Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7389D48EBF6
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 16:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787846918; cv=none; b=q4pah0253Dkuwbn+IAKDSfJcZd80RRMeyHIlFWPgimZycdRB2gB+ahGo3vxoRNjfTnMax6cuaXbzXmaXJE8orapru5VcApS08v+npj0WY1xzcsHULBk8LUuPxxtlaHenpVajr7fksj5NfFqMdxh8N2ED4wfxC1e6o52YWGQ/eqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787846918; c=relaxed/simple;
	bh=64JBdKFV0k5ypJWDkUZi9BoAaRy3vj5flkXzPsq15+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R+oPUWsQc4pP82bqp//ICg/6oPwIsZkYgVIUQIxLSb1gtz9QI6exSOEQuaPq8XiuDMoRgBvGHhtXA+0Bto+nHJHaU7D1loSGsgxSWeojPHaOm2i35PtbL7AovoO99TxcR496MRWeOuiSlf5q1YWvNH032DH2jCEyZJxn6H+2K7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=pPF1CI7o; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=JYWDEmWH; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="pPF1CI7o";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="JYWDEmWH"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67RFbnkk866304
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 16:08:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=LltqfmvyZbe
	c4Bgt7eBZwrXubHQDa7pvwd5LerJQc3I=; b=pPF1CI7opY3gmcOEv1Jilno3v2i
	VEBF+as3yqfzBh2zg2eYzZiFmFnDo+X6GsLvOvU9SiT4WmrOfQn5cd5TmzH/Coad
	26DWBpSBcoxynbm9jm2Z/6zxi16RlVDGJkDYtLkCqKJkef2JOLzhoE8jvzBmCxX+
	yxe/HWSTuXXi0lIK8SXphg2qG4dGFy1XZFUoDhLHpVFklJbwQuUrGSVHC7uwxYIz
	mSKLBkCac+xDJ7N12ZlLJUt58yo7UZ28bF58nk5Jfit+2BHfwFaiMuEGZPNK931j
	zNMO0o/W/+OZ4keC04GduHPzR580l37NTVf/9210ndWufByfzcqn+ES0lDw==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gapgv8m83-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 16:08:35 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38ec0f510a9so141414a91.2
        for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 09:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787846915; x=1788451715; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LltqfmvyZbec4Bgt7eBZwrXubHQDa7pvwd5LerJQc3I=;
        b=JYWDEmWHlRL+Qb1Rcs+Av2z4Em6v1OOBCQm1HmzDhlrUlH5bIem6+U5WrYRWpSgy83
         kinxNXz6o5vvMB4nhRjVrMcXXol14A3iywXqi/cE3cISBm1vCKZ5rOcPx0UcbvgchXvS
         REMvo2BwieN1CFBxO2x3Uq1tUxKm3eUfkHc47d8hXd3Jf/gqA15Z3Gqob0kPrf2lXFLO
         s9IPut1gD74U4Xjcr8S50H4haSUYTJTw+fjvHmJXIVtcxL+4t0fol8YAY2+BvskWvIv5
         Jx+eyx0B0el7YuyUpgiDvIX0w0/hyRsdO3gUfLdEgOF9C0a5qbTHTDajsfjxy4ZcTE62
         OQ0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787846915; x=1788451715;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LltqfmvyZbec4Bgt7eBZwrXubHQDa7pvwd5LerJQc3I=;
        b=MIP/mtg3NK6p56hB0PyrO8O8RUHzohzYoL4F1GL3W15oMbot+FoO7hcvHJc0MfiDvs
         vBJbu4hZ96oFFEjEQ0b4OEcVN8QVXUixPtO0zCcP18IkSwBT5X918vkdP3qyQEI1gaOz
         faiGvgJVszqEEp5EjRY/Q5Ho++2pzc980dlCZJzRYZw0+cLPO4FBnakLVnvX671KTTy/
         oXd7IbLLPiZ8b55bFTc5it0LglUDkumunxlhBKQkfGtf4cxLlU8ZZwrhazGC3HUBiHvC
         5/bvyF71aMk2Up79ZrV4Opq4vxWpa+YDHAvN5lLg2HJHrLuIp3hvzqxy8d46XJSsJuJV
         BKKA==
