Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED4E6FC3
	for <linux-scsi@vger.kernel.org>; Sun, 31 Aug 2025 02:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756606310; cv=none; b=aGZ3A4sAiOo4z3gXTKB23jbJX+8lDNBHfnvxeT/9w/tdMTuwMaCjx5NyflD+F/MeU4j4iw8k4CgEnQqldu9JiWKOqWh2ZzpH+DWI+E/O/ZmNkJ2Kc1B7w1FLfm0mjigJxQ+x8rA+5Iclqnu6JlI5Ttd9+1Q42Zm8goRtiHUpbgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756606310; c=relaxed/simple;
	bh=c8TbeJq7w+wCVWsmyJVtI5AJFbKO3I6970qyV6hws6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZmwGYqVEA41/GI9nn/L/1Oe4mntKjaEVzkDjn3hXuPrYi5m5L5//o/BwbZijbVXODF4hKX9nvMK3K6BoU18+CPmYr5/1DmUhfDgCYG2/8jo5c33Vkma+jmtrH2mLBMzc3wJW3iIWXWji7o6+yRGn6m9fG0nLy3jLZnN6VdxXjAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XeFlOcVr; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XeFlOcVr"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57V1D7PS029380;
	Sun, 31 Aug 2025 02:11:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ZU1AjWYUJIIV67TfxoeVP7wN1Sg70qjqBcvQyjczIU8=; b=
	XeFlOcVrVEt5hNGp38nct0bvS7R+wEnxS0G348/bnhiq3KM0BIV2pgVn+l9vVmCz
	xKeWHKTJEdTONIgkjaslCupEUU0wgWFK8CeqDwUfu8DEbn8vvl41eV4hW1qlUHfJ
	XgGlV7YvdrSwWeo/wNvS/1Gs99m4WMmCy0wf7Km1xuiq39nM+B9ZwTrC0BHcD1ET
	Mjr8ahMW8Rm2KGiUIi0lU816qPdpnZcyNY9/mAjZphBcnQA8AEL0PlA2b2v2YTuY
	7GjQE2nrn3ck6tZ+HjuZp7DAAAj6BulX8PU6TtW4DgZUV0YtPXP8FJdz9582mSXa
	1BC73YmNwGMau8R4/AkfZQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48v8p4g3qb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 31 Aug 2025 02:11:46 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57V23381028678;
	Sun, 31 Aug 2025 02:11:45 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqr72m51-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 31 Aug 2025 02:11:45 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 57V2BjAo019355;
	Sun, 31 Aug 2025 02:11:45 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqr72m4v-1;
	Sun, 31 Aug 2025 02:11:44 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        sathya.prakash@broadcom.com, ranjan.kumar@broadcom.com,
        prayas.patel@broadcom.com
Subject: Re: [PATCH 0/6] mpi3mr: bug fixes and minor updates
Date: Sat, 30 Aug 2025 22:11:40 -0400
Message-ID: <175660145356.2188324.10660402232088066771.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250820084138.228471-1-chandrakanth.patil@broadcom.com>
References: <20250820084138.228471-1-chandrakanth.patil@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-31_01,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508310022
X-Proofpoint-ORIG-GUID: SJCIMrnh1l-sOsMqQHo9XJ7n9w2Zbb12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDIyMiBTYWx0ZWRfX6laSxmS2z0qH
 YuXKaNaS5Y6Ffrz19q+djtSrWyE3hzJLfSOZt8iKa33MiPP/jRLUyuhYaS5d84j7NL2/L++O6CW
 JPDu8rPD0SwOuHKNATNDUgRR7F79tWMnhgwXNRMpWlUYL0l5iCWqiAEYSDt4ObELbDO22PbdAKO
 Swg4pUZ/jfEVzUJTn9OyVZApetvxDR9lhxFiFRY4HvHhSCHFdKcbth50JPuF3GPtpagR2Zs4Lx5
 IFEwQmEpzvDlr2yTTvVVtQJdnblA+IzAQESJzSIxCMFqNUKEtPhn/LxpCAvXzGx/j5ZGTM+WXbh
 fw4fK1bCNY35f/82UsrlhL87upvKLm9KvGyxDd7uo9OmWKP7l31IppTCMQaWhVdgcBvFXnu3qI8
 gD7N1U4o9B3b52V8jjuNb90JygWxoQ==
X-Authority-Analysis: v=2.4 cv=doHbC0g4 c=1 sm=1 tr=0 ts=68b3af62 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=ET7WVoIix35lhQ-nC0sA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13602
X-Proofpoint-GUID: SJCIMrnh1l-sOsMqQHo9XJ7n9w2Zbb12

On Wed, 20 Aug 2025 14:11:32 +0530, Chandrakanth Patil wrote:

> This series contains mpi3mr driver fixes and minor updates.
> 
> Chandrakanth Patil (6):
>   mpi3mr: Fix device loss during enclosure reboot due to zero link speed
>   mpi3mr: Fix controller init failure on fault during queue creation
>   mpi3mr: Fix I/O failures during controller reset
>   mpi3mr: Update MPI headers to revision 37
>   mpi3mr: Fix premature TM timeouts on virtual drives
>   mpi3mr: Update driver version to 8.15.0.5.50
> 
> [...]

Applied to 6.18/scsi-queue, thanks!

[1/6] mpi3mr: Fix device loss during enclosure reboot due to zero link speed
      https://git.kernel.org/mkp/scsi/c/d6c8e8b7c98c
[2/6] mpi3mr: Fix controller init failure on fault during queue creation
      https://git.kernel.org/mkp/scsi/c/829fa1582b6f
[3/6] mpi3mr: Fix I/O failures during controller reset
      https://git.kernel.org/mkp/scsi/c/b7b2176e30fc
[4/6] mpi3mr: Update MPI headers to revision 37
      https://git.kernel.org/mkp/scsi/c/a4ca63001e1a
[5/6] mpi3mr: Fix premature TM timeouts on virtual drives
      https://git.kernel.org/mkp/scsi/c/4af864784d80
[6/6] mpi3mr: Update driver version to 8.15.0.5.50
      https://git.kernel.org/mkp/scsi/c/80a403427d35

-- 
Martin K. Petersen
