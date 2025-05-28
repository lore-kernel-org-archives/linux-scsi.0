Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4E141DDA09
	for <linux-scsi@vger.kernel.org>; Wed, 28 May 2025 02:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748398860; cv=none; b=BVs4C9BcMKohAxZ9PD+hgrd/pRkDkxvw/xVzCSvyCSNfiytVeRtreh5EN60jRPJPVvNTam7SdJWibnfde9/7dw05seWTkJOQowCCL4R0ugTSB5Phg7k+OONSNrL8B/3UB47qTrq8hU1+L3E/R+MyHhlMWs0lhG2jLOq7UMMOzP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748398860; c=relaxed/simple;
	bh=ei1712Gnm0YeQj3PYvx1iey3UbAwzXnVNTBNnxnwRQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ij3M59RRCoj8ycUqxWGuqMJ6T4I7CR7c2g6oJzfxpDpKptbSbAoMMqj59YVsfnN3SbEJpOFgaHJuro84z+91slbaGWQ6J2JogZLGwsWVSHsldVFTpMNHOZnuKXRQrqjuUyKxoWsdKuG5CKD8HEGfIrcscpw3X9SVt5F8k/Lf0Jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Xe5yQxGc; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Xe5yQxGc"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54S1fwlR009583;
	Wed, 28 May 2025 02:20:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=eFU4+GoX+dm9+lc+clPYv660j6s3GUbzXNiuUAUMx1c=; b=
	Xe5yQxGcwVVUfxt4n7p7bvs5em/WpX1n9spxHAkIjIIrmzB6fLlTRvzRLKhZl0o8
	rMr9jVGePpcS1Xjmkp/EXDDlinxcItpKhjDBWkjRWoihnOrxBFHVyGdWMIE5hvo8
	RzP785ZeMCS9qd0Rg1cszXYhg9dMJZr1WHCBhHHCZsgGQb9b4wPNmuGsB3Z2hdKD
	8WdNPZ6ZtpQXlHmFCLMAHIA9wisysXX+thJc/Wq4eW/QvDiKRVgnqApGezT9Cf74
	7yJr9daLqwzUzV7H5eAMQ2T6J4HOL81Y8qW2liguWHcU3GYhqTb0L7KdLyQAMB1I
	g9A4ziWR1iVt0+CI//ygUw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46v2pevqgr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 May 2025 02:20:56 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54S163UA021123;
	Wed, 28 May 2025 02:20:55 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46u4jgb22n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 May 2025 02:20:55 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 54S2Kq1E017834;
	Wed, 28 May 2025 02:20:55 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 46u4jgb21n-8;
	Wed, 28 May 2025 02:20:55 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        sathya.prakash@broadcom.com, ranjan.kumar@broadcom.com,
        suganath-prabu.subramani@broadcom.com, sumit.saxena@broadcom.com
Subject: Re: [PATCH] mpt3sas: Fix _ctl_get_mpt_mctp_passthru_adapter to return ioc pointer
Date: Tue, 27 May 2025 22:20:22 -0400
Message-ID: <174839736815.456135.734202073937596976.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <1747213781-31545-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1747213781-31545-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-28_01,2025-05-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=997 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2505280019
X-Proofpoint-ORIG-GUID: FzmR3v0O7TNjGwC5mAxCHWwqHieG-Zqk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTI4MDAxOSBTYWx0ZWRfXzlTqHRCYFbFM HK+RE1BaA3gN4jfRhOjaa3ly0AYTmQF1UIK8rqJBjrWxfCKqCbJgnh2wbSxintHuWwy3pgznWiS 69Wm5PeYHyJIN7NwhO1YgyWWNsOglpUXFsJTZPCEL0gR0oKL7vGRID3hFyg/A3Lc0UrSPMahi9V
 92MeN3lsjWw45hiadpThMYqpIIURGa3LGXfz69ONaeg0MhucMlVabuXmWEHT6WaVvjP0b/JWqRh P2xvxs8VDeoQaZuDd1hx7Nb5XRHriZyGV519IF1vqUf6h0/PItdzHx4J/jSpyz7Uarot2QLDW1y nrEB5Rt97hkTz+zmyUFxwFBr0xpfYuXiUsfOQV56qbIf8yT/esDJMrqxrU+IvVC/cRDgWwF6QOI
 Fn+417JS0W826uLJjsWrIBCw1QnqJDZ7hPl3Uxye6jcJGCJF2Ryfdb5TQN3sQasVCXfytgk8
X-Proofpoint-GUID: FzmR3v0O7TNjGwC5mAxCHWwqHieG-Zqk
X-Authority-Analysis: v=2.4 cv=TdeWtQQh c=1 sm=1 tr=0 ts=68367308 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VwQbUJbxAAAA:8 a=My-Pt_pDO9S4dbDxluAA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:13207

On Wed, 14 May 2025 02:09:41 -0700, Shivasharan S wrote:

> Fix _ctl_get_mpt_mctp_passthru_adapter() to return the correct IOC
> pointer to caller based on dev_index.
> 
> 

Applied to 6.16/scsi-queue, thanks!

[1/1] mpt3sas: Fix _ctl_get_mpt_mctp_passthru_adapter to return ioc pointer
      https://git.kernel.org/mkp/scsi/c/9ad5249b37b5

-- 
Martin K. Petersen	Oracle Linux Engineering
