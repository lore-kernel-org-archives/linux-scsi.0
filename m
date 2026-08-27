Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 328FA48A2D8
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 16:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787846922; cv=none; b=YRv7WS0Nxj0/H+9GWgBTf541YGt4d/PP1Uk3khjVUXgU02YKNgRy0e1th89EjOH2EZ38J33bo27KJH18TQW33OMBUwfwsi28G/Tit0cPmR2mbYnUqjXaxGezy6YxTGqh461kdl0Bw8LTefi22HAx5ux0Gu0HVSkpnv7tUPAmUyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787846922; c=relaxed/simple;
	bh=XzVRSJskkXzsRQMCF0q2XHzItKnQaDkIqK2bV/uMi6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RZWrG0bz3UJ1YE4vnViCkHmvP2YotcVGO8pbW6ocbRXAhX+aqeb802v7pMCv15Q0Oaw7XlNEZic+wbIE08UjXiYGasu1jZhGaazHTKUXaTVGQQAFbP/yyelXZ+oT74OpcKXrXTESSLtI2WbLlCsD0diixcQYd21zAQg+XDOh+j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=oFwTjd6O; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=BCfu1miM; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="oFwTjd6O";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="BCfu1miM"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67RFbo0u297004
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 16:08:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=GQuf/V68eCT
	XXH2b/XlQO3XYqlyP/kTHk7utlZNkRig=; b=oFwTjd6O46+rn3wQuhLnjLfejRI
	JzlkxQSt3yFeu41vHuEDRwREWQb/MqlkNuVm1K7rXRrb1LnCdn7kasEpR73XcA4I
	0RUsK5WYrYHBR+ekT3kOuxUJTj9DvpOV7EJQJZ7kZTPydi9vTE5SM5FJFJaM4swO
	6cx951RiLv1XwxTtlcUdL7qyWC83c9a0lrDN9Ro7St3H1fkKn1PDPGNdgkyYf+n4
	0I05RdmD/c3T6KmB5Jo2tG6ZNq9g0uOiMJHwGomEX1zaxpZNwDz3WJFIzCPUKQC5
	VUHQzo0KHoD6lNydXTaSoa7h/p4k7EROq3txUc2+bYHsHO/xDvwP/N2vM7Q==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gam6fh458-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 16:08:38 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-388b404eaa4so142852a91.0
        for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 09:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787846918; x=1788451718; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GQuf/V68eCTXXH2b/XlQO3XYqlyP/kTHk7utlZNkRig=;
        b=BCfu1miMC5zWMyNdNUtAtQMyE5suGsZEdFJuLAgWI5rnFdL2ISus8xFh7rhdMUvq4F
         TsuB8wvnK070wWrup9JILSjFMmNi/+neDxZp1BYQkITBFyEL6Aqag48NrDXLbfTHaAoz
         kzMEOR8qk+I7sdw7KAiFk+H3WLARPWqsv9guN75zNz4JevcRPwNmr5JaGM4ZdzEeXEC3
         riX6YyeX7evE7kkwihuA/Slrtym2mYhCHW7s2xldBNk/rRlv6wDjCiuiX4TdM78Wnnn6
         3rtgruYseHPY0QttEjw/KNjmaud54CCWimWebNtzPWn7lN+fKFmhwBgRTvKwbvyJpRcd
         X4JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787846918; x=1788451718;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GQuf/V68eCTXXH2b/XlQO3XYqlyP/kTHk7utlZNkRig=;
        b=DhTXLXCDD4QDWzdVNUgVnQfN33tVx2wt6yaWLkHzpgpHVkT6Mwku6eBap3ogXclhQA
         jiOMGnFp84LMxHnr6EPrZyOOfdPgJgn8v6XwGNmvJNphTkVh+o7Z9z/YuhDtdwQem4uc
         lzARC44mlYGAtecPzf4SrWGX6S+PZUzSDmWAA4C+KBIRHloGgUABUEtbqrcFTN+X3Yz/
         R3NXNuEZyY3ArXCjiUyeaBeqhOBXtvqtvup9mq2gfP2JtX25PwMTs42STW1D7U7aRSQN
         17akO+UkT1GkairbR7WZLbzm8+0Fp6Hkp8cReK9EW3ftIteMcPDQ5B/PzPbauw5n0S5/
         kaxQ==
