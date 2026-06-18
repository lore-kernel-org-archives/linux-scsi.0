Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86163279907;
	Thu, 18 Jun 2026 14:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781791810; cv=none; b=qmrruS93yBi8dWzYPqdXEQpQP871gRv6SEXY/mhpWyATkdIqaDspQfYhDT/JF63IK7ymYHSGnb3UDC8h9tVe4PKBmVB2RfPTr8/A4COxoRHKsvDSeS0BZp2195MmNYtnOGmvLnFLnaJQGWVSvljGWc/le3V0LEPj+rWwf1FfoAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781791810; c=relaxed/simple;
	bh=sH5ynX5WFa9eEmysgNAniOJmsD3kRDzeuX2vvWIxt9c=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ss9+ubKnHSXZ5hHJ7Dix9ozhlZ7VLKcPCNpIZhNCVvG82DVz7S1CHCEJuBzmn6u0SOHRkwIi4Tmsmq+RsCdMZ+FsI+pa7+gp3Xx7MpKZoMu7yeu6X2NaWLz2CqW/HLMYky0HOU10tK7AL76k/3UcW47LOQIg/g8HI86MW258Je0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=kRa3ZAhV; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="kRa3ZAhV"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65IDt7HQ2007725;
	Thu, 18 Jun 2026 14:09:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=fS8RGLv3q3sgpwebpd7WziBbWEC43F4Wbl1
	odaEIbYA=; b=kRa3ZAhVy3k6LWtyavHjlGAX4GzQ6y57TkLwDDyLSX7HBKG5HBY
	oczq9H1INIEbYp1Tw5UAqwNHYP7Z4BUF9N1DsAEup3VM/dFNT0/9lWgUe16qD503
	yY7S5TzGhGEmTHkGJ39oxn7KGSuQHOI2p5aiDjQFy9IFaewcE8acKPH4Dp195tv4
	ywszaWXoSH7OiuhdsfKazwcARZH0b2TcIhcIcksw/hgfX82bV/7/WSpWACZFb5Xh
	vnh8CCKYJdK9ijhJqEgHSVrBrXNa8rKXn0YS7FY0TeK8LDnkLpwbW2w+mALmr3aY
	D7xF2jD7FUmc4vApI3Uec5llHhQ0a6MPcGA==
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ev0g7kwr9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Jun 2026 14:09:46 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA05.qualcomm.com [127.0.0.1])
	by NALASPPMTA05.qualcomm.com (8.18.1.7/8.18.1.7) with ESMTP id 65IE9jO1005630;
	Thu, 18 Jun 2026 14:09:45 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 4evhnq08qg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Jun 2026 14:09:45 +0000 (GMT)
Received: from NALASPPMTA05.qualcomm.com (NALASPPMTA05.qualcomm.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 65IE9i9c005622;
	Thu, 18 Jun 2026 14:09:44 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 65IE9iV0005621
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Jun 2026 14:09:44 +0000 (GMT)
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id 461D1655; Thu, 18 Jun 2026 07:09:44 -0700 (PDT)
From: Can Guo <can.guo@oss.qualcomm.com>
To: bvanassche@acm.org, beanhuo@micron.com, peter.wang@mediatek.com,
        martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] scsi: ufs: core: Avoid possible memory reclaim deadlock in TX EQTR context
Date: Thu, 18 Jun 2026 07:09:29 -0700
Message-Id: <20260618140941.902000-1-can.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE4MDEzMSBTYWx0ZWRfX6B4gs+7ysngA
 KzClhslXqnegJq9IXTlWgLfGWU+g5chh7+Pr8SrtSzEOl5DpaHcB1h2Vo3NjjctmhT1bfposjeV
 +tMd5PmBPfKxG6XXxGJpjpVLTTQHft5Hkx1fRruca2GqClV8jtt55Ht/b87nFYhQbJx18MYPx2v
 DiwGQLRXfcnPcOODCz1TUs1+GDOIYAukwi/ChxHTsIhDus/OOHWkpibtfeyRFhCljiXqOJfo2xl
 m3HU5BZ8AzLP8ugBc/W+YZAB1iqshYSti9JRmt6roAlZMEi3ba8TpOkSDWQ28aEtjf/qR1hEmEw
 M9LPe9W/7pNV3Gi/4DRedyGysu2NYYTdRNZkhsHdaub+lRuLpjl0qAaqL+tH9V+TCl4bjmS1N32
 Kw2aidBsQAhZmosGHLVvkmBVQTAJPilD84AOhmzqBJSVBcz4yGYwxK7Du4WOfIAtaEqArZO0OYT
 5l1E6GoYxbkWTxilnpg==
