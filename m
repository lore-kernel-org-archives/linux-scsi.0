Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794489529;
	b=Bju12DT3IoOTLDDw9Ai74fXRoeQt2AEZVFfyhnCcEUL6ST0Tr0Aqs0A/VIG7LCu06H79
	 HE3NiDo2UVWx2blxZ3tm+57uB8tLBaT8yx4nNGB7ETLdIS7t0IrTxXn8u+Gf9YOo3mMDE
	 5EEalr/eIz+UIwl4TqybViWUMttkALUZSsHEHvxGH2fj1RG2oL/g8m00hOmFKSE37H5Id
	 YZtWnFW7qP4w6bVS2xKvtWpDOZfVMspW6QCmCGC6Vxv9uDQQOs9R9VPe/tI4NUWeL4wDm
	 rb2QyBB3ZPKqNc5cdL+LwM7Z7neqqT4Tdygs4B91SXLrFL4qj4FKANjPZXR/LI/Yexg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794489529;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=FYKf+BSxd2cb15fIXmB9GOlvMtwvtc8EHKSqZ6YcNI0=;
	b=gL/T6YUlf7vISKQDILt7tn0C+B+DNWXLK/r88VyIBBKMZ6nlht2fmhUHdABynoarCAHj
	 0jb2dNK7THjmhyiz6A2mSI/qUn7BFwT8uYA1uJ7/rKFYMFMXzdnAI1i7HvQEu5z7ByhcW
	 Ubl7HdP7xwTbgGI7i5jFkt3er9sWbEnA5liSOawT7/CTTGW/sZMJBBNPMEZFYpIwYkZv9
	 Zbs2ujTiwBE31Y2kA/+UayLw7nvdM+lYJM3jGdgHl9jBomMN2dkh31fInsXfH3Z8TFzT7
	 qI6GD+e553WllzZDFpbLPyq9i0UN+YTTyi4Fu1Xn1qfdwXDwTaHpJkv828JVw9kEBnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=iEV4faAH;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=YAWxeJJr;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E395C606A8A4
	for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 13:18:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E395C606A8A4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=iEV4faAH;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=YAWxeJJr
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ACAUU7e1629167
	for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 13:18:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	FYKf+BSxd2cb15fIXmB9GOlvMtwvtc8EHKSqZ6YcNI0=; b=iEV4faAH6AEwx0yK
	M8mdfguFa67BDVndXkch3vGD1FgznzpBchyXDhGoZPawVNC1dGjOQvR25hpW3Xm5
	gYz8OciFHmJZC1PAWKdsA6NTFwNc3jT87CbXxksERiEUcwN9EUi67VRrQW/QtPqm
	dhg4Qk/mThJZB+x/uQAcwelSZm8sIFBG0vn+u1G+NZ81DGD7R3ZPcaIL9qNneVq0
	0bbqu0E3mPhjh3nSQTBEcFMGntolMHPmaok+g03Lc61oY0Qzq3Rdpp7nXapZHY3i
	nDRRC3D+HBu1Plz+rpNbp4LrtHjqj1aW0nuIjHP1fW2yWkPPSSksSIGFWU0mpl+0
	nzom3w==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hwbs00hrf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 13:18:47 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-36f479b9819so6824736eec.1
        for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 05:18:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794489527; x=1795094327; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FYKf+BSxd2cb15fIXmB9GOlvMtwvtc8EHKSqZ6YcNI0=;
        b=YAWxeJJrmwgtpLdrXgRxtWdhAHbyFVdp8oXahHIP0oYMmIVLxpn9Po7ZDdTgUQuVeH
         gxiuxJsZoXYKRazaTliQHaMjlYuJ/dzkgDCu+kg37puDm7BdMkaY7Lo41sczo9STlmtd
         UKHDnY+tafrAEIpyhnFjttObXI2+ryWuwfVVfYQgcz8JT1v//9qcnt62bW87LYtI15u1
         +KimLqtNrClzQ0JezqoCjTNPXS5Zog2RPhJP6ZRwmtlaIXyQLCSxUeU2D1oKOOq7N+ul
         xYsNu8ncNpY6kAuPQ2xnEQO8g9Rlc6iG/iUGEpJ4OzFp8RDc3OM8JwqrsUoL1XXXNKp7
         VOeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794489527; x=1795094327;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FYKf+BSxd2cb15fIXmB9GOlvMtwvtc8EHKSqZ6YcNI0=;
        b=kSCT3mmhooHjYCd1DHKMCLDUkypUZDI1M+6nIavbbFwUu9bx4BStHs4gqMJ0CjXCqW
         iMembEi0Q0GmcD3UqqheJiBdhxu0mKQMCSEH02njp5BkY0/EUJ86J/HE7rs24/79dINC
         aUF2bKhr6hTagGFzj9aQNaiaUeOWF47w9vTNKh+gMjfaOuvM0t5RTVYrl4+in1u6r1E5
         dGMKjTXspUGztsTPSdpTU2kqxh0nYdQsgIFsgnb3IS2WqjtRZETWY250OA9vLdRJ9QCG
         pvpvaPUsOdhOZS88QQ1bnmC1IsMoaoayBtLL7vkeIL1YT1pOvF+TgH7yxLr9jxpKvTOo
         cGDg==
