Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="civyD6qH"
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E244619A1
	for <linux-scsi@vger.kernel.org>; Fri,  1 Dec 2023 07:15:12 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-6cdfb721824so888015b3a.3
        for <linux-scsi@vger.kernel.org>; Fri, 01 Dec 2023 07:15:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701443712; x=1702048512; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RbyUrAaftLH0a6pAoGx1Rl9IDQRbi9vKE/mvsuJjc8A=;
        b=civyD6qH10xgCdwlR5Oza3I6Aj2gy3qnQUJ9hL/6XcV5kOwyBNzfgfkEe/rH07/1m6
         MFcwdNVNHLk8GTXrR/4xLPULHMnQlHp1kWfHlq1iKNUCHkNtMdPIavZOogvaFJ9PsFG7
         8EXiO143NHCzdEGEnsH8vxnl88bSdQhErJfpvEwhOL60Nb9hqLmDatULZEqCgLRI4dtm
         qspGlc3059J9XcGhduZ8xcX3onfKyElk8R+n1pweNJ8U74OjRXJTzRLVNxaBLKYKgeqf
         aOrJSMo9NjbduC87IZkZp6OMwen+cdtU8PuaVZ1uQjAiPd/sIls0yz7RFI9ewPux/TZI
         ZjGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701443712; x=1702048512;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RbyUrAaftLH0a6pAoGx1Rl9IDQRbi9vKE/mvsuJjc8A=;
        b=vq90dHNYea/gCUWYZ0kOBMG1dz9sD0lsEEHQ2iQ6FO+t0r9hQMTGfm9zx9SHr9rBS2
         X+9xu7OO2BkjRQ2ONz6NK4LeiYPnwOBhDOmQV3n9d12nhbtgqNoTGmWGjkRTM5CM9PrG
         k+KhNmJKVNNz6pcGKxdN3eVwxnnUMMLAamP7spAW9StNsi+7fdovDxojZYMvwZZfcIZn
         eNdEGouP7ytVCqU63LnoH0j/mW431l8uZpyzBySqlg5N+fbMy3u8mLCqRA5n4F+y4+cS
         qAIlAYo2I1XBmegE1puYsitgtPDpnx1/8wouohPPiOpqejd88wOGl3mhDCLjpE4GAEqU
         c/Ww==
X-Gm-Message-State: AOJu0YxpUlCb0o2x3A27Q/pTYTcoNjWkL0bZeTJLQvFURxhfiAqMcTtv
	liqtJRFH7FNMoK5s+L0tTNMi
X-Google-Smtp-Source: AGHT+IFuCo2HXUNTDZ89i3ZUB/xN8N1lk9JFjN5kV2JC6maA9HXjbyuOLP1pqtskP+HahJYnCrsHJw==
X-Received: by 2002:a05:6a21:7891:b0:18b:950d:de3b with SMTP id bf17-20020a056a21789100b0018b950dde3bmr31394907pzc.38.1701443712159;
        Fri, 01 Dec 2023 07:15:12 -0800 (PST)
Received: from localhost.localdomain ([117.213.98.226])
        by smtp.gmail.com with ESMTPSA id s14-20020a65644e000000b00578afd8e012sm2765824pgv.92.2023.12.01.07.15.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Dec 2023 07:15:11 -0800 (PST)
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
Subject: [PATCH 11/13] scsi: ufs: qcom: Remove unused ufs_qcom_hosts struct array
Date: Fri,  1 Dec 2023 20:44:15 +0530
Message-Id: <20231201151417.65500-12-manivannan.sadhasivam@linaro.org>
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

ufs_qcom_hosts array is assigned, but not used anywhere. So let's remove
it.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/ufs/host/ufs-qcom.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index a86f6620abc8..824c006be093 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -90,8 +90,6 @@ static const struct __ufs_qcom_bw_table {
 	[MODE_MAX][0][0]		    = { 7643136,	307200 },
 };
 
-static struct ufs_qcom_host *ufs_qcom_hosts[MAX_UFS_QCOM_HOSTS];
-
 static void ufs_qcom_get_default_testbus_cfg(struct ufs_qcom_host *host);
 static int ufs_qcom_set_core_clk_ctrl(struct ufs_hba *hba, bool is_scale_up);
 
@@ -1192,9 +1190,6 @@ static int ufs_qcom_init(struct ufs_hba *hba)
 
 	ufs_qcom_setup_clocks(hba, true, POST_CHANGE);
 
-	if (hba->dev->id < MAX_UFS_QCOM_HOSTS)
-		ufs_qcom_hosts[hba->dev->id] = host;
-
 	ufs_qcom_get_default_testbus_cfg(host);
 	err = ufs_qcom_testbus_config(host);
 	if (err)
-- 
2.25.1

