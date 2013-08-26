From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 0/9] target: Add support for EXTENDED_COPY (VAAI) offload emulation
Date: Mon, 26 Aug 2013 22:02:59 +0000
Message-ID: <1377554588-28394-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:33405 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab3HZWTN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Aug 2013 18:19:13 -0400
Received: by mail-oa0-f43.google.com with SMTP id i10so4376705oag.2
        for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 15:19:12 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Martin Petersen <martin.petersen@oracle.com>, Chris Mason <chris.mason@fusionio.com>, Roland Dreier <roland@purestorage.com>, Zach Brown <zab@redhat.com>, Kent Overstreet <kmo@daterainc.com>, Theodore Tso <tytso@mit.edu>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Nicholas Bellinger <nab@daterainc.com>

From: Nicholas Bellinger <nab@daterainc.com>

Hi folks,

This -v2 series adds support to target-core for generic EXTENDED_COPY offload
emulation as defined by SPC-4 using virtual (IBLOCK, FILEIO, RAMDISK)
backends.

EXTENDED_COPY is a VMWare ESX VAAI primative that is used to perform copy
offload, that allows a target to perform local READ + WRITE I/O requests
for bulk data transfers (cloning a virtual machine for example), instead
of requiring these I/Os to actually be sent to/from the requesting SCSI
initiator port.

This implemenation fully supports copy offload between the same device
backend, and across multiple device backends.  It supports copy offload
transparently across multiple target ports of different fabrics, eg:
iSCSI -> FC, FC -> iSER, iSER -> FCoE and so on.

It also supports both PUSH and PULL models of operation, so the actual
EXTENDED_COPY CDB may be received on either source or destination logical
unit.

For Target Descriptors, it currently supports the NAA IEEE Registered
Extended designator (type 0xe4), which allows the reference of target
ports to occur independent of fabric type using EVPD 0x83 WWNs.  For
Segment Descriptors, it currently supports copy from block to block
(0x02) mode.

The v2 changes include:

  - Use target_alloc_sgl() instead of transport_generic_get_mem()
  - Convert debug output to use pr_debug()
  - Convert target_xcopy_parse_target_descriptors() NAA IEE WWN
    dump to use 0x%16phN format specification
  - Drop unnecessary xcopy_pt_cmd->xpt_passthrough_wsem, and
    associated usage in xcopy_pt_write_pending() and
    target_xcopy_issue_pt_cmd()
  - Add check for unsupported EXTENDED_COPY(LID4) service action
    bits in target_do_xcopy()
 
Here's a quick snippet of the code in action with sg_xcopy performing
copy offload between two IBLOCK and FILEIO backends:

