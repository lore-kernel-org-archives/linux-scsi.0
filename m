Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B0721CA16;
	Fri, 10 Jan 2025 21:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736543868; cv=none; b=lbrmzR7P5u1HT/1wKY0hYUMg/ShJtfOxagFTJttc+MQ/wpUguYNw4Xe1Djqtna1fhHljXAilGpd5Kk8jLDD666leRAMj7nKCgWufONj1XkYGW0Q1X33H6rQQbqmU26gR3EgtCxw188snAGwOQRKmoZqzECVDViuteZkIfDRVoE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736543868; c=relaxed/simple;
	bh=nVD4eMCMxBn0WgnPMO3k83QE4WmouLg/W8TGizkzMnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ebDngZr4HqoDMQXzAjmVIZilyxqFn6Z+X2JOvPr4Rbimlmhl4HQ2PkHCdcBGpk+39I2CoF5RblG/JoJNWPbPb0iwdUFuDjCUFCEbBscyz13Jj4jt5DywYOONwbJ6er66XBZAjsIvhCSaEGy7jae2ZsQO2Qht6/VUalZVf7coiWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=K0UOAerK; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="K0UOAerK"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50ALBrGC029087;
	Fri, 10 Jan 2025 21:17:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=FuoYb+mfchcnkN6Jlg6jnjBZCTwDlhRUaHpb7oTZYiY=; b=
	K0UOAerK+RIDWHzqoJNbbCAJZvaLC/y6x4RRYpZEmMr0kY7eBo2h3WNz2dmMKXG1
	7ni0CrOJ9pE9PvoZu3mmr4Bvw7jhqwxiVIBmZbiGfmDSvujLGlGprDRxDkBclIFk
	6RNfJTHFTv72KitbGefeibY9tHprKNZ41W5WUGxGr4h86awruqEJng33rBuZWRb8
	FFEPgL6HBFBE3WqZN4qyohoJWwHeW5EppvxYE+TKrhstg2xid2WHGSk8NtKmQP92
	bSZlwOQUhRHXNIkLBO82DfG4Zdwh5FqtHlEOkQkc1tboYktGt/mHXN3MKV+v2j24
	WL2UZSSp7lIR5p1pCn4MGg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43xuk0c39h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 21:17:45 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50AL9SKj027555;
	Fri, 10 Jan 2025 21:17:44 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43xued5rau-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 21:17:44 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 50ALHQ2I034137;
	Fri, 10 Jan 2025 21:17:44 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 43xued5r3k-15;
	Fri, 10 Jan 2025 21:17:44 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, Siddharth Menon <simeddon@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] Drivers/scsi: Fix variable typo
Date: Fri, 10 Jan 2025 16:16:57 -0500
Message-ID: <173654330183.638636.2418144507673434833.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241210040202.11112-1-simeddon@gmail.com>
References: <20241210040202.11112-1-simeddon@gmail.com>
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
 definitions=2025-01-10_09,2025-01-10_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=815 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501100164
X-Proofpoint-ORIG-GUID: HzvjLOxakFNjush2HF4yC5t-UCtxK8LX
X-Proofpoint-GUID: HzvjLOxakFNjush2HF4yC5t-UCtxK8LX

On Tue, 10 Dec 2024 09:32:02 +0530, Siddharth Menon wrote:

> Renamed ESP_CONGIG4_TEST to ESP_CONFIG4_TEST
> 
> 

Applied to 6.14/scsi-queue, thanks!

[1/1] Drivers/scsi: Fix variable typo
      https://git.kernel.org/mkp/scsi/c/c13b10a754bc

-- 
Martin K. Petersen	Oracle Linux Engineering
