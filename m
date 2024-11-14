Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C471E8850
	for <linux-scsi@vger.kernel.org>; Thu, 14 Nov 2024 02:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731552672; cv=none; b=kpdnyl+ImmMvQOvZ1ZZwvAwj8tW2N4FbaYVW4nrWb5fW6ynsRWeTDjYSsUWZJjwUJgPuse5YJnG0rBk2v1G20FV1t/CfBAKy09300HOrUCVLKDJLBNpbR9+x/qPB2M5/85V0qyElhNb2hvUIVrqeFRUEvyXK7vJAk/PdYyOPk8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731552672; c=relaxed/simple;
	bh=il08Jrynykib5ULYHqWteBJG3U7vj+x2Y+S7sviduH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LqOZRdw5VPmXmKjd/VAWMnJJHO7xEp+X3cWWeq+qR5zVCjisob7DfM39gmH0XsA5NhJxNZpDkqPZptqdobUncxLQobv7ffhtwmPYXGigDASwkPv59WjFn7ibYDhvOoP9P9Oo7jpu8hTCp5D9zoxeGx7BfwIB2tNK+Shi2pObgdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=I5OPAPri; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="I5OPAPri"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AE1gAnm002009;
	Thu, 14 Nov 2024 02:50:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=6am5X1tdLjFU6NOoBtYKctM+Xp8FKnto9hqJlCTIX7Q=; b=
	I5OPAPriidRaBFDx334jnNschCwy9rXSr48n++Ew4gzcEtwGJYk4NwhTKjA8rt3x
	7Vsi8bfLsD1hkU/zFLyMHlJCLmVLpfUKJP3gbPvfPMOWIhlEt6DfjtnyDAAeq++N
	3VtZF+fEIibdP/8idpGD/HZM06cuGJB8pEz89VljYTCx3RGCYKz4VWGeSb3VDlvK
	XQFEfmDbhzD3eL8bUC40Wpk6xCE0za5GDsj5GfQdJcO0Y41oqOQ2jfJvdut022of
	Pl05uIq/MvkfzOAVYXN1kf6HiDgi50QTosdTCHzFW/4XglW6fPXscvFop+r12Cxp
	1Be6J7Ct+yNQP/Mqt03oAQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0k5g4ek-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Nov 2024 02:50:46 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AE1FYSc022726;
	Thu, 14 Nov 2024 02:50:46 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42vuw0p1w9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Nov 2024 02:50:45 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4AE2ojYi003527;
	Thu, 14 Nov 2024 02:50:45 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 42vuw0p1vg-1;
	Thu, 14 Nov 2024 02:50:45 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Douglas Gilbert <dgilbert@interlog.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] scsi: sg: Enable runtime power management
Date: Wed, 13 Nov 2024 21:49:54 -0500
Message-ID: <173155154791.970810.9973027424389333625.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241030220310.1373569-1-bvanassche@acm.org>
References: <20241030220310.1373569-1-bvanassche@acm.org>
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
 adultscore=0 phishscore=0 malwarescore=0 mlxlogscore=781 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411140021
X-Proofpoint-ORIG-GUID: SS5WIfmzSv9Sro0uW_bZ206-MTybGqLg
X-Proofpoint-GUID: SS5WIfmzSv9Sro0uW_bZ206-MTybGqLg

On Wed, 30 Oct 2024 15:03:10 -0700, Bart Van Assche wrote:

> In 2010, runtime power management support was implemented in the SCSI core.
> The description of patch "[SCSI] implement runtime Power Management"
> mentions that the sg driver is skipped but not why. This patch enables
> runtime power management even if an instance of the sg driver is held open.
> Enabling runtime PM for the sg driver is safe because all interactions of
> the sg driver with the SCSI device pass through the block layer
> (blk_execute_rq_nowait()) and the block layer already supports runtime PM.
> 
> [...]

Applied to 6.13/scsi-queue, thanks!

[1/1] scsi: sg: Enable runtime power management
      https://git.kernel.org/mkp/scsi/c/4045de893f69

-- 
Martin K. Petersen	Oracle Linux Engineering
