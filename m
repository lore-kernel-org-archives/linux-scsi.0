Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19AE2153ED
	for <linux-scsi@vger.kernel.org>; Tue, 30 Sep 2025 02:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759199833; cv=none; b=fxQE7Z3lpU8oQH5xW1hsJSIgrs8CPFdwnWER9QoZbhjEVP8kmFQLytaTyH9j0QaKI0tC/VHpFrgJX2+Q4XvibJ0OfnpQa2fA7XW99V51O0b3PRmoNPeUN7EQw3S8bh/qZ/6xQEw8mgwqDrEuxfQgiMhHTKvoGVhUUDa7HnZrkhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759199833; c=relaxed/simple;
	bh=GizOUB557AVyB9SXBLJ8x9giy2nwYipO9FZEjcAaoHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E7P73KkfrDyD/snGl/vF2+WAHDN8M35mxeyX+vs4NTs4F8xSs6ksLWLU6Vmx1LrTUfq4bAzF4OXNiTBbofSexI9ge0uK/SjUhVNkn6mCQ/SaQmkdAz6iqXYOmcWYCuZPHo+F7cxgf8YPlAAAXXhXbVWABhS/KMapcMiBkNDH3sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dWh/+DtA; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dWh/+DtA"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58U2Eaba014046;
	Tue, 30 Sep 2025 02:37:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Wiq9kzqHz5aBFkDGEyS+SRErdbtu3YgLkHyWzXIwBl4=; b=
	dWh/+DtAmOuJd+VpgvZem4pr4C4Wl941M/ljRpqJeijEKGt+tPeDoyVx9zk4IvMA
	Rkkx7Wa4dVSUhwSpX+zIYEXjbnVUVVsN8DDkPDsrJJwsd3SQyOaiVPIylvtyzkfv
	+U+7QOb9kLM3KXiVRzszyscCPm+b7+GQKPPHazen8Cwzc6Thtr5ksQNsWnXfFKEC
	uy4w+oOhg3vLgFiTVQZAGqiT4LWhkt5qe8bMUJ2G7C1MKHSZ2P4qUMswCahk8BFJ
	70Ce5MDTODtiYpSsXZ8nywNlkOmsjgjPrQn3jCNNSfLlrrU4UamL8QA37aHSEZpE
	87nbedMP+EzQk/9Nkkesgw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49g68cg1wc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Sep 2025 02:37:03 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58U2GuN5008078;
	Tue, 30 Sep 2025 02:37:03 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49e6c86ewu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Sep 2025 02:37:02 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 58U2awVF004400;
	Tue, 30 Sep 2025 02:37:02 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 49e6c86eur-4;
	Tue, 30 Sep 2025 02:37:02 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        sathya.prakash@broadcom.com, chandrakanth.patil@broadcom.com,
        prayas.patel@broadcom.com
Subject: Re: [PATCH v1 0/4] mpt3sas: Few Enhancements and minor fixes
Date: Mon, 29 Sep 2025 22:36:50 -0400
Message-ID: <175917739982.3755404.2348613575131996958.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922095113.281484-1-ranjan.kumar@broadcom.com>
References: <20250922095113.281484-1-ranjan.kumar@broadcom.com>
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
 definitions=2025-09-29_08,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 bulkscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2509150000 definitions=main-2509300021
X-Proofpoint-ORIG-GUID: UhR6Qiy7j0DE-ZxYaCrgHwRGBNk2TGhI
X-Proofpoint-GUID: UhR6Qiy7j0DE-ZxYaCrgHwRGBNk2TGhI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTMwMDAxOCBTYWx0ZWRfXzjUO/Jwmh4Ro
 D5dvWwXlkaAxKvbzwvczYtcxH/rsw7vLiPInTm4I/09MqrgubkoHXP2CdAXUBIHPoHGfXatZnB9
 +qEL97kJlZW5dDZ0PCM7h93q4UOkYq9gmVDGJTvOn4Lo83/QK1iAIZfoCWGwHBCxBmGRT24RuDn
 339A+vbEeIEE212CBT3XV2Fvv3xo4rfn9zPTZZE0FK2fxNKlxA8L2q4pg0dCWCqJGOd2fNPPnNH
 bE9yfMyuI7fFXs2OJD2tycgzDIJqxJaaTo8iZphnca238SdygPeQhl9rYXhMiywhBhLZwwwez+Y
 wiDodQ+uDl5nOXwq6dJcnveNnDGRX5CAzx7ZKALBUUvbRt/33R16nxEBOoc/No0dfKnzQHwpcxz
 GLMfqPsuqVn1wufAYY0NSe/ZANbTWg==
X-Authority-Analysis: v=2.4 cv=cpKWUl4i c=1 sm=1 tr=0 ts=68db424f b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=D5KAVH_pgczCNwkdMJkA:9
 a=QEXdDO2ut3YA:10

On Mon, 22 Sep 2025 15:21:09 +0530, Ranjan Kumar wrote:

> Few Enhancements and minor fixes of mpt3sas driver.
> 
> Ranjan Kumar (4):
>   mpt3sas: Fix crash in transport port remove by using ioc_info()
>   mpt3sas: suppress unnecessary IOCLogInfo on CONFIG_INVALID_PAGE
>   mpt3sas: Add support for 22.5 Gbps SAS link rate
>   mpt3sas: update driver version to 54.100.00.00
> 
> [...]

Applied to 6.18/scsi-queue, thanks!

[1/4] mpt3sas: Fix crash in transport port remove by using ioc_info()
      https://git.kernel.org/mkp/scsi/c/1703fe4f8ae5
[2/4] mpt3sas: suppress unnecessary IOCLogInfo on CONFIG_INVALID_PAGE
      https://git.kernel.org/mkp/scsi/c/27f0b41de105
[3/4] mpt3sas: Add support for 22.5 Gbps SAS link rate
      https://git.kernel.org/mkp/scsi/c/4be7599d6b27
[4/4] mpt3sas: update driver version to 54.100.00.00
      https://git.kernel.org/mkp/scsi/c/7e5a43897aa3

-- 
Martin K. Petersen
