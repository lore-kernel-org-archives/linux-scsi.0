Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7BCE171064;
	Mon,  5 Aug 2024 21:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722892722; cv=none; b=dbG8rcmAukq0YToy+2yUm1fdWH3FuzY8JWW//IbTNS9jqKZsqff7D9Wu7tlrk2JMvSpaqe8B5HKlffKl04I7oeDxG/7HiSUqT8tl/eCBQNrh+yDdf3x9+eCgl6ewZEyGcKju2NMnBm1GohT//551xi2hCyixItKG+iWVGCDzYFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722892722; c=relaxed/simple;
	bh=d5Do0gbUaXDVnmUsXZfP8HKT2ynq24muB7F21wlFt7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=maWhuCYIYqW4CpVz89P13/9tDTGAVCSouyiQPeidlrO/7q++B3a9hqcSdpXgxBCPwgE2pOSq3p/R2om9MfB65/8XTDXr3j8KLrPW4ZRHfeqd7KQm88e9bZ8bSWScBghOEUjwrNlu7f87ncZey7dTR4uGw1N9tDLx0IbNrUYuYxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=aFAjLgpC; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aFAjLgpC"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 475Kj06c028525;
	Mon, 5 Aug 2024 21:18:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=hRkFRL8HV8gxUsylgjeeyOo6lxDNNREn4rHRxilkzL8=; b=
	aFAjLgpCZZ70vbShT0RBp0+24BH8Axgpz6RodYCnYzgSh4vopM7oaji4hUyB31+3
	C6RnubcVX1VY93Fyh3fdX+WPd8YYahBV8h2mgux9GW+fprS9oFEGPKXRpqFEPMrZ
	12izsTN/+wZpVtnyAGTBlykMzD+vRLV29zglI0bVcm7KihqHJlw795ZljeW9Zk5g
	gmU1zRXZE1FQlFLvvxzdNssptJB3X1zdA3Q+6KSbAPVI6Mt7qA/GDad++P43FTh4
	MnCdQVuVOJYyC6W3BXvFFSThp/fjsvMNx7/+TZa2d1ExzF34Lvy2N4BjrLeKMxhu
	6CN7D9FkNBGgEOoQvcLwLQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40sckcbr0b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Aug 2024 21:18:28 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 475JbvBG034971;
	Mon, 5 Aug 2024 21:18:27 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40sb07ydjp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Aug 2024 21:18:27 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 475LINEP035403;
	Mon, 5 Aug 2024 21:18:27 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 40sb07ydcw-4;
	Mon, 05 Aug 2024 21:18:27 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kees Cook <kees@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Ranjan Kumar <ranjan.kumar@broadcom.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 0/4] scsi: mpi3mr: Replace 1-element arrays with flexible arrays
Date: Mon,  5 Aug 2024 17:17:28 -0400
Message-ID: <172289240507.2008326.13934701070082465133.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240711155446.work.681-kees@kernel.org>
References: <20240711155446.work.681-kees@kernel.org>
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
 definitions=2024-08-05_09,2024-08-02_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxlogscore=841 mlxscore=0 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408050151
X-Proofpoint-GUID: yD2dYJEqQWuFxJpWPO2dk7ACz7qB4R2B
X-Proofpoint-ORIG-GUID: yD2dYJEqQWuFxJpWPO2dk7ACz7qB4R2B

On Thu, 11 Jul 2024 08:56:32 -0700, Kees Cook wrote:

> Replace all the uses of deprecated 1-element "fake" flexible arrays
> with modern C99 flexible arrays.
> 
> Thanks!
> 
> -Kees
> 
> [...]

Applied to 6.12/scsi-queue, thanks!

[1/4] scsi: mpi3mr: struct mpi3_event_data_sas_topology_change_list: Replace 1-element array with flexible array
      https://git.kernel.org/mkp/scsi/c/ac5b7505de70
[2/4] scsi: mpi3mr: struct mpi3_event_data_pcie_topology_change_list: Replace 1-element array with flexible array
      https://git.kernel.org/mkp/scsi/c/0e11f97bfddc
[3/4] scsi: mpi3mr: struct mpi3_sas_io_unit_page0: Replace 1-element array with flexible array
      https://git.kernel.org/mkp/scsi/c/41bb96296f9d
[4/4] scsi: mpi3mr: struct mpi3_sas_io_unit_page1: Replace 1-element array with flexible array
      https://git.kernel.org/mkp/scsi/c/a62193abae75

-- 
Martin K. Petersen	Oracle Linux Engineering
