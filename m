Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F3731BCAE;
	Sat, 23 May 2026 03:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779506134; cv=none; b=F4324RaI5sLvI3KUmy9HaHg7uCQFQWbv7/u2F0IduWA5bNNhVuwGSPbTDPuzkx/GYVktYUY7pPK5388NNTQvrYXIsTnWMseKJxsX/Jn6FlgGQJHCTQVos1FQxkubFaPucctT5EPWPEq749akRqemTOLk8sRCs9IerucJ4iumPak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779506134; c=relaxed/simple;
	bh=24zXDaAOI9sTFYFMwqPvRlsMA/+q/fmDpPYA0/dD/ng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OfpnGJDx0DBBo/EQydBVK0LqFD1CgEsR8gynMnOanL6osCYXD6KN0Bg877wjMZrUAmD46RuvHGV4s5TpV84OzG9Q1iviZtmzwaJ4D9G2MbBM2QzM2ZSdDvAW5efmR2D97761HJDDmN0zwqWfMaw4Kyy3VCa/KunrG7VVRzoItr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LwwsNsY+; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LwwsNsY+"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64N1uqGq2628687;
	Sat, 23 May 2026 03:15:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=3KEvD00FqsJFSyBIfDIR8FwU6eVGvjwN713kz2PPUvY=; b=
	LwwsNsY+kJkxxg5eg8SGbJyf9EthYXtf1fsOTvLp46xW7B0k3w3E7R8FqnEl61dX
	fxFDElZ508B1HT7eOF62DqWY+2CeRkm0HI7Hc7zj1KaYqPwE0Pp+GWkFxQzoYv1r
	PthLduyC9G9/frrYbI1gwmxUUfYx4YIUQpv6DL0IPFzElT08cSyXOb/ltNNHITWL
	8pNHp6a/1EILwkoDsNxdB0KXVwVacnE8idaDfNsczWMERGNVp6mAcZlTNUpsj4th
	uRtdy01MlROrAHTNHy1BRZ2HpadsxPINAO6ZuDVdHbo8XZfKM1uEM9ZbQsmMI7Tk
	bcDl7dPkNfP8uMfvwaIoXA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4eb314r63f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 03:15:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64N3F6IF032418;
	Sat, 23 May 2026 03:15:22 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4eb2p6hshn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 03:15:22 +0000 (GMT)
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 64N3F9eG032824;
	Sat, 23 May 2026 03:15:22 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4eb2p6hs6k-12;
	Sat, 23 May 2026 03:15:22 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Sagar Biradar <sagar.biradar@microchip.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>, stable@vger.kernel.org,
        Brian King <brking@linux.vnet.ibm.com>,
        Don Brace <don.brace@microchip.com>, Raja VS <raja.vs@microchip.com>,
        Kumar Meiyappan <kumar.meiyappan@microchip.com>,
        Abhinav Kuchibhotla <abhinav.kuchibhotla@microchip.com>,
        Uday kumar Bagam <udaykumar.bagam@microchip.com>,
        Advait Churi <advait.churi@microchip.com>
Subject: Re: [PATCH] scsi: pm8001: reject non-fatal dump when controller is crashed
Date: Fri, 22 May 2026 23:14:26 -0400
Message-ID: <177913641792.1181900.12981405499868476293.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260416154650.415624-1-sagar.biradar@microchip.com>
References: <20260416154650.415624-1-sagar.biradar@microchip.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-23_01,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0 lowpriorityscore=0
 mlxlogscore=843 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2605230029
X-Proofpoint-ORIG-GUID: -PRaksQQtD4bK7C9A-9Qd9uJ17QkKlbv
X-Authority-Analysis: v=2.4 cv=V9BNF+ni c=1 sm=1 tr=0 ts=6a111bcb cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8
 a=MV4thHkwdZb-0T0WulAA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIzMDAyOSBTYWx0ZWRfX5VB9J+NkmlNg
 Ql54a1q+VMmn4Jje8uy+n9GTU5/HY7OoY83hNqbCaAR30UtK1BonRfuKt578/DiZrG6oJtfdYvv
 AkX6J3mA5qSjlaKeRaNK/pnqSGSBw0e7ArLRmYfAb9N0Kl90mFZp2vtb9IeO2cqTaK4C+DbLczp
 JJoyqE2GsfNetmgrOTfNthbdwtYXynjOJ/YqxBZME253fWQXJD3V1H1nklKa1F8XgxBotBn1k2a
 zVzdi9wL5JCVCCLCgl+B3paR/bFjrUEVu5g40qsMVvypfTLqiFApkqT2sediWlm7yH70mql/r8r
 iAJdykli3EFNpCiWTZF7gy/MDi4IxZzpF+GR644RDO7UImtw7SJo1gOXmWojwSuDAky23nJ3QoY
 MuA/PDkPm5CZYOPT3Eb3LtxUbGwko30wC60+aXr/YVeTXgy8nlEPCpHf3jvIEYHKlSHB4DH2tgB
 CHe8XQHXVLpYNeNDJoA==
X-Proofpoint-GUID: -PRaksQQtD4bK7C9A-9Qd9uJ17QkKlbv

On Thu, 16 Apr 2026 15:46:50 +0000, Sagar Biradar wrote:

> pm80xx_get_non_fatal_dump() can be called even after the controller
> has entered a fatal error state. In that case the forensic memory
> contents are not safe to access for a non-fatal dump request,
> and attempting to do so can trigger a call trace.
> 
> Check controller_fatal_error before reading the non-fatal dump buffer
> and return -EINVAL when the controller is already in a crashed state.
> 
> [...]

Applied to 7.2/scsi-queue, thanks!

[1/1] scsi: pm8001: reject non-fatal dump when controller is crashed
      https://git.kernel.org/mkp/scsi/c/aa3b8f56ef27

-- 
Martin K. Petersen
