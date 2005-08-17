From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [RFC] embryonic RAID class
Date: Wed, 17 Aug 2005 16:25:01 -0400
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F01709318@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:42640 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1751201AbVHQUZ3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Aug 2005 16:25:29 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Under aac based adapters the build task reports the task number, current
array water mark and end of array but not the array number associated
with the build task in the AIF events returning from the Firmware. The
management applications generally issue a series of enumerations to the
devices and the arrays to build a set of objects, one of these object
attributes is the build task associated with the array (if it is
rebuilding).

Really simple to report the percentage completed as the driver already
sniffs the AIFs to generate hot-add and hot-remove actions, much more
difficult and quite possibly driver bloating to associate that build
task status with an array or underlying targets.

Compromise? Well, what about exporting an raid adapter class and having
'resync' associated with that adapter object? Array creation will no
doubt have to go to the raid adapter class in any case, so it will be a
requirement if configuration is to be allowed in this RAID class.

Add hotspare-0, hotspare-1 ... to the list?

A target id written to resync would be used to 'suck in' a hotspare or
trigger a rebuild to a failed target?

Sincerely -- Mark Salyzyn


-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of James Bottomley
Sent: Tuesday, August 16, 2005 7:28 PM
To: SCSI Mailing List
Subject: [RFC] embryonic RAID class


The idea behind a RAID class is to provide a uniform interface to all
RAID subsystems (both hardware and software) in the kernel.

To do that, I've made this class a transport class that's entirely
subsystem independent (although the matching routines have to match per
subsystem, as you'll see looking at the code).  I put it in the scsi
subdirectory purely because I needed somewhere to play with it, but it's
not a scsi specific module.

I used a fusion raid card as the test bed for this; with that kind of
card, this is the type of class output you get:

jejb@titanic> ls -l /sys/class/raid_devices/20\:0\:0\:0/
total 0
lrwxrwxrwx  1 root root     0 Aug 16 17:21 component-0 ->
../../../devices/pci0000:80/0000:80:04.0/host20/target20:1:0/20:1:0:0/
lrwxrwxrwx  1 root root     0 Aug 16 17:21 component-1 ->
../../../devices/pci0000:80/0000:80:04.0/host20/target20:1:1/20:1:1:0/
lrwxrwxrwx  1 root root     0 Aug 16 17:21 device ->
../../../devices/pci0000:80/0000:80:04.0/host20/target20:0:0/20:0:0:0/
-r--r--r--  1 root root 16384 Aug 16 17:21 level
-r--r--r--  1 root root 16384 Aug 16 17:21 resync
-r--r--r--  1 root root 16384 Aug 16 17:21 state

So it's really simple: for a SCSI device representing a hardware raid,
it shows the raid level, the array state, the resync % complete (if the
state is resyncing) and the underlying components of the RAID (these are
exposed in fusion on the virtual channel 1).

As you can see, this type of information can be exported by almost
anything, including software raid.

The more difficult trick, of course, is going to be getting it to
perform configuration type actions with writable attributes.

James
