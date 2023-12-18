Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2F574E0F;
	Mon, 18 Dec 2023 22:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6d9344e194bso18470b3a.3;
        Mon, 18 Dec 2023 14:52:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702939967; x=1703544767;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dXmTcORL7MY38SoanT+OUSrIK5lzaglucptsGSQXywY=;
        b=i/k9T4ReTK+2zZhKdEoEXtaLGBOf5TyxwOUi4Jfhi3c/ZZ5BRABDlK36UYOWQs3xBX
         JxdfA4COTcllDKxCzlOPyVhgmy6aPxF+xR9Uak/YjlfMA9M8/28zdD3IyKfLFA894AiZ
         jcbJ11zCaOVNlr7IVbMZrQBAfhifBgEu4zb5chuhQfNgzX0q9gaZ64sllLxoSRwjv7LK
         cJQr33K3kR1CyQNt4oMUC9N9wlMLa/QaU+wbwpUQoE7p1Q6Lf2XCnlWnLfEowvj4mzOs
         /7CdEO4Nx0s59IyfBSx3La20kaKOfEeYqlcNK5mNcihXWXLjJi4EWEynfmTVoENu7c+7
         1EJQ==
X-Gm-Message-State: AOJu0YyHse63wKy3hCTZ93XRK7kKuNv+v+9Mjnpw68C2/Ucez2AMCGjU
	jZ7VkHzbkU7zZKwtVYa2TtAF7oBnEaA=
X-Google-Smtp-Source: AGHT+IEdu9LTD0HLvdjrOgmqJil1T6pKntjoAvsskKecjH7QS9SJXuWzOZ2CkGSzu15Kxi6+V6em/Q==
X-Received: by 2002:a05:6a00:2d98:b0:6d8:628c:93ef with SMTP id fb24-20020a056a002d9800b006d8628c93efmr1886016pfb.57.1702939966887;
        Mon, 18 Dec 2023 14:52:46 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:0:1000:8411:e67:7ba6:36a9:8cd5])
        by smtp.gmail.com with ESMTPSA id h18-20020a056a00171200b006d45b47612csm4078329pfc.89.2023.12.18.14.52.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Dec 2023 14:52:46 -0800 (PST)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	stable@vger.kernel.org,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	Stanley Jhu <chu.stanley@gmail.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Can Guo <quic_cang@quicinc.com>,
	Asutosh Das <quic_asutoshd@quicinc.com>,
	Bean Huo <beanhuo@micron.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Arthur Simchaev <Arthur.Simchaev@wdc.com>
Subject: [PATCH 1/2] scsi: ufs: Simplify power management during async scan
Date: Mon, 18 Dec 2023 14:52:14 -0800
Message-ID: <20231218225229.2542156-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
In-Reply-To: <20231218225229.2542156-1-bvanassche@acm.org>
References: <20231218225229.2542156-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ufshcd_init() calls pm_runtime_get_sync() before it calls
async_schedule(). ufshcd_async_scan() calls pm_runtime_put_sync()
directly or indirectly from ufshcd_add_lus(). Simplify
ufshcd_async_scan() by always calling pm_runtime_put_sync() from
ufshcd_async_scan().

Cc: stable@vger.kernel.org
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index d6ae5d17892c..0ad8bde39cd1 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8711,7 +8711,6 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
 
 	ufs_bsg_probe(hba);
 	scsi_scan_host(hba->host);
-	pm_runtime_put_sync(hba->dev);
 
 out:
 	return ret;
@@ -8980,15 +8979,15 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 
 	/* Probe and add UFS logical units  */
 	ret = ufshcd_add_lus(hba);
+
 out:
+	pm_runtime_put_sync(hba->dev);
 	/*
 	 * If we failed to initialize the device or the device is not
 	 * present, turn off the power/clocks etc.
 	 */
-	if (ret) {
-		pm_runtime_put_sync(hba->dev);
+	if (ret)
 		ufshcd_hba_exit(hba);
-	}
 }
 
 static enum scsi_timeout_action ufshcd_eh_timed_out(struct scsi_cmnd *scmd)
