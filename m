Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CBD22301
	for <linux-scsi@vger.kernel.org>; Sat, 24 Jan 2026 03:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769226629; cv=none; b=BIseeTfVaZeZZ1SeZdzoY3rsbTYABhBWbVxlFu+4zn5mW+IPLd6dAyhHVcv8dVwKBPyvXP3tFCj40XFiDeIM4mbAQPiAZjz+xKIjETMjVf6qfWbhktGFbYjNLsDusPegrQbfayPfTsj5nb3uv7hiH3uCA7XtVvu96OotBbba4ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769226629; c=relaxed/simple;
	bh=q4A0LQo4na0kWXxgEb3v63pc1PCD5JJSbnSHEzV9LsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fwKxOwJy4yd4JjEXYeY34bUuTWAmHuacPHwzxLh146isBLTnCFFSFKE/Ssfj6PC8PxMNLGRVCphRGcgEwLVIUrv1u39AgR3/B4HghR0LLC2yGfsC+Gls9WG8IoqCsBn7dxIborqObPfrqzrde1bXhsaXBu96SoMd04P/aP1rRxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QnMeL6kQ; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QnMeL6kQ"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60O3CGOR360413;
	Sat, 24 Jan 2026 03:50:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=M2we4nYv+FTCyJCyCNouvHXbZZTxazUpidoZnTTOQFs=; b=
	QnMeL6kQH2cL7XjiRa0vQMghvWvwKaGht62KLG/dkU67HVf2FhSGuWC2g2u5P3G3
	Qjzq4Iy3OsRpJc0qoIZDE73xSyGOENWNjza6SnIoRI7B04p+MdQdufxo/3xFXpsZ
	4AIJTvU/9UQz0IwukU/rULkdI+TxYM6dDAlQZDgW95GGoGwXSYA2DQLMcJnUD3Tq
	E9zU9Y6wq/vzyaGU87r2bkwGcTjFrgqF6rvwfhgVqN7l7TkXdeaAZcdaGLwHH3x+
	maclpfvOd0Fhp/19VEdKdXq1iQLjJO53aFqLUVWgJVCnlwOyH0REjyWZReqTScda
	zOAjQnXBt2MWth3yQ0NfbA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bvmv2r1j5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 24 Jan 2026 03:50:24 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60O1Y9Mb019814;
	Sat, 24 Jan 2026 03:50:23 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhbah62-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 24 Jan 2026 03:50:23 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 60O3oNSl037773;
	Sat, 24 Jan 2026 03:50:23 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4bvmhbah5x-1;
	Sat, 24 Jan 2026 03:50:23 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v6 0/5] Clean up the SCSI disk driver source code
Date: Fri, 23 Jan 2026 22:50:17 -0500
Message-ID: <176922262109.2870193.8650882197626219321.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260114175054.4118163-1-bvanassche@acm.org>
References: <20260114175054.4118163-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-24_01,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=552 mlxscore=0 spamscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601240027
X-Proofpoint-ORIG-GUID: _GKdbl9oVJ2Sdn4dox1skP1CwGf0kvL3
X-Proofpoint-GUID: _GKdbl9oVJ2Sdn4dox1skP1CwGf0kvL3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI0MDAyNyBTYWx0ZWRfX7+2kdofblpAF
 KSk3RV8AzS4gTw1SH8jKtr+hiobs053eDN0BzDxTZ7K+7SY1olt8iG5A13qI938ea0ZL12o0V6/
 XTHT1Ija0rH62yiSI543KWKyIajLdOmUA4/W5oeuKs9raIpKZUJbyvplBHZlqwjg/6S0M4ZTxnC
 zsCaSWV/2iwGY2e09Xn6NpJA2TrjnSM6lF5Ky22s4HA/Zdrl8jXJLeuQR3kbP9VOXPficmKudHK
 v7B6HE0HSrPYA/4yvX0oj/iqZfQKxJxv46U+NEtmoeRKv7W38SI9TSdP4CBLXMuKCpm1jyQWDs9
 mnJkci/nWWMSkRaDb3pD/kmfR+kligFFY3CyeKfi/NP/tWhYGK+3YUdvVJhybmNhk+iT4MBqIK1
 Tfh2ezAw7JDZkSSM9rPTn23s1gsqbXIRtlKt8JS0/bh4RsGS9MPdDV2h8aIBhhHML01qTIv5I4G
 FT/cI6nyBm7neVQTakjEqNZEpcRa2aao7sQ9Guo8=
X-Authority-Analysis: v=2.4 cv=cPLtc1eN c=1 sm=1 tr=0 ts=69744180 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=itwFWDFbHfIS_0ioev8A:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12103

On Wed, 14 Jan 2026 09:50:48 -0800, Bart Van Assche wrote:

> This patch series removes multiple forward declarations from the SCSI disk (sd)
> driver and also makes error messages easier to find with grep. Please consider
> this patch series for the next merge window.
> 
> Thanks,
> 
> Bart.
> 
> [...]

Applied to 6.20/scsi-queue, thanks!

[1/5] scsi: sd: Move the sd_remove() function definition
      https://git.kernel.org/mkp/scsi/c/4f39a4870a59
[2/5] scsi: sd: Move the sd_config_discard() function definition
      https://git.kernel.org/mkp/scsi/c/c0daf4836114
[3/5] scsi: sd: Move the scsi_disk_release() function definition
      https://git.kernel.org/mkp/scsi/c/3899cff5056f
[4/5] scsi: sd: Move the sd_fops definition
      https://git.kernel.org/mkp/scsi/c/6e07e5333cc3
[5/5] scsi: sd: Do not split error messages
      https://git.kernel.org/mkp/scsi/c/cb429866a825

-- 
Martin K. Petersen
