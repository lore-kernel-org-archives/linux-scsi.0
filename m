Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dqpTXmDo"
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C5A81BF4
	for <linux-scsi@vger.kernel.org>; Fri,  1 Dec 2023 07:15:19 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-6cdfb72172aso913201b3a.1
        for <linux-scsi@vger.kernel.org>; Fri, 01 Dec 2023 07:15:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701443719; x=1702048519; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=99jwCtueYKuqHSnO06pq+vanF2UHvfzCABwBvmt41SY=;
        b=dqpTXmDoXE6wytJPhm2PCBQfp/5HV7AtqtFuSibrn7aUkYe89B32Er6GSctfWsodS3
         5adNy7vLCG/+vARD/4JbpdWTFJb8JGike3Oa9YjC3A18kQ5paNKCktHOGIWb5SY8rFdx
         hYwMu2edywVkLpgNa1FYcalgADmyGnWCieRxbjpkzNO96Q+qqi7AxLB3HcbyhJup1WKe
         9nAw/W4/BGMt8cMwavX5YXBQo2jeXN1wMH7Jxa/8X88R7KKhsq0gpmNI97pOpt2IC8lo
         ZdXDc5tnZxdwXd1Aekcl8X9VjzPKXRjDe60PRrzGBVhNdZUMd4PmmlSipE1Tu7p1+FCc
         po+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701443719; x=1702048519;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=99jwCtueYKuqHSnO06pq+vanF2UHvfzCABwBvmt41SY=;
        b=dCpjAFM6J1aaBVF3tCGsj/Somkt43NHRjmSbuIaK58MK3cTUOKcqOxOke8YTpPR8PQ
         COz0dj3N119aTmiNUQH8uAw0MV3ssvpeBC7oWjx25EMHbY9bgu9fgMmSa9afGl4cpJrV
         pizYxgn7TUqy0c+S034pm2D/L4Hs25Tze2Bt3TJQLjKe4qc8Uty7pIiPb4RDVjsNl9r8
         AJ+xOJ1nxG1YR3KRfMXDUChnEpYqnI2EaLqQ06aYWkruL/eURy3+r/sGd3CsJR/6UiNr
         NuH1OjUyTLBLZHcaQZ2WPi2qA8R8iwHA4CW008mhf3PtRVwQFsz1sSxQlZ9KRK5A/Eoa
         eiwg==
X-Gm-Message-State: AOJu0Yzxy5DyMfnHw53kym1Rgcp+MKEtMZDlcDXJSCEvgsIzG8AZXPbj
	9EriBOF//n35LNHm9GVfOCdc
X-Google-Smtp-Source: AGHT+IG0lDGObraHLt0PSday0c1vddh/0X4DzkGcDUEtJFQ4rieNhf2pWlFV1r7BSDu6rIgWhh5OOA==
X-Received: by 2002:a05:6a00:938d:b0:6cd:faa6:fc36 with SMTP id ka13-20020a056a00938d00b006cdfaa6fc36mr3968638pfb.30.1701443718764;
        Fri, 01 Dec 2023 07:15:18 -0800 (PST)
Received: from localhost.localdomain ([117.213.98.226])
        by smtp.gmail.com with ESMTPSA id s14-20020a65644e000000b00578afd8e012sm2765824pgv.92.2023.12.01.07.15.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Dec 2023 07:15:18 -0800 (PST)
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
Subject: [PATCH 13/13] scsi: ufs: qcom: Initialize cycles_in_1us variable in ufs_qcom_set_core_clk_ctrl()
Date: Fri,  1 Dec 2023 20:44:17 +0530
Message-Id: <20231201151417.65500-14-manivannan.sadhasivam@linaro.org>
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

In case the "core_clk_unipro" clock is not provided, "cycles_in_1us"
variable will be used as uninitialized. So initialize it with 0.

Issue reported by Smatch tool:

drivers/ufs/host/ufs-qcom.c:1336 ufs_qcom_set_core_clk_ctrl() error: uninitialized symbol 'cycles_in_1us'.
drivers/ufs/host/ufs-qcom.c:1341 ufs_qcom_set_core_clk_ctrl() error: uninitialized symbol 'cycles_in_1us'.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/ufs/host/ufs-qcom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 590a2c67cf7d..208543a62d43 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -1296,7 +1296,7 @@ static int ufs_qcom_set_core_clk_ctrl(struct ufs_hba *hba, bool is_scale_up)
 	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
 	struct list_head *head = &hba->clk_list_head;
 	struct ufs_clk_info *clki;
-	u32 cycles_in_1us;
+	u32 cycles_in_1us = 0;
 	u32 core_clk_ctrl_reg;
 	int err;
 
-- 
2.25.1

