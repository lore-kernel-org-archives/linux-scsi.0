Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FAD580BEC
	for <linux-scsi@vger.kernel.org>; Thu,  5 Dec 2024 02:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733365067; cv=none; b=mwd2J0i3UvlL8TCTrR8QQb8gAABZQomxZFgX6omcis5ytR9AU2tpI+aZL0o0GUj4Qe6x2UO3+3nr8taEHIjidVZ8LGdXZIOZzQKd23X6uAQVzZRsboFtkzxYtb/bAZvoyAZT7/hQaVqPEPok1iOUA9yE41Rd/JH/Lj6rHfSQlSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733365067; c=relaxed/simple;
	bh=Ki8RaMZIi4liz1gtolTbyCANcACe/RBIyiN+OFKjiEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xw6u/f6LMYZBiEZMMSBlyW1hme5Wjn4fDBQr15tJTaja7l0hVcV7QXQEWX1n8kq2YtNji/9qIOn604w4PJPcA10MmoinCppimd5GZX3Y46zbeWs9mzpMsQ8jZ+z/LWG3oztp4HE/atkRcyiqH+dmW/2vf2aJ2Xpn6BGC1GvSxC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZJoo8Z02; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZJoo8Z02"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B51CNPZ017956;
	Thu, 5 Dec 2024 02:17:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=vMRR0W5ZlO709+hFi23C7Q4Uh+fL3jLNDDDv+bv51EI=; b=
	ZJoo8Z02N0jR7NDhhJDuWxZrOIsOYE73nLop/QcXO2QdWKHsK0Rp3hKA44DjK/Hd
	tua1zmodl0lI8m7+4pYFN/MrVIMToCT01OFNYmHAA7SgvY59X2ayJpkLyoOj5tLg
	IWAZ9Tn7zutDc0tgo3nX7C3biucs+AzeqPsclf+DDpVmbCz9AuvLkEEBWXKP6yoZ
	KmPKAXHDV1ibSYxMRqB7Kqzpc1YUNDvnofv94puIygsTdP6olbvlClTIu5mcerzu
	fmJmDj7NBCrGaZHvSBiJJ1502dSJDxGz3QfpB4XP5LpG5bL1KZyZp/f8FCrDlKUy
	B2PNzaQksNmwOfJB9y1LyQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 437sa01xmm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Dec 2024 02:17:43 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4B4Nif0H001392;
	Thu, 5 Dec 2024 02:17:42 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 437s5a8u7c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Dec 2024 02:17:42 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4B52HbvQ018742;
	Thu, 5 Dec 2024 02:17:42 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 437s5a8u3n-4;
	Thu, 05 Dec 2024 02:17:42 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        sathya.prakash@broadcom.com, sumit.saxena@broadcom.com
Subject: Re: [PATCH v1 0/2] mpt3sas: Update driver version
Date: Wed,  4 Dec 2024 21:17:03 -0500
Message-ID: <173336487627.2765947.14609104172792320921.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241110173341.11595-1-ranjan.kumar@broadcom.com>
References: <20241110173341.11595-1-ranjan.kumar@broadcom.com>
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
 definitions=2024-12-04_21,2024-12-04_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412050017
X-Proofpoint-GUID: pCcJPg4xxDXHLHUeOq1liqO4w28XGNIp
X-Proofpoint-ORIG-GUID: pCcJPg4xxDXHLHUeOq1liqO4w28XGNIp

On Sun, 10 Nov 2024 23:03:39 +0530, Ranjan Kumar wrote:

> Update driver version along with minor Enhancement.
> 
> Ranjan Kumar (2):
>   mpt3sas:  mpt3sas: Diag-Reset when Doorbell-In-Use bit is set during
>     driver load time
>   mpt3sas: Update driver version to 51.100.00.00
> 
> [...]

Applied to 6.13/scsi-fixes, thanks!

[1/2] mpt3sas: mpt3sas: Diag-Reset when Doorbell-In-Use bit is set during driver load time
      https://git.kernel.org/mkp/scsi/c/3f5eb062e8aa
[2/2] mpt3sas: Update driver version to 51.100.00.00
      https://git.kernel.org/mkp/scsi/c/6050471545ee

-- 
Martin K. Petersen	Oracle Linux Engineering
