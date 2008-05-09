From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Hack to fix not working spindown over Firewire
Date: Fri, 9 May 2008 20:32:27 +0200 (CEST)
Message-ID: <tkrat.327b59f1366f8ea0@s5r6.in-berlin.de>
References: <20080429232606.GA14261@dose.home.local>
 <481874BD.5010807@s5r6.in-berlin.de>
 <20080507180042.GA32629@dose.home.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:51546 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbYEIScj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 May 2008 14:32:39 -0400
In-Reply-To: <20080507180042.GA32629@dose.home.local>
Content-Disposition: INLINE
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Tino Keitel <tino.keitel@gmx.de>

On  7 May, Tino Keitel wrote at LKML and LSML:

[PL-3507 in Raidsonic Icy Box needs power condition 2 or 3 in the START
STOP UNIT command in order to spin down]

> On Wed, Apr 30, 2008 at 15:31:41 +0200, Stefan Richter wrote:
>> According to the description of Active,
>> Idle, Standby, Sleep in RBC, we do most certainly want code 1 on resume,
>> and rather 3 than 2 on suspend. 5 instead of 3 or 2 might even be better
> 
> FYI, sg_start --pc=3 also spins down the drive here.
> 
>> from the POV of energy consumption but a "device reset may be required
>> before access to the device is allowed" which I'd rather not deal with.
>> 
>> Tino, does the scsi stack log the device as "Direct-Access-RBC" after it
>> was plugged in?
> 
> Yes:
> 
> scsi 7:0:0:0: Direct-Access-RBC WDC WD32 00JB-00KFA0           PQ: 0 ANSI: 4


I tested a few FireWire disks now.

1) FireWire to IDE or to SATA chipset
2) start bit is honored:
   "sg_start --stop" stops the motor and "sg_start" restarts it
3) power condition field is honored:
   "sg_start --pc=3" stops the motor and "sg_start --pc=1 restarts it
4) peripheral device type claimed by the firmware
5) vendor and model of the enclosure


1)           2)     3)     4)    5)
bridge       start  pc     PDT   enclosure
--------------------------------------------------------------
INIC-2430    yes    yes    SBC   AVLAB 2.5" Drive Kit
INIC-2430    yes    yes    SBC   IOI FWB-IDE01AB, 1 HDD
INIC-2430    yes    yes    SBC   IOI FWB-IDE01AB, 2 HDDs, JBOD

OXFW911      yes    yes    RBC   MacPower Icecube
OXUF922      yes    yes    RBC   MacPower Icecube 800+
OXFW912      yes    yes    RBC   MacPower Igloo
OXFW912      yes    yes    RBC   VulcanTech DualDrive 2nd gen.
OXUF924DSB   yes    yes    SBC   MacPower Taurus, 1 HDD
OXUF924DSB   no     no     SBC   MacPower Taurus, 2 HDDs, JBOD

PL-3507      no     no     RBC   MacPower Prefect II

TSB42AA9     no     yes    SBC   DViCO MomoBay CX-1
TSB42AA9A    yes    yes    RBC   DViCO MomoBay FX-3A


General remarks:

Several disks don't require an "sg_start" or "sg_start --pc=1" to spin
up again; they do so on next access.  Some even ignore "sg_start --pc=1"
and do not start the motor until the next access (e.g. read access).  I
did not test systematically whether "sg_start" or "sg_start --pc=1" are
required at all.  (Proper support of "sg_start --pc=1" is beneficial in
so far as the high-latency operation which spin-up is happens when it is
expected, not sometime later.)

The firmwares of CX-1, FX-3A, AVLAB, and Prefect II implement
auto-spin-down after some time of inactivity (different from firmware to
firmware) and auto-spin-up on subsequent access.

Remarks on individual enclosures/ firmwares:

MacPower Taurus
---------------
I could not test RAID0 and RAID1 due to lack of spare disks.

MacPower Prefect II
-------------------
This is a 5.25" enclosure, i.e. primarily meant for CD/DVD-ROM/R/W.  I
tested it with a HDD here.  The firmware is from MacPower, not from
Prolific.  Power conditions 2 or 5 don't spin the disk down either.

MomoBay CX-1
------------
"sg_start --stop" stops the motor, but "sg_start" fails with unit
attention.  Subsequent read commands after "sg_start --stop" time out.
I.e. "sg_start --stop" causes CX-1 to go offline.  It needs to be
power-cycled after that.

MomoBay FX-3A
-------------
"sg_start --stop" works.  "sg_start" ends with unit attention, but
starts the motor.  Subsequent read commands succeed.


Conclusions so far:

  - Some PL-3507 based devices, notably those with a later firmware from
    Prolific, spin down if power condition 2 or 3 is set.  Others don't.

  - The old and in several ways quirky DViCO CX-1 must not be exposed to
    START STOP UNIT with start flag off.

  - There is alas no correlation between the PDT and support for either
    variant of spin down/ spin up.

I hope to test another PL-3507 device and an Apple Mac in target mode
soon.  I will then post a patch for the sbp2/scsi/sd stack based on
Tino's patch and the current findings which switches all SBP-2 HDDs to
using the power condition field in sd_start_stop_device().

I also have two devices which probably contain old SYM13FWxxx bridges.
Alas I can't test them with HDDs because they are sealed CD-RW
enclosures which cannot be opened without damage.
-- 
Stefan Richter
-=====-==--- -=-= -=--=
http://arcgraph.de/sr/


