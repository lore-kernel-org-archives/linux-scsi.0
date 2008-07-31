From: Martin Samuelsson <sam@home.se>
Subject: Re: aacraid and S.M.A.R.T
Date: Thu, 31 Jul 2008 20:32:06 +0200
Message-ID: <20080731203206.f19fdcfd.sam@home.se>
References: <20080730235450.0fcc21a6.sam@home.se>
	<EC1C30B3-9ED0-4A8B-90FE-F4AB25FF5E7A@adaptec.com>
	<4891C69E.9000106@torque.net>
	<4F4EA7EA-60E1-4CDC-B03F-7FC2AD9980A7@adaptec.com>
	<20080731172715.0c37f999.sam@home.se>
	<4891FBA3.50703@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from proxy1.bredband.net ([195.54.101.71]:48403 "EHLO
	proxy1.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbYGaScK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jul 2008 14:32:10 -0400
Received: from ironport2.bredband.com (195.54.101.122) by proxy1.bredband.net (7.3.127)
        id 4811823A0190E20E for linux-scsi@vger.kernel.org; Thu, 31 Jul 2008 20:32:08 +0200
In-Reply-To: <4891FBA3.50703@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Mark Salyzyn <Mark_Salyzyn@adaptec.com>, Linux-Scsi <linux-scsi@vger.kernel.org>, AACRAID <AACRAID@adaptec.com>

On Thu, 31 Jul 2008 13:51:31 -0400
Douglas Gilbert <dougg@torque.net> wrote:

> Martin Samuelsson wrote:
> > On Thu, 31 Jul 2008 10:47:33 -0400
> > Mark Salyzyn <Mark_Salyzyn@adaptec.com> wrote:
> > 
> >> On Jul 31, 2008, at 10:05 AM, Douglas Gilbert wrote:
> >>
> >>> Mark Salyzyn wrote:
> >>>> aacraid driver is not the emulation. The Firmware itself has a SAT  
> >>>> 0.9
> >>>> translation layer to the raw SATA drives at the physical transport,  
> >>>> the
> >>>> Firmware then deals with all the targets as SCSI representations.
> >>> Mark,
> >>> Is that SAT interface at the physical transport accessible
> >>> to something like smartmontools?
> >> YES, that is the whole reason we added the physical access via /dev/ 
> >> sg* in the driver!!!
> >>
> >> You may have to do a '-d ata', the patch to smartmontools to automate  
> >> this for SATA devices was not approved by Adaptec. SAS drives work.
> > 
> > Does that mean that
> > 
> > [root@disk ~]# smartctl -a -d ata /dev/sg1
> > 
> > should return something nicer than
> > 
> > ====
> > smartctl version 5.36 [i686-redhat-linux-gnu] Copyright (C) 2002-6 Bruce Allen
> > Home page is http://smartmontools.sourceforge.net/
> 
> Martin,
> I wouldn't use smartmontools version 5.36 . Could you try
> version 5.38?

Sure can do, after fetching the tar ball and a fitting C++ compiler.

> Also please don't use "-d ata" on the command line; either don't
> give a "-d <interface>" argument, or (if there are still problems)
> try "-d sat".

That did some kind of trick. Without -d sat, the result was the same as before; "bad response to IEC mode page", but with it, there's _something_ happening:

====
[root@disk ~]# smartctl -a -d sat -T permissive /dev/sg1
smartctl version 5.38 [i686-pc-linux-gnu] Copyright (C) 2002-8 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Device Model:     x_05_9anemf_er
Serial Number:    [No Information Found]
Firmware Version: #<binary junk>
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   14
ATA Standard is:  Not recognized. Minor revision code: 0xb7f8
Local Time is:    Thu Jul 31 20:18:20 2008 CEST
SMART support is: Ambiguous - ATA IDENTIFY DEVICE words 82-83 don't show if SMART supported.
                  Checking for SMART support by trying SMART ENABLE command.
                  SMART ENABLE appeared to work!  Continuing.
SMART support is: Ambiguous - ATA IDENTIFY DEVICE words 85-87 don't show if SMART is enabled.
                  Checking to be sure by trying SMART RETURN STATUS command.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00) Offline data collection activity
                                        was never started.
                                        Auto Offline Data Collection: Disabled.
Total time to complete Offline 
data collection:                 (   0) seconds.
Offline data collection
capabilities:                    (0x00)         Offline data collection not supported.
SMART capabilities:            (0x0000) Automatic saving of SMART data                                  is not implemented.
Error logging capability:        (0x00) Error logging NOT supported.
                                        No General Purpose Logging support.

Warning: device does not support Error Logging
SMART Error Log Version: 0
No Errors Logged

Warning: device does not support Self Test Logging
SMART Self-test log structure revision number 0
Warning: ATA Specification requires self-test log structure revision number = 1
No self-tests have been logged.  [To run self-tests, use: smartctl -t]


Device does not support Selective Self Tests/Logging
====

(I'd say the overall outcome was a failure, if somewhat less than before.)

Doing the same to /dev/sdb gives almost the same; the difference is in:

====
Device Model:     [No Information Found]
Serial Number:    [No Information Found]
Firmware Version: [No Information Found]
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   15
ATA Standard is:  Not recognized. Minor revision code: 0x83
====

Without permissive, it stops after the second "Ambiguous".

Regards,
/Sam

> 
> Doug Gilbert
> 
> 
> > Smartctl: Device Read Identity Failed (not an ATA/ATAPI device)
> > 
> > A mandatory SMART command failed: exiting. To continue, add one or more '-T permissive' options.
> > ====
> > ?
> > 
> > Without it, I at least get the drive name:
> > 
> > ====
> > [root@disk ~]# smartctl -a /dev/sg1
> > smartctl version 5.36 [i686-redhat-linux-gnu] Copyright (C) 2002-6 Bruce Allen
> > Home page is http://smartmontools.sourceforge.net/
> > 
> > Device: WDC      WD3200KS-00PFB0  Version: 21.0
> >>> Terminate command early due to bad response to IEC mode page
> > A mandatory SMART command failed: exiting. To continue, add one or more '-T permissive' options.
> > ====
> > 
> > The responses are identical for /dev/sdb, by the way. And two permissives state that SMART ENABLE failed in the former case, and that the response to IEC mode page was bad.
> > 
> > I got what seems to be Dell's latest firmware for the card
> > 
> > http://support.us.dell.com/support/downloads/format.aspx?releaseid=R155588&c=us&l=en&cs=&s=gen
> > 
> > (for the CERC SATA 1.5/6ch card, which should be the same), but it didn't like the card.
> > 
> > AFA0> controller details
> > Executing: controller details
> > Controller Information
> > ----------------------
> >          Remote Computer: .
> >              Device Name: AFA0
> >          Controller Type: Adaptec 2610SA
> >              Access Mode: READ-WRITE
> > Controller Serial Number: Last Six Digits = C31E83
> >       Number of Channels: 1
> >      Devices per Channel: 15
> > Controller Physical Slot: 2
> >           Controller CPU: i960 series
> >     Controller CPU Speed: 100 Mhz
> >        Controller Memory: 64 Mbytes
> >            Battery State: Not Present
> > 
> > Component Revisions
> > -------------------
> >                 CLI: 4.1-0 (Build #7420)
> >                 API: 4.1-0 (Build #7420)
> >     Miniport Driver: 1.1-5 (Build #2453)
> > Controller Software: 4.2-1 (Build #9304)
> >     Controller BIOS: 4.2-1 (Build #9304)
> > Controller Firmware: (Build #9304)
> > 
> > Regards,
> > /Sam
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
