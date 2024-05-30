Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C26558B9;
	Thu, 30 May 2024 09:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717062368; cv=none; b=q0bn2xMiDkJE91LgUO01OwsWEMExAjFj6zFuXMlpD1Bh6aF117v1ve79D6JtZMVwIyyfmAHLG2iIfcCD2bxE5ftm/MrfPV02MjKW96KjvrLgcLmXYgFySuTPtiPlvcjYONco9+pq1atPBNjb9Wn5l252m0gWqama0VUnKxd7pL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717062368; c=relaxed/simple;
	bh=ZCg8NSt18VIXcQRHLFOoRZguatTnXNwJD1nbCmfbq78=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Io7tULXDY2WoaOGqK0nhEw64nQNqkpZYMQr9p8GZ5i9jRdV5x6VpovHqIiI/gWX4JuM2NbpTLQko/phHkFZhBm/oxPxwu75vMwA52zDGpLqjf22MdoVTBoE9tjagxcEc3CrWa3KssdRKhqNYPUQQYXo7gdzHgnTWwXaYgRjbwfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 67cc117e1e6911ef9305a59a3cc225df-20240530
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.38,REQID:19d9c4a2-2657-43ce-a88d-8222360ff813,IP:15,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:1,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:16
X-CID-INFO: VERSION:1.1.38,REQID:19d9c4a2-2657-43ce-a88d-8222360ff813,IP:15,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:1,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:16
X-CID-META: VersionHash:82c5f88,CLOUDID:1d9ebe5babadecece3ca4d0a8df4f688,BulkI
	D:240530174554FR76ZIML,BulkQuantity:0,Recheck:0,SF:19|43|74|66|38|24|72|10
	2,TC:nil,Content:0,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:
	nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FSD,TF_CID_SPAM_FSI
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED, SN_EXISTED
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD
	CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_T1
	AMN_GOOD, AMN_C_TI, AMN_C_BU, ABX_MISS_RDNS
X-UUID: 67cc117e1e6911ef9305a59a3cc225df-20240530
X-User: mengfanhui@kylinos.cn
Received: from localhost.localdomain [(223.70.159.255)] by mailgw.kylinos.cn
	(envelope-from <mengfanhui@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1087431886; Thu, 30 May 2024 17:45:53 +0800
From: mengfanhui <mengfanhui@kylinos.cn>
To: kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com,
	shivasharan.srikanteshwara@broadcom.com,
	chandrakanth.patil@broadcom.com,
	mengfanhui@kylinos.cn
Cc: liuyun01@kylinos.cn,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	geliang@kernel.org
Subject: [PATCH 2/2] scsi: megaraid_sas: Add megasas_dcmd_timeout helper
Date: Thu, 30 May 2024 17:45:14 +0800
Message-Id: <20240530094514.2750723-2-mengfanhui@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240530094514.2750723-1-mengfanhui@kylinos.cn>
References: <20240530094514.2750723-1-mengfanhui@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

DCMD timeout is handled in many places, it makes sense to
add a hepler to handle it. This patch adds a new helper
named megasas_dcmd_timeout() to reduce duplicate code.

Co-developed-by: Jackie Liu <liuyun01@kylinos.cn>
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
Signed-off-by: mengfanhui <mengfanhui@kylinos.cn>
Suggested-by: Geliang Tang <geliang@kernel.org>
---
 drivers/scsi/megaraid/megaraid_sas.h        |   2 +
 drivers/scsi/megaraid/megaraid_sas_base.c   | 199 ++++----------------
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  34 +---
 3 files changed, 38 insertions(+), 197 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 91570c5e8456..d96dc446c3aa 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2761,5 +2761,7 @@ void megasas_setup_debugfs(struct megasas_instance *instance);
 void megasas_destroy_debugfs(struct megasas_instance *instance);
 int megasas_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num);
 int dcmd_timeout_ocr_possible(struct megasas_instance *instance);
+void megasas_dcmd_timeout(struct megasas_instance *instance,
+			struct megasas_cmd *cmd);
 
 #endif				/*LSI_MEGARAID_SAS_H */
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index ba8061ea2078..9325a011746d 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4531,6 +4531,30 @@ int dcmd_timeout_ocr_possible(struct megasas_instance *instance)
 		return INITIATE_OCR;
 }
 
