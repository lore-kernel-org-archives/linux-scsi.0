From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] scsi_debug 1.64 , remove detect(), "hotplug" hosts
Date: Sat, 09 Nov 2002 21:26:46 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DCCE2E6.6050800@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030505010003020309050506"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from torque.net (dm1-53.triode.net.au [202.147.125.53])
	by iggy.triode.net.au (8.11.6/8.11.6) with ESMTP id gA9AS3201072
	for <linux-scsi@vger.kernel.org>; Sat, 9 Nov 2002 21:28:04 +1100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------030505010003020309050506
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This patch is against lk 2.5.46-bk3 which includes
Christoph's work removing the requirement for
detect() functions in LLDDs. He sent me an example
for scsi_debug which I have built on with this patch.

As threatened, this version includes a "scsi_debug_add_host"
parameter. At kernel or module load time this is an absolute
number (0..127 are allowable and 1 is the default). So:
     modprobe scsi_debug scsi_debug_num_devs=20 scsi_debug_add_host=0
will result in no scsi_debug hosts (thus no devices) but
the driver has 20 slots available for devices.

Then a host can be introduced (simulated hotplug) by
     echo 1 > /sysfs/bus/scsi/drivers/scsi_debug/add_host
This causes a scsi_debug host to appear and devices get
found on it [14 in my system: 7 targets (0..6) each with
2 luns (0..1)]. Another host hotplug can be simulated by
     echo 1 > /sysfs/bus/scsi/drivers/scsi_debug/add_host
which results in another 6 devices being attached (for a
total of 20 scsi_debug devices as dictated by the original
scsi_debug_num_devs).

That last (second) scsi_debug host can be removed by
     echo -1 > /sysfs/bus/scsi/drivers/scsi_debug/add_host
and its 6 devices go. Another application of this "echo"
removes the first host and all remaining devices.

Seems to work fine.


Notes:
   - Christoph and Mike A. are pulling me in 2 different
     directions. In this case Christoph got to me first
     so I have moved along that direction. Mike's
     "/sysfs/bus/scsi_dbg_fake" has me perplexed ...
   - rmmod and subsequent modprobe's on scsi_debug
     sometimes blow up.
     Hopefully Patrick's fix (not in bk3?) addresses that.
   - this patch has a work around for a kernel sscanf() bug
     (parsing -ve numbers). Randy Dunlap has attended to that.
   - the simulated "hotplug" thread belongs to the echo command
     or some sysfs magic. scsi_debug could schedule a timer
     event and do the hotplug (hot unplug) in the context of
     a timer interrupt (?) for added reality.
   - cleaned out some extraneous includes and comments.
     Suggestions welcome.

Doug Gilbert


--------------030505010003020309050506
Content-Type: application/x-gzip;
 name="scsi_debug_164_46bk3.diff.gz"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="scsi_debug_164_46bk3.diff.gz"

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
--------------030505010003020309050506--

