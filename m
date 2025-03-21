Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA693595E
	for <linux-scsi@vger.kernel.org>; Fri, 21 Mar 2025 00:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742517451; cv=none; b=QTCDAPGaK7qW+T7uNga+FnLE0dLlr+v+oll0wDT8GTWk/xQW6lKmyEY5ZYK69BY9sVRxT5R8+bhFd1/YW4NLTNolZkBai61u0g9eeOpIJ+uNrG2GsegoMq1bIKudQzkUqhrSOY72XAcvlPiJRDpAnYAeK33yuzbncHt0g73FKbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742517451; c=relaxed/simple;
	bh=ztWF9t6MFRxq3gqQiubfSUl0lLPX4P07xpbbqxtGDSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PQmAvgC4tp29+SK51wWGP0S24JggTgLrPdbFXvuV7avAwMBJR2EvAL84A3DpKU28+L+I9jCwhpHO6qsQbfw9Yw7zf7EYxzEjLiT+izG7VZUH8K4K9CRlfXwrGLQarBLgUb1kiWJu14ad80vasYr3V337ldbOxyBrrJgKBZtyNgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=L+IOlu83; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L+IOlu83"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52KLBkpH001294;
	Fri, 21 Mar 2025 00:37:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=VpLd2Lbmyzkvwo4PAIFHKqiacpjklczyB5kxlb5KMsY=; b=
	L+IOlu83aiqlhHS60TT44291f/zt9IDXTaTsdhWNDe+kGYvaan656Lok4CmpUIfs
	6nqic1dtm6fT9xAmJxVEVSk47yd3tC2unc3O3jKsFsaBH0oxjbYGpC3HBkPlL6vG
	BFppUL1pSdA3FW1n1tnz+uCyIuNSTCj1t4yks5HtQs08P+ElHEvwLybQBGkF6rT5
	ENAKXapzSnJlmMXpGaVZIzAHbxibQBWRLTaepwfiU5MYu9Ppd5KL+E6vIvgr0T3H
	yDXkz3Kbaos57ipLIrHKDgO4kJM4toM5h0DCM56Ur6FDBns+o9SB6JCC7MCcXNNd
	KsFGvgPfX7j65UrKngLvfQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45d1hg7gd8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Mar 2025 00:37:19 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52KNe7fH005542;
	Fri, 21 Mar 2025 00:37:18 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45ftmxt6uc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Mar 2025 00:37:18 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 52L0bHsa024893;
	Fri, 21 Mar 2025 00:37:18 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 45ftmxt6tx-2;
	Fri, 21 Mar 2025 00:37:18 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        James.Bottomley@HansenPartnership.com, jmeneghi@redhat.com
Subject: Re: [PATCH 0/3] scsi: st: Small fixes
Date: Thu, 20 Mar 2025 20:36:50 -0400
Message-ID: <174251737529.2240574.14048234652007772220.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311112516.5548-1-Kai.Makisara@kolumbus.fi>
References: <20250311112516.5548-1-Kai.Makisara@kolumbus.fi>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-20_09,2025-03-20_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 mlxlogscore=866 suspectscore=0 spamscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2503210002
X-Proofpoint-GUID: -sSj_bwICdOQFoMVBn_2GXscJzPo59-M
X-Proofpoint-ORIG-GUID: -sSj_bwICdOQFoMVBn_2GXscJzPo59-M

On Tue, 11 Mar 2025 13:25:13 +0200, Kai Mäkisara wrote:

> Fix some small things in the st driver.
> 
> Applies to 6.15/scsi-staging
> 
> Kai Mäkisara (3):
>   scsi: st: Fix array overflow in st_setup()
>   scsi: st: ERASE does not change tape location
>   scsi: st: Tighten the page format heuristics with MODE SELECT
> 
> [...]

Applied to 6.15/scsi-queue, thanks!

[1/3] scsi: st: Fix array overflow in st_setup()
      https://git.kernel.org/mkp/scsi/c/a018d1cf990d
[2/3] scsi: st: ERASE does not change tape location
      https://git.kernel.org/mkp/scsi/c/ad77cebf97bd
[3/3] scsi: st: Tighten the page format heuristics with MODE SELECT
      https://git.kernel.org/mkp/scsi/c/8db816c6f176

-- 
Martin K. Petersen	Oracle Linux Engineering
