From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/4] [Target_Core_Mod]: Add SPC-3 reserverations
	infrastructure
Date: Thu, 22 Jan 2009 15:18:46 -0800
Message-ID: <1232666326.1274.610.camel@haakon2.linux-iscsi.org>
References: <1232612501.1274.526.camel@haakon2.linux-iscsi.org>
	 <49789C33.1050102@caiway.nl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:30952 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753849AbZAVXTL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jan 2009 18:19:11 -0500
In-Reply-To: <49789C33.1050102@caiway.nl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Evert van Grootheest <j.e.van.grootheest@caiway.nl>
Cc: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 2009-01-22 at 17:17 +0100, Jan Evert van Grootheest wrote:
> Hi Nicholas,
> 
> I just read your email on lkml.org and just had to reply...
> 
> Nicholas A. Bellinger wrote:
> > Greetings all,
> >
> > This series of patches adds SCSI reservation infrastructure to
> > Target_Core_Mod/ConfigFS for current legacy SPC-2 reservations, as well
> > as WIP code for adding SPC-3 compliant persistent reservations to
> > Target_Core_Mod.
> >   
> Thanks for this introduction and mentioning SCSI in it. Because the rest 
> of your mail barely shows the relation.
> If I understand correctly, this does not apply to ATA/SATA disks? What 
> about network storage?

Yes and Yes.  The main idea behind target_core_mod/ConfigFS is to
structure a $HBA/$STORAGE_OBJECT hierarchy of Linux/SCSI, Linux/BLOCK
and Linux/VFS storage subsystems objects, and to communicate through
target_core_transport.h:se_subsystem_api_t of function pointers into
those various subsystems.

The ConfigFS pieces comes into play when a $FABRIC_MOD wants to access
said $HBA/$STORAGE_OBJECT and establish communication for bulk I/O and
control (and possibling some emulation) processing.  This is one with a
ConfigFS symbolic link using /bin/ln to create the target port mapping
from $STORAGE_OBJECT.

Here is how is looks in use with LIO-Target v3.0 at:

http://linux-iscsi.org/index.php/LIO-Target/ConfigFS

# Set up our shell variables
export CONFIGFS=/sys/kernel/config/
export TARGET=/sys/kernel/config/target/core/
export FABRIC=/sys/kernel/config/target/iscsi/
# Create a IBLOCK device called 'lvm_test0' on iblock_0 HBA

<Setup target_core_mod/ConfigFS pieces>

# BEGIN CONFIGFS CODE FOR LINUX ISCSI TARGET (LIO-TARGET) 
DEF_IQN="iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0"
# Define the first iSCSI Network Portal
PORTAL="172.16.201.137:3260"
# The first mkdir(2) to $FABRIC will load iscsi_target_mod
mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/np/$PORTAL"
# Enable iSCSI/SCTP traffic on this $PORTAL for $DEF_IQN/tpgt_1
echo 1 > "$FABRIC/$DEF_IQN/tpgt_1/np/$PORTAL/sctp"
# Create iSCSI LUN=0 on $DEF_IQN/tpgt_1
mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_0"
# Map $TARGET/$HBA/$STORAGE_OBJECT into LIO-Target for $DEF_IQN/tpgt_1 LUN=0 with symbolic port name 'lio-west-port'
ln -s $TARGET/iblock_0/lvm_test0 "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_0/lio_west_port"
# Create iSCSI LUN=1 on $DEF_IQN/tpgt_1
mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_1"
# Map $TARGET/$HBA/$STORAGE_OBJECT into LIO-Target for $DEF_IQN/tpgt_1 LUN=1 with symbolic port name 'lio-east-port'
ln -s $TARGET/pscsi_0/sdd "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_1/lio_east_port"
# END CONFIGFS CODE FOR LINUX ISCSI TARGET (LIO-TARGET)

> >   
> Just a tiny hint there by that change to scsi.h.
> > On target_core_mod module load and /sys/kernel/config/target/core configuration with
> >   
> And no hint here at all. What is an admin to expect when he sees the 
> above path?
> I'm not an expert in /sys at all, but /sys/kernel/config makes some 
> sense. But what gets configured in /sys/kernel/config/target?

