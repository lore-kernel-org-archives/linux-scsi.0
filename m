From: "Frank Borich" <Frank_Borich@us.xyratex.com>
Subject: LBD support with 2.6.10
Date: Mon, 3 Jan 2005 14:03:52 -0800
Message-ID: <47F3C2BE74738E4683574107469DFA20678BA0@XYUSEX01.xyus.xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xyratexus11.xyratex.com ([65.203.33.11]:52771 "EHLO
	XYUSEX01.xyus.xyratex.com") by vger.kernel.org with ESMTP
	id S261890AbVACWEF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Jan 2005 17:04:05 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,
I mapped a LUN approx. 3.5 TB in size to Linux
Kernel 2.6.10 (converted red hat 9 distribution)
with CONFIG_LBD=y.

I am connecting to the LUN via a Qlogic 2340 HBA.
Everything looks ok in /var/log/messages following a modprobe:

Jan  2 15:00:10 oldenglish kernel:  QLogic Fibre Channel HBA Driver:
8.00.00b21-k
Jan  2 15:00:10 oldenglish kernel:   QLogic QLA2340 -
Jan  2 15:00:10 oldenglish kernel:   ISP2312: PCI (66 MHz) @
0000:02:04.0 hdma-, host#=0, fw=3.03.02 IPX
Jan  2 15:00:10 oldenglish kernel:   Vendor: IFT       Model: A16F-R1211
Rev: 341B
Jan  2 15:00:10 oldenglish kernel:   Type:   Direct-Access
ANSI SCSI revision: 03
Jan  2 15:00:10 oldenglish kernel: qla2300 0000:02:04.0: scsi(0:0:0:0):
Enabled tagged queuing, queue depth 32.
Jan  2 15:00:10 oldenglish /sbin/hotplug: no runnable
/etc/hotplug/fc_transport.agent is installed
Jan  2 15:00:10 oldenglish /sbin/hotplug: no runnable
/etc/hotplug/scsi.agent is installed
Jan  2 15:00:10 oldenglish kernel: sda : very big device. try to use
READ CAPACITY(16).
Jan  2 15:00:10 oldenglish kernel: SCSI device sda: 6855819264 512-byte
hdwr sectors (3510179 MB)
Jan  2 15:00:10 oldenglish /sbin/hotplug: no runnable
/etc/hotplug/block.agent is installed
Jan  2 15:00:10 oldenglish kernel: SCSI device sda: drive cache: write
back
Jan  2 15:00:10 oldenglish kernel: sda : very big device. try to use
READ CAPACITY(16).
Jan  2 15:00:10 oldenglish kernel: SCSI device sda: 6855819264 512-byte
hdwr sectors (3510179 MB)
Jan  2 15:00:10 oldenglish kernel: SCSI device sda: drive cache: write
back
Jan  2 15:00:10 oldenglish kernel:  sda: unknown partition table
Jan  2 15:00:10 oldenglish kernel: Attached scsi disk sda at scsi0,
channel 0, id 0, lun 0
Jan  2 15:00:10 oldenglish /sbin/hotplug: no runnable
/etc/hotplug/scsi_device.agent is installed
Jan  2 15:08:12 oldenglish /sbin/hotplug: no runnable
/etc/hotplug/module.agent is installed
Jan  2 15:08:12 oldenglish /sbin/hotplug: no runnable
/etc/hotplug/module.agent is installed
Jan  2 15:08:12 oldenglish /sbin/hotplug: no runnable
/etc/hotplug/scsi_generic.agent is installed
Jan  2 15:08:12 oldenglish /sbin/hotplug: no runnable
/etc/hotplug/class.agent is installed

I have also sent READ_CAPACITY 10, READ_CAPCITY 16, and INQUIRY commands
to the LUN using
The sg driver, and have received expected responses.  

The problem is when I start to use programs such as fdisk or sfdisk on
the LUN 
using sd driver(/dev/sda),

Fdisk yields ouput,

#fdisk -l

Disk /dev/hdb: 20.0 GB, 20020396032 bytes
16 heads, 63 sectors/track, 38792 cylinders
Units = cylinders of 1008 * 512 = 516096 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/hdb1   *         1       203    102280+  83  Linux
/dev/hdb2           204     36712  18400536   83  Linux
/dev/hdb3         36713     38792   1048320   82  Linux swap

Disk /dev/sda: 0 MB, 0 bytes
255 heads, 63 sectors/track, 0 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

Disk /dev/sda doesn't contain a valid partition table

Sfdisk ouptput yields,

# sfdisk -s /dev/sda
/dev/sda: File too large

sfdisk: BLKGETSIZE ioctl failed for /dev/sda

Did I miss something regarding LBD support ?
Any ideas ?

Thanks,
Frank
