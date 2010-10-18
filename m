From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [ANNOUNCE] TCM/LIO v4.0.0-rc5 for 2.6.36-rc8
Date: Mon, 18 Oct 2010 03:04:28 -0700
Message-ID: <1287396268.14039.120.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp104.sbc.mail.re3.yahoo.com ([66.196.96.80]:38518 "HELO
	smtp104.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753910Ab0JRKJR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Oct 2010 06:09:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Boaz Harrosh <bharrosh@panasas.com>, Joel Becker <joel.becker@oracle.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>

Greetings all,

It is my honor to announce that TCM/LIO v4.0.0-rc5 for v2.6.36-rc8 has
been tagged and pushed into lio-core-2.6.git/lio-4.0 on kernel.org.  It
has been almost exactly one month since v4.0.0-rc4 was released, and
development has continued to be quite busy as some of the new v4.0
emulation features are been shaken out on linux-scsi.  This released
includes the following major items:

	*) Add proper TCM/pSCSI BIDI-COMMAND passthrough (Boaz Harrosh assist)
	*) Allow MappedLUNs with non existent struct se_lun, which allowed
	   us to drop the struct config_group_operations->check_link() call
	   alltogether (Joel Becker assist)
	*) Add UNMAP and Block Limits VPD page support (Martin Petersen assist)
	*) Add Thin Provisioning VPD page emulation (Martin Petersen assist)
	*) Add proper extended CDB support with by default 32-bit CDBs.
	   (Martin Petersen and Boaz Harrosh assist)
	*) Add WRITE_SAME_16 and WRITE_SAME_32 w/ UNMAP-1 support (Martin Petersen assist)
	*) Add target_fabric_tf_ops_check() sanity checks at TCM fabric module
	   registration time
	*) Unify TCM subsysystem CDB emulation for INQUIRY, READ_CAPACITY*, UNMAP,
	   WRITE_SAME_* and SYNCHRONIZE_CACHE (Christoph Hellwig assist)
	*) Add struct se_dev_limits for subsystem ->create_virtdevice()
	   (Christoph Hellwig assist)

At this point I will be accepting bugfixes and other cleanups recommened
by community members to v4.0 for .37 mainline in the next two weeks, and
will be pushing new features bits into v4.1 for .38 as the remaining .37
items are resolved.

Once again, a big thanks go out to the community members involved in
this release.  Thank you!

--nab

Nicholas Bellinger (48):
  tcm: Convert split CDB code to put_unaligned_be*
  tcm: Add support for BIDI-COMMAND passthrough
  tcm/pscsi: Add proper BIDI-COMMAND passthrough to SCSI MidLayer
  tcm: Add XDWRITEREAD_10 passthrough support
  tcm: Convert VARIABLE_LENGTH_CMD to use scsi_varlen_cdb_length()
  tcm/fileio: Convert to iov allocations for fd_do_readv() and
    fd_do_writev()
  tcm: Allow MappedLUNs with non existent struct se_lun
  tcm: Drop unused target_fabric_port_check_link()
  tcm: Fix NULL pointer dereference for target_fabric_port_attrs[]
  tcm: Remove struct list_head lookup from
    core_dev_[add,del]_initiator_node_lun_acl()
  tcm: Add Thin Provisioning / UNMAP emulation and Block Limits VPD
    page
  tcm/iblock: Add UNMAP / Block DISCARD support
  tcm/fileio: Add UNMAP / Block DISCARD support
  tcm: Remove unnecessary typecasts in FILEIO, IBLOCK, pSCSI, RAMDISK
    and STGT subsystem plugins
  tcm: Fix incorrect data_length checks for Block Limits VPD page
    emulation
  tcm: Rename device attribute emulate_tpe to emulate_tpu
  tcm: Add Thin Provisioning VPD page emulation
  tcm/iblock,fileio: Fill in remaining Block Limits VPD from rq->limits
  tcm: Fix BIDI-Command bug with pSCSI passthrough
  tcm: Add support for CDBs greater than TCM_MAX_COMMAND_SIZE bytes
  tcm: Fix bug in *_subsystem set_configfs_dev_params() buffer copy
  tcm: Add WRITE_SAME_16 emulation and passthrough support
  tcm/iblock,fileio: Add WRITE_SAME_16 w/ UNMAP=1 bit support
  tcm: Minor cleanups for UNMAP debugging code
  tcm: Add support for SA WRITE_SAME_32
  tcm: Add missing TGCS_DATA_SG_IO_CDB assignment for XDWRITEREAD_32
  tcm: Remove legacy struct se_device->dev_generate_cdb()
  tcm: Remove unused struct target_core_fabric_ops->dev_del_lun()
  tcm: Add target_fabric_tf_ops_check() sanity checks
  tcm_loop: Add missing NOPs for struct target_core_fabric_ops
  tcm: Fix hardcoded size bug for struct
    se_transport_task->__t_task_cdb[]
  tcm: Unify subsystem plugin control CDB emulation
  tcm: Convert IBLOCK, FILEIO and RAMDISK subsystem code to
    transport_emulate_control_cdb()
  tcm: Move WRITE_SAME_* emulation into transport_emulate_control_cdb()
  tcm: Move SYNCHRONIZE_CACHE_* emulation into
    transport_emulate_control_cdb()
  tcm: Fix printk() + sector_t conversion spec build warning:
  tcm: Move transport_emulate_control_cdb() into
    __transport_execute_tasks()
  tcm: Unify INQUIRY subsystem plugin handling
  tcm: Unify READ_CAPACITY_* subsystem plugin handling
  tcm: Unify UNMAP and WRITE_SAME w/ UNMAP=1 subsystem plugin handling
  tcm: Unify SYNCHRONIZE_CACHE_* subsystem plugin handling
  tcm: Drop struct se_subsystem_api->create_virtdevice_from_fd()
  tcm: Convert UNMAP + WRITE_SAME_* to IBLOCK only support
  tcm/fileio: Drop igrab() and iput() usage
  tcm: Preload virtual backstore INQUIRY Product Model and Revision
  tcm/fileio: Drop unnecessary inode assignment conditional
  tcm: Add struct se_dev_limits for subsystem ->create_virtdevice()
  lio-core v4.0.0-rc5

 drivers/target/lio-target/iscsi_target_version.h |    2 +-
 drivers/target/target_core_configfs.c            |  259 ++++++--
 drivers/target/target_core_device.c              |  197 +++++--
 drivers/target/target_core_fabric_configfs.c     |   50 +-
 drivers/target/target_core_file.c                |  297 +++------
 drivers/target/target_core_iblock.c              |  380 +++--------
 drivers/target/target_core_pscsi.c               |  297 ++++++----
 drivers/target/target_core_pscsi.h               |    7 +-
 drivers/target/target_core_rd.c                  |  255 ++------
 drivers/target/target_core_scdb.c                |   57 +--
 drivers/target/target_core_stgt.c                |  107 +--
 drivers/target/target_core_tpg.c                 |    8 -
 drivers/target/target_core_transport.c           |  767 ++++++++++++++++++----
 drivers/target/tcm_loop/tcm_loop_configfs.c      |   10 +-
 drivers/target/tcm_loop/tcm_loop_fabric.c        |   23 +-
 drivers/target/tcm_loop/tcm_loop_fabric.h        |    9 +-
 include/target/target_core_base.h                |   31 +-
 include/target/target_core_device.h              |    9 +-
 include/target/target_core_fabric_ops.h          |    1 -
 include/target/target_core_transport.h           |   61 +-
 20 files changed, 1595 insertions(+), 1232 deletions(-)


