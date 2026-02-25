Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB8326560A
	for <linux-scsi@vger.kernel.org>; Wed, 25 Feb 2026 02:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771985327; cv=none; b=T+b2G9SEOxh2kOdeQK00PwMQ5UtXljWSj2BcL3p0fSxfrBghO1mb5MtSEACOFvttpFODYa4tEyVNhaW0W0fLsUVVOQFLZgSUV+ot/UATHB1DQ/bBWwlqvop3vJ5x6uCamhD2wKoUtxbZ5VlJNW+5lsJmYuopfQ20xdoT902lY7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771985327; c=relaxed/simple;
	bh=VkCuI/G0u0qDhrNtxgAgKWRQp06DJJXTgxTu8OXKRwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OmIVvXMIs5zQ67c1tN0Uwoqv1PfUumz+MemiRrFxiqYQX+6UaWScC3wCkSOLU6YIKGvLq0Q+yCf+k9Chb5VkxUjH2wQUbHakaOHbTcen01xh1EG2f12X60OODVxE6KhkoUPUvPfVzbh41aovV01k5KsRUkpkkiLvKDJ8FSfELAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dzqsBBPe; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dzqsBBPe"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61OItxKI553150;
	Wed, 25 Feb 2026 02:08:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=jexq13pqC2EZm52QNf6VPpZ2ZXjEAlCveI75dZSxQO8=; b=
	dzqsBBPe9ClHvPbOdNVm6dvQnJd/OB7sOmayIiLW8DRu6wTanxU5QXVxEDoOqgDX
	3DRMU7lmx77gMOuIdtblk5KYGfW2c324uOmbpnyA46V3MHxUEzH3Cqc1RidxF46t
	3lWCuzl3CDRPLVsJkoktlw+5e6xB9mt0U28YGvdBxmISAgua4OOyR7mvxB2U+sbb
	DWjZShBaOgoUUq1fwD4AEcvIq8ai22KUaCSauEWa7hNmbmmk6MprCodxk15gF3sy
	3WA39Eu4tmdagTCYhckus6c7SIcwRsSfN+mZdfRTTM1BIUKD8mYZal+aOc3FzFdm
	+UlkiLYt8OHR7CS73DP1jg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf3g3nejk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 02:08:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61P10oi5015743;
	Wed, 25 Feb 2026 02:08:37 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35ar24v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 02:08:37 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 61P28YNT029537;
	Wed, 25 Feb 2026 02:08:37 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4cf35ar1yt-3;
	Wed, 25 Feb 2026 02:08:37 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        WangShuaiwei <wangshuaiwei1@xiaomi.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
        wanghui33@xiaomi.com
Subject: Re: [PATCH] scsi: ufs: core: Fix shift out of bounds when MAXQ=32
Date: Tue, 24 Feb 2026 21:08:05 -0500
Message-ID: <177198526957.1649777.17327613686157442002.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260224063228.50112-1-wangshuaiwei1@xiaomi.com>
References: <20260224063228.50112-1-wangshuaiwei1@xiaomi.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-24_03,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 spamscore=0 bulkscore=0 mlxlogscore=841 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250018
X-Authority-Analysis: v=2.4 cv=Y6r1cxeN c=1 sm=1 tr=0 ts=699e59a6 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=nKQEoseQ2CVAKv_AYDcA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: L4SPIvcXtUEpUKzc8838cIOZX_JG3ehx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDAxOCBTYWx0ZWRfX1b9LS1aY34vI
 UtIKVQBjBc2GRlOUUX7aFRECVVf83Pw5bhvRsqWIBWiBgEEs10tdpWaurobyduacNrBZKH254GJ
 u4C458AU4VY+hLN/bjyxaL1fV+2r7mSiiHBAwCx4FtgxJHpOwSJcK6ukLleTGBTlA70kitk/HXL
 +W4LofjOiUMkPqfEh5xbJTkDZBEpuXmYrM82GV8UzOLNb0XwRSEPS/L2cjWGhXCimz1xk7GzpG5
 TYKbSIXXp4LOECRYEwrYqxJKEsg6CzdT5oGONYGXxGbwMqNo9G0ASz8BKd6cOdSLPpPS/WmZ6s/
 ixShqXL6eLgcFiPuviskp7rISkE6vkAAkDCrZUJAmbJdW0jakDpo35ZwEmxSsRnlXve5NhPjXt7
 JMp2kNmhPGvzYy6mld+ezX9/TREprmsk+IO+G1Dx1HxK2pho0xWGAOsZZRYZb4Zirl+B90w+cMM
 rI0VsfYytf4vAYjVUuQ==
X-Proofpoint-GUID: L4SPIvcXtUEpUKzc8838cIOZX_JG3ehx

On Tue, 24 Feb 2026 14:32:28 +0800, WangShuaiwei wrote:

> According to JESD223F, the maximum number of queues (MAXQ) is 32. When
> MCQ is enabled and ESI is disabled, nr_hw_queues=32 causes a shift overflow
> problem.
> 
> Fix this by using 64-bit intermediate values to handle the nr_hw_queues=32
> case safely.
> 
> [...]

Applied to 7.0/scsi-fixes, thanks!

[1/1] scsi: ufs: core: Fix shift out of bounds when MAXQ=32
      https://git.kernel.org/mkp/scsi/c/2f38fd99c000

-- 
Martin K. Petersen
