Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54FB347DD48
	for <linux-scsi@vger.kernel.org>; Thu,  4 Jun 2026 13:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780580111; cv=none; b=TkVeQvRsBmFsR8Yko7E7/2Zr80JhTc5JSimm5y4X34yGhflzj04gYBfwmYXiXKHCv6J99W+jcMcTxKI/NmEJ8D4ApbdFdaCPnIv5FAmol3jhhpMpUDPCRttqOnesCYQd7VYFl/FsfwrFaa8NIuy0GU1r5S7pTGOzd2J++kuv/Fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780580111; c=relaxed/simple;
	bh=mUg5OQFiTtkznQDA0krroHL1FQ11lUZkJZPw1BcGYuc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fjs6YVEbFjRihE9EWp/Ntu5VC623gD16gxS4/ktFKMI8I9a0bGlX6Qrh0zRQfv3I7oxPe/0STP2frZ8Jj1vYGuAZKcvdlFJ/+t7gqKe1rQ12wwLADhAE5Ogu1LTlC+m2BRnqHNcmGC04d3WCFSsvZdbKDlrPT+yifcif3Yyf0WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=WydqHRS6; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="WydqHRS6"
X-UUID: 32221704601a11f1b1788b6acf885367-20260604
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=y62SA2SsKPoSYZRzV69KTgT+7aqhJBWj89zXq315zyE=;
	b=WydqHRS6vu8OEWeqPs5Ejm2tHyWdy8twkM7UXgt51Nw071z+wM68ti6VUtnfG8ibnrW8Yt91hrLlGeRKcKfHShqQbNTQ15tvXSMHsIYAIgy2/YTj1eFuLzp9U1O+wYhhXrmrLErdi1frkYnZUHInT1VuIAiWNtn8pGWjIE7zyOk=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.15,REQID:240823cc-87e8-42a6-8a2f-0ffc1f1db791,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:e276073,CLOUDID:cd594b2a-13d2-4d29-83ea-b8014339a000,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102|123|836|865|888|898,TC:-5,Conten
	t:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,O
	SI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 32221704601a11f1b1788b6acf885367-20260604
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1684318082; Thu, 04 Jun 2026 21:35:05 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 4 Jun 2026 21:35:04 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Thu, 4 Jun 2026 21:35:04 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
	<avri.altman@wdc.com>, <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <tun-yu.yu@mediatek.com>,
	<eddie.huang@mediatek.com>, <naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>,
	<bvanassche@acm.org>
Subject: [PATCH v1] ufs: core: Remove unnecessary block I/O quiesce for clock scaling
Date: Thu, 4 Jun 2026 21:33:58 +0800
Message-ID: <20260604133503.2049288-1-peter.wang@mediatek.com>
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

According to the MIPI UniPro Specification v2.0:

5.3.2.3 PA_DL_PAUSE.ind
This primitive informs the PA Service User, the DL Layer in
this case, that the PA Layer was requested to execute a
operation that requires the usage of the Link, e.g. Power
Mode change or PACP frame transmission.

5.3.2.4 PA_DL_PAUSE.rsp_L
This primitive informs the Service Provider that the PA
Service User, the DL Layer in this case, has reached
a state where the Link may be used by the PA Layer.

5.3.2.5 PA_DL_RESUME.ind
This primitive informs the PA Service User, the DL Layer
in this case, that the PA Layer has completed its operation
and the DL Layer may continue to use the Link.

The detailed flow can be found in Figure 52:
Power Mode Change Using PACP_PWR_req and PACP_PWR_cnf.

In short, when the PA layer do power mode change:
1. The DL layer receives PA_DL_PAUSE.ind.
2. The DL layer stops and responds to the PA layer with PA_DL_PAUSE.rsp_L.
3. Waits until the PA layer has completed its work.
4. The PA layer then informs the DL layer with PA_DL_RESUME.ind.

Hence, it is not necessary to stop I/O during a power mode change,
and this step can be removed.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufshcd.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c3f08957d179..b979f5105eb5 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1468,7 +1468,7 @@ static int ufshcd_scale_gear(struct ufs_hba *hba, u32 target_gear, bool scale_up
  *
  * Return: 0 upon success; -EBUSY upon timeout.
  */
-static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba, u64 timeout_us)
+static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
 {
 	int ret = 0;
 	/*
@@ -1476,16 +1476,13 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba, u64 timeout_us)
 	 * clock scaling is in progress
 	 */
 	mutex_lock(&hba->host->scan_mutex);
-	blk_mq_quiesce_tagset(&hba->host->tag_set);
 	mutex_lock(&hba->wb_mutex);
 	down_write(&hba->clk_scaling_lock);
 
-	if (!hba->clk_scaling.is_allowed ||
-	    ufshcd_wait_for_pending_cmds(hba, timeout_us)) {
+	if (!hba->clk_scaling.is_allowed) {
 		ret = -EBUSY;
 		up_write(&hba->clk_scaling_lock);
 		mutex_unlock(&hba->wb_mutex);
-		blk_mq_unquiesce_tagset(&hba->host->tag_set);
 		mutex_unlock(&hba->host->scan_mutex);
 		goto out;
 	}
@@ -1501,7 +1498,6 @@ static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, int err)
 {
 	up_write(&hba->clk_scaling_lock);
 	mutex_unlock(&hba->wb_mutex);
-	blk_mq_unquiesce_tagset(&hba->host->tag_set);
 	mutex_unlock(&hba->host->scan_mutex);
 
 	/* Enable Write Booster if current gear requires it else disable it */
@@ -1529,7 +1525,7 @@ static int ufshcd_devfreq_scale(struct ufs_hba *hba, unsigned long freq,
 
 	new_gear = ufshcd_vops_freq_to_gear_speed(hba, freq);
 
-	ret = ufshcd_clock_scaling_prepare(hba, 1 * USEC_PER_SEC);
+	ret = ufshcd_clock_scaling_prepare(hba);
 	if (ret)
 		return ret;
 
-- 
2.45.2

