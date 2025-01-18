Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E6BF507
	for <linux-scsi@vger.kernel.org>; Sat, 18 Jan 2025 02:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737167904; cv=none; b=q9ufFskK0Gt/ZzRio9FUyyX/16aZXpsWeqKTEDjHWXN3/gR8MmVv4eIWX7F954tcNSRNnWP0B2/2WHdHgIyDpKLDeKwPT/vlOhqv4fXPc7XpJ3vY5eGqo9cTCtYz4BWrupCl0mLvw2foLnmzjFGTl73oETWOb3UfLOTnoJqBp5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737167904; c=relaxed/simple;
	bh=7nGIoxNmbWgoriwcuI0TRB2ru/JH/tIaYmzUtuMRcts=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 References; b=QnJURGi2a57Dvs5ifko7TGk3xNjN73w3eeas19AHO77iTDYtE8Mu0Uw+GOYJgu53f6Q4hqaAnGAtxGUO6YAAPj5itHNrOi+1JW54JkK5pSi6Uewb1yPm/z+tKc2Bm0Ssbp2lvGlE0lvUDcS4QZ63Zp9rauLqE5OhPCuZJzqsAJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=X/Fz9EgU; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="X/Fz9EgU"
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250118023819epoutp01ac84f48094f4c916823635fa4cb3570b~bqQAmOrnT3193331933epoutp01x
	for <linux-scsi@vger.kernel.org>; Sat, 18 Jan 2025 02:38:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250118023819epoutp01ac84f48094f4c916823635fa4cb3570b~bqQAmOrnT3193331933epoutp01x
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1737167899;
	bh=vf5MbK1efJ4AJaTGErEjVcVCmnTTRSqk80chmHdypI8=;
	h=From:To:Cc:Subject:Date:References:From;
	b=X/Fz9EgUcztolUMjmvuigm7twrkup87vi8WRku+BZEMqZRVYz9ol2P2VUykPbfzdE
	 nBcA/tn63gPhTjsyVse+I37f1dR++YLUWcn5CAirXC2mk496D0vJdReHpHSwsApJeL
	 s0cx/p1D5iSUqngt4iKQW60nhagc4NeJuTXE0UKo=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas1p3.samsung.com (KnoxPortal) with ESMTP id
	20250118023819epcas1p30882b0e66921e3bfe1cdaff4212d7e6f~bqQAYbl7v1043510435epcas1p3i;
	Sat, 18 Jan 2025 02:38:19 +0000 (GMT)