So, the target_core_mod/ConfigFS piece is intended to be the generic
infrastructure for these $STORAGE_OBJECTs to different network/storage
fabrics or loopback purposes.

> I usually go 'round in the embedded world. And 'target' is the tiny 
> board that you develop for and that ends up in some or other device that 
> customers buy.
> 
> Hope you get the idea.
> - shouldn't it be /sys/kernel/config/scsi/target or somesuch?

Or
perhaps /sys/kernel/config/target/scsi, /sys/kernel/config/target/block
and /sys/kernel/config/target/vfs and hang the subsystem PLUGINs in that
mannger.  We would still want to be able to access
include/linux/fs.h:struct block_device
for target_core_mod/IBLOCK and include/linux/fs.h:struct file access
with target_core_mod/FILEIO across a different non SCSI based fabrics
with ConfigFS however.  In that case the $FABRIC_MODs would be located
at /sys/kernel/config/target/sata or /sys/kernel/config/target/aoe.

Of course, the SCSI MIBs for statistics and debugging would have to be
adapted in /proc/scsi_target/mib/ for those non SCSI fabrics, but most
of the same abstractions would apply for stats to $STORAGE_OBJECT.

> - perhaps the code should move to drivers/scsi?

Well, the target_core_mod/ConfigFS code itself sits above Linux/SCSI,
and attempts to be as generic as possible wrt to the bulk READ/WRITE I/O
mapping algorithms across different subsystem plugins, CPU
architectures, and receiving all possible combinations of incoming
max_sectors for $STORAGE_OBJECTS from those CDBs being delivered through
$FABRIC_MOD operations.

Also, wrt to source directory structure, target_core_mod/ConfigFS +
Subsystem Plugins need be put into drivers/target and perhaps
drivers/target/$FABRIC_MOD.

Thanks for your comments!

--nab

