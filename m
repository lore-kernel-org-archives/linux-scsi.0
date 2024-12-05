Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA7322EE5
	for <linux-scsi@vger.kernel.org>; Thu,  5 Dec 2024 02:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733365065; cv=none; b=uxz6Otcc8C4e3DJ4iHIUAxy79VEW/qjuox1/1op5maQp3HPbhnIUldrU2umcDR3evR1ar2n+htZvvqHkg8acQsrJJjF2FhDZGIgdjVeg2CQP61uUuytmbDAGYD4j1Fhc3oev+cgyS+0lMk5ZzEfle1PtWO4aqZaDxTOU/rqC9Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733365065; c=relaxed/simple;
	bh=XvcsraA3VTIOZoU31CgQ9mu+tgPFIoLj1r59mshtyRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZCubkbv5CHfaIX8JhIM54iK5SNVcHRcW8UTeTG2jwfonFRc8P9bepQPtm956HwBGrl9ce7cOxb/i33Jp+OgaWpeXxchKUbyAqdSu6t+nWY7J6WDYm+XFc8XUaNTb2A5b92B5zZ+hzC2uxx0vS2j7hk4j/d/AgEqq8YGEs1kMFtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Hsj5ym9h; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Hsj5ym9h"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B51Ci1m010526;
	Thu, 5 Dec 2024 02:17:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=kLEGxlKmf2oQFf9PfXwaIjesQDKIzkyHHN7mBFo2L4g=; b=
	Hsj5ym9h9Vus75q3y99O4VbCBba/blBU5/s8aA7zdG94HPnTHVoaHNrsM5NRDD6e
	qa/0OHmcFkmUYK119Ymnd0hJGApIoHqKYH18G1i31wAnAwkrn+XkalZXPDoebLBw
	CUD8LYfnjDOFnMRiHUANCEv/ut3Qu8v+T1OSItnMtT+m8LZfC8XZ4eJ5jshX2n+3
	Ljk0Bd1lHIrtlN99Giv57NwWxb9wyYBhxCBLl3MkJ5yUPIWM0/7vmLwzYwyoTQ+F
	0URz97v5x4PFQMSOTadCaYaw8ptVCIExInsnTzX66u00ksOlFbhcdZe/6L2UeLTX
	fLMkuEiSyOu3Q24riqg0Zg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 437u8t9ymy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Dec 2024 02:17:39 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4B50BwC3001409;
	Thu, 5 Dec 2024 02:17:39 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 437s5a8u55-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Dec 2024 02:17:39 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4B52HbvM018742;
	Thu, 5 Dec 2024 02:17:38 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 437s5a8u3n-2;
	Thu, 05 Dec 2024 02:17:38 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Nilesh Javali <njavali@marvell.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        agurumurthy@marvell.com, sdeodhar@marvell.com, emilne@redhat.com,
        jmeneghi@redhat.com
Subject: Re: [PATCH 0/7] qla2xxx misc. bug fixes
Date: Wed,  4 Dec 2024 21:17:01 -0500
Message-ID: <173336487631.2765947.15056170020927588581.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241115130313.46826-1-njavali@marvell.com>
References: <20241115130313.46826-1-njavali@marvell.com>
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
 definitions=2024-12-04_21,2024-12-04_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=957
 bulkscore=0 phishscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412050017
X-Proofpoint-ORIG-GUID: 8Jx6SnA8teDtBpAzzDtXAIajJU7lrrHC
X-Proofpoint-GUID: 8Jx6SnA8teDtBpAzzDtXAIajJU7lrrHC

On Fri, 15 Nov 2024 18:33:06 +0530, Nilesh Javali wrote:

> Martin,
> 
> Please apply the qla2xxx driver miscellaneous bug fixes
> to the scsi tree at your earliest convenience.
> 
> Thanks,
> Nilesh
> 
> [...]

Applied to 6.13/scsi-fixes, thanks!

[1/7] qla2xxx: fix abort in bsg timeout
      https://git.kernel.org/mkp/scsi/c/c423263082ee
[2/7] qla2xxx: Fix use after free on unload
      https://git.kernel.org/mkp/scsi/c/07c903db0a2f
[3/7] qla2xxx: Move FCE Trace buffer allocation to user control
      Feature, queued for 6.14.
[4/7] qla2xxx: Remove check req_sg_cnt should be equal to rsp_sg_cnt.
      https://git.kernel.org/mkp/scsi/c/833c70e212fc
[5/7] qla2xxx: Fix NVME and NPIV connect issue
      https://git.kernel.org/mkp/scsi/c/4812b7796c14
[6/7] qla2xxx: Supported speed displayed incorrectly for VPorts
      https://git.kernel.org/mkp/scsi/c/e4e268f898c8
[7/7] qla2xxx: Update version to 10.02.09.400-k
      https://git.kernel.org/mkp/scsi/c/35002a8ec557

-- 
Martin K. Petersen	Oracle Linux Engineering
