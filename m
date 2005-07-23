From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Unplugging of SBP-2 devices still does not work
Date: Sat, 23 Jul 2005 21:43:49 +0200
Message-ID: <42E29DF5.5090603@s5r6.in-berlin.de>
Reply-To: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:63923 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S261545AbVGWToH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Jul 2005 15:44:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

Hi all,

Summary:
--------
Problem 1) Hot unplugging of SBP-2 hangs ieee1394's nodemgr when *sd_mod*
was attached to the SBP-2 device. I have seen this problem since RBC
handling was moved from sbp2 to sd_mod.

Problem 2) Hot unplugging of SBP-2 hangs ieee1394's nodemgr when *sr_mod*
was attached to the SBP-2 device. This is a very old problem.

Details:
--------
I don't know exactly how old the underlying problem is, but I can see
scenario 1 consistently at least with Linux 2.6.13-rc3 and linux1394.org's
current drivers.

When an SBP-2 disk is physically unplugged while sbp2 is still loaded and
associated with the disk, ieee1394's knodemgrd_# thread goes straight into
D state (uninterruptible sleep, according to ps). Furthermore, the scsi_eh_#
thread still exists (and sleeps). /sys/bus/scsi/devices/ is empty after
disconnection. With sbp2's debug level increased, the following functions
are traced:

[unplug disk]
Jul 23 19:56:24 shuttle kernel: ieee1394: Node changed: 1-01:1023 -> 1-00:1023
Jul 23 19:56:24 shuttle kernel: ieee1394: Node suspended: ID:BUS[1-00:1023]  GUID[0001d202e0200ef1]
Jul 23 19:56:24 shuttle kernel: ieee1394: sbp2: sbp2_remove
Jul 23 19:56:24 shuttle kernel: ieee1394: sbp2: sbp2_logout_device
Jul 23 19:56:24 shuttle kernel: ieee1394: sbp2: sbp2_remove_device
Jul 23 19:56:24 shuttle kernel: Synchronizing SCSI cache for disk sda:
Jul 23 19:56:24 shuttle perl: drakupdate_fstab called with --auto --del /dev/sda1

(The last one is an administrative script from Mandrake that modifies fstab
for removable volumes.)

After the latest update at linux1394.org, which adds a scsi_remove_device()
to sbp2_remove() just before sbp2_logout_device() [this update improves
sbp2_remove() for unloading of sbp2 while an RBC SBP-2 disk is still connected],
the trace changes slightly:

[unplug disk]
Jul 23 20:08:53 shuttle kernel: ieee1394: Node changed: 1-01:1023 -> 1-00:1023
Jul 23 20:08:53 shuttle kernel: ieee1394: Node suspended: ID:BUS[1-00:1023]  GUID[0001d202e0200ef1]
Jul 23 20:08:53 shuttle kernel: ieee1394: sbp2: sbp2_remove
Jul 23 20:08:53 shuttle kernel: Synchronizing SCSI cache for disk sda:
Jul 23 20:08:53 shuttle perl: drakupdate_fstab called with --auto --del /dev/sda1

sbp2_logout_device and sbp2_remove_device are missing here because the
whole procedure hangs in scsi_remove_device(). The slightly older code
which showed the log above did not call scsi_remove_device() directly,
it only called scsi_remove_host() from sbp2_remove_device(). So the older
code hung in scsi_remove_host().

Furthermore, when I then shutdown the machine in order to reboot and get
ieee1394 working again, the shutdown scripts end with this message:
"Synchronizing SCSI cache for disk sda:"
Then the system comes to a halt and must be reset manually.

All of the above is valid for RBC harddisks. When I attach an older FireWire
harddisk that claims to be TYPE_DISK instead of TYPE_RBC, then sd_sync_cache()
is skipped. The reason is that this disk's cache cannot be determined:

[attach disk]
[...]
Jul 23 20:53:54 shuttle kernel: sda: asking for cache data failed
Jul 23 20:53:54 shuttle kernel: sda: assuming drive cache: write through
[...]

This "cures" or at least masks the problem:

[unplug disk]
Jul 23 20:54:24 shuttle kernel: ieee1394: Node changed: 1-01:1023 -> 1-00:1023
Jul 23 20:54:24 shuttle kernel: ieee1394: Node suspended: ID:BUS[1-00:1023]  GUID[0001041010004beb]
Jul 23 20:54:24 shuttle kernel: ieee1394: sbp2: sbp2_remove
Jul 23 20:54:24 shuttle kernel: ieee1394: sbp2: sbp2_logout_device
Jul 23 20:54:24 shuttle kernel: ieee1394: sbp2: sbp2_remove_device
Jul 23 20:54:24 shuttle kernel: ieee1394: sbp2: SBP-2 device removed, SCSI ID = 0
Jul 23 20:54:25 shuttle perl: drakupdate_fstab called with --auto --del /dev/sda2
Jul 23 20:54:25 shuttle perl: drakupdate_fstab called with --auto --del /dev/sda1

After this, knodemgrd_# is still running correctly (usually sleeping), and
there is no scsi_eh_# thread left. This log was generated with the most recent
sbp2 code, i.e. with scsi_remove_device() called just before sbp2_logout_device().

So I gather the problem was introduced --- or at least unmasked --- when RBC
handling was taken out of sbp2 and put into sd_mod.

However, there is not only a problem between sbp2 and sd_mod (with RBC disks).
There is also an old problem between sbp2 and sr_mod. The underlying problem
may perhaps be the same as with sd_mod.

Here is a log when detaching a FireWire CD-R/W, again with the newest sbp2
code that calls scsi_remove_device() in sbp2_remove() just before the call
to sbp2_logout_device():

[unpug CD-R/W]
Jul 23 21:04:49 shuttle kernel: ieee1394: Node changed: 1-02:1023 -> 1-00:1023
Jul 23 21:04:49 shuttle kernel: ieee1394: GUID 0x00301bac00002ba4: bus_info_data[0] = 0x0404912b
Jul 23 21:04:49 shuttle kernel: ieee1394: Node suspended: ID:BUS[1-00:1023]  GUID[00d0010500006823]
Jul 23 21:04:49 shuttle kernel: ieee1394: sbp2: sbp2_remove

After that, knodemgrd_# hangs in D state, there is a scsi_eh_# left over, but
at least /sys/bus/scsi/devices/ is already empty.

Note: All logs above were generated with debug log level set to 2 in sbp2,
which also shows all scsi commands passed down to sbp2. As you can see,
there are no more commands coming down once scsi_remove_device() was entered.

According to a posting from Olaf Hering in May, ide_scsi had the same (or a
similar) problem with sd_mod but it was fixed in ide_scsi eventually:
http://marc.theaimsgroup.com/?m=111598100912279
(But does ide_scsi actually deal with hardware hot-unplugging?)

Any ideas on how to fix this are very appreciated. These problems are quite
frustrating, considering that SBP-2 hot-unplugging already worked in Linux
2.4 (although in a crude way) but never seemed to work properly in Linux 2.6.
-- 
Stefan Richter
-=====-=-=-= -=== =-===
http://arcgraph.de/sr/

