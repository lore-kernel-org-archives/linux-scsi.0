Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483332C80;
	Thu, 12 Sep 2024 23:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726182602; cv=none; b=LrHxSNBN5f0GJk/is86ijI3mBTXhQ7EKPjwBmWGkbzsVCzDIcSd5JeyYQHENAErIoNAm8hqWISLcdTzIHfpqfU5/0CT1LvYXUaBuLUo9h60mpKPqyC235KvkCq2x2VRxJxIE7WVPwm/P+mzTZiYhcNdu1IZ3aRakJrLxyZrxkBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726182602; c=relaxed/simple;
	bh=0Ge18v6zaAvhk/oEiRWweDIF+9hvGks00PCRVeXOVmM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DpRnYwveEizfwQfwAXAV7kfq4i/5ZVyCB2m2EP/wR0+6f9wZ/vvV8zf1mMCjPrx/xnYqDSLTP0i5LCThnR1drXcxG8zvZ4zrBswAUDbO/D8WW8yxY3IS6SeO2FbWVFlPVOCWbXyuUoIYOhYH/tN/iHc0SgfAtRI2GFwtBRuvzas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ABuFw/6p; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ABuFw/6p"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-6c579748bf4so2875866d6.1;
        Thu, 12 Sep 2024 16:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726182600; x=1726787400; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wiC3DzZpi8FezEv1LFuaGk5XrynBNf5kaRDjIajewSc=;
        b=ABuFw/6p9P2tB3zfPHNiYWd0ZcGeCDDBL416WkLCZT/uj2CInBh2U50NhNocimJ53M
         SiyMyUsxf1uj+0WgYOq88Hjnfop6UGehH7oBZRVIwTfsCr8mPnDMvXp+7LVL8RU75OYI
         cZr8CTW0Zjf5tkb2J5P7EifoOPKttDoN29TbcMk426OQEo0kYW242RfRm+PBH+2dQSzF
         cvjguVdGbwa9bjVBBWrLbM2huQ7kS29Knf3Dqt9DfkD42bKpJsTM20ZdA4z0w5ORcGAV
         iCbNF2U+Uw6xzqqqLk0plbYC8OvH+uwuB3BWmnjSKPH8iO3d1zCtAMQyr41LjoRYs1Gf
         CGlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726182600; x=1726787400;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wiC3DzZpi8FezEv1LFuaGk5XrynBNf5kaRDjIajewSc=;
        b=YoO59AEAopuHK+sxpI42QGNvoc/NdmneQuWRAdaiBHFnL/ES0xbsa+SDpzp51wXoOJ
         8sugMFfzDwiq5s8Uxb+AuRfxOa+lqiqSQMvFsVJLX36uT1bU7eUgQ23EUsk2ZkOLD9hX
         RG1SxhRn5PjbbBpLcGHOhGrspJ2Ph9QSsO2wy32KOBPwnarGZy1SZePpg+z3/s1Qsd+Z
         G+AIVh4BsUAbJiBdKkB0hLp06uMTaZyZhHtspTlq8x51PYi4AncUSgmXznjoulUMBRCn
         BD0manUv9/S303nVp9aZdUrrQi2ltlkYr4eVlXBC9p6y+Qmj14Llo+jvytDA3Mn29/iO
         uo+A==
X-Forwarded-Encrypted: i=1; AJvYcCUNTv9Jfna/d00+Si2JNURqeLxjQor5sm6byJRANj6zM7Kra5gZbDi/VgrP37zcWLNBOz/5q0A=@vger.kernel.org
X-Gm-Message-State: AOJu0YxbxQPWX/55ZlP5/mBMIRg4hAQPZHh7Pa4Z6ZDKCPT8EDHQpSpW
	EwGLXZK0gbRh0Ae/9Si+5ifCM4MvMeiEsQnMDc9qOtaMDzL6cTQzAGF9VQ==
X-Google-Smtp-Source: AGHT+IHcAI2C/NRSUgFSmEpB8S0KE3BS//6WU1Z9nn8XgOxmqSkwYg+VoUWBK6QInSaJROqu/9+Ogw==
X-Received: by 2002:a05:6214:2f0f:b0:6c5:55bc:2705 with SMTP id 6a1803df08f44-6c57df773a1mr15388186d6.6.1726182599848;
        Thu, 12 Sep 2024 16:09:59 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6c534339a88sm59363136d6.50.2024.09.12.16.09.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Sep 2024 16:09:59 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH 3/8] lpfc: Restrict support for 32 byte CDBs to specific HBAs
