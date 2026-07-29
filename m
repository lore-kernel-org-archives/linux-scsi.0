Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A73391E7B;
	Wed, 29 Jul 2026 02:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785293797; cv=none; b=SXtNnadiZ6ja6hAnA3IrOFSy9RKNKDAuW/2Vw+NFVNbsJb4U5pTOhOh9RU905SUSAth6pKprPwBiYpWRyd5rC2uJxwuSzya7IbbwLNhz/SK52dJPkdzBYoZDG9ft2EXNGC1tFOB13p8DjA+6B3UVv6gTZ8BeMSbhY1XgKIEFDlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785293797; c=relaxed/simple;
	bh=50btgkuxS1/iFD6/Fl6tT1Nf5jQjnrdN5i2Fyn3EJaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qmPe6eZLEMGhS0pKV7lFVX64zA9co7CUxow6VWbQ4SMbu4SK0QR7U5D9C0y2I0F8S9kHf1FTpWPf+yAmHzEOm1/Q6VAkJ3Qq7oDaWNTK2fO7B8npaMA5qWhUwRlTXyaouKPnODsJJcSvbElwgc94yTeftYyjNYChIA/crTH5ZA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=r6jpxhgB; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="r6jpxhgB"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66SItWRG1120904;
	Wed, 29 Jul 2026 02:56:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=dKQAJWggTgQWiVcrPSOVkQTXGHhAnluQ+fdwzTA1Vy4=; b=
	r6jpxhgB+Vc1/CYFcX6/GTCnEJRFqg4PmxjzwnpJYhsWzxlUOT8NJM9aQT2LcMLO
	diobAsl3pMVtUo7dmWG36EN5KbFnvfb+wNYw3gzDheE9Bk7Mnn3+cvujLXZKmwLh
	BjDCYMv0f5IW2PkT2IOFfj4jJgsSLpRIloI/3lrHMTHAGqdGlRlzzXPXM4G71L99
	QBZzpYrw17hbUkUL2BaNFNQYDyKsvWIaTWJGGJZaSf5VIwvUMjpxynkUCHKzDy5P
	hXQVhpoQBqSeozNAdBHlH6t8ifFBuDkjQIu+NRldursmZvf9NksbHLON1AQStcvl
	yKkI4VErX8isXye1FmCoZQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr5nn52q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 02:56:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66T2oYUg034565;
	Wed, 29 Jul 2026 02:56:26 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6ddkrn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 02:56:26 +0000 (GMT)
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 66T2uMAD006812;
	Wed, 29 Jul 2026 02:56:26 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4fnh6ddkq0-10;
	Wed, 29 Jul 2026 02:56:26 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James.Bottomley@HansenPartnership.com, dlemoal@kernel.org,
        Ibrahim Hashimov <security@auditcode.ai>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, bvanassche@acm.org,
        shinichiro.kawasaki@wdc.com, damien.lemoal@opensource.wdc.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v4] scsi: scsi_debug: fix REPORT ZONES alloc_len underflow OOB write
Date: Tue, 28 Jul 2026 22:56:17 -0400
Message-ID: <178529373855.132455.17231948294601118688.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260712183739.83915-1-security@auditcode.ai>
References: <20260710055755.53830-1-security@auditcode.ai> <20260712183739.83915-1-security@auditcode.ai>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_01,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=973 malwarescore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607290021
X-Authority-Analysis: v=2.4 cv=OPsXGyaB c=1 sm=1 tr=0 ts=6a696bdb b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8
 a=rm27UfJz-dtlBx3NcCgA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13517
X-Proofpoint-ORIG-GUID: LMK2a5OgsU6TN51mU9lQUfSPnaRvUv5h
X-Proofpoint-GUID: LMK2a5OgsU6TN51mU9lQUfSPnaRvUv5h
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDAyMSBTYWx0ZWRfX8YUFKVQS8zI5
 bc1mz4ZDYJY7NlidVphCalllo4S7sK+rAYW9AbIgqJ6g43Td9kMCKyYM8Jg8tXEcc9p483kUR9e
 A70oWU13L+bT37fQOsiMqrLaFQ8n3/qzwghzLagPx8tVGwA+X1+F
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDAyMSBTYWx0ZWRfX2Hmt3BjqAUDU
 HCwNZ76iiPp+bh32D0/wfRGDSVhAFblnmEfYS8a65AeLVPAXLbDYuU5lLbk4Zvr+C3RE/CGZ5it
 vJiZWEThc7UivV6BFBLnj90Q5UCEQjsdJqH7T8QbY35Ich7U316ksliUjGEeyawfNx5soCNuNlr
 lU5XxZqZjdHJHgXyMIhBKPBfzQ834QBicvIEzS60t063+gbwqitvLWiTnu8BTMQ2YwfyDRoPOn5
 iJRkUYFZzXZQkz51bsWyBvgOHK94U+/BCdYDpN/Y0fzljoS5+PB4m1uQjQCRV8Es4BTXOs25fkU
 YqRVPduWl5LkGl7lHwGcO+ZCG6YoXH2sTRb+FgZnSBL04QZpjh3/8x6we07gMK1045XAUtU0+QD
 PV58WVIhTkj9TAFvvBv7lMCel+nsmf1OPcxdqPUvQ75fauCnbVGaFLEIqf84GP6tL+yY5DnzZgg
 QkbWY+IYkWI/AT+49QOiJJFDBgN01+FSzgM9EIJ0=

On Sun, 12 Jul 2026 20:37:39 +0200, Ibrahim Hashimov wrote:

> resp_report_zones() sizes the reply buffer from the CDB allocation
> length. The v3 fix rounds alloc_len up with ALIGN() before deriving the
> descriptor count:
> 
> 	rep_max_zones = (ALIGN((u64)alloc_len, RZONES_DESC_HD) -
> 			 RZONES_DESC_HD) >> ilog2(RZONES_DESC_HD);
> 	arr_len = (u64)RZONES_DESC_HD * (rep_max_zones + 1);
> 
> [...]

Applied to 7.2/scsi-fixes, thanks!

[1/1] scsi: scsi_debug: fix REPORT ZONES alloc_len underflow OOB write
      https://git.kernel.org/mkp/scsi/c/93dde0bf2f39

-- 
Martin K. Petersen
