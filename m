From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 0/9] target: Add WRITE_STRIP + READ_INSERT support
Date: Sat, 28 Feb 2015 10:35:57 +0000
Message-ID: <1425119766-11878-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi MKP, Sagi, & Co,

This series adds support for internal WRITE_STRIP + READ_INSERT
DIX operations using existing target_core_sbc.c DIF emulation.

It's useful in order for T10-PI fabrics to interoperate between
backend devices that don't have protection available or enabled yet.
This should be able to be done both internally using target DIF
emulation, or by the fabric driver's own HBA/NIC hardware offloads
outside of target_core_mod code.

This series includes initial tcm_loop support using a new endpoint
'fabric_prot_type' configfs attribute, and is able to successful
register SCSI LUNs and process I/Os in TYPE1 mode against a FILEIO
backend with pi_prot_type=0 set.

Here's how it looks in action:

scsi host6: TCM_Loopback
scsi 6:0:1:0: Direct-Access     LIO-ORG  FILEIO           4.0 PQ: 0 ANSI: 5
sd 6:0:1:0: [sda] Enabling DIF Type 1 protection
sd 6:0:1:0: Attached scsi generic sg1 type 0
sd 6:0:1:0: [sda] 4194304 512-byte logical blocks: (2.14 GB/2.00 GiB)
sd 6:0:1:0: [sda] Write Protect is off
sd 6:0:1:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 6:0:1:0: [sda] Enabling DIX T10-DIF-TYPE1-CRC protection
sd 6:0:1:0: [sda] DIF application tag size 2
sd 6:0:1:0: [sda] Attached SCSI disk

root@scsi-mq:~# cat /sys/kernel/config/target/loopback/naa.6001405973efc183/tpgt_1/attrib/fabric_prot_type
1
root@scsi-mq:~# cat
/sys/kernel/config/target/core/fileio_1/tmpfile/attrib/pi_prot_type
0

Please review as v4.1 material.

Thank you,

--nab

Nicholas Bellinger (9):
  target: Convert DIF emulation to use cmd->prot_type
  target: Add protected fabric + unprotected device support
  target: Update SPC/SBC emulation for sess_prot_type
  target: Move cmd->prot_op check into target_check_write_prot
  target: Add internal WRITE_STRIP support
  target: Move cmd->prot_op check into target_check_read_prot
  target: Add internal READ_INSERT support
  target/file: Add checks for backend DIF emulation
  loopback: Add fabric_prot_type attribute support

 drivers/target/loopback/tcm_loop.c     | 51 ++++++++++++++++++++-
 drivers/target/loopback/tcm_loop.h     |  1 +
 drivers/target/target_core_file.c      |  8 ++--
 drivers/target/target_core_sbc.c       | 73 ++++++++++++++++++++++--------
 drivers/target/target_core_spc.c       | 14 +++---
 drivers/target/target_core_transport.c | 82 +++++++++++++++++++++++++++-------
 include/target/target_core_base.h      |  1 +
 include/target/target_core_fabric.h    |  8 ++++
 8 files changed, 191 insertions(+), 47 deletions(-)

-- 
1.9.1
