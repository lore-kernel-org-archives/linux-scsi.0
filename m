From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Race to power off harming SATA SSDs
Date: Mon, 10 Apr 2017 20:21:19 -0300
Message-ID: <20170410232118.GA4816@khazad-dum.debian.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

Summary:

Linux properly issues the SSD prepare-to-poweroff command to SATA SSDs,
but it does not wait for long enough to ensure the SSD has carried it
through.

This causes a race between the platform power-off path, and the SSD
device.  When the SSD loses the race, its power is cut while it is still
doing its final book-keeping for poweroff.  This is known to be harmful
to most SSDs, and there is a non-zero chance of it even bricking.

Apparently, it is enough to wait a few seconds before powering off the
platform to give the SSDs enough time to fully enter STANDBY IMMEDIATE.

This issue was verified to exist on SATA SSDs made by at least Crucial
(and thus likely also Micron), Intel, and Samsung.  It was verified to
exist on several 3.x to 4.9 kernels, both distro (Debian) and also
upstream stable/longterm kernels from kernel.org.   Only x86-64 was
tested.

A proof of concept patch is attached, which was sufficient to
*completely* avoid the issue on the test set, for a perid of six to
eight weeks of testing.


Details and hypothesis:

For a long while I have noticed that S.M.A.R.T-provided attributes for
SSDs related to "unit was powered off unexpectedly" under my care where
raising on several boxes, without any unexpected power cuts being
accounted for.

This has been going for a *long* time (several years, since the first
SSD I got).  But it was too rare an event for me to try to track down
the root cause...  until a friend reported his SSD was already reporting
several hundred unclean power-offs on his laptop.  That made it much
easier to track down.

Per spec (and device manuals), SCSI, SATA and ATA-attached SSDs must be
informed of an imminent poweroff to checkpoing background tasks, flush
RAM caches and close logs.  For SCSI SSDs, you must tissue a
START_STOP_UNIT (stop) command.  For SATA, you must issue a STANDBY
IMMEDIATE command.  I haven't checked ATA, but it should be the same as
SATA.

In order to comply with this requirement, the Linux SCSI "sd" device
driver issues a START_STOP_UNIT command when the device is shutdown[1].
For SATA SSD devices, the SCSI START_STOP_UNIT command is properly
translated by the kernel SAT layer to STANDBY IMMEDIATE for SSDs.

After issuing the command, the kernel properly waits for the device to
report that the command has been completed before it proceeds.

However, *IN PRACTICE*, SATA STANDBY IMMEDIATE command completion
[often?] only indicates that the device is now switching to the target
power management state, not that it has reached the target state.  Any
further device status inquires would return that it is in STANDBY mode,
even if it is still entering that state.

The kernel then continues the shutdown path while the SSD is still
preparing itself to be powered off, and it becomes a race.  When the
kernel + firmware wins, platform power is cut before the SSD has
finished (i.e. the SSD is subject to an unclean power-off).

Evidently, how often the SSD will lose the race depends on a platform
and SSD combination, and also on how often the system is powered off.
A sluggish firmware that takes its time to cut power can save the day...


Observing the effects:

An unclean SSD power-off will be signaled by the SSD device through an
increase on a specific S.M.A.R.T attribute.  These SMART attributes can
be read using the smartmontools package from www.smartmontools.org,
which should be available in just about every Linux distro.

	smartctl -A /dev/sd#

The SMART attribute related to unclean power-off is vendor-specific, so
one might have to track down the SSD datasheet to know which attribute a
particular SSD uses.  The naming of the attribute also varies.

For a Crucial M500 SSD with up-to-date firmware, this would be attribute
174 "Unexpect_Power_Loss_Ct", for example.

NOTE: unclean SSD power-offs are dangerous and may brick the device in
the worst case, or otherwise harm it (reduce longevity, damage flash
blocks).  It is also not impossible to get data corruption.


Testing, and working around the issue:

I've asked for several Debian developers to test a patch (attached) in
any of their boxes that had SSDs complaining of unclean poweroffs.  This
gave us a test corpus of Intel, Crucial and Samsung SSDs, on laptops,
desktops, and a few workstations.

The proof-of-concept patch adds a delay of one second to the SD-device
shutdown path.

Previously, the more sensitive devices/platforms in the test set would
report at least one or two unclean SSD power-offs a month.  With the
patch, there was NOT a single increase reported after several weeks of
testing.

This is obviously not a test with 100% confidence, but it indicates very
strongly that the above analysis was correct, and that an added delay
was enough to work around the issue in the entire test set.



Fixing the issue properly:

The proof of concept patch works fine, but it "punishes" the system with
too much delay.  Also, if sd device shutdown is serialized, it will
punish systems with many /dev/sd devices severely.

1. The delay needs to happen only once right before powering down for
   hibernation/suspend/power-off.  There is no need to delay per-device
   for platform power off/suspend/hibernate.

2. A per-device delay needs to happen before signaling that a device
   can be safely removed when doing controlled hotswap (e.g. when
   deleting the SD device due to a sysfs command).

I am unsure how much *total* delay would be enough.  Two seconds seems
like a safe bet.

Any comments?  Any clues on how to make the delay "smarter" to trigger
only once during platform shutdown, but still trigger per-device when
doing per-device hotswapping ?


[1] In ancient times, it didn't, or at least the ATA/SATA side didn't.
It has been fixed for at least a decade, refer to "manage_start_stop", a
deprecated sysfs node that should have been removed in y2008 :-)

-- 
  Henrique Holschuh
