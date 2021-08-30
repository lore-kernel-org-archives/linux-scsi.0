Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A263C432BE
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Aug 2021 23:12:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4979560F42
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Aug 2021 23:12:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238898AbhH3XNo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Aug 2021 19:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232217AbhH3XNo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Aug 2021 19:13:44 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23892C061575
        for <linux-scsi@vger.kernel.org>; Mon, 30 Aug 2021 16:12:50 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id m17so9471498plc.6
        for <linux-scsi@vger.kernel.org>; Mon, 30 Aug 2021 16:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ifwW6/B4KRqgEcuevW4ZI8aBupKXxTSLcDByvRV6N1A=;
        b=oxiSct2wJLlIhxYa9vD8d/LPF04icQ42L2QXDEG9aRh0Aa0d61Smd2rZyT7jheBCWO
         U7nrXU/ZTQUG1YGJoxtDyoxtdUMGI1tuBA7dqpM5x14udXZwQwNwA7GOT7kj5DazB/Cy
         ex6EAWtZp/sN9mlMH66weg6/1KHWu5MDj8INY1/s2Sterl+LcUbxNWq7uht+fsNPuJAf
         YEO+CNd/o6VR4FzE4MXVr/seIiJjTtAZ/I1gi6ZL6ty3QR90X+PRZdMEn3zD+6nd+RkZ
         yUdt6zxY8YmexrlmHzVyd5JNWe9RBVC7lcDkyCivpU+h2tpkl49aZLLlN5NPmrapFYsN
         39dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ifwW6/B4KRqgEcuevW4ZI8aBupKXxTSLcDByvRV6N1A=;
        b=CbzQzN+SWMM9V8W8eIkT4hJSfHERq2az1pt9qje1iKqxYEjBoAdkJLVNLWwn3+m6gE
         HC/nwIqS5QoXX80mXYNDl6zq17FmF3S77QPpPFdCQScRJ7g4L17wtub+jTGtIyoCa9sg
         p6lTmew2UHA9qk7/xq01a7YcqJhl21ckz1QfUXdMSm3E8C7OxedyuVm3Ewb4gE+5Oic0
         Y7u/JRRqlX6m4pKb5StgHphsHn7PmimmFKH79oc1tEOiuJ6Mv833USLn51BLhfdt5eGH
         BI+pNjOEh+uMWSif+OMBuqEeUNiSGxP/rlBRGH/4/+KMWyvDRWYGs70AVmsz9x3I2MzT
         JuQg==
X-Gm-Message-State: AOAM5321ZThMePuV78yS4nUWnC+x65Y05ElHeshmu+WCJEs1czHnj4Ui
        VHio8q0bf61rNqz1f72go5eTlLBt/i01xQ==
X-Google-Smtp-Source: ABdhPJy65u4n5Y+MoCRJ3du9SOtPaVZimXqI10Me9/j56deByK7+95nRxkyCKj2x5YBMkh8cgbgApQ==
X-Received: by 2002:a17:90a:19d0:: with SMTP id 16mr1725117pjj.4.1630365169526;
        Mon, 30 Aug 2021 16:12:49 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x16sm18241103pgc.49.2021.08.30.16.12.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 16:12:49 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        kernel test robot <lkp@intel.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH] lpfc: Fix cpu to/from endian warnings introduced by els processing
Date:   Mon, 30 Aug 2021 16:12:43 -0700
Message-Id: <20210830231243.6227-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The kernel test robot reported the following sparse warning:
".../lpfc_els.c:3984:25: sparse: sparse: cast from restricted __be16"

For the error being flagged, using be32_to_cpu() on a be16 data type,
it was simple enough. But a review of other elements and warnings were
also evaluated.

This patch corrected several items in the original patch:
- using be32_to_cpu() on a be16 data type
- cpu_to_le32 used on a std uint32_t (cpu) data type.
  Note: this is a bytearray, but stored in le layout by hw at 32bit
   boundaries. So it possibly needed conversion.
- using cpu_to_le32() on a std uint16_t and assigned to a char typeA
- using le32_to_cpu on a le16 type
- missing cpu_to_le16 on an assignment

-- james

Fixes: 9064aeb2df8e ("scsi: lpfc: Add EDC ELS support")
Reported-by: kernel test robot <lkp@intel.com>
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c  |  8 ++++----
 drivers/scsi/lpfc/lpfc_hw4.h  |  2 +-
 drivers/scsi/lpfc/lpfc_init.c | 16 ++++++++--------
 drivers/scsi/lpfc/lpfc_sli.c  |  5 +++--
 4 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 1254a575fd47..f3fc79b99165 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -4015,11 +4015,11 @@ lpfc_cmpl_els_edc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				be32_to_cpu(pcgd->desc_tag),
 				be32_to_cpu(pcgd->desc_len),
 				be32_to_cpu(pcgd->xmt_signal_capability),
-				be32_to_cpu(pcgd->xmt_signal_frequency.count),
-				be32_to_cpu(pcgd->xmt_signal_frequency.units),
+				be16_to_cpu(pcgd->xmt_signal_frequency.count),
+				be16_to_cpu(pcgd->xmt_signal_frequency.units),
 				be32_to_cpu(pcgd->rcv_signal_capability),
