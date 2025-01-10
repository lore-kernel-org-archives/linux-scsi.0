Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91FD2192D9E
	for <linux-scsi@vger.kernel.org>; Fri, 10 Jan 2025 21:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736543857; cv=none; b=EjYo8ZIxUygKSPeoil2PBG4KmB4C1QRnol3kJ4p/bGSViW0ObPRdO2tKmLvvGGGvj7BAaqN5YOeXD2bBhQknClH7bCGoFBoGe8aAYqv2w+KEKNmX8lEkjEk1pcD5McKqhvXppDVBACbzplcK3epH0cd7FKX+xq5kdlrGtrl+eKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736543857; c=relaxed/simple;
	bh=AUKQSnLLuNlkjS0bJ3+MUSnfxuN7HwdTXnIfl5yAuK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EgPA+bVQj61JQWKhWNtFRb2S2NjOIzbYx6XnnR11+Gh0q7F0kBcD6KSXVVsV4v4W+m7nuBSr/zOXhweKyAiuyxHGuY8d9hPgDnXxaR79a9CMZst3FGIa2iG2951GI1U+33gvOzTcQU4BZq3q4e4HJl5zoWDUM0mNSBC+oDqGJds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gIR5YMyc; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gIR5YMyc"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50ALBoQm030652;
	Fri, 10 Jan 2025 21:17:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=XMamT7Zuw5eTDWoCLGNklP9bcHdCJeOJdNrXOQmdaTM=; b=
	gIR5YMycM0CYCgvFlkEp/IiS6/JbC2ScaIrfThw3KC9wKchr+VYliAS06RzfGaHZ
	Mw+o8M2PSPM5EAmHta9N57Rqqw5JRUaCN6TdFLJzJy+nEATg2LchV9XzJFRpDaB6
	ymjjm5WqeovcRTPIv9O5vZMhEWX1BUY+/QSS8+3av+QdzIzlFmYS5aXAIXrjkGVs
	q3qig6B27AJ1kkNkxPj6FNjcwiAlVhjj8OoBI4hBe8FVG0j94O5n5sIHTmnPlHdj
	DDlVOHux9MwP7F3BYFPCHVsrx41LK10ZndS7qfHHdGkzfRno3lPrCZW/FoUiirWO
	nwlJwARItV/aNdLN5xG6LQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4427jpkn8u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 21:17:33 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50AJM2CE027219;
	Fri, 10 Jan 2025 21:17:32 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43xued5r6f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 21:17:32 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 50ALHQ1w034137;
	Fri, 10 Jan 2025 21:17:32 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 43xued5r3k-5;
	Fri, 10 Jan 2025 21:17:32 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Justin Tee <justintee8345@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, jsmart2021@gmail.com,
        justin.tee@broadcom.com
Subject: Re: [PATCH 00/10] Update lpfc to revision 14.4.0.7
Date: Fri, 10 Jan 2025 16:16:47 -0500
Message-ID: <173654330190.638636.463825367335055463.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241212233309.71356-1-justintee8345@gmail.com>
References: <20241212233309.71356-1-justintee8345@gmail.com>
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
 definitions=2025-01-10_09,2025-01-10_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501100164
X-Proofpoint-ORIG-GUID: eMUpLsQQHCkI6j1JgAfDCCBRr7YIVKa6
X-Proofpoint-GUID: eMUpLsQQHCkI6j1JgAfDCCBRr7YIVKa6

On Thu, 12 Dec 2024 15:32:59 -0800, Justin Tee wrote:

> Update lpfc to revision 14.4.0.7
> 
> This patch set contains fixes related to smatch, clean up of obsolete code
> and global spinlocks, changes to ADISC and LS_RJT handling, and support for
> large fw object reads used in proprietary applications.
> 
> The patches were cut against Martin's 6.14/scsi-queue tree.
> 
> [...]

Applied to 6.14/scsi-queue, thanks!

[01/10] lpfc: Redefine incorrect type in lpfc_create_device_data
        https://git.kernel.org/mkp/scsi/c/1ff0f95ade41
[02/10] lpfc: Restrict the REG_FCFI MAM field to FCoE adapters only
        https://git.kernel.org/mkp/scsi/c/17cb5e986e7a
[03/10] lpfc: Delete NLP_TARGET_REMOVE flag due to obsolete usage
        https://git.kernel.org/mkp/scsi/c/bb33b07ac6e3
[04/10] lpfc: Modify handling of ADISC based on ndlp state and RPI registration
        https://git.kernel.org/mkp/scsi/c/ee80d8c2d4cc
[05/10] lpfc: Add handling for LS_RJT reason explanation authentication required
        https://git.kernel.org/mkp/scsi/c/06dbe31e8950
[06/10] lpfc: Change lpfc_nodelist save_flags member into a bitmask
        https://git.kernel.org/mkp/scsi/c/3f8f9f16f844
[07/10] lpfc: Update definition of firmware configuration mbox cmds
        https://git.kernel.org/mkp/scsi/c/91b91309db02
[08/10] lpfc: Add support for large fw object application layer reads
        https://git.kernel.org/mkp/scsi/c/3103af831c8f
[09/10] lpfc: Update lpfc version to 14.4.0.7
        https://git.kernel.org/mkp/scsi/c/eb2087085243
[10/10] lpfc: Copyright updates for 14.4.0.7 patches
        https://git.kernel.org/mkp/scsi/c/62297838de61

-- 
Martin K. Petersen	Oracle Linux Engineering