X-Forwarded-Encrypted: i=1; AHgh+RoRV9c48ZSL5JivXoQwS0L/PgSepYUSdacURR1KAB4+DA4i7TBXXvBUiIZ6XYPIIr+rfNLdVhhUZ8rO@vger.kernel.org
X-Gm-Message-State: AFuF++lTveuADRY0JshXshP/5FNE6MTIFY6dVUle2SxobCyzKZscyIrF
	W0SZuq6PZ0Jn62Z5j0c1wAw4uG7cX/olTELP1lYkgbdJdr+LhnYMSZ+55/4GAQYZg0QfSsnkQb0
	yF8yq+3j3lU7uIHpWOoYRA3f7n5MQpQvFFHu56I8X4js/HBPszPzzXMEaxFNhSkFk
X-Gm-Gg: AR+sD12ao8I6fhBdq49/yRFf1Nhj5XHH7vTD2kyXjMs46duro1hjjlIojubIOVRxdyF
	Yjq8GmgDaggh+blIRPdLXTTG0iGvO0TRfLVCREi7zSUiHNOwHu3Sne6ZIhu4VqjNaPoknxQpilC
	W/cvNFT+4JK/uYbKW5X7vNpQTsZYDplxI6LW3xNlbiEsU3pbSOM9ZmTNE1I6RXasoQXki6GN45H
	shv/EfEIUr07qeswozOqiXreWTSzOYKF2Y01cWW7ZIqh+RvjPXULkNtiKlBNowJJO/zooxaihNu
	4OgtxC51oKMVvZHLYqMau3PCgr1HXdLNdZngTNMtVmQUdRw2BTBH9xOdRfcge+S8E/Ns6pBBE1V
	vIf1nJBxDpeMeosbhXAxNqEZiv4xH9zCO9MkSpEPeNgXHXF0T2Hq+OBU6qaQ=
X-Received: by 2002:a17:90b:51c7:b0:38f:5801:dc0e with SMTP id 98e67ed59e1d1-396d0f52b2amr503464a91.15.1787846917368;
        Thu, 27 Aug 2026 09:08:37 -0700 (PDT)
X-Received: by 2002:a17:90b:51c7:b0:38f:5801:dc0e with SMTP id 98e67ed59e1d1-396d0f52b2amr503276a91.15.1787846916655;
        Thu, 27 Aug 2026 09:08:36 -0700 (PDT)
Received: from u24-san1p10108.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396b0fd9085sm3245892a91.12.2026.08.27.09.08.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 09:08:36 -0700 (PDT)
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
Subject: [PATCH v1 07/11] blk-crypto: move bio_crypt_dun_increment() to the public header
Date: Thu, 27 Aug 2026 09:07:16 -0700
Message-ID: <20260827160806.1295313-8-linlin.zhang@oss.qualcomm.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI3MDEzNiBTYWx0ZWRfXyW8JIiY0+QeG
 k1r7CL/0uHbZOO1z2Ez3lJpeLbn66HizbqH6dX0y/KNIcrJDoGmQ0AZsMkisozZLwF8q2Bnu+ng
 abo9dQaKUrGqeJoAgEb0ZurornN+JUQ=
