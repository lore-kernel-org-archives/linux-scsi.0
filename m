Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49937156F3C;
	Tue,  4 Feb 2025 03:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738640169; cv=none; b=W5iLSvX3PqfQTrUHXo8TFf7siplFLekdnOBQ2v/MsJBtoAY1kntWUfJfxwncomuxEB4Hsu3/ui5ZPicGNX/J2H2SC+Nunl2Cn9hm2ow2YS1GOMVDn/YCmBXJ6QH/pqjBjn/8Ka6cyDO0hmagGNvX3AHRyoA9jQgdP2a9ymbL7PM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738640169; c=relaxed/simple;
	bh=Bcu7k0ftf/3hVCFw+FUvkSxFJ5438FIN3AnY1bXbPSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RzPz9gnJ70HGJ9Tpm1+rLpb8kUtlWu7dtgjMxnQ1sOvIm4PBt3M6evzB7ZDteK2o3e2/irOGFUso99XeRXa7DMGFsntI4SoZAjSlgkZrVc+Q5K7w8tJhMfdxtAtHoGJcQXeaQgDKnpxig04Dvv+ssqQufVtVah2w3gleuxcaEcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gCbcpdLb; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gCbcpdLb"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5141NjiZ002916;
	Tue, 4 Feb 2025 03:35:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=c+UwsxKs9uTq11asQUxnuOBitsERD4GWWt+qzTnd6p0=; b=
	gCbcpdLbkhRbqI4DuX6t3kILIcr37Ds9A2EXiYftf6//xdQN3TnQpuC5KyPKzuMd
	MPgiqTJM/Ly75ytnV+fC0YRnkkDy0D3chg7iPnAU9NBnA7Ti2hIR1qyc/hGL8lAA
	Eds959QoBtm9TGT3EqfadMX7wYYMasxhDrYktxVCH3QFjK8E/xP72IoZSHost/DC
	q4eCqdz/aUwRmptkSR034iwjli7JsBN/YS0d3RbpKvwVt+/AQyhLyq00Of9ri2XJ
	H72wN/ceg0JNzJ1rdm0eOAKsEy/6zVKtzyqaWO6HBM6zgDFe0qC34zxVOOQK7rAp
	hMqPNgPvJkhbSqrH+3pf/w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44hj7uuwsd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Feb 2025 03:35:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5141jSjA038947;
	Tue, 4 Feb 2025 03:35:33 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8e76g01-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Feb 2025 03:35:33 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5143VlxM009625;
	Tue, 4 Feb 2025 03:35:33 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 44j8e76fxf-4;
	Tue, 04 Feb 2025 03:35:33 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: quic_cang@quicinc.com, bvanassche@acm.org, avri.altman@wdc.com,
        peter.wang@mediatek.com, manivannan.sadhasivam@linaro.org,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, stable@vger.kernel.org,
        Bean Huo <beanhuo@micron.com>, Daejun Park <daejun7.park@samsung.com>,
        Guenter Roeck <linux@roeck-us.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] scsi: ufs: core: Fix the HIGH/LOW_TEMP Bit Definitions
Date: Mon,  3 Feb 2025 22:35:09 -0500
Message-ID: <173864009032.4118838.5080919620979879348.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <69992b3e3e3434a5c7643be5a64de48be892ca46.1736793068.git.quic_nguyenb@quicinc.com>
References: <69992b3e3e3434a5c7643be5a64de48be892ca46.1736793068.git.quic_nguyenb@quicinc.com>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=867
 phishscore=0 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502040026
X-Proofpoint-ORIG-GUID: -3B6jx8EuJUD6P5fIHNQYLeo1xIHlsmZ
X-Proofpoint-GUID: -3B6jx8EuJUD6P5fIHNQYLeo1xIHlsmZ

On Mon, 13 Jan 2025 10:32:07 -0800, Bao D. Nguyen wrote:

> According to the UFS Device Specification, the dExtendedUFSFeaturesSupport
> defines the support for TOO_HIGH_TEMPERATURE as bit[4] and the
> TOO_LOW_TEMPERATURE as bit[5]. Correct the code to match with
> the UFS device specification definition.
> 
> 

Applied to 6.14/scsi-fixes, thanks!

[1/1] scsi: ufs: core: Fix the HIGH/LOW_TEMP Bit Definitions
      https://git.kernel.org/mkp/scsi/c/1b3e2d4ec0c5

-- 
Martin K. Petersen	Oracle Linux Engineering
