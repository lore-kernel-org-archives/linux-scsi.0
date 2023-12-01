Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NqcaiHbD"
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC6C1173E
	for <linux-scsi@vger.kernel.org>; Fri,  1 Dec 2023 07:15:09 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-6cde14ff73bso1831339b3a.0
        for <linux-scsi@vger.kernel.org>; Fri, 01 Dec 2023 07:15:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701443709; x=1702048509; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=64ppbjLuXnC3sRRee6xAp4YeL9+LAF3VOykBfQp43DQ=;
        b=NqcaiHbD9GEc1QdsywbH+1UAg6UVzN8fpEYFb9BqCPy8/OjnHyfEE/WF58C8a4gTkx
         wLcbXFvyQTq9BWcDY7/nuEgaV5OuKl9+L4xbhxUdFNU/KhlDvbNpcvpbgDzXl9NW6C8I
         3Zwg72HTkUQJgwNRYUnnNrzwsBgj3KJUeyzy5JU/ikEYk1kseUj4TkcngNmSa7+VAHHE
         4CD7wcv4fmktMwc/aWiqdm5UWfvfeTQnQ7laJkyUugKJTAQXxT7gK5Jikk23GhffpnZp
         5hMuCRI94o1tvBCms84+ZqzCn5nR3TXnc8TwyNHp6p1ztZV6XB8dSSwraKG+b+Hf7xSv
         sK7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701443709; x=1702048509;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=64ppbjLuXnC3sRRee6xAp4YeL9+LAF3VOykBfQp43DQ=;
        b=VOD6UwRK6cTRaBhZWhLfHGNJkBDXYeT6n9etb3fVtP8NQb6SJB8l9F9aALvTotUSu8
         gDGqDFMMblC4t7n7vrIxQhKefl8y9BZHFT7Wz7QRlcScQsBKIqnNhNWi7EhkC+P/7T5G
         lymWuUfCR0ayG1K90s6FHS+N0i+xYJJ9Mf4LrcmfI0GMOlFhaHmVQK/2w9hnMXwF333r
         DyBcC5xUHAPWpXYxEwgCix6YqMrZ8+V7aN7q+fxh4xEUcDVlSulDVmXLx2dwWgR6WtoG
         QnZh0xfMqtTwiBH9ZGoxOrhosJd+odCERy5asdkXeGzM6OgCCDal9hJLXBkN7Bz7RW/7
         CQFA==
X-Gm-Message-State: AOJu0YzXV5+LVDHuMeknmXu6o+TnoAUZ4zteTHemYALYO++SfX22DvaT
	u2215pssMUIwucVJLpeEwGid
X-Google-Smtp-Source: AGHT+IGFEwYFndW1mgX6h47/MbvGBKo00XuXVuSHUaCz6PgUzV+fkCdc8GeBdLKLTyRZDfjr7WGuGA==
X-Received: by 2002:a05:6a20:918b:b0:15d:4cf1:212e with SMTP id v11-20020a056a20918b00b0015d4cf1212emr38989386pzd.4.1701443708902;
        Fri, 01 Dec 2023 07:15:08 -0800 (PST)
Received: from localhost.localdomain ([117.213.98.226])
        by smtp.gmail.com with ESMTPSA id s14-20020a65644e000000b00578afd8e012sm2765824pgv.92.2023.12.01.07.15.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Dec 2023 07:15:08 -0800 (PST)
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
Subject: [PATCH 10/13] scsi: ufs: qcom: Use dev_err_probe() to simplify error handling of devm_gpiod_get_optional()
Date: Fri,  1 Dec 2023 20:44:14 +0530
Message-Id: <20231201151417.65500-11-manivannan.sadhasivam@linaro.org>
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

As done in other places, let's use dev_err_probe() to simplify the error
handling while acquiring the device reset gpio using
devm_gpiod_get_optional().

While at it, let's reword the error message to make it clear that the
failure is due to acquiring "device reset gpio".

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/ufs/host/ufs-qcom.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 218d22e1efce..a86f6620abc8 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -1146,9 +1146,8 @@ static int ufs_qcom_init(struct ufs_hba *hba)
 	host->device_reset = devm_gpiod_get_optional(dev, "reset",
 						     GPIOD_OUT_HIGH);
 	if (IS_ERR(host->device_reset)) {
-		err = PTR_ERR(host->device_reset);
-		if (err != -EPROBE_DEFER)
-			dev_err(dev, "failed to acquire reset gpio: %d\n", err);
+		err = dev_err_probe(dev, PTR_ERR(host->device_reset),
+				    "Failed to acquire device reset gpio\n");
 		goto out_variant_clear;
 	}
 
-- 
2.25.1

