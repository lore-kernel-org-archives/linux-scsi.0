From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [ANNOUNCE]: ConfigFS enabled Generic Target Mode and iSCSI Target
 Stack on v2.6.27-rc7
Date: Wed, 01 Oct 2008 21:36:41 +0400
Message-ID: <48E3B529.4060406@vlnb.net>
References: <1222716101.4296.41.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-03.mailcluster.net ([77.221.130.215]:46623 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751642AbYJARgj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Oct 2008 13:36:39 -0400
In-Reply-To: <1222716101.4296.41.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>, SCST-Devel <scst-devel@lists.sourceforge.net>, iet-dev <iscsitarget-devel@lists.sourceforge.net>, Joel Becker <joel.becker@oracle.com>, Jerome Martin <tramjoe.merin@gmail.com>, Greg KH <greg@kroah.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, "H. Peter Anvin" <hpa@zytor.com>, Ming Zhang <blackmagic02881@gmail.com>

Hi Nicholas,

Nicholas A. Bellinger wrote:
> Greetings all,
> 
> I am happy to announce that the first ConfigFS configurable generic
> target engine (target_core_mod) and iSCSI Target Stack
> (iscsi_target_mod) are now able to use ConfigFS symlinks for the
> creation of Linux Storage Objects from drivers/scsi, block, or fs/
> storage objects to iSCSI Target Port Endpoints.
> 
> The code is available currently running on v2.6.27-rc7 and has been
> broken up into a number of commits at:
> http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary
> 
> Now that the primary configfs functionality is up and allowing iSCSI
> Initiator Traffic to the symlinked storage objects from a generic target
> engine, I will be continuing work on the complete logic for configfs
> enabled iscsi_target_mod, as well as removing the legacy IOCTL control
> path as equivalent functionality is added with ConfigFS.  
> 
> Also, one of the next major steps for the upstream generic target engine
> and iSCSI target stack is to include SCST's target mode API between
> Engine / Fabric to give target_core_mod a proper Fabric API to allow
> other SCST fabric modules to access target_core_mod's configfs enabled
> storage objects.  Also, allowing STGT to use the configfs interface to
> allow for userspace fabrics to the same target_core_mod storage objects
> is also on the list, but I imagine interest from those communities will
> certainly help drive those efforts.  
> 
> Here are the shell variables required to make it all go:
> 
> export CONFIGFS=/sys/kernel/config/
> export TARGET=/sys/kernel/config/target/core/
> export FABRIC=/sys/kernel/config/target/iscsi/
> 
> The storage objects registered with target_core_mod via $TARGET may be
> mapped from $TARGET/$HBA/$STORAGE_OBJECT any number of times to:
> 
> $FABRIC/$IQN/tpgt_1/lun/lun_0/$PORT_LINK
> $FABRIC/$IQN/tpgt_1/lun/lun_1/$PORT_LINK
> $FABRIC/$IQN/tpgt_2/lun/lun_0/$PORT_LINK
> $FABRIC/$ANOTHER_IQN/tpgt_1/lun_0/$PORT_LINK
> ....
> ....
> 
> Here are the shell commands to bring storage objects online..
> 
> # Create a IBLOCK HBA and virtual storage object
> mkdir -p $TARGET/iblock_0/lvm_test0
> # Tell the virtual storage object what struct block_device we want
> echo iblock_major=254,iblock_minor=2 > $TARGET/iblock_0/lvm_test0/dev_control
> # Enable the virtual storage object and call bd_claim()
> echo 1 > $TARGET/iblock_0/lvm_test0/dev_enable
> 
> DEF_IQN="iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0"
> 
> # Create the network portal on $DEF_IQN/tpgt_1
> mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/np/172.16.201.137:3260"
> # Create LUN 0 on $DEF_IQN/tpgt_1
> mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_0"
> # Create the iSCSI Target Port Mapping for $DEF_IN/tpgt_1 LUN 0
> # to lvm_test0 and give it the port symbolic name of lio_west_port
> ln -s $TARGET/iblock_0/lvm_test0 "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_0/lio_west_port"
> 
> # Allow iSCSI Initiators to login to $DEF_IQN/tpgt_1
> #warning Currently uses generate_node_acls=1,cache_dynamic_acls=1,demo_mode_lun_access=1
> echo 1 > $FABRIC/$DEF_IQN/tpgt_1/tpg_enable
> 
> target:~# tree $CONFIGFS
> /sys/kernel/config/
> `-- target
>     |-- core
>     |   `-- iblock_0
>     |       |-- hba_info
>     |       `-- lvm_test0
>     |           |-- dev_control
>     |           |-- dev_enable
>     |           `-- dev_info
>     |-- iscsi
>     |   |-- iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0
>     |   |   `-- tpgt_1
>     |   |       |-- lun
>     |   |       |   `-- lun_0
>     |   |       |       |-- lio_west_port -> ../../../../../../target/core/iblock_0/lvm_test0
>     |   |       |       |-- port_control
>     |   |       |       `-- port_info
>     |   |       |-- np
>     |   |       |   `-- 172.16.201.137:3260
>     |   |       |       `-- portal_info
>     |   |       |-- tpg_control
>     |   |       `-- tpg_enable
>     |   `-- lio_version
>     `-- version
> 
> 
> ----------------------------------------------------------
> 
> # Add some more HBA and storage Objects
> target:~# mkdir -p $TARGET/fileio_0/file_object
> target:~# mkdir -p $TARGET/rd_mcp_0/ramdisk0
> target:~# mkdir -p $TARGET/rd_dr_0/ramdisk0
> 
> target:~# mkdir -p $TARGET/pscsi_0/sdd
> target:~# echo scsi_channel_id=0,scsi_target_id=3,scsi_lun_id=0 > $TARGET/pscsi_0/sdd/dev_control   
> target:~# echo 1 > $TARGET/pscsi_0/sdd/dev_enable 
> 
> # Now, create LUN 1 and another Port Symlink to a new device on the same $IQN/tpgt_1
> mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_1"
> # Create the iSCSI Target Port Mapping for $DEF_IN/tpgt_1 LUN 1
> # to lvm_test0 and give it the port symbolic name of lio_east_port
> ln -s $TARGET/pscsi_0/sdd/ "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_1/lio_east_port"
> 
> target:~# tree $CONFIGFS
> /sys/kernel/config/
> `-- target
>     |-- core
>     |   |-- fileio_0
>     |   |   |-- file_object
>     |   |   |   |-- dev_control
>     |   |   |   |-- dev_enable
>     |   |   |   `-- dev_info
>     |   |   `-- hba_info
>     |   |-- iblock_0
>     |   |   |-- hba_info
>     |   |   `-- lvm_test0
>     |   |       |-- dev_control
>     |   |       |-- dev_enable
>     |   |       `-- dev_info
>     |   |-- pscsi_0
>     |   |   |-- hba_info
>     |   |   `-- sdd
>     |   |       |-- dev_control
>     |   |       |-- dev_enable
>     |   |       `-- dev_info
>     |   |-- rd_dr_0
>     |   |   |-- hba_info
>     |   |   `-- ramdisk0
>     |   |       |-- dev_control
>     |   |       |-- dev_enable
>     |   |       `-- dev_info
>     |   `-- rd_mcp_0
>     |       |-- hba_info
>     |       `-- ramdisk0
>     |           |-- dev_control
>     |           |-- dev_enable
>     |           `-- dev_info
>     |-- iscsi
>     |   |-- iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0
>     |   |   `-- tpgt_1
>     |   |       |-- lun
>     |   |       |   |-- lun_0
>     |   |       |   |   |-- lio_west_port -> ../../../../../../target/core/iblock_0/lvm_test0
>     |   |       |   |   |-- port_control
>     |   |       |   |   `-- port_info
>     |   |       |   `-- lun_1
>     |   |       |       |-- lio_east_port -> ../../../../../../target/core/pscsi_0/sdd
>     |   |       |       |-- port_control
>     |   |       |       `-- port_info
>     |   |       |-- np
>     |   |       |   `-- 172.16.201.137:3260
>     |   |       |       `-- portal_info
>     |   |       |-- tpg_control
>     |   |       `-- tpg_enable
>     |   `-- lio_version
>     `-- version
> 
> 22 directories, 29 files

It's good, I like it. The only thing concerns me that, considering how 
much time *I* spent to understand it, for an average user understanding 
it can be an unbearable nightmare ;)

In a few days I'll write a proposed configfs hierarchy for existing SCST 
/proc interface.

Vlad

