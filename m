From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [Bug 9775]  HOST_MSG_LOOP invalid SCB ff
Date: Fri, 18 Jan 2008 16:27:47 -0600
Message-ID: <1200695267.3111.65.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:38419 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932501AbYARW1w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jan 2008 17:27:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Cc: linux-scsi <linux-scsi@vger.kernel.org>


> Latest working kernel version:
> Earliest failing kernel version: 
> Distribution: Gentoo
> Hardware Environment: ML150G3, (2Core cpu, 64Bit)  AHA3944AUWD card, Storagetek
> L80 +2x DLT8000
> Software Environment: gentoo
> Problem Description: kernel panic 
> 
> Steps to reproduce:
> Panic if the L80 is powered up when the kernel boots. 100% on any failing
> kernel.
> Not all kernels fail but most do.
> Git Bisect across linus's tree did not produce a convincing patch.
> Originally filed here: http://bugs.gentoo.org/show_bug.cgi?id=200708
> I have joined the linux-scsi list and will
> 
> The event that brought the problem to light was the installation of a
> secondhand Storagetek L80
> tape library. This has two DLT8000 drives on a HV-Differential bus.
> This needed special card, an adaptec 3944AUWD.
> The kernel I was running at that time was 2.6.22-gentoo-r8.
> It worked fine. Then when -r9 came out and this error manifested, the
> assumption
> was that -r9 was broken.
> 
> I no longer think this to be the case.
> 
> I think they are _ALL_ broken, possibly going way back toward the start of the
> 2.6 series.
> I think that the bug may or may not manifest depending on the internal layout
> of data in the kernel
> --A true heisenbug--
> 
> All that the git bisect did was to change the internal layout, not add/remove a
> bad patch.
> 
> This explains why I could take the 2.6.23.8 kernel and compile for SMP and have
> it fail.
> Compile it for UP and have it work. Initially I thought that meant a locking or
> race issue.
> Now I think its was just another case of altering the internal kernel layout.

Actually, I'd investigate either your tapes or the SCSI bus.

The message is produced deep in the heart of the aic7xxx driver.  It
happens when the driver gets reselected with a tag that doesn't exist.
However, in this case, I think your device is untagged, in which case
this is some handling issue with SCB_LIST_NULL (the value 0xff).

James


