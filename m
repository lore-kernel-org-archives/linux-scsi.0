Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YeyAgzSG"
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02CE3173E
	for <linux-scsi@vger.kernel.org>; Thu,  7 Dec 2023 23:00:22 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1d06fffdb65so13715745ad.2
        for <linux-scsi@vger.kernel.org>; Thu, 07 Dec 2023 23:00:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1702018821; x=1702623621; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LGLbsXXGOS5hXbJdfbXpRGohhCcqKUKVxgEMXEAy08s=;
        b=YeyAgzSGcDH+2e7mqUPgeHxqYUjbbNguQ3NgSgLy8KXb37NZm2krkB/+f9OXYjUqMK
         sEXsPwQzfm+uGCGugVgye7qgyHpoIzFi30oGTubgjjR0Zb8aaZ0KMwJR9dGmm56SqqUu
         /PAijbv9nP/ZhIk4Lz2utUCTppKLSyXOX3Vnk/nIBpa1NGVPbMrBA04ecUlpVuXFjhHu
         JP2mo+qGTG4ljzQyXS279N6RjvkcSP+2IErsnn6ErgYnFc0H6HHYA/3SWJpTgMVMB9qP
         8o0frzK1OfXLKkrwI4GsYdojndt1+IH2U3HGknpFhmBlzlG6oo39RQvQXbx2z2mqXxsT
         73cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702018821; x=1702623621;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LGLbsXXGOS5hXbJdfbXpRGohhCcqKUKVxgEMXEAy08s=;
        b=C29YJu6AYM/AQyAkKoctOjOLIemHyggatIPVtDqPv6v9md6xTBWAKFnuvZntTDhFer
         MF6uO8rWeNFfQQF9s9/wkxOkNfCjYPhRSgY9ot/oprLLkZD9kP6sy5GLN5eIltWKz7Bv
         1VHrU6waZ3hFRGvH0FvDd21Pd9AxBS8xb39/ZHEM0jQzMxFAF+fCH6b3BTdcxPI7wnom
         P6v20yiiYzgfZy2QUMGnIx5chbEy8H3zdSSmW7/P3YiG3lNH9JT/vfmLO08s2nHjzFDi
         Wz4T7mTloV/fqBekqMS0/cc6S43ly1W1GDZ41Igh1pkHpCEouRcg7JV9rVPBTnYr4ReL
         nDLQ==
X-Gm-Message-State: AOJu0YxqJeG23qC01QRHv6Zgo7hYYJ9VXCV+N6GO3JroakuKCvGmsbAs
	hApDECi3Q0hAEbHzsTnLuV2O
X-Google-Smtp-Source: AGHT+IFVUyG4dUS2LcbHQXN+dYuFi0KCByDG/dbfAzTMOhqxdP9LZSqbkTlmoGdGcQDFMbhwvqbFcw==
X-Received: by 2002:a17:902:b70d:b0:1d0:8c3c:a123 with SMTP id d13-20020a170902b70d00b001d08c3ca123mr3278106pls.38.1702018821392;
        Thu, 07 Dec 2023 23:00:21 -0800 (PST)
Received: from localhost.localdomain ([117.216.123.142])
        by smtp.gmail.com with ESMTPSA id n8-20020a170902e54800b001b03f208323sm934263plf.64.2023.12.07.23.00.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Dec 2023 23:00:20 -0800 (PST)
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
Subject: [PATCH v2 13/17] scsi: ufs: qcom: Initialize cycles_in_1us variable in ufs_qcom_set_core_clk_ctrl()
Date: Fri,  8 Dec 2023 12:28:58 +0530
Message-Id: <20231208065902.11006-14-manivannan.sadhasivam@linaro.org>
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

In case the "core_clk_unipro" clock is not provided, "cycles_in_1us"
variable will be used as uninitialized. So initialize it with 0.

Issue reported by Smatch tool:

drivers/ufs/host/ufs-qcom.c:1336 ufs_qcom_set_core_clk_ctrl() error: uninitialized symbol 'cycles_in_1us'.
drivers/ufs/host/ufs-qcom.c:1341 ufs_qcom_set_core_clk_ctrl() error: uninitialized symbol 'cycles_in_1us'.

Reviewed-by: Nitin Rawat <quic_nitirawa@quicinc.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/ufs/host/ufs-qcom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 7fbd35a3eb81..9b3d6d3609c9 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -1298,7 +1298,7 @@ static int ufs_qcom_set_core_clk_ctrl(struct ufs_hba *hba, bool is_scale_up)
 	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
 	struct list_head *head = &hba->clk_list_head;
 	struct ufs_clk_info *clki;
-	u32 cycles_in_1us;
+	u32 cycles_in_1us = 0;
 	u32 core_clk_ctrl_reg;
 	int err;
 
-- 
2.25.1

