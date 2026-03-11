Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543F634D902
	for <linux-scsi@vger.kernel.org>; Wed, 11 Mar 2026 06:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773209368; cv=none; b=ltyQFomCI5p1R6nw8xiEqIMy4OARBj/iizaTerQomcrjRQ1pa3G3SmNByGnTLUCUYnGY9DTt+2WfPTT1/oMb1EqMIg93wwamfArvMT8JdNT2hwph6zhrCQuZjECyPIOF5b+ad/UmnC8rYu3rBII+ZBnndBJNF8riLWY7W3t+t/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773209368; c=relaxed/simple;
	bh=9sccUKaZSr8ywssnVFM1RdHmOQ7XGxUmVBnmL132DMY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=u+IpgDGRLXGYWYYyz0jDiaCXDGZNZ2V/sTx55m7E2Nq/YTyztnUHWN1RyFJdYvpxagYrePS6NSijRDVcNBcps2xTj3iQOtvTxNB7IsMR34kmzFStgLlrp+NwUWPCPoeLJ59JOZMcQBUB6ovwUHgBvcHqpYNdyACmye0K8OyGqgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=JNdKlW4i; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=jyV1Uz7/; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="JNdKlW4i";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="jyV1Uz7/"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62B5Jxei3295792
	for <linux-scsi@vger.kernel.org>; Wed, 11 Mar 2026 06:09:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=SV8YcDYDzpo
	HRabnVJC4LyUMveC1weMJBeT5vJRXZ6M=; b=JNdKlW4icpULbagCyHC3FTHEB0k
	F1ISbD5BgkmAjVlMe16gyWMjFp/Bldx1Xemy3WMRvFt6mc9kuHAFHQYDlT9PmUrW
	SDUm7nAki5qFvcUi73TCK7gl6zFDRucPMRWfOCqT0vTnB31zfwShnfV4jVmSH8Ea
	lx4VCk4H0yLnWR1ffQ36UBSS6ppAFrS8Fe/61ybD3X5nDUYPahuBYmYmcSv6Zw5S
	HDNFnjjjsCYojNwz38oLhUWvlRoyem7m+BjVS7pAk+ZUZ18OQA2KAkz6pBsZThHE
	GblZu1iWIw6zcFwlatxo4Pv/9iS17UACK6ubTODyQ7mGeghkXAv1OII0q2g==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ctg1mv7nb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 11 Mar 2026 06:09:26 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2ae49120e74so95362415ad.3
        for <linux-scsi@vger.kernel.org>; Tue, 10 Mar 2026 23:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773209365; x=1773814165; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SV8YcDYDzpoHRabnVJC4LyUMveC1weMJBeT5vJRXZ6M=;
        b=jyV1Uz7/TjoZPAtFs/hRVmIjl4Z/hC0H7yP28/oWiF49LRE/83Pel1QxYVv9WGvJJ8
         dXVgcB7e+4GykXwCp37hnoY4oLa5FAx3C0iSz9nJH2T50IiU80Xu8Yivj5OuZai996xJ
         q4+/BjKDRicbTwEddPlrAUZvvU6I+RZ2Io35URvqSK/bNNoLjZNQY/2kI0d+KiJnaXxm
         qOZhSuA5/LQ9yymyO1DhqzAKiSTUpEVthwpB2Mq3qAKWk4J7riGB8hC83kIYOhvamJz9
         6FjFehe4iJvQa/IyY0YFl1rYhd2RvRq3jk9S59pdsHOzIxgUY8QhG5G0ZDZh2fy8GcJn
         uXeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773209365; x=1773814165;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SV8YcDYDzpoHRabnVJC4LyUMveC1weMJBeT5vJRXZ6M=;
        b=E386sulnsOp10yE3fJ3W35DV2dA+/cAfjYef0kFG6uzPp3L/cn3AmrMNfDakoK9E1S
         c4uBHfAigULyoiZ+WqKj2jBKrdJh5DyN5zeIzBQs+gmztx5DQSNgHInsKBe0TGNiJK28
         eXBuPnzAvHmXtZhVGj7j2wDNqLi7xDXzaHbETRPJCPs2wQFrp1U6HeuBa5RDqtVdbOuN
         r7TIRZpHzyFLQV1m3aUsYsQtWuIQuz6YXcv9sx6BM2KGj1xEJZz68iR/WVeZz5pGs9kx
         zG2V0K5ohKCdlHF99KQeH08Jpztp+yiK5Cxal2XzPqt2Pr362/p6NFc4YMe5vip6w+6k
         3usw==
