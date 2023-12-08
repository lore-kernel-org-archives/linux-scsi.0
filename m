Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Lkg2FT/q"
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6380A19A7
	for <linux-scsi@vger.kernel.org>; Thu,  7 Dec 2023 22:59:47 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-6cea1522303so1262553b3a.1
        for <linux-scsi@vger.kernel.org>; Thu, 07 Dec 2023 22:59:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1702018787; x=1702623587; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dw1HiXXVLe/1lHZEEZF1Ot3Ar80Z2/bXxftivhX5tWk=;
        b=Lkg2FT/qLKmsXBe+tGnDvhLGNWWYSkFcrXDJSF/Zqy5stxddekXqvDiUHbbCs7/cdu
         tt5tLKXySVez3GwIu3HVzPFf/aUbVtNDkJkot2MmUhabP0L/xZnjLx2KM+hIWx71AZF7
         QKcf+klR1XDnGGaaa59bcRRK7R6sBQFW+aD9KYXu4fVwm4D3VlHz6OTtpAPWQz3ClmeD
         Ac+2b6bfkYFqU7L2HmlcGGgqJlVOh1V7duAR9f/m7lbrOuV89vM9aLX4WnIm53ERY+//
         JakUIJTK/V3iyal/h3g32iGQr4oDDS7lWj4uxVDjKFTFn2nRpnajPPxZ515eutkjtQMK
         0Akg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702018787; x=1702623587;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dw1HiXXVLe/1lHZEEZF1Ot3Ar80Z2/bXxftivhX5tWk=;
        b=EIVTz2AJqc6XSZEP6nmBVGcy5pO8nBLRCawz/652OoGgSSivZpj5nQimuJLawbHAlI
         E3VnzuAb8Mdr5l/fFOXjDe45PubBTenJ3sJ2JXrk0vD3mbuV1mPXESO8pQ5QFrG3SQVW
         0anlbiO4ML5BOWjd45MxRVifItvnsS+2eS7PdjdLPT/crFShMhQ1lGmT003OA2V+SsDo
         Q/WXOb9AcsVL9lajjMGId172Q5oKyh2yDGYxyO/VPXMCG4dV2xcxYBiY3dQ9BoWGBuTH
         ML1NCtyTGV7vucw0rWegUicyQLV/3SmqNXzCP+pJiG1FyZ+7DMQS8PAdCnkcw+q7kFSM
         l5Gg==
X-Gm-Message-State: AOJu0Yx+fjZtTKt4vU/136KWGDL7MtP4SCCaf9z3HXehl2NhUKVuVCE1
	qeXnqOHGLpwGzZPgJSXIp/w+
X-Google-Smtp-Source: AGHT+IFlANwUDSGd5XPpy2qZbzYDd6htcTyx/Nw7NjuSSv96jvDu+tD5S18+TtoeaDp8BF0BsIsOLA==
X-Received: by 2002:a05:6a20:6e22:b0:18f:97c:4f4b with SMTP id go34-20020a056a206e2200b0018f097c4f4bmr2292930pzb.87.1702018786881;
        Thu, 07 Dec 2023 22:59:46 -0800 (PST)
Received: from localhost.localdomain ([117.216.123.142])
        by smtp.gmail.com with ESMTPSA id n8-20020a170902e54800b001b03f208323sm934263plf.64.2023.12.07.22.59.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Dec 2023 22:59:46 -0800 (PST)
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: martin.petersen@oracle.com,
	jejb@linux.ibm.com
Cc: andersson@kernel.org,
	konrad.dybcio@linaro.org,
	linux-arm-msm@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	quic_cang@quicinc.com,
	ahalaney@redhat.com,
	quic_nitirawa@quicinc.com,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 06/17] scsi: ufs: qcom: Export ufshcd_{enable/disable}_irq helpers and make use of them
Date: Fri,  8 Dec 2023 12:28:51 +0530
Message-Id: <20231208065902.11006-7-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231208065902.11006-1-manivannan.sadhasivam@linaro.org>
References: <20231208065902.11006-1-manivannan.sadhasivam@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of duplicating the enable/disable IRQ part, let's export the
helpers available in ufshcd driver and make use of them. This also fixes
the possible redundant IRQ disable before asserting reset (when IRQ was
already disabled).

Fixes: 4a791574a0cc ("scsi: ufs: ufs-qcom: Disable interrupt in reset path")
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/ufs/core/ufshcd.c   | 6 ++++--
 drivers/ufs/host/ufs-qcom.c | 9 +++------
 include/ufs/ufshcd.h        | 2 ++
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 8b1031fb0a44..671facc73921 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -289,21 +289,23 @@ static void ufshcd_wb_toggle_buf_flush_during_h8(struct ufs_hba *hba,
 static void ufshcd_hba_vreg_set_lpm(struct ufs_hba *hba);
 static void ufshcd_hba_vreg_set_hpm(struct ufs_hba *hba);
 
-static inline void ufshcd_enable_irq(struct ufs_hba *hba)
+void ufshcd_enable_irq(struct ufs_hba *hba)
 {
 	if (!hba->is_irq_enabled) {
 		enable_irq(hba->irq);
 		hba->is_irq_enabled = true;
 	}
 }
+EXPORT_SYMBOL_GPL(ufshcd_enable_irq);
 
-static inline void ufshcd_disable_irq(struct ufs_hba *hba)
+void ufshcd_disable_irq(struct ufs_hba *hba)
 {
 	if (hba->is_irq_enabled) {
 		disable_irq(hba->irq);
 		hba->is_irq_enabled = false;
 	}
 }
+EXPORT_SYMBOL_GPL(ufshcd_disable_irq);
 
 static void ufshcd_configure_wb(struct ufs_hba *hba)
 {
diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index d474de0739e4..604273a22afd 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -300,8 +300,7 @@ static int ufs_qcom_host_reset(struct ufs_hba *hba)
 		return 0;
 
 	reenable_intr = hba->is_irq_enabled;
-	disable_irq(hba->irq);
-	hba->is_irq_enabled = false;
+	ufshcd_disable_irq(hba);
 
 	ret = reset_control_assert(host->core_reset);
 	if (ret) {
@@ -324,10 +323,8 @@ static int ufs_qcom_host_reset(struct ufs_hba *hba)
 
 	usleep_range(1000, 1100);
 
-	if (reenable_intr) {
-		enable_irq(hba->irq);
-		hba->is_irq_enabled = true;
-	}
+	if (reenable_intr)
+		ufshcd_enable_irq(hba);
 
 	return 0;
 }
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 7f0b2c5599cd..f1fc16ac6af2 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1231,6 +1231,8 @@ static inline void ufshcd_rmwl(struct ufs_hba *hba, u32 mask, u32 val, u32 reg)
 	ufshcd_writel(hba, tmp, reg);
 }
 
+void ufshcd_enable_irq(struct ufs_hba *hba);
+void ufshcd_disable_irq(struct ufs_hba *hba);
 int ufshcd_alloc_host(struct device *, struct ufs_hba **);
 void ufshcd_dealloc_host(struct ufs_hba *);
 int ufshcd_hba_enable(struct ufs_hba *hba);
-- 
2.25.1

