Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="i0ARUHZI"
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD4E71980
	for <linux-scsi@vger.kernel.org>; Thu,  7 Dec 2023 23:00:12 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id 41be03b00d2f7-53fa455cd94so1279915a12.2
        for <linux-scsi@vger.kernel.org>; Thu, 07 Dec 2023 23:00:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1702018812; x=1702623612; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vdbM2PfYii852DpHOsW1XBn04AhqRFyeEuBtlshPQPM=;
        b=i0ARUHZIMZo3TUvm3DwNHIDr/NbD045vDQfkr+NwCagtWvBDh+YCk7qXGqv1vasn33
         169Y9Kf9/+7TqODM+Gfc6eCXo1ik3h221iInYdO/xD3BTc/YR4m2VILeMSyvp9tktLuq
         EI6pNvaJ+bKijhMCWbqyZUmGZLSieTm1DIlJfnLsOxxBwaXIARaH1kcfzeAW5PkeQmB4
         ApHH2FICEypauGNsRCEmzu28k6ydo4HLH7lDCBXwGxu+xq3UWk+IzJgVn4dnfPLytKnZ
         y0ILhJtutPFvAgf5SDeGCHzMmYPZsa9mM4nbTjyCDeaS62kFYAWs/knyxaFYiMaE/znw
         NQ1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702018812; x=1702623612;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vdbM2PfYii852DpHOsW1XBn04AhqRFyeEuBtlshPQPM=;
        b=imZAzfF5pGhsy9rgeB8w3trc4FFEOWbyZtWsq5Q11YwvQmilGi09aqDTNUjaaoRYaj
         1ybAjogLWx3UTlQJtEgWAA0lGZMP7PRKFKNLA8QEJxIGZ2d5qxUhC8iiKaiUw3yH329Y
         m0biN8iQvJ3qDjWYAP2OWThWjVn0wLVajHvNOrfj9rCKJ0oqh1NbMmTLatSzQQ9qcepq
         /sV104Nib85a0wgnT5mhXRdkonFWk8XqzMGHReUmTPvAxEwEVpCqeWSN+d9TnL/VIXvK
         kpUi4wBKaubNRnDXTxv4VPb2UdcyUejQ+kyNDfldkdPkVhyFc5ECcELLbcKUmi7Y9PV4
         3iHQ==
X-Gm-Message-State: AOJu0Yyw9R1rXxjDjSDlwgu2J5bBywd4m6Fdk6Cxr5MPU1yuyKBXR/JA
	LZYsKMUv13DSZrqVj1j2R9Uq
X-Google-Smtp-Source: AGHT+IGv+GAPa6Ypg344o0UlsXWILp6Hb3RQcQuHpl5BD9CYuBn23Qp5TZa5x8eqFhl33IaLmcYJxg==
X-Received: by 2002:a17:903:2115:b0:1d0:a0dd:7d3b with SMTP id o21-20020a170903211500b001d0a0dd7d3bmr2951714ple.65.1702018811863;
        Thu, 07 Dec 2023 23:00:11 -0800 (PST)
Received: from localhost.localdomain ([117.216.123.142])
        by smtp.gmail.com with ESMTPSA id n8-20020a170902e54800b001b03f208323sm934263plf.64.2023.12.07.23.00.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Dec 2023 23:00:11 -0800 (PST)
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
Subject: [PATCH v2 11/17] scsi: ufs: qcom: Remove unused ufs_qcom_hosts struct array
Date: Fri,  8 Dec 2023 12:28:56 +0530
Message-Id: <20231208065902.11006-12-manivannan.sadhasivam@linaro.org>
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

ufs_qcom_hosts array is assigned, but not used anywhere. So let's remove
it.

Reviewed-by: Andrew Halaney <ahalaney@redhat.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/ufs/host/ufs-qcom.c | 5 -----
 drivers/ufs/host/ufs-qcom.h | 1 -
 2 files changed, 6 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index ae9fafa49ded..18ea41f5bae9 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -90,8 +90,6 @@ static const struct __ufs_qcom_bw_table {
 	[MODE_MAX][0][0]		    = { 7643136,	307200 },
 };
 
-static struct ufs_qcom_host *ufs_qcom_hosts[MAX_UFS_QCOM_HOSTS];
-
 static void ufs_qcom_get_default_testbus_cfg(struct ufs_qcom_host *host);
 static int ufs_qcom_set_core_clk_ctrl(struct ufs_hba *hba, bool is_scale_up);
 
@@ -1194,9 +1192,6 @@ static int ufs_qcom_init(struct ufs_hba *hba)
 
 	ufs_qcom_setup_clocks(hba, true, POST_CHANGE);
 
-	if (hba->dev->id < MAX_UFS_QCOM_HOSTS)
-		ufs_qcom_hosts[hba->dev->id] = host;
-
 	ufs_qcom_get_default_testbus_cfg(host);
 	err = ufs_qcom_testbus_config(host);
 	if (err)
diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
index e2df4c528a2a..53db424a0bcb 100644
--- a/drivers/ufs/host/ufs-qcom.h
+++ b/drivers/ufs/host/ufs-qcom.h
@@ -10,7 +10,6 @@
 #include <soc/qcom/ice.h>
 #include <ufs/ufshcd.h>
 
-#define MAX_UFS_QCOM_HOSTS	1
 #define MAX_U32                 (~(u32)0)
 #define MPHY_TX_FSM_STATE       0x41
 #define TX_FSM_HIBERN8          0x1
-- 
2.25.1

