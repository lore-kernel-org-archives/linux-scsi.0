Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB84C219E0;
	Wed, 19 Feb 2025 01:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739927261; cv=none; b=MxOx++RXtxlwPHEphP/XNOzQe/Hn5v3RqtdgNDDqPxAnmLwnHQdSs8eFBHwNVi28yoIBprUw+nWyjQqG7Dd8Oca+dn+4SPuN8bqBhv37rakp67VohD+KHk2CP4l563jBSxwQzyNvQkKGYMytjJ3QCuDG068ubIks9nRj239iOVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739927261; c=relaxed/simple;
	bh=cjgz1uNG96Lycd9+lrfpP12gnfIGm6u995enqdGw4o4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m/FBaVLE2s9b9wNd3dN5lq6cYfLkJEGaPkQFFf5bHNEsYrttspxm4NbIPkgk2rdvuEh9Y1uigZI42OW3TVHfA4s+L9BspTTmyLUuQoWQmOobjlUV/el9CUIZJutZk+AH5gFfbqcJsWpqPnU7cH4zs1K9Rlm4tvoP2tNlFKw2WgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NR5beZfq; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NR5beZfq"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51IMfZkH003776;
	Wed, 19 Feb 2025 01:07:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=osjTj04gBbUr1US/hfIxtUbMQoOUsZVR+jnA8SFFFuQ=; b=
	NR5beZfq2TGC2sCEJYJodznjduOYEfqkKOGBS+NRclQCL/PuKNd6t1NTZDKYHMsw
	sQTM1fCXFxMAPkiLjllLFV7R6MGaDBpqqr2WBDAWyWkH5PlhMuvslFi7irzCQIHw
	DfrOY7+vNhu12224jznj8NIzs9pgR9NPP28SFrv2LYNMEft5MFlq7v9MDgX/TZHF
	vbgMFC9ioVFV3+/+fyPWvtAYyzmYTs9in7fg7+/H34V0n/uqThTRHgMh7yhjZBrr
	E4FEmzP2zMDwDgdF+2DEPcApX4kq5eG6Hn9Lnwzb9EkY1rytWBS68t8jJyrEWgeH
	rJVExhQaxs41NsH+91EGQA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44w00ngkkd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Feb 2025 01:07:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51J06mD0002149;
	Wed, 19 Feb 2025 01:07:24 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44w0tk1rrw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Feb 2025 01:07:24 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 51J17KeV000669;
	Wed, 19 Feb 2025 01:07:23 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 44w0tk1rq5-7;
	Wed, 19 Feb 2025 01:07:23 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Tomas Henzl <thenzl@redhat.com>, MPT-FusionLinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: mpt3sas: Reduce log level of `set ignore_delay_remove for handle(0x%04x)` to info
Date: Tue, 18 Feb 2025 20:06:55 -0500
Message-ID: <173992713061.526057.1776061314538121010.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250131171640.30721-1-pmenzel@molgen.mpg.de>
References: <20250131171640.30721-1-pmenzel@molgen.mpg.de>
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
 definitions=2025-02-18_11,2025-02-18_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2502190006
X-Proofpoint-ORIG-GUID: fex-3gynrVsUpM1ALhZlZsYKuyRRg16y
X-Proofpoint-GUID: fex-3gynrVsUpM1ALhZlZsYKuyRRg16y

On Fri, 31 Jan 2025 18:16:40 +0100, Paul Menzel wrote:

> On several systems with Dell HBA controller Linux prints the warning below:
> 
>     $ dmesg | grep -e "Linux version" -e "DMI: Dell"  -e "ignore_delay_remove"
>     [    0.000000] Linux version 6.12.11.mx64.479 (root@lucy.molgen.mpg.de) (gcc (GCC) 12.3.0, GNU ld (GNU Binutils) 2.41) #1 SMP PREEMPT_DYNAMIC Fri Jan 24 13:30:47 CET 2025
>     [    0.000000] DMI: Dell Inc. PowerEdge R7625/0M7YXP, BIOS 1.10.6 12/06/2024
>     [    9.386551] scsi 0:0:4:0: set ignore_delay_remove for handle(0x0012)
> 
> [...]

Applied to 6.15/scsi-queue, thanks!

[1/1] scsi: mpt3sas: Reduce log level of `set ignore_delay_remove for handle(0x%04x)` to info
      https://git.kernel.org/mkp/scsi/c/fb27da6e06a0

-- 
Martin K. Petersen	Oracle Linux Engineering
