Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E33A2E62A4
	for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2026 04:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776401787; cv=none; b=Xrd5ZA4M1821+NPuSmTH5Msu7YJXkJsTItG4flwcrbmU1+ncbbIZn7HAbWsqiMe65u8uz9iU8V0ya5zkiHI/LTDkfABL1iDPzAPYNq/B1th8A9ZU8Bxn+k+FZ5cSWdRBfX6a4Jv7Dprk6IIcfb/qb+la5uKVgUvwAk9OFXJoaVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776401787; c=relaxed/simple;
	bh=OT5u2ONptORC5MouS3fuNPzcbostP9NpKv1/r7MwhjY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=t/6eqBjVUk7OmY2a6Y/ju0XSXQxSpGGcsxWpO7ujwgE0J/q/8EIzVlfkXB9AbWLNQx/dvTgB+eN5MfIkxjbv13I0CR+TEQfSvzWyr383NQHjYVkMiDsYaT9TDWeRjd0Wd0pEb/klBbrElkJa/CKr4hs3a6mvqetGDfTDv537UTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=QZNYkR1Q; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Bu0eBjDT; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="QZNYkR1Q";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Bu0eBjDT"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63H0fiuv1872644
	for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2026 04:56:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=Ayxjj0kFxM6
	lXABDb6ZrdOtAZi6U3ltyOfDuAQr5w3o=; b=QZNYkR1Qq83MTZ8CNzyFDbVFgOH
	rLVWrM6UPyljJ7GQpEyi55Bb1+RjnsePtYljuq9m3Fg9gEHWA/Zph8/zxIb5zVlY
	M+bAfybgVvYx+pREqRPbY+aMqfhN0I4zRSk6HM7HxhC3WYYWxwP27fsP73sCPsBE
	70QOorH/kJrZNhkxvTBb+DnpzURYhE5Ni9j8mDxc6n2AUn9+KK4mfcBUNqKMbUkz
	Xs5IViPdCUsqz8KnBhkchAlU2+OrQ49nU35Z3N/hvpuSNUtBxgL2oPT3zcM8tw0X
	1kDRvDGFbPZbFrX7FzTYS20ztvmbb4YtZuFl66YsOM65QhGzcAmgKOMcCKQ==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dk2knabk5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2026 04:56:25 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-358e95e81aeso953647a91.0
        for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2026 21:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776401784; x=1777006584; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ayxjj0kFxM6lXABDb6ZrdOtAZi6U3ltyOfDuAQr5w3o=;
        b=Bu0eBjDTLq+EI/dfzwu+P6N9JAFl1d0mD8r4kH4GXIkAr+KiEKg36z0MCcc/l6x2as
         UfoM3S/gTWWnZov0rWut9ngkSN6pD/2gTzkZSTlRLWTH6u1q4+fPApAizG4ROTEnc3a4
         XTL+1V80p0xxaFZUY8Ijg9eJOJZgKvOh8w4vNs501gs6YOegPJwWfPqfDm61vRnxM1vs
         lCGIUC2db53yFLd/AufZirypih4fj600PI1ln/Kd+GObBo+3CCWPMr8Gxh+t/j8+dIJv
         CGgMX/wa8JqlC8TlogCYJHryE/j6Mf+P/nlXIp3cnJssMeXn4vEHRNz0RdPdAPPsqN7F
         0xFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776401784; x=1777006584;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ayxjj0kFxM6lXABDb6ZrdOtAZi6U3ltyOfDuAQr5w3o=;
        b=ql7pJA4pYi4gB+35unuiTjBjOAXWsiqQlyLCy/ERPdwfuSub27pUULkDgluIj6Fhck
         ZYT4fb4VANvMIYuPawdnTM7wdqOSxrcgc7Mkc3MUyXr9xJI4rRK+X6ZjI8r0qO4yWtrc
         Am+rTSvj6Ao9gRGLb5EJ7xB+irhkn+WfV7BdL02G78mO0sxfPHOZnC0+Dk+WCw0XD6Ny
         9/Shb4uBhyzccS+xP5RtJY8iEdkaU0Qk02NZEOVUeIkFzsQbXDBpH92URgSL79XeiIJ7
         H8Mpjodd30UsZ3VrAOoY2HC/u/xyDSJajzfV5i4jG4xjNmS8wwRMI7mFfBhKJ3nfmUlu
         rHXQ==
