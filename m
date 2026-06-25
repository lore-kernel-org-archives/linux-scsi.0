Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6743E025E;
	Thu, 25 Jun 2026 12:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782389630; cv=none; b=UNigzhf4ImIxU0mVSrGGtYHsvfP52fm6LNRIJ9kp1VBj5RguzhAXQmZHAVzlV87Vlvthup9ueZk4Hz89oop25clAhb4qfGRQwv1KhxNcuvzxkRmVog4FDYx4Z6l8i6QroWFBgZnWnJT6h5XXvL68psZdY8r3HySwmpHGiX+6hVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782389630; c=relaxed/simple;
	bh=UH2xABG9ws1Pe8l00nqT5eOh2WUXHIJOpQmeMi7ugEQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RF1ggjPDmPF/Ryfm4nOPYmGWrjKLb3Sk5yosJgX6cMj8wwgPeFBsJ9caR0/JygI+zqo9jFf/qr9hghFds5J4ov5Y1aoomiyilS4hYisf4W47WSdQyrtAwfqWpm7iB2d2U8AxaLSL1mLQZzLT+obhoNgKSrP4URs+NqCBrW32Baw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=CtMBkkWx; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="CtMBkkWx"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65P9jutG1470664;
	Thu, 25 Jun 2026 12:13:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=TaDCDsAJt3J
	hwfWit2OZtkQHLJaEb1/D5jK0iVvmEzE=; b=CtMBkkWxZAtH6jltLARIJW16xaZ
	ca1xjwYtw8RImOjuZHN8oWlCumE9xkcWRXay2NlKbzze1Xq3ptK0gn44yGDTQm+f
	KmH0S1IgdUpIPBdoYWMFkbwTv/jygbag8rH1oc0z++02jFJex0dBMrfP4wnNGp85
	RU1fW9bN/9EbVeNxbqfhJdH6IfQGGwXhgac4c4H6jN5W/DC4/cdzTSbcMC4oAMSU
	5BN8K+jzShxm1DtiefjZrdv93JokWscbj5C/6M1AI9s33QWvbMLlyA1aplw9FHcZ
	QS4ckV2I9rbq//siXd5iHOvm1GlWxAsvd8UGcYYqdAbqe7Jk8xw7eQZNXQw==
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f0nv7k7g7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Jun 2026 12:13:26 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA03.qualcomm.com [127.0.0.1])
	by NALASPPMTA03.qualcomm.com (8.18.1.7/8.18.1.7) with ESMTP id 65PCDPGC006774;
	Thu, 25 Jun 2026 12:13:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA03.qualcomm.com (PPS) with ESMTPS id 4f0q1qxr9c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Jun 2026 12:13:25 +0000 (GMT)
Received: from NALASPPMTA03.qualcomm.com (NALASPPMTA03.qualcomm.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 65PCDOFl006756;
	Thu, 25 Jun 2026 12:13:24 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA03.qualcomm.com (PPS) with ESMTPS id 65PCDO1b006754
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Jun 2026 12:13:24 +0000 (GMT)
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id E14F7620; Thu, 25 Jun 2026 05:13:24 -0700 (PDT)
From: Can Guo <can.guo@oss.qualcomm.com>
To: bvanassche@acm.org, beanhuo@micron.com, peter.wang@mediatek.com,
        martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 2/3] scsi: ufs: core: Tolerate RX_FOM read failures in TX EQTR
Date: Thu, 25 Jun 2026 05:13:04 -0700
Message-Id: <20260625121306.1655467-3-can.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260625121306.1655467-1-can.guo@oss.qualcomm.com>
References: <20260625121306.1655467-1-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI1MDEwNSBTYWx0ZWRfX2hQB7KvaDV7z
 iRNndMRGW9C82srJYvi8gFXlERm7e62Z6ve7UtyyDFwa6pDC/QRiZe+OfWqbkTtlGsiiQQRP0+g
 EpTd9C48sFx4cVjzOrZVN69Cj6/+Ivg=
