Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68E9AC00143
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Aug 2021 09:03:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 501C860F39
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Aug 2021 09:03:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233014AbhHBJDQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Aug 2021 05:03:16 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:6555 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232814AbhHBJCv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Aug 2021 05:02:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1627894960; x=1659430960;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9Tbl+ZYaDpBVRwr+peFFdheaVaDWXB+rHBnYavgl5IE=;
  b=aRQKvT3wkohCNbiKz8YBELHTGpHVPGwSh9LMoJ7+3CDPjYwCArqG16I7
   G+qeDQcvf4jfmDQ9yzpSAmXnI461zroCJls8co1KDvAD/5JVlU+iZ7qz+
   P/YNvs9fwJQ+HthNxvmMniYdXJ45ay3fZFiRr1AxwEGCDyK0GWNkD4Bc+
   pN/NwNKvR2xh4t29O3Opwx8xUuVUJoJc4HphWk+LOPSWHeGo4cIghyg66
   wAa3HuFRyMF8uXxF/zP/4ZEFj5LmIIF9+CqQecL1rL61YX1GM3Rt2IEKC
   rvoDIcvddL0iiVqQZAmYuEJt8VKk+eltd+q5kmfvzsHmRR5rJxObCuvIw
   w==;
X-IronPort-AV: E=Sophos;i="5.84,288,1620662400"; 
   d="scan'208";a="180887620"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 02 Aug 2021 17:02:36 +0800
IronPort-SDR: yANogrtc5D0nQfqLUgtfbVPJg2KifXnMx+CLlcr0xspWers4iNI+nBKk9fKT7xBgfX8Ev568yV
 dmCYmuKxQYCTOcb83wB1fbDBzmn/BFZ0WUPL6S4YmjM3oxJtxvBVYHjPYlM+k+grsd3LA4rWSc
 KuWQ+iPZmQdA904pn259lUcm8kqlusNVaswk69jilQrmTsNw0u2hxuTSh9IRL/VZF7p1UKN2XZ
 9IWq4CJD2xLaX5EOg9tdkvKk+CdAWzv9jNdV0QevkANv72DsmSZ9nZ7pVAeX33c4u/FvZpI24t
 DT892Hu1Ylk17xpRLK0kuU+G
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2021 01:40:13 -0700
IronPort-SDR: UwxAmegxJfFLnLnYo0VM7dIKc3afNkMlH6hRsiMgHAqo3pLpFeBN29h9z/KipAKTX374yX0lDn
 bEFsV6On1RGDOLjL8JB2N3Lcg0iIaFM0EGbFx1+NbQjwjEPwtVdQQ90O4fKnw7bJvQNGVf6LkF
 nHTuTAw3Vh0OR1EvLujZ95z++3y8/2AMr2oOLBO8S5pyQYPoOVHtxbb+8gxcQxBaDK9PJeTlgd
 eMeo9VUL2j2aQWNyI3joGVS6x0hREYEZNVii3aILaOW/VKztBWgFIC/Rl1NexLieegcJ3izCos
 0J4=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 02 Aug 2021 02:02:38 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 3/7] libata: cleanup NCQ priority handling
Date:   Mon,  2 Aug 2021 18:02:28 +0900
Message-Id: <20210802090232.1166195-4-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210802090232.1166195-1-damien.lemoal@wdc.com>
References: <20210802090232.1166195-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The ata device flag ATA_DFLAG_NCQ_PRIO indicates if a device supports
the NCQ Priority feature while the ATA_DFLAG_NCQ_PRIO_ENABLE device
flag indicates if the feature is enabled. Enabling NCQ priority use is
controlled by the user through the device sysfs attribute
ncq_prio_enable. As a result, the ATA_DFLAG_NCQ_PRIO flag should not be
cleared when ATA_DFLAG_NCQ_PRIO_ENABLE is not set as the device still
supports the feature even after the user disables it. This leads to the
following cleanups:
- In ata_build_rw_tf(), set a command high priority bit based on the
  ATA_DFLAG_NCQ_PRIO_ENABLE flag, not on the ATA_DFLAG_NCQ flag. That
  is, set a command high priority only if the user enabled NCQ priority
  use.
- In ata_dev_config_ncq_prio(), ATA_DFLAG_NCQ_PRIO should not be cleared
  if ATA_DFLAG_NCQ_PRIO_ENABLE is not set. If the device does not
  support NCQ priority, both ATA_DFLAG_NCQ_PRIO and
  ATA_DFLAG_NCQ_PRIO_ENABLE must be cleared.

With the above ata_dev_config_ncq_prio() change, ATA_DFLAG_NCQ_PRIO flag
is set on device scan and revalidation. There is no need to trigger a
device revalidation in ata_ncq_prio_enable_store() when the user enables
the use of NCQ priority. Remove the revalidation code from that funciton
to simplify it. Also change the return value from -EIO to -EINVAL when a
user tries to enable NCQ priority for a device that does not support
this feature.  While at it, also simplify ata_ncq_prio_enable_show().

