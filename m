Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8271317727;
	Wed,  5 Jun 2024 02:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717554830; cv=none; b=FUSTeuOdHL/B3zCCmNPszKJHjQYxordd2eSQnsCvL8BFiB2T2i+yN3Ya9Khq/jJqRg8REll45KPJ/oFTEXbmIZyaJiPSQBqtnGWwiiBY8sYhf6He6EyHYrmD6WhOc4sBkybRMbyS8LHtuW0ArGKQ0r6CYTRBZ+/bHKMpRGUM/4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717554830; c=relaxed/simple;
	bh=y3Jpf3796V7bB4ll5S6QM6/04zoMMEk756hQdynLuHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aVfwRQBWHnJbPxo8EewDPEEMJzGOcKwwtMnTqWRk//Wyji5B+AVO0c1fQxLWTjRss1584KUWyVMSlKm1GETKJFMZpexl5j6lMWi6esGG/y9ngmbZC6bOtDk9tvPydFsY+PeK7cM+NKeJXMOlDkH8snVuPfmw7Dlj9uhVxz3J9EE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kxOKFK9U; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kxOKFK9U"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4551EYFL026333;
	Wed, 5 Jun 2024 02:33:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc :
 content-transfer-encoding : content-type : date : from : in-reply-to :
 message-id : mime-version : references : subject : to; s=corp-2023-11-20;
 bh=gXX2gIwJWr0RYYcEQaA9j+2IVmeB4guJsEguiKMUhUM=;
 b=kxOKFK9Un8zHropEoU7ikU71HDyGsfJfG2WF6Kh4AsWjBEDro/AD/Ou2SKHYbsjqyrwy
 gnFUgA4Df/DZKqjCNpLVT37MYna4CjXcPTLOVZJAdxd2HP00kC5cfrcnu+QnRP5meDNQ
 7z3h/qRkqMUL6Uoj4APZfO383VJW4OtfW6650nEjRqo6wV9Runk88EedkaAhZ5nlG6I6
 gFdNpbVvk/tM4yO4oqGB0xr/Oat9hMA18dKaYyRGxB/cS92hACP4gVlnWDKEXJA83atN
 VqSUrBHeBlQcWPlQkGhjbVR4LfhHYMjBlA0fLLx973vn9/zA5d4NRNhttbUyMwTYzyw7 DA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yjbqn069g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Jun 2024 02:33:42 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4550LmHH015580;
	Wed, 5 Jun 2024 02:33:42 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ygrjd4btd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Jun 2024 02:33:41 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4552XFLu011499;
	Wed, 5 Jun 2024 02:33:41 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3ygrjd4bky-2;
	Wed, 05 Jun 2024 02:33:41 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: axboe@kernel.dk, James.Bottomley@HansenPartnership.com, hch@lst.de,
        John Garry <john.g.garry@oracle.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        himanshu.madhani@oracle.com
Subject: Re: [PATCH 0/2] block, scsi: Small improvements for blk_mq_alloc_queue() usage
Date: Tue,  4 Jun 2024 22:32:38 -0400
Message-ID: <171755313980.3904072.6866529850445079083.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240524084829.2132555-1-john.g.garry@oracle.com>
References: <20240524084829.2132555-1-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-04_11,2024-06-04_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=972 phishscore=0
 adultscore=0 bulkscore=0 spamscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406050019
X-Proofpoint-ORIG-GUID: FX-G2ehU5Dxv0BVkCYFY07B2eaEAjWnx
X-Proofpoint-GUID: FX-G2ehU5Dxv0BVkCYFY07B2eaEAjWnx

On Fri, 24 May 2024 08:48:27 +0000, John Garry wrote:

> A couple of small improvements to not manually set q->queuedata.
> 
> I asked Himanshu (cc'ed) to test the bsg-lib.c change as I have no setup
> to test.
> 
> Based on mkp-scsi 6.10 staging queue at e4f5f8298cf6.
> 
> [...]

Applied to 6.11/scsi-queue, thanks!

[1/2] scsi: core: Pass sdev to blk_mq_alloc_queue()
      https://git.kernel.org/mkp/scsi/c/e7c09df178f7
[2/2] scsi: bsg: Pass dev to blk_mq_alloc_queue()
      https://git.kernel.org/mkp/scsi/c/41b757425203

-- 
Martin K. Petersen	Oracle Linux Engineering
