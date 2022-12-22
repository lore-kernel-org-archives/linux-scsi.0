Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08A48C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Dec 2022 14:14:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235455AbiLVOOk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Dec 2022 09:14:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235635AbiLVONs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Dec 2022 09:13:48 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB0E52CCBE
        for <linux-scsi@vger.kernel.org>; Thu, 22 Dec 2022 06:12:24 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id d15so2122803pls.6
        for <linux-scsi@vger.kernel.org>; Thu, 22 Dec 2022 06:12:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mPijPobTcYQaRyLBeRVB3HBZnVNDSDqtRoK4CmiEviM=;
        b=BA0eDOPbqVVIhhnoX9eUYS0pHxcdGVSvOSEqKJssJmQgmB/zpfNs2ywpseefd9emYh
         XoqN4fMEHfG2pCF4KZiD2D5/qOOhJbSP8VUw1VfdAzx0eEsQJRZfPNZ1giqckcw6l/0F
         RY9jGf365mZQMeq8fABGTxuju4LBtSxJVrQVhQSYMynUL2F04SC6OwQb54WMmEL+4MHi
         nj4OlLmn3jy8CMwICcCtp6czimJzm9ypl8bMFg5PkRnYD7CXnKG/mQwKZnsgSz2ndx0y
         UIxtddqWDUwypdkhoLzg5pp8bnnjBvmdaWC8ZQ+LmnfdZ565cBWkogTOH/3UPtLm+trg
         koiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mPijPobTcYQaRyLBeRVB3HBZnVNDSDqtRoK4CmiEviM=;
        b=71rlYTaC2H5M8B5f/dtJ3cxGa5GTIScfloY8j63gwPe43vifH/Z6y1jH1W9/b3WJXt
         zvQXi1tCeIjM2+vnMU/L0UUngEEsLyTQ2CqLq07ipICS7C/Y5KlC4p5XKPaAGl8dUx6a
         ePf/GiBvsMsODSPaRZQn00WEAEliUqpi6BYVLLHJSG5sxC6u2gpvyR/k0wdq87muBb9F
         UH3evpJOS8PRVMoE5Xpt/zmaqkFwUTA6U6gQ+Boj/JjbTX3OHz6IiS0g7Vo1eBmnkXmm
         SV13L6aRNFIHNNmN+7evwqIpSUNI1Wthta1t1z75RknEYpP/SzVlJA0XoXOej+SFRAh7
         Crjg==
X-Gm-Message-State: AFqh2koUJm8ytwrKHG/fAglL5MrmKpvlrvrjxYOKNli8164m21bGPmi4
        SwR182XTLZQwRfZr+t7WQIkB
X-Google-Smtp-Source: AMrXdXvWMjrApzmz5yi1BXdIqlRS22IM1TaOp7Xa1o1bPm+EfdAnwO2fH9/w5YnfyLy+cSU+N9cqsQ==
X-Received: by 2002:a17:903:28d:b0:191:386:d8f with SMTP id j13-20020a170903028d00b0019103860d8fmr6265636plr.47.1671718344357;
        Thu, 22 Dec 2022 06:12:24 -0800 (PST)
Received: from localhost.localdomain ([117.217.177.177])
        by smtp.gmail.com with ESMTPSA id f8-20020a655908000000b0047829d1b8eesm832031pgu.31.2022.12.22.06.12.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Dec 2022 06:12:23 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        andersson@kernel.org, vkoul@kernel.org
Cc:     quic_cang@quicinc.com, quic_asutoshd@quicinc.com,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org,
        dmitry.baryshkov@linaro.org, ahalaney@redhat.com,
        abel.vesa@linaro.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH v5 18/23] scsi: ufs: core: Add reinit_notify() callback
Date:   Thu, 22 Dec 2022 19:39:56 +0530
Message-Id: <20221222141001.54849-19-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221222141001.54849-1-manivannan.sadhasivam@linaro.org>
References: <20221222141001.54849-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

reinit_notify() callback can be used by the UFS controller drivers to
perform changes required for UFSHCD reinit that can happen during max
gear switch.

Tested-by: Andrew Halaney <ahalaney@redhat.com> # Qdrive3/sa8540p-ride
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/ufs/core/ufshcd-priv.h | 6 ++++++
 include/ufs/ufshcd.h           | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index a9e8e1f5afe7..2ce3c98e0711 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -226,6 +226,12 @@ static inline void ufshcd_vops_config_scaling_param(struct ufs_hba *hba,
 		hba->vops->config_scaling_param(hba, p, data);
 }
 
+static inline void ufshcd_vops_reinit_notify(struct ufs_hba *hba)
+{
+	if (hba->vops && hba->vops->reinit_notify)
+		hba->vops->reinit_notify(hba);
+}
+
 extern const struct ufs_pm_lvl_states ufs_pm_lvl_states[];
 
 /**
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 5cf81dff60aa..0a0b435f5c17 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -297,6 +297,7 @@ struct ufs_pwr_mode_info {
  * @config_scaling_param: called to configure clock scaling parameters
  * @program_key: program or evict an inline encryption key
  * @event_notify: called to notify important events
+ * @reinit_notify: called to notify reinit of UFSHCD during max gear switch
  */
 struct ufs_hba_variant_ops {
 	const char *name;
@@ -335,6 +336,7 @@ struct ufs_hba_variant_ops {
 			       const union ufs_crypto_cfg_entry *cfg, int slot);
 	void	(*event_notify)(struct ufs_hba *hba,
 				enum ufs_event_type evt, void *data);
+	void	(*reinit_notify)(struct ufs_hba *);
 };
 
 /* clock gating state  */
-- 
2.25.1

