From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12020] scsi_times_out NULL pointer dereference
Date: Thu, 13 Nov 2008 11:03:42 -0800 (PST)
Message-ID: <20081113190342.2EB6611D107@picon.linux-foundation.org>
References: <bug-12020-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37096 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751886AbYKMTDw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2008 14:03:52 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mADJ3g3p005496
	for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2008 11:03:43 -0800
In-Reply-To: <bug-12020-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12020





------- Comment #1 from anonymous@kernel-bugs.osdl.org  2008-11-13 11:03 -------
Reply-To: James.Bottomley@HansenPartnership.com

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
@@ -127,6 +127,13 @@ enum blk_eh_timer_return scsi_times_out(struct request
*req)
        enum blk_eh_timer_return (*eh_timed_out)(struct scsi_cmnd *);
        enum blk_eh_timer_return rtn = BLK_EH_NOT_HANDLED;

+       if (!scmd)
+               /*
+                * nasty: command timed out before the mid layer
+                * even prepared it
+                */
+               return BLK_EH_RESET_TIMER;
+
        scsi_log_completion(scmd, TIMEOUT_ERROR);

        if (scmd->device->host->transportt->eh_timed_out)


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