X-Forwarded-Encrypted: i=1; AHgh+RoUImZbJAa5FDG4PSFix3yYFhr8revQh8V4gQ4zqtjWt3lx6nBTbxPCEVb1H5OMNo7Ux8QA5t2MTurB@vger.kernel.org
X-Gm-Message-State: AFuF++lkEZbtCa1O72Hq4/0BCyRm49HOZU9EduGhK4DQ66ZDq9pMRU4e
	DnFrnkVQ2fGZ/Algd5VcbjO8J87U9l57U+zbWvc9yIMoCZnvxI+ChdfmX+GJVeEOKiLe5K+YUa8
	UV2PTiylDKgMKKpEf47VLfk6PyQRP4EmJ8B76PJkqXZBbE6TuINGCP3/V9HXd5Emq
X-Gm-Gg: AR+sD13GX1gUDNyvjaGUa75wOHtGr2lgpPDbNUqJFP2qtpXQY10OKM1lsgyZANruQW8
	k9Oz/TRR7LLp9plK9fAlp/1R7kT/liCLLSHfsshUZq5I60NbEyxdv311AMOFtwR4lrkotiMX3RU
	0+MUWSpyptVvNoNsUJBhsux6UHS2lql9hx8l48jL5jztm2ZajGCG3fBBH4YUV0b3EufwpNvOOvd
	qdxboHmul+qGYWuYUw/OycSRMcMTNFIhvtaOPP9DxVHB7jPW90gxOPF2UPafEAFnnqnkeln4NgL
	B+Hj16wOU4+27jR9oGxH3fdEJA5rRozJDqCHfpXDfy5gPlO+9721PUU3neWv3TFdJ0J2DZf/+DX
	TwOcpkt3v62WzKA1YbQDSDY+1zP/7Jp5nyOp+tmOFBrIxc/jIv92vKEkDbDo=
X-Received: by 2002:a17:90b:4fcc:b0:38d:ef48:b04 with SMTP id 98e67ed59e1d1-396d0f8fbfemr510657a91.10.1787846914843;
        Thu, 27 Aug 2026 09:08:34 -0700 (PDT)
X-Received: by 2002:a17:90b:4fcc:b0:38d:ef48:b04 with SMTP id 98e67ed59e1d1-396d0f8fbfemr510461a91.10.1787846914243;
        Thu, 27 Aug 2026 09:08:34 -0700 (PDT)
Received: from u24-san1p10108.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396b0fd9085sm3245892a91.12.2026.08.27.09.08.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 09:08:33 -0700 (PDT)
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
To: ebiggers@kernel.org, axboe@kernel.dk, mst@redhat.com, jasowangio@gmail.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org,
        linux-block@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-scsi@vger.kernel.org, virtualization@lists.linux.dev,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc: neeraj.soni@oss.qualcomm.com, gaurav.kashyap@oss.qualcomm.com,
        mani@kernel.org, andersson@kernel.org, konradybcio@kernel.org,
        bvanassche@acm.org, alim.akhtar@samsung.com, avri.altman@sandisk.com,
        stefanha@redhat.com, pbonzini@redhat.com, eperezma@redhat.com,
        xuanzhuo@linux.alibaba.com, linux-kernel@vger.kernel.org
