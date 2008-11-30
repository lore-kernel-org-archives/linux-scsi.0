From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12120] [Block layer or SCSI] requests aborted too early during check_partition()
Date: Sun, 30 Nov 2008 01:44:10 -0800 (PST)
Message-ID: <20081130094410.E2690108041@picon.linux-foundation.org>
References: <bug-12120-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58431 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750962AbYK3JoN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Nov 2008 04:44:13 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mAU9iAji015916
	for <linux-scsi@vger.kernel.org>; Sun, 30 Nov 2008 01:44:11 -0800
In-Reply-To: <bug-12120-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12120





------- Comment #9 from anonymous@kernel-bugs.osdl.org  2008-11-30 01:44 -------
Reply-To: stefanr@s5r6.in-berlin.de

James Bottomley wrote:
> Theory number two is a block timeout cockup.  It looks like
> sdev->timeout is vestigial and has zero value, so we shouldn't be using
> it in the start command, so try this.
> 
> If this works, the correct fix will be to kill the sdev timeout
> parameter so we get a compile failure where anything tries to use it.
> 
> James
> 
> ---
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 3863617..de3f6d0 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -933,7 +933,7 @@ static int scsi_eh_try_stu(struct scsi_cmnd *scmd)
>  
>  		for (i = 0; rtn == NEEDS_RETRY && i < 2; i++)
>  			rtn = scsi_send_eh_cmnd(scmd, stu_command, 6,
> -						scmd->device->timeout, 0);
> +						3*SENSE_TIMEOUT, 0);
>  
>  		if (rtn == SUCCESS)
>  			return 0;
> 
> 

Yes, this works with all of the SBP-2 bridges here which exhibit this
false TEST UNIT READY "GOOD" status.

BTW, 3 * SENSE_TIMEOUT == 30 seconds may actually be a little bit narrow
as a START UNIT timeout.  The disks which I tested here --- a few 7200
RPM IDE or SATA disks behind the SBP-2 bridges --- usually take about 7
seconds to spin up in single-disk enclosures and 14 seconds in dual-disk
enclosures, since the bridge spins them up serially.  But a dual-disk
enclosure with Hitachi Deskstar 7K400 took 28 seconds.  Maybe this
should be used in scsi_eh_try_stu:
include/scsi/scsi.h:#define START_STOP_TIMEOUT          (60 * HZ)

Thanks a lot,


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