Date: Thu, 12 Sep 2024 16:24:42 -0700
Message-Id: <20240912232447.45607-4-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240912232447.45607-1-justintee8345@gmail.com>
References: <20240912232447.45607-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

An older generation of HBAs are failing FCP discovery due to usage of an
outdated field in FCP command WQEs.

Fix by checking the SLI Interface Type register for applicable support of
32 Byte CDB commands, and restore a setting for a WQE path using normal 16
byte CDBs.

Fixes: af20bb73ac25 ("scsi: lpfc: Add support for 32 byte CDBs")
Cc: <stable@vger.kernel.org> # v6.10+
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_hw4.h  |  3 +++
 drivers/scsi/lpfc/lpfc_init.c | 21 ++++++++++++++++++---
 drivers/scsi/lpfc/lpfc_scsi.c |  2 +-
 3 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 500253007b1d..26e1313ebb21 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -4847,6 +4847,7 @@ struct fcp_iwrite64_wqe {
 #define	cmd_buff_len_SHIFT  16
 #define	cmd_buff_len_MASK  0x00000ffff
 #define	cmd_buff_len_WORD  word3
+/* Note: payload_offset_len field depends on ASIC support */
 #define payload_offset_len_SHIFT 0
 #define payload_offset_len_MASK 0x0000ffff
 #define payload_offset_len_WORD word3
@@ -4863,6 +4864,7 @@ struct fcp_iread64_wqe {
 #define	cmd_buff_len_SHIFT  16
 #define	cmd_buff_len_MASK  0x00000ffff
 #define	cmd_buff_len_WORD  word3
+/* Note: payload_offset_len field depends on ASIC support */
 #define payload_offset_len_SHIFT 0
 #define payload_offset_len_MASK 0x0000ffff
 #define payload_offset_len_WORD word3
@@ -4879,6 +4881,7 @@ struct fcp_icmnd64_wqe {
 #define	cmd_buff_len_SHIFT  16
 #define	cmd_buff_len_MASK  0x00000ffff
 #define	cmd_buff_len_WORD  word3
+/* Note: payload_offset_len field depends on ASIC support */
 #define payload_offset_len_SHIFT 0
 #define payload_offset_len_MASK 0x0000ffff
 #define payload_offset_len_WORD word3
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index e1dfa96c2a55..0c1404dc5f3b 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -4699,6 +4699,7 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
 	uint64_t wwn;
 	bool use_no_reset_hba = false;
 	int rc;
+	u8 if_type;
 
 	if (lpfc_no_hba_reset_cnt) {
 		if (phba->sli_rev < LPFC_SLI_REV4 &&
@@ -4773,10 +4774,24 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
 	shost->max_id = LPFC_MAX_TARGET;
 	shost->max_lun = vport->cfg_max_luns;
 	shost->this_id = -1;
-	if (phba->sli_rev == LPFC_SLI_REV4)
-		shost->max_cmd_len = LPFC_FCP_CDB_LEN_32;
-	else
+
+	/* Set max_cmd_len applicable to ASIC support */
+	if (phba->sli_rev == LPFC_SLI_REV4) {
+		if_type = bf_get(lpfc_sli_intf_if_type,
+				 &phba->sli4_hba.sli_intf);
+		switch (if_type) {
+		case LPFC_SLI_INTF_IF_TYPE_2:
+			fallthrough;
+		case LPFC_SLI_INTF_IF_TYPE_6:
+			shost->max_cmd_len = LPFC_FCP_CDB_LEN_32;
+			break;
+		default:
+			shost->max_cmd_len = LPFC_FCP_CDB_LEN;
+			break;
+		}
+	} else {
 		shost->max_cmd_len = LPFC_FCP_CDB_LEN;
+	}
 
 	if (phba->sli_rev == LPFC_SLI_REV4) {
 		if (!phba->cfg_fcp_mq_threshold ||
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 60cd60ebff38..0eaede8275da 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -4760,7 +4760,7 @@ static int lpfc_scsi_prep_cmnd_buf_s4(struct lpfc_vport *vport,
 
 	 /* Word 3 */
 	bf_set(payload_offset_len, &wqe->fcp_icmd,
-	       sizeof(struct fcp_cmnd32) + sizeof(struct fcp_rsp));
+	       sizeof(struct fcp_cmnd) + sizeof(struct fcp_rsp));
 
 	/* Word 6 */
 	bf_set(wqe_ctxt_tag, &wqe->generic.wqe_com,
-- 
2.38.0

