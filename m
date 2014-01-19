From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 00/17] target: Add support for DIF Type1+Type3 emulation + passthrough
Date: Sun, 19 Jan 2014 02:44:23 +0000
Message-ID: <1390099480-29013-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:44502 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813AbaASDFQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Jan 2014 22:05:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Roland Dreier <roland@kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi MKP & Co,

This -v2 series contains support for target mode DIF Type1+Type3
emulation within target core, FILEIO, and RAMDISK_MCP device backends,
BIP passthrough of T10 PI within IBLOCK device backends, and DIF/DIX
host support in the tcm_loop fabric driver.

DIF emulation is enabled via a new 'pi_prot_type' device attribute
within configfs for FILEIO + RAMDISK_MCP, which is set after initial
device configuration and before target fabric LUN export occurs.

For IBLOCK backends, protection support is automatically detected via
struct blk_integrity at configuration time, and no additional end-user
setup is required.

For FILEIO backends, format of protection information is exposed via
a new 'pi_prot_format' device attribute, that is used during initial
configuration to format a new $FILENAME.protection file containing
DIF Type1/Type3 style metadata.

Also, the DIF read/write verify emulation has been made generic enough
so it can be used by other backend drivers (eg: FILEIO), as well as
Type4 (16-byte PI) in the near future.

Here is the v1 -> v2 changelog:

  - Drop guard_type related definitions
  - Update target_prot_op + target_prot_ho definitions (Sagi)
  - Drop SCF_PROT + pi_prot_version flag
  - Add se_subsystem_api->format_prot() (Sagi)
  - Add hw_pi_prot_type device attribute
  - Make sbc_check_prot defined as static (Fengguang + Wei)
  - Remove unprotected READ/WRITE warning (mkp)
  - Populate cmd->prot_type + friends (Sagi)
  - Drop SCF_PROT usage
  - Select CRC_T10DIF for TARGET_CORE in Kconfig (Fengguang)
  - Drop IP checksum logic from sbc_dif_v1_verify (MKP)
  - Fix offset on app_tag = 0xffff in sbc_dif_verify_read()
  - Drop pi_guard_type + pi_prot_version related code (MKP)
  - Add pi_prot_format logic (Sagi)
  - Add ->free_prot callback in target_free_device
  - Add hw_pi_prot_type read-only attribute
  - Add target/iblock blk_integrity + BIP passthrough
  - Add target/file DIF protection init/format support
  - Add target/file DIF protection support to fd_execute_rw
  - Drop unused sg_table from rd_release_device_space (Wei)
  - Drop unused sg_table from rd_release_prot_space (Wei)
  - Drop rd_release_prot_space call from rd_free_device
  - Make rd_execute_rw() to u32 sectors count instead of sector_t

At this point the main TODO item remaining for v3.14 code is to determine
how best to propigate App/Guard/Reference Tag VERIFY failures back up
into IBLOCK device backend code.

MKP has an idea how to go about doing this that will be appearing as
a seperate SCSI-core + IBLOCK patch.

Thank you,

--nab

Nicholas Bellinger (17):
  target: Add DIF related base definitions
  target: Add DIF CHECK_CONDITION ASC/ASCQ exception cases
  target/sbc: Add DIF setup in sbc_check_prot + sbc_parse_cdb
  target/sbc: Add DIF TYPE1+TYPE3 read/write verify emulation
  target/spc: Add protection bit to standard INQUIRY output
  target/spc: Add protection related bits to INQUIRY EVPD=0x86
  target/sbc: Add P_TYPE + PROT_EN bits to READ_CAPACITY_16
  target/spc: Expose ATO bit in control mode page
  target/configfs: Expose protection device attributes
  target: Add protection SGLs to target_submit_cmd_map_sgls
  target/iblock: Add blk_integrity + BIP passthrough support
  target/file: Add DIF protection init/format support
  target/file: Add DIF protection support to fd_execute_rw
  target/rd: Refactor rd_build_device_space + rd_release_device_space
  target/rd: Add support for protection SGL setup + release
  target/rd: Add DIF protection into rd_execute_rw
  tcm_loop: Enable DIF/DIX modes in SCSI host LLD

 drivers/target/Kconfig                 |    2 +
 drivers/target/loopback/tcm_loop.c     |   12 +-
 drivers/target/target_core_configfs.c  |   12 ++
 drivers/target/target_core_device.c    |   89 +++++++++++
 drivers/target/target_core_file.c      |  256 +++++++++++++++++++++++++++++++-
 drivers/target/target_core_file.h      |    9 ++
 drivers/target/target_core_iblock.c    |   91 +++++++++++-
 drivers/target/target_core_internal.h  |    2 +
 drivers/target/target_core_rd.c        |  252 +++++++++++++++++++++++++------
 drivers/target/target_core_rd.h        |    4 +
 drivers/target/target_core_sbc.c       |  245 ++++++++++++++++++++++++++++++
 drivers/target/target_core_spc.c       |   27 ++++
 drivers/target/target_core_transport.c |   46 +++++-
 drivers/vhost/scsi.c                   |    2 +-
 include/target/target_core_backend.h   |    7 +
 include/target/target_core_base.h      |   47 ++++++
 include/target/target_core_fabric.h    |    3 +-
 17 files changed, 1052 insertions(+), 54 deletions(-)

-- 
1.7.10.4

