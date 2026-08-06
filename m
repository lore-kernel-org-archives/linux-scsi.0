Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E378A4C9008
	for <linux-scsi@vger.kernel.org>; Thu,  6 Aug 2026 19:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786043203; cv=none; b=LLCGzWkWEti9JEiSQ8Rn9kDg/N4k1ruc6YfWbgutVkUWwS9xZ9FdfxMjeSlhDCgPFRst8k/V+4rSKBBJu7YefWyRR8WU1rirsg9V2qjPIIu1hwcMu9BPDHncCJ9z2r2s1xu8qpO0CABq1sgsMV6A+wY2f2pQJi8DDaWWT+PNll0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786043203; c=relaxed/simple;
	bh=ayCIeZ7XNyhwDjXiOLUJkXSHNyJzlOnYlJsme31iFZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=defV45y2x/p0pYPygPvgJ49CYCt+V42kh6MNtXyJN1f9Flss7guqw4x53VVAwPgzqsz/INFMHvmFblpTdiTZVzdUHpW7zdYD18Dsto5FhR261s3BgUf0UerW5xbQeyAkDiMHVobK3y+tEnkuzrEH6Mk/MFriYkDylnHP59JNF8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hrVO0vlZ; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hrVO0vlZ"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 676FtuJF3084586;
	Thu, 6 Aug 2026 19:06:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=qvk6GMYU9sv0xPeJ3GXItGBWEfCda4s/5kRogJpchyI=; b=
	hrVO0vlZixa3yWKMnQXTtnfZevBfeQykThBx2tB6L4O9xDdrF89LWWA30aj4mwsX
	9mMVjxCfUk83YlsEI9oVNZDPqEq04W2s6GvmvgxqfF7ts2tOEQeJmvbW043XW6Bb
	bUKzNimBqwnzkGmBzirN1FKfnBbn9Bwk42LBMsHGJyyB8Y9jwCOTqZ2t2rDI/YwH
	nQvXiED+cqqalAD842OfIxGI9v6p3wqonr6z1grW3qmOC5HDEa0WF9gLCDza1Wi/
	4D9QBGzYg/irDojCEdkegFMClfd8PjDtoGQ9vVzzLCO5G8LSCj+GZzzzLHluBXwT
	q4E1y1whEUTCwjCKp4Z+wQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fs7k3pm0d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Aug 2026 19:06:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 676J0cfi024703;
	Thu, 6 Aug 2026 19:06:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fs78w56ed-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Aug 2026 19:06:25 +0000 (GMT)
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 676J6Lgb011247;
	Thu, 6 Aug 2026 19:06:24 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4fs78w56b9-4;
	Thu, 06 Aug 2026 19:06:24 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James.Bottomley@HansenPartnership.com, m.szyprowski@samsung.com,
        robin.murphy@arm.com, hch@lst.de, John Garry <john.g.garry@oracle.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, iommu@lists.linux.dev,
        ionut.nechita@windriver.com
Subject: Re: [PATCH 0/2] Drop SCSI core dev->dma_mask check
Date: Thu,  6 Aug 2026 15:06:09 -0400
Message-ID: <178589207054.336697.7602751558246670967.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260629085310.2298552-1-john.g.garry@oracle.com>
References: <20260629085310.2298552-1-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-06_02,2026-08-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 spamscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0 mlxscore=0
 phishscore=0 mlxlogscore=999 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2608060149
X-Proofpoint-GUID: bfBrggM1LiC8vT4yoUHiCgoOeePkTznS
X-Proofpoint-ORIG-GUID: bfBrggM1LiC8vT4yoUHiCgoOeePkTznS
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDE0OSBTYWx0ZWRfX0+r31i9CJ0is
 0/AGavYb2N50MZd9sSvFosms18pGiRqg93/AmZVJ+cmQgZh26d9APuqRZa0WkH/A7nO5MOVA33/
 Zst3MrgnFl5YUzCX/DHdJ/Lh5pOn2y7MMFE3NSdUU/+gIIUGGRPi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDE0OSBTYWx0ZWRfX0K1KwSoseYpR
 pNIhFTCOPAlzoYkdkLFTKUmvvFKFJ0sOb/U+zSrfbF/dJU1Hs20SxJ0J4GoN10UV0Qz0g8txUWZ
 xljXqqZ8vBJ/hX/MVRmscVDGMSbT2GAdD1hJRj0q8VV+vRTQOqAzhkXAg/SEg5VXbCzIwkmnnXN
 zzYPKK/OGYxQz2uc89aIYAwaxsfv5YBbZnW9MWhbR//jpWhwcLrGbt5Zq0RiUj9GgNDOdo0xUjS
 8iaKgGeh8ICIQSxjWciFsiN24+FiP/eRFJXpE0ElkF6vPF4MrIsNiJF6+QbosnJi1cefmInRAi/
 QjeMTypJJEySl0/dDYFk6qeDum0H6O8hfw0qRuAv3JJsL53FiyUi8pQC/vOXP+weuSCb6LUpQXT
 9FxbCOGiSbC/CkZ1YsYBq1Hsy+FaBsVJ9OTKGM+m7txU2m1mGjOPQlGPtgyWU30x5vQNwon4VcF
 mvfE6HCM9PPbeh0VmHCajj4tJ/JrHhrDgv/mgk+I=
X-Authority-Analysis: v=2.4 cv=Iqcutr/g c=1 sm=1 tr=0 ts=6a74db31 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8
 a=cFe9pjvixOIbOj0nVsMA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13510

On Mon, 29 Jun 2026 08:53:08 +0000, John Garry wrote:

> In commit be8fcd4a8217 ("scsi: sas: Skip opt_sectors when DMA reports no
> real optimization hint"), the check for dev->dma_mask prior to calling
> dma_opt_mapping_size() was dropped.
> 
> However, it is not safe to do so, as dma_opt_mapping_size() ->
> dma_max_mapping_size() may try to dereference dev->dma_mask.
> 
> [...]

Applied to 7.3/scsi-queue, thanks!

[1/2] dma-mapping: make dma_max_mapping_size() return 0 for no DMA capability
      https://git.kernel.org/mkp/scsi/c/81d273096f12
[2/2] scsi: core: Drop dev->dma_mask check in evaluating max_sectors
      https://git.kernel.org/mkp/scsi/c/6e468644fc17

-- 
Martin K. Petersen
