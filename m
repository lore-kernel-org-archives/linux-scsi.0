Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB04279917;
	Tue, 26 Aug 2025 02:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756175655; cv=none; b=LSR4ZhY0tsKh0Xiy6fUM5DJKP0UGvvCUHIkn9biFrQZ92S9RBkTov/2fsZb4DD884bFF2QZT8ApZjvMaS83b0SCT8Bc45FUXO8aXKIF5uQ/gL5JoqJZLaTOClNYLEPWfPYYGJYlaSYBHzBQpYWkWpXdol/6QAU+WOWMRTMlVSz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756175655; c=relaxed/simple;
	bh=ZmQBTu6Y+3F8KlhbQ5m8zoNfyUNzgsjfOM69+2QlTgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nAkN/1SffmSY6aeoeNZC9FrGEpJ5Be0wOrmBfrbFdwMUx8x8a15TRQToPmw13/yx7LOJdns/FIMaM6MNyOvmgCM9C1vgUk7HVnqbg8LiWpPEh1nvF1lF5ppGOZ7zx3Oi3C+zuIlnkVA2DwJrcG9yPVwiKekwEMrRlB9FFWimWTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oFNoAVa9; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oFNoAVa9"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57Q1JHw1011249;
	Tue, 26 Aug 2025 02:34:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=fs9sraVsB/GOaOHq07WcXCDczWxUc2qvWYVQM5H7lCQ=; b=
	oFNoAVa99aakP8Lj3BB5dRRTlsTbIx/LkiGItbBOgZsvvq2LsLrPl0qMQVGXdSOZ
	AiEkTP5h4TwNkbTtXgt+CG2j6LnM19tJqPu0wmL0tVa7uHrEpHBBdEnHk0qITTMV
	1sZ3JOTOUL6ibGoyQuCObpDXgiruBVhOm3FQVoBVNxARJ/9m+O4ktrco7H18qs+U
	m6DpPryJbLvODgvxXxQNX5z78K6ZgvHmgXwag6uWYQdcVlLS9vxGTBRR+UvaAaz3
	uWvCpnIziInE/0PXkLSHsGxO0sBLg9GqgK1fK6SD3BxpL2djnKNvhsVqp4mKD36g
	v+JumfDO5xuCFn9yj1KTEQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48r8twa8up-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Aug 2025 02:34:06 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57Q1iEsg012234;
	Tue, 26 Aug 2025 02:34:05 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48q438xc61-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Aug 2025 02:34:05 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 57Q2Y2s8010861;
	Tue, 26 Aug 2025 02:34:04 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48q438xc0n-5;
	Tue, 26 Aug 2025 02:34:04 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Don Brace <don.brace@microchip.com>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Chandrakanth patil <chandrakanth.patil@broadcom.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, storagedev@microchip.com,
        megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        Qianfeng Rong <rongqianfeng@vivo.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: (subset) [PATCH 0/6] scsi: use min()/min_t()/max() to improve code
Date: Mon, 25 Aug 2025 22:33:57 -0400
Message-ID: <175613417243.1984137.16546785455865806920.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250815121609.384914-1-rongqianfeng@vivo.com>
References: <20250815121609.384914-1-rongqianfeng@vivo.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-26_01,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508260021
X-Proofpoint-ORIG-GUID: etD27G9wyphBeWFaNr4DjNpfzKfwfxr7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODI0MDE4NCBTYWx0ZWRfXwNk9yF+P7ZZE
 I0b2QoaFT1N19/tDpxcznZaj1NsmrnP0/6vwA5vF88VvnNbj1NWwx0B89a/Tuer+ZFG/0cjNc+Z
 tNwfyY06uVg99OjQOSAPGVDYFJYqbuheKTm+VgtSKQ4ofvkBHsQlshyFE0Jm1Ndw8GjMHNVeveJ
 SoUp4vlr4i4rqg3iaMSXaxVlz5RkiorEcXCa8DlavFip5B3pINA1goPq7E1Y5JlkJ3q7V1YicVz
 xSmXO5GKZV3RPOiaDHp8AT7r25NsVyYkOZtRmR0kPWaj+WEW4dFn8A7Yh1hy1y6SGU378DK4Ouk
 Dq4CPYKGG8uyc/2becmU8ZAvjQ2G84OTcfo/Mz9r6e5g1xmeJ9beMP3l0s6fMr9G1mb3RKmrOua
 9F513EOHK9ep72ux6h0omMuH5nCoVw==
X-Proofpoint-GUID: etD27G9wyphBeWFaNr4DjNpfzKfwfxr7
X-Authority-Analysis: v=2.4 cv=IciHWXqa c=1 sm=1 tr=0 ts=68ad1d1e b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=IKSvcPwFDvSkbDVEwb8A:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12070

On Fri, 15 Aug 2025 20:16:02 +0800, Qianfeng Rong wrote:

> Use min()/min_t()/max() to reduce the code and improve readability.
> 
> No functional changes.
> 
> Qianfeng Rong (6):
>   scsi: bfa: use min_t() to improve code
>   scsi: hpsa: use min()/min_t() to improve code
>   scsi: lpfc: use min() to improve code
>   scsi: megaraid_sas: use max() to improve code
>   scsi: mpi3mr: use min() to improve codee
>   scsi: qla2xxx: use min() to improve code
> 
> [...]

Applied to 6.18/scsi-queue, thanks!

[2/6] scsi: hpsa: use min()/min_t() to improve code
      https://git.kernel.org/mkp/scsi/c/0138c16872bd
[3/6] scsi: lpfc: use min() to improve code
      https://git.kernel.org/mkp/scsi/c/e79aa10e288c

-- 
Martin K. Petersen