+/*
+ * megasas_dcmd_timeout -	Classification processing dcmd timeout.
+ * @instance:				Adapter soft state
+ */
+void megasas_dcmd_timeout(struct megasas_instance *instance, struct megasas_cmd *cmd)
+{
+	switch (dcmd_timeout_ocr_possible(instance)) {
+	case INITIATE_OCR:
+		cmd->flags |= DRV_DCMD_SKIP_REFIRE;
+		mutex_unlock(&instance->reset_mutex);
+		megasas_reset_fusion(instance->host,
+					MFI_IO_TIMEOUT_OCR);
+		mutex_lock(&instance->reset_mutex);
+		break;
+	case KILL_ADAPTER:
+		megaraid_sas_kill_hba(instance);
+		break;
+	case IGNORE_TIMEOUT:
+		dev_info(&instance->pdev->dev, "Ignore DCMD timeout: %s %d\n",
+			__func__, __LINE__);
+		break;
+	}
+}
+
 static void
 megasas_get_pd_info(struct megasas_instance *instance, struct scsi_device *sdev)
 {
@@ -4582,24 +4606,7 @@ megasas_get_pd_info(struct megasas_instance *instance, struct scsi_device *sdev)
 		break;
 
 	case DCMD_TIMEOUT:
-
-		switch (dcmd_timeout_ocr_possible(instance)) {
-		case INITIATE_OCR:
-			cmd->flags |= DRV_DCMD_SKIP_REFIRE;
-			mutex_unlock(&instance->reset_mutex);
-			megasas_reset_fusion(instance->host,
-				MFI_IO_TIMEOUT_OCR);
-			mutex_lock(&instance->reset_mutex);
-			break;
-		case KILL_ADAPTER:
-			megaraid_sas_kill_hba(instance);
-			break;
-		case IGNORE_TIMEOUT:
-			dev_info(&instance->pdev->dev, "Ignore DCMD timeout: %s %d\n",
-				__func__, __LINE__);
-			break;
-		}
-
+		megasas_dcmd_timeout(instance, cmd);
 		break;
 	}
 
@@ -4678,29 +4685,7 @@ megasas_get_pd_list(struct megasas_instance *instance)
 			instance->pd_list_not_supported = 1;
 		break;
 	case DCMD_TIMEOUT:
-
-		switch (dcmd_timeout_ocr_possible(instance)) {
-		case INITIATE_OCR:
-			cmd->flags |= DRV_DCMD_SKIP_REFIRE;
-			/*
-			 * DCMD failed from AEN path.
-			 * AEN path already hold reset_mutex to avoid PCI access
-			 * while OCR is in progress.
-			 */
-			mutex_unlock(&instance->reset_mutex);
-			megasas_reset_fusion(instance->host,
-						MFI_IO_TIMEOUT_OCR);
-			mutex_lock(&instance->reset_mutex);
-			break;
-		case KILL_ADAPTER:
-			megaraid_sas_kill_hba(instance);
-			break;
-		case IGNORE_TIMEOUT:
-			dev_info(&instance->pdev->dev, "Ignore DCMD timeout: %s %d \n",
-				__func__, __LINE__);
-			break;
-		}
-
+		megasas_dcmd_timeout(instance, cmd);
 		break;
 
 	case DCMD_SUCCESS:
@@ -4805,29 +4790,7 @@ megasas_get_ld_list(struct megasas_instance *instance)
 		megaraid_sas_kill_hba(instance);
 		break;
 	case DCMD_TIMEOUT:
-
-		switch (dcmd_timeout_ocr_possible(instance)) {
-		case INITIATE_OCR:
-			cmd->flags |= DRV_DCMD_SKIP_REFIRE;
-			/*
-			 * DCMD failed from AEN path.
-			 * AEN path already hold reset_mutex to avoid PCI access
-			 * while OCR is in progress.
-			 */
-			mutex_unlock(&instance->reset_mutex);
-			megasas_reset_fusion(instance->host,
-						MFI_IO_TIMEOUT_OCR);
-			mutex_lock(&instance->reset_mutex);
-			break;
-		case KILL_ADAPTER:
-			megaraid_sas_kill_hba(instance);
-			break;
-		case IGNORE_TIMEOUT:
-			dev_info(&instance->pdev->dev, "Ignore DCMD timeout: %s %d\n",
-				__func__, __LINE__);
-			break;
-		}
-
+		megasas_dcmd_timeout(instance, cmd);
 		break;
 
 	case DCMD_SUCCESS:
