From: "Kit Gerrits" <kit@gerritsacc.nl>
Subject: PERC2/Si won't failover
Date: Mon, 31 Jan 2005 14:49:25 +0100
Message-ID: <20050131134506.34A3AC4@frisbee.gerritsacc.nl>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.gerritsaa.nl ([82.168.101.83]:51778 "EHLO
	frisbee.gerritsacc.nl") by vger.kernel.org with ESMTP
	id S261193AbVAaNtB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Jan 2005 08:49:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hey all!

I have a PowerEDGE 2400 with  PERC2/Si with 4x9GB Drives with RedHat EL 3.0
Container 0: plain 9GB drive (O/S)
Container 1: 3x9GB in RAID5 (data)

After getting I/O Errors (and gettinge a strange noise from drive 0:3:0), I
did the unthinkable: I pulled the drive from the chassis without shutting it
down. (oops)
I have now verified the drive, cleaned off the partition and rescanned the
bus.
...but the drive won't failover

I have set it to failover, but the PERC won't failover the drive, even after
a (warm) reboot.

Did I forget anything?

Thanks in advance,

Kit Gerrits
kit@gerritsaa.nl


---------------
Debugging info:
---------------

AFA0> disk list
Executing: disk list

B:ID:L  Device Type     Blocks    Bytes/Block Usage            Shared Rate
------  --------------  --------- ----------- ---------------- ------ ----
0:00:0   Disk            17783240  512         Initialized      NO     80
0:01:0   Disk            17783240  512         Initialized      NO     80
0:02:0   Disk            17783240  512         Initialized      NO     80
0:03:0   Disk            17783240  512         Initialized      NO     80

AFA0> container show failover
Executing: container show failover

Container Scsi B:ID:L
--------- ----------------------------------
  0       --- No Devices Assigned ---
  1       0:03:0

AFA0> container list
Executing: container list
Num          Total  Oth Chunk          Scsi   Partition
Label Type   Size   Ctr Size   Usage   B:ID:L Offset:Size
----- ------ ------ --- ------ ------- ------ -------------
 0    Volume 8.47GB            Open    0:00:0 64.0KB:8.47GB
 /dev/sda             NT

 1    RAID-5 16.9GB       32KB Open    0:01:0 64.0KB:8.47GB
 /dev/sdb             DATA             0:02:0 64.0KB:8.47GB
                                       ?:??:?  - Missing -

AFA0> controller show au
Executing: controller show automatic_failover
Automatic failover ENABLED

AFA0> container scrub 1
Executing: container scrub 1
Command Error: <The controller was unable to perform a scrub (consistency
check)
 operation on the container because one or more of the container's
partitions fa
iled.  >


