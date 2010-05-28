From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16058] [BUG] Cannot boot any kernel from 2.6.27 on if a 256
 byte sector SCSI disk is attached
Date: Fri, 28 May 2010 14:58:57 GMT
Message-ID: <201005281458.o4SEwv44023397@demeter.kernel.org>
References: <bug-16058-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:35663 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab0E1O66 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 May 2010 10:58:58 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4SEwvZp023398
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 28 May 2010 14:58:57 GMT
In-Reply-To: <bug-16058-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16058





--- Comment #4 from Alan Stern <stern@rowland.harvard.edu>  2010-05-28 14:58:55 ---
On Fri, 28 May 2010, Mark Hounschell wrote:

> First READ(10):
> 
>  sde:
> ahc_calc_residual: Entered
> ahc_calc_residual: return Case 5-1 resid = 0x800
> ahc_calc_residual: return Case 5-2 resid = 0x800
> 
> scsi_finish_command: Entered for cmd(10):0x28 0x00 0x00 0x00 0x00 0x00
> 0x00 0x00 0x08 0x00
> cmd->result = 0x00000000
> good_bytes == old_good_bytes = 0x800  scsi_get_resid(cmd) = 0x800
> New good_bytes = 0x0
> scsi_finish_command: Complete
> 
> From here it just keeps repeating this read of 8 blocks. (2048 bytes) so
> it looks like the machine is hung.

Probably not hung, just doing a lot of retries.  It should time out 
eventually, but it might take a long time (perhaps as long as 15 
minutes).  The combination of the block layer and the SCSI layer isn't 
very good at knowing when to give up.

> Now, I know for a fact that _if_ this read CDB is actually being sent to
> the drive, it's actual residual count will be zero. These are working
> disks and that read CDB is valid.
> 
> Why is ahc_calc_residual saying that the residual count is as though the
> read never took place? I noticed that the first read on all the SATA
> drives was for 4096 bytes, why is this one only 2048? Should it have
> been 4096 and ahc_calc_residual assume that?

I don't know the answer to any of these questions.  They could well be
due to bugs in the driver, and I know nothing about how the aic7xxx
driver works.  You should talk to someone who does.

In the meantime, you can track this down a little farther by adding
printk's to the appropriate places in drivers/scsi/sd.c.  Look at
sd_prep_fn() to see why there's 2048 bytes instead of 4096.

Alan Stern

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
