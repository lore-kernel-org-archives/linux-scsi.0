Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC2B433D1
	for <linux-scsi@vger.kernel.org>; Thu, 14 Nov 2024 02:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731552975; cv=none; b=T9FqT5gSMl+9oVAtCQ6QmnUJl73Y4BtxWnJCIQFABwCOV920RNDysTq+Oy60rw4NjhkW7m57j433hed6YFZ/mDYV5QWfezb91I+VkEIWeifD6fqyyHXVOQU1L5ZsHFxYextOVR4uQvePpOW/SxBCs/oXWRUeVxSdAHVBxJc04I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731552975; c=relaxed/simple;
	bh=9IwoRxc4lyJ2nYBRRBp9T4zHiCJZWVNXVJsGP5cGVCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HwwqoeN/qRY//x4D7dvI5ueOazB9/NHANBRPu4d+CnXCxL4dFr1oqenG/7H/92kIPpyiXMrg/gCnb8bDDAYUZw7hzIJtgYwbeNZHfP20VthPJ0gFjCO8KeiOOf4Xo79LgW58qcBR3R804LrKewNJZBAU0tDUehNR5TlpQcJ9Aj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UVXRBBth; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UVXRBBth"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AE1fbgN018578;
	Thu, 14 Nov 2024 02:51:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=R/Hbsv4T29kzmeKkbpEpxNw5hcw2zFInwQN4oleszpU=; b=
	UVXRBBthBsAFzseMp7VIunw83aGVsqp0n7u+X9O1JcZrP7hrJrqESXWLzqgplAAx
	k4Jm8ZnjNDJRaV+0LhDffVlNVKo4GJXzNeA9q5uTdQEzknrRWrmuAIaqCa0CQYnm
	ikQ46kNIDd3oRNq66SelypLlfZ1UlWCD46M1aWW39tb4wLWlPF6XJs0O3ZUWh/OC
	neOBK1Z+Tb/PaHrk3cmGlezAWd4t5k1JEM1GwRClON5QNi4pMNM1oYlVmEdTB041
	SZXRbWxSDwxOfgcshnb3mEkcx+InKN1AuSK5GKacan49yjV/5fUbk3cz0QNcSpn/
	bPX65M05mFw3UkZ+eGi/nw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0kc0bay-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Nov 2024 02:51:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AE18Sqr022740;
	Thu, 14 Nov 2024 02:51:00 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42vuw0p247-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Nov 2024 02:50:59 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4AE2ojZ6003527;
	Thu, 14 Nov 2024 02:50:59 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 42vuw0p1vg-12;
	Thu, 14 Nov 2024 02:50:59 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Saurav Kashyap <skashyap@marvell.com>, Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        Zhen Lei <thunder.leizhen@huawei.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/2] scsi: Fix two possible memory leaks
Date: Wed, 13 Nov 2024 21:50:05 -0500
Message-ID: <173155154809.970810.3123163404665586536.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241026125711.484-1-thunder.leizhen@huawei.com>
References: <20241026125711.484-1-thunder.leizhen@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-14_01,2024-11-13_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 phishscore=0 malwarescore=0 mlxlogscore=903 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411140021
X-Proofpoint-GUID: 1LFyEcHN57fqxT3jUo0gS1_oYmhEHG1Z
X-Proofpoint-ORIG-GUID: 1LFyEcHN57fqxT3jUo0gS1_oYmhEHG1Z

On Sat, 26 Oct 2024 20:57:09 +0800, Zhen Lei wrote:

> When "ops->common->sb_init = qed_sb_init" fails, the DMA memory needs to be
> explicitly released.
> 
> Zhen Lei (2):
>   scsi: qedf: Fix a possible memory leak in qedf_alloc_and_init_sb()
>   scsi: qedi: Fix a possible memory leak in qedi_alloc_and_init_sb()
> 
> [...]

Applied to 6.13/scsi-queue, thanks!

[1/2] scsi: qedf: Fix a possible memory leak in qedf_alloc_and_init_sb()
      https://git.kernel.org/mkp/scsi/c/c62c30429db3
[2/2] scsi: qedi: Fix a possible memory leak in qedi_alloc_and_init_sb()
      https://git.kernel.org/mkp/scsi/c/95bbdca4999b

-- 
Martin K. Petersen	Oracle Linux Engineering
