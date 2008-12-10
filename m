From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [PATCH][RFC 18/23]: Documentation for SRP target driver
Date: Wed, 10 Dec 2008 21:57:15 +0300
Message-ID: <4940110B.9070401@vlnb.net>
References: <494009D7.4020602@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:62642 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbYLJS5K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Dec 2008 13:57:10 -0500
In-Reply-To: <494009D7.4020602@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>, Boaz Harrosh <bharrosh@panasas.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, Vu Pham <huongvp@yahoo.com>, Bart Van Assche <bart.vanassche@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

This patch contains documentation for SRP target driver.

Signed-off-by: Vu Pham <vu@mellanox.com>
Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
---
  Documentation/scst/README.srpt |   85 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  1 file changed, 85 insertions(+)

diff -uprN orig/linux-2.6.27/Documentation/scst/README.srpt linux-2.6.27/Documentation/scst/README.srpt
--- orig/linux-2.6.27/Documentation/scst/README.srpt
+++ linux-2.6.27/Documentation/scst/README.srpt
@@ -0,0 +1,85 @@
+SCSI RDMA Protocol (SRP) Target driver for Linux
+=================================================
+
+The SRP Target driver is designed to work directly on top of the
+OpenFabrics OFED-1.x software stack (http://www.openfabrics.org) or
+the Infiniband drivers in the Linux kernel tree
+(http://www.kernel.org). The SRP target driver also interfaces with
+the generic SCSI target mid-level driver called SCST
+(http://scst.sourceforge.net).
+
+How-to run
+-----------
+
+A. On srp target machine
+1. Please refer to SCST's README for loading scst driver and its
+dev_handlers drivers (scst_disk, scst_vdisk block or file IO mode, nullio, ...)
+
+Example 1: working with real back-end scsi disks
+a. modprobe scst
+b. modprobe scst_disk
+c. cat /proc/scsi_tgt/scsi_tgt
+
+ibstor00:~ # cat /proc/scsi_tgt/scsi_tgt
+Device (host:ch:id:lun or name)                             Device handler
+0:0:0:0                                                     dev_disk
+4:0:0:0                                                     dev_disk
+5:0:0:0                                                     dev_disk
+6:0:0:0                                                     dev_disk
+7:0:0:0                                                     dev_disk
+
+Now you want to exclude the first scsi disk and expose the last 4 scsi disks as
+IB/SRP luns for I/O
+echo "add 4:0:0:0 0" >/proc/scsi_tgt/groups/Default/devices
+echo "add 5:0:0:0 1" >/proc/scsi_tgt/groups/Default/devices
+echo "add 6:0:0:0 2" >/proc/scsi_tgt/groups/Default/devices
+echo "add 7:0:0:0 3" >/proc/scsi_tgt/groups/Default/devices
+
+Example 2: working with VDISK FILEIO mode (using md0 device and file 10G-file)
+a. modprobe scst
+b. modprobe scst_vdisk
+c. echo "open vdisk0 /dev/md0" > /proc/scsi_tgt/vdisk/vdisk
+d. echo "open vdisk1 /10G-file" > /proc/scsi_tgt/vdisk/vdisk
+e. echo "add vdisk0 0" >/proc/scsi_tgt/groups/Default/devices
+f. echo "add vdisk1 1" >/proc/scsi_tgt/groups/Default/devices
+
+Example 3: working with VDISK BLOCKIO mode (using md0 device, sda, and cciss/c1d0)
+a. modprobe scst
+b. modprobe scst_vdisk
+c. echo "open vdisk0 /dev/md0 BLOCKIO" > /proc/scsi_tgt/vdisk/vdisk
+d. echo "open vdisk1 /dev/sda BLOCKIO" > /proc/scsi_tgt/vdisk/vdisk
+e. echo "open vdisk2 /dev/cciss/c1d0 BLOCKIO" > /proc/scsi_tgt/vdisk/vdisk
+f. echo "add vdisk0 0" >/proc/scsi_tgt/groups/Default/devices
+g. echo "add vdisk1 1" >/proc/scsi_tgt/groups/Default/devices
+h. echo "add vdisk2 2" >/proc/scsi_tgt/groups/Default/devices
+
+2. modprobe ib_srpt
+
+
+B. On initiator machines you can manualy do the following steps:
+1. modprobe ib_srp
+2. ipsrpdm -c (to discover new SRP target)
+3. echo <new target info> > /sys/class/infiniband_srp/srp-mthca0-1/add_target
+4. fdisk -l (will show new discovered scsi disks)
+
+Example:
+Assume that you use port 1 of first HCA in the system ie. mthca0
+
+[root@lab104 ~]# ibsrpdm -c -d /dev/infiniband/umad0
+id_ext=0002c90200226cf4,ioc_guid=0002c90200226cf4,
+dgid=fe800000000000000002c90200226cf5,pkey=ffff,service_id=0002c90200226cf4
+[root@lab104 ~]# echo id_ext=0002c90200226cf4,ioc_guid=0002c90200226cf4,
+dgid=fe800000000000000002c90200226cf5,pkey=ffff,service_id=0002c90200226cf4 >
+/sys/class/infiniband_srp/srp-mthca0-1/add_target
+
+OR
+
++ You can edit /etc/infiniband/openib.conf to load srp driver and srp HA daemon
+automatically ie. set SRP_LOAD=yes, and SRPHA_ENABLE=yes
++ To set up and use high availability feature you need dm-multipath driver
+and multipath tool
++ Please refer to OFED-1.x SRP's user manual for more in-details instructions
+on how-to enable/use HA feature
+
+To minimize QUEUEFULL conditions, you can apply scst_increase_max_tgt_cmds
+patch from SRPT package from http://sourceforge.net/project/showfiles.php?group_id=110471

