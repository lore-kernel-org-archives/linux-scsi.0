From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 12020] New: scsi_times_out NULL pointer dereference
Date: Thu, 13 Nov 2008 13:03:30 -0600
Message-ID: <1226603010.3537.18.camel@localhost.localdomain>
References: <bug-12020-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:39184 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751345AbYKMTDe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2008 14:03:34 -0500
In-Reply-To: <bug-12020-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org, Jens Axboe <Jens.Axboe@oracle.com>

On Thu, 2008-11-13 at 10:30 -0800, bugme-daemon@bugzilla.kernel.org
wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=12020
> 
>            Summary: scsi_times_out NULL pointer dereference
>            Product: SCSI Drivers
>            Version: 2.5
>      KernelVersion: 2.6.28-git20081113
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>         AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
>         ReportedBy: bs@q-leap.de
> 
> 
> Latest working kernel version: 2.6.27
> Earliest failing kernel version: 2.6.28-rc4
> Hardware Environment: Infortrend G2430 connected to LSI22320R
> Problem Description:
> 
> Hello,
> 
> first in 2.6.28-rc{1,2,3} the error handler was entirely broken - it
> deadlocked. In rc4 this is fixed, but now I already two times got a Null
> pointer dereference while doing some error handler tests. All of that looks
> like due to the scsi timeout commits.
> 
> Steps to reproduce: E.g. reset devices connected to LSI 53C1030 devices using
> lsiutil. Can be reproduced on about 20% eh activations.
> 
> (gdb) l *(scsi_times_out+0x15)
> 0xffffffff80460f1e is in scsi_times_out (drivers/scsi/scsi_error.c:176).
> 171             enum blk_eh_timer_return (*eh_timed_out)(struct scsi_cmnd *);
> 172             enum blk_eh_timer_return rtn = BLK_EH_NOT_HANDLED;
> 173
> 174             scsi_log_completion(scmd, TIMEOUT_ERROR);
> 175
> 176             if (scmd->device->host->transportt->eh_timed_out)
> 177                     eh_timed_out =
> scmd->device->host->transportt->eh_timed_out;
> 178             else if (scmd->device->host->hostt->eh_timed_out)
> 179                     eh_timed_out = scmd->device->host->hostt->eh_timed_out;
> 180             else

Actually, I think the trace is slightly off.  I suspect this is the
problem:

	struct scsi_cmnd *scmd = req->special;

I bet req->special is NULL because the command timed out even before it
was prepared by the subsystem.

Does this fix it?

The fix is more of a bandaid than anything ... we can't really have
commands timing out in the mid-layer because we expect we have full
control of them.  With this patch, if we run out of resets, block will
complete a command we're still processing.

James

---

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 94ed262..5612c42 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -127,6 +127,13 @@ enum blk_eh_timer_return scsi_times_out(struct request *req)
 	enum blk_eh_timer_return (*eh_timed_out)(struct scsi_cmnd *);
 	enum blk_eh_timer_return rtn = BLK_EH_NOT_HANDLED;
 
+	if (!scmd)
+		/*
+		 * nasty: command timed out before the mid layer
+		 * even prepared it
+		 */
+		return BLK_EH_RESET_TIMER;
+
 	scsi_log_completion(scmd, TIMEOUT_ERROR);
 
 	if (scmd->device->host->transportt->eh_timed_out)


