Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAF97C63719
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Dec 2022 11:03:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbiLHLD3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Dec 2022 06:03:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbiLHLCH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Dec 2022 06:02:07 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 269ED813BE;
        Thu,  8 Dec 2022 03:01:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1670497260; x=1702033260;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7OOLcX2+vM155WgZyxnafA0YBJsvwJzjjqumba4e+eQ=;
  b=WCKLu4rpPWjAgM22gohlf2I1/RiyGRA//4FNtc2rHoPVSXYNJ7gjR/Cq
   hiPBU0xpSnNmlVlXGGkl6HHt+2gS8Zp9LsPPBTiBk/FU0CDjsZEP9M0Sn
   ds66Dza7BRZ1ovzp//0NHVsMgr8fHz8VzcLw0gEvG9ryzxcCrJPm4xuvo
   vW01mgkUOF+lgbzunLe++RbjfgL/qLfb6eOzJpiJp2zjoQM12YsVokVZJ
   ipar2OwlIQ7v2KYpBLgWaEJWc8XgcAK0fO9QtR+9xPLVuS0BmgJbGgrQ7
   10zCAygtKseeOnTg7x1TgtQnyguJazTBGMo/LY4WjV+XlEiJCLFKAlW2b
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,227,1665417600"; 
   d="scan'208";a="223333379"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Dec 2022 19:00:59 +0800
IronPort-SDR: gunyvR74Zdxnge1ER/wX0QtcLGHBNpzrWBrZp843BBn/f86H0Ug9NWqK1fkhVmY10J5dZSnd8h
 HVou8nLMjAmZT6xe9tZKJU4gGm61Ig2ghbmj20KzjfUmZky8Ld5kPXJhPrlVKHr4H9onjKQ/GX
 bTLY68VFZBHsTiGxdJz3kmPE2uKxEENU6RUPvG9hfsrgfn2sjZqrXYqz0r90NhXWnZurmGwtlR
 WECsmUMArNuLgHp4KPJjLPOEQRAF7CI+d65ya7szLOuZ35NVM/78YyepsvJoTLRDXySHxgnfUC
 f8g=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Dec 2022 02:13:45 -0800
IronPort-SDR: 85QCEAkcwvB4LVbsz1/iBs+GUc6b2Z+vpDwOKzBUOVLgRf/Kg3TQXOIJB5+YhtUWG3+gc5aCOt
 9ldbNYUkSHM6u6rPzYcoTxj2th8k1avw3cV5HsA9ZADL4CI7V1vTYyURuZs0Wgn2iUIkGmSo29
 oFVdCyfRsT6XP1lvHi5vZu4nxPoGepYiBOWHEEN/MaGjlCDe9M4t54O/BRr1H984bfET9I/E43
 LLN+ZHbZiZWe7XAEbIOfEMC4dvZNiuVEO9Elg5T8PzdtqB5z+oWcsp37T9sO/OOi34V9HtuQno
 2Jc=
WDCIronportException: Internal
Received: from dellx5.wdc.com (HELO x1-carbon.cphwdc) ([10.200.210.81])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Dec 2022 03:00:59 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        Niklas Cassel <niklas.cassel@wdc.com>,
        linux-ide@vger.kernel.org
Subject: [PATCH 07/25] ata: libata: allow ata_eh_request_sense() to not set CHECK_CONDITION
Date:   Thu,  8 Dec 2022 11:59:23 +0100
Message-Id: <20221208105947.2399894-8-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221208105947.2399894-1-niklas.cassel@wdc.com>
References: <20221208105947.2399894-1-niklas.cassel@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Current ata_eh_request_sense() calls ata_scsi_set_sense() with
check_condition always set to true, which, in addition to setting the
sense data, unconditionally sets the scsicmd->result to
SAM_STAT_CHECK_CONDITION.

For Command Duration Limits policy 0xD:
The device shall complete the command without error (SAM_STAT_GOOD)
with the additional sense code set to DATA CURRENTLY UNAVAILABLE.

It is perfectly fine to have sense data for a command that returned
completion without error.

In order to support for CDL policy 0xD, we have to remove this
assumption that having sense data means that the command failed
(SAM_STAT_CHECK_CONDITION).

Add a new parameter to ata_eh_request_sense() to allow us to request
sense data without unconditionally setting SAM_STAT_CHECK_CONDITION.
This new parameter will be used in a follow-up patch.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 drivers/ata/libata-eh.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index c278366370ab..e05d62791e08 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1392,6 +1392,7 @@ unsigned int atapi_eh_tur(struct ata_device *dev, u8 *r_sense_key)
 /**
  *	ata_eh_request_sense - perform REQUEST_SENSE_DATA_EXT
  *	@qc: qc to perform REQUEST_SENSE_SENSE_DATA_EXT to
+ *	@check_condition: if SAM_STAT_CHECK_CONDITION should get set
  *
  *	Perform REQUEST_SENSE_DATA_EXT after the device reported CHECK
  *	SENSE.  This function is an EH helper.
@@ -1399,7 +1400,8 @@ unsigned int atapi_eh_tur(struct ata_device *dev, u8 *r_sense_key)
  *	LOCKING:
  *	Kernel thread context (may sleep).
  */
-static void ata_eh_request_sense(struct ata_queued_cmd *qc)
+static void ata_eh_request_sense(struct ata_queued_cmd *qc,
+				 bool check_condition)
 {
 	struct scsi_cmnd *cmd = qc->scsicmd;
 	struct ata_device *dev = qc->dev;
@@ -1429,8 +1431,8 @@ static void ata_eh_request_sense(struct ata_queued_cmd *qc)
 	/* Ignore err_mask; ATA_ERR might be set */
 	if (tf.status & ATA_SENSE) {
 		if (ata_scsi_sense_is_valid(tf.lbah, tf.lbam, tf.lbal)) {
-			ata_scsi_set_sense(dev, cmd, true, tf.lbah, tf.lbam,
-					   tf.lbal);
+			ata_scsi_set_sense(dev, cmd, check_condition, tf.lbah,
+					   tf.lbam, tf.lbal);
 			qc->flags |= ATA_QCFLAG_SENSE_VALID;
 		}
 	} else {
@@ -1587,7 +1589,7 @@ static unsigned int ata_eh_analyze_tf(struct ata_queued_cmd *qc)
 		 *  (i.e. NCQ autosense is not supported by the device).
 		 */
 		if (!(qc->flags & ATA_QCFLAG_SENSE_VALID) && (stat & ATA_SENSE))
-			ata_eh_request_sense(qc);
+			ata_eh_request_sense(qc, true);
 		if (err & ATA_ICRC)
 			qc->err_mask |= AC_ERR_ATA_BUS;
 		if (err & (ATA_UNC | ATA_AMNF))
-- 
2.38.1

