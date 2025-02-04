Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FFFA15689A;
	Tue,  4 Feb 2025 03:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738640130; cv=none; b=XvWmDGSlTMfD4/Q2LzDa8qsZf5ofnZDuWLXmX6KnHv9VGeZbD3ygErm63wAh8uzD1WjU+Q0A0j/4NQdQ2jm8l7j1pqA9c11xKi53NmbiZSyelifQ0/pUOlIdlavVxbcvjphO0/a34424/hF1cR6jQjvAyde+PTyuPvX2tWgqtRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738640130; c=relaxed/simple;
	bh=etkXxkIr3zgxbeBq1yYcYuI8y1wCVh04F5Jwz4gyllc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uYdIhKzsvIubkZ23iWvgbWULkkgbSgYavn9oy8xgK9X0wO3veido+CU70yD6ok0mLnSBFVVmciOCt/xcowgK5//wd4Rz/Rk2GmwB1WZB/nplvh3Z25v27VUa8YFBgz5q8Szo8jvEou6YgJUC6ITw8BBH/5UjqJXsSJtpF2iHOKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=j5Kh5xFS; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="j5Kh5xFS"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5141MsMt020492;
	Tue, 4 Feb 2025 03:34:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=reXDLEnqVMPPLX1BJU34BSBU13kXVWrcjmGU7TLM9B0=; b=
	j5Kh5xFSGMsivTeUjtRA1/NhVbzpU63eKNawlfCYCS9Xma+eTEYEnLosbqi5hLsH
	ewvBsUy49RxIEqouOwwn7FZH/7psdiC0fW6JWis05CkM1WLPOBa3p4wi9r/sUtR/
	tC6b/XUCJiUnTSfbmMS7MEYT033VgkmacuyB4rXx6+rLq5NYtX2L1Xf20CS8SqG/
	slUMnzWawcXWFbZ/M4c2oueQwz9/zcfbDlGmu0639gNlj2KWlpkF81mCHxbtWdwO
	rqEUECuAxTg0jTRyB4HqJBzLHMgLwFyYYKcqCpJu9BBH4ykV+XlkXg1363i3zZRc
	tSuW2Lb2vqog5SWjWsy5zA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44hfcgv427-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Feb 2025 03:34:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5140E0mK038932;
	Tue, 4 Feb 2025 03:34:00 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8e76f1c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Feb 2025 03:34:00 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5143Xs6s015172;
	Tue, 4 Feb 2025 03:33:59 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 44j8e76ex2-5;
	Tue, 04 Feb 2025 03:33:59 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Christoph Hellwig <hch@infradead.org>, Rik van Riel <riel@surriel.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        =?UTF-8?q?Marc=20Aur=20=C3=A8le=20La=20France?= <tsi@tuyoix.net>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@meta.com
Subject: Re: [PATCH v2] scsi: use GFP_NOIO to avoid circular locking dependency
Date: Mon,  3 Feb 2025 22:33:08 -0500
Message-ID: <173863996275.4118719.4750343805511377444.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250129104525.0ae8421e@fangorn>
References: <20250128164700.6d8504c1@fangorn> <Z5m-FuU7wJsUoSST@infradead.org> <20250129104525.0ae8421e@fangorn>
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
 definitions=2025-02-04_02,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=647
 phishscore=0 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502040026
X-Proofpoint-GUID: sJMFBtJ4q7v3HiPmOuVCjJ-Fxbu0ZXDt
X-Proofpoint-ORIG-GUID: sJMFBtJ4q7v3HiPmOuVCjJ-Fxbu0ZXDt

On Wed, 29 Jan 2025 10:45:25 -0500, Rik van Riel wrote:

> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> Filesystems can write to disk from page reclaim with __GFP_FS
> set. Marc found a case where scsi_realloc_sdev_budget_map
> ends up in page reclaim with GFP_KERNEL, where it could try
> to take filesystem locks again, leading to a deadlock.
> 
> [...]

Applied to 6.14/scsi-fixes, thanks!

[1/1] scsi: use GFP_NOIO to avoid circular locking dependency
      https://git.kernel.org/mkp/scsi/c/5363ee9d110e

-- 
Martin K. Petersen	Oracle Linux Engineering
