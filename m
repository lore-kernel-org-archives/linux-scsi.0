Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1CE72874F5
	for <linux-scsi@vger.kernel.org>; Thu, 20 Nov 2025 04:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763612201; cv=none; b=kgAloyMZTNLlwnjsiplZz9G+DDOIeCqqPF/+4dJnFm6Hy9SJsq9h7NlXs1HU2dPV3EIhTuZLOzcpn4/6kMb3LFFugIwNfuIP/5vGr8+uM2/z9GG7ssdCvABCOZVKZoSxxvl6uyKr9P2dEHnqlALPM9Qk4mjWcyPkpd249C6h+Ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763612201; c=relaxed/simple;
	bh=270QrrLKlrOiXN00EHC7pGo4xMW3IDJa4lAeedVpYWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S6Ov6484u5UWzuQTQlseIMveW031tO+EuD0W598Ps6NNJddAOSBFzKqFHPQHx+thnwKJ6kUH9x18bSdw2vVmylyaPTqTItYHN2mNuhfCHrp9GaE9KVWhhajuMicp1u1WyOR6YG32RRciNk3CQEN0yyX/YHoBFtNbcUU4ShNb3kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=E8uzZN/4; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E8uzZN/4"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK1Nbwk013047;
	Thu, 20 Nov 2025 04:16:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Vy+SGU10HmPVIhX55rNZyB6n6/aZpOfRHWrd4R9VcVk=; b=
	E8uzZN/4CM6h4Vf8AzMhgN3gWaLHubAnCPOrd7crwYAF5iDxxNFrXQZUpxbBmQ1H
	CZg5+gW1ci6c8UHfb+04HsDMuIJAMlqgv1/cTqVlIcDaaS4g5AawuEVVDHSQAaSX
	Hdbpkpc6yhHf/adcPTyFODciVr+QRxB2TsJEU5FZSNE3jsE12ry5ZnfchzhAYyRs
	pzKTF8qUO6mraLEjNP1+jBIv67p3yZzfoXnWkmijbqCfsn6YXScgjMECB9guJ7Ds
	ZWneXj8Kt1Fz58ybR3ZVRtL/Mo3p2D4CyZROLcxc+YtunF2woloIoSjJnjHwGkEN
	GVI9lVPZ3epvlnu6ExIaMA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejbq0c7k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 04:16:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK306Sd007160;
	Thu, 20 Nov 2025 04:16:37 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefybh4dw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 04:16:36 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5AK4GKPt012546;
	Thu, 20 Nov 2025 04:16:36 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4aefybh471-15;
	Thu, 20 Nov 2025 04:16:36 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH RESEND v2] scsi: pm: Drop unneeded call to pm_runtime_mark_last_busy()
Date: Wed, 19 Nov 2025 23:16:04 -0500
Message-ID: <176357169025.3229299.5694613086076752832.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111-scsi-pm-improv-v2-1-626b8491f4b4@analog.com>
References: <20251111-scsi-pm-improv-v2-1-626b8491f4b4@analog.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-20_01,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 malwarescore=0 adultscore=0 mlxlogscore=763 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511200020
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfXx0QUA+2PS7CE
 zE2XcEtl87vl+hasIquefydsZl1xN8d2cOeh1nTBDNi53k7ryKj6xAkjfLcf2kz74WCot184pg+
 cyA/hBnWnxqfe6yKqoH9gRFuP6iOVjeMAEc/CqntLUcrbw8/SdgSax+qW3f2noaW0tV8Qy1cj7t
 LNoi0PKzM/KaRMCEkYkN+nWQiUESHIOzmOGjcnjiBprCtK+eiGxAlI+HHnTnORpm6xh6KkADN3B
 qBOyGUHLBm2MlY6EoU4gd36VzrbDDp0tqae/bn9tEMDmWdUsxB0NCWyKNCN5AbU0d7UUBGj7c32
 MBqQo8iJno2abk5h++ftcPYQkiXbupz0nUySGHvp+TTV0KpZUlDNLyNGTRPCegp0cqzA8ZcBmRP
 Xar/yuBW9hze1Blhd4THhyvNYfD8HA==
X-Proofpoint-ORIG-GUID: mE9zsp1x2RNI_RqoAbsFUAtjCz8i-bCk
X-Proofpoint-GUID: mE9zsp1x2RNI_RqoAbsFUAtjCz8i-bCk
X-Authority-Analysis: v=2.4 cv=a+o9NESF c=1 sm=1 tr=0 ts=691e9625 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=M04PtJBfOdjdU-LseVYA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10

On Tue, 11 Nov 2025 17:50:17 +0000, Nuno Sá wrote:

> There's no need to explicitly call pm_runtime_mark_last_busy() since
> pm_runtime_autosuspend() is now doing it since commit 08071e64cb64
> ("PM: runtime: Mark last busy stamp in pm_runtime_autosuspend()")
> 
> 

Applied to 6.19/scsi-queue, thanks!

[1/1] scsi: pm: Drop unneeded call to pm_runtime_mark_last_busy()
      https://git.kernel.org/mkp/scsi/c/1028258914f6

-- 
Martin K. Petersen
