Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B3E3446A6
	for <linux-scsi@vger.kernel.org>; Fri, 21 Nov 2025 10:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763721399; cv=none; b=CBAsu/uYV1w/n23ogmwOojaA3qH880SlzLR8h5pz+qM8cetsDRvvScyp39fwyvd1P4PrjN5zU/8mLk3YlGQkAk5YZBwy/ACElQXsjlDaTlaQ5PVRs03shD4mWHyMpBw/x8RDQswsP8oz9OPQnIzT0pjwDZpsldoTRvFWfnjdPAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763721399; c=relaxed/simple;
	bh=Sz1vlOSV0D+xZIKhfYfVDh8pgF70ZFS+nkZyzuLd+Nw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=p/z4RUTrk+gZUK0o47vpfbJRkq9cFr7wojtX8zNJsiB3bNY0MGPyR97mQwfaxRr6Ic1lj+PVvhqSWbryUIt0g8Mk2Sv4faxCRJHYqPINR6I63OzWIVYcwAEuGo0v13Ik1Sdk6fWI8Hy2Z0kakCOkb18mrvq/wCGo60O2H2cre+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=mG01GSaO; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=bl3L/+MJ; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="mG01GSaO";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="bl3L/+MJ"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AL6ffkH1989368
	for <linux-scsi@vger.kernel.org>; Fri, 21 Nov 2025 10:36:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	4LUtc/dFuaKo7IYHuZGMVu8mLcTAVi9XHB3HqrpmlT0=; b=mG01GSaOAMm65hDM
	KYNUT4JZqaZ5aaG9uNqsTX//2J7lIblVeDNPr3f9HBlLU8aUcGSBbRIySAZEBO9x
	QTIokWi1lHP8/Ft5t1N1bwnLM2xMuWhOCh2MBXgk2hCe8zQsMfB3YCiyPe0rXK7y
	AzMDG0ZSB5jFfGyuAwV5jvrh5uA1tGMbOdPkNlnT1G+yt+ZfmGKjyFG5peINhQJ+
	tLeoCU49B+YoW0dIngMECcKmmsf5avqSNJzpA6FSFhVDxiM+WwcQrL8si46XJWo1
	K8wjII0HFidLdiOD/Wl8MS3BwfDzi1RSv9H4wtcKD/fbowPRA52L7GBocszkhXCN
	DaNvng==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4aj1vac3hb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 21 Nov 2025 10:36:36 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-343e262230eso2394101a91.2
        for <linux-scsi@vger.kernel.org>; Fri, 21 Nov 2025 02:36:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1763721395; x=1764326195; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4LUtc/dFuaKo7IYHuZGMVu8mLcTAVi9XHB3HqrpmlT0=;
        b=bl3L/+MJZ/UMzM7dhNX77WlG4nHGOjEoqR8p71Kiv6ZRIcrKlZcbcfx0lF5cDab4xD
         IXKuqwDCSEplUPYP5XtXMVY4ApNXXrEoki34LgbAKEDh9K9BONxQ3o1Le/KRkJ3/ytH6
         ytyN0wy5rgU/YYtzAdijiyZXQRJuZb2rHoVdyZiZrLiwZNbVOktaeTB3ni4C+WFDyNDj
         7DGX61DbvCZHPdmoPb+sPLQseLvKs2qQLBdz2be3jPcGhu7DekqIrOd5inrkyi74HEcC
         b35yLFIY8d9xVHwae+UoeZAQM88Ej7ZjZd2VJiUvehCPt3fMZeG4VRkli/T8pl240vb2
         VSDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763721395; x=1764326195;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4LUtc/dFuaKo7IYHuZGMVu8mLcTAVi9XHB3HqrpmlT0=;
        b=w7B568n6aVabBRIa4c1iPgBxMvLeT8YQ+pMy8nJOR0lKV+C0Pv2oes8w85htGDBmo+
         RM3g2NRQmR9S+0h6sZI/N7ZpB9F1LXCDhST6ho2XLHIEFAcQcaksRntQxoMj6QrPUzqL
         Ig1eb7nj7kM0Q34VGNrfRNGQoJTc5p8FumXIkvovPe3nynkz/4PdvwTW7J310HpIoQgG
         vM0Sb0Tif1IzXY01GJI+6w8ZX/1+pro8LOCcUFUp37LV1oBhBK9P46CXEBQmEcm6fe0D
         d6LDAJirGB8BEJjXqj+poZfOUxZSceCIZxaW4Dfe2Jnz+PgW0L6lWTm2Epz3f/rC1AeC
         v4TQ==
X-Forwarded-Encrypted: i=1; AJvYcCWNxEHb9kZ+GvugR5l3EIKPiBoNODvz4RJs5//Qqeaw+41iOcUSKu8OEtXAbnzPr6NveMLcVO9donIw@vger.kernel.org
X-Gm-Message-State: AOJu0YzIIyn84cxOkLPLcDMKSoGo3LsUj2KldOmS+L/LN+vi1vuqOsTH
	G1yjGI6mUdhVAaHt/PU9Ot55rLAyZ1wELOOFthx/8svcJKZMEAv8+LxvWPEDBk3VAoUO9TDhAdY
	Odllj4WS+rwDu+0v+X6di5WJ0qSQ/3Cr+DmRfWMyH2D9sWpf6R9QwfuMf955fcpNKAxKC1c2P
