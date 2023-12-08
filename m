Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="w17CAwjn"
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 500E3198B
	for <linux-scsi@vger.kernel.org>; Thu,  7 Dec 2023 23:00:02 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1d1e1edb10bso16238115ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 07 Dec 2023 23:00:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1702018802; x=1702623602; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZMlhD8WS0RVtXNWZq8+Ekz+zAl7Mbew6ctHcI4T3R2A=;
        b=w17CAwjnBiSA5PJez0PVyJiJdKr/bj+JBOG20onw+6Kv5mV1jQX9kB9ucvfRm1QHs/
         c2jwDB3MqsglMdnhWbqWuVqvbrVeQDGTlTDVBigWMpryNNVx3vhS39gDjuuYbyj5c21y
         QwyephmqTeaTT4CfzzCZ41c7fNJfP3LTVWWvLKXlxQnlBA+0NWY+ZTUdV6b8TOnMzk4T
         Cpc3d7vOH+etmycLfQrfGZIq8xioTBmpi/zHcLTL+1KbcWybspNc6wNRzGty9KJxe3yF
         oW8pr+uHjJbTuEO66KtKGY/qFPGm1xz9XXxvboOb5DgLmoGAGnfKvB2JalZ8VVqWecKG
         Yfmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702018802; x=1702623602;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZMlhD8WS0RVtXNWZq8+Ekz+zAl7Mbew6ctHcI4T3R2A=;
        b=nfsTrI+qaUt1xwssn2+Sn/xxxhg+Il0TIXgCTe06LCHcIdPOoK4H7cE/am2DbtqRXd
         fhWbn0fpFOlVyBW1dfayvxtaP4svyEUSqpkXIEuGNpP+k0YV3t+fcarlQyT5zIuP6xIv
         MZJJQrM1xXyeXBUN7rvHxk2o8239yPUEIJWuKM5AnqRExm38/8mc0/7Y7u+HC+eRn0c1
         QxGA5X0+QhXI57um6ju3R6TggTB+9hgsNyxfHBCQqFHY9yxjNL/HoNE/1IYO1M72y9T1
         f14LB17zqa3j9Ge6GqF1OLTBJnKsuimoPdW4uSg652ljt1bPRFFYtI3pRfLosQvl7nL1
         MZPg==
X-Gm-Message-State: AOJu0YzQGJ2lmEWZAmgsuUorF90dKAaYnb/rlvooK7M28VqaTDDfQzDh
	+oKUcpIru3+O9X0voGtfClyC
X-Google-Smtp-Source: AGHT+IHccpHpLogCcC55e3YdRrf5zzuYzDmRVH4d9uufAv8PswsFT4A1IbRSAb8WkK22n3+dGsOP0g==
X-Received: by 2002:a17:902:f68e:b0:1cf:ad5f:20ab with SMTP id l14-20020a170902f68e00b001cfad5f20abmr4410627plg.19.1702018801803;
        Thu, 07 Dec 2023 23:00:01 -0800 (PST)
Received: from localhost.localdomain ([117.216.123.142])
        by smtp.gmail.com with ESMTPSA id n8-20020a170902e54800b001b03f208323sm934263plf.64.2023.12.07.22.59.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Dec 2023 23:00:01 -0800 (PST)
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
Subject: [PATCH v2 09/17] scsi: ufs: qcom: Remove redundant error print for devm_kzalloc() failure
Date: Fri,  8 Dec 2023 12:28:54 +0530
Message-Id: <20231208065902.11006-10-manivannan.sadhasivam@linaro.org>
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

devm_kzalloc() will itself print the error message on failure. So let's get
rid of the redundant error message in ufs_qcom_init().

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/ufs/host/ufs-qcom.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index b141dd2a9346..05a9a25bc34c 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -1109,10 +1109,8 @@ static int ufs_qcom_init(struct ufs_hba *hba)
 	struct ufs_clk_info *clki;
 
 	host = devm_kzalloc(dev, sizeof(*host), GFP_KERNEL);
-	if (!host) {
-		dev_err(dev, "%s: no memory for qcom ufs host\n", __func__);
+	if (!host)
 		return -ENOMEM;
-	}
 
 	/* Make a two way bind between the qcom host and the hba */
 	host->hba = hba;
-- 
2.25.1

