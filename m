From: Brian King <brking@us.ibm.com>
Subject: Re: PROBLEM: Oops in 2.6.3 with lots of SG_IO activity - [PATCH]
Date: Mon, 08 Mar 2004 16:01:00 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <404CED1C.8010603@us.ibm.com>
References: <40478DD3.10807@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010004000904080503000603"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.105]:46013 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261340AbUCHWBk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Mar 2004 17:01:40 -0500
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------010004000904080503000603
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Attached is a patch which seems to fix the oops for me. Without the patch
I can consistently reproduce the oops in just a couple minutes. With the
patch I have been running for close to an hour without problems so far.
Doug, does this look ok? I'm going to let my testcase run overnight as well
and will post the results tomorrow.


> I have been experiencing occasional oopses in some testing I have been
> doing and have recently been able to aggravate the problem to recreate
> the oops quite quickly. If I do lots of overlapped SG_IO ioctls while
> also doing heavy disk I/O, I can recreate the oops within a few minutes,
> although I have also seen the problem under very little load. I have
> seen the problem using both the ipr and sym2 drivers.


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

--------------010004000904080503000603
Content-Type: text/plain;
 name="sg_cmd_done_oops.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sg_cmd_done_oops.patch"


The patch fixes a race condition in sg_cmd_done that results in an oops.


---


diff -puN drivers/scsi/sg.c~sg_cmd_done_oops drivers/scsi/sg.c
--- linux-2.6.4-rc2/drivers/scsi/sg.c~sg_cmd_done_oops	2004-03-06 22:08:45.000000000 -0600
+++ linux-2.6.4-rc2-brking/drivers/scsi/sg.c	2004-03-06 22:55:12.000000000 -0600
@@ -1256,7 +1256,6 @@ sg_cmd_done(Scsi_Cmnd * SCpnt)
 	SRpnt->sr_request->rq_disk = NULL; /* "sg" _disowns_ request blk */
 
 	srp->my_cmdp = NULL;
-	srp->done = 1;
 
 	SCSI_LOG_TIMEOUT(4, printk("sg_cmd_done: %s, pack_id=%d, res=0x%x\n",
 		sdp->disk->disk_name, srp->header.pack_id, (int) SRpnt->sr_result));
@@ -1312,8 +1311,9 @@ sg_cmd_done(Scsi_Cmnd * SCpnt)
 	}
 	if (sfp && srp) {
 		/* Now wake up any sg_read() that is waiting for this packet. */
-		wake_up_interruptible(&sfp->read_wait);
 		kill_fasync(&sfp->async_qp, SIGPOLL, POLL_IN);
+		srp->done = 1;
+		wake_up_interruptible(&sfp->read_wait);
 	}
 }
 

_

--------------010004000904080503000603--

