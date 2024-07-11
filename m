Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D5B653
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jul 2024 03:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720667361; cv=none; b=gDGF/m9g6m8yi0nN6Ef24xLJ1W8cGzrrsZpRK+NCQk5s7pt12CwAxCG0G8nJSgISwWaJM9Zby/PP0hfVViDv2LXA/QFPa0S6tIAApKHR4wNQM3EX9QTDARl7WXHlppYMtzbR8DlpF1aXxPvA7tJWE7V23qUVyQRwIOUZL0FdZ3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720667361; c=relaxed/simple;
	bh=leQGhrIk19ZfHfhpU1uMlt9NhkD86MUv13IOBTYaU78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lnx2hr9Kfla5i9FoF+GVTagtdzo0AOGBJY7D/oBORJn4XxmtYz86bYLuG/cjJXxOL1m1DciplJ2gQtxVNZQuxFlyh9/+lfAhlkGKr2p7fPzoejdX9FsaF8llvHTKJCkYWl03ecQ1pibvsFAtnjmH5OJxQUSRXxmk1EHd94/+3pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HVUEzKmN; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HVUEzKmN"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46B1SeE6029616;
	Thu, 11 Jul 2024 03:09:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=fgXr/fURG8nJ4N+7CHxMj3O1bW6Ls7Pqu8ivOeiy+Sg=; b=
	HVUEzKmNplGdRkxCH3sdAxqC8/axnYvOMZaj7B5wDa49GZ6Omu+amRXdOCKSwART
	DtHObEBTYzOE8nMh1LX6jrZ3x2nYvflRkfZyR4wHua2J+NG4wdM+zGh06iKSrArb
	0S6LR0gVIhoHLymUVGW/XZYNDgJvvQ8WTAOSdQNQ0FGXsvcBYmmUPTQBYKyo697t
	gvwhv413BtX3XMDgdTE7B9Wker4X63USTgG/jN94EV/kvoYAVPpQ/WK/YaU3eLnw
	7tm7mnnQMxd8sTkHT8odJbW53Gf8OtlasJnO3Nj0rlZ/uredatr/veHd7Z/d+jAD
	Ngb6PTCRuCiBQPIMyKPnjA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 406wgq0p87-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jul 2024 03:09:15 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46ANshwX008752;
	Thu, 11 Jul 2024 03:09:14 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 409vv3x4bc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jul 2024 03:09:14 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 46B39D9h006490;
	Thu, 11 Jul 2024 03:09:14 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 409vv3x4ar-1;
	Thu, 11 Jul 2024 03:09:13 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Justin Tee <justintee8345@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, jsmart2021@gmail.com,
        justin.tee@broadcom.com
Subject: Re: [PATCH 0/8] Update lpfc to revision 14.4.0.3
Date: Wed, 10 Jul 2024 23:08:32 -0400
Message-ID: <172066369905.698281.10079387911559575213.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240628172011.25921-1-justintee8345@gmail.com>
References: <20240628172011.25921-1-justintee8345@gmail.com>
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
 definitions=2024-07-10_20,2024-07-10_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2407110020
X-Proofpoint-ORIG-GUID: YoqOSPRU7Av-3JxjK8Y0Gyzfvb2o9iPD
X-Proofpoint-GUID: YoqOSPRU7Av-3JxjK8Y0Gyzfvb2o9iPD

On Fri, 28 Jun 2024 10:20:03 -0700, Justin Tee wrote:

> Update lpfc to revision 14.4.0.3
> 
> This patch set contains bug fixes related to discovery, submission of
> mailbox commands, and proper endianness conversions.
> 
> The patches were cut against Martin's 6.11/scsi-queue tree.
> 
> [...]

Applied to 6.11/scsi-queue, thanks!

[1/8] lpfc: Cancel ELS WQE instead of issuing abort when SLI port is inactive
      https://git.kernel.org/mkp/scsi/c/e999ef15423b
[2/8] lpfc: Allow DEVICE_RECOVERY mode after RSCN receipt if in PRLI_ISSUE state
      https://git.kernel.org/mkp/scsi/c/9609385dd91b
[3/8] lpfc: Relax PRLI issue conditions after GID_FT response
      https://git.kernel.org/mkp/scsi/c/aeaf117cc7d2
[4/8] lpfc: Fix handling of fully recovered fabric node in dev_loss callbk
      https://git.kernel.org/mkp/scsi/c/15e21dc6d6b7
[5/8] lpfc: Handle mailbox timeouts in lpfc_get_sfp_info
      https://git.kernel.org/mkp/scsi/c/ede596b1434b
[6/8] lpfc: Fix incorrect request len mbox field when setting trunking via sysfs
      https://git.kernel.org/mkp/scsi/c/f65f31ac120b
[7/8] lpfc: Revise lpfc_prep_embed_io routine with proper endian macro usages
      https://git.kernel.org/mkp/scsi/c/8bc7c617642d
[8/8] lpfc: Update lpfc version to 14.4.0.3
      https://git.kernel.org/mkp/scsi/c/41972df1a56b

-- 
Martin K. Petersen	Oracle Linux Engineering
