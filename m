From: Brian King <brking@us.ibm.com>
Subject: Re: PROBLEM: Oops in 2.6.3 with lots of SG_IO activity
Date: Thu, 18 Mar 2004 15:48:20 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <405A1924.10303@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050906020205040502080408"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:5113 "EHLO e33.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S262980AbUCRVtF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Mar 2004 16:49:05 -0500
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, dougg@torque.net

This is a multi-part message in MIME format.
--------------050906020205040502080408
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

James,

Attached is a patch to fix an oops in sg_cmd_done. Please apply.

Thanks

-Brian


-------- Original Message --------
Subject: Re: PROBLEM: Oops in 2.6.3 with lots of SG_IO activity
Date: Wed, 10 Mar 2004 10:24:39 -0600
From: Brian King <brking@us.ibm.com>
To: dougg@torque.net
CC: James.Bottomley@steeleye.com,  tonyb@cybernetics.com
References: <40478DD3.10807@us.ibm.com> <404B1C79.4060600@torque.net> <404CD74A.1090301@us.ibm.com> 
<404F3133.7060200@torque.net>

Douglas Gilbert wrote:

 > Brian,
 > Thanks for this test code. I don't follow the "run disk exercisers" bit.
 > BTW iprinit seg faulted when the sg module wasn't loaded
 >
 > Your patch widens the srp->done window and re-orders kill_fasync()
 > and wake_up_interruptible(). Are they both needed? If not which one
 > is critical?

I need both for my testcase to run clean. sg_cmd_done cannot touch sfp
once srp->done is set.

 > Anyway I'm happy to go ahead with the patch (posted by you a little
 > while later on the lsml). Having just moved accommodation my
 > equipment still needs more setting up. I have a sym53c8xx HBA.

Thanks. Once again, here is the patch. James, please apply.


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

--------------050906020205040502080408
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


--------------050906020205040502080408--