X-Forwarded-Encrypted: i=1; AJvYcCXqPZZJN3OUUkT2285vSn328h89vKub/kLoFPe8Fob3+gzRVEj+ZFMTub1XUEzAxlYCG+H3HG4Zrq+l@vger.kernel.org
X-Gm-Message-State: AOJu0YyM6xD4WyUwwm1S0cFdUixJwQd4blcseipW0WPWHzxzgwp3V4y6
	tFweWZ3caw1MObYJze7sbES7rxyNE3muhX6WVUsLdtEZ7M+UVAva1W8GA8FnzpgAwY4D02S5wn6
	k/dubhobnPNAtFLUqS6IezsChuZP7aOkjAmnF4U6+yEBqV5fJABsOXqrzaespIY91
X-Gm-Gg: ATEYQzzawGm6jlhQTm3Y2RT61Dmqj/yQvcFjTPNFV4LJijNWyPwnQXIx2mCLqVB/H5z
	uX4lvf3hEHngFT0buf+p3Z2WAxOAUwBwv3prRcI3JfTWiVW4v00cVVJFWzGLT1EF66+jS2DSYac
	+7MjYsIshPKygFCRJywAdFoSvuniy8U07+wOIDBOGjvvq6BlxPtNsTQdZJgNgd9aDNGVye2kiI/
	No5cSyJFg8iIbYszfg/Zt233+Gn8VsJNwLpS8k5kDPkOACPbCHc2l1PXIcLdL10XVUuRCHIa7FR
	nKg7smyOII/DVzmuwp9cXygcGhyj9ZR7f/SBc/sMAORafDBN6kAavbGPXqpSZC/dfNWufo9FWje
	i3pIDaWLLHCB8LfQ5NOm6SYbjO9QJbCB9XyGVaJlQX63bsCviJDwc9A==
X-Received: by 2002:a17:903:3846:b0:2ae:47c9:68aa with SMTP id d9443c01a7336-2aeae92a03dmr16644615ad.52.1773209365190;
        Tue, 10 Mar 2026 23:09:25 -0700 (PDT)
X-Received: by 2002:a17:903:3846:b0:2ae:47c9:68aa with SMTP id d9443c01a7336-2aeae92a03dmr16644355ad.52.1773209364705;
        Tue, 10 Mar 2026 23:09:24 -0700 (PDT)
Received: from hu-pkambar-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aeae246fe5sm12433265ad.28.2026.03.10.23.09.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 23:09:24 -0700 (PDT)
From: palash.kambar@oss.qualcomm.com
To: mani@kernel.org, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, nitin.rawat@oss.qualcomm.com,
        Palash Kambar <palash.kambar@oss.qualcomm.com>
Subject: [PATCH v1 1/2] ufs: core: Configure only active lanes during link
Date: Wed, 11 Mar 2026 11:39:11 +0530
Message-Id: <20260311060912.3139257-2-palash.kambar@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260311060912.3139257-1-palash.kambar@oss.qualcomm.com>
References: <20260311060912.3139257-1-palash.kambar@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=YOeSCBGx c=1 sm=1 tr=0 ts=69b10716 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22 a=EUspDBNiAAAA:8
 a=Z8YMyZzXpU5RQDwMThsA:9 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-ORIG-GUID: uYo_RIMS_Etgdn96cJbQO6pZIQWe5cbm
