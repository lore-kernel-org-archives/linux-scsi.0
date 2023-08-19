Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF19AEE49A6
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Aug 2023 00:21:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbjHTAVO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Aug 2023 20:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbjHTAUm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Aug 2023 20:20:42 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D17ACDBAAC
        for <linux-scsi@vger.kernel.org>; Sat, 19 Aug 2023 14:30:53 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d6adc83eb10so2914077276.2
        for <linux-scsi@vger.kernel.org>; Sat, 19 Aug 2023 14:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692480653; x=1693085453;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ioX0pdqkRflpWbTw+qj+p6Veh+H84lgpwVPnZSVgPAQ=;
        b=WNmE+qvIBL3rNtHbrqlF5+tJwsqGIeAXHPVIMDovres4gZSyLQn8BMTdUEHTJKKjsA
         DN7UPxXm+n1sDxvxUHUALow532RG8736pac3x5DO7MkKQ72z0gx4yt0ehziFwk2OeL0+
         xVzHKvN4m0VCI0ONsWDALMc5ICRBAWXaWzRmSQMjEuOEzm6DVmj6MtzRw6nzo5RjJD5F
         HGQguyFzRVIpqIzjSnTMUEQko/WZ++ngOfvfToy0HMjoT+xfoI3mEKq/Q+eojCEqNF/7
         a6/8l43L4OtqkbCUvxTu1+oZLPqCfu71olOl2T2LG52UAVe2+fOrXHQB7cfBzMUJmaHq
         D2rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692480653; x=1693085453;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ioX0pdqkRflpWbTw+qj+p6Veh+H84lgpwVPnZSVgPAQ=;
        b=Zm/0pK0sfJH2xjw+gnvKRKKCLTxziBbOFNjtQdSfiX0VvYrqjKE0QJ+2OpfKYXXUgx
         LHJh8OqprxX9b+eD7kz0QCcqA03GlbYQDGfCGD+f8STwX2WQKqDSABSvrK0f/+FmcGqT
         1jIpBzTdACS5X+s+7zMng6lgdrCMvalY7iVrovkOHGjWenN/3js2M/pzcZmBOU+ZU/IX
         00lB3EMYncm62JbpaWOtwgW+vRn8QoScBnTadHWkSPpsyWnKC3S8J9gyU14NJeAusjpM
         1Y9p0JpPrL+8rd7cCuDeZvkHBsUCinCEKB1u0yR43B5N8eadX6rynSvA/JBjxKpQBIFS
         y0Fw==
X-Gm-Message-State: AOJu0Yz6s/g/h4YT49U4qzjb/inMXC7gPDK6OKzePpvHBrK+XFk1tPbn
        2Qhk+OzoL5QeCHxFT+toiV53gW1PN60MIQ==
X-Google-Smtp-Source: AGHT+IG2JIpfNwsH9wx0p/mzC2Ju99IGnsxTvqvn4e9IUixHyQwWEmBbuzVNsqAUbT8ovvbSRjT6kWcUQ6IUqw==
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:13:7789:3ff3:28cf:bae9])
 (user=ipylypiv job=sendgmr) by 2002:a25:cb17:0:b0:d71:36b5:e9ee with SMTP id
 b23-20020a25cb17000000b00d7136b5e9eemr23326ybg.8.1692480653096; Sat, 19 Aug
 2023 14:30:53 -0700 (PDT)
Date:   Sat, 19 Aug 2023 14:30:40 -0700
In-Reply-To: <20230819213040.1101044-1-ipylypiv@google.com>
Mime-Version: 1.0
References: <20230819213040.1101044-1-ipylypiv@google.com>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <20230819213040.1101044-3-ipylypiv@google.com>
Subject: [PATCH v2 2/2] scsi: pm80xx: Set RETFIS when requested by libsas
From:   Igor Pylypiv <ipylypiv@google.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Niklas Cassel <niklas.cassel@wdc.com>
Cc:     linux-scsi@vger.kernel.org, Jack Wang <jinpu.wang@cloud.ionos.com>,
        Igor Pylypiv <ipylypiv@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

By default PM80xx HBAs return FIS only when a drive reports an error.
The RETFIS bit forces the controller to populate FIS even when a drive
reports no error.

Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c |  9 ++++++---
 drivers/scsi/pm8001/pm8001_hwi.h |  2 +-
 drivers/scsi/pm8001/pm80xx_hwi.c | 24 +++++++++++-------------
 drivers/scsi/pm8001/pm80xx_hwi.h |  2 +-
 4 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 73cd25f30ca5..649724a1d134 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -4095,7 +4095,7 @@ static int pm8001_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 	u32 hdr_tag, ncg_tag = 0;
 	u64 phys_addr;
 	u32 ATAP = 0x0;
-	u32 dir;
+	u32 dir, retfis = 0;
 	u32  opc = OPC_INB_SATA_HOST_OPSTART;
 
 	memset(&sata_cmd, 0, sizeof(sata_cmd));
@@ -4124,8 +4124,11 @@ static int pm8001_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 	sata_cmd.tag = cpu_to_le32(tag);
 	sata_cmd.device_id = cpu_to_le32(pm8001_ha_dev->device_id);
 	sata_cmd.data_len = cpu_to_le32(task->total_xfer_len);
