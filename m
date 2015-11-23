From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH] target: fix a case of data corruption during COMPARE_AND_WRITE
Date: Mon, 23 Nov 2015 17:46:32 +0100
Message-ID: <1448297192-24937-1-git-send-email-jengelh@inai.de>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: nab@linux-iscsi.org
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

target_core_sbc's compare_and_write functionality suffers from taking
data at the wrong memory location when writing a CAW request to disk.

Given the following sample LIO subtopology,

% targetcli ls /loopback/
o- loopback ................................. [1 Target]
  o- naa.6001405ebb8df14a ....... [naa.60014059143ed2b3]
    o- luns ................................... [2 LUNs]
      o- lun0 ................ [iblock/ram0 (/dev/ram0)]
      o- lun1 ................ [iblock/ram1 (/dev/ram1)]
% lsscsi -g
[3:0:1:0]    disk    LIO-ORG  IBLOCK           4.0   /dev/sdc   /dev/sg3
[3:0:1:1]    disk    LIO-ORG  IBLOCK           4.0   /dev/sdd   /dev/sg4

the following bug can be observed in Linux 4.3 and 4.4~rc1:

% perl -e 'print chr$_ for 0..255,reverse 0..255' >rand
% perl -e 'print "\0" x 512' >zero
% cat rand >/dev/sdd
% sg_compare_and_write -i rand -D zero --lba 0 /dev/sdd
% sg_compare_and_write -i zero -D rand --lba 0 /dev/sdd
Miscompare reported
% hexdump -Cn 512 /dev/sdd
00000000  0f 0e 0d 0c 0b 0a 09 08  07 06 05 04 03 02 01 00
00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
*
00000200

Rather than writing all-zeroes as instructed with the -D file, it
corrupts the data in the sector by splicing some of the original
bytes in. The page of the first entry of cmd->t_data_sg includes the
CDB, and sg->offset is set to a position past the CDB. I presume that
sg->offset is also the right choice to use for subsequent sglist
members.

Signed-off-by: Jan Engelhardt <jengelh@netitwork.de>
---
 The following changes since commit 8005c49d9aea74d382f474ce11afbbc7d7130bec:
  Linux 4.4-rc1 (2015-11-15 17:00:27 -0800)
 are available in the git repository at:
  git://git.inai.de/linux tcm
 for you to fetch changes up to 54d035e8349bdb547a4372ebe6a83710971052bb:
  target: fix a case of data corruption during COMPARE_AND_WRITE

 drivers/target/target_core_sbc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 0b4b2a6..dc51cdc 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -556,11 +556,11 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
 
 		if (block_size < PAGE_SIZE) {
 			sg_set_page(&write_sg[i], m.page, block_size,
-				    block_size);
+				    m.piter.sg->offset + block_size);
 		} else {
 			sg_miter_next(&m);
 			sg_set_page(&write_sg[i], m.page, block_size,
-				    0);
+				    m.piter.sg->offset);
 		}
 		len -= block_size;
 		i++;
-- 
2.4.3