X-Forwarded-Encrypted: i=1; AL+hErGY4CFTBT78GI28KBVsqmhRVnpFwhw6NBbaSswE2g6h56+AjbV0q/0Ebt55jv3efBsonP2biLfUcnKn@vger.kernel.org
X-Gm-Message-State: APuU4Z9X+4/L9KX92TIbdzdhPWsNrw3B1hUywf+qZb3imeKMvEifCMeW
	qNYl749LQnzzEzn2Leo4PHdQ2+Z2pnO98IOBN5RN584T5iI2VWr+tLLmvmwpn0LApYTJ72tUPz5
	EXLMvLmlnPFnnb9FAwXDYaZo4lk9RXI8SsYpEtlBZ3bkSAcv66FdshXAZ6m2Yx+rW
X-Gm-Gg: AYBFou2R11B8MvhBh10UFn/StDTW3BwYjFHZrhQ2zqWV6SJFQqQLHNIyUMZnQpjddmC
	LAXeNfJNvqK9ZXBiu+fMD7vl/HquIkqEk5sfez3pHciCJgApSlTSwDbrxon4JN4GZpYT1ck8RXU
	GX4FiaJQV8HwC0N/hrV2v5+Exmi7j3dmMh0KZRaKBSjqeghC87CIgmWvAJ0JLTyS6Lci7cb6WKl
	B8aRb6bf5UCNGuSrWdpdHZaUPMOnRzc7IGtbD2FHDwxBPfRurcEWwpFGU1OW6Bol13wIBUpmZNJ
	2k54rX7ZUsYImmfPXeFJJh/AJx0ilCRA3oI8xMdGbHlleC9TpEvZo2EYLZ5ZSmq2X6gknqRD5yR
	ELNxKNMKVo7YTgO3fExDKfGNsYIm8EtLjA1lprrZJTFcIlghAWqEjonuriKO9xOScPnahB+ct/E
	URI3/Yd6Q=
X-Received: by 2002:a05:7300:ce01:b0:36a:1452:8dad with SMTP id 5a478bee46e88-3768636e3c6mr6130136eec.20.1794489526689;
        Thu, 12 Nov 2026 05:18:46 -0800 (PST)
X-Received: by 2002:a05:7300:ce01:b0:36a:1452:8dad with SMTP id 5a478bee46e88-3768636e3c6mr6130104eec.20.1794489526047;
        Thu, 12 Nov 2026 05:18:46 -0800 (PST)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-375212e7d24sm43798356eec.22.2026.11.12.05.18.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 05:18:45 -0800 (PST)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Date: Thu, 12 Nov 2026 18:48:18 +0530
Subject: [PATCH v2 2/2] ufs: ufs-qcom: Enable ICE before enabling crypto
 support
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261112-qcom_ice_pm_enable-v2-2-177e454d6f22@oss.qualcomm.com>
References: <20261112-qcom_ice_pm_enable-v2-0-177e454d6f22@oss.qualcomm.com>
In-Reply-To: <20261112-qcom_ice_pm_enable-v2-0-177e454d6f22@oss.qualcomm.com>
To: Adrian Hunter <adrian.hunter@intel.com>, Ulf Hansson <ulfh@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <mkp@kernel.org>,
        Eric Biggers <ebiggers@google.com>
Cc: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>, linux-mmc@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, stable@vger.kernel.org
X-Mailer: b4 0.15.2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDA1MiBTYWx0ZWRfX4ltmptCOU1Az
 0sLvkGT5Mtp+G8tddmkGwrRqINRF5/zfni4p8zmMUWouYvFRqjAD+sTwuNwEkoz3m97aEQwDHVs
 ygUW7soLMDdCR3ekWO/hstmJNeI7HOPmYdlZGpITHRxiWpZe/XcBZ+rZGuVZXkC1fUg4kXkwPXK
 fO/mvGa5MksMVfIzI/C1pqaTJEsmH4xCR2zejUrLRx+FIhTTFgMPU0Wipq7hEAgSp9gME+kyIO9
 3pAQqvpXbr+KwyKaqwTOepF5vVnYU2g+v/TsJ5c+XTIibU4RpLn0J8W7JidR8KJ7BBXgbtm6Mfq
 /g21nJw4qJXOiadTCoONEXsCtN8EwveyyxP1Lv+cNEOkLsz4H+fVam6m15xqdHV4F1tZzI/aKDQ
 Zj+IYUiLpWKB8H916OANmgMOGXsMWFjSY47njxfgeiZsY6nemCb01+NulO16oW/wsOKYmjDxbXJ
 GYSnwgJMyje11HOvSJQ==
