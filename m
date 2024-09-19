Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAEF01A08BD;
	Thu, 19 Sep 2024 15:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726761237; cv=none; b=aI9PGEBgxkhodNGAz7RIELAuKHbEJo4Y3/6QfIqx6hWxD2AE9c8wGVMRD2fKyc7CA7c5Di6bFn6Vu398yyottC8hQhveOUVqiS9N11a+RWFY9eIKmJxkJC0kDE3fTyPRZ0eTJaRt8isoOTwGmauWyAEFSscfNL5V5Jbbt8kZTmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726761237; c=relaxed/simple;
	bh=imFDZ7DKWRYQNvnJgAAKTRMb1ulVUpG/D4WdMvu4vXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FV9SLEh8RQNBU0DR/LZ17ND6IYtErFKiVO4oodFSV09CQgi0scX0mxTBzuY4ji3zPme568FY3AWp0Dq18j2vUcSiSyHKvv4U5gYDVhA4yhFaCrQoEDICUD2zk8ZFt+/8QS2Rde16FEi3w9dkfzLVB0CQ7rKdi6x45sfdLJtlE1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RTqF83BL; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RTqF83BL"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48JEfkhL014315;
	Thu, 19 Sep 2024 15:53:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=uPmDJNgoqS44O0rfmrNLmEE2hBO4gGobBmgV6+3s7b8=; b=
	RTqF83BLLsrSnyaF1mK9zbcEB6gqxuVxCLwlgMjXJOCLFfxgrL3hJ0t+tTC9S6Kt
	Ph+fYaJK/uioky45VhjpTWwoCSiseeojtmeF51IEs4qoHPRwgthjnb1UoPm8wB4G
	FxBYcJ6hMy+IxCDVw85N+ZnJtvcVRPnfIjapUVhu4g/58x3i4RQjUh2ZwuXEQl+u
	e5mGv+9dyMkst/H9VbDqkbKx1rTK3WYgAxuMC+rdQZ+wtsml4YIjCouiVeyFhBpj
	yDuS6QIz+yTqsNjUAs01ReCqTIHWSaC8aYZu78uRqgkFMaVJOUCHsmBoXxfoBXEM
	uPWYWKrDVgIC5Jp90VFi7w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41n3n3mhxy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Sep 2024 15:53:50 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48JFAEYC010466;
	Thu, 19 Sep 2024 15:53:48 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41nyb9xjay-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Sep 2024 15:53:48 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 48JFri8j031813;
	Thu, 19 Sep 2024 15:53:47 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 41nyb9xj7h-4;
	Thu, 19 Sep 2024 15:53:47 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Chandrakanth patil <chandrakanth.patil@broadcom.com>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        Colin Ian King <colin.i.king@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] megaraid_sas: Remove trailing space after \n newline
Date: Thu, 19 Sep 2024 11:52:50 -0400
Message-ID: <172676112043.1503679.5790201067153267535.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240902142252.309232-1-colin.i.king@gmail.com>
References: <20240902142252.309232-1-colin.i.king@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-19_12,2024-09-19_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=908 bulkscore=0
 adultscore=0 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409190105
X-Proofpoint-GUID: nDEcpbjwaqR5A4wSHFpHKsaqD5s-bNH6
X-Proofpoint-ORIG-GUID: nDEcpbjwaqR5A4wSHFpHKsaqD5s-bNH6

On Mon, 02 Sep 2024 15:22:52 +0100, Colin Ian King wrote:

> There is a extraneous space after a newline in a dev_err message.
> Remove it.
> 
> 

Applied to 6.12/scsi-queue, thanks!

[1/1] megaraid_sas: Remove trailing space after \n newline
      https://git.kernel.org/mkp/scsi/c/571d81b482f0

-- 
Martin K. Petersen	Oracle Linux Engineering