Subject: [PATCH v1 06/11] scsi: ufs: core: add slot path to ufshcd_prepare_lrbp_crypto
Date: Thu, 27 Aug 2026 09:07:15 -0700
Message-ID: <20260827160806.1295313-7-linlin.zhang@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260827160806.1295313-1-linlin.zhang@oss.qualcomm.com>
References: <20260827160806.1295313-1-linlin.zhang@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: SiWK3zEnRF7rGNWhE_6baQxXCUaadq4a
X-Proofpoint-GUID: SiWK3zEnRF7rGNWhE_6baQxXCUaadq4a
X-Authority-Analysis: v=2.4 cv=FpU1OWrq c=1 sm=1 tr=0 ts=6a906103 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22 a=EUspDBNiAAAA:8
 a=UfCYJ6Unc3kZa_kcAOwA:9 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI3MDEzNiBTYWx0ZWRfX2+/VDCEBMQmH
 OylhrC5UwuRRZuTgnvqYS2KdfEAnYhFWJq+3P2wyUl7sJzJeoww3LSkuAPl8igFe4p7mAzPxV7k
 XuwKN+l33mfM0YRQBxbRV5u6jyWQahFRItZIVFuiB+km7fwI1IxMTnNtqJRQoEtePUCvRKl01bi
 cFqHn9+cjXzPZzSwHSMdEKcdOG6lhWgoCHHz+0+j29ziMcUt8va4jLUGZbDhhkQTY+EkmMliajI
 3wqObs6E41fV0rni/8uoIjv2w5i77WPdoGNBs+1aWADsGJ1yO1dCACyOCNLjLw15JaY+DgJ48Rj
 DIU/htelqRDPVD26w/D+ChRONTcb0BkNqWkoifg8ANK7nCMUye7GUhGcuffPC2T1QukqD4DVjnP
 dl0x/Pk8WTBag+hbI4CyYRRixFvjFUugzBFPUL65sVC4WNqT8OAi9cGzyxGdTlSIEseELr21gfz
 CliEv1MZcbfhP9R5hvA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI3MDEzNiBTYWx0ZWRfX3WOwayn3A6mU
 Y0M5YaqEPkdb1GPuKGETdO9JbAy/SgmT29+75Z2Ftmkwbk0RIAwrTFcu97ibkTXhtUozWuRCWlP
 1dPKIoITgOy2uXEfOoJ7cStof4E2sSc=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-27_07,2026-08-27_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 adultscore=0 suspectscore=0 impostorscore=0 phishscore=0
 spamscore=0 bulkscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608270136

From: linlzhan <linlin.zhang@oss.qualcomm.com>

ufshcd_prepare_lrbp_crypto() programs crypto_key_slot in the LRB from
rq->crypt_keyslot.  With the blk-crypto slot path a bio can carry a
pre-programmed physical ICE keyslot index in crypt_ctx->bc_slot rather
than a blk_crypto_key pointer.  In that case rq->crypt_keyslot is NULL
and the existing code incorrectly falls through to the "no encryption"
path, leaving crypto_key_slot as -1.

Extend the function to handle both cases: when rq->crypt_keyslot is
set, derive the slot index via blk_crypto_keyslot_index() as before;
when bc_slot.data_unit_size_bits is non-zero, read crypto_key_slot
directly from bc_slot.phy_slot.

Signed-off-by: linlzhan <linlin.zhang@oss.qualcomm.com>
---
 drivers/ufs/core/ufshcd-crypto.h | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd-crypto.h b/drivers/ufs/core/ufshcd-crypto.h
index 8f66db94e179..2fc5601c0f76 100644
--- a/drivers/ufs/core/ufshcd-crypto.h
+++ b/drivers/ufs/core/ufshcd-crypto.h
@@ -15,13 +15,21 @@
 static inline void ufshcd_prepare_lrbp_crypto(struct request *rq,
 					      struct ufshcd_lrb *lrbp)
 {
-	if (!rq || !rq->crypt_keyslot) {
+	if (!rq) {
 		lrbp->crypto_key_slot = -1;
 		return;
 	}
 
-	lrbp->crypto_key_slot = blk_crypto_keyslot_index(rq->crypt_keyslot);
-	lrbp->data_unit_num = rq->crypt_ctx->bc_dun[0];
+	if (rq->crypt_keyslot) {
+		lrbp->crypto_key_slot = blk_crypto_keyslot_index(rq->crypt_keyslot);
+		lrbp->data_unit_num = rq->crypt_ctx->bc_dun[0];
+	} else if (rq->crypt_ctx && rq->crypt_ctx->bc_slot.data_unit_size_bits) {
+		lrbp->crypto_key_slot = rq->crypt_ctx->bc_slot.phy_slot;
+		lrbp->data_unit_num = rq->crypt_ctx->bc_dun[0];
+	} else {
+		lrbp->crypto_key_slot = -1;
+	}
+
 }
 
 static inline void
-- 
2.34.1

