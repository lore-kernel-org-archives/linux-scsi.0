Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5BB433C4
	for <linux-scsi@vger.kernel.org>; Tue,  5 Nov 2024 02:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730774029; cv=none; b=Z1fypHR09WeoIV6UtTW09oot28XbXE0TpyM8OW1ciuVYQlw5GbnaBGdKsujnnhjFMKe+TyaHvEUCiyX4zSSTz6Ss6fu7FSEHdGsRMMoub7K5okax3n+NsbZ0rwVySsFhF6k8y7cpD4zXJPNYL7IH1nodAgiu6wkePmGgJtsSyT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730774029; c=relaxed/simple;
	bh=5uda3O649r38llld6SicMjccSkaJG3Tzo7pjzeisuhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZwjIe0bm6CFpkVZcgo8GXoB4lICIoyp7MFfUFZfgWk5mTjXTsKsbjHA1riu7nTsHOcBCymDGdUU9w8XoFHJnp6/oGpOjty3zjWAt8YqKxCU9nlsutJ6C1EhRNuklyu4Dt0+Y2DrccsTBzL4mpQAm3uwzLG3G+BsRjJSEs81hpow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=a/f2qNQZ; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="a/f2qNQZ"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A52MYhc016795;
	Tue, 5 Nov 2024 02:33:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=dmT4gSVFYRaOegQuJhd23JNNy96qvG/hc3dAKGZ+s64=; b=
	a/f2qNQZjO3izoGdP/yMGvHHKUnjJyCRDo18jraEFRjlC/F1IxVNsEvIuT7tHlZP
	FReEOHHxqVk/Ez9t2g9IGgwRx+54xDSv/Ucre4yk9DuZDFWHnmWuFQ7JWaPdxlkd
	j+UjDv58Taep4j4lOiJIXAncQmiXRgsNdYrh+AX2QOz5yR9tp4mPEj5m4DpLLvac
	8eZr4emeCvyTfPoENfwUd7GFHkGWMmC/g6ls7O2TNOJLYg1SWcuJ5OB7YekOA7Qy
	Dh8nBN8250+fjCQxiQBk4p1DRbQxhKkG5pnDMJKf9vXAZGfSDqG39m/BLl8+7Z+p
	Y1xlDi7YGC7xKyHmUemfHA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42nagc4906-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 05 Nov 2024 02:33:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A52IHew036832;
	Tue, 5 Nov 2024 02:33:33 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42nah6g2kx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 05 Nov 2024 02:33:33 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4A52XVFu017503;
	Tue, 5 Nov 2024 02:33:32 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 42nah6g2k1-5;
	Tue, 05 Nov 2024 02:33:32 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v6 00/11] Combine the two UFS driver scsi_add_host() calls
Date: Mon,  4 Nov 2024 21:32:51 -0500
Message-ID: <173077364682.2354920.148933117502221819.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241016201249.2256266-1-bvanassche@acm.org>
References: <20241016201249.2256266-1-bvanassche@acm.org>
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
 definitions=2024-11-04_22,2024-11-04_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=651
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411050019
X-Proofpoint-ORIG-GUID: z4mNU_llOoCYCd9JsE9geBjS2tX1uSdi
X-Proofpoint-GUID: z4mNU_llOoCYCd9JsE9geBjS2tX1uSdi

On Wed, 16 Oct 2024 13:11:56 -0700, Bart Van Assche wrote:

> In the UFS driver the legacy and MCQ scsi_add_host() calls occur in different
> functions. This patch series reduces the number of scsi_add_host() calls from
> two to one and hence makes the UFS driver easier to maintain.
> 
> Please consider this patch series for the next merge window.
> 
> Thanks,
> 
> [...]

Applied to 6.13/scsi-queue, thanks!

[01/11] scsi: ufs: core: Introduce ufshcd_add_scsi_host()
        https://git.kernel.org/mkp/scsi/c/17a973970397
[02/11] scsi: ufs: core: Introduce ufshcd_post_device_init()
        https://git.kernel.org/mkp/scsi/c/3192d28ec660
[03/11] scsi: ufs: core: Call ufshcd_add_scsi_host() later
        https://git.kernel.org/mkp/scsi/c/7702c7f64f2d
[04/11] scsi: ufs: core: Introduce ufshcd_process_probe_result()
        https://git.kernel.org/mkp/scsi/c/18ec23b60822
[05/11] scsi: ufs: core: Convert a comment into an explicit check
        https://git.kernel.org/mkp/scsi/c/093600132264
[06/11] scsi: ufs: core: Move the ufshcd_device_init() calls
        https://git.kernel.org/mkp/scsi/c/639e2043b589
[07/11] scsi: ufs: core: Move the ufshcd_device_init(hba, true) call
        https://git.kernel.org/mkp/scsi/c/69f5eb78d4b0
[08/11] scsi: ufs: core: Expand the ufshcd_device_init(hba, true) call
        https://git.kernel.org/mkp/scsi/c/a390e6677f41
[09/11] scsi: ufs: core: Remove code that is no longer needed
        https://git.kernel.org/mkp/scsi/c/b6195d02b914
[10/11] scsi: ufs: core: Move the MCQ scsi_add_host() call
        https://git.kernel.org/mkp/scsi/c/72e979225ed2
[11/11] scsi: ufs: core: Move code out of an if-statement
        https://git.kernel.org/mkp/scsi/c/b92e5937e352

-- 
Martin K. Petersen	Oracle Linux Engineering
