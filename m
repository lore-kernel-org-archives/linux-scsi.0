Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3EFA211C;
	Mon, 10 Feb 2025 02:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739156354; cv=none; b=p5QLzAUyCL0Ddyzt1aXd/8s+WI7slkSulEkMkgzAQA4kDjBP7sYvdh1e9pkjh/rnBfXH5AIeXlkuPVrcFqBVC5tAxzqLIlHxO2OUykig6A6n5eTrYj7X0PFiHbcvOpqU02RC7FtvO/w29ss3FMEGwFrn+ulhL0pUT7USVxKeTE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739156354; c=relaxed/simple;
	bh=1IngeWnOnd5ExsVUi+FqRNHBHpXKN4ACrc09jCAF708=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d3pnz9XBi+ZfuJ4Oce/qfpz76Mjr5346UsuxEuq7mudh62SuiczIV1BoIbnupty6DZ5jz3iauPwc0BCPvNrlyWG++B5ORvByimL2LycKcfPot2JCkU7026M4YjV9eVok30AvRbURSOB4SbSg8caT83neZzkkysjoE/NMxZHoZ/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oUwscDqN; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oUwscDqN"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 519NOdok006949;
	Mon, 10 Feb 2025 02:59:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=2HY6I2H5FXE3P3JQlcbUZ8ssm2W+IZLYDVu7/YBH9Lo=; b=
	oUwscDqNDgxdq/+Guvpon0pQrgXsyZnlxFpOELJBLfCGoe/u+oCZspMWmOXV6AAd
	EeJankxjxieGYMcUSasS3aubt9C1g5ZIAUZW+acq9NZvGF7hiRVFrX7wf7mlAaqQ
	VPxHZ4J0p1AZzGv4MJ7VvReUw9lrK2OxWMhhcQ/XaAfVx+kluFxFEekxowbQdxat
	ofbFXMe/GZbG6i9BI2BSEPEp5AurZBUHOMjdCw1zHkVm/azEz/LIlQQfJQafpLPb
	hxmFhYfsgW7Icb/5ArQM/EDD1R09+cmD3SdLTqPfOvfLqp2Vy1lpAaVgGKIcuW24
	zuinosdqY68a+xh6Uuu54Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44p0t422kd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Feb 2025 02:59:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51A2C9xN012543;
	Mon, 10 Feb 2025 02:59:08 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44nwq6uaey-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Feb 2025 02:59:08 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 51A2vwAf033952;
	Mon, 10 Feb 2025 02:59:07 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 44nwq6uacs-5;
	Mon, 10 Feb 2025 02:59:07 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com,
        MPT-FusionLinux.pdl@broadcom.com, linux@treblig.org
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: message: fusion: Remove unused mptscsih_target_reset
Date: Sun,  9 Feb 2025 21:58:27 -0500
Message-ID: <173915612136.10716.11373800146661952717.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250127002716.113641-1-linux@treblig.org>
References: <20250127002716.113641-1-linux@treblig.org>
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
 definitions=2025-02-10_02,2025-02-07_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=914 mlxscore=0 spamscore=0 suspectscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502100023
X-Proofpoint-ORIG-GUID: 0Thf06BA9WKSR8qewWC0zAX7NnEU-OcR
X-Proofpoint-GUID: 0Thf06BA9WKSR8qewWC0zAX7NnEU-OcR

On Mon, 27 Jan 2025 00:27:16 +0000, linux@treblig.org wrote:

> mptscsih_target_reset() was added in 2023 by
> commit e6629081fb12 ("scsi: message: fusion: Correct definitions for
> mptscsih_dev_reset()")
> but never used.
> 
> Remove it.
> 
> [...]

Applied to 6.15/scsi-queue, thanks!

[1/1] scsi: message: fusion: Remove unused mptscsih_target_reset
      https://git.kernel.org/mkp/scsi/c/b932ff7d0459

-- 
Martin K. Petersen	Oracle Linux Engineering
