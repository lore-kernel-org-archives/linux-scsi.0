From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 7919] New: Tape dies if wrong block size used
Date: Thu, 1 Feb 2007 16:08:58 -0800
Message-ID: <20070201160858.ef28f354.akpm@osdl.org>
References: <200702012334.l11NYTWu010618@fire-2.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50930 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422965AbXBBAJM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Feb 2007 19:09:12 -0500
In-Reply-To: <200702012334.l11NYTWu010618@fire-2.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>, dmartin@sccd.ctc.edu

On Thu, 1 Feb 2007 15:34:29 -0800
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=7919
> 
>            Summary: Tape dies if wrong block size used
>     Kernel Version: 2.6.20-rc5
>             Status: NEW
>           Severity: normal
>              Owner: scsi_drivers-other@kernel-bugs.osdl.org
>          Submitter: dmartin@sccd.ctc.edu
> 
> 
> Most recent kernel where this bug did *NOT* occur: 2.6.17.14
> 
> Other Kernels Tested and Results:
> 
>     OK 2.6.15.7
>     OK 2.6.16.37 
>     OK 2.6.17.14 
>     BAD 2.6.18.6
>     BAD 2.6.18-1.2869.fc6
>     BAD 2.6.19.2 +
>     BAD 2.6.20-rc5
> 
> NOTE: 2.6.18-1.2869.fc6 is a Fedora modified kernel, all others are from kernel.org
> 
> Distribution: Fedora 
> Hardware Environment: i386
>   Arch    I386 
>   Model    Dell Poweredge 1300 
>   Processor    Pentium III (Coppermine) 697.929 Mhz. 
>   SCSI    Adaptec AHA-2940U/UW/D / AIC-7881U 
>   Disks    3 QUANTUM ATLAS V 9 WLS in RAID 5 software raid attached to adaptech
>                card above 
>   Tape    HP C1537A attached to adaptech card above
> 
> Software Environment: tar and mt
> 
> Problem Description: 
> 
> I usually specify a tape block size, such as 'mt setblk 4096'. If I access the
> tape drive with the wrong tape block size, for instance 'tar -cvf /dev/tape
> foo', the screen fills with kernel errors. If I use the correct block size, as
> in 'tar -b 8 -cvf /dev/tape foo', it works fine. If I use the wrong block size I
> have to reboot to make the tape drive respond again.
> 
> I've seen this problem on three systems with identical SCSI cards and different
> tape drives, so that makes me think it's the AIC7XXX driver. I've tested with
> several kernels to try and isolate when this problem was introduced. More
> details below.
> 
> Interestingly, my main testing system is running software raid from the same
> scsi card with no problems, so this seems specific to tape drives. The other
> machine I've seen this on had a separate raid card, so you can't blame it on my
> software raid setup.
> 
> Steps to reproduce: 
> Get a Adaptec AHA-2940U/UW/D / AIC-7881U card and a tape drive,
> install a recent kernel
> set the tape block size - mt setblk 4096
> read from or write to tape using wrong block size - tar -b 7 -cvf /dev/tape foo
> 
> ------- You are receiving this mail because: -------
> You are on the CC list for the bug, or are watching someone who is.
