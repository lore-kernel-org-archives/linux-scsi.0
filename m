From: Douglas Gilbert <dougg@torque.net>
Subject: [RFC] sgbind
Date: Wed, 14 May 2003 22:33:32 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EC2379C.4010709@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:31498 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S262037AbTENMlj
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 May 2003 08:41:39 -0400
Received: from torque.net (d-242-115.stlucia.uq.net.au [203.101.242.115])
	by bunyip.cc.uq.edu.au (8.12.9/8.12.9) with ESMTP id h4ECsOHO020657
	for <linux-scsi@vger.kernel.org>; Wed, 14 May 2003 22:54:24 +1000 (GMT+1000)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have resynced the sgbind code against lk 2.5.69-bk8
but I will await a more stable baseline before releasing
it (so I know sgbind isn't causing more flakiness).


sgbind is a virtual device node (misc char device 10, 246
at the moment) that allows an existing or an unscanned
logical unit (device) to be bound by its nexus and SCSI
commands sent to it. By "nexus" I mean its topological
address <host_no, channel, id, lun>.

The sgbind code is in the sg driver which allows it
to share existing code. sgbind avoids using the sg
driver's upper level sysfs code (i.e. sg_driverfs_dev).

Here is the additional code in the sg header:

/* sgbind support, for device scanning via /dev/sgbind */
#define SGBIND_ATTACH 0x22a0
#define SGBIND_DETACH 0x22a1
#define SGBIND_ADD_LU 0x22a2
#define SGBIND_REMOVE_LU 0x22a3
 

struct sgbind_nexus {
         int descriptor_id;      /* set to 0 for now */
         unsigned int host_no;
         unsigned int channel;
         unsigned int scsi_id;
         unsigned int lun;
};

The SGBIND_ADD_LU and SGBIND_REMOVE_LU ioctls are simply
programmatic interfaces to the code behind "scsi add-single-device"
and "scsi remove-single-device". [Code was moved from scsi_proc.c
to scsi_scan.c so that these ioctls don't require procfs to be
configured.]

Multiple file descriptors may be open on /dev/sgbind, each
file descriptor has its own state (like normal sg device nodes).
The SGBIND_ATTACH ioctl will either bind:
   - to an existing logical unit (device) which matches the
     given nexus
   - create a new scsi_device instance (using scsi_alloc_dev())
     with the given nexus
The host number must match an existing host.

The SGBIND_DETACH ioctl unbinds the file descriptor from an
existing nexus (assuming a nexus was established by a prior
SGBIND_ATTACH). Thereafter an new nexus can be formed with
SGBIND_ATTACH. Closing the file descriptor also has the effect
of unbinding the nexus.

I'm not sure whether a SGBIND_PUBLISH ioctl is required
(SGBIND_ADD_LU sort of does that).

Two other sg ioctl's can be used on a sgbind file descriptor:
   - SG_GET_VERSION
   - SG_IO once there is an existing nexus

Obviously getting to the SG_IO ioctl is the point of the exercise.


To test this further I believe there should be a new
field in the Scsi_Host and Scsi_Host_Template structures
called something like 'no_scan'. Default is 0 for
existing mid level scanning. A value of 1 instructs
the scsi_scan.c to ignore this host.

Comments?

Doug Gilbert




