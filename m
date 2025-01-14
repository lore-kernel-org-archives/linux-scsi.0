Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0D31CEAC9
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jan 2025 16:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736872848; cv=none; b=JEhzmQHDeGPG3xXQJnoQ3XygFSkkN4fN0i52tqaupAPODFrhT6nXhMbaum4StA/3/WYTC5XsQFqZTkLqhvBc5qfNqx3vK3Hla/GObcy5QPeZ6aYjBgvrTlQQPWwJHsvQ1jstZPr++XVFeNT70TNzA79bGsptncyoVyP9b8vP2Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736872848; c=relaxed/simple;
	bh=CHizOH8xd2uKAuO/JuzCO0XcZXGfc21oahpYXC/YOGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A2l+0a8xEB2VTIrNPkD9uWmiFFDXcVtxHq5pMZuDR7eAIi2sd6Ex/kCQe84z7MPWMUm9bVOXscPp/RxSlaYtSQkitx1xKaHG04KzblPOdhCnvlbCgKRFuscVooZm1Xu8Nj387ey4yhf/GsBylM/XBscK7Cuc10jOyM3en+Vo5rQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=laykaakw; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="laykaakw"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50EC0oK9014294;
	Tue, 14 Jan 2025 16:40:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=jAO8evmgY/N1f9+XTABMRax2aZRXvu3rHeF4sfOZIHY=; b=
	laykaakwNBT2Kd7N4fIut1xs36YWgbPTWgndjWeGAweWgE4cSlF5e48y4uC8XTyY
	v1HoihVcAUcBzxX21riJVtwmLxTS9t/DKbcq5cYgkm2N9bRSnbRMF+CHkwcwO3Jr
	8GmMNKGq1NjcpZi84ULxWail+ucy8e9EIfj5SAUFNmgV4bwY3+ahAHgriH57Oi97
	jsY9EdyTEcEqwmrtBErmNKLcxC6/QrikSZct4srdmL7uu4tYnGHbhJdlwm45qluU
	DxwY7hEWPixccDeEzshlDt00VOgrEeffRfXwIVgWJxpinbhCeIeeMVbUhTJV3ZcY
	fSCS/QgI8841pynWaWtM4Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 443gh8wy34-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Jan 2025 16:40:44 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50EG78kf036392;
	Tue, 14 Jan 2025 16:40:43 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 443f38vb5y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Jan 2025 16:40:43 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 50EGegeg005685;
	Tue, 14 Jan 2025 16:40:43 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 443f38vb57-2;
	Tue, 14 Jan 2025 16:40:42 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James.Bottomley@HansenPartnership.com,
        John Garry <john.g.garry@oracle.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: scsi_debug: Constify sdebug_driver_template
Date: Tue, 14 Jan 2025 11:40:11 -0500
Message-ID: <173687227215.1044893.4094468761954938282.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20250107153325.1689432-1-john.g.garry@oracle.com>
References: <20250107153325.1689432-1-john.g.garry@oracle.com>
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
 definitions=2025-01-14_05,2025-01-13_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxlogscore=974 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501140129
X-Proofpoint-GUID: KUO4OpV0_gOdIpdp3n0BYNlO8Ctc24H2
X-Proofpoint-ORIG-GUID: KUO4OpV0_gOdIpdp3n0BYNlO8Ctc24H2

On Tue, 07 Jan 2025 15:33:25 +0000, John Garry wrote:

> It's better to have sdebug_driver_template as const, so update the probe
> path to set the shost members directly after allocation and make that
> change.
> 
> 

Applied to 6.14/scsi-queue, thanks!

[1/1] scsi: scsi_debug: Constify sdebug_driver_template
      https://git.kernel.org/mkp/scsi/c/37d061e1ace1

-- 
Martin K. Petersen	Oracle Linux Engineering
