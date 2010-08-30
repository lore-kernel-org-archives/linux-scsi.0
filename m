From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [ANNOUNCE] TCM/LIO v4.0.0-rc3 for 2.6.36-rc3
Date: Sun, 29 Aug 2010 17:18:27 -0700
Message-ID: <1283127507.32007.403.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp107.sbc.mail.gq1.yahoo.com ([67.195.14.110]:36194 "HELO
	smtp107.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753357Ab0H3AWT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Aug 2010 20:22:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <bharrosh@panasas.com>

Greetings all,

I am very pleased to announce that TCM/LIO v4.0.0-rc3 for the 2.6.36-rc3 kernel
has been pushed into lio-core-2.6.git/lio-4.0.  Along with the numerous bugfixes
listed in the shortlog below, the main cleanups and features since v4.0.0-rc2
was released earlier this month include:

	*) Major cleanups of TCM/pSCSI struct scsi_device registration code (hch assist)
	*) Remove legacy linux_blockdevice_[claim,release]() usage (hch assist)
	*) Fix struct se_mem memory mapping across N struct se_task for
	   max_sectors=255 backstores
	*) Conversion of TCM Core to follow mainline convention and use
	   include/linux/scatterlist.h wrappers wherever possible.
	*) Add proper 4k -> 512 block_size conversion for TCM/IBLOCK (jaxboe assist)
	*) New tcm_mod_builder.py script and mini-HOWTO for generating new
	   TCM fabric modules with functional+runnable configfs skeletons
	*) TCM level SYNCHRONIZE_CACHE_* emulation w/ support for WriteCache and
	   FUA WRITE emulation with FILEIO and IBLOCK subsystem plugins. (hch assist)
	   
A big thanks (again) to hch, jaxboe, and everyone involved in this release
for their very gracious help and feedback!

Best,

--nab

Nicholas Bellinger (33):
  tcm: Add __module_get() and module_put() calls to se_core_add_hba()
    and se_core_shutdown_hba()
  tcm_loop: Fix NULL pointer dereference in tcm_loop_queuecommand()
  tcm: Make se_core_add_hba() use try_module_get() for struct
    se_subsystem_api->sub_owner
  tcm: Fix non-existent TPG LUN OOPs in target_fabric_mappedlun_link()
  tcm: Merge struct se_subsystem_spc into struct se_subsystem_api and
    convert subsystem plugins
  tcm/fileio: Remove fd_seek() usage for local scope loff_t usase
  tcm/pscsi: Remove pscsi_create_virtdevice_from_fd() usage
  tcm/pscsi: Remove legacy LINUX_VPD_PAGE_CHECK logic
  tcm/pscsi: Remove internal TYPE_DISK
    linux_blockdevice_[claim,release]() usage
  tcm/iblock: Fix NULL struct iblock_dev->ibd_bd case in
    iblock_free_device()
  tcm/pscsi: Fix NULL struct pscsi_dev_virt->pdv_bd case for TYPE_DISK
    in pscsi_free_device()
  tcm/pscsi: Remove remaining struct scsi_disk references
  tcm/ramdisk: Fix NULL pointer dereference in rd_DIRECT_free_DMA()
  tcm: Convert transport_map_sg_to_mem() to use sg_next()
  tcm: Remove *task_offset_in parameter from
    transport_generic_get_cdb_count()
  tcm: Minor naming cleanup for dev_obj_do_se_mem_map()
  tcm: Remove task_offset parameter from transport_map_sg_to_mem()
  tcm: Make transport_calc_sg_num() properly handle task_offset
  tcm: Make transport_map_mem_to_sg() properly handle task_offset
  tcm: Remove legacy transport_map_mem_to_mem()
  tcm: Remove remaining code out of target_core_seobj.c
  tcm: Remove legacy struct se_lun->lun_type_ptr
  tcm/iblock: Add SCSI LBA -> block_lba conversion for non 512-byte
    block_size
  tcm/iblock: Convert iblock_map_task_SG() to use for_each_sg()
  tcm: Add Documentation/target/tcm_mod_builder.py script and
    mini-HOWTO
  tcm: Add WriteCache and FUADPO infrastructure and attributes
  tcm: Add SYNCHRONIZE_CACHE* CDB infrastructure and emulation
  tcm: Add WriteCache and DPOFUA emulation bits to MODE_SENSE
  tcm/fileio: Add WriteCache and Forced Unit Access WRITE emulation
  tcm/fileio: Remove struct se_subsystem_api->do_sync_cache() usage
  tcm: Remove struct se_subsystem_api->do_sync_cache()
  tcm/iblock: Add WriteCache and Forced Unit Access WRITE emulation
  lio-core v4.0.0-rc3

 Documentation/target/tcm_mod_builder.py          | 1039 ++++++++++++++++++++++
 Documentation/target/tcm_mod_builder.txt         |  138 +++
 drivers/target/Kbuild                            |    1 -
 drivers/target/lio-target/iscsi_target_mib.c     |    8 +-
 drivers/target/lio-target/iscsi_target_version.h |    2 +-
 drivers/target/target_core_alua.c                |    6 +-
 drivers/target/target_core_configfs.c            |   17 +-
 drivers/target/target_core_device.c              |  170 ++++-
 drivers/target/target_core_fabric_configfs.c     |   14 +-
 drivers/target/target_core_file.c                |  249 ++++--
 drivers/target/target_core_hba.c                 |   29 +
 drivers/target/target_core_iblock.c              |  219 ++++--
 drivers/target/target_core_iblock.h              |    1 +
 drivers/target/target_core_mib.c                 |    8 +-
 drivers/target/target_core_pscsi.c               |  484 +---------
 drivers/target/target_core_pscsi.h               |    1 +
 drivers/target/target_core_rd.c                  |   47 +-
 drivers/target/target_core_seobj.c               |  215 -----
 drivers/target/target_core_seobj.h               |   47 -
 drivers/target/target_core_stgt.c                |   32 +-
 drivers/target/target_core_tpg.c                 |   15 +-
 drivers/target/target_core_transport.c           |  758 +++++++++-------
 drivers/target/tcm_loop/tcm_loop_fabric_scsi.c   |   11 +-
 include/target/target_core_base.h                |   14 +-
 include/target/target_core_device.h              |   10 +
 include/target/target_core_transport.h           |   99 ++-
 26 files changed, 2336 insertions(+), 1298 deletions(-)
 create mode 100755 Documentation/target/tcm_mod_builder.py
 create mode 100644 Documentation/target/tcm_mod_builder.txt
 delete mode 100644 drivers/target/target_core_seobj.c
 delete mode 100644 drivers/target/target_core_seobj.h


