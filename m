From: Raju <krishnamraju-e@hcl.com>
Subject: mkdir: cannot create directory =?utf-8?b?YC9zeXMva2VybmVsL2NvbmZpZy90YXJnZXQvaXNjc2knOg==?= Invalid argument
Date: Tue, 19 Jul 2011 15:17:34 +0000 (UTC)
Message-ID: <loom.20110719T170144-482@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:42840 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716Ab1GTEAI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jul 2011 00:00:08 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <lnx-linux-scsi@m.gmane.org>)
	id 1QjNx9-0004BY-5v
	for linux-scsi@vger.kernel.org; Wed, 20 Jul 2011 06:00:07 +0200
Received: from 128-222-37-57.emc.com ([128.222.37.57])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Wed, 20 Jul 2011 06:00:07 +0200
Received: from krishnamraju-e by 128-222-37-57.emc.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Wed, 20 Jul 2011 06:00:07 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,
I can't able create an iscsi target because of some problem in configfs:


Below are the steps I followed in Debian Lenny(upgraded kernel to 2.6.39.2):

#!/bin/sh
# BEGIN CONFIG FOR CONFIGFS USAGE
modprobe configfs
mount -t configfs none /sys/kernel/config
# END CONFIG FOR CONFIGFS USAGE

# BEGIN CONFIGFS CODE FOR GENERIC TARGET ENGINE
modprobe target_core_mod
export CONFIGFS=/sys/kernel/config/
export TARGET=/sys/kernel/config/target/core/
export FABRIC=/sys/kernel/config/target/iscsi/
# END CONFIGFS CODE FOR GENERIC TARGET ENGINE

# START RAMDISK SUBSYSTEM PLUGIN OBJECTS
mkdir -p $TARGET/rd_mcp_0/ramdisk
echo rd_pages=32768 > $TARGET/rd_mcp_0/ramdisk/control
echo 1 > $TARGET/rd_mcp_0/ramdisk/enable
# END RAMDISK SUBSYSTEM PLUGIN OBJECTS

# BEGIN CONFIGFS CODE FOR LINUX ISCSI TARGET (LIO-TARGET)
DEF_IQN="iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0"
# Define the first iSCSI Network Portal
PORTAL1="10.0.0.1:3260"
# The first mkdir(2) to $FABRIC will load iscsi_target_mod
mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/np/$PORTAL1"
mkdir: cannot create directory `/sys/kernel/config/target/iscsi': 
Invalid argument


AND KERNEL LOG:

[10443.799266] CORE_HBA[0] - TCM Ramdisk HBA Driver v4.0 on Generic 
        Target CoreStack v4.0.0-rc7-ml
[10443.799272] CORE_HBA[0] - Attached Ramdisk HBA: 0 to Generic Target 
        Core TCQDepth: 256 MaxSectors: 1024
[10443.799278] CORE_HBA[1] - Attached HBA to Generic Target Core
[10443.799329] Target_Core_ConfigFS: Allocated struct se_subsystem_dev:
        f4ee1000se_dev_su_ptr: f4e3e2c0
[10443.800370] Missing rd_pages= parameter
[10443.805761] Target_Core_ConfigFS: REGISTER-> group:f8552220 name:iscsi
[10443.838505] target_core_get_fabric() failed for iscsi
[10443.841826] Target_Core_ConfigFS: REGISTER-> group:f8552220 name:iscsi
[10443.875313] target_core_get_fabric() failed for iscsi
[10443.878496] Target_Core_ConfigFS: REGISTER-> group:f8552220 name:iscsi
[10443.910039] target_core_get_fabric() failed for iscsi
[10443.921684] Target_Core_ConfigFS: REGISTER-> group:f8552220 name:iscsi
[10443.951926] target_core_get_fabric() failed for iscsi



Please suggest any idea,


Thanks,
Raju.

