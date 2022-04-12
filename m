Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29E2DC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 23:34:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbiDLXgu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 19:36:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231363AbiDLXcy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 19:32:54 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 888D2C624A
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:29 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id 2so83376pjw.2
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ADM8hEagvYj5j8EgYdQiVeDmYYbZ/CTt564WNuAXIX8=;
        b=ZW4xgWJJ4MSW5AdBlNt2JWF7QPt6NGs/sOSW/7j13lKMtkyKyTP2AVGI2F9Bg0lBlE
         4NFTD3muGunrkbbNj+ink+uOwHXWKsjxF82BuVvSzwiPG9MnbgJNQhO2hTjXX8Oqmdg2
         z8Efvd7u8fm2Gu1XYoQ+5tyDuI8+ZgBZKgYqU0dad9FhkxtvdVCkDhn4tVnkkS0xNwMB
         YGs2AxwSw8CCSp0tgS7owHi87MaJxM9MQn0ZtWZgbQTRGEIj22MHYXVYZQ9Q1cohvWrb
         l6HSLG9CQa+ja6cS0vv9qAtuMSUI4YURzZnTEJFFfPoYQXhZsGrR/zoYR5V5AX+pGCvG
         r+yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ADM8hEagvYj5j8EgYdQiVeDmYYbZ/CTt564WNuAXIX8=;
        b=iGGObYJr64A9xVUOJjiu8IvbyKqXDShqEDsdWK54xecYvs+GrVUztjKdRHO+1W5/yW
         Q6GEOcjwKHrN4FZcpInLCPNfp7YICjtgEv8BRKVSQVqA2HRMdooW1H4LtwHGKKNGKkEj
         5BJ3nhWaSQXCm+QBugV/hDsBlM2YYReJfML77brqXdX20KmP4TLIzFb0WDh2Noe4mMjV
         BVtRXuYn2qPDhsdgpfrYF3s8tzU6QeMAa5y7bp80f561CzOPZqp28+kvefAT/eYfsih3
         qqsyMYEIiA+pqBjfqSI27V/62XRbeD0xwH4eZ4+WQH0jQgZDBgai3fbTcwCKfGXF4JDu
         wzTA==
X-Gm-Message-State: AOAM5304VUd9WzVYutzHqJV0L1lkIqgRk9QWfKvypIHBgLUl965UqLWD
        LG9C/zviJz9Pz62Y7ZZBoO4vLG2XU84=
X-Google-Smtp-Source: ABdhPJwBtaYLQ96HrZKXT8150P3fxSaFWTrq0D3hrnjzjIV4laMQbeINyde1q/5Pzj2lG34NOBkeiw==
X-Received: by 2002:a17:902:be03:b0:156:7ed7:a02a with SMTP id r3-20020a170902be0300b001567ed7a02amr39417123pls.10.1649802028884;
        Tue, 12 Apr 2022 15:20:28 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g15-20020a056a000b8f00b004fa9dbf27desm40429824pfj.55.2022.04.12.15.20.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 15:20:28 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 18/26] lpfc: Register for Application Services FC-4 type in Fabric topology
Date:   Tue, 12 Apr 2022 15:20:00 -0700
Message-Id: <20220412222008.126521-19-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220412222008.126521-1-jsmart2021@gmail.com>
References: <20220412222008.126521-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add new FC-4 type 0x60 Application Services for fabric registration when
VMID is enabled.

