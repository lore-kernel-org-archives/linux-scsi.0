Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052E55C96
	for <linux-scsi@vger.kernel.org>; Sat, 17 Aug 2024 01:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723858698; cv=none; b=sKSdMC8NAXOydc5Tk8wUb8yF6Ck8uWMoecTSusWn9FIj+OL8LLvxANcCmJKZyrY+YVJf8vCQRYlAhUkNhBVjwV0HXpIcXCrm77gROk/kueaTIbvoTTNOZLrHW/JJvNq8s7HumDn2zeY9Vo4Z/7hWoHDDikilYmZjsI82TPaZ0WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723858698; c=relaxed/simple;
	bh=076+vRKtL2os03wvwvK90gpZ9lFLXfF9/XdMuvEtgL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KQks4u1xfhLLxqXdGlHR64Uj8lhYhKDanQSzCerkpsdLNknbRUlHxfnIi4qZ6jnYYjHMw6f7r3AEf3HTG+NDOP4d8Y7SJpYZ3F23v1yHpYcLtXd75GEUM7SR8rYibRbB+SfbwPR+L/r1HuSVGgM1aOMgdwhwGUIlVEtR31kbM+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=K1PXuaAl; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="K1PXuaAl"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47GLBxXw007668;
	Sat, 17 Aug 2024 01:38:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=7PYwGvXZCpNE5MO1td2r5A7WLbtYAH6/eSaudALCHng=; b=
	K1PXuaAlr5E+9b7zLq8Ia6ZkP4fJUlqXQd5QONPUKEJUG7cRv3lhZ0sQOc7eVSSo
	lHnducyuFOWG2BKWhl7bLOzXI4ksjKNNRBf9Fiaf7ZfTHlmOFelyODb3BJqLfh0H
	+1tAWwOZNEQ9F3LbbB7uRshe7NvhwppVuy2Cp1gxjJc6foba5tnw8SD/x+p1QK3z
	Hg4j5TtNZ4AnwkBrv6T2VyDzyg3so6+255oRe4UWW9YxCgRymzvD3YnG122HpUxO
	wh/vpUMS5+fU7D5xcCEFAy/HELoWrSVXUZ/o3ieO1Ouf+3y9IZIcHb9tsf+jT2M/
	R+nHHrkQ5D+Da6zw9PiO7w==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40wy4bnuy2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Aug 2024 01:38:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 47H1Xb6w011148;
	Sat, 17 Aug 2024 01:38:13 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 412ja5r1n3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Aug 2024 01:38:13 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 47H1cCmj019253;
	Sat, 17 Aug 2024 01:38:12 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 412ja5r1mw-1;
	Sat, 17 Aug 2024 01:38:12 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        sathya.prakash@broadcom.com, sumit.saxena@broadcom.com
Subject: Re: [PATCH v1 0/3] mpi3mr: Critical bug fixes
Date: Fri, 16 Aug 2024 21:37:36 -0400
Message-ID: <172385819631.3430749.17773885625671373312.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240808125418.8832-1-ranjan.kumar@broadcom.com>
References: <20240808125418.8832-1-ranjan.kumar@broadcom.com>
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
 definitions=2024-08-16_18,2024-08-16_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 mlxlogscore=935 suspectscore=0 mlxscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2408170009
X-Proofpoint-GUID: 7SOoFxUIv28eRJvt8VRdl9cKWh0368st
X-Proofpoint-ORIG-GUID: 7SOoFxUIv28eRJvt8VRdl9cKWh0368st

On Thu, 08 Aug 2024 18:24:15 +0530, Ranjan Kumar wrote:

> This patch set contains mpi3mr critical bug fixes.
> 
> Ranjan Kumar (3):
>   mpi3mr: return complete ioc_status for ioctl commands
>   mpi3mr: Update consumer index of reply queues after every 100 replies
>   mpi3mr: Driver version update to 8.10.0.5.50
> 
> [...]

Applied to 6.12/scsi-queue, thanks!

[1/3] mpi3mr: return complete ioc_status for ioctl commands
      https://git.kernel.org/mkp/scsi/c/6dc7050d4671
[2/3] mpi3mr: Update consumer index of reply queues after every 100 replies
      https://git.kernel.org/mkp/scsi/c/199510e33dea
[3/3] mpi3mr: Driver version update to 8.10.0.5.50
      https://git.kernel.org/mkp/scsi/c/f856e57d6138

-- 
Martin K. Petersen	Oracle Linux Engineering
