Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A782107;
	Sat, 17 Aug 2024 01:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723858652; cv=none; b=i7PkVb20QHAUoq9MrS1OZv3zl9TrdkW8FeQe1+ggF1bjgeA/Wz1Ik5UBpqA7eT51YuoQ77cUGBMONimqR2+FoixLt491qmkCoIC96PIoUaGIITTG1nxOvBuPqs80zsosVovtkYUONhQvhHf8h239wmZtb9wAHtE5DDQVOy6Dcbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723858652; c=relaxed/simple;
	bh=9bXYrOSpLpwSu3NTZqGWX5OwdJ+YGlI0b1S1z6OcmjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=urJqFght+MqX8Mc4E0qAg/6keaXpoYzXLJhhAMfJyOEgM5ePgJ93ptRnxCEVgSKq922V99111pCk/yAFxNvVVDWKs8OhZZ3czON7j13ud8B2m1oTo/G8PQkISg7E796hNsexms4zHPTnMYJ2H9rEbcGfoMUcjPqheVyekHm2RrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=m4U0rd0B; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m4U0rd0B"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47GLBu8p026425;
	Sat, 17 Aug 2024 01:37:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=AeHnEIXp2Szc6hQ05+u6MeQ3QzfrOXjk31HYAl9lorI=; b=
	m4U0rd0Bk6GAJNpIdEMqOhq5Tw24FY3tv25TkVnV7PpF8fkYNFCHLgqh8XVdme+b
	HTBsdu+J5IHBs7nlYgH7u/9qZNZzw7KLjt9LKxozV1JaTQ5e338j9jZ8zUuc9Ujl
	A4tbnF2hxiSNAYdBq9vba7Kf8XZfYhZAmPYaIMjlj6ggElrZFCGHyWeLOV6bLonY
	qjpuxxLrT5TmfWWW1A8HiV6kOhHWzFjLIhDezW/8ChIJ4AvrBiOHEGFOGBilCyz3
	Zcx0NHj0W9YXG967VNoD6rX1AN+96nDYyl1pnS7I6P57bU9Y1WSxfr4cOdHiiiVs
	9qZyWb2vLmb+pYCyJpqrRA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40wxt15rr1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Aug 2024 01:37:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 47H1XSuB034948;
	Sat, 17 Aug 2024 01:37:26 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 412ja5r1e2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Aug 2024 01:37:26 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 47H1bQS6001346;
	Sat, 17 Aug 2024 01:37:26 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 412ja5r1dy-1;
	Sat, 17 Aug 2024 01:37:26 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Karan Tilak Kumar <kartilak@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Pedro Falcato <pedro.falcato@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: snic: Avoid creating two slab caches with the same name
Date: Fri, 16 Aug 2024 21:36:51 -0400
Message-ID: <172385819630.3430749.8896357739520780911.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240807095709.2200728-1-pedro.falcato@gmail.com>
References: <20240807095709.2200728-1-pedro.falcato@gmail.com>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=661 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408170009
X-Proofpoint-GUID: K87Fbphd5NtPnqhNokYFRjUssLEpcdUF
X-Proofpoint-ORIG-GUID: K87Fbphd5NtPnqhNokYFRjUssLEpcdUF

On Wed, 07 Aug 2024 10:57:09 +0100, Pedro Falcato wrote:

> In the spirit of [1], fix the copy-paste typo and use unique names for
> both caches.
> 
> [1]: https://lore.kernel.org/all/20240807090746.2146479-1-pedro.falcato@gmail.com/
> 
> 

Applied to 6.12/scsi-queue, thanks!

[1/1] scsi: snic: Avoid creating two slab caches with the same name
      https://git.kernel.org/mkp/scsi/c/ff30732014f5

-- 
Martin K. Petersen	Oracle Linux Engineering