X-Forwarded-Encrypted: i=1; AFNElJ8evrE4ObzcqGpsi3LkeblBStgjKLQPa4fQrdJW/0AiAya8pOzAzFkFkQYpIOpFoegNbfNoNEzvi8uw@vger.kernel.org
X-Gm-Message-State: AOJu0YxOLI9Rg32a0pekQJSNip2vVvMWy8EUoMsq5P+U9hef3y7KgYo7
	DzhJJhyZDo0byKxiOSWwg8fyN5IWvdSgCjzabIsUi0bhXK/8clVpp4/mwRrvh1SVDpc9Z1EpocX
	Wkp75a9l9blePV9ssHDZGuaxCV/GxbxCOtxE3/Yg7LytVwjWuBF449L8XVRUZp2Mq
X-Gm-Gg: AeBDiesaiRlWJ5a8SZJ04TWen85piWucQZ9aUIpSt043IYpZ12sC6QPXgIzUvFd7O7E
	IGi8LzPuWxkqBi0Sw1mDObscP2TXK2ySuIf7a7wubrPRrJpjMmHYgh8Ob63EU0K45S8VuYYuKit
	tRF7O0bCIUA9Knne87Te4Iz0Z4llGJ1qUVU5A7qKHJR8j7YWkmLal3s+EDa/pCqBEZtKCRYPyZO
	hOvNLmfIzdbB9hnNESuKkSnnlSoFqveeScq/nFWDTCepX5cq4GsLi6oFOMGc6aLtkWLjBH6Ac9W
	w/MErACHBPh60DGrCZ7M2QCXWcj/Qm7C9IJHParCeFPd/WcJVY/0TZ1gncMiq+gtmjCv/nWD6JO
	UL0K/gfW2962vlLudbMJaBlEaBiSVinm98AsLM2znWqkXllHnIrWAXKjO/8a657do
X-Received: by 2002:a17:903:2b0c:b0:2b0:41eb:165e with SMTP id d9443c01a7336-2b5fa009d46mr14057495ad.38.1776401784284;
        Thu, 16 Apr 2026 21:56:24 -0700 (PDT)
X-Received: by 2002:a17:903:2b0c:b0:2b0:41eb:165e with SMTP id d9443c01a7336-2b5fa009d46mr14057125ad.38.1776401783760;
        Thu, 16 Apr 2026 21:56:23 -0700 (PDT)
Received: from hu-pkambar-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fa9ff3a8sm5702115ad.12.2026.04.16.21.56.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 21:56:23 -0700 (PDT)
From: palash.kambar@oss.qualcomm.com
To: mani@kernel.org, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, bvanassche@acm.org,
        nitin.rawat@oss.qualcomm.com, shawn.lin@rock-chips.com,
        Palash Kambar <palash.kambar@oss.qualcomm.com>