Received: from epsmges1p3.samsung.com (unknown [182.195.38.243]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4YZgky5k2Vz4x9Pp; Sat, 18 Jan
	2025 02:38:18 +0000 (GMT)
Received: from epcas1p3.samsung.com ( [182.195.41.47]) by
	epsmges1p3.samsung.com (Symantec Messaging Gateway) with SMTP id
	EC.E1.23379.A141B876; Sat, 18 Jan 2025 11:38:18 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20250118023817epcas1p1a7cb68709776f01c5ebeeb02908ed157~bqP_39_JH2188421884epcas1p18;
	Sat, 18 Jan 2025 02:38:17 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20250118023817epsmtrp17b881dd881353e96164d0eaa25d2d03a~bqP_3cAGX1814718147epsmtrp1f;
	Sat, 18 Jan 2025 02:38:17 +0000 (GMT)
X-AuditID: b6c32a37-17dea70000005b53-f2-678b141a99bc
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	D0.D8.18949.9141B876; Sat, 18 Jan 2025 11:38:17 +0900 (KST)
Received: from sh043lee-960XFH.. (unknown [10.253.98.183]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250118023817epsmtip12260c2885aed70537461ef0940f5056d~bqP_qbctO2024620246epsmtip1Q;
	Sat, 18 Jan 2025 02:38:17 +0000 (GMT)
From: Seunghui Lee <sh043.lee@samsung.com>
To: linux-scsi@vger.kernel.org
Cc: Seunghui Lee <sh043.lee@samsung.com>
Subject: [PATCH v2] scsi: ufs: core: Fix error return with query response
Date: Sat, 18 Jan 2025 11:38:08 +0900
Message-ID: <20250118023808.24726-1-sh043.lee@samsung.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDKsWRmVeSWpSXmKPExsWy7bCmvq6USHe6wbttmhbd13ewWTT92cfi
	wOTRt2UVo8fnTXIBTFHZNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2
	Si4+AbpumTlA45UUyhJzSoFCAYnFxUr6djZF+aUlqQoZ+cUltkqpBSk5BWYFesWJucWleel6
	eaklVoYGBkamQIUJ2RlnVvxiLJjHUfHt3xqWBsa7bF2MnBwSAiYSD260ANlcHEICOxgl2r5c
	ZIdwPjFKPLr9gRHC+cYo0fH1PnMXIwdYy/mLIRDxvYwSTxf8Y4Vw3jNK9F07ywgyl01AS2L6
	pi1MILaIgJzE5uVfWUBsZgENiZcNE8B2Cwt4SqxatY4RZCiLgKrEzGNOIGFeASuJM//+sEOc
	Jy+xeMdyZoi4oMTJmU+gxshLNG+dzQyyV0Kgn13i9PSDrBANLhKr961lgrCFJV4d3wI1SEri
	ZX8bO0RDM9CfDSAHgTgTGCVeLHgF1WEv0dzazAZyEbOApsT6XfoQ2/gk3n3tYYX4nleio00I
	olpZ4uWjZVCdkhJL2m8xQ9geEi1XDoAdKiQQK3Frag/rBEa5WUh+mIXkh1kIyxYwMq9iFEst
	KM5NTy02LDCGx2Ryfu4mRnCy0jLfwTjt7Qe9Q4xMHIyHGCU4mJVEeNN+d6QL8aYkVlalFuXH
	F5XmpBYfYjQFBupEZinR5HxguswriTc0sTQwMTMysTC2NDZTEue9sK0lXUggPbEkNTs1tSC1
	CKaPiYNTqoEp4/Vq0dVfVPc8Wupx6v3eho61YbpblP9Zshm0p4ls6mDYtUncWOQtW8wdQ7kp
	POmczyTfzHngr7dIPkGH/9cRLtXnizdOWC4gLFrm/TttgUnIrZ3Li77HJuQ7ng58enY/R9B2
	T9sXD/eYLlGV22l39sHnPQHPetjdUurX7L757Pqvh0WmzkKfl2YwHmOd/74ypyf3tFNLw/6v
	cWtPiza8135TeHmpg9PPMyrz5p5n7Xk4feJyxj+uPt//SSm9cOv4P+HaVbVt3+dO3M7l5Jf+
	Oo3hemuG4BqlY+sn1S5NeHrH96nzZT1BN5F11xtlP+wobeQSOaCReidcIyfTOnTOIf6bTRwb
	61I/pqwI3l+zXImlOCPRUIu5qDgRAJQJ7OHfAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmluLIzCtJLcpLzFFi42LZdlhJTldSpDvd4OBLSYvu6zvYLJr+7GNx
	YPLo27KK0ePzJrkApigum5TUnMyy1CJ9uwSujDMrfjEWzOOo+PZvDUsD4122LkYODgkBE4nz
	F0O6GLk4hAR2M0qcWfqJtYuREyguKbH40UOoGmGJw4eLQcJCAm8ZJc532IPYbAJaEtM3bWEC
	sUUE5CQ2L//KAmIzC2hIvGyYwAZiCwt4SqxatY4RZAyLgKrEzGNOIGFeASuJM//+sENskpdY
	vGM5M0RcUOLkzCdQY+QlmrfOZp7AyDcLSWoWktQCRqZVjJKpBcW56bnFhgVGeanlesWJucWl
	eel6yfm5mxjB4aSltYNxz6oPeocYmTgYDzFKcDArifCm/e5IF+JNSaysSi3Kjy8qzUktPsQo
	zcGiJM777XVvipBAemJJanZqakFqEUyWiYNTqoFJcd1iZzt57iv35eW+OpgbfP9+JnzC13R7
	lZ6Tjvx6dhrb/NVrRGJYChRK3E4wv3vyRf7A51OmTDbcAspRAtPnZS1V9Q7oLA67+Px04oPG
	2/O27qwyNfnhdM3afZnhmxe3m/blTZ7zPvKy1efe/QeLlE8L2jKq/shuti5wjxD8X7Hm23Wu
	CcWqk12rNhbnmazda3c+oe1SSNXK3kYWFy6dMMW9NiVHVooG+z3L1mK0n+D3SLKUSW/DvTwb
	qz+SPf+LV7rytrw4tNZ3iWBUjICZqXJ9iplZTe1C7uP7L/ZzPut/bZLFl2tfGKg+20efb5ej
	zMubarzXW06bGm8JNavzm1O1a//Vj/m7aqdaKbEUZyQaajEXFScCAHi71EOWAgAA
X-CMS-MailID: 20250118023817epcas1p1a7cb68709776f01c5ebeeb02908ed157
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250118023817epcas1p1a7cb68709776f01c5ebeeb02908ed157
References: <CGME20250118023817epcas1p1a7cb68709776f01c5ebeeb02908ed157@epcas1p1.samsung.com>

There is currently no mechanism to return error from query responses.
Return the error and print the corresponding error message with it.

Signed-off-by: Seunghui Lee <sh043.lee@samsung.com>
---
Changes to v1:
- modify the error message with response in UPIU(Bean Huo's suggestion)
---
 drivers/ufs/core/ufshcd.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 9c26e8767515..97e50bccb95c 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3118,8 +3118,13 @@ ufshcd_dev_cmd_completion(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	case UPIU_TRANSACTION_QUERY_RSP: {
 		u8 response = lrbp->ucd_rsp_ptr->header.response;
 
-		if (response == 0)
+		if (response == 0) {
 			err = ufshcd_copy_query_response(hba, lrbp);
+		} else {
+			err = -EINVAL;
+			dev_err(hba->dev, "%s: unexpected response in Query RSP: %x\n",
+					__func__, response);
+		}
 		break;
 	}
 	case UPIU_TRANSACTION_REJECT_UPIU:
-- 
2.43.0

