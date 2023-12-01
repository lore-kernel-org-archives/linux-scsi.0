Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="piBUBkG9"
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA228D4A
	for <linux-scsi@vger.kernel.org>; Fri,  1 Dec 2023 07:14:49 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-6cdd214bce1so2208568b3a.3
        for <linux-scsi@vger.kernel.org>; Fri, 01 Dec 2023 07:14:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701443689; x=1702048489; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XnOqh3tKVGxzLKVliMslkL85vI3TlFUJ6BYDSjXWVCM=;
        b=piBUBkG9uHOi7mSVIxeCLVNiNuoR5BzdVQJJ7IgkhhSgJjpokyXpjW2euko5Ymd/SB
         jK5xDHPEq5Mn56qcprjXt28xqoT5HfhEzxXE9NC5Js/i9wbU66PPB2kjie0Wxwu2zhkn
         k7UoEqaUPYReoaMozX1s4wB5Gp4iNk3bKnaN3KnaHyP0MEimdy9iYl+i1Fyhwyry6SaZ
         0ybrqzZEfpe1kV1H/h0rjb+9gScTZcPDb48biWNU3fyPC+OBL6KSpYYC3or3JY8Dtma0
         8hI0e0Vkkcw6gmtBP9RPUoidPKMNckytaBj2QySybHla8YZ2i0xPPxHnml5lOnyYGSuO
         QmAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701443689; x=1702048489;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XnOqh3tKVGxzLKVliMslkL85vI3TlFUJ6BYDSjXWVCM=;
        b=PLHKlVJeDHG3I4BhxOLhk45od92xTT8aJloQM3grK7a5VUJK72QaxeJoM01++H0Njn
         ub3Xqap6H9VOxriPzqRDw5+X0T3SjUqNBmsh7tj60yh5/1MT2x0mszHXkq6aY5WPs6tK
         oAxdY1i2BPkRqHkbrOd8YyPAqZZlrGgXeZafRN7UHGattoMnLC5sZM26Vn7NYfKPYvYw
         MTqL2nhPz2mW0UB2aiM3yjBPZDSpH5ICUau8zrAmno753b+89yfZ6uZkbs7ut7F1309h
         4+G9fnRIJEhZuq1AcarQIW+Ja6hTdL07VYNl6zC19ipC+rnLHBOt4IImplJSaeTtHJh/
         pgNg==
X-Gm-Message-State: AOJu0Yw+SXh16iyrOwQa5n1A+E4/sxk3R7KFGqYhgBTW48BOcZt4dmsv
	NkEnu/8/ICcg762YogyGI5P0
X-Google-Smtp-Source: AGHT+IFRok/PPbeYz1jt5sDzaQAYKwisws8ppClXIyJSzhqJBqHMFReTc4GN3X4WZgb17WbfSDMXFw==
X-Received: by 2002:a05:6a21:150a:b0:18a:f462:5d3c with SMTP id nq10-20020a056a21150a00b0018af4625d3cmr30375005pzb.12.1701443689407;
        Fri, 01 Dec 2023 07:14:49 -0800 (PST)
Received: from localhost.localdomain ([117.213.98.226])
        by smtp.gmail.com with ESMTPSA id s14-20020a65644e000000b00578afd8e012sm2765824pgv.92.2023.12.01.07.14.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Dec 2023 07:14:48 -0800 (PST)
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
Subject: [PATCH 05/13] scsi: ufs: qcom: Remove the warning message when core_reset is not available
Date: Fri,  1 Dec 2023 20:44:09 +0530
Message-Id: <20231201151417.65500-6-manivannan.sadhasivam@linaro.org>
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

core_reset is optional, so there is no need to warn the user if it is not
available (that too not while doing host reset each time).

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/ufs/host/ufs-qcom.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index dc93b1c5ca74..d474de0739e4 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -296,10 +296,8 @@ static int ufs_qcom_host_reset(struct ufs_hba *hba)
 	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
 	bool reenable_intr;
 
-	if (!host->core_reset) {
-		dev_warn(hba->dev, "%s: reset control not set\n", __func__);
+	if (!host->core_reset)
 		return 0;
-	}
 
 	reenable_intr = hba->is_irq_enabled;
 	disable_irq(hba->irq);
-- 
2.25.1

