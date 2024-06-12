Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AADF75CAC
	for <linux-scsi@vger.kernel.org>; Wed, 12 Jun 2024 01:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718157526; cv=none; b=PqWHJWpcobi1iZWqgCGcx8fYbAr1RajWX4LusYuSVNnNuPpgNyAA7YDNcxKG7gEomCGL1HUDbtfYT2Lr9jA1clgG2NTxm1OAQ5INrXhncdpD+yv4jfv5IBn+DVhvzeftYLzFoJs8nJ/EKvk7CmvJ02zt9qM1/AjWrjshEBqAE4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718157526; c=relaxed/simple;
	bh=kR92prx68tzcTX9ZOQPSc9m11L0BXYfxPBkOjI0aXZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WxJOjXogyjEaP2SoflGNoOxHAWH+ra7usx9UY9h5JUpb2PVKYTYysADmI914vUUOshyLEp0oLB8dYm8JlNi6bdJ804xsZ/3LywLnm44RU96pQ+SaPyG3zZrIXRQyZ7xpW3Q8VVDiqdxwTRbkOMKKxsSOZ/MFRZSA71D8DpBSKOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QozIfFcq; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QozIfFcq"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45C1tOC1009090;
	Wed, 12 Jun 2024 01:58:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=WFThFTVlo+ib1lZQJA3WZ1bPO3RrOrAK8j/6Yw/yXdY=; b=
	QozIfFcqy7lSwbkwIS2m00+iOtnDxCxYbuq7NdxVYd9F3di7XkWGz5IZ79NOwlkZ
	gS4dpakVs8ud6r0xOGTZpsYN8OTbUkmBhUT/bzBiXlfGNUfkDNaudi+e6qJ4yc7S
	3hWrNzVAtMQ8IqCpFTutyOm0NooCAID6f/MngeTlga0fWsxSGbrzrSnGzUp84I0j
	rBZECGCUcotua37GrumP7LiU2JBcmN1m+YROLKrUfTWZpuGinUo/mQBo70XtwdVw
	zPgyfY3v/KqL+g4t5ZlW9gNOie29xFZ3WSV2P52B6jknmfBqlU1AXh3llktzTH99
	3/m6IjcRzLZ3IQlCdIKP8g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymh1me43n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Jun 2024 01:58:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45C0BfAA014346;
	Wed, 12 Jun 2024 01:58:39 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ynceusfvy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Jun 2024 01:58:39 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 45C1wbsa031272;
	Wed, 12 Jun 2024 01:58:38 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3ynceusfuq-2;
	Wed, 12 Jun 2024 01:58:38 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Subject: Re: [PATCH v4] scsi: mpi3mr: Fix ATA NCQ priority support
Date: Tue, 11 Jun 2024 21:58:00 -0400
Message-ID: <171815745546.194120.1810995193191329283.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240611083435.92961-1-dlemoal@kernel.org>
References: <20240611083435.92961-1-dlemoal@kernel.org>
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
 definitions=2024-06-11_13,2024-06-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406120011
X-Proofpoint-ORIG-GUID: NCP_p6OXV90CDtizxwtNUTZohySDMiIY
X-Proofpoint-GUID: NCP_p6OXV90CDtizxwtNUTZohySDMiIY

On Tue, 11 Jun 2024 17:34:35 +0900, Damien Le Moal wrote:

> The function mpi3mr_qcmd() of the mpi3mr driver is able to indicate to
> the HBA if a read or write command directed at an ATA device should be
> translated to an NCQ read/write command with the high prioiryt bit set
> when the request uses the RT priority class and the user has enabled NCQ
> priority through sysfs.
> 
> However, unlike the mpt3sas driver, the mpi3mr driver does not define
> the sas_ncq_prio_supported and sas_ncq_prio_enable sysfs attributes, so
> the ncq_prio_enable field of struct mpi3mr_sdev_priv_data is never
> actually set and NCQ Priority cannot ever be used.
> 
> [...]

Applied to 6.10/scsi-fixes, thanks!

[1/1] scsi: mpi3mr: Fix ATA NCQ priority support
      https://git.kernel.org/mkp/scsi/c/90e6f08915ec

-- 
Martin K. Petersen	Oracle Linux Engineering