> 
> Thanks,
> Jan Evert
> 
> 
> > Target_Core_Mod/IBLOCK, Target_Core_Mod/pSCSI, and Target_Core_Mod/RAMDISK_MCP $STORAGE_OBJECTS:
> >
> > TARGET_CORE[0]: Loading Generic Kernel Storage Engine: v3.0.0 on Linux/i686 on 2.6.28
> > TARGET_CORE[0]: Initialized ConfigFS Fabric Infrastructure: v1.0.0 on Linux/i686 on 2.6.28
> > SE_PC[1] - Registered Plugin Class: TRANSPORT
> > PLUGIN_TRANSPORT[1] - pscsi registered
> > PLUGIN_TRANSPORT[4] - iblock registered
> > PLUGIN_TRANSPORT[5] - rd_dr registered
> > PLUGIN_TRANSPORT[6] - rd_mcp registered
> > PLUGIN_TRANSPORT[7] - fileio registered
> > SE_PC[2] - Registered Plugin Class: OBJ
> > PLUGIN_OBJ[1] - dev registered
> > Target_Core_ConfigFS: Located se_plugin: cfa41090 plugin_name: iblock hba_type: 4 plugin_dep_id: 0
> > CORE_HBA[0] - Linux-iSCSI.org iBlock HBA Driver v3.0 on Generic Target Core Stack v3.0.0
> > CORE_HBA[0] - Attached iBlock HBA: 0 to Generic Target Core TCQ Depth: 512
> > CORE_HBA[0] - Attached HBA to Generic Target Core
> > IBLOCK: Allocated ib_dev for lvm_test0
> > Target_Core_ConfigFS: Allocated se_subsystem_dev_t: cfa40000 se_dev_su_ptr: c8c74400
> > IBLOCK: Claiming struct block_device: cf63cf00
> > IBLOCK: Created bio_set() for major/minor: 254:2
> > iblock: Using SPC2_RESERVATIONS emulation
> > CORE_iBLOCK[0] - Activating Device with TCQ: 0 at Major: 254 Minor 2
> >   Vendor: LIO-ORG   Model: IBLOCK            Revision: v3.0
> >   Type:   Direct-Access                      ANSI SCSI revision: 02
> > T10 EVPD Unit Serial Number: 1234567890:0_254_2
> > T10 EVPD Page Length: 37
> > T10 EVPD Identifer Length: 33
> > T10 EVPD Identifier Association: addressed logical unit
> > T10 EVPD Identifier Type: T10 Vendor ID based
> > T10 EVPD ASCII Device Identifier: LIO-ORG IBLOCK:1234567890:0_254_2
> > Target_Core_ConfigFS: Registered iblock se_dev->se_dev_ptr: c7f95800 from fd
> > Target_Core_ConfigFS: Located se_plugin: cfa41024 plugin_name: pscsi hba_type: 1 plugin_dep_id: 0
> > CORE_HBA[1] - Linux-iSCSI.org Parallel SCSI HBA Driver v3.0 on Generic Target Core Stack v3.0.0
> > CORE_HBA[1] - MPT SPI Host
> > CORE_HBA[1] - Attached Parallel SCSI HBA to Generic Target Core with TCQ Depth: 127 MaxSectors: 8192
> > CORE_HBA[1] - Attached HBA to Generic Target Core
> > PSCSI: Allocated pdv: cd047160 for sdd
> > Target_Core_ConfigFS: Allocated se_subsystem_dev_t: cfa43800 se_dev_su_ptr: cd047160
> > PSCSI: Claiming cf2d8000 Major:Minor - 8:48
> > pscsi: Using SPC_PASSTHROUGH, no reservation emulation
> > CORE_PSCSI[0] - Activating Device with TCQ: 32 at Parallel SCSI Location (Channel/Target/LUN) 0/3/0
> >   Vendor: VMware,   Model: VMware Virtual S  Revision: 1.0 
> >   Type:   Direct-Access                      ANSI SCSI revision: 02
> > PSCSI Status Byte exception at task: ca63d000 CDB: 0x12 Result: 0x08000002
> > CORE_PSCSI[0] - Added TYPE_DISK for 0:3:0
> > Target_Core_ConfigFS: Registered pscsi se_dev->se_dev_ptr: c8f92000 from fd
> > Target_Core_ConfigFS: Located se_plugin: cfa410d8 plugin_name: rd_mcp hba_type: 6 plugin_dep_id: 0
> > CORE_HBA[2] - Linux-iSCSI.org Ramdisk HBA Driver v3.0 on Generic Target Core Stack v3.0.0
> > CORE_HBA[2] - Attached Ramdisk HBA: 0 to Generic Target Core TCQ Depth: 256 MaxSectors: 1024
> > CORE_HBA[2] - Attached HBA to Generic Target Core
> > Target_Core_ConfigFS: Allocated se_subsystem_dev_t: c85bf800 se_dev_su_ptr: c8fe5880
> > RAMDISK: Referencing Page Count: 16384
> > CORE_RD[0] - Built Ramdisk Device ID: 0 space of 16384 pages in 6 tables
> > rd_mcp: Using SPC2_RESERVATIONS emulation
> > CORE_RD[0] - Activating Device with TCQ: 0 at Ramdisk Device ID: 0
> >   Vendor: LIO-ORG   Model: RAMDISK-MCP       Revision: v3.0
> >   Type:   Direct-Access                      ANSI SCSI revision: 02
> > T10 EVPD Unit Serial Number: 1234567890:2_0
> > T10 EVPD Page Length: 38
> > T10 EVPD Identifer Length: 34
> > T10 EVPD Identifier Association: addressed logical unit
> > T10 EVPD Identifier Type: T10 Vendor ID based
> > T10 EVPD ASCII Device Identifier: LIO-ORG RAMDISK-MCP:1234567890:2_0
> > CORE_RD[0] - Added LIO MEMCPY Ramdisk Device ID: 0 of 16384 pages in 6 tables, 67108864 total bytes
> > Target_Core_ConfigFS: Registered se_dev->se_dev_ptr: c8f93400
> >
> > <SNIP>
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> >
> >   
> 
> 

