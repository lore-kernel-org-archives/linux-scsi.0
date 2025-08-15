Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF721E32D7
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 03:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755229112; cv=none; b=ThrPK+NI6todSgtlMiozmuvN/hXp6xuIrQlqniDPvcguUQpCvePGarZ/f0izpmhv4w0Diw7n3lLcNJVrD2g2c9uwYkQF0TvdzqPJQhVZ5Y6raUzEaUYiXK0huh2/BPWoXT2QFcRFuwA8sFmnJ17cXxAGrGl4lo2sp2zE5P8I5zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755229112; c=relaxed/simple;
	bh=Pe4Bc1xSaGpTfKMcgZbd9F2JORCi5FQCUG8Usmn1aFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N9tLGD/W2PDl+eR+TXxls+Gyn7D4IWeoOoJ21gsWpUOkNlPBG33jBqEu1Eds6aaKDFY7cnmLPaeHMzrxCDgKUyAtwcivv9u6NLU9W7PPeHw7NfTDVPzWPLrBSiws6hXDfyOJbZJJygr9aGW9WdteptPaIrCy3fT8it00IupByLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=pOAW8EBH; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pOAW8EBH"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57EHfsTN002632;
	Fri, 15 Aug 2025 03:38:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=yZVvLdgmtWfdW7zfGKl5r3HWizAMyC8LsRKMFyKSG10=; b=
	pOAW8EBHXIiSmv2zmwzFX14t5t0LRqnrDXFBg1X+yPHOKjcMHf89RjX8F+tKxS03
	vOR3JmqIVp5Z6TbQ41jICEf2j63b4sZLaRc2QjHirvJEbz7V7DbAqDE+3Hr1gvQs
	PVtzGVruYDR3n45kTYD3VIGppS3k2EQSYAXJV5qdvcEd/h9/CRdk09CxGgNZGLrX
	+tYBkAcZaBfOZEFYSbHJ2VOkIqEBiCRDu2+DxUhjEiV22C1lAZ1bRw+e3MAxRgei
	Xf/nHydBkOodKC3AjLc7PXQQidPiMz2PbVoehDQpE9LGm79GKJ86m7UgXnzbGo/5
	/ICD2Mb6WX1ozNjLS4chIQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dx7du5g6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 03:38:24 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57F3HVdr006372;
	Fri, 15 Aug 2025 03:38:23 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsdcuwy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 03:38:23 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 57F3cMAk015669;
	Fri, 15 Aug 2025 03:38:22 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48dvsdcuwe-3;
	Fri, 15 Aug 2025 03:38:22 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, satishkh@cisco.com,
        sebaddel@cisco.com, kartilak@cisco.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] fnic: remove a useless struct mempool forward declaration
Date: Thu, 14 Aug 2025 23:38:17 -0400
Message-ID: <175522907867.1556995.10981232285935511044.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812082808.371119-1-hch@lst.de>
References: <20250812082808.371119-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-15_01,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 spamscore=0 bulkscore=0 suspectscore=0 mlxlogscore=627 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508150027
X-Proofpoint-ORIG-GUID: uilTyRStdEQP_UVX_G8VxuE2wp4FybBG
X-Authority-Analysis: v=2.4 cv=WecMa1hX c=1 sm=1 tr=0 ts=689eabb0 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=Gib3qXGkYryyHggYza8A:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13600
X-Proofpoint-GUID: uilTyRStdEQP_UVX_G8VxuE2wp4FybBG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE1MDAyNyBTYWx0ZWRfXwDvJeseWgfpF
 YI2iLNwoQpBFDNx4KJeNPm/NY2DcYxkUH5Sla6cJK/zQrG/McJ78CiKTtYac1m5h8zd4LGSb+XS
 NySNZ2/c6UrAE+1mrPNPmgnOWDftCLrrtjN1B+ob20i+36TlL+HsFQ6B6I2vgvVg73/eAZHr+C0
 wZfYUBYsCNTQHLvAWCEobSiK7NcmRKOGrF94xaFiDCO8Lqy18XLCgG2KWXHwZIEjGoRW17MdvS6
 A1ff++7k6OJSjgXf7dTydcHALh7RGOYQ353+mKd9CtcmSZZRA0LzuRYsgfy/XPHXNtqynteMd1H
 iOv4qgOGfZ4HoIgKh4liYtELlpi3R1r3CkOU7xQPCDUqjsZSZMlB6TFZVzwJZ3xt4nPsvBYJhGQ
 eka9Of1lRY4KVLI4k02h+80bU4rpuoyvwi0/soy3urPK0CqCsLYkgaa1cKTvp0YiFGD8YJXG

On Tue, 12 Aug 2025 10:28:05 +0200, Christoph Hellwig wrote:

> Struct mempool doesn't current exist, and thus also isn't used in fnic.h,
> remove it.
> 
> 

Applied to 6.17/scsi-fixes, thanks!

[1/1] fnic: remove a useless struct mempool forward declaration
      https://git.kernel.org/mkp/scsi/c/fad2cf04e91f

-- 
Martin K. Petersen
