From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [ANNOUNCE]: ConfigFS enabled Generic Target Mode and iSCSI
	Target Stack on v2.6.27-rc7
Date: Wed, 01 Oct 2008 17:18:40 -0700
Message-ID: <1222906720.15764.49.camel@haakon2.linux-iscsi.org>
References: <1222716101.4296.41.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:27612 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753455AbYJBASp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Oct 2008 20:18:45 -0400
In-Reply-To: <1222716101.4296.41.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-iscsi-target-dev@googlegroups.com, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, SCST-Devel <scst-devel@lists.sourceforge.net>, iet-dev <iscsita>
Cc: Joel Becker <joel.becker@oracle.com>, Jerome Martin <tramjoe.merin@gmail.com>, Greg KH <greg@kroah.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Vladislav Bolkhovitin <vst@vlnb.net>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, "H. Peter Anvin" <hpa@zytor.com>, Ming Zhang <blackmagic02881@gmail.com>, Jens Axboe <jens.axboe@oracle.com>

On Mon, 2008-09-29 at 12:21 -0700, Nicholas A. Bellinger wrote:
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

Ok, just added new commits to make target_core_mod be able to run
independently of iscsi_target_mod.  This means that all mkdir(2) calls
under $TARGET do not require iscsi_target_mod to be loaded.

Next, following Joel's advice from LPC, I made
target_core_configfs.c:target_core_register_fabric(),  call
request_module() to load $FABRIC_MOD instead of using
do_configfs_mkdir() to kick off the registration process.  This means
that $FABRIC_MOD's init_module() is responsible for calling
target_fabric_configfs_init() and target_fabric_configfs_register() to
complete $FABRIC_MOD's registration with the configfs generic target
core.  This means that startup now looks like:

modprobe target_core_mod

export CONFIGFS=/sys/kernel/config/
export TARGET=/sys/kernel/config/target/core/
export FABRIC=/sys/kernel/config/target/iscsi/

mkdir -p $TARGET/iblock_0/lvm_test0
echo iblock_major=254,iblock_minor=2 >
$TARGET/iblock_0/lvm_test0/dev_control
echo 1 > $TARGET/iblock_0/lvm_test0/dev_enable

mkdir -p $TARGET/pscsi_0/sdd
echo scsi_channel_id=0,scsi_target_id=3,scsi_lun_id=0 >
$TARGET/pscsi_0/sdd/dev_control
echo 1 > $TARGET/pscsi_0/sdd/dev_enable

DEF_IQN="iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0"

# The first mkdir(2) to $FABRIC will load iscsi_target_mod
mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/np/172.16.201.137:3260"
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

<snip>

This line will modprobe iscsi_target_mod, create iscsi_tiqn_t,
iscsi_portal_group_t, and iscsi_tpg_np_t objects with a single mkdir(2)
call.

Many thanks to Joel Becker for recommending the request_module() usage!

> Also, one of the next major steps for the upstream generic target engine
> and iSCSI target stack is to include SCST's target mode API between
> Engine / Fabric to give target_core_mod a proper Fabric API to allow
> other SCST fabric modules to access target_core_mod's configfs enabled
> storage objects.  Also, allowing STGT to use the configfs interface to
> allow for userspace fabrics to the same target_core_mod storage objects
> is also on the list, but I imagine interest from those communities will
> certainly help drive those efforts.  
> 

So at this point, I believe all (or very close to all) iSCSI target
related functions are now outside of target_core_mod.  There are a few
more file and function names that need to have their prefixes changed,
but other that a handful of this minor bits, things are getting close
installing the SCST Target API between $FABRIC_MOD <->
$TARGET_CORE_MOD. 

Also, I was thinking a bit more about how things show up under $TARGET,
which is /sys/kernel/config/target/core.  With the current code,
parameters are passed it for all target_core_mod subsystem plugins (eg:
the ones to drivers/scsi, block/ or fs/.  One thing I was thinking about
for struct scsi_device and struct block_device storage objects that
appear under /sys/block (or any SysFS location that eventually leads
back to a struct scsi_device) would be to create a symbolic link from
say /sys/block/sdd to ConfigFS at say $TARGET/core/pscsi_0/sdd, so we
could drop the echo scsi_channel_id=0,scsi_target_id=0,scsi_lun_id=0 >
$TARGET/pscsi/sdd/dev_control stuff..

I know that ConfigFS today does not allow symlinks to non ConfigFS
filesystems, but perhaps this would be a special case between ConfigFS
<-> SysFS to order to deliver struct scsi_device for $TARGET/pscsi_* and
struct block_device to $TARGET/iblock_* generic storage objects..?

What do you think..? Joel or Greg KH..?

--nab

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
> 
> --nab
> 
> 
> 
> --~--~---------~--~----~------------~-------~--~----~
> You received this message because you are subscribed to the Google Groups "Linux-iSCSI.org Target Development" group.
> To post to this group, send email to linux-iscsi-target-dev@googlegroups.com
> To unsubscribe from this group, send email to linux-iscsi-target-dev+unsubscribe@googlegroups.com
> For more options, visit this group at http://groups.google.com/group/linux-iscsi-target-dev?hl=en
> -~----------~----~----~----~------~----~------~--~---
> 

