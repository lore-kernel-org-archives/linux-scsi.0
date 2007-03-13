From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: WRITE BUFFER commands through SG_IO getting rounded up to sector
 past 32k
Date: Tue, 13 Mar 2007 12:52:29 -0500
Message-ID: <45F6E4DD.30400@cs.wisc.edu>
References: <45EE00F0.2010702@gmail.com> <45EE09A6.7030004@cs.wisc.edu> <45F08737.3060100@gmail.com> <45F093E4.9060805@cs.wisc.edu> <45F1EFA2.9070800@gmail.com> <45F31C2D.7000401@cs.wisc.edu> <45F3573E.2040802@aim.com> <45F596BE.8030103@cs.wisc.edu> <45F5E91B.7000000@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040009040006080809050403"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:60867 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608AbXCMRwh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Mar 2007 13:52:37 -0400
In-Reply-To: <45F5E91B.7000000@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aravind Parchuri <aravind.parchuri@gmail.com>
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------040009040006080809050403
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Aravind Parchuri wrote:
> Command with 32896 bytes:
> 
> Mar 12 11:02:33 ITX000c292c3c8d kernel: iscsi: mgmtpdu [op 0x40 hdr->itt
> 0xffffffff datalen 0]
> Mar 12 11:02:33 ITX000c292c3c8d kernel: iscsi: mtask deq [cid 0 state 4
> itt 0xa05]
> Mar 12 11:03:03 ITX000c292c3c8d kernel: iscsi: mgmtpdu [op 0x40 hdr->itt
> 0xffffffff datalen 0]
> Mar 12 11:03:03 ITX000c292c3c8d kernel: iscsi: mtask deq [cid 0 state 4
> itt 0xa06]
> Mar 12 11:03:32 ITX000c292c3c8d kernel: iscsi: mgmtpdu [op 0x40 hdr->itt
> 0xffffffff datalen 0]
> Mar 12 11:03:32 ITX000c292c3c8d kernel: iscsi: mtask deq [cid 0 state 4
> itt 0xa07]
> Mar 12 11:04:02 ITX000c292c3c8d kernel: iscsi: mgmtpdu [op 0x40 hdr->itt
> 0xffffffff datalen 0]
> Mar 12 11:04:02 ITX000c292c3c8d kernel: iscsi: mtask deq [cid 0 state 4
> itt 0xa08]
> Mar 12 11:04:21 ITX000c292c3c8d kernel: sg_open: dev=0, flags=0x802
> Mar 12 11:04:21 ITX000c292c3c8d kernel: sg_add_sfp: sfp=0xcb554000
> Mar 12 11:04:21 ITX000c292c3c8d kernel: sg_build_reserve: req_size=32768
> Mar 12 11:04:21 ITX000c292c3c8d kernel: sg_build_indirect:
> buff_size=32768, blk_size=32768
> Mar 12 11:04:21 ITX000c292c3c8d kernel: sg_add_sfp:   bufflen=32768,
> k_use_sg=1
> Mar 12 11:04:21 ITX000c292c3c8d kernel: sg_ioctl: sg0, cmd=0x2285
> Mar 12 11:04:21 ITX000c292c3c8d kernel: sg_common_write:  scsi
> opcode=0x3b, cmd_size=10
> Mar 12 11:04:21 ITX000c292c3c8d kernel: sg_start_req: dxfer_len=32896
> Mar 12 11:04:21 ITX000c292c3c8d kernel: sg_build_indirect:
> buff_size=32896, blk_size=33280
> Mar 12 11:04:21 ITX000c292c3c8d kernel: sg_write_xfer: num_xfer=32896,
> iovec_count=0, k_use_sg=2
> Mar 12 11:04:21 ITX000c292c3c8d kernel: scsi 4:0:0:0: send 0xd7b16380
>                scsi 4:0:0:0:
> Mar 12 11:04:21 ITX000c292c3c8d kernel:         command: Write Buffer:
> 3b 01 01 00 00 00 00 80 80 00
> Mar 12 11:04:21 ITX000c292c3c8d kernel: buffer = 0xd7497c80, bufflen =
> 32896, done = 0xd8876a7b, queuecommand 0xd8a9de6e
> Mar 12 11:04:21 ITX000c292c3c8d kernel: iscsi: cmd [itt 0x3 total 32896
> imm_data 32896 unsol count 0, unsol offset 32896]
> Mar 12 11:04:21 ITX000c292c3c8d kernel: iscsi: ctask enq [write cid 0 sc
> d7b16380 cdb 0x3b itt 0x3 len 32896 cmdsn 4 win 257]
> Mar 12 11:04:21 ITX000c292c3c8d kernel: leaving scsi_dispatch_cmnd()
> Mar 12 11:04:21 ITX000c292c3c8d kernel: iscsi: ctask deq [cid 0 xmstate
> 2 itt 0x3]
> Mar 12 11:04:21 ITX000c292c3c8d kernel: iscsi: cmdrsp [op 0x21 cid 0 itt
> 0x3 len 0]
> Mar 12 11:04:21 ITX000c292c3c8d kernel: iscsi: done [sc d7b16380 res 0
> itt 0x3]
> Mar 12 11:04:21 ITX000c292c3c8d kernel: scsi 4:0:0:0: done 0xd7b16380
> SUCCESS        0 scsi 4:0:0:0:
> Mar 12 11:04:21 ITX000c292c3c8d kernel:         command: Write Buffer:
> 3b 01 01 00 00 00 00 80 80 00
> Mar 12 11:04:21 ITX000c292c3c8d kernel: scsi host busy 1 failed 0

