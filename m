Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECCD36FC3;
	Sun, 31 Aug 2025 02:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756606291; cv=none; b=qg66nl5uNCbcyFi3AVfNhvhnkcNp+0sOY54lRnkLMRUDdhan7NA/oM6sFvcu+Dh07/SC9QTw9EvugU4ymQN51+4Fq8W8E/zluRQqPJX2NeYALp0IHBIW0TkWAHC4knlV3zCMW60AiIK+oAjTouE8G0NeYjLK5d1NhYHof4I38RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756606291; c=relaxed/simple;
	bh=Dt13hPD+e1XgNgcdXllXluslhdFCCmG21aeCtHpglvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tnh0F9xKm2ya/yRoUn99n53DCaP8zfH2YKa3AagYsjTiMZaQk6Easw9nvauyVGVwtKZ1EmBnb2F7XZw6ncRhfo1VeuX74GWYqNaNEgNp/1SJjuUxt7uPjTO4V1ogrzcJmU31hT8s4auKrtRneTpqGc8Po7VsQLUtEBLFYX1p/Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=b5Ly5U22; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="b5Ly5U22"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57V1DljL017781;
	Sun, 31 Aug 2025 02:11:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=gg1wsU5v7g/WLpzWVbSAWFZsUiZjFyNz+27KU14UwbM=; b=
	b5Ly5U22VmAdnQhx7/lGccVvxRezDZohfogWKddlnavAouPMIyq32TeP6XAzW3gU
	fdOK4J3piFw8wZA71Y1mc9gBctDKPjyRSefI/mFbi9dhEz5oxBlOe09qm67d+A84
	MZj46TPFGSx+EvxRjW1iK8HvBxkslnOrBOEtUyZjESFavxOSQQhx66i6KFEMA4LY
	RTLdMXKDKjbq6oQxnJ8Xe1g5c/QTgNuUXC/VPlrtOLKrm9Pj7H/8qxu76lvZhiI9
	+TG73iA9A4PSMZGJ3QuTLKTUEREG7+QreW1kvqBhtbzzr4BC63Kkep1Zs7wZxzMz
	lLrEV7MXtIQPon5BeVJ25A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48usmn8mhd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 31 Aug 2025 02:11:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57UMa28S026795;
	Sun, 31 Aug 2025 02:11:21 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48v01kaah5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 31 Aug 2025 02:11:21 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 57V2BKgr033747;
	Sun, 31 Aug 2025 02:11:21 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 48v01kaagp-2;
	Sun, 31 Aug 2025 02:11:21 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Ming Lei <ming.lei@redhat.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi: sr: Set rotational feature flag back
Date: Sat, 30 Aug 2025 22:11:14 -0400
Message-ID: <175660626142.2289384.15154739568387943295.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250827113550.2614535-1-ming.lei@redhat.com>
References: <20250827113550.2614535-1-ming.lei@redhat.com>
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
 definitions=2025-08-31_01,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxlogscore=685 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508310022
X-Proofpoint-GUID: t7K3huUueDU887vfCURIsggtXiZ4-TAI
X-Proofpoint-ORIG-GUID: t7K3huUueDU887vfCURIsggtXiZ4-TAI
X-Authority-Analysis: v=2.4 cv=Of2YDgTY c=1 sm=1 tr=0 ts=68b3af4a cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=pLdJOJpxjfIZuJD9IVcA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzMiBTYWx0ZWRfX2C1GjYUBoNxa
 nP+sF5HNLYl4nmYQvDQ7lI917GuY+FWWWO5gmF+UxlKTpC7TvUDvbIFgpxUzAqr+ZTQ/TbtjFc4
 ybI61JgOogT9hDrDuwq2jNc/OSxyyA+Xb2ntFU0J8lKNQtsw9hmT+R9g3gcCegkx05z0HMNLOL3
 Ku9cGvX5KL6PTG4ck/NCFh+kAVgsEnazxrLKPAJNVakFpgVI9W/y67bKjmikq/S+xAmF9XA4bhr
 CbYRWUD8UngmRKI08LMhh1axGKYUUU7/cJzqhItnf+mSzCxOh32hegXrRBI/rDzxTiKyzPBUASb
 O3Ma/Hl9QqseIISBg1Q+KSpNGIr7Edc3cHuhYdTGR7jzAxJ/WcwMrs59WqZ6Wx0oIIzLGskD+z+
 JSZjR2Pm

On Wed, 27 Aug 2025 19:35:50 +0800, Ming Lei wrote:

> Set rotational feature flag back for cd-rom which is really rotational disk,
> and the flag is `cleared` since commit bd4a633b6f7c ("block: move the nonrot
> flag to queue_limits"). And this way breaks some applications.
> 
> Move queue limits configuration from get_sectorsize() to
> sr_revalidate_disk(), so that it is more readable to set rotational
> feature flag and sector size limit in sr_revalidate_disk().
> 
> [...]

Applied to 6.17/scsi-fixes, thanks!

[1/1] scsi: sr: Set rotational feature flag back
      https://git.kernel.org/mkp/scsi/c/708e2371f77a

-- 
Martin K. Petersen
