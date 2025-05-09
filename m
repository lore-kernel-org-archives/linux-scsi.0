Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5664026FA78
	for <linux-scsi@vger.kernel.org>; Fri,  9 May 2025 07:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746774638; cv=none; b=afvBsLTkmmdRBpUQIejMURIsQ7l/xVigN+DWBJpw4AJBsdv/KqxJkDFdJawSatPkMmGI05u+Teruy+hWUN/EfgZ7jteukPfnVf8IaBoOFa9RZd/rNPsAGQ+blYaTta6Y7KO62RYvqNfCWD0LuQE/zMiyWAmtfba5GJt7+2PfjYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746774638; c=relaxed/simple;
	bh=/x+HVPJj2GV9MhfdbMZVPWqqx8ZlMrBJ2KXv7cM0RY4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ulXDfct3PoJAbCsu+1YGsrRYoHWZpqUokH1BMxWJzOClb3K1n7tKB5+j9vVZmT+MS/TZYOSW7Q9baaV9RA6MBghsTJdaZOqDlzXgTH/sQXGtCMG38SN179ui92NE0hDgIWnGis95cGJRXrxvxq5QuTGfT9+NXf1JEyJGY3TKabM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=gOS85sXz; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="gOS85sXz"
X-UUID: b23245ae2ca411f082f7f7ac98dee637-20250509
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=c7Glw3bezdI36kevqO4BKNrlWhkSOlkYGNEKN164VNQ=;
	b=gOS85sXzC/PhXdgK/VX+zZ7gEBoK4xO8EVkMZeHX4c5iZJpdsZTJqm69KqMcwbFUbg51Uu69dJinttRoEg//fAfPuSo/bAxA9I6UhQqwGJDVjNaku1HSAtPLG3K6NJF80MwMyIHMJRWyC6xKpRhGBp9J6a39RJF8afNz/4fIUEo=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.2.1,REQID:a685d302-426d-44d3-8fc6-d121ac18be24,IP:0,UR
	L:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-25
X-CID-META: VersionHash:0ef645f,CLOUDID:72c6d4f9-d2be-4f65-b354-0f04e3343627,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|50,EDM:-3,IP:ni
	l,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: b23245ae2ca411f082f7f7ac98dee637-20250509
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 579010279; Fri, 09 May 2025 15:10:32 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Fri, 9 May 2025 15:10:30 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Fri, 9 May 2025 15:10:30 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
	<avri.altman@wdc.com>, <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>
Subject: [PATCH v1] ufs: core: support updating device command timeout
Date: Fri, 9 May 2025 15:08:32 +0800
Message-ID: <20250509071029.446697-1-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

From: Peter Wang <peter.wang@mediatek.com>

The default device command timeout remains 1.5 seconds,
but platform drivers can override it if needed.

