From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: WRITE BUFFER commands through SG_IO getting rounded up to sector
 past 32k
Date: Tue, 06 Mar 2007 18:39:02 -0600
Message-ID: <45EE09A6.7030004@cs.wisc.edu>
References: <45EE00F0.2010702@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060401090207010109010408"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:50876 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161028AbXCGAjK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Mar 2007 19:39:10 -0500
In-Reply-To: <45EE00F0.2010702@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aravind Parchuri <aravind.parchuri@gmail.com>
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------060401090207010109010408
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Aravind Parchuri wrote:
> In fact, even with the newer kernel, all commands smaller than 32k make
> it through with the right size, which leads me to think it's something
> to do with the scatter-gather list. I'm not particularly familiar with
> the scsi code, but inside scsi_execute_async, in scsi_map_req_sg, should
> the request's data_len be set to the dxfer_len instead of summing up the
> scatter-gather list lengths? I must mention again that I haven't really
> gone through the code thoroughly.
> 

You are right. sg_build_indirect will do this
blk_size = (blk_size + SG_SECTOR_MSK) & (~SG_SECTOR_MSK)
so we should be using the bufflen passed into us. Attached is a patch
made over scsi-misc. It should also apply to scsi rc fixes.

--------------060401090207010109010408
Content-Type: text/x-patch;
 name="use-bufflen-for-data-len.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="use-bufflen-for-data-len.patch"

sg's may have setup a the buffer with a different length than
the transfer length so we should be using the bufflen passed
in as the request's data len.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9f7482d..dfe3ccd 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -301,7 +301,7 @@ static int scsi_req_map_sg(struct reques
 {
 	struct request_queue *q = rq->q;
 	int nr_pages = (bufflen + sgl[0].offset + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	unsigned int data_len = 0, len, bytes, off;
+	unsigned int len, bytes, off;
 	struct page *page;
 	struct bio *bio = NULL;
 	int i, err, nr_vecs = 0;
@@ -310,7 +310,6 @@ static int scsi_req_map_sg(struct reques
 		page = sgl[i].page;
 		off = sgl[i].offset;
 		len = sgl[i].length;
-		data_len += len;
 
 		while (len > 0) {
 			bytes = min_t(unsigned int, len, PAGE_SIZE - off);
@@ -350,7 +349,7 @@ static int scsi_req_map_sg(struct reques
 	}
 
 	rq->buffer = rq->data = NULL;
-	rq->data_len = data_len;
+	rq->data_len = bufflen;
 	return 0;
 
 free_bios:

--------------060401090207010109010408--