[  644.638215] Processing XCOPY with list_id: 0x00 list_id_usage: 0x10 tdll: 64 sdll: 28 inline_dl: 0
[  644.648227] XCOPY 0xe4: RELATIVE INITIATOR PORT IDENTIFIER: 0
[  644.654639] XCOPY 0xe4: desig_len: 16
[  644.658722] XCOPY 0xe4: Set xop->src_dev ffff88045d770000 from source received xop
[  644.667179] XCOPY 0xe4: RELATIVE INITIATOR PORT IDENTIFIER: 0
[  644.673597] XCOPY 0xe4: desig_len: 16
[  644.677699] XCOPY 0xe4: Setting xop->dst_dev: ffff88045d771048 from located se_dev
[  644.686297] Called configfs_depend_item for subsys: ffffffffa00f2570 se_dev: ffff88045d771048 se_dev->se_dev_group: ffff88045d7714f8
[  644.699607] XCOPY TGT desc: Source dev: ffff88045d770000 NAA IEEE WWN: 0x6001405d2e0745b08564acea3ca401e5
[  644.710296] XCOPY TGT desc: Dest dev: ffff88045d771048 NAA IEEE WWN: 0x60014056da9d8672d4b437596ab764b3
[  644.720782] XCOPY: Processed 2 target descriptors, length: 64
[  644.727203] XCOPY seg desc 0x02: desc_len: 24 stdi: 0 dtdi: 1, DC: 2
[  644.734304] XCOPY seg desc 0x02: nolb: 1 src_lba: 0 dst_lba: 0
[  644.740819] XCOPY seg desc 0x02: DC=1 w/ dbl: 0
[  644.745881] XCOPY: Processed 1 segment descriptors, length: 28
[  644.752402] target_xcopy_do_work: nolb: 1, max_nolb: 1024 end_lba: 1
[  644.759504] target_xcopy_do_work: Starting src_lba: 0, dst_lba: 0
[  644.766303] target_xcopy_do_work: Calling read src_dev: ffff88045d770000 src_lba: 0, cur_nolb: 1
[  644.776115] XCOPY: Built READ_16: LBA: 0 Sectors: 1 Length: 512
[  644.782751] Honoring local SRC port from ec_cmd->se_dev: ffff88045d770000
[  644.790335] Honoring local SRC port from ec_cmd->se_lun: ffff88085a1977e0
[  644.797921] XCOPY-READ: Saved xop->xop_data_sg: ffff880459d3e3a8, num: 1 for READ memory
[  644.807203] target_xcopy_issue_pt_cmd(): SCSI status: 0x00
[  644.813333] target_xcopy_do_work: Incremented READ src_lba to 1
[  644.819947] target_xcopy_do_work: Calling write dst_dev: ffff88045d771048 dst_lba: 0, cur_nolb: 1
[  644.829854] XCOPY: Built WRITE_16: LBA: 0 Sectors: 1 Length: 512
[  644.836568] Setup emulated se_dev: ffff88045d771048 from se_dev
[  644.843185] Setup emulated se_dev: ffff88045d771048 to pt_cmd->se_lun->lun_se_dev
[  644.851545] Setup emulated remote DEST xcopy_pt_port: ffffffffa00f7610 to cmd->se_lun->lun_sep for X-COPY data PUSH
[  644.863198] Setup PASSTHROUGH_NOALLOC t_data_sg: ffff880459d3e3a8 t_data_nents: 1
[  644.895203] target_xcopy_issue_pt_cmd(): SCSI status: 0x00
[  644.901332] target_xcopy_do_work: Incremented WRITE dst_lba to 1
[  644.908044] Calling configfs_undepend_item for subsys: ffffffffa00f2570 remote_dev: ffff88045d771048 remote_dev->dev_group: ffff88045d7714f8
[  644.922129] target_xcopy_do_work: Final src_lba: 1, dst_lba: 1
[  644.928646] target_xcopy_do_work: Blocks copied: 1, Bytes Copied: 512
[  644.935840] target_xcopy_do_work: Setting X-COPY GOOD status -> sending response

For all intensive purposes this code is completely standalone, and the amount
of changes required to enable it's function within target-core code is small.

Please review as v3.12 material.

Nicholas Bellinger (9):
  target: Make target_core_subsystem defined as non static
  target: Make spc_parse_naa_6h_vendor_specific non static
  target: Make helpers non static for EXTENDED_COPY command setup
  target: Add global device list for EXTENDED_COPY
  target: Avoid non-existent tg_pt_gp_mem in target_alua_state_check
  target: Add support for EXTENDED_COPY copy offload emulation
  target: Enable EXTENDED_COPY setup in spc_parse_cdb
  target: Add Third Party Copy (3PC) bit in INQUIRY response
  target: Enable global EXTENDED_COPY setup/release

 drivers/target/Makefile                |    3 +-
 drivers/target/target_core_alua.c      |    3 +
 drivers/target/target_core_configfs.c  |   12 +-
 drivers/target/target_core_device.c    |   27 +
 drivers/target/target_core_internal.h  |    1 +
 drivers/target/target_core_spc.c       |   20 +-
 drivers/target/target_core_transport.c |    4 +-
 drivers/target/target_core_xcopy.c     | 1082 ++++++++++++++++++++++++++++++++
 drivers/target/target_core_xcopy.h     |   62 ++
 include/target/target_core_backend.h   |    4 +
 include/target/target_core_base.h      |    5 +
 11 files changed, 1215 insertions(+), 8 deletions(-)
 create mode 100644 drivers/target/target_core_xcopy.c
 create mode 100644 drivers/target/target_core_xcopy.h

-- 
1.7.2.5

