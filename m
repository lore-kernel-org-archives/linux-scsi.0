Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E059390CA9
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2026 02:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785293792; cv=none; b=SUgGgXth+38TyFivgPnJ7H8Eov0bi4ow0dS0oGxwXsdsH3P0JBO9CLnTPfdJCE071y7NqghddSNzBRhUPLRbs7Gv/Pl9ibQqILX5RvhWfozmUgIT3ls7iKxH89eFH5oOcd0UmeuZQMOlBF3XdKDSA21PjeHSi36X1HRXaq2coQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785293792; c=relaxed/simple;
	bh=9/Xfp/megs/HvpKNpgd7MEMW5A4sz1UaXDC9lL7sS2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F9N14MZavlO428wJ6ZC2Lg0EJlmSx0GoxNpcjMwz4gn3saO+KWW6X378zRt8x+hXdVVPMRqNy5AXB7Ws56RyHYaLWkmBqJf4zGHRL71sOa9IEFydbSpuaSEC5diLHZjwJU1XiMFRH78lGDcZ6Uro/iywtlQv3qUmvguNN+tZowk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SNEiCVU6; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SNEiCVU6"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66SItZQU1401794;
	Wed, 29 Jul 2026 02:56:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=KVFfWe+cdD0Nu9iQC16hmsKcbDtOLzI0K8kfclyxDVY=; b=
	SNEiCVU6xdZEepc0fN6JKfd2Yk0ZOH/HYeUcjIdk7gcfIG31A+vs0ZMaVqto4KhE
	BV3vx0rkGvam5Fqk+mEf/ED0391wjFw97/CezSuMOn9sk63wzfrJPC6rTA2oeyMk
	nooIl8tHArlqpo52tcQI99SobgYh+x9rjZ3NQhAk1K5jhUXa9pBAOr0NwQgQr31h
	J0ewhjMYUh5Hn1gtYcqroO+22cXPS0iuhhjStbkoyKLj82ogbgUTsaVv4KS33gf0
	0YfLM6Jh5OU4RZUKzRWKimfp0jApQyVzhJfYEkASYVwFLlSPLmXUkwVbp7dg1lJx
	ph+5SV6f78sL+Xu0RL00ig==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr0158kx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 02:56:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66T2oYJc034542;
	Wed, 29 Jul 2026 02:56:24 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6ddkqp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 02:56:24 +0000 (GMT)
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 66T2uM9x006812;
	Wed, 29 Jul 2026 02:56:23 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4fnh6ddkq0-3;
	Wed, 29 Jul 2026 02:56:23 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        sathya.prakash@broadcom.com, sumit.saxena@broadcom.com,
        ranjan.kumar@broadcom.com, vishakhavc@google.com, ipylypiv@google.com,
        sashiko-bot <sashiko-bot@kernel.org>
Subject: Re: [PATCH v2] mpi3mr: Fix potential deadlock in mpi3mr_fault_uevent_emit
Date: Tue, 28 Jul 2026 22:56:10 -0400
Message-ID: <178529373876.132455.17394199846097510846.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260724175231.935192-1-chandrakanth.patil@broadcom.com>
References: <20260724164630.924288-1-chandrakanth.patil@broadcom.com> <20260724175231.935192-1-chandrakanth.patil@broadcom.com>
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
 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607290021
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDAyMSBTYWx0ZWRfX2mZ241ej80uV
 ejPiYRXsFoIjxs4tP576s4w8gnZXq/sjZLeumoRT+8H3ldvH5tIWeUebOLB4+wqRofCiOMzKaTh
 YOPeByppz0csRjfjGeIjFPPGQCVdKjfsoseDPptx4RPMhcWwhHCO
X-Proofpoint-GUID: yz8K0ibqCcH_VZ-eWvehtKCbr6KNqP4K
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDAyMSBTYWx0ZWRfXyrqskrls90nr
 BSt/OJ7aCpNGHaBA4cbgdVeevBJPX2qdwOSJ1GRjHfmX6XwRMCEqXC1rNbUerzaOMYafdSjEYEQ
 ExYKMRqzyTcnKq1Ysfnue57hyakJs/na7lsx5vHnueqizyKkv6klFIynZUAQ5aGZDoGa3mWg/uP
 J810+UchDJ7YX3lC9kYscOr13GwKB1FzbPGYssGhMJQlOSyJPT3xG3Wrq51rMfOVBCRDOMOozWa
 WogUre9ovHblMVOZDvwSyzcFev+GC+dE3fwXKbIqUALXgh7Y2oAIZTT4M/C8p9LfWOj9uzXY8OQ
 x0+Cy8WVGWo24EnX+w6aj0bDArmCfaFz8zJsJKm5avtViMgkOuPfBx4S1q2xqbmxvWS0XufS7yq
 Z+3o8iYpkiHP2zcxIL/X54X7WNrzxln0ppMUQbdtJWexGqMnOxdrKBoVK6jJ4rae+LkcHCo4Tpo
 537sdKrtZ1BAnN4FAD34ny9FFjZr+a9FbyaO3YHM=
X-Authority-Analysis: v=2.4 cv=KL1qylFo c=1 sm=1 tr=0 ts=6a696bd9 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8
 a=9cf_8RkQ3xQRBlWBkGkA:9 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13517
X-Proofpoint-ORIG-GUID: yz8K0ibqCcH_VZ-eWvehtKCbr6KNqP4K

On Fri, 24 Jul 2026 23:22:31 +0530, Chandrakanth Patil wrote:

> mpi3mr_fault_uevent_emit() runs from the fault watchdog and reset
> paths, where host I/O may already be blocked. GFP_KERNEL allocations
> here, both the local kzalloc_obj() and the ones inside
> kobject_uevent_env() itself, can trigger reclaim that waits on that
> blocked I/O and deadlock.
> 
> Use memalloc_noio_save()/restore() to cover the whole call instead of
> just the local allocation.
> 
> [...]

Applied to 7.2/scsi-fixes, thanks!

[1/1] mpi3mr: Fix potential deadlock in mpi3mr_fault_uevent_emit
      https://git.kernel.org/mkp/scsi/c/ccff8c925715

-- 
Martin K. Petersen
