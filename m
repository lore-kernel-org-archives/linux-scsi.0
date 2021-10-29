Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94B97C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 19:49:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7182960FED
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 19:49:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbhJ2TwR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Oct 2021 15:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbhJ2TwO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Oct 2021 15:52:14 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83288C061570;
        Fri, 29 Oct 2021 12:49:45 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id d27so207855wrb.6;
        Fri, 29 Oct 2021 12:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xK0OgKCgasorIcncaA/RIPd54WafWAPhaFoI+LfDjAI=;
        b=XMWUGVgdG0z/rLYK1zsJSTwS7NYnJ0uVT8e6HZAyn79kcWGG37HLI38NQ6D8g6eflv
         sEDf3ADBQjNAjK6B3wsCZyavKrEF4K+uAeofN2OUhNxqQ2dI2oh13sIBU1YtemqS/yL5
         UlFp8bxcqb6LGUZdw+b+eFdDAIsF/wKUVUaMyL3hB6HmMyJFv48CeKjn7RN9cK8NmVuW
         djg2GvANNp76MlFZh8IUf+9nHxXCn6wetHb2JI4JncXwYQcCFifXZxVJ8tacWbAkplMh
         iK0Kc8+BccxGiZxaWGhhvk5UjDFyT8paRU8gJfDJ8sQS+8gOFChTLzgBdV20ub5akPNI
         mjHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xK0OgKCgasorIcncaA/RIPd54WafWAPhaFoI+LfDjAI=;
        b=moR+ggGwswb9/tA+cuzIhR7z/PspKnBk41pP5JUuXbk2rAZZw8/FlAwa5arSfW+bQe
         zYV4VqiFg9yFunzv2ozLAQeipxqZ7g6CsUHUfPhgQ2kDxaetQZ3xotiEwdPdXnixknjL
         XUS5JyK/TCAkkt0ipFyoxakeOfu2u2EGQE4Kv90DA3jR0VosfQwvOhrjIWEnz+uvfRMT
         OehZfHSUFHkZ9BJr0DenpnpBquCkNV/HYwVgoBf4d/o6P+r7fJeUeoUjZ21l3Ddt33E+
         NW4Mec3cLifvS54MFTiT33LmGygJcs3SWABlVvTnSLQP6RA/gTvX6EkpTrNsvH3ttG9/
         q3Xw==
X-Gm-Message-State: AOAM533ny/VUFWnUp1QRLTObGb2I8//eshZ9lmdNZHvulQ6vjcTT5x3A
        DAKX/GgE9KYB5fDr6OLdxlY=
X-Google-Smtp-Source: ABdhPJy30bPqRk6xBKQaZF5W1IMh4qvyC13Fsx+VdhSGriwzx+H/ZhnIgcEPrlx5bh48pCLxxnp1JA==
X-Received: by 2002:a1c:a70c:: with SMTP id q12mr5018584wme.105.1635536984194;
        Fri, 29 Oct 2021 12:49:44 -0700 (PDT)
Received: from ubuntu-laptop.speedport.ip (p200300e94719c92a81a9947a27df1b21.dip0.t-ipconnect.de. [2003:e9:4719:c92a:81a9:947a:27df:1b21])
        by smtp.gmail.com with ESMTPSA id r11sm6323365wro.93.2021.10.29.12.49.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Oct 2021 12:49:44 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, daejun7.park@samsung.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] scsi: ufshpb: Delete ufshpb_set_write_buf_cmd()
Date:   Fri, 29 Oct 2021 21:49:31 +0200
Message-Id: <20211029194931.293826-3-huobean@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211029194931.293826-1-huobean@gmail.com>
References: <20211029194931.293826-1-huobean@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Since commit "facdc632bb5f ('scsi: ufs: ufshpb: Remove HPB2.0 flows')",
no body uses it, so delete it.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshpb.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 95ce20ff2194..106d8e0e50c7 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -342,20 +342,6 @@ ufshpb_set_hpb_read_to_upiu(struct ufs_hba *hba, struct ufshpb_lu *hpb,
 	lrbp->cmd->cmd_len = UFS_CDB_SIZE;
 }
 
-static inline void ufshpb_set_write_buf_cmd(unsigned char *cdb,
-					    unsigned long lpn, unsigned int len,
-					    int read_id)
-{
-	cdb[0] = UFSHPB_WRITE_BUFFER;
-	cdb[1] = UFSHPB_WRITE_BUFFER_PREFETCH_ID;
-
-	put_unaligned_be32(lpn, &cdb[2]);
-	cdb[6] = read_id;
-	put_unaligned_be16(len * HPB_ENTRY_SIZE, &cdb[7]);
-
-	cdb[9] = 0x00;	/* Control = 0x00 */
-}
-
 static inline int ufshpb_get_read_id(struct ufshpb_lu *hpb)
 {
 	if (++hpb->cur_read_id >= MAX_HPB_READ_ID)
-- 
2.25.1

