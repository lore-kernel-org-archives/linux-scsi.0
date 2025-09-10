Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E38DD145A05;
	Wed, 10 Sep 2025 03:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757473492; cv=none; b=tSs9qcoLevKVVavBZWTZ7L77FOQNs+fxDMQSpwxPJoBrN4bcpwqa5OPncUY9VHDGJtDP3t8jmUuT/Ba1bI7hLG1eXQyC9UMyx1WaATIXwL+Bt3D8wuWsMtvOZ/aZ5qhVygCmx2NAWCGwKtut4dChScGLYauxCoyk/sRBAPOD/d4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757473492; c=relaxed/simple;
	bh=6K8Iq6I1ns2rcDQFJfkcrrEgLULqBE2VeDfx4/bT6HE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZfeRA5BJ+XSNQ4lduVVpOnbhUyg7KUK3XVMr14E1g9ROo+IM3l7j9LwmY6rz1tYLlNVOOgQPuIS3N5l/BnuvqMvtmVnWsWgWSQhm6ngn0kVasYxVAKK1y9grSoyP1cEGB1pkJkxczwG3d8p11AIDR1YosYtTOr+EiNbMB6dOyFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=aNQJzJCn; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aNQJzJCn"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 589L0fJ6032519;
	Wed, 10 Sep 2025 03:04:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=unRM/JZH3+rgvM+Lf93/eZQQxksqquorIu8EUawEmzQ=; b=
	aNQJzJCnx9Yo0yNBGLRdY6h9UzndEwhDLMtwSUM+/lWt95L0HS1I16yNe2ecCZY1
	VBjSy9zcgHFW/jwqJhlMF5MNlZ5wTBY2X1QlbHs1BOw7CBr3iS7jQQJNqD0BWmKS
	+VR+hkwY9ZkwkTjCsIy5YC1LzQtg8zMOvnx4srJq6p8FUMYkYpn0WcBFASaRABGa
	jLItCoa83HevI/OZrGyqE7fzYUuG6OIcpJLm04mqR0QHt4G4ZxXBJrPrQ1MOZEqQ
	xItVqEvxWE5811xuhMJ6DGz5/AYNsVjyVEUbgxH3DN1CYf+Aj+WGMYeZxhBnRT0+
	wkFq2S+Nk9/sy84ipNICfA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4921m2u83m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 03:04:43 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58A05BvR030899;
	Wed, 10 Sep 2025 03:04:42 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bdadcv2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 03:04:42 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 58A34g5U011326;
	Wed, 10 Sep 2025 03:04:42 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 490bdadcur-1;
	Wed, 10 Sep 2025 03:04:42 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: bvanassche@acm.org, Abinash Singh <abinashsinghlalotra@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        James.Bottomley@HansenPartnership.com, dlemoal@kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v10 0/3] scsi: sd: Cleanups and warning fixes in sd_revalidate_disk()
Date: Tue,  9 Sep 2025 23:04:33 -0400
Message-ID: <175746865968.2804493.9846138740555856553.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250825183940.13211-1-abinashsinghlalotra@gmail.com>
References: <20250825183940.13211-1-abinashsinghlalotra@gmail.com>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=596 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509100024
X-Proofpoint-GUID: xvyX8CBSzsy7gygALEOd0KCwTC77n0VX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1MSBTYWx0ZWRfXwseCzD/SPrA7
 W/bC41Ss0JIKcS0Wj60RuS1gfcE1dal/EvbIyGoc+RYZ0Ht6t/fYSHFNKBl+bBWjwGBweuAoxXN
 Zo2FcEXz72C+6uaRd/Q135lWpw4MeYlYZI91Pnd3A48wWxEIDbJ7gRjjgTJTbarH0w0wytcCOEF
 edQCvXs31jFbf4K65slP2NF8BWPvgZoJKPeco1cwpoEElUUsMtTWZCdFNUA2UuHGHzvt2T9HfYF
 AqB1xYZ3W0VNrgMKc9PikQffBdKprgNDHEb/72GVcywyYuT7s+MjUR4UwzxATm0uBqTfPxCAIMh
 S952nyD6ILoLuw8ttIETwBUCNMWfXL6bPlowjwBloK4UKzkmjZMWucWlviqAKZLy2a8ONKPpF35
 /BkF0UIi
X-Authority-Analysis: v=2.4 cv=Dp5W+H/+ c=1 sm=1 tr=0 ts=68c0eacb cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=YuMkFcEIVgUaU34oYOQA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: xvyX8CBSzsy7gygALEOd0KCwTC77n0VX

On Tue, 26 Aug 2025 00:09:37 +0530, Abinash Singh wrote:

> This v10 series addresses a build warning and does minor cleanups in
> sd_revalidate_disk().
> 
> Changes since v9:
>   - Moved the build warning fix to patch 1/3 so that it can be
>     easily backported.
>   - Added "Fixes:" and "Cc: stable" tags to patch 1/3 as suggested
>     by Damien.
>   - Moved the redundant printk removal to patch 2/3, since it is
>     not a backport candidate and also removed "fixes:" tag from it as
>     it is not a bug.
>   - Incorporated Reviewed-by tags from  Damien.
>   - Updated changelogs accordingly.
> 
> [...]

Applied to 6.18/scsi-queue, thanks!

[1/3] scsi: sd: Fix build warning in sd_revalidate_disk()
      https://git.kernel.org/mkp/scsi/c/b5f717b31b5e
[2/3] scsi: sd: Remove redundant printk after kmalloc failure
      https://git.kernel.org/mkp/scsi/c/d842da6924a9
[3/3] scsi: sd: make sd_revalidate_disk() return void
      https://git.kernel.org/mkp/scsi/c/11e6fb38bde5

-- 
Martin K. Petersen