Subject: [PATCH v4 1/2] ufs: core: Configure only active lanes during link
Date: Fri, 17 Apr 2026 10:26:01 +0530
Message-Id: <20260417045602.3042928-2-palash.kambar@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260417045602.3042928-1-palash.kambar@oss.qualcomm.com>
References: <20260417045602.3042928-1-palash.kambar@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: 0YtjPfLl25CASuujjzQPD4khgUPATR3R
X-Authority-Analysis: v=2.4 cv=XNoAjwhE c=1 sm=1 tr=0 ts=69e1bd79 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22 a=EUspDBNiAAAA:8
 a=Z8YMyZzXpU5RQDwMThsA:9 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-ORIG-GUID: 0YtjPfLl25CASuujjzQPD4khgUPATR3R
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE3MDA0NiBTYWx0ZWRfX6kltTfJ6Cm9J
 28ED5DwIUl6xszkbE7CTgWh2x4DpNm7Uqr+pSJ7tLIN7EJeFI/fLf9MWrn2zPUi6R/h/tHfssvG
 2pQPFrEBNW1MThQTF7uWKoo7kVahjBM3ZqeC75fo5LyPVrPyAnRf3mBVCBxGkhR++BRDo9GWvA9
 f5DiDc2y/8aQa6uw+rxpd04a/tfEid0tgBcVIUgBMt01oESkJ8a/eISmMeLSvLl019pbJ6eT7+N
 QXt4b3ZUgDdK5stBVVOO+rI/c3d55lFmuYci8yCttmlwJOdOaAzYIllnr4d6FwezLOU7V9b5TqN
 OqylcMziwlJREVfy7t0tqkuGEk531xMY0XCZDfuvCWXzMOsM1VgyrNv404yjDxaaEQoNW6pV1fg
 MOGtnuUt8mrhe2gAfaQxCpb3ehFTydipb2/Ov2q5WgFpYLmC95soNSC7NeduTJWf0JB0+5BR1bN
 hr3PpK3sxgtWxrFX+mA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-16_04,2026-04-16_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=0 priorityscore=1501 suspectscore=0 spamscore=0
 phishscore=0 clxscore=1015 lowpriorityscore=0 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604170046

From: Palash Kambar <palash.kambar@oss.qualcomm.com>

The number of connected lanes detected during UFS link startup can be
fewer than the lanes specified in the device tree. The current driver
logic attempts to configure all lanes defined in the device tree,
regardless of their actual availability. This mismatch may cause
failures during power mode changes.

Hence, Add a check during link startup to ensure that only the lanes
actually discovered are considered valid. If a mismatch is detected,
fail the initialization early, preventing the driver from entering
an unsupported configuration that could cause power mode transition
failures.

Signed-off-by: Palash Kambar <palash.kambar@oss.qualcomm.com>
---
 drivers/ufs/core/ufshcd.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 31950fc51a4c..10f8d2b552be 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5035,6 +5035,40 @@ void ufshcd_update_evt_hist(struct ufs_hba *hba, u32 id, u32 val)
 }
 EXPORT_SYMBOL_GPL(ufshcd_update_evt_hist);
 
+static int ufshcd_validate_link_params(struct ufs_hba *hba)
+{
+	int ret, val;
+
+	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(PA_CONNECTEDTXDATALANES),
+			     &val);
+	if (ret)
+		goto out;
+
+	if (val != hba->lanes_per_direction) {
+		dev_err(hba->dev, "Tx lane mismatch [config,reported] [%d,%d]\n",
+			hba->lanes_per_direction, val);
+		ret = -ENOLINK;
+		goto out;
+	}
+
+	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(PA_CONNECTEDRXDATALANES),
+			     &val);
+	if (ret)
+		goto out;
+
+	if (val != hba->lanes_per_direction) {
+		dev_err(hba->dev, "Rx lane mismatch [config,reported] [%d,%d]\n",
+			hba->lanes_per_direction, val);
+		ret = -ENOLINK;
+		goto out;
+	}
+
+return 0;
+
+out:
+	return ret;
+}
+
 /**
  * ufshcd_link_startup - Initialize unipro link startup
  * @hba: per adapter instance
@@ -5108,6 +5142,10 @@ static int ufshcd_link_startup(struct ufs_hba *hba)
 			goto out;
 	}
 
+	ret = ufshcd_validate_link_params(hba);
+	if (ret)
+		goto out;
+
 	/* Include any host controller configuration via UIC commands */
 	ret = ufshcd_vops_link_startup_notify(hba, POST_CHANGE);
 	if (ret)
-- 
2.34.1

