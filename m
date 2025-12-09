Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7EF30146C;
	Tue,  9 Dec 2025 03:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765250503; cv=none; b=d1dfWbavEJxS+xgCWnuQ5fIm02egaxPnZJtEITjQ0fmasS+/l3clC9tUSKiGJl7G1nOKPNDxdfzgILLMeo1JXRZjlK7NhWQJ5WXP+9gApdivid6S0cjrPWvSvV8BzWjHT4SAnIrUkdSZ0pWFdkUEplpdwfFluFfWDtXPSyEFNg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765250503; c=relaxed/simple;
	bh=2BC7T9zzsfJ67q9x74UQFb/K1k3yGr16Da5Id9itEH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Da+/FkpPGAA9ypBIspsXVcGJVT8yvcIhykrpzilKC/hFg7rIsOYfbL25CYvmaNvGERxfYwQSFE4TC/66RQsBecDk8D2/s1sSWRa3a2SVHRAOnNIJ9u9LL06Rmd7D7MyjFonyAB1UNSkzT7ldAuaLcgC/CJ4T6QtCvWuHjjxF4os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DfIKlCFi; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DfIKlCFi"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B92fkPx4149799;
	Tue, 9 Dec 2025 03:21:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=PZ9DvVAzHbBX6pwCyMAeRMaVVj+ZB9j9NWeCUy4KoQc=; b=
	DfIKlCFidd0eS2zyEE2QCopaWRxiooIiUA4yZ5ce4zFom8JH94q07jsV2+lfl/M7
	Rw5vq22oo+3x1popL4KUbh/gQzt7szTv6Mt5KP8hmpzjuRbscTSpz552AcA8zb9n
	InfAW7/8TAC3BNTpPCCuqQOkvTjFFhUbqc6N/6/jJgF2Hx38zzw7uKdzCbO/3ohV
	+ITpOlCWx+WjMUCkXL8VqQwC8YB7ijDo3jhTk6NN2aou1/01xbbh3YZTyFv/qgPy
	NYWv2pXEKwrNNWDfawNjTdrX/riTK8VMTjZFbzRxahk4QgzDwyDzyWPXp48BdTDP
	5YajlzxtKr3c9OgCBshX5g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4axb7500r7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Dec 2025 03:21:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B91GeuB038425;
	Tue, 9 Dec 2025 03:21:20 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4avax8j01n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Dec 2025 03:21:20 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5B93I4FY022652;
	Tue, 9 Dec 2025 03:21:20 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4avax8hyys-6;
	Tue, 09 Dec 2025 03:21:19 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James.Bottomley@HansenPartnership.com, Miao Li <limiao870622@163.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Miao Li <limiao@kylinos.cn>
Subject: Re: [PATCH] scsi: scsi_lib: Correct the description of the return value for scsi_device_quiesce()
Date: Mon,  8 Dec 2025 22:21:05 -0500
Message-ID: <176524933126.418581.4093701419923571601.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251124075444.32699-1-limiao870622@163.com>
References: <20251124075444.32699-1-limiao870622@163.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-08_07,2025-12-04_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=966 bulkscore=0 spamscore=0 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2512090023
X-Proofpoint-ORIG-GUID: OYUHsdk1sBgi7l8dOCCuuIV_1wwQTCU_
X-Authority-Analysis: v=2.4 cv=KqBAGGWN c=1 sm=1 tr=0 ts=693795b1 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=HBcysWutQPUIF9z9UvAA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: OYUHsdk1sBgi7l8dOCCuuIV_1wwQTCU_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA5MDAyMyBTYWx0ZWRfX4WHfRuHv5O2p
 9x2FKDzgPAY99pb0a7gQLvWWvyZjs3DHaqqSWQ5CZDhOxA+ABMhD7MbjDgLemOoni9fjH/3nZ2e
 47cqYRjoStHu1cVSX3Z1lr1oycxlIqCo1ZVbggAGB4v0Tt2ROUhX2+I2LuNfSFuY6CphUny9cbn
 qvGyjm8uEDshR7FeBZa4h0q/qi861Ouv5rLQPOmhqvIvG9fHDnXJ6t3j1KwhDh4OSjrh1N3kat5
 IQ0IboP/Peryb7CKS1vnx/AcCFSPG8fQn2Axwsh5yOOrEN7aqhRSIAwOK9l1mRy1/y5aGhRSkIq
 nKdaMdrrZb6s1g6TTuldFPlZqKvlzqLzDyuDHfvcwxKqyBKJefwe2tuCIf+TaTC2SgEhSDIGs+T
 Y9WP1PArTgCi2TC2/ISCMC/XI5ETHg==

On Mon, 24 Nov 2025 15:54:44 +0800, Miao Li wrote:

> if scsi_device_quiesce() returns zero, the function executed successfully.
> 
> 

Applied to 6.19/scsi-queue, thanks!

[1/1] scsi: scsi_lib: Correct the description of the return value for scsi_device_quiesce()
      https://git.kernel.org/mkp/scsi/c/c131c9bf98d9

-- 
Martin K. Petersen