X-Gm-Gg: ASbGncvJ8SdNMq61gMLsRPp3hsiCvRhGd/WZFXu91VYxudvWDU+9yqJHIMVO2tKqn5k
	c3JzF36SdJQmeSyIynx+2gkHDXX2OKSV0szMpYmF1QwcJcmF0M261ntZXya7bfml2braX28kbwD
	3NrfQAGKVNSQUfbvSrWLAlJwO11BDQkbcJF4rZFLE0pCKFbpYlzzne3UKNwnrOBs/iZPuOCbi6+
	KTYf+rXNed1SxAetV8spGofPUQ/miUg3kvsfLslZq2683RhZ2KDOaeFOKNABrdERB4Iac1sytqu
	k5qsLFb6hv7SPDP0KAnFfok6dDpqwgAZCvJL2OZ3NWpwAGp40Y7+lbwmpFl0LfWng8wfGPc/34D
	vIePsLopgMSiCJ/GbtwngeVei8bsDO/ZL9jI7Iayg+vKd0f4=
X-Received: by 2002:a17:90b:5291:b0:343:7714:4ca6 with SMTP id 98e67ed59e1d1-34733f006a9mr2006820a91.22.1763721395449;
        Fri, 21 Nov 2025 02:36:35 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFyRidwSlFOnbJRIIYJwVdp1bjncHdnam+AEc2s9XEeF7HVt0aV3t296lfLC+14ccvC8iEszg==
X-Received: by 2002:a17:90b:5291:b0:343:7714:4ca6 with SMTP id 98e67ed59e1d1-34733f006a9mr2006786a91.22.1763721394994;
        Fri, 21 Nov 2025 02:36:34 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34727be2fa7sm5122890a91.6.2025.11.21.02.36.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 02:36:34 -0800 (PST)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Fri, 21 Nov 2025 16:06:06 +0530
Subject: [PATCH v2 3/3] soc: qcom: ice: Set ICE clk to TURBO on probe
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251121-enable-ufs-ice-clock-scaling-v2-3-66cb72998041@oss.qualcomm.com>
References: <20251121-enable-ufs-ice-clock-scaling-v2-0-66cb72998041@oss.qualcomm.com>
In-Reply-To: <20251121-enable-ufs-ice-clock-scaling-v2-0-66cb72998041@oss.qualcomm.com>
To: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIxMDA4MSBTYWx0ZWRfXxvXp2a+zc8vD
 Hxfj8aKDbEM1bu690TeTK8V00b385PyxmVp7vwC+V1TN5mh3f80BSUIyY1wuenpbL6z3xWBaIKI
 lhhBALV1j4DLA49rrNlQOcALAh0TwNNqVHePe9VEJmu/27C0VZXxp02GckarHYm7PRUx+wDbyxt
 aPWXLkRxVHBmHdDEdTRopQUrL84WEUFkpU1E6PBynPIbhsiZ+2kOgeXHR9mJnHl/JE7XlW4lIOB
 oWzawmhnRdIN9ps4RxUpclnORsnJmVIK2BpXTSxX9OuWUhHe6te2GwomKzPELC8z1ttcsOXOp2N
 /5OjEJ7fABCcKr/PqjN9Dp0xNM+h9DTliWhRCwfKzAlmDp1MmYDwQ9H8+KcoSILDu2+zARitt8L
 soH5rDR3bla9+NJrIXBW92hcEvPERg==
X-Authority-Analysis: v=2.4 cv=Vpwuwu2n c=1 sm=1 tr=0 ts=692040b4 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=u1bwIIJuvd_SIhYoViIA:9
 a=QEXdDO2ut3YA:10 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-ORIG-GUID: 7Kv9AnBalmc7WcqPwoaajwhU0-zQvKY4
X-Proofpoint-GUID: 7Kv9AnBalmc7WcqPwoaajwhU0-zQvKY4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-21_03,2025-11-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2511210081

MMC controller lacks a clock scaling mechanism, unlike the UFS
controller. By default, the MMC controller is set to TURBO mode
during probe, but the ICE clock remains at XO frequency,
leading to read/write performance degradation on eMMC.

To address this, set the ICE clock to TURBO during probe to
align it with the controller clock. This ensures consistent
performance and avoids mismatches between the controller
and ICE clock frequencies.

For platforms where ICE is represented as a separate device,
use the OPP framework to vote for TURBO mode, maintaining
proper voltage and power domain constraints. For legacy
targets where ICE is integrated with the storage controller,
fall back to using standard clock APIs to set the frequency.

Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 drivers/soc/qcom/ice.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
index c352446707ab5e90e6baf159c86a0914ff4bfc53..fd1ae680c64370ae6cc8f999fbab20e4e875be03 100644
--- a/drivers/soc/qcom/ice.c
+++ b/drivers/soc/qcom/ice.c
@@ -616,6 +616,11 @@ static struct qcom_ice *qcom_ice_create(struct device *dev,
 		if (clk_index < 0)
 			return ERR_PTR(clk_index);
 
+		/* Vote for maximum clock rate for maximum performance */
+		err = clk_set_rate(engine->core_clk, INT_MAX);
+		if (err)
+			dev_warn(dev, "Failed boosting the ICE clk to TURBO\n");
+
 		break;
 	}
 
@@ -636,6 +641,11 @@ static struct qcom_ice *qcom_ice_create(struct device *dev,
 		}
 		engine->has_opp = (err == 0);
 
+		/* Vote for maximum clock rate for maximum performance */
+		err = dev_pm_opp_set_rate(dev, INT_MAX);
+		if (err)
+			dev_warn(dev, "Failed boosting the ICE clk to TURBO\n");
+
 		/* Since, there is only one clock
 		 * index can be set as 0
 		 */

-- 
2.34.1

