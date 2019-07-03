From: Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [PATCH 20/30] scsi: Use kmemdup rather than duplicating its implementation
Date: Wed,  3 Jul 2019 21:16:55 +0800
Message-ID: <20190703131655.25594-1-huangfq.daxian@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.com>, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, QLogic-Storage-Upstream@qlogic.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Fuqian Huang <huangfq.daxian@gmail.com>
List-Id: linux-scsi@vger.kernel.org

kmemdup is introduced to duplicate a region of memory in a neat way.
Rather than kmalloc/kzalloc + memset, which the programmer needs to
write the size twice (sometimes lead to mistakes), kmemdup improves
readability, leads to smaller code and also reduce the chances of mistakes.
Suggestion to use kmemdup rather than using kmalloc/kzalloc + memset.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/scsi/aic7xxx/aic79xx_core.c | 3 +--
 drivers/scsi/aic7xxx/aic7xxx_core.c | 3 +--
 drivers/scsi/myrb.c                 | 4 +---
 drivers/scsi/qla4xxx/ql4_os.c       | 7 ++-----
 4 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 7e5044bf05c0..f4bc88c50dcd 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -9442,10 +9442,9 @@ ahd_loadseq(struct ahd_softc *ahd)
 	if (cs_count != 0) {
 
 		cs_count *= sizeof(struct cs);
-		ahd->critical_sections = kmalloc(cs_count, GFP_ATOMIC);
+		ahd->critical_sections = kmemdup(cs_table, cs_count, GFP_ATOMIC);
 		if (ahd->critical_sections == NULL)
 			panic("ahd_loadseq: Could not malloc");
-		memcpy(ahd->critical_sections, cs_table, cs_count);
 	}
 	ahd_outb(ahd, SEQCTL0, PERRORDIS|FAILDIS|FASTMODE);
 
diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index a9d40d3b90ef..7ea4e45309ff 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -6907,10 +6907,9 @@ ahc_loadseq(struct ahc_softc *ahc)
 	if (cs_count != 0) {
 
 		cs_count *= sizeof(struct cs);
-		ahc->critical_sections = kmalloc(cs_count, GFP_ATOMIC);
+		ahc->critical_sections = kmemdup(cs_table, cs_count, GFP_ATOMIC);
 		if (ahc->critical_sections == NULL)
 			panic("ahc_loadseq: Could not malloc");
-		memcpy(ahc->critical_sections, cs_table, cs_count);
 	}
 	ahc_outb(ahc, SEQCTL, PERRORDIS|FAILDIS|FASTMODE);
 
diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index 539ac8ce4fcd..5e6b5e7ae93a 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -1658,14 +1658,12 @@ static int myrb_ldev_slave_alloc(struct scsi_device *sdev)
 	if (!ldev_info)
 		return -ENXIO;
 
-	sdev->hostdata = kzalloc(sizeof(*ldev_info), GFP_KERNEL);
+	sdev->hostdata = kmemdup(ldev_info, sizeof(*ldev_info), GFP_KERNEL);
 	if (!sdev->hostdata)
 		return -ENOMEM;
 	dev_dbg(&sdev->sdev_gendev,
 		"slave alloc ldev %d state %x\n",
 		ldev_num, ldev_info->state);
-	memcpy(sdev->hostdata, ldev_info,
-	       sizeof(*ldev_info));
 	switch (ldev_info->raid_level) {
 	case MYRB_RAID_LEVEL0:
 		level = RAID_LEVEL_LINEAR;
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 8c674eca09f1..8f8c64e5f02d 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -3559,21 +3559,18 @@ static int qla4xxx_copy_from_fwddb_param(struct iscsi_bus_flash_session *sess,
 	conn->port = le16_to_cpu(fw_ddb_entry->port);
 
 	options = le16_to_cpu(fw_ddb_entry->options);
-	conn->ipaddress = kzalloc(IPv6_ADDR_LEN, GFP_KERNEL);
+	conn->ipaddress = kmemdup(fw_ddb_entry->ip_addr, IPv6_ADDR_LEN, GFP_KERNEL);
 	if (!conn->ipaddress) {
 		rc = -ENOMEM;
 		goto exit_copy;
 	}
 
-	conn->redirect_ipaddr = kzalloc(IPv6_ADDR_LEN, GFP_KERNEL);
+	conn->redirect_ipaddr = kmemdup(fw_ddb_entry->tgt_addr, IPv6_ADDR_LEN, GFP_KERNEL);
 	if (!conn->redirect_ipaddr) {
 		rc = -ENOMEM;
 		goto exit_copy;
 	}
 
-	memcpy(conn->ipaddress, fw_ddb_entry->ip_addr, IPv6_ADDR_LEN);
-	memcpy(conn->redirect_ipaddr, fw_ddb_entry->tgt_addr, IPv6_ADDR_LEN);
-
 	if (test_bit(OPT_IPV6_DEVICE, &options)) {
 		conn->ipv6_traffic_class = fw_ddb_entry->ipv4_tos;
 
-- 
2.11.0
