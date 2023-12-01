Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OqYs0GmF"
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28456171C
	for <linux-scsi@vger.kernel.org>; Fri,  1 Dec 2023 07:14:59 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-6cde4aeea29so1897299b3a.2
        for <linux-scsi@vger.kernel.org>; Fri, 01 Dec 2023 07:14:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701443698; x=1702048498; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S5u5mj8ueK+oc2yv8mZg26TvQm1X83rBh8cXq05A5b8=;
        b=OqYs0GmF8HFxp5IsgzqAulfJFTwog24rf3mni9vKI2/sxOm9JPq3BaymnyA3lIYbDq
         lGSX+JeE8BOmoWcJ/af2/C8Z+yk8j73ivOFvKMKt3z7hSLpuZBIN2rheDuC1e24em4Hu
         eNpbL5BMEQjQQjMX5piE943Zp5ANR/GLCN2tG1JtzFsrpDZtQ2cLI9EoNr/QiQVAtCf3
         Q5i7E6PPHlYSfWrNvjBgtCYiSeCGGs9H4Kz412qih8tCbREub2ythCx2gF1NU65jOOKh
         GW78sJammyY7wBmDChniak6rErGEUS+maCY9+Pzuo4QwbzbFoy6qqG1nfNpQCAR/9fWz
         DMig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701443698; x=1702048498;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S5u5mj8ueK+oc2yv8mZg26TvQm1X83rBh8cXq05A5b8=;
        b=ROc9+1N7Lvp1KUZ2Wpvz0kPTRmuJb+6PXfV4/pLRapn48yVghq1wDNYCB34Q762/ME
         qoTDuIaJ7d2HoVetv7QUXfQDf/rpQWAebthNL7N44dx+SAaXw+FuAdCIXtuhjokzGtYc
         w9IY4zRSKG5wXsMI4ZNtp6DrYG/FlnySmBCR1pZ9AdlqPmc3jbQZtxf4sfgtCBig3gvj
         lkGD3JulmS2JZIjWKLUe8E/6PaqKKlGMcBK8/6ssdJE8IDL/TXbiKs/eFcBq2Dj0oTJV
         5ZrAsuMjeQMQfYCtLG2O5lTORPoLa7evmEIN4VnbS0+OYgb9D1/wK9/w0z6eYPsX0020
         8JSQ==
X-Gm-Message-State: AOJu0Yy8fQ9B9I2w5WiNMUqBbpURwT7OjWOAgo+6Bye7jXX1pDLP/zYZ
	XXIeBPfFNKkgIMbU9g/SA721
X-Google-Smtp-Source: AGHT+IEjBAHxDNnswReyTsQ/wgyRVee0zz+RTPON/r87o5NDp9vCjrHC67XAbwc0Yi+6bHfU1R4nag==
X-Received: by 2002:a05:6a20:548e:b0:18c:8d0f:a794 with SMTP id i14-20020a056a20548e00b0018c8d0fa794mr19592802pzk.19.1701443698551;
        Fri, 01 Dec 2023 07:14:58 -0800 (PST)
Received: from localhost.localdomain ([117.213.98.226])
        by smtp.gmail.com with ESMTPSA id s14-20020a65644e000000b00578afd8e012sm2765824pgv.92.2023.12.01.07.14.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Dec 2023 07:14:58 -0800 (PST)
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
Subject: [PATCH 07/13] scsi: ufs: qcom: Fail ufs_qcom_power_up_sequence() when core_reset fails
Date: Fri,  1 Dec 2023 20:44:11 +0530
Message-Id: <20231201151417.65500-8-manivannan.sadhasivam@linaro.org>
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

Even though core_reset is optional, a failure during assert/deassert should
be considered fatal, if core_reset is available. So fail
ufs_qcom_power_up_sequence() if an error happens during reset and also get
rid of the redundant warning as the ufs_qcom_host_reset() function itself
prints error messages.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/ufs/host/ufs-qcom.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 604273a22afd..4948dd732aae 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -359,8 +359,7 @@ static int ufs_qcom_power_up_sequence(struct ufs_hba *hba)
 	/* Reset UFS Host Controller and PHY */
 	ret = ufs_qcom_host_reset(hba);
 	if (ret)
-		dev_warn(hba->dev, "%s: host reset returned %d\n",
-				  __func__, ret);
+		return ret;
 
 	/* phy initialization - calibrate the phy */
 	ret = phy_init(phy);
-- 
2.25.1

