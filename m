Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541804C63
	for <linux-scsi@vger.kernel.org>; Wed, 12 Jun 2024 01:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718157586; cv=none; b=p2vKy7hQ02ozMTsk1znyTiixrJvAIPVT8g8w3uSIWKimtSGe4d8jlfDgrwMEwDglvovVS+XDvLFPm8BSJ3G3aMGdI/SEGhR1p6kiACHIoOGjYI+No3IepZHAV4UePWyxv0p08cPfVnXbAMSYvIsFL7I+p9mDnWjIngE9/WXb124=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718157586; c=relaxed/simple;
	bh=CIsBBA0dxAoOP3cjIHd4wpSDsi/CgcseGPEbg/PhgL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hQri4912HxeZuZDeZmkyJUyM0/HFrWXIJEulVEjmMH8FYIBvdOuq8xF8jIF1aNifKqDWQQNJVMx2TS+zR8IW1gCV/eeKFxrbSLmqXLBbvq13nacvP02tY5FM+I3TP/nA+80bKVer3dJs6/1jfEiZSrrMZ337NhwBuOsC0zDBNUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TJy9r629; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TJy9r629"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45C1tWNd023981;
	Wed, 12 Jun 2024 01:59:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=POPMyr9/+9k4K69oopOMrmXCS5YXacV//VOFTigBmMg=; b=
	TJy9r629xR7yvwjhEJZ44NoRNmNq3CbIHupJXzGuEzcwIoi/Kihjt+GXPCAi/r/o
	VROsrYkNA/ntnNiFhIEOOsOwqB0GSffG6FV+XPtdM/iuNetUQPZwbEFmqRtg++LG
	Q3UOumaWHZBer0TqdXU7dKH0XaD4n03Rs/7P8MXMhYTnN87uagsl7g2d5qrGIm6r
	nmXMvCK0FlyaI2dCgfsLb225OMTvOiv5rSVE+Pn/oBJntMaUNmmOZxJhiBviZ/t+
	g5QkooYetoRXwMvwV9JQ1GDsMEcbvHtXvYTJrKjAB3z1q0xaQ7Mmag+c0GncSFNw
	9uBCCNtdLBcwpZBCiZigig==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymh7fp2uq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Jun 2024 01:59:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45C0WZHF014422;
	Wed, 12 Jun 2024 01:59:42 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ynceusgw9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Jun 2024 01:59:42 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 45C1xfbe034029;
	Wed, 12 Jun 2024 01:59:41 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3ynceusgvu-1;
	Wed, 12 Jun 2024 01:59:41 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/4] Declare local functions static
Date: Tue, 11 Jun 2024 21:59:02 -0400
Message-ID: <171815477640.111825.12718565874170792663.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240603172311.1587589-1-bvanassche@acm.org>
References: <20240603172311.1587589-1-bvanassche@acm.org>
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
 definitions=2024-06-11_13,2024-06-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0 mlxscore=0
 mlxlogscore=436 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406120011
X-Proofpoint-GUID: wUlye4yn8qNBtr_tY7NglqGwxb9d8Q1n
X-Proofpoint-ORIG-GUID: wUlye4yn8qNBtr_tY7NglqGwxb9d8Q1n

On Mon, 03 Jun 2024 10:23:07 -0700, Bart Van Assche wrote:

> There are several 32-bit ARM SCSI drivers that trigger compiler warnings about
> missing function declarations. This patch series fixes these compiler warnings
> by declaring local functions static. Please consider this patch series for the
> next merge window.
> 
> Thanks,
> 
> [...]

Applied to 6.11/scsi-queue, thanks!

[1/4] scsi: acornscsi: Declare local functions static
      https://git.kernel.org/mkp/scsi/c/f5a954bbf2f4
[2/4] scsi: cumana: Declare local functions static
      https://git.kernel.org/mkp/scsi/c/1414045725a0
[3/4] scsi: eesox: Declare local functions static
      https://git.kernel.org/mkp/scsi/c/1dc98be41814
[4/4] scsi: powertec: Declare local functions static
      https://git.kernel.org/mkp/scsi/c/daf613331c93

-- 
Martin K. Petersen	Oracle Linux Engineering
