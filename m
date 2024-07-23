Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2CCF433A0
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jul 2024 01:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721697858; cv=none; b=WMQ5APYOfUItv+ufyjbUx//vK+TRzjRYzXlO1Oh+LB8y2XPzWyxvQvHnTI3WazJemdV1JcoC+uBBTundfT5pd0dv6wY9ijtBqF56F4AjzmQk3bJOwFNByca1u3xPavflPrm4VS7JdlEgLKo/t2OPylXGdrcusyTAN1TPX0KPs5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721697858; c=relaxed/simple;
	bh=AfFeSeBAsCYh0iUdPzzhqaCbPItXT0+5LpD23En7UUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TUF1JjzjUh6EUhrtqofQ2Q9JDyBRA7nTg//nvoUX0rWlAPPryznWOsVjPzh0l7En0+e0xXJ9/l8/NvOUgJr/EzcWz0DhFAEDLeMDniqc0VPvbx5Fu93KMokmdJ01D5+w6k11ennvYueL9bn4wl0zCVBdCqvmDjgnkkBHxeEnWD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BIDLx7Ix; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BIDLx7Ix"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46MKtW8u018341;
	Tue, 23 Jul 2024 01:24:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=yt1UlTOn6IQTjb8jSrqQ3/NGKgujgJlWg/mq852LJhY=; b=
	BIDLx7Ix8IVXk2V08c9o8XbcWjvA3wGBjdKhgofrJdQRPQveMO6fYtohGd/4Kwcl
	lBJzXndDR3dgMeDianTg+uf+dLc20TEsNqbxl178oORFsfMnTjm8vyjEltR5GLhN
	J5ndlHcBKUzNzMjZTfWgRezOOs0c+/3zx/U2glHVbbU2oIop9LgsVE0Hmb5pv4OK
	LqUUuUvyzAoolssq7GhEVunNZJvmeHQTI/CCpW+XA7BtxIJY9mNswo2vSUPaF6mY
	b9NcLnj5rNePc1d3Yat1W93lw8DQ3hFzYte5tzb2QHIBI4lLO5dPQaemSxVzIyo2
	eebi3POzW6cyV57hwhhgUg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40hft0ccm0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jul 2024 01:24:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46N1EilM018838;
	Tue, 23 Jul 2024 01:24:06 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40h27xysq1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jul 2024 01:24:06 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 46N1O681005270;
	Tue, 23 Jul 2024 01:24:06 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 40h27xysph-1;
	Tue, 23 Jul 2024 01:24:06 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James.Bottomley@HansenPartnership.com,
        Kyoungrul Kim <k831.kim@samsung.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, bvanassche@acm.org,
        Ed.Tsai@mediatek.com, Minwoo Im <minwoo.im@samsung.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH V4] scsi: ufs: core: Check LSDBS cap when !mcq
Date: Mon, 22 Jul 2024 21:23:20 -0400
Message-ID: <172168235244.1161648.4461798222095474087.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709232520epcms2p8ebdb5c4fccc30a6221390566589bf122@epcms2p8>
References: <CGME20240709232520epcms2p8ebdb5c4fccc30a6221390566589bf122@epcms2p8> <20240709232520epcms2p8ebdb5c4fccc30a6221390566589bf122@epcms2p8>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-22_18,2024-07-22_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=705 adultscore=0 phishscore=0 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2407230008
X-Proofpoint-GUID: 4VbEHkdWvIl3YW0WJV9Pf43bIf3bylM_
X-Proofpoint-ORIG-GUID: 4VbEHkdWvIl3YW0WJV9Pf43bIf3bylM_

On Wed, 10 Jul 2024 08:25:20 +0900, Kyoungrul Kim wrote:

> if the user sets use_mcq_mode to 0, the host will try to activate the
> lsdb mode unconditionally even when the lsdbs of device hci cap is 1. so
> it makes timeout cmds and fail to device probing.
> 
> To prevent that problem. check the lsdbs cap when mcq is not supported
> case.
> 
> [...]

Applied to 6.11/scsi-queue, thanks!

[1/1] scsi: ufs: core: Check LSDBS cap when !mcq
      https://git.kernel.org/mkp/scsi/c/0c60eb0cc320

-- 
Martin K. Petersen	Oracle Linux Engineering
