Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D0B63A1
	for <linux-scsi@vger.kernel.org>; Tue, 13 Feb 2024 01:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707789474; cv=none; b=Gkd+AHz9PZzEDqZas/LOCqMiKEPW9UU4rKxPFL3Ie09K7lyo+wwPBMaS5ziJJ0Lkl4pSoTAB7l4YMSQtsUwMyh37rGlkwIldqrAQ5L6UyTCzd5ielLf/RFiqiDYw4t6JFlkWDGL+Wv5nyumAt0slci8ma5VRGGcBM/nGLnURU4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707789474; c=relaxed/simple;
	bh=Eda0qraDzmS8PbUG6aeUDNSTEEi0oSfFgrx9n6fzXGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WLYBwHa/02XlXG/ar1YJmc5VeobhtWH8syY4uAP3lrAsL2kYRzuQmIoDSDSK5kNjMwxDjqoQlHqnMoeBwYuIzt3keX/VXVxvTr0oCWyAcbkEdC82PmwNvIYwYY6h4SPnDLOi+SPA/PLHqk6Ou1+c5u5IwSd5C0KjvU0SMRf4mSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mmyJ595M; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mmyJ595M"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41D1hmx2006419;
	Tue, 13 Feb 2024 01:57:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=hmuZT7EtKJ11FDKMBvgrGj/E6kxV8Vv0eCEF8mb2bbM=;
 b=mmyJ595MkQ9bkDHc+rut2qaJZvrJBKoPMFM5fBLzM/1RRZa6alZfqmTH7hTEbIfaCxg7
 nJm4J2igXqQIwZLCE+xFujuE4QCOcwhm6pjCxV/bpdbS8rOVP4ZJkQfeTyR1nIVpsPCu
 rB252fHavpSZHw/w2PhM20D8L7gDrPG/TnieJg1aI5dyRHI4cj+UjRnFEnrr5UDZjVaj
 EFlDgdMdEEO0PL1vtjxSVnCcQgLDn7eYH8aX1LJibcfNZZt+8sqGjs5mTD2Q96PUUL7B
 1dbbcQNYiz8jtZIOrHpAh4TuE7oI5YSiBVzwJpq5CWwaWveOHgeS+my6JiXorG8IRHw0 oQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w7xt500xh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Feb 2024 01:57:50 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41D10gwl024566;
	Tue, 13 Feb 2024 01:57:49 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3w5ykcw3ac-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Feb 2024 01:57:49 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 41D1vm1h022232;
	Tue, 13 Feb 2024 01:57:49 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3w5ykcw3a9-1;
	Tue, 13 Feb 2024 01:57:48 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Justin Tee <justintee8345@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, jsmart2021@gmail.com,
        justin.tee@broadcom.com, himanshu.madhani@oracle.com
Subject: Re: [PATCH v2 00/17] Update lpfc to revision 14.4.0.0
Date: Mon, 12 Feb 2024 20:57:41 -0500
Message-ID: <170778686835.2103627.3025860483050076365.b4-ty@oracle.com>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20240131185112.149731-1-justintee8345@gmail.com>
References: <20240131185112.149731-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-12_20,2024-02-12_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402130011
X-Proofpoint-GUID: JGXsBFm06cItdI0-wGssnTbXhq_T5msr
X-Proofpoint-ORIG-GUID: JGXsBFm06cItdI0-wGssnTbXhq_T5msr

On Wed, 31 Jan 2024 10:50:55 -0800, Justin Tee wrote:

> Update lpfc to revision 14.4.0.0
> 
> This patch set contains fixes identified by static code analyzers, updates
> to log messaging, bug fixes related to discovery and congestion management,
> and clean up patches regarding the abuse of shost lock in the driver.
> 
> The patches were cut against Martin's 6.9/scsi-queue tree.
> 
> [...]

Applied to 6.9/scsi-queue, thanks!

[01/17] lpfc: Initialize status local variable in lpfc_sli4_repost_sgl_list
        https://git.kernel.org/mkp/scsi/c/3d0f9342ae20
[02/17] lpfc: Fix possible memory leak in lpfc_rcv_padisc
        https://git.kernel.org/mkp/scsi/c/2ae917d4bcab
[03/17] lpfc: Use sg_dma_len API to get struct scatterlist's length
        https://git.kernel.org/mkp/scsi/c/aa7674bd8da5
[04/17] lpfc: Remove D_ID swap log message from trace event logger
        https://git.kernel.org/mkp/scsi/c/b76beac1a4f5
[05/17] lpfc: Allow lpfc_plogi_confirm_nport logic to execute for Fabric nodes
        https://git.kernel.org/mkp/scsi/c/e1b3acad0d7b
[06/17] lpfc: Remove NLP_RCV_PLOGI early return during RSCN processing for ndlps
        https://git.kernel.org/mkp/scsi/c/a801d57a110d
[07/17] lpfc: Fix failure to delete vports when discovery is in progress
        https://git.kernel.org/mkp/scsi/c/7bb6cb7bb21c
[08/17] lpfc: Add condition to delete ndlp object after sending BLS_RJT to an ABTS
        https://git.kernel.org/mkp/scsi/c/900db34ad265
[09/17] lpfc: Save FPIN frequency statistics upon receipt of peer cgn notifications
        https://git.kernel.org/mkp/scsi/c/6ca396c5e3c4
[10/17] lpfc: Move handling of reset congestion statistics events
        https://git.kernel.org/mkp/scsi/c/140bd888ed0d
[11/17] lpfc: Remove shost_lock protection for fc_host_port shost APIs
        https://git.kernel.org/mkp/scsi/c/4be4ad6cd237
[12/17] lpfc: Change nlp state statistic counters into atomic_t
        https://git.kernel.org/mkp/scsi/c/0dfd9cbc187c
[13/17] lpfc: Protect vport fc_nodes list with an explicit spin lock
        https://git.kernel.org/mkp/scsi/c/9bb36777d0a2
[14/17] lpfc: Change lpfc_vport fc_flag member into a bitmask
        https://git.kernel.org/mkp/scsi/c/a645b8c1f5bc
[15/17] lpfc: Change lpfc_vport load_flag member into a bitmask
        https://git.kernel.org/mkp/scsi/c/e39811bec6b1
[16/17] lpfc: Update lpfc version to 14.4.0.0
        https://git.kernel.org/mkp/scsi/c/5b22878daf48
[17/17] lpfc: Copyright updates for 14.4.0.0 patches
        https://git.kernel.org/mkp/scsi/c/ea4044e4dd0d

-- 
Martin K. Petersen	Oracle Linux Engineering
