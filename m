Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC0E69787
	for <linux-scsi@vger.kernel.org>; Thu, 14 Dec 2023 19:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1d05199f34dso49614975ad.3
        for <linux-scsi@vger.kernel.org>; Thu, 14 Dec 2023 11:24:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702581885; x=1703186685;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X/TAYzD0j0yGLZNLwU3IXglAxyastSRbKLClHFqaqh0=;
        b=hKKcyHAgOnsMRP0sX73jz0r0OZuSVSRjdBBobEOJ74lQVaZ3/YW+YThnuL8rT2V/1X
         udHLMim22hjM+9VC+OUdpoKsQO0p/b37zdeLvjQ5SS+TjND2ThuIaalOqmQcpmzFQbMZ
         xHLM3X+fDnU6kSE68lCKhPvOLQ8Mq0Llzus1H+1yyn2Eht0DK3w7ZpoaxYyGO7hQxI4m
         B6oVKIzx3UOZoNiVrQA9mfzAQL0YA83sBguKxkaxz9omfRGI2ELz8qfNy8oF7u4sLkDK
         kDCLDOVwFmHBrWYY9KugbYQaoqz+k+/i8awYi//mvNiMJROCBsTXQOXn0PEetDCppyzx
         28kA==
X-Gm-Message-State: AOJu0YzJc11zNCVWZEkqUwCtkMyo/6jg0Tx6yctIjNXY4NcxCev8fjKl
	WfPV2e8RG2lm5JrST/tWl7k=
X-Google-Smtp-Source: AGHT+IHlzfompgPR5hDs9iiwLhdKwTVTq9dp1qAGzvx1FaDZdk9MBw2oSAfc3sUNNi/zOEkA+Rut9A==
X-Received: by 2002:a05:6a20:8b03:b0:190:169a:a571 with SMTP id l3-20020a056a208b0300b00190169aa571mr4920649pzh.12.1702581885367;
        Thu, 14 Dec 2023 11:24:45 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:0:1000:8411:bae8:452d:2e24:5984])
        by smtp.gmail.com with ESMTPSA id 61-20020a17090a09c300b0028b0d8b3cdfsm1718495pjo.57.2023.12.14.11.24.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Dec 2023 11:24:45 -0800 (PST)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"Bao D . Nguyen" <quic_nguyenb@quicinc.com>,
	Can Guo <quic_cang@quicinc.com>,
	Avri Altman <avri.altman@wdc.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	Stanley Jhu <chu.stanley@gmail.com>,
	Asutosh Das <quic_asutoshd@quicinc.com>,
	Bean Huo <beanhuo@micron.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Arthur Simchaev <Arthur.Simchaev@wdc.com>
Subject: [PATCH 2/2] scsi: ufs: Simplify ufshcd_auto_hibern8_update()
Date: Thu, 14 Dec 2023 11:23:58 -0800
Message-ID: <20231214192416.3638077-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
In-Reply-To: <20231214192416.3638077-1-bvanassche@acm.org>
References: <20231214192416.3638077-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Calls to ufshcd_auto_hibern8_update() are already serialized: this
function is either called if user space software is not running
(preparing to suspend) or from a single sysfs store callback function.
Kernfs serializes sysfs .store() callbacks. No functionality is changed.

Reviewed-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
Reviewed-by: Can Guo <quic_cang@quicinc.com>
Cc: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 608dba595beb..d6ae5d17892c 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4423,21 +4423,13 @@ static void ufshcd_configure_auto_hibern8(struct ufs_hba *hba)
 
 void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
 {
-	unsigned long flags;
-	bool update = false;
+	const u32 cur_ahit = READ_ONCE(hba->ahit);
 
-	if (!ufshcd_is_auto_hibern8_supported(hba))
+	if (!ufshcd_is_auto_hibern8_supported(hba) || cur_ahit == ahit)
 		return;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	if (hba->ahit != ahit) {
-		hba->ahit = ahit;
-		update = true;
-	}
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
-
-	if (update &&
-	    !pm_runtime_suspended(&hba->ufs_device_wlun->sdev_gendev)) {
+	WRITE_ONCE(hba->ahit, ahit);
+	if (!pm_runtime_suspended(&hba->ufs_device_wlun->sdev_gendev)) {
 		ufshcd_rpm_get_sync(hba);
 		ufshcd_hold(hba);
 		ufshcd_configure_auto_hibern8(hba);
