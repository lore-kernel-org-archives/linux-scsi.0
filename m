Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yk2bjEZQ"
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C48719A1
	for <linux-scsi@vger.kernel.org>; Thu,  7 Dec 2023 23:00:37 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1d0897e99e0so13418585ad.3
        for <linux-scsi@vger.kernel.org>; Thu, 07 Dec 2023 23:00:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1702018837; x=1702623637; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2+/0RBXo0Ut4g1LSue/1QXAxKJHirjkCQZ0L8v6kdO8=;
        b=yk2bjEZQKAPbt/lcroBL2+Q3vcqcuVHba2GQWYL5FLG/dloUc4E3I21h6nuF0P0gWD
         NBJRCtfXYWtr3B9LvlWGtobzaK4eHq8k93gQM7vh8nOBq73870XuTRQ8bVaNNQrdAyfn
         n1Efo3+7Cx94QENoH0IoKdi4K7wsZED7kNMnTFiLoyELUyfkD0BxoE2lQyAHA6a6UW6b
         MO05F0zKMNtgXKLxRgsW4QY9CITUhUR8r9Wpcg4mDf0yQPp7jUm0xzovIxw89/Kylv59
         avE/+bv1RxxV1j+5w6tNFaP+bJNCSziNdCHxKV2gZpoIp0FHhA5D+CMhmwrbCGtyOmTU
         tx/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702018837; x=1702623637;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2+/0RBXo0Ut4g1LSue/1QXAxKJHirjkCQZ0L8v6kdO8=;
        b=IgXb2gMYHwGQjZCHlA9tQ2nvMiLVGNcsU26YdHNa39PQoczor3fI/TJ7hvWCrg6Jp7
         KJzqIJ9mi9WYp9EoPwYVlqpABAhZaJczTlAzA1BXsSprhzk57WuTHe6Dv5A2WD7Zos31
         SQ+3/rgifs8vvI0UDoev/KCpco6UCYjd2aEBluI+VdhnzQVO/1PdgroDb40fNYGmw/ju
         rL+Y0TpanJ59FtD64cB8zUf5HNXm3xs6JZfnyxGnBj9kKD9qP3X8v2Ote/Z9WMJ/lJjU
         rj8wJ8FNGNA1O3Q7viKD88F9V8E4nOvY1k/OyxomYOXtvfTD7Ns5By3wvsWGRtrHQLze
         WlRg==
X-Gm-Message-State: AOJu0YwOndX9XUQGOkBWSxEwlWNXLVOd302IV1ID72WZy3RduG8gwlYi
	40cj6B8/6wm8lk6v5rn9+mxC
X-Google-Smtp-Source: AGHT+IFpgePBTs9KhPg66z+JEsh/VBMJvj2ot9J4I6Jvibmo2uaLDB8nY99jgWPitg1JXnJO+3F1gg==
X-Received: by 2002:a17:902:7d97:b0:1d0:71ab:b9b4 with SMTP id a23-20020a1709027d9700b001d071abb9b4mr3508248plm.90.1702018837001;
        Thu, 07 Dec 2023 23:00:37 -0800 (PST)
Received: from localhost.localdomain ([117.216.123.142])
        by smtp.gmail.com with ESMTPSA id n8-20020a170902e54800b001b03f208323sm934263plf.64.2023.12.07.23.00.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Dec 2023 23:00:36 -0800 (PST)
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
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH v2 16/17] scsi: ufs: qcom: Use ufshcd_rmwl() where applicable
Date: Fri,  8 Dec 2023 12:29:01 +0530
Message-Id: <20231208065902.11006-17-manivannan.sadhasivam@linaro.org>
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

Instead of using both ufshcd_readl() and ufshcd_writel() to read/modify/
write a register, let's make use of the existing helper.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/ufs/host/ufs-qcom.c | 12 ++++--------
 drivers/ufs/host/ufs-qcom.h |  3 +++
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 26aa8904c823..549a08645391 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -387,9 +387,8 @@ static int ufs_qcom_power_up_sequence(struct ufs_hba *hba)
  */
 static void ufs_qcom_enable_hw_clk_gating(struct ufs_hba *hba)
 {
-	ufshcd_writel(hba,
-		ufshcd_readl(hba, REG_UFS_CFG2) | REG_UFS_CFG2_CGC_EN_ALL,
-		REG_UFS_CFG2);
+	ufshcd_rmwl(hba, REG_UFS_CFG2_CGC_EN_ALL, REG_UFS_CFG2_CGC_EN_ALL,
+		    REG_UFS_CFG2);
 
 	/* Ensure that HW clock gating is enabled before next operations */
 	mb();
@@ -1689,11 +1688,8 @@ static int ufs_qcom_config_esi(struct ufs_hba *hba)
 		platform_msi_domain_free_irqs(hba->dev);
 	} else {
 		if (host->hw_ver.major == 6 && host->hw_ver.minor == 0 &&
-		    host->hw_ver.step == 0) {
-			ufshcd_writel(hba,
-				      ufshcd_readl(hba, REG_UFS_CFG3) | 0x1F000,
-				      REG_UFS_CFG3);
-		}
+		    host->hw_ver.step == 0)
+			ufshcd_rmwl(hba, ESI_VEC_MASK, 0x1f00, REG_UFS_CFG3);
 		ufshcd_mcq_enable_esi(hba);
 	}
 
diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
index 385480499e71..2ce63a1c7f2f 100644
--- a/drivers/ufs/host/ufs-qcom.h
+++ b/drivers/ufs/host/ufs-qcom.h
@@ -102,6 +102,9 @@ enum {
 #define TMRLUT_HW_CGC_EN	BIT(6)
 #define OCSC_HW_CGC_EN		BIT(7)
 
+/* bit definitions for REG_UFS_CFG3 register */
+#define ESI_VEC_MASK		GENMASK(22, 12)
+
 /* bit definitions for REG_UFS_PARAM0 */
 #define MAX_HS_GEAR_MASK	GENMASK(6, 4)
 #define UFS_QCOM_MAX_GEAR(x)	FIELD_GET(MAX_HS_GEAR_MASK, (x))
-- 
2.25.1

