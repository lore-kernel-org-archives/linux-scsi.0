Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Sqi3qwLl"
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF79E115
	for <linux-scsi@vger.kernel.org>; Thu, 14 Dec 2023 04:55:43 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id d75a77b69052e-4258026a9fdso49759711cf.0
        for <linux-scsi@vger.kernel.org>; Thu, 14 Dec 2023 04:55:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1702558543; x=1703163343; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZYvEigRoKhZbgGLuv/4wRFyGkLXXYVjXdCoJrdge4oY=;
        b=Sqi3qwLlbp9FeKdI8GmTTRhMRTWkZp9S19FW4xUBP6+ZaUbH1O+R0Lmo4ayjaOpsHr
         VlwnVZBNQCtyzgu/xLlxjmKZTnTyBUfmgRNsjwIhNTlsqDAtGt3oT+IemsSoXbWm+pxn
         xevbT7swASnyBLZBUQK6u+2QSjwpVNauCD3iJx0DxGwaDrbR0ehQ+7VEA2XPSI3+dQz9
         zMzpqNHStUnbBItYmEcghuBzlrQyweXyJYMoz2IaqrC3dXtlr2FeqExB5UmEMFzfF8kZ
         5zDHu9wOHsjNYkFUfDAmnsqg6Yma/H29Kx6zb9xhBIeLFnaMYYLUP/vv64xSwVpQ0eXd
         NFZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702558543; x=1703163343;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZYvEigRoKhZbgGLuv/4wRFyGkLXXYVjXdCoJrdge4oY=;
        b=mGrRYgheZn+itlmqsY2i/u9RzxbXQnGXOLxPN0fRjVwnj1wbwI6INNxCCxxFup81sk
         mZGgSJ2KICH51GysAJHHkystnGmx2mD8u3bcaghmeYUYx4s0utDPXUzzmTGAg2taFDgF
         WwBUijl5lh4tklHybXzi0GydCEtnRoi1CwiBOe4zogT7kPgm/CpK2O4hY9lnbZ+Zj6SD
         cT0wdmeOm3EC1r30iRu/x0WR+vDQAGp8dyPMp5/RrpogZ+yh/HTcZQ6HfW3Z3Upgb+I6
         li4ZuPfw9ns7wTecKOmR/EopG8dQdbJ4gVMJMbTVDMXhC0L1YUyPmuli6aO083mjvtyD
         HRig==
X-Gm-Message-State: AOJu0YyvuBU6WzVJ8yAg8zXnIaM8uHgqiYaXZbTP8jzk/giIZ0sXZJot
	XO+xPFpBfXNX3NKq9vlAEhe1
X-Google-Smtp-Source: AGHT+IEy7mhPx0wsyEsM+VLjF3KlKQ6SL9f68/1wLMmcgtKQD6pj0h3a0IGYh27ImtTH/GZ7DXYtFw==
X-Received: by 2002:ac8:5fce:0:b0:423:77aa:163b with SMTP id k14-20020ac85fce000000b0042377aa163bmr11944057qta.51.1702558542823;
        Thu, 14 Dec 2023 04:55:42 -0800 (PST)
Received: from localhost.localdomain ([117.216.120.87])
        by smtp.gmail.com with ESMTPSA id hj1-20020a05622a620100b0042601b60861sm302377qtb.26.2023.12.14.04.55.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Dec 2023 04:55:42 -0800 (PST)
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: andersson@kernel.org,
	konrad.dybcio@linaro.org,
	jejb@linux.ibm.com,
	martin.petersen@oracle.com
Cc: linux-arm-msm@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH] scsi: ufs: qcom: Fix ESI vector mask
Date: Thu, 14 Dec 2023 18:25:32 +0530
Message-Id: <20231214125532.55109-1-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While cleaning up the code to use ufshcd_rmwl() helper, the ESI vector mask
was changed incorrectly. Fix it and also define a proper macro for the
value together with FIELD_PREP().

Reported-by: Andrew Halaney <ahalaney@redhat.com>
Fixes: 0e9f4375db1c ("scsi: ufs: qcom: Use ufshcd_rmwl() where applicable")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/ufs/host/ufs-qcom.c | 4 +++-
 drivers/ufs/host/ufs-qcom.h | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index d5cca5d3a98f..9fd8d737edea 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -1744,7 +1744,9 @@ static int ufs_qcom_config_esi(struct ufs_hba *hba)
 	} else {
 		if (host->hw_ver.major == 6 && host->hw_ver.minor == 0 &&
 		    host->hw_ver.step == 0)
-			ufshcd_rmwl(hba, ESI_VEC_MASK, 0x1f00, REG_UFS_CFG3);
+			ufshcd_rmwl(hba, ESI_VEC_MASK,
+				    FIELD_PREP(ESI_VEC_MASK, MAX_ESI_VEC - 1),
+				    REG_UFS_CFG3);
 		ufshcd_mcq_enable_esi(hba);
 	}
 
diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
index 9026fe243307..9dd9a391ebb7 100644
--- a/drivers/ufs/host/ufs-qcom.h
+++ b/drivers/ufs/host/ufs-qcom.h
@@ -15,6 +15,7 @@
 #define HBRN8_POLL_TOUT_MS      100
 #define DEFAULT_CLK_RATE_HZ     1000000
 #define MAX_SUPP_MAC		64
+#define MAX_ESI_VEC		32
 
 #define UFS_HW_VER_MAJOR_MASK	GENMASK(31, 28)
 #define UFS_HW_VER_MINOR_MASK	GENMASK(27, 16)

base-commit: ed340d13aa1db6773667ed4bf907738df203fbda
-- 
2.25.1

