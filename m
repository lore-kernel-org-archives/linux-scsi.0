Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="a/WAEUWw"
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DEDD1730
	for <linux-scsi@vger.kernel.org>; Fri,  1 Dec 2023 07:15:06 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id 41be03b00d2f7-5c1f8b0c149so472177a12.3
        for <linux-scsi@vger.kernel.org>; Fri, 01 Dec 2023 07:15:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701443705; x=1702048505; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7s+dxOARPtmuDtxtrPmYWXFcx5QSwMABsj/xuwm0cfM=;
        b=a/WAEUWwXBU2IwTd/1lnStFpgCNRsM5snta4eqSqhLzBSBwpsjhVCyYVYV2lD/WBVS
         mbK/kKi8hhafFgki7Qke4VWPLBaLVImDjo6NBPn1bm3a1GvCkZ0+dXjGVHMVK+yz+ULe
         oYrdGfOX5MjAeEeT4kdwQP9lF1ejE8xyN2lHRc6ITB5fuWqYJepJip1GcRZ6r3sphNuX
         Qtzf+A6M6VkKAP2DtPIU5aln+GiDMb3JrCAeXSJU6d9i+kCdsm1ElijHkwoTVlLBuS/r
         FeoRBICXTsomzzFwdEpmQnGC+jZXB6VG2ejEmh3/xzob3O/wH+KPR86ty7Nt/YJjAb41
         cXAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701443705; x=1702048505;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7s+dxOARPtmuDtxtrPmYWXFcx5QSwMABsj/xuwm0cfM=;
        b=XpooqOFwG5AwjFIXVNw8E7oTC5JqrhjPFCm5JR5itiv1UpxBXuqkRFbac8qwgPKxzX
         rqaKNDiNwNN2jCZy0P9qkudZ9/xC1tVqWOqLL0M8FzEyMeDEIZskkdi8o4Wqhjd3hPaT
         al/TlcK57L8sbHd7FhcIuW/newu/f/71XxkLBDTdq9Gu5GjSNwV0uOaKVyj8Z9mmtyHM
         hsiEL9CWXWYzHQXR7jLIUpanok2j+dMGMJ691bAMo8s0gfmohM6mSORPCT9eNpCpB8Jz
         W69zNk93pKdjGzNgb8tq2LOjI/ASpdiL37KttY/llyN6iHi/e/5xWtAHl7BBgtNEJEDu
         UOew==
X-Gm-Message-State: AOJu0YzPRL8W0Z5utE7PlZrlHogV08x/EbwD8ING/bcQM4xA6q9xN6+t
	j+JqsvYrwWc8Oj7kMunmJqaa
X-Google-Smtp-Source: AGHT+IFvJZzkDlY46j20YHiJ2dxic5gDp8k5OB44MAkItevykW7t58SjWek1DweEF2vi9nrFLvLUYg==
X-Received: by 2002:a17:90b:1a8d:b0:285:81aa:aec0 with SMTP id ng13-20020a17090b1a8d00b0028581aaaec0mr26173302pjb.12.1701443705444;
        Fri, 01 Dec 2023 07:15:05 -0800 (PST)
Received: from localhost.localdomain ([117.213.98.226])
        by smtp.gmail.com with ESMTPSA id s14-20020a65644e000000b00578afd8e012sm2765824pgv.92.2023.12.01.07.15.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Dec 2023 07:15:04 -0800 (PST)
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: martin.petersen@oracle.com,
	jejb@linux.ibm.com
Cc: andersson@kernel.org,
	konrad.dybcio@linaro.org,
	linux-arm-msm@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	quic_cang@quicinc.com,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 09/13] scsi: ufs: qcom: Remove redundant error print for devm_kzalloc() failure
Date: Fri,  1 Dec 2023 20:44:13 +0530
Message-Id: <20231201151417.65500-10-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231201151417.65500-1-manivannan.sadhasivam@linaro.org>
References: <20231201151417.65500-1-manivannan.sadhasivam@linaro.org>
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
index e4dd3777a4d4..218d22e1efce 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -1107,10 +1107,8 @@ static int ufs_qcom_init(struct ufs_hba *hba)
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