Modified rft struture to indicate __be format. Removed redundant ipReg
variable as it was not used.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_ct.c | 26 ++++++++++++++------------
 drivers/scsi/lpfc/lpfc_hw.h | 36 ++++++++++++++++++------------------
 2 files changed, 32 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 8df5ba3ed482..c74833ed78c6 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -2018,28 +2018,30 @@ lpfc_ns_cmd(struct lpfc_vport *vport, int cmdcode,
 		vport->ct_flags &= ~FC_CT_RFT_ID;
 		CtReq->CommandResponse.bits.CmdRsp =
 		    cpu_to_be16(SLI_CTNS_RFT_ID);
-		CtReq->un.rft.PortId = cpu_to_be32(vport->fc_myDID);
+		CtReq->un.rft.port_id = cpu_to_be32(vport->fc_myDID);
+
+		/* Register Application Services type if vmid enabled. */
+		if (phba->cfg_vmid_app_header)
+			CtReq->un.rft.app_serv_reg =
+				cpu_to_be32(RFT_APP_SERV_REG);
 
 		/* Register FC4 FCP type if enabled.  */
 		if (vport->cfg_enable_fc4_type == LPFC_ENABLE_BOTH ||
 		    vport->cfg_enable_fc4_type == LPFC_ENABLE_FCP)
-			CtReq->un.rft.fcpReg = 1;
+			CtReq->un.rft.fcp_reg = cpu_to_be32(RFT_FCP_REG);
 
-		/* Register NVME type if enabled.  Defined LE and swapped.
-		 * rsvd[0] is used as word1 because of the hard-coded
-		 * word0 usage in the ct_request data structure.
-		 */
+		/* Register NVME type if enabled. */
 		if (vport->cfg_enable_fc4_type == LPFC_ENABLE_BOTH ||
 		    vport->cfg_enable_fc4_type == LPFC_ENABLE_NVME)
-			CtReq->un.rft.rsvd[0] =
-				cpu_to_be32(LPFC_FC4_TYPE_BITMASK);
+			CtReq->un.rft.nvme_reg = cpu_to_be32(RFT_NVME_REG);
 
 		ptr = (uint32_t *)CtReq;
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
-				 "6433 Issue RFT (%s %s): %08x %08x %08x %08x "
-				 "%08x %08x %08x %08x\n",
-				 CtReq->un.rft.fcpReg ? "FCP" : " ",
-				 CtReq->un.rft.rsvd[0] ? "NVME" : " ",
+				 "6433 Issue RFT (%s %s %s): %08x %08x %08x "
+				 "%08x %08x %08x %08x %08x\n",
+				 CtReq->un.rft.fcp_reg ? "FCP" : " ",
+				 CtReq->un.rft.nvme_reg ? "NVME" : " ",
+				 CtReq->un.rft.app_serv_reg ? "APPS" : " ",
 				 *ptr, *(ptr + 1), *(ptr + 2), *(ptr + 3),
 				 *(ptr + 4), *(ptr + 5),
 				 *(ptr + 6), *(ptr + 7));
diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index d6050f3c9efe..2f5537f57846 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -97,6 +97,18 @@ union CtCommandResponse {
 #define FC4_FEATURE_INIT	0x2
 #define FC4_FEATURE_NVME_DISC	0x4
 
+enum rft_word0 {
+	RFT_FCP_REG	= (0x1 << 8),
+};
+
+enum rft_word1 {
+	RFT_NVME_REG	= (0x1 << 8),
+};
+
+enum rft_word3 {
+	RFT_APP_SERV_REG	= (0x1 << 0),
+};
+
 struct lpfc_sli_ct_request {
 	/* Structure is in Big Endian format */
 	union CtRevisionId RevisionId;
@@ -131,25 +143,13 @@ struct lpfc_sli_ct_request {
 			uint8_t Fc4Type;
 		} gid_ff;
 		struct rft {
-			uint32_t PortId;	/* For RFT_ID requests */
-
-#ifdef __BIG_ENDIAN_BITFIELD
-			uint32_t rsvd0:16;
-			uint32_t rsvd1:7;
-			uint32_t fcpReg:1;	/* Type 8 */
-			uint32_t rsvd2:2;
-			uint32_t ipReg:1;	/* Type 5 */
-			uint32_t rsvd3:5;
-#else	/*  __LITTLE_ENDIAN_BITFIELD */
-			uint32_t rsvd0:16;
-			uint32_t fcpReg:1;	/* Type 8 */
-			uint32_t rsvd1:7;
-			uint32_t rsvd3:5;
-			uint32_t ipReg:1;	/* Type 5 */
-			uint32_t rsvd2:2;
-#endif
+			__be32 port_id; /* For RFT_ID requests */
 
-			uint32_t rsvd[7];
+			__be32 fcp_reg;	/* rsvd 31:9, fcp_reg 8, rsvd 7:0 */
+			__be32 nvme_reg; /* rsvd 31:9, nvme_reg 8, rsvd 7:0 */
+			__be32 word2;
+			__be32 app_serv_reg; /* rsvd 31:1, app_serv_reg 0 */
+			__be32 word[4];
 		} rft;
 		struct rnn {
 			uint32_t PortId;	/* For RNN_ID requests */
-- 
2.26.2