-				be32_to_cpu(pcgd->rcv_signal_frequency.count),
-				be32_to_cpu(pcgd->rcv_signal_frequency.units));
+				be16_to_cpu(pcgd->rcv_signal_frequency.count),
+				be16_to_cpu(pcgd->rcv_signal_frequency.units));
 
 			/* Compare driver and Fport capabilities and choose
 			 * least common.
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 79a4872c2edb..7359505e6041 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -1167,7 +1167,7 @@ struct lpfc_mbx_read_object {  /* Version 0 */
 #define lpfc_mbx_rd_object_rlen_MASK	0x00FFFFFF
 #define lpfc_mbx_rd_object_rlen_WORD	word0
 			uint32_t rd_object_offset;
-			uint32_t rd_object_name[LPFC_MBX_OBJECT_NAME_LEN_DW];
+			__le32 rd_object_name[LPFC_MBX_OBJECT_NAME_LEN_DW];
 #define LPFC_OBJ_NAME_SZ 104   /* 26 x sizeof(uint32_t) is 104. */
 			uint32_t rd_object_cnt;
 			struct lpfc_mbx_host_buf rd_object_hbuf[4];
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 6e742d31258d..d3f1fa38269f 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -5518,7 +5518,7 @@ lpfc_cgn_update_stat(struct lpfc_hba *phba, uint32_t dtag)
 	if (phba->cgn_fpin_frequency &&
 	    phba->cgn_fpin_frequency != LPFC_FPIN_INIT_FREQ) {
 		value = LPFC_CGN_TIMER_TO_MIN / phba->cgn_fpin_frequency;
-		cp->cgn_stat_npm = cpu_to_le32(value);
+		cp->cgn_stat_npm = value;
 	}
 	value = lpfc_cgn_calc_crc32(cp, LPFC_CGN_INFO_SZ,
 				    LPFC_CGN_CRC32_SEED);
@@ -5547,9 +5547,9 @@ lpfc_cgn_save_evt_cnt(struct lpfc_hba *phba)
 	uint32_t mbps;
 	uint32_t dvalue, wvalue, lvalue, avalue;
 	uint64_t latsum;
-	uint16_t *ptr;
-	uint32_t *lptr;
-	uint16_t *mptr;
+	__le16 *ptr;
+	__le32 *lptr;
+	__le16 *mptr;
 
 	/* Make sure we have a congestion info buffer */
 	if (!phba->cgn_i)
@@ -5570,7 +5570,7 @@ lpfc_cgn_save_evt_cnt(struct lpfc_hba *phba)
 	if (phba->cgn_fpin_frequency &&
 	    phba->cgn_fpin_frequency != LPFC_FPIN_INIT_FREQ) {
 		value = LPFC_CGN_TIMER_TO_MIN / phba->cgn_fpin_frequency;
-		cp->cgn_stat_npm = cpu_to_le32(value);
+		cp->cgn_stat_npm = value;
 	}
 
 	/* Read and clear the latency counters for this minute */
@@ -5753,7 +5753,7 @@ lpfc_cgn_save_evt_cnt(struct lpfc_hba *phba)
 			dvalue += le32_to_cpu(cp->cgn_drvr_hr[i]);
 			wvalue += le32_to_cpu(cp->cgn_warn_hr[i]);
 			lvalue += le32_to_cpu(cp->cgn_latency_hr[i]);
-			mbps += le32_to_cpu(cp->cgn_bw_hr[i]);
+			mbps += le16_to_cpu(cp->cgn_bw_hr[i]);
 			avalue += le32_to_cpu(cp->cgn_alarm_hr[i]);
 		}
 		if (lvalue)		/* Avg of latency averages */
@@ -13411,8 +13411,8 @@ lpfc_init_congestion_buf(struct lpfc_hba *phba)
 
 	/* last used Index initialized to 0xff already */
 
-	cp->cgn_warn_freq = LPFC_FPIN_INIT_FREQ;
-	cp->cgn_alarm_freq = LPFC_FPIN_INIT_FREQ;
+	cp->cgn_warn_freq = cpu_to_le16(LPFC_FPIN_INIT_FREQ);
+	cp->cgn_alarm_freq = cpu_to_le16(LPFC_FPIN_INIT_FREQ);
 	crc = lpfc_cgn_calc_crc32(cp, LPFC_CGN_INFO_SZ, LPFC_CGN_CRC32_SEED);
 	cp->cgn_info_crc = cpu_to_le32(crc);
 
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index ffd8a140638c..78ce38d7251c 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -22090,6 +22090,7 @@ lpfc_read_object(struct lpfc_hba *phba, char *rdobject, uint32_t *datap,
 	uint32_t shdr_status, shdr_add_status;
 	union lpfc_sli4_cfg_shdr *shdr;
 	struct lpfc_dmabuf *pcmd;
+	u32 rd_object_name[LPFC_MBX_OBJECT_NAME_LEN_DW] = {0};
 
 	/* sanity check on queue memory */
 	if (!datap)
@@ -22113,10 +22114,10 @@ lpfc_read_object(struct lpfc_hba *phba, char *rdobject, uint32_t *datap,
 
 	memset((void *)read_object->u.request.rd_object_name, 0,
 	       LPFC_OBJ_NAME_SZ);
-	sprintf((uint8_t *)read_object->u.request.rd_object_name, rdobject);
+	scnprintf((char *)rd_object_name, sizeof(rd_object_name), rdobject);
 	for (j = 0; j < strlen(rdobject); j++)
 		read_object->u.request.rd_object_name[j] =
-			cpu_to_le32(read_object->u.request.rd_object_name[j]);
+			cpu_to_le32(rd_object_name[j]);
 
 	pcmd = kmalloc(sizeof(*pcmd), GFP_KERNEL);
 	if (pcmd)
-- 
2.26.2

