Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCCB21876
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jul 2024 02:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721097012; cv=none; b=o9n0ocUzwQKA4yFnJAlbG/4iQId1P/z5+OFneVWu6MNLHXRTQ9X5/LAWPKIBWXhu8F/0Thtan+c9UC7IWf64kyU7cl5aqnGDT7YH4ktzUpBahUHn8kWvrPLlebm+Yw9wci5A/ophFio0lkHGkhON0US9yo/ECwdefNDqeRjc5ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721097012; c=relaxed/simple;
	bh=RmlO5VwMtsy6ErmCf4oVrz20kdI5yYDTKczzrqHsf/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BwaVcSHJmAnOWXphVnWxy2gM0/jJRJdxSIwCiU4jGSZd2HcgXDfb63tG2ihIS+8M9zw4fbyxHDNGxTzqDnRTjlmpiG0aNnnhWcISbjvnolpIf/FhQJWrnF0yEJwSnCmz/p6s8nCSi6naXL5b6CusOtVvKguj2TnyYB4utAUVvB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iu4qWo9n; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iu4qWo9n"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46FLXceU019169;
	Tue, 16 Jul 2024 02:30:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=38pQ/FkG3WiXRL+9+sgt9kgMMfnCgWY3FUDthaKG3DU=; b=
	iu4qWo9ntCt8aSwXHlvJ3xqjo84Rm0TjXcvMXYD6UWtirHEFqu49gLo+cPPvg9SA
	1/Yx1V3KBXLAjZFhsm1ybXTBPbx9jGP9Er22vmD4pZVcM/3b42u71+sj5Lqz+7gE
	JxTJjlwz4F35gnCJv9zSGm30qBYpKZP78DlvrZCA7fAR2kPJQgwxKCjIoN5hZCyt
	oag74l5vNBgmmI1wPZgXieieSS+v5OtfkOZbHu9bRIQ3sCml/mWn66w3ta68y0qL
	Wh72RsqFuKA0moJYu9PRHT4geVTF2tV7uaEPUB9F7P9RE9r8n7DgMkudcl3KJTcl
	+L1h+CHIf4Krjc4qaliLag==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40bhmcmf37-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jul 2024 02:30:05 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46G1fYuC002627;
	Tue, 16 Jul 2024 02:30:05 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40bg1exxdj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jul 2024 02:30:05 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 46G2U3AB027682;
	Tue, 16 Jul 2024 02:30:04 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 40bg1exxah-4;
	Tue, 16 Jul 2024 02:30:04 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Nilesh Javali <njavali@marvell.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        agurumurthy@marvell.com, sdeodhar@marvell.com, emilne@redhat.com,
        jmeneghi@redhat.com
Subject: Re: [PATCH v2 00/11] qla2xxx misc. bug fixes
Date: Mon, 15 Jul 2024 22:29:23 -0400
Message-ID: <172109323560.941202.13735343870813567849.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240710171057.35066-1-njavali@marvell.com>
References: <20240710171057.35066-1-njavali@marvell.com>
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
 definitions=2024-07-15_19,2024-07-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 bulkscore=0 mlxlogscore=871 malwarescore=0 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2407160018
X-Proofpoint-GUID: bWrUrCP7FnMupi4t3LP0vvC3f19aguTK
X-Proofpoint-ORIG-GUID: bWrUrCP7FnMupi4t3LP0vvC3f19aguTK

On Wed, 10 Jul 2024 22:40:46 +0530, Nilesh Javali wrote:

> Martin,
> 
> Please apply the qla2xxx driver miscellaneous bug fixes
> to the scsi tree at your earliest convenience.
> 
> v2:
> - Fix smatch warn, val_is_in_range() warn: always true condition '(val <= 4294967295) => (0-u32max <= u32max)'
> - Fix smatch warn, qla24xx_get_flash_version() warn: missing error code? 'ret'
> 
> [...]

Applied to 6.11/scsi-queue, thanks!

[01/11] qla2xxx: unable to act on RSCN for port online
        https://git.kernel.org/mkp/scsi/c/c3d98b12eef8
[02/11] qla2xxx: validate nvme_local_port correctly
        https://git.kernel.org/mkp/scsi/c/eb1d4ce26095
[03/11] qla2xxx: Fix for possible memory corruption
        https://git.kernel.org/mkp/scsi/c/c03d740152f7
[04/11] qla2xxx: Return ENOBUFS if sg_cnt is more than one for ELS cmds
        https://git.kernel.org/mkp/scsi/c/ce2065c4cc4f
[05/11] qla2xxx: Fix flash read failure
        https://git.kernel.org/mkp/scsi/c/29e222085d89
[06/11] qla2xxx: complete command early within lock
        https://git.kernel.org/mkp/scsi/c/4475afa2646d
[07/11] qla2xxx: During vport delete send async logout explicitly
        https://git.kernel.org/mkp/scsi/c/76f480d7c717
[08/11] qla2xxx: Fix optrom version displayed in FDMI
        https://git.kernel.org/mkp/scsi/c/348744f27a35
[09/11] qla2xxx: Reduce fabric scan duplicate code
        https://git.kernel.org/mkp/scsi/c/beafd6924614
[10/11] qla2xxx: Use QP lock to search for bsg
        https://git.kernel.org/mkp/scsi/c/c449b4198701
[11/11] qla2xxx: Update version to 10.02.09.300-k
        https://git.kernel.org/mkp/scsi/c/a1392b19ca59

-- 
Martin K. Petersen	Oracle Linux Engineering
