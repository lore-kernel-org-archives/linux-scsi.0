Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E552215058;
	Fri, 10 Jan 2025 21:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736543874; cv=none; b=aVI8tpsZNiajrI94DIbdzG8663CBvGuNMqiK8jyRT8D0D3NpxhQsLP3CdKxItbe/5dpO4HRvwEWkOMur0gBE6FfcyizyBuvrfoK2uoT+UrYAU7hp7a+YBV+CoDwUGo4BAiYep3ywvY/2zLN7aAAqVbWBqNSObNmw8pqfXUwktWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736543874; c=relaxed/simple;
	bh=qd8HmzWXUvj1FSxkJZxLbC+UsLy3aqRWKxZfpPF28xc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SedZ9Xyfdm4TA3rnNbmWokNG/xiPCtq+qXDPBl5HTn69sKjTU8e6+9m59srnzViJIhwk+L6pgSbL4oJEJQ0W1zHucTgqyBTncDrPySaiTG1ZC/VD61Dx59CbXNLGP7q+AZLBvj0j9llJF3GdEG0ONv91FxdI9wKx5NaORc5OwGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ClPT1+lT; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ClPT1+lT"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50ALBtwe015591;
	Fri, 10 Jan 2025 21:17:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=8ymIlVifxb6BkytjP8D009NFsA+RYCchj5hd5P5wYC0=; b=
	ClPT1+lTsO9+kdtXDT8rvV/IfjC1ChhCk2V5Nesq+deqaiHVP6Cv6ZaJGbnCRR9I
	hHWCm/ggKZh0oGMBOOBkhPNeJjgO//qednz6tRneba8Wzevck9HivnpzlEs4HmgA
	W1UpuejEpNl7A0VH7n4hYtB7w+/gkOzxj0Y9Au/q8EEbx0UP6fMJc0+kMzAHwD/e
	m5pGRMVCccz0bcs04OWwTE6m3jDNNvN8i1vOok1Dv+J7hB4ZKzN/SSxtDSO7ViW3
	zNpZxNz3kiQ9zVYavHwVQle4sJ6HPahuzBts6L1mUUOPAswG9K1eAH5C+CpqeAmy
	hPnRZ/u1l0C9aHgILoLtfg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 442my6261q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 21:17:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50AJ7SOa027663;
	Fri, 10 Jan 2025 21:17:40 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43xued5r94-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 21:17:40 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 50ALHQ28034137;
	Fri, 10 Jan 2025 21:17:39 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 43xued5r3k-10;
	Fri, 10 Jan 2025 21:17:39 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] scsi: mpt3sas: Add details to EEDPTagMode error message
Date: Fri, 10 Jan 2025 16:16:52 -0500
Message-ID: <173654330186.638636.11731163498673648499.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241212221817.78940-1-pmenzel@molgen.mpg.de>
References: <20241212221817.78940-1-pmenzel@molgen.mpg.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-10_09,2025-01-10_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501100164
X-Proofpoint-GUID: FBoWv3TB2n__MfLbOB897POzCVB2yVVh
X-Proofpoint-ORIG-GUID: FBoWv3TB2n__MfLbOB897POzCVB2yVVh

On Thu, 12 Dec 2024 23:18:11 +0100, Paul Menzel wrote:

> Linux 5.15 logs the error below
> 
>     mpt3sas_cm0: overriding NVDATA EEDPTagMode setting
> 
> on a Dell PowerEdge T440 with the card below.
> 
>     5e:00.0 Serial Attached SCSI controller [0107]: Broadcom / LSI SAS3008 PCI-Express Fusion-MPT SAS-3 [1000:0097] (rev 02)
> 
> [...]

Applied to 6.14/scsi-queue, thanks!

[1/2] scsi: mpt3sas: Add details to EEDPTagMode error message
      https://git.kernel.org/mkp/scsi/c/09ecc187ebde
[2/2] scsi: mpt3sas: Set ioc->manu_pg11.EEDPTagMode directly to 1
      https://git.kernel.org/mkp/scsi/c/ad7c3c0cb8f6

-- 
Martin K. Petersen	Oracle Linux Engineering