Some UFS device commands may timeout due to being blocked
by regular SCSI write commands. Therefore, the timeout
needs to be extended to 30 seconds, matching the SCSI write
command timeout.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufshcd.c | 34 +++++++++++++++++++++++++++-------
 1 file changed, 27 insertions(+), 7 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 7735421e3991..09d9a16af339 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -63,7 +63,10 @@ enum {
 /* Query request retries */
 #define QUERY_REQ_RETRIES 3
 /* Query request timeout */
-#define QUERY_REQ_TIMEOUT 1500 /* 1.5 seconds */
+enum {
+	QUERY_REQ_TIMEOUT_DEFAULT = 1500,
+	QUERY_REQ_TIMEOUT_MAX     = 30000
+};
 
 /* Advanced RPMB request timeout */
 #define ADVANCED_RPMB_REQ_TIMEOUT  3000 /* 3 seconds */
@@ -135,6 +138,23 @@ module_param_cb(uic_cmd_timeout, &uic_cmd_timeout_ops, &uic_cmd_timeout, 0644);
 MODULE_PARM_DESC(uic_cmd_timeout,
 		 "UFS UIC command timeout in milliseconds. Defaults to 500ms. Supported values range from 500ms to 2 seconds inclusively");
 
+static unsigned int dev_cmd_timeout = QUERY_REQ_TIMEOUT_DEFAULT;
+
+static int dev_cmd_timeout_set(const char *val, const struct kernel_param *kp)
+{
+	return param_set_uint_minmax(val, kp, QUERY_REQ_TIMEOUT_DEFAULT,
+				     QUERY_REQ_TIMEOUT_MAX);
+}
+
+static const struct kernel_param_ops dev_cmd_timeout_ops = {
+	.set = dev_cmd_timeout_set,
+	.get = param_get_uint,
+};
+
+module_param_cb(dev_cmd_timeout, &dev_cmd_timeout_ops, &dev_cmd_timeout, 0644);
+MODULE_PARM_DESC(dev_cmd_timeout,
+		 "UFS Device command timeout in milliseconds. Defaults to 1.5s. Supported values range from 1.5 to 30 seconds inclusively");
+
 #define ufshcd_toggle_vreg(_dev, _vreg, _on)				\
 	({                                                              \
 		int _ret;                                               \
@@ -3365,7 +3385,7 @@ int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
 	struct ufs_query_req *request = NULL;
 	struct ufs_query_res *response = NULL;
 	int err, selector = 0;
-	int timeout = QUERY_REQ_TIMEOUT;
+	int timeout = dev_cmd_timeout;
 
 	BUG_ON(!hba);
 
@@ -3462,7 +3482,7 @@ int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
 		goto out_unlock;
 	}
 
-	err = ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_QUERY, QUERY_REQ_TIMEOUT);
+	err = ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_QUERY, dev_cmd_timeout);
 
 	if (err) {
 		dev_err(hba->dev, "%s: opcode 0x%.2x for idn %d failed, index %d, err = %d\n",
@@ -3558,7 +3578,7 @@ static int __ufshcd_query_descriptor(struct ufs_hba *hba,
 		goto out_unlock;
 	}
 
-	err = ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_QUERY, QUERY_REQ_TIMEOUT);
+	err = ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_QUERY, dev_cmd_timeout);
 
 	if (err) {
 		dev_err(hba->dev, "%s: opcode 0x%.2x for idn %d failed, index %d, err = %d\n",
@@ -6020,7 +6040,7 @@ int ufshcd_read_device_lvl_exception_id(struct ufs_hba *hba, u64 *exception_id)
 
 	request->query_func = UPIU_QUERY_FUNC_STANDARD_READ_REQUEST;
 
-	err = ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_QUERY, QUERY_REQ_TIMEOUT);
+	err = ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_QUERY, dev_cmd_timeout);
 
 	if (err) {
 		dev_err(hba->dev, "%s: failed to read device level exception %d\n",
@@ -7245,7 +7265,7 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 	 * bound to fail since dev_cmd.query and dev_cmd.type were left empty.
 	 * read the response directly ignoring all errors.
 	 */
-	ufshcd_issue_dev_cmd(hba, lrbp, tag, QUERY_REQ_TIMEOUT);
+	ufshcd_issue_dev_cmd(hba, lrbp, tag, dev_cmd_timeout);
 
 	/* just copy the upiu response as it is */
 	memcpy(rsp_upiu, lrbp->ucd_rsp_ptr, sizeof(*rsp_upiu));
@@ -8678,7 +8698,7 @@ static void ufshcd_set_timestamp_attr(struct ufs_hba *hba)
 
 	put_unaligned_be64(ktime_get_real_ns(), &upiu_data->osf3);
 
-	err = ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_QUERY, QUERY_REQ_TIMEOUT);
+	err = ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_QUERY, dev_cmd_timeout);
 
 	if (err)
 		dev_err(hba->dev, "%s: failed to set timestamp %d\n",
-- 
2.45.2

