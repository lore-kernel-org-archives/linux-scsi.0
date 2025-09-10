Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0018F4A;
	Wed, 10 Sep 2025 03:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757473472; cv=none; b=Nj7A4cUMbyV5+Ay9Fb790BI2Chtxcnqsw/o65RegAmP3V5AO/SUgXFW6ZL76fufEdzsgWicN+fYySwxp5EnGaRs/B0pcj35g1czjAlMnAQRMbVWNdqJxSB12enheUZs5Luzn29Rl+QGAy0H3lsw0gTqOx98YMkRvXqWo0/xRFsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757473472; c=relaxed/simple;
	bh=8vM6q6rKNwCyDlNLJkBBEpgor18DKoRDa4kVxCvLSio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JOOmjIxpIyuV/N/TvqEd0TxFM1llHk2AVIdz4MQzw/0S5qjh56NmWhOVVm1WHZnmrSAQyv86iWtK04R7VnsIgqdWSqc9nJKBpTOUxWI5dEWAWy6dPHwgS+SxEoMkIEwJwUnsDW4LET6DXzOJZ6z2xlfH16DpXkOXStpruo1aySw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mYc017R2; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mYc017R2"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 589L0gAo031116;
	Wed, 10 Sep 2025 03:04:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=KL4t9EfLRkiw72wM2uBuCwhWndW37uOec8qj33ZcXuY=; b=
	mYc017R2CwB+E7PYeB4HbPoP2of49qKWMKP2A18D7huSJ2kP99jmTtnU0RDoaaGU
	dmWFb+3q3EWD8ENR0Sc68WhnGLrTSqntARwidvh9EbBMdCFeqHoRZW6nNUExzyq8
	D13oOH//GOTVibZ2nnwAkLfrEcaxTWpAOf98K2GgLd9EErzKJStycGwXJQGSzd0J
	Z4v2Ntiqv1/vnl2Z8BKiBJvwvfDt18lOSQnkF+wnutRVp363SUns9OzsMbyJykvP
	X01ee8RdKD7Pk5gVffnrWauKaaI/0OMCvpS3Oap6hY2UxUvd5FS8jsnkos89J9JQ
	WXXUWf9MgUFhV2DAWNLVwA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4921peb9qj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 03:04:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58A00VCk032833;
	Wed, 10 Sep 2025 03:04:17 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bdbdy9c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 03:04:17 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 58A34GIe017468;
	Wed, 10 Sep 2025 03:04:16 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 490bdbdy8u-1;
	Wed, 10 Sep 2025 03:04:16 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: mani@kernel.org, quic_cang@quicinc.com, quic_asutoshd@quicinc.com,
        peter.wang@mediatek.com, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, James.Bottomley@HansenPartnership.com,
        linux-scsi@vger.kernel.org, Alok Tiwari <alok.a.tiwari@oracle.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: ufs: mcq: Fix memory allocation checks for SQE and CQE
Date: Tue,  9 Sep 2025 23:04:11 -0400
Message-ID: <175747321924.2920136.5249615498551213507.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250907194025.3611607-1-alok.a.tiwari@oracle.com>
References: <20250907194025.3611607-1-alok.a.tiwari@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-09_03,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 bulkscore=0 mlxlogscore=445 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509100024
X-Proofpoint-GUID: VHwcmSR7r3pXsGX8MzuAvAJBO_orBD_j
X-Proofpoint-ORIG-GUID: VHwcmSR7r3pXsGX8MzuAvAJBO_orBD_j
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1MiBTYWx0ZWRfX1QndRRPDt5uM
 8WZQVaJwQof755rKMfysoYvCEY6xE9otGTlhdFtF4c+5UBFRyCX3Fk9kIsOy0QMDzVJPqpiuCeI
 N7zz79HYSWSBsfsCeEOfsqkISy5cqW/8bnLgKyH2JwjskaosYoQ/GI6Jbz1QxVVqz44o+VR5x4b
 T8OgNdDEI7Le9lwsucLqJZvLsnTWIt3XJulvRuOOOD+NBODOy9pQ0nRkSTt4J7pdXXQdmUgSUUi
 vB1sZNTtnQwEDp/ZZG/Uia6czVucaYn7esYdY32HM0Wlmqe02/WgEVQmuqMmN+zKcy20hC1GnBH
 POFwHLFVh40fcNu4pUAjf2qlQgmIkzA2D/+bLHkb5zqT8sPSX/AuO6kmBpgWs+zCebZyhwa8Rak
 uNuxis4K
X-Authority-Analysis: v=2.4 cv=b9Oy4sGx c=1 sm=1 tr=0 ts=68c0eab1 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=LbRfUqgqCajye2J0cYIA:9
 a=QEXdDO2ut3YA:10

On Sun, 07 Sep 2025 12:40:16 -0700, Alok Tiwari wrote:

> Previous checks incorrectly tested the DMA addresses (dma_handle)
> for NULL. Since dma_alloc_coherent() returns the CPU (virtual)
> address, the NULL check should be performed on the *_base_addr
> pointer to correctly detect allocation failures.
> 
> Update the checks to validate sqe_base_addr and cqe_base_addr
> instead of sqe_dma_addr and cqe_dma_addr.
> 
> [...]

Applied to 6.17/scsi-fixes, thanks!

[1/1] scsi: ufs: mcq: Fix memory allocation checks for SQE and CQE
      https://git.kernel.org/mkp/scsi/c/5cb782ff3c62

-- 
Martin K. Petersen
