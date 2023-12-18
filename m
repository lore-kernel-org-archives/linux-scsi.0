Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73EED74E3E
	for <linux-scsi@vger.kernel.org>; Mon, 18 Dec 2023 22:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-6d9338bc11fso40796b3a.1
        for <linux-scsi@vger.kernel.org>; Mon, 18 Dec 2023 14:52:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702939975; x=1703544775;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oTF+J14j0yYky+MpiBvWqSC7e/OIFKPAN10FwsmrckY=;
        b=BXO1XhlRuSN9T3XQxYLMUJWzW2QjuRnrozLs7kAcblIqwCeZl96LDTBimd5a6KhgZG
         KhBWlpJ6ms1PtJSZ3G0pjlsBARtF1mH2trF++o+ln2Lr2Dlntmc7gvtygpdir9s5nsXG
         kyXVjj9Inz4PZBGrwPwMxnQHTtlWh3aAqtGHxjwnk3eko/fwCbLWea8sUgrxCuLrL3vd
         0qluDTwt4Ksx0dC5xjMzlrPHC4KZIah4nKGjO8WR0IWf+iN1pdB0KSz/fZqBpaogucrh
         Vh1GleFG9Z2gaWyvzZinPXgCbZtqAghNtJYrmtdiAtFBK4/Wp7IBzth+fFXWdBNygZU4
         mWZg==
X-Gm-Message-State: AOJu0Yx5XGu4tC5uqZk+CEobSxizCt/xtsXfa2Df5AufRvNGcwXlnK7+
	e733MznEc0gVsnMqc6XWNhM=
X-Google-Smtp-Source: AGHT+IEhNeTH79OFfpl+8yfDkq7aVc6qu7mskTms0I5p/BFs3c0PxVrGkG9SiK0S3yDezIQ8dYe+gw==
X-Received: by 2002:a05:6a00:17a1:b0:6ce:6d8b:275d with SMTP id s33-20020a056a0017a100b006ce6d8b275dmr21402206pfg.20.1702939974595;
        Mon, 18 Dec 2023 14:52:54 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:0:1000:8411:e67:7ba6:36a9:8cd5])
        by smtp.gmail.com with ESMTPSA id h18-20020a056a00171200b006d45b47612csm4078329pfc.89.2023.12.18.14.52.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Dec 2023 14:52:54 -0800 (PST)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Daniel Mentz <danielmentz@google.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	Stanley Jhu <chu.stanley@gmail.com>,
	Avri Altman <avri.altman@wdc.com>,
	Can Guo <quic_cang@quicinc.com>,
	Asutosh Das <quic_asutoshd@quicinc.com>,
	Bean Huo <beanhuo@micron.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Arthur Simchaev <Arthur.Simchaev@wdc.com>
Subject: [PATCH 2/2] scsi: ufs: Remove the ufshcd_hba_exit() call from ufshcd_async_scan()
Date: Mon, 18 Dec 2023 14:52:15 -0800
Message-ID: <20231218225229.2542156-3-bvanassche@acm.org>
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

Calling ufshcd_hba_exit() from a function that is called asynchronously
from ufshcd_init() is wrong because this triggers multiple race
conditions. Instead of calling ufshcd_hba_exit(), log an error message.

Reported-by: Daniel Mentz <danielmentz@google.com>
Fixes: 1d337ec2f35e ("ufs: improve init sequence")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 0ad8bde39cd1..7c59d7a02243 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8982,12 +8982,9 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 
 out:
 	pm_runtime_put_sync(hba->dev);
-	/*
-	 * If we failed to initialize the device or the device is not
-	 * present, turn off the power/clocks etc.
-	 */
+
 	if (ret)
-		ufshcd_hba_exit(hba);
+		dev_err(hba->dev, "%s failed: %d\n", __func__, ret);
 }
 
 static enum scsi_timeout_action ufshcd_eh_timed_out(struct scsi_cmnd *scmd)
