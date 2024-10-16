Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7471A21E3DE;
	Wed, 16 Oct 2024 02:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729046390; cv=none; b=LehGeEKQDE5s0yoZZ3BNWbJdlGszWNGsnlTqMJhc7R70Adjb9lwOZE3iBo9wR6VlsCVRYdn0Q37CSnoW7WEJjOmMBtnrLuE8af+t+cy1LFZ1D2A622icfZnXvYDaT99c6XZFV5OQCm6Xg/VzaXINYSgJ8AyDY9gUrSO71bb8N5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729046390; c=relaxed/simple;
	bh=Q1/8i8Bor3esTVmoc+8xASKKV+Qy3oSJlE+tSiQBVJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XpVgdSLZGXkn6Jm7Frsikb8mxXPZVd7xC9JMhchLnpzobml5si4i3bgGH5h7/P2HZVdket77XRzzB7Kc6b9LjwSq0hikgARZzG3vDQHzv7QE1wvFoVHg4UsgYFcvGG7L0BKv8lziBRh84sKG4BcPYcP3pck2x/ggOsDh84gzu/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=coBWQjUw; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="coBWQjUw"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49G2MimU010615;
	Wed, 16 Oct 2024 02:39:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=b6wYgvn1UFB/K0BQlY8XtiQWNcWvDDvAAQWITEbvMPc=; b=
	coBWQjUw4hSWBBHj2t/8Q4pj0XNS7lkSE0XzZF7IzivkLtv+7KC6eBwX1DA8ZvVf
	SvyoGyluzPaXSdeQhDx+oy4CFW/4IHrPZ1qHjpjhmC7lBiZKXoqffvl8GwIoD9P0
	aMdblpWYEDdIVyQalYST9jNgL95rVdbGM4qyc7adv2Ikg/KGy02Gpk3Y8U+5dh2P
	yZswSFXLaDmNbWG7PMuACaySSmbP5QyVsIfxF9B686y59MzFA1Pb+zKTmtJPmDyo
	FZiYA5AlX5xpBf1HA2MK3RJH/LKr1TZbbxZC47DTdMpPdm9wx3Bpzm2fzi7VTEcF
	uwd/60SbP97xtllLvmElBA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427fhcj8rf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 02:39:41 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49G15ERl036678;
	Wed, 16 Oct 2024 02:39:41 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 427fjem1v0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 02:39:40 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 49G2bkUh023540;
	Wed, 16 Oct 2024 02:39:40 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 427fjem1uj-3;
	Wed, 16 Oct 2024 02:39:40 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        James.Bottomley@HansenPartnership.com, bvanassche@acm.org,
        avri.altman@wdc.com, alim.akhtar@samsung.com,
        Seunghwan Baek <sh8267.baek@samsung.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, grant.jung@samsung.com,
        jt77.jang@samsung.com, junwoo80.lee@samsung.com,
        dh0421.hwang@samsung.com, jangsub.yi@samsung.com,
        sh043.lee@samsung.com, cw9316.lee@samsung.com, wkon.kim@samsung.com
Subject: Re: [PATCH v1 0/1] Set SDEV_OFFLINE when ufs shutdown.
Date: Tue, 15 Oct 2024 22:39:01 -0400
Message-ID: <172904632506.1112721.11988166953037342244.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.1
In-Reply-To: <20240829093913.6282-1-sh8267.baek@samsung.com>
References: <CGME20240829093920epcas1p1cf45ac0cd7d4ed8cf39ff5f1d1b4fe00@epcas1p1.samsung.com> <20240829093913.6282-1-sh8267.baek@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_21,2024-10-15_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 bulkscore=0
 spamscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410160016
X-Proofpoint-GUID: BJHTkLSO8ydLgWmsSWlKVhN6NbiN_ggK
X-Proofpoint-ORIG-GUID: BJHTkLSO8ydLgWmsSWlKVhN6NbiN_ggK

On Thu, 29 Aug 2024 18:39:12 +0900, Seunghwan Baek wrote:

> When ufs shutdown, set SDEV_OFFLINE instead of SDEV_QUIESCE for all lus
> except device wlun.
> 
> Seunghwan Baek (1):
>   ufs: core: set SDEV_OFFLINE when ufs shutdown.
> 
> drivers/ufs/core/ufshcd.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> [...]

Applied to 6.12/scsi-fixes, thanks!

[1/1] ufs: core: set SDEV_OFFLINE when ufs shutdown.
      https://git.kernel.org/mkp/scsi/c/19a198b67767

-- 
Martin K. Petersen	Oracle Linux Engineering