X-Authority-Analysis: v=2.4 cv=AsF7T+9P c=1 sm=1 tr=0 ts=6af5bcb7 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=lF1qQ_KX37YNnQO-sMYA:9 a=QEXdDO2ut3YA:10
 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDA1MiBTYWx0ZWRfX2JKYDYb7yNTE
 hbPM22qJ6qXXvXX0bHGYcP/XRbE+tOXRXAweO1qf/TGdvr4tOR9c7baO9CtRNHG0kf8WnP9VI5v
 xFFh69NpbN4xwC0pmVDf3PAnVr5/QwI=
X-Proofpoint-GUID: ZLhg2oUhPyWQGKNa46ibxr7ZH4_7WWvs
X-Proofpoint-ORIG-GUID: ZLhg2oUhPyWQGKNa46ibxr7ZH4_7WWvs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-12_01,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 phishscore=0 impostorscore=0 bulkscore=0
 adultscore=0 lowpriorityscore=0 spamscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611120052

ufs-qcom currently exposes UFS crypto profile and sets UFSHCD_CAP_CRYPTO
before enabling ICE. This leaves a window where blk-crypto can issue
keyslot programming calls before ufs-qcom has explicitly enabled ICE.

Similar to MMC, enable ICE during ufs crypto init path to ensure ICE is
ready before blk-crypto can issue key programming calls.

Also call qcom_ice_enable() from HCE PRE_CHANGE path once crypto support
has been enabled. UFS controller reset can reset ICE state, and the UFS
core can reprogram keys during HCE start before POST_CHANGE.
Re-enabling ICE in PRE_CHANGE makes ICE ready before reset-time key
reprogramming and for any later ICE operation.

Fixes: 56541c7c4468 ("scsi: ufs: ufs-qcom: Switch to the new ICE API")
Cc: stable@vger.kernel.org
Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
---
 drivers/ufs/host/ufs-qcom.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 6afb8498b8c2..4ec400c5281b 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -158,13 +158,15 @@ static void ufs_qcom_config_ice_allocator(struct ufs_qcom_host *host)
 	ufshcd_writel(hba, config, REG_UFS_MEM_ICE_NUM_CORE);
 }
 
-static inline void ufs_qcom_ice_enable(struct ufs_qcom_host *host)
+static const struct blk_crypto_ll_ops ufs_qcom_crypto_ops; /* forward decl */
+
+static inline int ufs_qcom_ice_enable(struct ufs_qcom_host *host)
 {
 	if (host->hba->caps & UFSHCD_CAP_CRYPTO)
-		qcom_ice_enable(host->ice);
-}
+		return qcom_ice_enable(host->ice);
 
-static const struct blk_crypto_ll_ops ufs_qcom_crypto_ops; /* forward decl */
+	return 0;
+}
 
 static int ufs_qcom_ice_init(struct ufs_qcom_host *host)
 {
@@ -188,6 +190,12 @@ static int ufs_qcom_ice_init(struct ufs_qcom_host *host)
 
 	host->ice = ice;
 
+	err = qcom_ice_enable(host->ice);
+	if (err) {
+		dev_err(dev, "Failed to enable ICE: %d\n", err);
+		return err;
+	}
+
 	/* Initialize the blk_crypto_profile */
 
 	caps.reg_val = cpu_to_le32(ufshcd_readl(hba, REG_UFS_CCAP));
@@ -318,11 +326,12 @@ static const struct blk_crypto_ll_ops ufs_qcom_crypto_ops = {
 
 #else
 
-static inline void ufs_qcom_ice_enable(struct ufs_qcom_host *host)
+static int ufs_qcom_ice_init(struct ufs_qcom_host *host)
 {
+	return 0;
 }
 
-static int ufs_qcom_ice_init(struct ufs_qcom_host *host)
+static inline int ufs_qcom_ice_enable(struct ufs_qcom_host *host)
 {
 	return 0;
 }
@@ -636,12 +645,15 @@ static int ufs_qcom_hce_enable_notify(struct ufs_hba *hba,
 		 * is initialized.
 		 */
 		err = ufs_qcom_enable_lane_clks(host);
+		if (err)
+			return err;
+
+		err = ufs_qcom_ice_enable(host);
 		break;
 	case POST_CHANGE:
 		/* check if UFS PHY moved from DISABLED to HIBERN8 */
 		err = ufs_qcom_check_hibern8(hba);
 		ufs_qcom_enable_hw_clk_gating(hba);
-		ufs_qcom_ice_enable(host);
 		ufs_qcom_config_ice_allocator(host);
 		break;
 	default:
@@ -660,10 +672,9 @@ static int ufs_qcom_fw_managed_hce_enable_notify(struct ufs_hba *hba,
 	switch (status) {
 	case PRE_CHANGE:
 		ufs_qcom_select_unipro_mode(host);
-		break;
+		return ufs_qcom_ice_enable(host);
 	case POST_CHANGE:
 		ufs_qcom_enable_hw_clk_gating(hba);
-		ufs_qcom_ice_enable(host);
 		break;
 	default:
 		dev_err(hba->dev, "Invalid status %d\n", status);

-- 
2.34.1

