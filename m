From: Brian King <brking@us.ibm.com>
Subject: [PATCH] sg block layer tcqing fix
Date: Mon, 29 Dec 2003 14:29:35 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FF08EAF.9080708@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080406030005000005080300"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.105]:40422 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S265387AbTL2U3j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Dec 2003 15:29:39 -0500
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------080406030005000005080300
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

In bringing up a new LLD driver I am working on, I came across an oops 
related to sg and using the TCQ function provided by the block layer. 
The backtrace is shown below. I did some poking around and it looks like 
when doing SG_IO ioctls to devices running blk tagged command queuing, 
blk_queue_start_tag gets called, but blk_queue_end_tag never does. 
Attached is a patch against 2.6.0 which adds the call in sg_cmd_done and 
gets rid of the oops for me. Please apply.


-Brian


Unable to handle kernel paging request at virtual address
c5580e8c
  printing eip:
c02eacf8
*pde = 00016067
*pte = 05580000
Oops: 0002 [#1]
CPU:    1
EIP:    0060:[<c02eacf8>]    Not tainted
EFLAGS: 00010046
EIP is at blk_queue_start_tag+0x68/0x100
eax: c5580e88   ebx: 00000001   ecx: 00000000   edx: cb1884d0
esi: c5760e88   edi: cb1884c8   ebp: cb18849c   esp: c5dc3cd8
ds: 007b   es: 007b   ss: 0068
Process iprconfig (pid: 1511, threadinfo=c5dc2000 task=c642b9b0)
Stack: cdc12df8 c6442000 c02e9d3e cdc12df8 00000002 c899dbf8 c5760e88 
c6442000
        c03269dc cdc12df8 c5760e88 cdc12f58 c899dd84 c10da700 cdc12df8 
c5760e88
        cdc12df8 c02e9c29 00000002 c5760e88 cdc12df8 00000202 c02ec6a1 
cdc12df8
Call Trace:
  [<c02e9d3e>] elv_next_request+0x4e/0x100
  [<c03269dc>] scsi_request_fn+0x46c/0x4b0
  [<c02e9c29>] __elv_add_request+0x29/0x40
  [<c02ec6a1>] blk_insert_request+0x91/0x110
  [<c032525e>] scsi_do_req+0x4e/0xa0
  [<c032515a>] scsi_insert_special_req+0x3a/0x40
  [<c0350d18>] sg_common_write+0x168/0x1c0
  [<c0352060>] sg_cmd_done+0x0/0x250
  [<c0350b34>] sg_new_write+0x1f4/0x270
  [<c03519cf>] sg_ioctl+0xc5f/0xe50
  [<c01468af>] __get_free_pages+0x1f/0x50
  [<c0354190>] sg_page_malloc+0x40/0x100
  [<c0352dce>] sg_build_indirect+0x5e/0x1f0
  [<c03539a9>] sg_build_reserve+0x39/0x60
  [<c0353f2b>] sg_add_sfp+0xeb/0x120
  [<c034ff66>] sg_open+0x186/0x260
  [<c0165dcf>] get_empty_filp+0x4f/0x100
  [<c0170193>] chrdev_open+0x123/0x310
  [<c011e8f0>] default_wake_function+0x0/0x20
  [<c017a95b>] sys_ioctl+0x13b/0x2f7
  [<c016425e>] sys_open+0x7e/0x90
  [<c010996f>] syscall_call+0x7/0xb

Code: 89 70 04 89 06 31 c0 89 56 04 ff 47 10 89 77 08 83 c4 10 5b



-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

--------------080406030005000005080300
Content-Type: text/plain;
 name="sg_tcq.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sg_tcq.patch"

diff -Naur linux-2.6.0/drivers/scsi/sg.c linux-2.6.0-sg/drivers/scsi/sg.c
--- linux-2.6.0/drivers/scsi/sg.c	Mon Dec  8 11:10:40 2003
+++ linux-2.6.0-sg/drivers/scsi/sg.c	Mon Dec 29 13:03:35 2003
@@ -1219,6 +1219,8 @@
 	Sg_device *sdp = NULL;
 	Sg_fd *sfp;
 	Sg_request *srp = NULL;
+	request_queue_t *q;
+	unsigned long flags = 0;
 
 	if (SCpnt && (SRpnt = SCpnt->sc_request))
 		srp = (Sg_request *) SRpnt->upper_private_data;
@@ -1284,6 +1286,12 @@
 	}
 	/* Rely on write phase to clean out srp status values, so no "else" */
 
+	q = SRpnt->sr_device->request_queue;
+	spin_lock_irqsave(q->queue_lock, flags);
+	if (blk_rq_tagged(SRpnt->sr_request))
+		blk_queue_end_tag(q, SRpnt->sr_request);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+
 	scsi_release_request(SRpnt);
 	SRpnt = NULL;
 	if (sfp->closed) {	/* whoops this fd already released, cleanup */

--------------080406030005000005080300--

