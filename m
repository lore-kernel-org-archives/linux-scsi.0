From: Gorazd Golob <gorazd.golob@noviforum.si>
Subject: Re: Fw: [Bugme-new] [Bug 6052] New: Megaraid file corruption and
	performance degradation on x86_64 with 8G RAM
Date: Fri, 10 Feb 2006 21:04:36 +0100
Message-ID: <1139601876.10214.14.camel@dacun.noviforum.si>
References: <20060210112640.4637dfdb.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from elfstone.noviforum.si ([193.189.169.107]:36744 "EHLO
	elfstone.noviforum.si") by vger.kernel.org with ESMTP
	id S1751365AbWBJUEi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Feb 2006 15:04:38 -0500
Received: from localhost (localhost [127.0.0.1])
	by elfstone.noviforum.si (ESMTP) with ESMTP id CFAED1B913
	for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2006 21:02:33 +0100 (CET)
Received: from dacun.noviforum.si (dacun.noviforum.si [192.168.2.26])
	by elfstone.noviforum.si (ESMTP) with ESMTP id AA43D1B912
	for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2006 21:02:33 +0100 (CET)
In-Reply-To: <20060210112640.4637dfdb.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Switching off the directio in megaraid's setup to cacheio should help.
It's controller's (32bit) problem not drivers.


On Fri, 2006-02-10 at 11:26 -0800, Andrew Morton wrote:
> 
> Begin forwarded message:
> 
> Date: Fri, 10 Feb 2006 10:19:45 -0800
> From: bugme-daemon@bugzilla.kernel.org
> To: bugme-new@lists.osdl.org
> Subject: [Bugme-new] [Bug 6052] New: Megaraid file corruption and performance degradation on x86_64 with 8G RAM
> 
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=6052
> 
>            Summary: Megaraid file corruption and performance degradation on
>                     x86_64 with 8G RAM
>     Kernel Version: 2.6.15-1.2005_FC4smp
>             Status: NEW
>           Severity: normal
>              Owner: andmike@us.ibm.com
>          Submitter: bloch@verdurin.com
> 
> 
> Most recent kernel where this bug did not occur:
> Distribution: 
> Fedora Core 4
> 
> Hardware Environment: 
> 
> Tyan S2882
> 2 x Opteron 252
> 8G RAM
> LSI MegaRAID SATA 150-4
> 
> Software Environment:
> 
> Problem Description:
> 
> A RAID1 mirror was setup using the MegaRAID card and 2 x 250 GB drives.
> After only a day or so of use, there was severe filesystem corruption (using
> ext3) and the user complained that even before the corruption it was incredibly
> slow (the mirror is used to house $HOME).
> 
> We have other machines here with only 4G RAM using the same card and setup. 
> Performance there is fine and there's been no filesystem corruption.
> 
> In one case I removed the drives from the card and connected them to the SATA
> ports on the motherboard, using software RAID.  That machine is working fine.
> 
> In the other case I have tried using a Fedora test kernel, equivalent to
> 2.6.16-rc2, which has the latest version of the MegaRAID driver (2.20.4.7).
> I was unable to recover the filesystem on the original partition when running
> fsck using the new kernel.  However, at least on this occasion fsck kept running
> (for two days...) instead of crashing.
> 
> When running mkfs on the hardware RAID1 mirror, performance still seems to be
> very slow.
> 
> Hence it appears there is a specific problem with the LSI megaraid driver on
> x86_64 machines with more than 4G RAM.
> 
> Steps to reproduce:
> 
> ------- You are receiving this mail because: -------
> You are on the CC list for the bug, or are watching someone who is.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

