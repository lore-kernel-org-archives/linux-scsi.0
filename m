From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 00/14] target: Initial support for DIF Type1+Type3 emulation
Date: Wed,  8 Jan 2014 20:15:43 +0000
Message-ID: <1389212157-14540-1-git-send-email-nab@daterainc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi MKP & SCSI folks,

This series contains initial support for target mode DIF Type1+Type3
emulation within target core, RAMDISK_MCP device backend, and tcm_loop
fabric driver.

DIF emulation is enabled via a new 'pi_prot_type' device attribute
within configfs, which is set after initial device configuration and
before target fabric LUN export occurs.

The DIF read/write verify emulation has been made generic enough so
it can be used by other backend drivers (eg: FILEIO), as well as
DIF v2 in the near future.  Also note that the majority of the logic
has been groked from existing scsi_debug.c code.

The current plan is to enable basic support for emulated backends with
tcm_loop for v3.14 code, and then move onto IBLOCK backend support
(that requires BLOCK layer changes), and then onto other more complex
fabric driver support + hardware offloads (iser-target that Sagi + Or
are currently working on) and DIF support into KVM guest using
virtio-scsi + vhost-scsi.

Here is a quick snippet of the code in action with v3.13-rc3:

[  846.774085] scsi8 : TCM_Loopback
[  846.778044] scsi 8:0:1:0: Direct-Access     LIO-ORG  RAMDISK-MCP      4.0 PQ: 0 ANSI: 5
[  846.780160] init_tag_map: adjusted depth to 256
[  846.781309] init_tag_map: adjusted depth to 256
[  846.782424] init_tag_map: adjusted depth to 256
[  846.783685] sd 8:0:1:0: Attached scsi generic sg1 type 0
[  846.783923] sd 8:0:1:0: [sda] Enabling DIF Type 1 protection
[  846.783929] sd 8:0:1:0: [sda] 2097152 512-byte logical blocks: (1.07 GB/1.00 GiB)
[  846.784111] sd 8:0:1:0: [sda] Write Protect is off
[  846.784114] sd 8:0:1:0: [sda] Mode Sense: 43 00 00 08
[  846.784157] sd 8:0:1:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  846.785357]  sda: unknown partition table
[  846.795464] sd 8:0:1:0: [sda] Enabling DIX T10-DIF-TYPE1-CRC protection
[  846.797278] sd 8:0:1:0: [sda] DIF application tag size 2
[  846.798951] sd 8:0:1:0: [sda] Attached SCSI disk

<First 4k WRITE_10 performing Host Generate + Target Verify>

[  901.477786] Entering sd_dif_type1_generate >>>>>>>>>>>>>>>
[  901.477809] SD TYPE1 Generate: sector: 0 guard_tag: 0x5fd1 app_tag: 0x0000 ref_tag: 0
[  901.477823] SD TYPE1 Generate: sector: 1 guard_tag: 0x41de app_tag: 0x0000 ref_tag: 1
[  901.477835] SD TYPE1 Generate: sector: 2 guard_tag: 0x27b1 app_tag: 0x0000 ref_tag: 2
[  901.477848] SD TYPE1 Generate: sector: 3 guard_tag: 0xeb4c app_tag: 0x0000 ref_tag: 3
[  901.477860] SD TYPE1 Generate: sector: 4 guard_tag: 0x5d81 app_tag: 0x0000 ref_tag: 4
[  901.477872] SD TYPE1 Generate: sector: 5 guard_tag: 0xda61 app_tag: 0x0000 ref_tag: 5
[  901.477884] SD TYPE1 Generate: sector: 6 guard_tag: 0x80df app_tag: 0x0000 ref_tag: 6
[  901.477896] SD TYPE1 Generate: sector: 7 guard_tag: 0x5ede app_tag: 0x0000 ref_tag: 7
[  901.477940] sd_prep_fn: CDB: 0x2a blk_integrity_rq(rq): 1
[  901.481576] DIF WRITE sector: 0 guard_tag: 0x5fd1 app_tag: 0x0000 ref_tag: 0
[  901.481591] DIF WRITE sector: 1 guard_tag: 0x41de app_tag: 0x0000 ref_tag: 1
[  901.481615] DIF WRITE sector: 2 guard_tag: 0x27b1 app_tag: 0x0000 ref_tag: 2
[  901.481637] DIF WRITE sector: 3 guard_tag: 0xeb4c app_tag: 0x0000 ref_tag: 3
[  901.481649] DIF WRITE sector: 4 guard_tag: 0x5d81 app_tag: 0x0000 ref_tag: 4
[  901.481661] DIF WRITE sector: 5 guard_tag: 0xda61 app_tag: 0x0000 ref_tag: 5
[  901.481673] DIF WRITE sector: 6 guard_tag: 0x80df app_tag: 0x0000 ref_tag: 6
[  901.481685] DIF WRITE sector: 7 guard_tag: 0x5ede app_tag: 0x0000 ref_tag: 7

