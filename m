Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB553451C8
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jun 2026 02:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780366261; cv=none; b=BILWV0+LD7R+LTgzFfPrJ9wKBXl/uAwMZ/7pryotg7Av7wDgPsonVq3mLCbHEhDLTSpVCexBQRgqiD8mPfdHevpfbedwOzFhlBjomh6SZB2gh5HzK7KwxuoSu1fwtQni5fINfw7rYG9UI63yei76/4YkjAPlAAWr/RWi+T2I7zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780366261; c=relaxed/simple;
	bh=Ft/dp/BZwPxW2LD+NIzWotFv4UqBP8NOBUAECxo5HSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jwUnBJsLaKZwsLqfuPXHDWLUQGxRusUF1/VBNaLMXhGBDVqKXsQGrdVw+8sRCO89lt6Z1yI+ZWRJNvJpiDGK3ZT9LSKxoPwqYLwwbC4w5UqgZpyE1KNCJhVe+cq/RyGnkQl3Eprxnoq7LtLTnR4/TlWtq4QWjGwW99oQmmDvFmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UayhLSra; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UayhLSra"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 651GtgeR3465796;
	Tue, 2 Jun 2026 02:10:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=EikQX0kh5GMFXzPQhf1MjzrEZhz9bfLUe+bgBz3KA7w=; b=
	UayhLSraWKLtpISaZaZZOIR4/dZHlhj1+tXcLXflqQ/bHIDsw4d6qePNEOKEtD2w
	Q9V25KErt6xnbCHKaNqZI/gkssdi4rLy+grAq7Pg0aGoQ67Sy9GCKziAkyb4z415
	3BksEAGao/XAh4mWY546JUhqxCp6bGZW3ZmOWBcurCMAVs6hR6lOAooKzFvRYFbF
	OsE+wkMl0cGN3YWDEQxzgn+yOJCnsfpOp88ZAmrPrhmc//hhikLPpCi2yfLfEbtP
	4SXwM56ftOEeNSdRmavVflRKAZdCUkfBj0cvAgQMZ2YoaxLOEceLOPOK//5/sKUC
	iTh33MCo+AvsjU+jl6GWlw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4efqxdb84p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Jun 2026 02:10:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 6522A5Rc020253;
	Tue, 2 Jun 2026 02:10:55 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4efpbc2wxu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Jun 2026 02:10:55 +0000 (GMT)
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 6522ArC8023303;
	Tue, 2 Jun 2026 02:10:55 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4efpbc2ww0-3;
	Tue, 02 Jun 2026 02:10:55 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 0/3] ufs: core: Optimize the UIC command implementation
Date: Mon,  1 Jun 2026 22:10:44 -0400
Message-ID: <178036282202.1628204.1350880365708576618.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260519212135.3130556-1-bvanassche@acm.org>
References: <20260519212135.3130556-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_07,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 lowpriorityscore=0 adultscore=0 mlxlogscore=808 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2606020018
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAyMDAxOCBTYWx0ZWRfX7DEXkiX/g/Z5
 8NBgzKbSiSUarig3HvLej5bqMYFFUrtd+jdXpc/ZPfJTdpnISvA7jlGQKexuKfV7qzhmgGDWsnx
 ZKHuD23GMuPb/YOLelxeEDnYyZADhs92P7kUL4opg5g6mLlYMR0bwIFGVLCI8HGZtSJILzbJdxq
 jS3KNMz0L1fbe6Ut8PVTSqpVG8YQN7m6dExXqEij5nXQKT/LwM435mgpCkr84MzNDpZE9orfWR5
 izXp73ovbpcMJS9yAh56Vi7v8qsm2uOxE5hvOHe44oBtTTKUDX1ENev1uX1mG24Gk/nON6YxrYn
 dK59f8zm20boHNZVpL4We2/RhL4BKWxbM8h5P2oE+BsDNWChCOsXBM8hJzy6Q+KdAOlB2u4ZR2q
 h3xiRkL059v2R45nNFZK6p5UnW8/XM309qufyWmHY+qgfOzUpqWHuTph5CqgiGMRQ+KhJalDGJk
 NZNq5IzNGVNPWrs/E0g==
X-Proofpoint-GUID: gp4Dl9xc3REWgRSe9dMqo63xPCDjpxvo
X-Proofpoint-ORIG-GUID: gp4Dl9xc3REWgRSe9dMqo63xPCDjpxvo
X-Authority-Analysis: v=2.4 cv=Po+jqQM3 c=1 sm=1 tr=0 ts=6a1e3bb0 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=ndFNgTagABYcOeMgRLEA:9 a=QEXdDO2ut3YA:10

On Tue, 19 May 2026 14:21:26 -0700, Bart Van Assche wrote:

> This patch series reduces the number of readl() calls while processing UIC
> commands. Please consider this patch series for the next merge window.
> 
> Thanks,
> 
> Bart.
> 
> [...]

Applied to 7.2/scsi-queue, thanks!

[1/3] ufs: core: Inline two functions related to UIC commands
      https://git.kernel.org/mkp/scsi/c/727e78887e62
[2/3] ufs: core: Complain if UIC argument 2 is invalid
      https://git.kernel.org/mkp/scsi/c/9fb4c793223b
[3/3] ufs: core: Optimize ufshcd_add_uic_command_trace()
      https://git.kernel.org/mkp/scsi/c/f8380c57dcff

-- 
Martin K. Petersen
