From: Jan Evert van Grootheest <j.e.van.grootheest@caiway.nl>
Subject: Re: [PATCH 0/4] [Target_Core_Mod]: Add SPC-3 reserverations infrastructure
Date: Thu, 22 Jan 2009 17:17:55 +0100
Message-ID: <49789C33.1050102@caiway.nl>
References: <1232612501.1274.526.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cardassian.kabelfoon.nl ([62.45.45.18]:53379 "EHLO
	cardassian.kabelfoon.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757000AbZAVQoj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jan 2009 11:44:39 -0500
In-Reply-To: <1232612501.1274.526.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

Hi Nicholas,

I just read your email on lkml.org and just had to reply...

Nicholas A. Bellinger wrote:
> Greetings all,
>
> This series of patches adds SCSI reservation infrastructure to
> Target_Core_Mod/ConfigFS for current legacy SPC-2 reservations, as well
> as WIP code for adding SPC-3 compliant persistent reservations to
> Target_Core_Mod.
>   
Thanks for this introduction and mentioning SCSI in it. Because the rest 
of your mail barely shows the relation.
If I understand correctly, this does not apply to ATA/SATA disks? What 
about network storage?
>  drivers/lio-core/Makefile                |    1 -
>  drivers/lio-core/target_core_base.h      |   36 +--
>  drivers/lio-core/target_core_configfs.c  |  137 +---------
>  drivers/lio-core/target_core_device.c    |    1 -
>  drivers/lio-core/target_core_pr.c        |  427 ------------------------------
>  drivers/lio-core/target_core_pr.h        |   25 --
>  drivers/lio-core/target_core_tpg.c       |    4 +
>  drivers/lio-core/target_core_transport.c |  315 ++++++++++++----------
>  drivers/lio-core/target_core_transport.h |    4 +-
>  include/scsi/scsi.h                      |   22 --
>  10 files changed, 186 insertions(+), 786 deletions(-)
>   
Just a tiny hint there by that change to scsi.h.
> On target_core_mod module load and /sys/kernel/config/target/core configuration with
>   
And no hint here at all. What is an admin to expect when he sees the 
above path?
I'm not an expert in /sys at all, but /sys/kernel/config makes some 
sense. But what gets configured in /sys/kernel/config/target?
I usually go 'round in the embedded world. And 'target' is the tiny 
board that you develop for and that ends up in some or other device that 
customers buy.

Hope you get the idea.
- shouldn't it be /sys/kernel/config/scsi/target or somesuch?
- perhaps the code should move to drivers/scsi?

Thanks,
Jan Evert


> Target_Core_Mod/IBLOCK, Target_Core_Mod/pSCSI, and Target_Core_Mod/RAMDISK_MCP $STORAGE_OBJECTS:
>
> TARGET_CORE[0]: Loading Generic Kernel Storage Engine: v3.0.0 on Linux/i686 on 2.6.28
> TARGET_CORE[0]: Initialized ConfigFS Fabric Infrastructure: v1.0.0 on Linux/i686 on 2.6.28
> SE_PC[1] - Registered Plugin Class: TRANSPORT
> PLUGIN_TRANSPORT[1] - pscsi registered
> PLUGIN_TRANSPORT[4] - iblock registered
> PLUGIN_TRANSPORT[5] - rd_dr registered
> PLUGIN_TRANSPORT[6] - rd_mcp registered
> PLUGIN_TRANSPORT[7] - fileio registered
> SE_PC[2] - Registered Plugin Class: OBJ
> PLUGIN_OBJ[1] - dev registered
> Target_Core_ConfigFS: Located se_plugin: cfa41090 plugin_name: iblock hba_type: 4 plugin_dep_id: 0
> CORE_HBA[0] - Linux-iSCSI.org iBlock HBA Driver v3.0 on Generic Target Core Stack v3.0.0
> CORE_HBA[0] - Attached iBlock HBA: 0 to Generic Target Core TCQ Depth: 512
> CORE_HBA[0] - Attached HBA to Generic Target Core
> IBLOCK: Allocated ib_dev for lvm_test0
> Target_Core_ConfigFS: Allocated se_subsystem_dev_t: cfa40000 se_dev_su_ptr: c8c74400
> IBLOCK: Claiming struct block_device: cf63cf00
> IBLOCK: Created bio_set() for major/minor: 254:2
> iblock: Using SPC2_RESERVATIONS emulation
> CORE_iBLOCK[0] - Activating Device with TCQ: 0 at Major: 254 Minor 2
>   Vendor: LIO-ORG   Model: IBLOCK            Revision: v3.0
>   Type:   Direct-Access                      ANSI SCSI revision: 02
> T10 EVPD Unit Serial Number: 1234567890:0_254_2
> T10 EVPD Page Length: 37
> T10 EVPD Identifer Length: 33
> T10 EVPD Identifier Association: addressed logical unit
> T10 EVPD Identifier Type: T10 Vendor ID based
> T10 EVPD ASCII Device Identifier: LIO-ORG IBLOCK:1234567890:0_254_2
> Target_Core_ConfigFS: Registered iblock se_dev->se_dev_ptr: c7f95800 from fd
> Target_Core_ConfigFS: Located se_plugin: cfa41024 plugin_name: pscsi hba_type: 1 plugin_dep_id: 0
> CORE_HBA[1] - Linux-iSCSI.org Parallel SCSI HBA Driver v3.0 on Generic Target Core Stack v3.0.0
> CORE_HBA[1] - MPT SPI Host
> CORE_HBA[1] - Attached Parallel SCSI HBA to Generic Target Core with TCQ Depth: 127 MaxSectors: 8192
> CORE_HBA[1] - Attached HBA to Generic Target Core
> PSCSI: Allocated pdv: cd047160 for sdd
> Target_Core_ConfigFS: Allocated se_subsystem_dev_t: cfa43800 se_dev_su_ptr: cd047160
> PSCSI: Claiming cf2d8000 Major:Minor - 8:48
> pscsi: Using SPC_PASSTHROUGH, no reservation emulation
> CORE_PSCSI[0] - Activating Device with TCQ: 32 at Parallel SCSI Location (Channel/Target/LUN) 0/3/0
>   Vendor: VMware,   Model: VMware Virtual S  Revision: 1.0 
>   Type:   Direct-Access                      ANSI SCSI revision: 02
> PSCSI Status Byte exception at task: ca63d000 CDB: 0x12 Result: 0x08000002
> CORE_PSCSI[0] - Added TYPE_DISK for 0:3:0
> Target_Core_ConfigFS: Registered pscsi se_dev->se_dev_ptr: c8f92000 from fd
> Target_Core_ConfigFS: Located se_plugin: cfa410d8 plugin_name: rd_mcp hba_type: 6 plugin_dep_id: 0
> CORE_HBA[2] - Linux-iSCSI.org Ramdisk HBA Driver v3.0 on Generic Target Core Stack v3.0.0
> CORE_HBA[2] - Attached Ramdisk HBA: 0 to Generic Target Core TCQ Depth: 256 MaxSectors: 1024
> CORE_HBA[2] - Attached HBA to Generic Target Core
> Target_Core_ConfigFS: Allocated se_subsystem_dev_t: c85bf800 se_dev_su_ptr: c8fe5880
> RAMDISK: Referencing Page Count: 16384
> CORE_RD[0] - Built Ramdisk Device ID: 0 space of 16384 pages in 6 tables
> rd_mcp: Using SPC2_RESERVATIONS emulation
> CORE_RD[0] - Activating Device with TCQ: 0 at Ramdisk Device ID: 0
>   Vendor: LIO-ORG   Model: RAMDISK-MCP       Revision: v3.0
>   Type:   Direct-Access                      ANSI SCSI revision: 02
> T10 EVPD Unit Serial Number: 1234567890:2_0
> T10 EVPD Page Length: 38
> T10 EVPD Identifer Length: 34
> T10 EVPD Identifier Association: addressed logical unit
> T10 EVPD Identifier Type: T10 Vendor ID based
> T10 EVPD ASCII Device Identifier: LIO-ORG RAMDISK-MCP:1234567890:2_0
> CORE_RD[0] - Added LIO MEMCPY Ramdisk Device ID: 0 of 16384 pages in 6 tables, 67108864 total bytes
> Target_Core_ConfigFS: Registered se_dev->se_dev_ptr: c8f93400
>
> <SNIP>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>   