X-Proofpoint-GUID: nLh6FBTG5qgiLj6gkCD0mC-GqVDaZqIX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI3MDEzNiBTYWx0ZWRfX9i50sSPrUej9
 uPmB1gxAbpJ3QkF+42/8scGN+wb4w38C32P5MUPpbrI4VGMM1YWecGzmbgzkdj6gpIHBx5y3/9h
 BOBNLywT+//Gdt6QlIHM/q0Q2BmdO6Sijl1gRIGkvldzO49EePBvL2OOVD38qDzYfV2/djOaSf4
 YkAW5cVmf1IdKkpKnzVkNuGRwSa5cUq4dKqC6Vcq2EPHA2jou1zx9klinQOaXav3h4ebqqa7S5M
 eiQWeqZAcJ5gAY3d8CHwkNhbnAp0Vw49PlaDNEOj35D80sSLhrBEyxu4b+H4Bf4IyGQfiUFnR1w
 BY2A9DKZC3ejtp5XeF+PRjf87Hdrj2nmi224cxCFJzs5TmOvkuU7dipDhqmMJANdQ9Wylpzx0wv
 Yl1LSLqdc6EQQBI3utyByHArKRLyE4JhlQY8ofDRZxA4sAinPULDRFxPxMGkAD/sgtdSo314109
 hD55l3vzMjpuYvMucTw==
X-Authority-Analysis: v=2.4 cv=eIgjSnp1 c=1 sm=1 tr=0 ts=6a906106 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=EUspDBNiAAAA:8
 a=Dog9NmGJ06mbJvtOeFoA:9 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-ORIG-GUID: nLh6FBTG5qgiLj6gkCD0mC-GqVDaZqIX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-27_07,2026-08-27_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 clxscore=1011 impostorscore=0 malwarescore=0
 bulkscore=0 phishscore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608270136

From: linlzhan <linlin.zhang@oss.qualcomm.com>

bio_crypt_dun_increment() is currently declared only in
block/blk-crypto-internal.h, which is not accessible to code
outside of block/.  Drivers that manage inline-encrypted I/O
directly need to advance the DUN across bio_vecs within a bio,
or across multiple bios in a request, and have no other way
to call this function.

Move the declaration from block/blk-crypto-internal.h to
include/linux/blk-crypto.h alongside the existing
bio_crypt_dun_is_contiguous() and blk_crypto_init_key()
declarations. The implementation in block/blk-crypto.c is
unchanged.

Signed-off-by: linlzhan <linlin.zhang@oss.qualcomm.com>
---
 block/blk-crypto-internal.h | 3 ---
 include/linux/blk-crypto.h  | 3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/blk-crypto-internal.h b/block/blk-crypto-internal.h
index 04035d237f03..32c720aabba7 100644
--- a/block/blk-crypto-internal.h
+++ b/block/blk-crypto-internal.h
@@ -26,9 +26,6 @@ int blk_crypto_sysfs_register(struct gendisk *disk);
 
 void blk_crypto_sysfs_unregister(struct gendisk *disk);
 
-void bio_crypt_dun_increment(u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE],
-			     unsigned int inc);
-
 bool bio_crypt_rq_ctx_compatible(struct request *rq, struct bio *bio);
 
 bool bio_crypt_ctx_mergeable(struct bio_crypt_ctx *bc1, unsigned int bc1_bytes,
diff --git a/include/linux/blk-crypto.h b/include/linux/blk-crypto.h
index 33ae52b77522..c9f436b6b2ef 100644
--- a/include/linux/blk-crypto.h
+++ b/include/linux/blk-crypto.h
@@ -181,6 +181,9 @@ bool bio_crypt_dun_is_contiguous(const struct bio_crypt_ctx *bc,
 				 unsigned int bytes,
 				 const u64 next_dun[BLK_CRYPTO_DUN_ARRAY_SIZE]);
 
+void bio_crypt_dun_increment(u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE],
+			     unsigned int inc);
+
 int blk_crypto_init_key(struct blk_crypto_key *blk_key,
 			const u8 *key_bytes, size_t key_size,
 			enum blk_crypto_key_type key_type,
-- 
2.34.1

