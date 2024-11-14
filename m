Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A14121E412E
	for <linux-scsi@vger.kernel.org>; Thu, 14 Nov 2024 02:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731552657; cv=none; b=OGnIKpa7VFRnr9XBNg07wIri2PMnegYTObl7/QdeBRGxg7xMLpYwBkpevNOaSj8ezHtr+VOK2YiOUjXGqMixDP47u0JOv6+kbBRq4BLcwsMrylEka1c8XJutLrKcJ7Occ1syIrWfIdzkdD88C2DK9LlGIIfaoA4WVz4+WL/r60A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731552657; c=relaxed/simple;
	bh=ZZx72ay3gCPQ8vNcWV9ydckwE1z6LCS7jbYm+nmqweU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BTverU2Ir8zyXMH5CuUt3FZ4GKC3p75RUPhjWSYpMM76xpqlW5Rm3NCCyEFDmi3IfSofiteK9xbw338EIHU26pAxxilyMtX9DabFq1h/zotDIoDxzRKmlz7qrLCYisTIdiCty1YGvnl4VA9XM+yIAAnBhiE0/mIsT1/pn4C9Pq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DYLz/DI8; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DYLz/DI8"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AE1gWT6002826;
	Thu, 14 Nov 2024 02:50:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=bfcfq/vgCq+iGmi1nco+4Ax0D7MmL5nQmep/x5q+D1w=; b=
	DYLz/DI84OXRLr5mCqqO2T/DZ6e43voci7I1FDD4WjCMRUeUFdjMAlO4BfEIQR6H
	FUQRlkR++AYhQDSF5IG+yonOdrN5AuY7sa3qspm0Nq7rVlYqTYxe5/CvNjcc07L8
	vA+jzAASe7VZDnE7OLiWp/I14JPMIQyM9mQazYXC7YK2as3aFINFydaq+yjIqUoA
	GC00x+MYx2oIJnHFG/Z5jATPysfZyhR9AnKalfB1Yzsq+bjoiyxXVPbBMafOg0dz
	5hi2WoC5Zx0K3vw14DjWqwU70jaFPuKUQk7gWBDmlrgHHnLLlFT5HJleduRQsd0l
	u994rpbocmiAG5ZbLcEkHQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0k5g4ep-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Nov 2024 02:50:53 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AE1AUWG022725;
	Thu, 14 Nov 2024 02:50:52 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42vuw0p20e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Nov 2024 02:50:52 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4AE2ojYs003527;
	Thu, 14 Nov 2024 02:50:51 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 42vuw0p1vg-6;
	Thu, 14 Nov 2024 02:50:51 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Justin Tee <justintee8345@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, jsmart2021@gmail.com,
        justin.tee@broadcom.com
Subject: Re: [PATCH 00/11] Update lpfc to revision 14.4.0.6
Date: Wed, 13 Nov 2024 21:49:59 -0500
Message-ID: <173155154805.970810.15787564406197339264.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241031223219.152342-1-justintee8345@gmail.com>
References: <20241031223219.152342-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-14_01,2024-11-13_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 phishscore=0 malwarescore=0 mlxlogscore=519 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411140021
X-Proofpoint-ORIG-GUID: sWQ-nLq8EJCSa3htm6pJybt__P25TV_V
X-Proofpoint-GUID: sWQ-nLq8EJCSa3htm6pJybt__P25TV_V

On Thu, 31 Oct 2024 15:32:08 -0700, Justin Tee wrote:

> Update lpfc to revision 14.4.0.6
> 
> This patch set contains bug fixes related to congestion handling,
> accounting for internal remoteport objects, resource release during HBA
> unload and reset, and clean up regarding the abuse of a global spinlock.
> 
> The patches were cut against Martin's 6.13/scsi-queue tree.
> 
> [...]

Applied to 6.13/scsi-queue, thanks!

[01/11] lpfc: Modify cgn warning signal calculation based on EDC response
        https://git.kernel.org/mkp/scsi/c/29a64210c767
[02/11] lpfc: Check devloss callbk done flag for potential stale ndlp ptrs
        https://git.kernel.org/mkp/scsi/c/4c113ac05bb2
[03/11] lpfc: Call lpfc_sli4_queue_unset in restart and rmmod paths
        https://git.kernel.org/mkp/scsi/c/d35f7672715d
[04/11] lpfc: Update lpfc_els_flush_cmd to check for SLI_ACTIVE before BSG flag
        https://git.kernel.org/mkp/scsi/c/940ddac89612
[05/11] lpfc: Check SLI_ACTIVE flag in FDMI cmpl before submitting follow up FDMI
        https://git.kernel.org/mkp/scsi/c/98f8d3588097
[06/11] lpfc: Add cleanup of nvmels_wq after HBA reset
        https://git.kernel.org/mkp/scsi/c/eb038363d8e9
[07/11] lpfc: Prevent ndlp reference count underflow in dev_loss_tmo callback
        https://git.kernel.org/mkp/scsi/c/4281f44ea8bf
[08/11] lpfc: Remove NLP_RELEASE_RPI flag from nodelist structure
        https://git.kernel.org/mkp/scsi/c/32566a6f1ae5
[09/11] lpfc: Change lpfc_nodelist nlp_flag member into a bitmask
        https://git.kernel.org/mkp/scsi/c/92b99f1a73b7
[10/11] lpfc: Update lpfc version to 14.4.0.6
        https://git.kernel.org/mkp/scsi/c/3f8175c0a859
[11/11] lpfc: Copyright updates for 14.4.0.6 patches
        https://git.kernel.org/mkp/scsi/c/5c169625d89e

-- 
Martin K. Petersen	Oracle Linux Engineering
