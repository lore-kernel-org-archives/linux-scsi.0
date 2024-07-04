Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DADD748D;
	Thu,  4 Jul 2024 01:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720057333; cv=none; b=kBlX2V9aQ4UZ4ifWtgMHXMqgZQwZmVlr1qrVv+AkKsJMyKLS/5/e4xmcnVwCJlXkK1DclVddLasZzPL/Z0lYn1PlnNBF278ymBC0L+PoJONrc8WCfpXOUUw+ElL5tYM/BeG2K2Ja8NWptOwP2HIha+I7z9DnEgMtGtVX0Ii00+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720057333; c=relaxed/simple;
	bh=b426e6oGVVh+vaTeePmL2JbGmIogG4PydvIJ3ZMsQII=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tFM+VL/3xQjzdrSuvvSMpNn5hF7mR6KUKQ0JyIPwtidS/Dp9kTBx57dO7ZjhU0zbARIY++ODetNYL8lFpIPw4CBAK2bMp59R6XnX+EkMVaSIUxon5jz5w4R0eJqoeUEZGLcWrm5FVDIrUZ8Q29514hncPUQP8obAVchIJu6Cgp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 9d3c280039a611ef93f4611109254879-20240704
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
X-CID-O-INFO: VERSION:1.1.38,REQID:dd17342a-16fc-44ae-a306-6f8cdb8c6657,IP:20,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:-11,FILE:0,BULK:0,RULE:Release_Ham,ACT
	ION:release,TS:4
X-CID-INFO: VERSION:1.1.38,REQID:dd17342a-16fc-44ae-a306-6f8cdb8c6657,IP:20,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:-11,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:4
X-CID-META: VersionHash:82c5f88,CLOUDID:4a31ea16592e290cf674e5909c9da95b,BulkI
	D:2407040858227AE2U9YK,BulkQuantity:1,Recheck:0,SF:38|25|17|19|44|66|102,T
	C:nil,Content:0,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:40,QS:nil,BEC:nil,
	COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_FSI
X-UUID: 9d3c280039a611ef93f4611109254879-20240704
X-User: mengfanhui@kylinos.cn
Received: from localhost.localdomain [(223.70.160.255)] by mailgw.kylinos.cn
	(envelope-from <mengfanhui@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 776967633; Thu, 04 Jul 2024 09:42:03 +0800
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
Subject: [scsi-next v2 2/2] scsi: megaraid_sas: make dcmd_timeout_ocr_possible static
Date: Thu,  4 Jul 2024 09:40:49 +0800
Message-Id: <87bee5805ca11e64045e05210f8afdcf895a89c8.1720056514.git.mengfanhui@kylinos.cn>
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

dcmd_timeout_ocr_possible is only used in megaraid_sas_base.c, this
patch makes it static. Furthermore, drop the useless "inline" label
too.

Suggested-by: Geliang Tang <geliang@kernel.org>
Co-developed-by: Jackie Liu <liuyun01@kylinos.cn>
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
Signed-off-by: Fanhui Meng <mengfanhui@kylinos.cn>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index e6a9cef027c0..c9f6e691128e 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4516,8 +4516,9 @@ int megasas_alloc_cmds(struct megasas_instance *instance)
  * Return 0 for only Fusion adapter, if driver load/unload is not in progress
  * or FW is not under OCR.
  */
-inline int
-dcmd_timeout_ocr_possible(struct megasas_instance *instance) {
+static int
+dcmd_timeout_ocr_possible(struct megasas_instance *instance)
+{
 
 	if (instance->adapter_type == MFI_SERIES)
 		return KILL_ADAPTER;
-- 
2.25.1

