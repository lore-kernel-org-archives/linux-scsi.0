Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7659923BE;
	Fri, 21 Mar 2025 00:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742517447; cv=none; b=WAD4gVS0UK8dusXPLWMH3AJRC/W86NrgPpHL05pp6MTkfrMXCMz519RoTC7ANFwZlNbxegBai+/jyonN+Hu4kQ9n1o50hj8KcjbcNxxuwiqbzHuuTUveJFijXfSpfjFvj1oKnas9Vi7rmXwHRRHOrtlPLYf9pYjTFhOa0Nl3dtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742517447; c=relaxed/simple;
	bh=eGWe6No9PgYD5pxyU0eods0lJ1MWHGm+w8wxn8Z9RMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a7JffoXFJdQEMszmT6Aa+iE4ZO7d8E9jOnYPMFhMi6dvdzHq6Wjn6DO6dNP7Ss4I7Piq1cTsm3W9JqGCfJzriyib0rhPvFiDWxjtjHZaOrL96i+61LJT16jVdOLc7yLtdlwdnIsRDeG5yfnru557Mr4iy2/drEzOfyjApajr56I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MN/KNWmb; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MN/KNWmb"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52KLBaN6020754;
	Fri, 21 Mar 2025 00:37:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=9nvDBgDUgZC+aADyNeESmN1q0SRTFUqbJTThmrIuksI=; b=
	MN/KNWmbmDXwLKub+5F3GCj7WS4WtqDisftjfm7P+KTR4jka2STVcBoH67lzZ8v8
	rNKGTQVH2pEBLq1HsCh2xQ6f7MTT0Ybq4Lbjs7QFHksJFEM7JWn1VqbyAcpED0YY
	o2Aw3IF7Uy3pKSRERm1zbxyKpjDQSXnD9ZQbhrYebKxrdQgfMF9lT94R3XSfutog
	K3r8C4uvaqTuOVGQ5S7Ws3nqu/vIm6Ek1drN09pswAGYWB2XLFJu8oKBqSwbXIR9
	wuhYLchC/LDw3IEGIekk2POYzOsVofdOnE5z0rvs5ulXRMj2SBNW/FudAtt2BV5i
	lZ00qpHxUaezNFdUcBi0BA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45d1n8q8d1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Mar 2025 00:37:19 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52KLxBqF004582;
	Fri, 21 Mar 2025 00:37:19 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45ftmxt6uf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Mar 2025 00:37:18 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 52L0bHsc024893;
	Fri, 21 Mar 2025 00:37:18 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 45ftmxt6tx-3;
	Fri, 21 Mar 2025 00:37:18 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Guixin Liu <kanie@linux.alibaba.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH] scsi: target: tcm_loop: fix wrong abort tag
Date: Thu, 20 Mar 2025 20:36:51 -0400
Message-ID: <174251737532.2240574.2622734049480949129.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250313014728.105849-1-kanie@linux.alibaba.com>
References: <20250313014728.105849-1-kanie@linux.alibaba.com>
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
 mlxlogscore=829 suspectscore=0 spamscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2503210002
X-Proofpoint-ORIG-GUID: puVTQTRYnV2Q-K0WDKgyYywEqQ_CR1xB
X-Proofpoint-GUID: puVTQTRYnV2Q-K0WDKgyYywEqQ_CR1xB

On Thu, 13 Mar 2025 09:47:27 +0800, Guixin Liu wrote:

> When the tcm_loop_nr_hw_queues is set to a value greater than 1, the
> tags of requests in the block layer are no longer unique. This may lead
> to erroneous aborting of commands with the same tag. The issue can be
> resolved by using blk_mq_unique_tag to generate globally unique
> identifiers by combining the hardware queue index and per-queue tags.
> 
> 
> [...]

Applied to 6.15/scsi-queue, thanks!

[1/1] scsi: target: tcm_loop: fix wrong abort tag
      https://git.kernel.org/mkp/scsi/c/1909b643034e

-- 
Martin K. Petersen	Oracle Linux Engineering
