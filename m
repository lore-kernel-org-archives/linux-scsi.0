Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 141BCC677C4
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Aug 2023 21:43:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355408AbjHQVmu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Aug 2023 17:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355407AbjHQVmU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2023 17:42:20 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED747E4F
        for <linux-scsi@vger.kernel.org>; Thu, 17 Aug 2023 14:42:18 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d6ce0c4489bso327378276.2
        for <linux-scsi@vger.kernel.org>; Thu, 17 Aug 2023 14:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692308538; x=1692913338;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Qtl6EpumWNGPoRz7oaS5PTYvxovlVgZ6i46m27dXaq4=;
        b=cl7isfNShgcgUXX+bIwc6SL9TYZ+oE3/kJae10YUFS24BqiFrqqw+JQe70bvc3gg4n
         6SwcN0j37z71dphycVkQPAa62jUnHMXwKMjmHDDIQcNPEXyy4USrNXpLR2uD33wXc0LO
         T9IJ0jTOsd1eBN0DNRL8AJ5TzOckT/mU/uA/J1F5evgf3CqLRIwqX4XHtoy59i4oa1o4
         3beHdUhm/TuzoRgiwS/QOyEFzepYhCG1NBfFfh2+nk/sZPtPmZ28c+QWdPRkcxGsnTzr
         8nGj74ponNusbpL0hjMRXXzptGkP12k/0Lk3xKCUKAjgf+EoUzQM2cLeuEg3h5Qk/DgR
         4PUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692308538; x=1692913338;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qtl6EpumWNGPoRz7oaS5PTYvxovlVgZ6i46m27dXaq4=;
        b=JiVNjAsqQZAlvHTWXYj+BCofPpNghNt8Hs1lAxvtKxGo76V+udRcCG0rWTNXPTT82k
         bx1aioS/+VWSe70jCcjZ4G+DUW9CDr44g4gRnOBcr8FrID/zYWkbnlNByfSWrXzsqODz
         FTYsJK8exwESnRWI8MjZC5tzCHXCqyIcXm6UwFM8brIGU8Md3QVici8eNgA1gU/g/gcO
         0fnX0Is0dbBT/AtV+ObLb5XX1lBbH+AR5mkdGV3JWp2jl3YugGEeVu8cIqyEQ5dhi1mc
         +4LngO31PuOEtC4phAg97p2YOguZJGtLYngqo1s5rKG4QONOUf3S8l2NSOsf5EKEk3E8
         lnfA==
X-Gm-Message-State: AOJu0YxNsbCdPjhLv0mis3tCZPNxdrZ7wUmoAjihRuZrK/lqBDmQqkyH
        PAxvjGnyKoKKdwnKGqEYlwnsRY08hKNc7w==
X-Google-Smtp-Source: AGHT+IHrRtetB/alA9IynLSO6i/2PCQBhpOYIoUI37adIRvWn3Xs+ORUb6jfqmp0nZ5s0YhUZQQ3Z5VOo5/hxQ==
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:13:ab26:9b32:155b:9418])
 (user=ipylypiv job=sendgmr) by 2002:a25:946:0:b0:d4f:638b:d806 with SMTP id
 u6-20020a250946000000b00d4f638bd806mr10595ybm.8.1692308538248; Thu, 17 Aug
 2023 14:42:18 -0700 (PDT)
Date:   Thu, 17 Aug 2023 14:41:37 -0700
In-Reply-To: <20230817214137.462044-1-ipylypiv@google.com>
Mime-Version: 1.0
References: <20230817214137.462044-1-ipylypiv@google.com>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <20230817214137.462044-3-ipylypiv@google.com>
Subject: [PATCH 3/3] scsi: pm80xx: Set RETFIS when requested by libsas
From:   Igor Pylypiv <ipylypiv@google.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Damien Le Moal <dlemoal@kernel.org>
Cc:     linux-scsi@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
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
 drivers/scsi/pm8001/pm8001_hwi.c |  8 +++++---
 drivers/scsi/pm8001/pm8001_hwi.h |  2 +-
 drivers/scsi/pm8001/pm80xx_hwi.c | 11 ++++++-----
 drivers/scsi/pm8001/pm80xx_hwi.h |  2 +-
 4 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 73cd25f30ca5..255553dcadb9 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -4095,7 +4095,7 @@ static int pm8001_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 	u32 hdr_tag, ncg_tag = 0;
 	u64 phys_addr;
 	u32 ATAP = 0x0;
-	u32 dir;
+	u32 dir, retfis;
 	u32  opc = OPC_INB_SATA_HOST_OPSTART;
 
 	memset(&sata_cmd, 0, sizeof(sata_cmd));
@@ -4124,8 +4124,10 @@ static int pm8001_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 	sata_cmd.tag = cpu_to_le32(tag);
 	sata_cmd.device_id = cpu_to_le32(pm8001_ha_dev->device_id);
 	sata_cmd.data_len = cpu_to_le32(task->total_xfer_len);
-	sata_cmd.ncqtag_atap_dir_m =
-		cpu_to_le32(((ncg_tag & 0xff)<<16)|((ATAP & 0x3f) << 10) | dir);
+	retfis = task->ata_task.return_fis_on_success;
+	sata_cmd.retfis_ncqtag_atap_dir_m =
+		cpu_to_le32((retfis << 24) | ((ncg_tag & 0xff) << 16) |
+				((ATAP & 0x3f) << 10) | dir);
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
index 39a12ee94a72..e839fb53f0e3 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4457,7 +4457,7 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 	u64 phys_addr, end_addr;
 	u32 end_addr_high, end_addr_low;
 	u32 ATAP = 0x0;
-	u32 dir;
+	u32 dir, retfis;
 	u32 opc = OPC_INB_SATA_HOST_OPSTART;
 	memset(&sata_cmd, 0, sizeof(sata_cmd));
 
@@ -4487,6 +4487,7 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 	sata_cmd.tag = cpu_to_le32(tag);
 	sata_cmd.device_id = cpu_to_le32(pm8001_ha_dev->device_id);
 	sata_cmd.data_len = cpu_to_le32(task->total_xfer_len);
+	retfis = task->ata_task.return_fis_on_success;
 
 	sata_cmd.sata_fis = task->ata_task.fis;
 	if (likely(!task->ata_task.device_control_reg_update))
@@ -4502,8 +4503,8 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 		opc = OPC_INB_SATA_DIF_ENC_IO;
 
 		/* set encryption bit */
-		sata_cmd.ncqtag_atap_dir_m_dad =
-			cpu_to_le32(((ncg_tag & 0xff)<<16)|
+		sata_cmd.retfis_ncqtag_atap_dir_m_dad =
+			cpu_to_le32((retfis << 24) | ((ncg_tag & 0xff) << 16) |
 				((ATAP & 0x3f) << 10) | 0x20 | dir);
 							/* dad (bit 0-1) is 0 */
 		/* fill in PRD (scatter/gather) table, if any */
@@ -4569,8 +4570,8 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 			   "Sending Normal SATA command 0x%x inb %x\n",
 			   sata_cmd.sata_fis.command, q_index);
 		/* dad (bit 0-1) is 0 */
-		sata_cmd.ncqtag_atap_dir_m_dad =
-			cpu_to_le32(((ncg_tag & 0xff)<<16) |
+		sata_cmd.retfis_ncqtag_atap_dir_m_dad =
+			cpu_to_le32((retfis << 24) | ((ncg_tag & 0xff) << 16) |
 					((ATAP & 0x3f) << 10) | dir);
 
 		/* fill in PRD (scatter/gather) table, if any */
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

