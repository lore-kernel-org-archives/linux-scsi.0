Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D004DEEC0
	for <linux-scsi@vger.kernel.org>; Sun,  1 Mar 2026 02:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772331128; cv=none; b=irRh4oAoRS2hIt6GvBoqhAg8xGifSkoO2pgFml68QYWHyIRf29YtjI6mMKLr019cw10uVCbNgVhR9kAk+6D4qGEnhX6u5ewnqylzayqQZG2T5gPzlih32UbLLHQRLKAS9M4Ma72wYQq5pJGKF+pkm7jHcRZW4pkZoZ5CXDgRD98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772331128; c=relaxed/simple;
	bh=x8nj94FySeows4EaAaDZ/790WcCN1sdxdhC2JVKWRvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dGtanEG/KeRyXnqI5wp3Jbsr4iuRnaCfahuXBe5JBxBwPOGXxy1ZQ0KC2Mnnix1UVQbAq+KnWlrycLO0EM2b24NFzfolHdwPJG5F5fnhBcqfEcV6Irs3leUoWzPm8EmL++StigQG1Y0sboPonhiM0O2Dvdkst1pjNQvQOBRvfPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Sm9YkzBI; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Sm9YkzBI"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6211nbeh2953310;
	Sun, 1 Mar 2026 02:12:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=jdatGWiN4GEERnj+aot6fABKJ1eG4U7jq7QRwZmVhX0=; b=
	Sm9YkzBIMvPc9r/g9ZMndHFI3Tq8HkvLjrUIDiCWTz35vV7GR8+vXHjukcjtPEPY
	XL6mbLW57ENgSz3LxPK2g5Zt14Ca6yOAmLd/gxIIL+tlgMVHARpV/nUASMXpnSX4
	8iS33zoaC/Qly5eKLWn8g32w+u0Wamtf1AX8Al/aJi1O5pjmZDNs8Ld9RF6XVtJE
	j0zbcSjwOcPzxWalTS7fTgaPqM7Hxv3+bY5YmEngcgGQ5sO8+EonC3ABjXzEwy7m
	zYyw/JkG1DvpYUVHE20/zqYrwT1MwRDUUtpJmV2x3LadvNOjULvg4BdMsBeMJYVT
	sNAEF/rXKDHJJ5F1Diu93A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cksh8rnr1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 01 Mar 2026 02:12:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61SNkt4n034758;
	Sun, 1 Mar 2026 02:12:04 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptbpnra-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 01 Mar 2026 02:12:04 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 6212C32D009031;
	Sun, 1 Mar 2026 02:12:03 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4ckptbpnqs-3;
	Sun, 01 Mar 2026 02:12:03 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        sathya.prakash@broadcom.com, chandrakanth.patil@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com
Subject: Re: [PATCH v1] mpi3mr: Clear reset history on ready and recheck state after timeout
Date: Sat, 28 Feb 2026 21:11:58 -0500
Message-ID: <177233109539.1886347.12926270163589926860.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225082622.82588-1-ranjan.kumar@broadcom.com>
References: <20260225082622.82588-1-ranjan.kumar@broadcom.com>
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
 definitions=2026-02-28_07,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2603010017
X-Proofpoint-ORIG-GUID: v-RfHd0AsijPjVI0OieBPhC-etZzS_mR
X-Authority-Analysis: v=2.4 cv=D8VK6/Rj c=1 sm=1 tr=0 ts=69a3a074 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=Nen4gYhZ1qQA8kT9mQMA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12261
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAxMDAxNyBTYWx0ZWRfX7K14fx93l15C
 PtQJTHNL+LW4ekXP8yRmf48ShoPkURZnirjR53KAfjyn0QCNbMHQzEvcoXcxUjd55OsPpkmbuNz
 XB9LiU12YHgvyACKrRd29C94m1LEixK+7goxE4dEgXCAkEc0/2rlnzwpISybjOCfUnx1u1ouxoU
 XAQPRFJObi/SUm7V/F5zJr+JASysUomQhFX6CxtDi90Nwx4wDV5K8oJ20P2v9k8IOvi9slVqE76
 MERDIEKI9kiCge2ije9YOiwIZwnlK3DwB0yGPl7nSfB+go5zk8vRDh1aRsyJjwQtNHzPjNTiYvn
 Geoj1rvJvegNZ29Umy7MZtZWJ7rbU3qTmhEBNSlGqWFKZKUkGOmbiAL8kYZGXfQYox6VuJ2GEYu
 8Pimz8OjEhq0o+jVbAx4XC/86Csg0HGKGQTPUf6kycFhp2s6L793XpKQUD76/WB9ygDeubH49gY
 ofvCJ/saxaIZGlQwd9RJoqtUKDbAWag72gi2je+o=
X-Proofpoint-GUID: v-RfHd0AsijPjVI0OieBPhC-etZzS_mR

On Wed, 25 Feb 2026 13:56:22 +0530, Ranjan Kumar wrote:

> The driver retains reset history even after the IOC has successfully
> reached the READY state. That leaves stale reset information active
> during normal operation and can mislead recovery and diagnostics.
> In addition, if the IOC becomes READY just as the ready timeout
> loop exits, the driver still follows the failure path and may
> retry or report failure incorrectly.
> 
> [...]

Applied to 7.0/scsi-fixes, thanks!

[1/1] mpi3mr: Clear reset history on ready and recheck state after timeout
      https://git.kernel.org/mkp/scsi/c/dbd53975ed41

-- 
Martin K. Petersen