X-Proofpoint-GUID: uYo_RIMS_Etgdn96cJbQO6pZIQWe5cbm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzExMDA1MCBTYWx0ZWRfX9JBmLfNjEUx1
 nBIbabtG3XgykDaxJ3UCXLsG8j02u2Ys7IAFGzGs/WHZ78ObGERoxbn8O5RJpoDoq5MfmSY3Cdw
 iaIOVHVVG6SfwWvnBdDYvsyrcfZjJUDL2QN5xApETkEMtOMlin2aDpG8LxOsn5HKAXTNkHYks7o
 BAIArs2qwJp+fW1klWP7JcKGRKz70VVCo9UjtKfkDZx0/WMbGJtLEH67i5qUntSpmZT57AnQyYu
 5cC3G6c6ZfVTftLSW2SQCXqTaGclbZe0T5cd5W5IueIAkYR/6RupRs9xkGctxt0I0UJmnbEEfMk
 LrKz0ODyvhRfEJKDNOaWhSDa+p67Kz7fyE/h17giaLdJSuvBewJR2B9IpDA2c9glRHoz0tsaD7O
 sv38PMTlVQCPpEqLEAj5AD11iE9QMsU69Icu5N2WaiAGZhZ1NYpKBW2et7kAmYTdg7DYj85MnXZ
 ZfsGgiea2KUWGS4hJXg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_05,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1011 spamscore=0 bulkscore=0 suspectscore=0
 priorityscore=1501 malwarescore=0 phishscore=0 adultscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2603110050

From: Palash Kambar <palash.kambar@oss.qualcomm.com>

The number of active lanes detected during UFS link startup can be
fewer than the lanes specified in the device tree. The current driver
logic attempts to configure all lanes defined in the device tree,
regardless of their actual availability. This mismatch may cause
failures during power mode changes.

Hence, add check to identify only the lanes that were successfully
discovered during link startup, to warn on power mode change errors
caused by mismatched lane counts.

Signed-off-by: Palash Kambar <palash.kambar@oss.qualcomm.com>
---
 drivers/ufs/core/ufshcd.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 31950fc51a4c..c956fab32932 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5035,6 +5035,42 @@ void ufshcd_update_evt_hist(struct ufs_hba *hba, u32 id, u32 val)
 }
 EXPORT_SYMBOL_GPL(ufshcd_update_evt_hist);
 
+static int ufshcd_get_connected_tx_lanes(struct ufs_hba *hba, u32 *tx_lanes)
+{
+	return ufshcd_dme_get(hba,
+			      UIC_ARG_MIB(PA_CONNECTEDTXDATALANES), tx_lanes);
+}
+
+static int ufshcd_get_connected_rx_lanes(struct ufs_hba *hba, u32 *rx_lanes)
+{
+	return ufshcd_dme_get(hba,
+			      UIC_ARG_MIB(PA_CONNECTEDRXDATALANES), rx_lanes);
+}
+
+static void ufshcd_validate_link_params(struct ufs_hba *hba)
+{
+	int val = 0;
+
+	if (ufshcd_get_connected_tx_lanes(hba, &val))
+		return;
+
+	if (val != hba->lanes_per_direction) {
+		dev_err(hba->dev, "Tx lane mismatch [config,reported] [%d,%d]\n",
+			hba->lanes_per_direction, val);
+		return;
+	}
+
+	val = 0;
+
+	if (ufshcd_get_connected_rx_lanes(hba, &val))
+		return;
+
+	if (val != hba->lanes_per_direction) {
+		dev_err(hba->dev, "Rx lane mismatch [config,reported] [%d,%d]\n",
+			hba->lanes_per_direction, val);
+	}
+}
+
 /**
  * ufshcd_link_startup - Initialize unipro link startup
  * @hba: per adapter instance
@@ -5108,6 +5144,9 @@ static int ufshcd_link_startup(struct ufs_hba *hba)
 			goto out;
 	}
 
+	/* Check successfully detected lanes */
+	ufshcd_validate_link_params(hba);
+
 	/* Include any host controller configuration via UIC commands */
 	ret = ufshcd_vops_link_startup_notify(hba, POST_CHANGE);
 	if (ret)
-- 
2.34.1