X-Authority-Analysis: v=2.4 cv=RJiD2Yi+ c=1 sm=1 tr=0 ts=6a3d1b66 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=eoimf2acIAo5FJnRuUoq:22 a=EUspDBNiAAAA:8 a=MY0Nf5o17odUSmN9C4UA:9
X-Proofpoint-ORIG-GUID: 4YaMDM4x7QhiUfD280fDWfYrXkphkxOJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI1MDEwNSBTYWx0ZWRfXzN848DF7Olgy
 KrscOml7mvTghtzxDn5RH2Nnh4goRbMyOTqa9vIiREs5d0dpPRzvfra4qcZXzkoZGUBYyMwgskU
 0cYa2PhQH/tjwQky7z+NiAaKmGE+4CDN3iXNRIzmo9HZtwaEjlatro4N6XnQ7pY88LO6Vq6ztYc
 7Vmto3tfR4fuH6gTom3+dx3eGLb142nCMIExBxwjtWmseix2x+wvKzJcRB+YxedlwKCARHsSg4b
 QLFsBwFknX0iK3vf3lVi3y3Z64hU0Hd6/fOcTlg+F2wEbaQzW0N/CAf/VP6lYTmpvBnTxkpuPSB
 SrIqIUSdo8EpqlfW1wMmf8prwAVS924NFRTfw/poBJ/6NSn7YMEGo/gXk0xmDdSCev5cokvq+ic
 GAtrIKv/Gf1Js/j1RoXxOPnsAcgmTqmPBjmjNzLBLMSmKTCEZNDfwlbktzfW2cdFHqLT8v4PKTp
 tZNI0ObOufzl8QX/aLA==
X-Proofpoint-GUID: 4YaMDM4x7QhiUfD280fDWfYrXkphkxOJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-25_01,2026-06-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501 spamscore=0
 clxscore=1015 impostorscore=0 suspectscore=0 adultscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606250105

ufshcd_get_rx_fom() aborted TX EQTR when a per-lane RX_FOM DME read failed.
That makes the whole training flow fragile even though these reads can be
treated as best effort.

Keep TX EQTR running by logging RX_FOM read failures and continuing.
Make failed lanes deterministic by initializing each lane FOM to 0 before
reading and only updating it when the DME read succeeds. This avoids
propagating stale or uninitialized values into EQTR evaluation.

Also update the kerneldoc return description to match behavior: RX_FOM
DME read failures are handled as warnings, while get_rx_fom() vops
failures are still propagated to the caller.

Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
---
 drivers/ufs/core/ufs-txeq.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufs-txeq.c b/drivers/ufs/core/ufs-txeq.c
index 9dca0cd344b8..e1302ea9f27e 100644
--- a/drivers/ufs/core/ufs-txeq.c
+++ b/drivers/ufs/core/ufs-txeq.c
@@ -482,7 +482,8 @@ static void ufshcd_evaluate_tx_eqtr_fom(struct ufs_hba *hba,
  * @h_iter: host TX EQTR iterator data structure
  * @d_iter: device TX EQTR iterator data structure
  *
- * Returns 0 on success, negative error code otherwise
+ * Returns 0 on success, negative error code if get_rx_fom vops fails.
+ * RX_FOM DME get failures are logged and treated as 0 FOM for that lane.
  */
 static int ufshcd_get_rx_fom(struct ufs_hba *hba,
 			     struct ufs_pa_layer_attr *pwr_mode,
@@ -497,8 +498,12 @@ static int ufshcd_get_rx_fom(struct ufs_hba *hba,
 		ret = ufshcd_dme_peer_get(hba, UIC_ARG_MIB_SEL(RX_FOM,
 					  UIC_ARG_MPHY_RX_GEN_SEL_INDEX(lane)),
 					  &fom);
-		if (ret)
-			return ret;
+		if (ret) {
+			h_iter->fom[lane] = 0;
+			dev_dbg(hba->dev, "Failed to get FOM for Host TX Lane %d: %d\n",
+				 lane, ret);
+			continue;
+		}
 
 		h_iter->fom[lane] = (u8)fom;
 	}
@@ -508,8 +513,12 @@ static int ufshcd_get_rx_fom(struct ufs_hba *hba,
 		ret = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(RX_FOM,
 				     UIC_ARG_MPHY_RX_GEN_SEL_INDEX(lane)),
 				     &fom);
-		if (ret)
-			return ret;
+		if (ret) {
+			d_iter->fom[lane] = 0;
+			dev_dbg(hba->dev, "Failed to get FOM for Device TX Lane %d: %d\n",
+				 lane, ret);
+			continue;
+		}
 
 		d_iter->fom[lane] = (u8)fom;
 	}
-- 
2.34.1

