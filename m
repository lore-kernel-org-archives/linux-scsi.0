From: Mike Grant <mgg@ecs.soton.ac.uk>
Subject: Advansys scsi reset problems
Date: Fri, 04 Oct 2002 20:10:28 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D9DE7A4.7000002@ecs.soton.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from roadrunner.ecs.soton.ac.uk (roadrunner.ecs.soton.ac.uk [152.78.68.161])
	by raven.ecs.soton.ac.uk (8.9.3/8.9.3) with ESMTP id UAA11972
	for <linux-scsi@vger.kernel.org>; Fri, 4 Oct 2002 20:10:30 +0100 (BST)
Received: from ecs.soton.ac.uk (IDENT:t4D+U/icpssIVKD/qdGyPZTgfo5hVv22@beermat.ecs.soton.ac.uk [152.78.191.92])
	by roadrunner.ecs.soton.ac.uk (8.12.3/8.12.3) with ESMTP id g94JASn0007974
	for <linux-scsi@vger.kernel.org>; Fri, 4 Oct 2002 20:10:29 +0100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

A while ago, I bought a SCSI Ultra3 LVD disk and an Advansys Ultra160 (2
channel) card and installed RedHat 7.2 on it, hoping for a pleasant
speed up from my IDE setup.  Unfortunately, the performance was very
poor - taking over 10 mins just to boot due to many long inactive pauses
and frequent scsi resets.  Thinking it might be a kernel problem, I
built several kernels (2.4.16 & 18) and found that I could get a usable
(some resets, ~3min to boot) system by building the advansys driver into
the kernel.  As a module, I'd get a lot more resets.

Later, I tried booting into the old RedHat7.1 (still on the IDE disk)
and checking that I could see the same problems there.  While I didn't
see any resets from SCSI disk activity, I did still have the long
pauses.  I did see resets on the (SCSI-II) CD* devices, which are on the
other channel.

Symptoms:
=========
   - Frequent resets (approx 1 every 30-60min) with no load.
   - Heavy load (i.e. disk intensive operations) gives long inactive
pauses with intermittent resets.  Not every pause is followed by a
reset.  I think write operations are worse, but I've not properly tested
that.

The most common manifestation is when the machine boots - it's virtually
guaranteed to have several long pauses and a couple of resets during the
boot process.  Typically this happens near the ext3 and fcsk parts
(during disk activity I guess).

The hardware:
=============
   - 1.4GHz Athlon, Gigabyte m/b, 768MB
   - Advansys 3950 SCSI card (two channels)
   - Fujitsu MAN3184MP LVD SCSI disk  **
   - Ricoh MP6201S CD writer  ++
   - Iomega SCSI ZIP drive ++
   - Pioneer 106S DVDROM ++
   - Plextor 32x CDROM ++
**=on LVD chain   ++=on SCSI-II chain
The devices are correctly terminated as far I can tell.

Things I've tried:
==================
   - since it's a two-channel card, I've tried moving the disk to the
other channel.  No change.
   - removing various scsi devices (ie. tests with no scsi disk or with
the cd writer removed).  No change.
   - removing whole channels (ie. just disk, or just SCSI-II devices).
No change, although resets caused by the SCSI-II devices (CD*, zip
drive) are less frequent.
   - changing the LVD cable (albeit to a worse cable).  No change.

Since any combination of the devices still gives resets (in different
amounts) I speculate the problem is with the card/other hardware or the
driver.

Things I could try:
===================
     - 2.5.?
     - a different LVD terminator (but resets occur without any LVD cable
connected, so this seems unlikely)
     - set fire to and stomp on the resetting SCSI card, then buy a new one.

Any other ideas?

Thanks,

Mike Grant.

PS. There's some more info (output of lspci -v, etc) at:
http://www.ecs.soton.ac.uk/~mgg/scsi_misery/
I thought this mail was getting a little bit big :)