The problem is that with the patch the difference between what got
rounded up and requested confuses the block and scsi layer and we try to
transfer difference forever.

When we hit this in scsi_end_request

        if (end_that_request_chunk(req, uptodate, bytes)) {

end_that_request_chunk will return 1

                int leftover = (req->hard_nr_sectors << 9);

                if (blk_pc_request(req))
                        leftover = req->data_len;


scsi_io_completion set req->data_len to scsi_cmnd->resid which was zero

                /* kill remainder if no retrys */
                if (!uptodate && blk_noretry_request(req))

uptodate is one
                        end_that_request_chunk(req, 0, leftover);
                else {
                        if (requeue) {

result equals zero so requeue equals one and so we requeue a command with

request->data_len == 0
request->bio == 1 (last bio has rounded up size of request - 32896)

The scsi layer will then continue to see a request with zero bytes and
the block layer will continue to see a little bit leftover.

                                /*
                                 * Bleah.  Leftovers again.  Stick the
                                 * leftovers in the front of the
                                 * queue, and goose the queue again.
                                 */
                                scsi_requeue_command(q, cmd);
                                cmd = NULL;
                        }
                        return cmd;
                }
        }


Try the attached patch.

--------------040009040006080809050403
Content-Type: text/x-patch;
 name="usebufflen.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="usebufflen.patch"

sg's may have setup a the buffer with a different length than
the transfer length so we should be using the bufflen passed
in as the request's data len.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>


diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 5f95570..30ae831 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -301,7 +301,7 @@ static int scsi_req_map_sg(struct reques
 {
 	struct request_queue *q = rq->q;
 	int nr_pages = (bufflen + sgl[0].offset + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	unsigned int data_len = 0, len, bytes, off;
+	unsigned int data_len = bufflen, len, bytes, off;
 	struct page *page;
 	struct bio *bio = NULL;
 	int i, err, nr_vecs = 0;
@@ -310,10 +310,15 @@ static int scsi_req_map_sg(struct reques
 		page = sgl[i].page;
 		off = sgl[i].offset;
 		len = sgl[i].length;
-		data_len += len;
 
-		while (len > 0) {
+		while (len > 0 && data_len > 0) {
+			/*
+			 * sg sends a scatterlist that is larger than
+			 * the data_len it wants transferred for certain
+			 * IO sizes
+			 */
 			bytes = min_t(unsigned int, len, PAGE_SIZE - off);
+			bytes = min(bytes, data_len);
 
 			if (!bio) {
 				nr_vecs = min_t(int, BIO_MAX_PAGES, nr_pages);
@@ -345,12 +350,13 @@ static int scsi_req_map_sg(struct reques
 
 			page++;
 			len -= bytes;
+			data_len -=bytes;
 			off = 0;
 		}
 	}
 
 	rq->buffer = rq->data = NULL;
-	rq->data_len = data_len;
+	rq->data_len = bufflen;
 	return 0;
 
 free_bios:

--------------040009040006080809050403--
