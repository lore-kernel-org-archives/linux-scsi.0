Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA6E52F44
	for <linux-scsi@vger.kernel.org>; Sat, 17 Aug 2024 01:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723858164; cv=none; b=ER5M52juFoD3x/clI4LJRQCDZPkDkdX44ut/euG6pARFLdxs5o5mfU4fVg+PiCzh6WgQ7XJFEWBTvklZm8E/5/4l/xI3A2Y6y2iBZjx/Kum3UQuFStxYlHCKbA1JFihdCPI5nfBPlYurSW7ikz8NIrFQtuBGyWaPsRd3ZRHVhwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723858164; c=relaxed/simple;
	bh=hPgSIvnVfLsBfLgWSAcfSLNKTcIyq1/RAkxktuDVCoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sjrvskhpe0pjqnhRW2Ww+Lz25T+TAX2VzFPFgh/1rp4SayB27LdWNM5J7A9Glg5kubK1rUn+lQ35F4NmmV50MKFleybcG7nt8wmtLyu52OuoJiB2EPELiLdAyVZ6emGmI9BEPbOQ5KBvYhqb58xj3XDtfFWHTZqEkLUY+uh32uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KttUpsqq; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KttUpsqq"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47GLC8d7008064;
	Sat, 17 Aug 2024 01:29:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=jWq8iy0QcCUh8lljM+41u3cTBNBcvo25DZMmZlabuYE=; b=
	KttUpsqq7bz9w6j3EflK9hMpPvsBhxm+QbYI78SOq89Rys/O/flIYWqFcdFSk8Lz
	n3UWLJeoL4L1wVXZkkt+e6qVuvjkRqRfKDTjsB43dnoZ8wcA0s+xTPrzH+5cui+s
	uMT2/UwDCTbxJbUaos3cyor0nlSLOG+3BSn3UrdPEbt50lOb2/B2wHN4xi7sQdMi
	f3ScIe6MMBc/k/4ESK2kM+okPI+QnaXQkpyL6hM6T5tbASa48FVpzgChbcRXi+HJ
	vFQ5aNzlf7Yy73BVNcB9Z2EKyGGRnbUb9JQt/b5rTtDwn2y19KaFezCahN7heDK2
	CuHYYTUYtoqLaOJhdZsvqA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40wy4bnuu2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Aug 2024 01:29:15 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 47GMJwPe020583;
	Sat, 17 Aug 2024 01:29:14 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40wxnkh7w5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Aug 2024 01:29:14 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 47H1TDaY025300;
	Sat, 17 Aug 2024 01:29:13 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 40wxnkh7vt-2;
	Sat, 17 Aug 2024 01:29:13 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Simon Horman <horms@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Add header files to SCSI SUBSYSTEM
Date: Fri, 16 Aug 2024 21:28:35 -0400
Message-ID: <172385808995.3430657.3413667240408813977.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240816-scsi-mnt-v1-1-439af8b1c28b@kernel.org>
References: <20240816-scsi-mnt-v1-1-439af8b1c28b@kernel.org>
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
 definitions=2024-08-16_18,2024-08-16_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 phishscore=0 malwarescore=0 suspectscore=0 spamscore=0 mlxlogscore=684
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408170009
X-Proofpoint-GUID: ZmuvsztyZVCX7G3gIZotXVkCLGuPe1hs
X-Proofpoint-ORIG-GUID: ZmuvsztyZVCX7G3gIZotXVkCLGuPe1hs

On Fri, 16 Aug 2024 13:59:56 +0100, Simon Horman wrote:

> This is part of an effort to assign a section in MAINTAINERS to header
> files that relate to Networking [1]. In this case the files with "net" in
> their name.
> 
> [1] https://lore.kernel.org/netdev/20240816-net-mnt-v1-0-ef946b47ced4@kernel.org/
> 
> As part of that effort these files came up:
> * include/uapi/scsi/scsi_netlink_fc.h
> * include/uapi/scsi/scsi_netlink.h
> 
> [...]

Applied to 6.11/scsi-fixes, thanks!

[1/1] MAINTAINERS: Add header files to SCSI SUBSYSTEM
      https://git.kernel.org/mkp/scsi/c/cd612b57c367

-- 
Martin K. Petersen	Oracle Linux Engineering