Overall, there is no functional change introduced by this patch.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/ata/libata-core.c | 32 ++++++++++++++------------------
 drivers/ata/libata-sata.c | 37 ++++++++++++-------------------------
 2 files changed, 26 insertions(+), 43 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 1849f858761b..21afb59f359f 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -706,11 +706,9 @@ int ata_build_rw_tf(struct ata_taskfile *tf, struct ata_device *dev,
 		if (tf->flags & ATA_TFLAG_FUA)
 			tf->device |= 1 << 7;
 
-		if (dev->flags & ATA_DFLAG_NCQ_PRIO) {
-			if (class == IOPRIO_CLASS_RT)
-				tf->hob_nsect |= ATA_PRIO_HIGH <<
-						 ATA_SHIFT_PRIO;
-		}
+		if (dev->flags & ATA_DFLAG_NCQ_PRIO_ENABLE &&
+		    class == IOPRIO_CLASS_RT)
+			tf->hob_nsect |= ATA_PRIO_HIGH << ATA_SHIFT_PRIO;
 	} else if (dev->flags & ATA_DFLAG_LBA) {
 		tf->flags |= ATA_TFLAG_LBA;
 
@@ -2173,11 +2171,6 @@ static void ata_dev_config_ncq_prio(struct ata_device *dev)
 	struct ata_port *ap = dev->link->ap;
 	unsigned int err_mask;
 
-	if (!(dev->flags & ATA_DFLAG_NCQ_PRIO_ENABLE)) {
-		dev->flags &= ~ATA_DFLAG_NCQ_PRIO;
-		return;
-	}
-
 	err_mask = ata_read_log_page(dev,
 				     ATA_LOG_IDENTIFY_DEVICE,
 				     ATA_LOG_SATA_SETTINGS,
@@ -2185,18 +2178,21 @@ static void ata_dev_config_ncq_prio(struct ata_device *dev)
 				     1);
 	if (err_mask) {
 		ata_dev_dbg(dev,
-			    "failed to get Identify Device data, Emask 0x%x\n",
+			    "failed to get SATA settings log, Emask 0x%x\n",
 			    err_mask);
-		return;
+		goto not_supported;
 	}
 
-	if (ap->sector_buf[ATA_LOG_NCQ_PRIO_OFFSET] & BIT(3)) {
-		dev->flags |= ATA_DFLAG_NCQ_PRIO;
-	} else {
-		dev->flags &= ~ATA_DFLAG_NCQ_PRIO;
-		ata_dev_dbg(dev, "SATA page does not support priority\n");
-	}
+	if (!(ap->sector_buf[ATA_LOG_NCQ_PRIO_OFFSET] & BIT(3)))
+		goto not_supported;
+
+	dev->flags |= ATA_DFLAG_NCQ_PRIO;
+
+	return;
 
+not_supported:
+	dev->flags &= ~ATA_DFLAG_NCQ_PRIO_ENABLE;
+	dev->flags &= ~ATA_DFLAG_NCQ_PRIO;
 }
 
 static int ata_dev_config_ncq(struct ata_device *dev,
diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index 8adeab76dd38..dc397ebda089 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -839,23 +839,17 @@ static ssize_t ata_ncq_prio_enable_show(struct device *device,
 					char *buf)
 {
 	struct scsi_device *sdev = to_scsi_device(device);
-	struct ata_port *ap;
+	struct ata_port *ap = ata_shost_to_port(sdev->host);
 	struct ata_device *dev;
 	bool ncq_prio_enable;
 	int rc = 0;
 
-	ap = ata_shost_to_port(sdev->host);
-
 	spin_lock_irq(ap->lock);
 	dev = ata_scsi_find_dev(ap, sdev);
-	if (!dev) {
+	if (!dev)
 		rc = -ENODEV;
-		goto unlock;
-	}
-
-	ncq_prio_enable = dev->flags & ATA_DFLAG_NCQ_PRIO_ENABLE;
-
-unlock:
+	else
+		ncq_prio_enable = dev->flags & ATA_DFLAG_NCQ_PRIO_ENABLE;
 	spin_unlock_irq(ap->lock);
 
 	return rc ? rc : snprintf(buf, 20, "%u\n", ncq_prio_enable);
@@ -869,7 +863,7 @@ static ssize_t ata_ncq_prio_enable_store(struct device *device,
 	struct ata_port *ap;
 	struct ata_device *dev;
 	long int input;
-	int rc;
+	int rc = 0;
 
 	rc = kstrtol(buf, 10, &input);
 	if (rc)
@@ -883,27 +877,20 @@ static ssize_t ata_ncq_prio_enable_store(struct device *device,
 		return  -ENODEV;
 
 	spin_lock_irq(ap->lock);
+
+	if (!(dev->flags & ATA_DFLAG_NCQ_PRIO)) {
+		rc = -EINVAL;
+		goto unlock;
+	}
+
 	if (input)
 		dev->flags |= ATA_DFLAG_NCQ_PRIO_ENABLE;
 	else
 		dev->flags &= ~ATA_DFLAG_NCQ_PRIO_ENABLE;
 
-	dev->link->eh_info.action |= ATA_EH_REVALIDATE;
-	dev->link->eh_info.flags |= ATA_EHI_QUIET;
-	ata_port_schedule_eh(ap);
+unlock:
 	spin_unlock_irq(ap->lock);
 
-	ata_port_wait_eh(ap);
-
-	if (input) {
-		spin_lock_irq(ap->lock);
-		if (!(dev->flags & ATA_DFLAG_NCQ_PRIO)) {
-			dev->flags &= ~ATA_DFLAG_NCQ_PRIO_ENABLE;
-			rc = -EIO;
-		}
-		spin_unlock_irq(ap->lock);
-	}
-
 	return rc ? rc : len;
 }
 
-- 
2.31.1

