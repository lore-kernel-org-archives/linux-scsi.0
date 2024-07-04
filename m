Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD309946F;
	Thu,  4 Jul 2024 01:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720057332; cv=none; b=QvKerII8hM+jSXuRpxdqdgJwP1NowIat4vrTaAQgF2NnodLUYGJBwYJ+pT0++BHbRkOjAIjjraVjuYAwogQR4OPik4obR/LZI4zcoyxl0oLQPshV3RjHBNoZSKc80qBTJ2U3mc2Ew92Tr9m/7Q+XB33imXdRU/USxRUuNTuE0iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720057332; c=relaxed/simple;
	bh=eoATg7rH9rs5fMxWrx4Uy7wn7AVBqrvKrf63z2isDpI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oOKFCd8B6SZGyiSoPPwmeCW6GJcK1D4+XkW1FqimFOW96JscfsiUkDOQKSso2Dan+YRJS1TYP6kKA1FYK80FrTu6Jy/AKlzdkghRSXY7dAvn3u5toiWGHTALG6gHpp/CzBCz/tsyhdHwYNYJngLLIIq0vn1TpYfDQYWn7VwYIdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 9d05a56e39a611ef93f4611109254879-20240704
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_T1, AMN_GOOD, AMN_C_TI, AMN_C_BU
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.38,REQID:fe8e0314-bfb7-4bfc-8f4b-b7756def3de4,IP:20,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-11,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:9
X-CID-INFO: VERSION:1.1.38,REQID:fe8e0314-bfb7-4bfc-8f4b-b7756def3de4,IP:20,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-11,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:9
X-CID-META: VersionHash:82c5f88,CLOUDID:bce4d33eefa2295834a64b20e1a47246,BulkI
	D:240625134029G3UPL4GT,BulkQuantity:2,Recheck:0,SF:66|38|25|17|19|44|102,T
	C:nil,Content:0,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:40,QS:nil,BEC:nil,
	COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_FSI
X-UUID: 9d05a56e39a611ef93f4611109254879-20240704
X-User: mengfanhui@kylinos.cn
Received: from localhost.localdomain [(223.70.160.255)] by mailgw.kylinos.cn
	(envelope-from <mengfanhui@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1287972793; Thu, 04 Jul 2024 09:42:03 +0800
From: Fanhui Meng <mengfanhui@kylinos.cn>
To: kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com,
	shivasharan.srikanteshwara@broadcom.com,
	chandrakanth.patil@broadcom.com,
	martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Geliang Tang <geliang@kernel.org>,
	Jackie Liu <liuyun01@kylinos.cn>
Subject: [scsi-next v2 1/2] scsi: megaraid_sas: Add megasas_dcmd_timeout helper
Date: Thu,  4 Jul 2024 09:40:48 +0800
Message-Id: <39ebba5f96ec4c8b0266a55f8eea6972b91a150e.1720056514.git.mengfanhui@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1720056514.git.mengfanhui@kylinos.cn>
References: <cover.1720056514.git.mengfanhui@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

DCMD timeout is handled in many places, it makes sense to
add a helper to handle it. This patch adds a new helper
named megasas_dcmd_timeout() to reduce duplicate code.

Suggested-by: Geliang Tang <geliang@kernel.org>
Co-developed-by: Jackie Liu <liuyun01@kylinos.cn>
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
Signed-off-by: Fanhui Meng <mengfanhui@kylinos.cn>
---
 drivers/scsi/megaraid/megaraid_sas.h      |   2 +
 drivers/scsi/megaraid/megaraid_sas_base.c | 198 ++++------------------
 2 files changed, 35 insertions(+), 165 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 5680c6cdb221..277f179157e8 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2760,5 +2760,7 @@ void megasas_exit_debugfs(void);
 void megasas_setup_debugfs(struct megasas_instance *instance);
 void megasas_destroy_debugfs(struct megasas_instance *instance);
 int megasas_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num);
+void megasas_dcmd_timeout(struct megasas_instance *instance,
+			  struct megasas_cmd *cmd);
 
 #endif				/*LSI_MEGARAID_SAS_H */
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 6c79c350a4d5..e6a9cef027c0 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4529,6 +4529,30 @@ dcmd_timeout_ocr_possible(struct megasas_instance *instance) {
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
@@ -4580,24 +4604,7 @@ megasas_get_pd_info(struct megasas_instance *instance, struct scsi_device *sdev)
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
 
@@ -4676,29 +4683,7 @@ megasas_get_pd_list(struct megasas_instance *instance)
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
@@ -4803,29 +4788,7 @@ megasas_get_ld_list(struct megasas_instance *instance)
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
@@ -4923,28 +4886,7 @@ megasas_ld_list_query(struct megasas_instance *instance, u8 query_type)
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
@@ -5079,22 +5021,7 @@ megasas_host_device_list_query(struct megasas_instance *instance,
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
@@ -5230,22 +5157,7 @@ void megasas_get_snapdump_properties(struct megasas_instance *instance)
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
@@ -5370,22 +5282,7 @@ megasas_get_ctrl_info(struct megasas_instance *instance)
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
@@ -5452,20 +5349,7 @@ int megasas_set_crash_dump_params(struct megasas_instance *instance,
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
 	} else
 		megasas_return_cmd(instance, cmd);
 
@@ -6838,23 +6722,7 @@ megasas_get_target_prop(struct megasas_instance *instance,
 
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
-- 
2.25.1