X-Proofpoint-GUID: BX2EQC65UbXr8tvrG6vLJ-M0fms-h1OZ
X-Proofpoint-ORIG-GUID: BX2EQC65UbXr8tvrG6vLJ-M0fms-h1OZ
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE4MDEzMSBTYWx0ZWRfX5gR8BVlCykH1
 bSr/F2wL/sNACXyJ543mgwl+n9z80itKYVXpV1QR+e6rd5TAnHzJIWwIh+FhflP0oJOTyND3wK5
 bzTCDJKLMSa6N/2EuOvXoz3MAvnGZL8=
X-Authority-Analysis: v=2.4 cv=YrI/gYYX c=1 sm=1 tr=0 ts=6a33fc2a cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=gowsoOTTUOVcmtlkKump:22 a=c92rfblmAAAA:8 a=EUspDBNiAAAA:8
 a=GQIZyLKiKp83YMogZvcA:9 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-18_02,2026-06-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1015 malwarescore=0 bulkscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 spamscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2606180131

TX EQTR may run while devfreq gear scaling has quiesced the UFS tagset. In
that context, functions ufshcd_tx_eqtr(), __ufshcd_tx_eqtr() and
ufs_qcom_get_rx_fom() allocate memory with GFP_KERNEL. If direct reclaim
is triggered, reclaim/writeback can depend on I/O to UFS device. Because
the queue is quiesced, this can cause deadlock.

Use memalloc_noio_save/restore() in ufshcd_tx_eqtr() to cover all
allocations in the TX EQTR call tree, including:
- params->eqtr_record in ufshcd_tx_eqtr()
- eqtr_data in __ufshcd_tx_eqtr()
- params in ufs_qcom_get_rx_fom()

This is preferred over tagging individual call sites with GFP_NOIO, as it
automatically covers any future allocations added anywhere in the call
tree without requiring each caller to be aware of this constraint.

Fixes: 03e5d38e2f98 ("scsi: ufs: core: Add support for TX Equalization")
Closes: https://sashiko.dev/#/patchset/20260615132834.2985346-1-can.guo@oss.qualcomm.com?part=2
Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
---
v1 -> v2:
- Replaced per-allocation GFP_NOIO usage with memalloc_noio_save/restore()
  around ufshcd_tx_eqtr() call tree.

 drivers/ufs/core/ufs-txeq.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufs-txeq.c b/drivers/ufs/core/ufs-txeq.c
index 4b264adfdf49..9dca0cd344b8 100644
--- a/drivers/ufs/core/ufs-txeq.c
+++ b/drivers/ufs/core/ufs-txeq.c
@@ -10,6 +10,7 @@
 #include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
+#include <linux/sched/mm.h>
 #include <ufs/ufshcd.h>
 #include <ufs/unipro.h>
 #include "ufshcd-priv.h"
@@ -1212,14 +1213,25 @@ static int ufshcd_tx_eqtr(struct ufs_hba *hba,
 			  struct ufs_pa_layer_attr *pwr_mode)
 {
 	struct ufs_pa_layer_attr old_pwr_info;
+	unsigned int noio_flag;
 	int ret;
 
+	/*
+	 * ufshcd_tx_eqtr() is called from a power-mode-change context where
+	 * I/O is suspended. Use memalloc_noio_save() to propagate GFP_NOIO
+	 * to all allocations in the call tree instead of tagging each call
+	 * site individually.
+	 */
+	noio_flag = memalloc_noio_save();
+
 	if (!params->eqtr_record) {
 		params->eqtr_record = devm_kzalloc(hba->dev,
 						   sizeof(*params->eqtr_record),
 						   GFP_KERNEL);
-		if (!params->eqtr_record)
-			return -ENOMEM;
+		if (!params->eqtr_record) {
+			ret = -ENOMEM;
+			goto out_noio_restore;
+		}
 	}
 
 	memcpy(&old_pwr_info, &hba->pwr_info, sizeof(struct ufs_pa_layer_attr));
@@ -1244,6 +1256,9 @@ static int ufshcd_tx_eqtr(struct ufs_hba *hba,
 	if (ret)
 		ufshcd_tx_eqtr_unprepare(hba, &old_pwr_info);
 
+out_noio_restore:
+	memalloc_noio_restore(noio_flag);
+
 	return ret;
 }
 
-- 
2.34.1