@@ -4925,28 +4888,7 @@ megasas_ld_list_query(struct megasas_instance *instance, u8 query_type)
 		ret = megasas_get_ld_list(instance);
 		break;
 	case DCMD_TIMEOUT:
-		switch (dcmd_timeout_ocr_possible(instance)) {
-		case INITIATE_OCR:
-			cmd->flags |= DRV_DCMD_SKIP_REFIRE;
-			/*
-			 * DCMD failed from AEN path.
-			 * AEN path already hold reset_mutex to avoid PCI access
-			 * while OCR is in progress.
-			 */
-			mutex_unlock(&instance->reset_mutex);
-			megasas_reset_fusion(instance->host,
-						MFI_IO_TIMEOUT_OCR);
-			mutex_lock(&instance->reset_mutex);
-			break;
-		case KILL_ADAPTER:
-			megaraid_sas_kill_hba(instance);
-			break;
-		case IGNORE_TIMEOUT:
-			dev_info(&instance->pdev->dev, "Ignore DCMD timeout: %s %d\n",
-				__func__, __LINE__);
-			break;
-		}
-
+		megasas_dcmd_timeout(instance, cmd);
 		break;
 	case DCMD_SUCCESS:
 		tgtid_count = le32_to_cpu(ci->count);
@@ -5081,22 +5023,7 @@ megasas_host_device_list_query(struct megasas_instance *instance,
 		break;
 
 	case DCMD_TIMEOUT:
-		switch (dcmd_timeout_ocr_possible(instance)) {
-		case INITIATE_OCR:
-			cmd->flags |= DRV_DCMD_SKIP_REFIRE;
-			mutex_unlock(&instance->reset_mutex);
-			megasas_reset_fusion(instance->host,
-				MFI_IO_TIMEOUT_OCR);
-			mutex_lock(&instance->reset_mutex);
-			break;
-		case KILL_ADAPTER:
-			megaraid_sas_kill_hba(instance);
-			break;
-		case IGNORE_TIMEOUT:
-			dev_info(&instance->pdev->dev, "Ignore DCMD timeout: %s %d\n",
-				 __func__, __LINE__);
-			break;
-		}
+		megasas_dcmd_timeout(instance, cmd);
 		break;
 	case DCMD_FAILED:
 		dev_err(&instance->pdev->dev,
@@ -5232,22 +5159,7 @@ void megasas_get_snapdump_properties(struct megasas_instance *instance)
 		break;
 
 	case DCMD_TIMEOUT:
-		switch (dcmd_timeout_ocr_possible(instance)) {
-		case INITIATE_OCR:
-			cmd->flags |= DRV_DCMD_SKIP_REFIRE;
-			mutex_unlock(&instance->reset_mutex);
-			megasas_reset_fusion(instance->host,
-				MFI_IO_TIMEOUT_OCR);
-			mutex_lock(&instance->reset_mutex);
-			break;
-		case KILL_ADAPTER:
-			megaraid_sas_kill_hba(instance);
-			break;
-		case IGNORE_TIMEOUT:
-			dev_info(&instance->pdev->dev, "Ignore DCMD timeout: %s %d\n",
-				__func__, __LINE__);
-			break;
-		}
+		megasas_dcmd_timeout(instance, cmd);
 	}
 
 	if (ret != DCMD_TIMEOUT)
@@ -5372,22 +5284,7 @@ megasas_get_ctrl_info(struct megasas_instance *instance)
 		break;
 
 	case DCMD_TIMEOUT:
-		switch (dcmd_timeout_ocr_possible(instance)) {
-		case INITIATE_OCR:
-			cmd->flags |= DRV_DCMD_SKIP_REFIRE;
-			mutex_unlock(&instance->reset_mutex);
-			megasas_reset_fusion(instance->host,
-				MFI_IO_TIMEOUT_OCR);
-			mutex_lock(&instance->reset_mutex);
-			break;
-		case KILL_ADAPTER:
-			megaraid_sas_kill_hba(instance);
-			break;
-		case IGNORE_TIMEOUT:
-			dev_info(&instance->pdev->dev, "Ignore DCMD timeout: %s %d\n",
-				__func__, __LINE__);
-			break;
-		}
+		megasas_dcmd_timeout(instance, cmd);
 		break;
 	case DCMD_FAILED:
 		megaraid_sas_kill_hba(instance);
@@ -5454,20 +5351,8 @@ int megasas_set_crash_dump_params(struct megasas_instance *instance,
 		ret = megasas_issue_polled(instance, cmd);
 
 	if (ret == DCMD_TIMEOUT) {
-		switch (dcmd_timeout_ocr_possible(instance)) {
-		case INITIATE_OCR:
-			cmd->flags |= DRV_DCMD_SKIP_REFIRE;
-			megasas_reset_fusion(instance->host,
-					MFI_IO_TIMEOUT_OCR);
-			break;
-		case KILL_ADAPTER:
-			megaraid_sas_kill_hba(instance);
-			break;
-		case IGNORE_TIMEOUT:
-			dev_info(&instance->pdev->dev, "Ignore DCMD timeout: %s %d\n",
-				__func__, __LINE__);
-			break;
-		}
+		megasas_dcmd_timeout(instance, cmd);
+
 	} else
 		megasas_return_cmd(instance, cmd);
 
@@ -6840,23 +6725,7 @@ megasas_get_target_prop(struct megasas_instance *instance,
 
 	switch (ret) {
 	case DCMD_TIMEOUT:
-		switch (dcmd_timeout_ocr_possible(instance)) {
-		case INITIATE_OCR:
-			cmd->flags |= DRV_DCMD_SKIP_REFIRE;
-			mutex_unlock(&instance->reset_mutex);
-			megasas_reset_fusion(instance->host,
-					     MFI_IO_TIMEOUT_OCR);
-			mutex_lock(&instance->reset_mutex);
-			break;
-		case KILL_ADAPTER:
-			megaraid_sas_kill_hba(instance);
-			break;
-		case IGNORE_TIMEOUT:
-			dev_info(&instance->pdev->dev,
-				 "Ignore DCMD timeout: %s %d\n",
-				 __func__, __LINE__);
-			break;
-		}
+		megasas_dcmd_timeout(instance, cmd);
 		break;
 
 	default:
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index f0aeb1ee83a2..1d0991650062 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1371,22 +1371,7 @@ megasas_sync_pd_seq_num(struct megasas_instance *instance, bool pend) {
 		instance->pd_seq_map_id++;
 		break;
 	case DCMD_TIMEOUT:
-		switch (dcmd_timeout_ocr_possible(instance)) {
-		case INITIATE_OCR:
-			cmd->flags |= DRV_DCMD_SKIP_REFIRE;
-			mutex_unlock(&instance->reset_mutex);
-			megasas_reset_fusion(instance->host,
-					     MFI_IO_TIMEOUT_OCR);
-			mutex_lock(&instance->reset_mutex);
-			break;
-		case KILL_ADAPTER:
-			megaraid_sas_kill_hba(instance);
-			break;
-		case IGNORE_TIMEOUT:
-			dev_info(&instance->pdev->dev, "Ignore DCMD timeout: %s %d\n",
-				 __func__, __LINE__);
-			break;
-		}
+		megasas_dcmd_timeout(instance, cmd);
 		break;
 	case DCMD_FAILED:
 		dev_err(&instance->pdev->dev,
@@ -1476,22 +1461,7 @@ megasas_get_ld_map_info(struct megasas_instance *instance)
 
 	switch (ret) {
 	case DCMD_TIMEOUT:
-		switch (dcmd_timeout_ocr_possible(instance)) {
-		case INITIATE_OCR:
-			cmd->flags |= DRV_DCMD_SKIP_REFIRE;
-			mutex_unlock(&instance->reset_mutex);
-			megasas_reset_fusion(instance->host,
-					     MFI_IO_TIMEOUT_OCR);
-			mutex_lock(&instance->reset_mutex);
-			break;
-		case KILL_ADAPTER:
-			megaraid_sas_kill_hba(instance);
-			break;
-		case IGNORE_TIMEOUT:
-			dev_info(&instance->pdev->dev, "Ignore DCMD timeout: %s %d\n",
-				 __func__, __LINE__);
-			break;
-		}
+		megasas_dcmd_timeout(instance, cmd);
 		break;
 	case DCMD_FAILED:
 		dev_err(&instance->pdev->dev,
-- 
2.25.1

