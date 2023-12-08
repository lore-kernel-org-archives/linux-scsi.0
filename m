Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rHOy/IwR"
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E6DA1987
	for <linux-scsi@vger.kernel.org>; Thu,  7 Dec 2023 23:00:27 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1d04dba2781so14787765ad.3
        for <linux-scsi@vger.kernel.org>; Thu, 07 Dec 2023 23:00:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1702018826; x=1702623626; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jL9z1/vZzZLZROJW1gRidiD4hf3DEiFp/UIXcZDRkcc=;
        b=rHOy/IwRDg2AySpVozsj22bhZyCdt7kqO7MXbP6bnYQMYOHMoYzuZXLUoERX3N0mN7
         IurNclhZJEo6Rx3L6ew9ak6HgTinNzyX+272zGGaaqYrd0JDwTuZDD75PTr3/bZt78kD
         Pd3t8zhHPefB8BXvX0SyTThkwDW1uPSmkOUkCjX/XhcOQJTjQ7owj8ThMJcS8Vx4uZPy
         eUiL6oXivScdDyPps+PY/mw4Yr4YKERvxSUZddPzeNxF9oE7ibC9sdO71XmE/F0Z64kM
         WCCI//5VF7+TzTOBFWX8FnoWSMfgolWNp5JS3DE5+09LBd2CMpuKUtpWx383EEbaNblE
         cDUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702018826; x=1702623626;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jL9z1/vZzZLZROJW1gRidiD4hf3DEiFp/UIXcZDRkcc=;
        b=ZVGQchvqoj1KNITY4n+ZiRelFrg5LZPM0kJBVS3rZE1LQDKTnrZ16/4+M8q/W4zTkJ
         Wwn6QTDfAX9oIAkHibHq9xXdqi7fwhYKPFpthUc+SZ7MR9XswhTeYJNCNimhnJRZNtPB
         dF6iFJLqr2iUiDp8p2SN30kvhXzCvIxhTHSQsWjBdb/qG6IfW+ErXbcOmjsQ7ZPjsz51
         tvg8jHp1i6nqB0ZTWM2/CnT86nXU53k3xytwOlt9FYkGqyoCHjJwbVyKhwtLkWTKzCq3
         91Wpd8Qw/Bva/vR2vGdA/R25Vs1FsVaCqJ8462aF7b1K81BDCNpKjnIcmKh5FEmSpQzp
         kFPw==
X-Gm-Message-State: AOJu0Yx54w0UNXKSdOM08Pvg6zxUyPwtf4Y5ukJGobxsPcboaIGoLSJ0
	wFUgzpdvnv+THlXGc46ahv+z
X-Google-Smtp-Source: AGHT+IGCvffDTxUFdEuyd5JIhFtq68gOkH/G7XBlHWwJltw1YgZE13vGTg+aS1+bHxo+EqtrQfQy/Q==
X-Received: by 2002:a17:903:247:b0:1d0:5878:d4e3 with SMTP id j7-20020a170903024700b001d05878d4e3mr4024291plh.9.1702018826702;
        Thu, 07 Dec 2023 23:00:26 -0800 (PST)
Received: from localhost.localdomain ([117.216.123.142])
        by smtp.gmail.com with ESMTPSA id n8-20020a170902e54800b001b03f208323sm934263plf.64.2023.12.07.23.00.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Dec 2023 23:00:26 -0800 (PST)
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
Subject: [PATCH v2 14/17] scsi: ufs: qcom: Simplify ufs_qcom_{assert/deassert}_reset
Date: Fri,  8 Dec 2023 12:28:59 +0530
Message-Id: <20231208065902.11006-15-manivannan.sadhasivam@linaro.org>
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

In both the functions, UFS_PHY_SOFT_RESET contains the mask of the reset
bit. So this can be passed directly as the value to be written for
asserting the reset. For deasserting, 0 can be passed.

This gets rid of the FIELD_PREP() inside these functions and also
UFS_PHY_RESET_{ENABLE/DISABLE} definitions.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/ufs/host/ufs-qcom.h | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
index 53db424a0bcb..a109d3359db4 100644
--- a/drivers/ufs/host/ufs-qcom.h
+++ b/drivers/ufs/host/ufs-qcom.h
@@ -92,9 +92,6 @@ enum {
 #define TEST_BUS_SEL		GENMASK(22, 19)
 #define UFS_REG_TEST_BUS_EN	BIT(30)
 
-#define UFS_PHY_RESET_ENABLE	1
-#define UFS_PHY_RESET_DISABLE	0
-
 /* bit definitions for REG_UFS_CFG2 register */
 #define UAWM_HW_CGC_EN		BIT(0)
 #define UARM_HW_CGC_EN		BIT(1)
@@ -157,8 +154,7 @@ ufs_qcom_get_controller_revision(struct ufs_hba *hba,
 
 static inline void ufs_qcom_assert_reset(struct ufs_hba *hba)
 {
-	ufshcd_rmwl(hba, UFS_PHY_SOFT_RESET, FIELD_PREP(UFS_PHY_SOFT_RESET, UFS_PHY_RESET_ENABLE),
-		    REG_UFS_CFG1);
+	ufshcd_rmwl(hba, UFS_PHY_SOFT_RESET, UFS_PHY_SOFT_RESET, REG_UFS_CFG1);
 
 	/*
 	 * Make sure assertion of ufs phy reset is written to
@@ -169,8 +165,7 @@ static inline void ufs_qcom_assert_reset(struct ufs_hba *hba)
 
 static inline void ufs_qcom_deassert_reset(struct ufs_hba *hba)
 {
-	ufshcd_rmwl(hba, UFS_PHY_SOFT_RESET, FIELD_PREP(UFS_PHY_SOFT_RESET, UFS_PHY_RESET_DISABLE),
-		    REG_UFS_CFG1);
+	ufshcd_rmwl(hba, UFS_PHY_SOFT_RESET, 0, REG_UFS_CFG1);
 
 	/*
 	 * Make sure de-assertion of ufs phy reset is written to
-- 
2.25.1

