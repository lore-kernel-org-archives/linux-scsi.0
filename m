From: Martin Samuelsson <sam@home.se>
Subject: Re: aacraid and S.M.A.R.T
Date: Thu, 31 Jul 2008 17:27:15 +0200
Message-ID: <20080731172715.0c37f999.sam@home.se>
References: <20080730235450.0fcc21a6.sam@home.se>
	<EC1C30B3-9ED0-4A8B-90FE-F4AB25FF5E7A@adaptec.com>
	<4891C69E.9000106@torque.net>
	<4F4EA7EA-60E1-4CDC-B03F-7FC2AD9980A7@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from proxy3.bredband.net ([195.54.101.73]:50519 "EHLO
	proxy3.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbYGaP1V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jul 2008 11:27:21 -0400
Received: from ironport.bredband.com (195.54.101.120) by proxy3.bredband.net (7.3.127)
        id 481183EA018919AF for linux-scsi@vger.kernel.org; Thu, 31 Jul 2008 17:27:19 +0200
In-Reply-To: <4F4EA7EA-60E1-4CDC-B03F-7FC2AD9980A7@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
Cc: "dougg@torque.net" <dougg@torque.net>, Linux-Scsi <linux-scsi@vger.kernel.org>, AACRAID <AACRAID@adaptec.com>

On Thu, 31 Jul 2008 10:47:33 -0400
Mark Salyzyn <Mark_Salyzyn@adaptec.com> wrote:

> On Jul 31, 2008, at 10:05 AM, Douglas Gilbert wrote:
> 
> > Mark Salyzyn wrote:
> >> aacraid driver is not the emulation. The Firmware itself has a SAT  
> >> 0.9
> >> translation layer to the raw SATA drives at the physical transport,  
> >> the
> >> Firmware then deals with all the targets as SCSI representations.
> >
> > Mark,
> > Is that SAT interface at the physical transport accessible
> > to something like smartmontools?
> 
> YES, that is the whole reason we added the physical access via /dev/ 
> sg* in the driver!!!
> 
> You may have to do a '-d ata', the patch to smartmontools to automate  
> this for SATA devices was not approved by Adaptec. SAS drives work.

Does that mean that

[root@disk ~]# smartctl -a -d ata /dev/sg1

should return something nicer than

====
smartctl version 5.36 [i686-redhat-linux-gnu] Copyright (C) 2002-6 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

Smartctl: Device Read Identity Failed (not an ATA/ATAPI device)

A mandatory SMART command failed: exiting. To continue, add one or more '-T permissive' options.
====
?

Without it, I at least get the drive name:

====
[root@disk ~]# smartctl -a /dev/sg1
smartctl version 5.36 [i686-redhat-linux-gnu] Copyright (C) 2002-6 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

Device: WDC      WD3200KS-00PFB0  Version: 21.0
>> Terminate command early due to bad response to IEC mode page
A mandatory SMART command failed: exiting. To continue, add one or more '-T permissive' options.
====

The responses are identical for /dev/sdb, by the way. And two permissives state that SMART ENABLE failed in the former case, and that the response to IEC mode page was bad.

I got what seems to be Dell's latest firmware for the card

http://support.us.dell.com/support/downloads/format.aspx?releaseid=R155588&c=us&l=en&cs=&s=gen

(for the CERC SATA 1.5/6ch card, which should be the same), but it didn't like the card.

AFA0> controller details
Executing: controller details
Controller Information
----------------------
         Remote Computer: .
             Device Name: AFA0
         Controller Type: Adaptec 2610SA
             Access Mode: READ-WRITE
Controller Serial Number: Last Six Digits = C31E83
      Number of Channels: 1
     Devices per Channel: 15
Controller Physical Slot: 2
          Controller CPU: i960 series
    Controller CPU Speed: 100 Mhz
       Controller Memory: 64 Mbytes
           Battery State: Not Present

Component Revisions
-------------------
                CLI: 4.1-0 (Build #7420)
                API: 4.1-0 (Build #7420)
    Miniport Driver: 1.1-5 (Build #2453)
Controller Software: 4.2-1 (Build #9304)
    Controller BIOS: 4.2-1 (Build #9304)
Controller Firmware: (Build #9304)

Regards,
/Sam
