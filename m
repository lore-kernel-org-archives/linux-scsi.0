Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A1129A0;
	Tue, 10 Jun 2025 02:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749521246; cv=none; b=X6RMSIMqjoIO0gzp0H5nZ3RIBPvQTO2pS+LzjTvIOz0Q29d6wWvO+4T+wVfXOyOtYIfxF3UiWrlI8xz8dgzU0+H3+yeFzBw1NLOrUjBk4QOWuQgxkuVZz0ckpEMsEwKfhONRK4zNaypJAgs1KL/WZ6Ja+HPXWgkBSVIODUyk0wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749521246; c=relaxed/simple;
	bh=e5O5KvtfwWvvvASIfXLP6mixs31hlM0v6Xm94NcQkc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nxAtrXVXH3ynNWYE6bHA/W27RvDQinb3hbTmcC8VQ29jAktU5vFNOhY4ixhCCo4So/oIOqR7dCg7Yhxe723X8Z3RiNS1SzRAfA11gZ8CcTWqhKbG4Pp2kOdQM2Fo5OgfzGIp3dULwuh7ajF2e5xSiytT/A3M2e1qPNTx/UBYsyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YBJaUz1D; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YBJaUz1D"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 559FcTxx031955;
	Tue, 10 Jun 2025 02:07:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=hyI4TvBXfKLKWM+nUb5A5Mw3PYe/GOv6hCN5q1ZmPUU=; b=
	YBJaUz1DuzwUYRGZ/PmsJ5BMsFMUB0rNsHrANVVkreDdImyv+PlSPIq8mgn3Kyqi
	I12QHwDtnSIieKzwiT/9mcHFTBWA/5YDwMD1UeR1va88orNsrhIcF8KspKfCuInQ
	T3KeySS7tuulZtZT7O6jpWGPvi0lOKJ4aXtxdQEZlbICxP+s3i0DFeDaJJyraU1O
	woQ5kHWRGto6AQ5miNdSqYuNUJ3Jwggu4xXvvZ/faWwbTD3/yHft/48tsUVJ1/93
	oOVulENM7mWowEojvoMl4gfKPsdDoHBMdkVTbrOimM7mhBk20dUv1iw73NGTubMS
	yG68zSKypfxnnPBboPchNQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 474d1v39dh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Jun 2025 02:07:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55A0tpH0031405;
	Tue, 10 Jun 2025 02:07:21 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 474bv84jfu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Jun 2025 02:07:21 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 55A27Kqw016523;
	Tue, 10 Jun 2025 02:07:21 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 474bv84jet-2;
	Tue, 10 Jun 2025 02:07:21 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James.Bottomley@HansenPartnership.com,
        Ankit Chauhan <ankitchauhan2065@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: mvsas: fix typos in per-phy comments and SAS cmd port registers
Date: Mon,  9 Jun 2025 22:06:46 -0400
Message-ID: <174951883626.1141801.1614094922768237098.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250528110604.59528-1-ankitchauhan2065@gmail.com>
References: <20250528110604.59528-1-ankitchauhan2065@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-10_01,2025-06-09_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 suspectscore=0
 phishscore=0 malwarescore=0 mlxlogscore=929 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506100014
X-Proofpoint-GUID: djSOGbWYOS3DjvEjwiIKgNW4WX-4eZXB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjEwMDAxNCBTYWx0ZWRfXz2B8OLzypap5 u2eTMpRk3qeWZL3OaoM19h9j0PxbhlStyzRWzkP7j3TP/0IFlCroqcZs1U2GMktxR3Rfs7S2YnJ GB8RkkA7KJ7KgY/6mAUiE6A2SvLEsn0ckqY2qZmWr1xAcZavEJb/aYuODdysvGjq+kslOYS8TZ1
 WR6AEziC13zsArOmHHU2FOn/QfpKJYkgs6fkwcc16kouQ9VAAqYjWFwLQdiRNQ6pm+7VEGJN1/3 w3OCd2UHNVmvOZiOpZk2X8V7wXLLV2IRqY+GQIu4QLI0OXD7UVgZk+RWalYf/xg6DSkY+F5QUGm yVNsSb/1vK5Y74C3s/ROI72twsiEWW5wnImJLF7ZFEryxdFQ4WxCg4Q1Bwh67vlhN7zm/Zqr8nJ
 wUO6EFTckRlKOG/6sUEASvomlyHehT7sy+7lP06jyhim4+eC8tdu/Qo0WkzKg/eXfjdog/Sq
X-Proofpoint-ORIG-GUID: djSOGbWYOS3DjvEjwiIKgNW4WX-4eZXB
X-Authority-Analysis: v=2.4 cv=d731yQjE c=1 sm=1 tr=0 ts=6847935a cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=i4bYIVD2DNLvW2J3l1cA:9 a=QEXdDO2ut3YA:10

On Wed, 28 May 2025 16:36:04 +0530, Ankit Chauhan wrote:

> Spelling fixes:
> Deocder --> Decoder
> Memroy --> Memory
> 
> This is a non-functional change aimed at improving code clarity.
> 
> 
> [...]

Applied to 6.16/scsi-fixes, thanks!

[1/1] scsi: mvsas: fix typos in per-phy comments and SAS cmd port registers
      https://git.kernel.org/mkp/scsi/c/ad0f54842cd2

-- 
Martin K. Petersen	Oracle Linux Engineering
