From: Michael Reed <mdr@sgi.com>
Subject: [PATCH] 2.6.25-rc4-git3 - inquiry cmd issued via /dev/sg? device
 causes infinite loop in 2.6.24
Date: Tue, 11 Mar 2008 17:10:39 -0500
Message-ID: <47D7035F.5000700@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay2.sgi.com ([192.48.171.30]:36816 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751701AbYCKWKn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Mar 2008 18:10:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Jeremy Higdon <jeremy@sgi.com>, James Bottomley <James.Bottomley@SteelEye.com>

Note: description below applies to 2.6.24 as that's what was used to
isolate the problem being described.  There are comments at the end
with regard to 2.6.25-rc4-git3.  The below email thread directly 
applies to this bug/patch.

http://marc.info/?l=linux-scsi&m=120222578814366&w=2

--

While performing raid reset testing using 2.6.24, every once in the
while I noticed that one of the raid's management tools would not exit.
I tracked this down to it waiting on an inquiry command's completion.

An infinite loop occurs because there is an occasional inquiry
command submitted to the host driver with the associated bio
having a bi_size field of 512 when the inquiry command's transfer
length is 255.  This "enlarged" bi_size field causes the completion
handler to re-issue the inquiry command because there are "leftovers"
following the completion.

scsi_finish_command() calls scsi_io_completion() with
good_bytes equal to cmd->request_bufflen.

scsi_io_completion() sets req->data_len to the residual provided
by the LLDD.

scsi_io_completion() calls scsi_end_request() with the good_bytes
value of 255.

scsi_end_request() calls end_that_request_chunk() which calls
__end_that_request_first() which uses bio->bi_size as the size of
the request.  As bi_size is larger than the number of bytes (nr_bytes)
being completed, it returns "1" indicating that there wasn't enough
data to finish the request.

scsi_end_request() then calls scsi_requeue_command() to resubmit and
fetch that data which wasn't received.  This results in the
command being reissued using the residual value returned by
the driver as the request_bufflen for the next command.

This repeats itself until the residual is zero and bi_size is
non-zero at which point the command gets reissued with a 
request_bufflen of zero and sc_data_direction of DMA_NONE.
The subsequent completions are retried infinitely because
bi_size is still non-zero.

What drove me crazy is that this didn't happen with every inquiry
command issued by the application.  It was very infrequent.
I finally tracked it down to the sg driver.

sg_ioctl() calls sg_new_write() which calls sg_common_write()
which calls sg_start_req().

sg_start_req() either calls sg_link_reserve() or sg_build_indirect()
to set up the data transfer.  The call to sg_build_indirect()
ROUNDS UP THE REQUEST SIZE to a sector boundary, and this is what
causes the infinite loop.

I tried removing the round up statement in sg_build_indirect()
and forcing sg_start_req() to always call sg_build_indirect()
to test the change and the infinite loop did not occur.

To me, it seems that if sg_link_reserve() has no need to round up
to a sector boundary then sg_build_indirect() should also not need
to round up the request length.

I've included a patch (against 2.6.25-rc4-git3) which removes the
rounding in sg_build_indirect() for your comments.

I then tried my test case with 2.6.25-rc4-git3 and it didn't happen.
I noticed the change in the routine scsi_req_map_sg() which
deletes a line which incremented the "data_len" variable at the start
of the for_each_sg() loop.  This was also a line which I examined in 6.5.24.
But, I noticed comments about sg indicating that it "sends a scatterlist
that is larger than the data_len it wants transferred for certain
IO sizes", and as that appeared to be what was happening, I went in
search of what was up with sg.

So, will the below patch break anything?

Signed-off-by: Michael Reed <mdr@sgi.com>


--- linux-2.6.25-rc4-git3/drivers/scsi/sg.c	2008-03-10 13:21:06.000000000 -0700
+++ linux-2.6.25-rc4-git3-modified/drivers/scsi/sg.c	2008-03-11 14:47:32.376281307 -0700
@@ -1829,17 +1829,13 @@
 	struct scatterlist *sg;
 	int ret_sz = 0, k, rem_sz, num, mx_sc_elems;
 	int sg_tablesize = sfp->parentdp->sg_tablesize;
-	int blk_size = buff_size;
 	struct page *p = NULL;
 
-	if (blk_size < 0)
+	if (buff_size < 0)
 		return -EFAULT;
-	if (0 == blk_size)
-		++blk_size;	/* don't know why */
-/* round request up to next highest SG_SECTOR_SZ byte boundary */
-	blk_size = (blk_size + SG_SECTOR_MSK) & (~SG_SECTOR_MSK);
-	SCSI_LOG_TIMEOUT(4, printk("sg_build_indirect: buff_size=%d, blk_size=%d\n",
-				   buff_size, blk_size));
+
+	SCSI_LOG_TIMEOUT(4, printk("sg_build_indirect: buff_size=%d\n",
+				   buff_size));
 
 	/* N.B. ret_sz carried into this block ... */
 	mx_sc_elems = sg_build_sgat(schp, sfp, sg_tablesize);
@@ -1854,7 +1850,7 @@
 		} else
 			scatter_elem_sz_prev = num;
 	}
-	for (k = 0, sg = schp->buffer, rem_sz = blk_size;
+	for (k = 0, sg = schp->buffer, rem_sz = buff_size;
 	     (rem_sz > 0) && (k < mx_sc_elems);
 	     ++k, rem_sz -= ret_sz, sg = sg_next(sg)) {
 		
@@ -1880,7 +1876,7 @@
 	SCSI_LOG_TIMEOUT(5, printk("sg_build_indirect: k_use_sg=%d, "
 			 "rem_sz=%d\n", k, rem_sz));
 
-	schp->bufflen = blk_size;
+	schp->bufflen = buff_size;
 	if (rem_sz > 0)	/* must have failed */
 		return -ENOMEM;
 