-	sata_cmd.ncqtag_atap_dir_m =
-		cpu_to_le32(((ncg_tag & 0xff)<<16)|((ATAP & 0x3f) << 10) | dir);
+	if (task->ata_task.return_fis_on_success)
+		retfis = 1;
+	sata_cmd.retfis_ncqtag_atap_dir_m =
+		cpu_to_le32((retfis << 24) | ((ncg_tag & 0xff) << 16) |
+			    ((ATAP & 0x3f) << 10) | dir);
 	sata_cmd.sata_fis = task->ata_task.fis;
 	if (likely(!task->ata_task.device_control_reg_update))
 		sata_cmd.sata_fis.flags |= 0x80;/* C=1: update ATA cmd reg */
diff --git a/drivers/scsi/pm8001/pm8001_hwi.h b/drivers/scsi/pm8001/pm8001_hwi.h
index 961d0465b923..fc2127dcb58d 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.h
+++ b/drivers/scsi/pm8001/pm8001_hwi.h
@@ -515,7 +515,7 @@ struct sata_start_req {
 	__le32	tag;
 	__le32	device_id;
 	__le32	data_len;
-	__le32	ncqtag_atap_dir_m;
+	__le32	retfis_ncqtag_atap_dir_m;
 	struct host_to_dev_fis	sata_fis;
 	u32	reserved1;
 	u32	reserved2;
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 39a12ee94a72..a5021577a15f 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4457,7 +4457,7 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 	u64 phys_addr, end_addr;
 	u32 end_addr_high, end_addr_low;
 	u32 ATAP = 0x0;
-	u32 dir;
+	u32 dir, retfis = 0;
 	u32 opc = OPC_INB_SATA_HOST_OPSTART;
 	memset(&sata_cmd, 0, sizeof(sata_cmd));
 
@@ -4487,7 +4487,8 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 	sata_cmd.tag = cpu_to_le32(tag);
 	sata_cmd.device_id = cpu_to_le32(pm8001_ha_dev->device_id);
 	sata_cmd.data_len = cpu_to_le32(task->total_xfer_len);
-
+	if (task->ata_task.return_fis_on_success)
+		retfis = 1;
 	sata_cmd.sata_fis = task->ata_task.fis;
 	if (likely(!task->ata_task.device_control_reg_update))
 		sata_cmd.sata_fis.flags |= 0x80;/* C=1: update ATA cmd reg */
@@ -4500,12 +4501,10 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 			   "Encryption enabled.Sending Encrypt SATA cmd 0x%x\n",
 			   sata_cmd.sata_fis.command);
 		opc = OPC_INB_SATA_DIF_ENC_IO;
-
-		/* set encryption bit */
-		sata_cmd.ncqtag_atap_dir_m_dad =
-			cpu_to_le32(((ncg_tag & 0xff)<<16)|
-				((ATAP & 0x3f) << 10) | 0x20 | dir);
-							/* dad (bit 0-1) is 0 */
+		/* set encryption bit; dad (bits 0-1) is 0 */
+		sata_cmd.retfis_ncqtag_atap_dir_m_dad =
+			cpu_to_le32((retfis << 24) | ((ncg_tag & 0xff) << 16) |
+				    ((ATAP & 0x3f) << 10) | 0x20 | dir);
 		/* fill in PRD (scatter/gather) table, if any */
 		if (task->num_scatter > 1) {
 			pm8001_chip_make_sg(task->scatter,
@@ -4568,11 +4567,10 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 		pm8001_dbg(pm8001_ha, IO,
 			   "Sending Normal SATA command 0x%x inb %x\n",
 			   sata_cmd.sata_fis.command, q_index);
-		/* dad (bit 0-1) is 0 */
-		sata_cmd.ncqtag_atap_dir_m_dad =
-			cpu_to_le32(((ncg_tag & 0xff)<<16) |
-					((ATAP & 0x3f) << 10) | dir);
-
+		/* dad (bits 0-1) is 0 */
+		sata_cmd.retfis_ncqtag_atap_dir_m_dad =
+			cpu_to_le32((retfis << 24) | ((ncg_tag & 0xff) << 16) |
+				    ((ATAP & 0x3f) << 10) | dir);
 		/* fill in PRD (scatter/gather) table, if any */
 		if (task->num_scatter > 1) {
 			pm8001_chip_make_sg(task->scatter,
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80xx_hwi.h
index acf6e3005b84..eb8fd37b2066 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.h
+++ b/drivers/scsi/pm8001/pm80xx_hwi.h
@@ -731,7 +731,7 @@ struct sata_start_req {
 	__le32	tag;
 	__le32	device_id;
 	__le32	data_len;
-	__le32	ncqtag_atap_dir_m_dad;
+	__le32	retfis_ncqtag_atap_dir_m_dad;
 	struct host_to_dev_fis	sata_fis;
 	u32	reserved1;
 	u32	reserved2;	/* dword 11. rsvd for normal I/O. */
-- 
2.42.0.rc1.204.g551eb34607-goog

