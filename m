From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: device_suspend() levels [was Re: [patch] ACPI work on aic7xxx]
Date: Tue, 27 Jul 2004 21:16:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1090977414.18239.28.camel@gaston>
References: <40FD38A0.3000603@optonline.net>
	 <20040720155928.GC10921@atrey.karlin.mff.cuni.cz>
	 <40FD4CFA.6070603@optonline.net>
	 <20040720174611.GI10921@atrey.karlin.mff.cuni.cz>
	 <40FD6002.4070206@optonline.net> <1090347939.1993.7.camel@gaston>
	 <40FD65C2.7060408@optonline.net> <1090350609.2003.9.camel@gaston>
	 <40FD82B1.8030704@optonline.net> <1090356079.1993.12.camel@gaston>
	 <40FD85A3.2060502@optonline.net> <1090357324.1993.15.camel@gaston>
	 <410280E9.5040001@optonline.net> <1090684826.1963.6.camel@gaston>
	 <41029215.1030406@optonline.net> <1090694118.1971.13.camel@gaston>
	 <4102FC9D.1060100@optonline.net> <1090793440.1987.2.camel@gaston>
	 <41050EEA.5040107@optonline.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:36570 "EHLO gate.crashing.org")
	by vger.kernel.org with ESMTP id S266749AbUG1BXO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jul 2004 21:23:14 -0400
In-Reply-To: <41050EEA.5040107@optonline.net>
List-Id: linux-scsi@vger.kernel.org
To: Nathan Bryant <nbryant@optonline.net>
Cc: linux-scsi@vger.kernel.org, Pavel Machek <pavel@ucw.cz>


> For suspend/resume and also initialization on bootup. We're not saving 
> the chip state for PIIX so I assume we're hoping that ACPI does it for us

ah, that part, yes, well, we hope ;) though it may just come back up
in the right state for normal PIO access, and we do restore the DMA
state by calling dma_check again in the ide-disk wakeup code.

> > We need to issue the stuff from the low level driver (like aix7xxx) or
> > the disk, that is sd, but we should make sure sg etc... also properly
> > call the stuff, actually, look at IDE, I defined the special power
> > request to act as a state machine once down the queue so the ide layer
> > acts differently for disks, cdroms, etc... by sending appropriate
> > commands like standby for disks.
> 
> There's another one - synchronize cache or disable write back cache on 
> the drive....

Yes, whatever. STANDBYNOW1 is enough on IDE (it does sync. the cache),
though I don't think we "restore" the state of the write back cache,
so that could be a good idea to add too :)

Ben
 

