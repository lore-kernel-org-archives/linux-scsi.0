Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E8530B53C;
	Tue, 14 Apr 2026 02:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776133178; cv=none; b=axpx+hLBXsxFxTLgt8kH7JoJkQ1Pfr7bceLXRWbV0yFTle9NaKlsNV4jCg52CQO0YxRX9A75FtWKL9/5p1cAWBJtlAXbjhqkELwcXydqa/Tb1ssX+F8crr9DT0ZWiIiDxnG0hluXls76gbA6x6dWhn5GHeQ79MwDh0GgkGSf23c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776133178; c=relaxed/simple;
	bh=jb2tsl1y1ZRAOKU6z6K0SrfwzfNDrRLX8MzILuoJlmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EwGJxmzR3I9akCIIIMvMHqXNAYP940TlkN5V0SN3QUP/GZ8GEz1OISgy9XgnzIZzt0eJcocVHckuk33mso0A+XIvbutSlniTiSRE4wQKTvCQprB6SVMaP8KRl3F8MbwtZbJS96miaXGC/VDVA+XD7XCqqipv5OwQ7+WePXORK+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AvKrtRsC; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AvKrtRsC"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63DLABFT1233819;
	Tue, 14 Apr 2026 02:19:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=1lD5a+gjuF3RFooEnR0pUG5eUhfVM3HXUF5PHgZncrw=; b=
	AvKrtRsCXpt0TEIf5CazofCFMRuXwZgUGVFYeHNVlHxijRld9hWTSeZxW67l4L/W
	l/9boh/LVxuXyvkb+qGJfLm8oE7IrrQcbQLaR5FVS2nFG59i1u78vnbBL1J5k9kL
	xqfhlXnkczIRIW+Fvm+X8VO5VnBuVQInY0s7pVDMGpner2rzmDWhsDN6zGb+nqq8
	n66o6qi6xD39uMwJDDo4MxYUYQtmKkB9kVYRT4qJSE/wHhfoflXY2ooiIeqIkxTG
	x7wDdKB9eIqUy0sPoCNR175UQihFpvKDbvhAcVtuY6Qr2ZstmPPXhE6EoMNuSpe3
	o6PYBZCASvivYw+kW9ljmQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dh85jgawt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 02:19:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63E2EJDI023504;
	Tue, 14 Apr 2026 02:19:29 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4dh7nj0nrr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 02:19:29 +0000 (GMT)
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 63E2JTjb036955;
	Tue, 14 Apr 2026 02:19:29 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4dh7nj0nr0-1;
	Tue, 14 Apr 2026 02:19:29 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: sathya.prakash@broadcom.com, kashyap.desai@broadcom.com,
        sumit.saxena@broadcom.com, sreekanth.reddy@broadcom.com,
        James.Bottomley@HansenPartnership.com,
        Claudiu <claudiu.beznea@tuxon.dev>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Subject: Re: [PATCH] scsi: mpi3mr: Fix typo
Date: Mon, 13 Apr 2026 22:19:15 -0400
Message-ID: <177595422529.3963380.6906072502609245466.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260403133109.2744351-1-claudiu.beznea.uj@bp.renesas.com>
References: <20260403133109.2744351-1-claudiu.beznea.uj@bp.renesas.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-13_03,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 malwarescore=0 phishscore=0 mlxscore=0 mlxlogscore=790 spamscore=0
 lowpriorityscore=0 adultscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604070000 definitions=main-2604140019
X-Proofpoint-ORIG-GUID: XaD2_p9mXvRwiDoVh4ol0xmDnII1RTkP
X-Proofpoint-GUID: XaD2_p9mXvRwiDoVh4ol0xmDnII1RTkP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE0MDAyMCBTYWx0ZWRfXwXs+H6rETSY2
 DfExdgsWpKzkaZQTq94zeYKDsLVtTaQIvlcGpcNJtlKeKQVPrlhlsFfmyBTZPoOs7rolvmLETXD
 OnWRc8/pA8mqdb4ynjamVGYxwBUWdn3Ip8jE4D4Ne+yoco8KBPb7zNMS+9lG1uU01KC99t5vHwl
 pw0o9ZLTl20J44yPGyoOAOYDkz1GlGtfcLPUYDY0gfac4fN2KUvqQY4ala1wHq4LmA02xP7ni//
 1eXr+LtCGW1jLcbvlJrLzL0YPXW0VPY4cmjXwnQ0QvsfM5o4Y7ZwOZUX50ZnPqZ+nJD6c3gCKkV
 yI2m9rX90el5JAzydT1K0cZKt4xc+L/wunPkBkGNQQim9w5UPlgPXiTEGCeQp63s+4dB1OoaOsx
 HFX36FXymXuS1wO+MPuzyYXDrYKQxTuZ1FLR76v+33vrgxFwJ+ACWgbdXs3O1I4quidRu91FTZE
 UQ9IVf/6IFM3VJsdmWA==
X-Authority-Analysis: v=2.4 cv=Co+PtH4D c=1 sm=1 tr=0 ts=69dda432 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=OEaI_fKz8m4pCk7--TIA:9 a=QEXdDO2ut3YA:10

On Fri, 03 Apr 2026 16:31:09 +0300, Claudiu wrote:

> Fix typo in "synchronize".
> 
> 

Applied to 7.1/scsi-queue, thanks!

[1/1] scsi: mpi3mr: Fix typo
      https://git.kernel.org/mkp/scsi/c/03a5e8ec68d7

-- 
Martin K. Petersen