<Subsequent 4k READ_10 performing Target Verify + Host Verify>

[  901.522883] sd_prep_fn: CDB: 0x28 blk_integrity_rq(rq): 1
[  901.528637] DIF READ sector: 0 guard_tag: 0x5fd1 app_tag: 0x0000 ref_tag: 0
[  901.528655] DIF READ sector: 1 guard_tag: 0x41de app_tag: 0x0000 ref_tag: 1
[  901.528667] DIF READ sector: 2 guard_tag: 0x27b1 app_tag: 0x0000 ref_tag: 2
[  901.528679] DIF READ sector: 3 guard_tag: 0xeb4c app_tag: 0x0000 ref_tag: 3
[  901.528691] DIF READ sector: 4 guard_tag: 0x5d81 app_tag: 0x0000 ref_tag: 4
[  901.528703] DIF READ sector: 5 guard_tag: 0xda61 app_tag: 0x0000 ref_tag: 5
[  901.528715] DIF READ sector: 6 guard_tag: 0x80df app_tag: 0x0000 ref_tag: 6
[  901.528727] DIF READ sector: 7 guard_tag: 0x5ede app_tag: 0x0000 ref_tag: 7
[  901.528788] Entering bio_integrity_verify sector: 0 >>>>>>>>>>>>>>>>>>>>>>>
[  901.535807] bio_integrity_verify: bio->bi_idx: 1 bio->bi_vcnt: 1
[  901.538222] SD TYPE1 Verify sector: 0 guard_tag: 0x5fd1 app_tag: 0x0000 ref_tag: 0
[  901.538226] SD TYPE1 Verify sector: 1 guard_tag: 0x41de app_tag: 0x0000 ref_tag: 1
[  901.538230] SD TYPE1 Verify sector: 2 guard_tag: 0x27b1 app_tag: 0x0000 ref_tag: 2
[  901.538234] SD TYPE1 Verify sector: 3 guard_tag: 0xeb4c app_tag: 0x0000 ref_tag: 3
[  901.538238] SD TYPE1 Verify sector: 4 guard_tag: 0x5d81 app_tag: 0x0000 ref_tag: 4
[  901.538241] SD TYPE1 Verify sector: 5 guard_tag: 0xda61 app_tag: 0x0000 ref_tag: 5
[  901.538245] SD TYPE1 Verify sector: 6 guard_tag: 0x80df app_tag: 0x0000 ref_tag: 6
[  901.538248] SD TYPE1 Verify sector: 7 guard_tag: 0x5ede app_tag: 0x0000 ref_tag: 7

Please review as v3.14-rc1 code.

Thank you,

--nab

Nicholas Bellinger (14):
  target: Add DIF related base definitions
  target: Add DIF CHECK_CONDITION ASC/ASCQ exception cases
  target/sbc: Add sbc_check_prot + update sbc_parse_cdb for DIF
  target/sbc: Add DIF TYPE1+TYPE3 read/write verify emulation
  target/spc: Add protection bit to standard INQUIRY output
  target/spc: Add protection related bits to INQUIRY EVPD=0x86
  target/sbc: Add P_TYPE + PROT_EN bits to READ_CAPACITY_16
  target/spc: Expose ATO bit in control mode page
  target/configfs: Expose protection device attributes
  target: Add protection SGLs to target_submit_cmd_map_sgls
  target/rd: Refactor rd_build_device_space + rd_release_device_space
  target/rd: Add support for protection SGL setup + release
  target/rd: Add DIF protection into rd_execute_rw
  tcm_loop: Enable DIF/DIX modes in SCSI host LLD

 drivers/target/loopback/tcm_loop.c     |   12 +-
 drivers/target/target_core_configfs.c  |   12 ++
 drivers/target/target_core_device.c    |   65 ++++++++
 drivers/target/target_core_internal.h  |    2 +
 drivers/target/target_core_rd.c        |  264 ++++++++++++++++++++++++++------
 drivers/target/target_core_rd.h        |    4 +
 drivers/target/target_core_sbc.c       |  224 +++++++++++++++++++++++++++
 drivers/target/target_core_spc.c       |   27 ++++
 drivers/target/target_core_transport.c |   46 +++++-
 drivers/vhost/scsi.c                   |    2 +-
 include/target/target_core_backend.h   |    6 +
 include/target/target_core_base.h      |   62 ++++++++
 include/target/target_core_fabric.h    |    3 +-
 13 files changed, 678 insertions(+), 51 deletions(-)

-- 
1.7.10.4
