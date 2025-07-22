Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60C5145323
	for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2025 03:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753156070; cv=none; b=aH+b2QY/NwVwfZs5xQihEi3v+WhHu4+FTlmBSygy5Ss1CqK3mVMREttDuQZxPJA2tKaBPJFBi0TeXh/A21f+VFlkOMQmRFVc5e7Iz9r0aNiAmjmRxfKRSvaBBmoa4YJEYGckbHO9O8NiqhzgO3PqgEmD2vlsII3wWFTQ6MlXNMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753156070; c=relaxed/simple;
	bh=kXHzS8s3u8gSO7kNPimk2aAhF0S5pYKgZt3D1E5qNgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CLPynry1oCYVNmdOzej5GVw6EBxCbs8mqhkp7zKsgJyBjSW3zzT0cmyKEhkQrNAwPnjKOzmeF/5nHllBGACsCqzCw23as2wxxPdjz2CUxbSq8iQyVwOJvFauvcWXMPfJ0mWO+2bIWW1Y2/AkVdP3e1FFNaQTsqm18wpLG4xCUBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jUEWFPFL; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jUEWFPFL"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56M1CvLA024986;
	Tue, 22 Jul 2025 03:47:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=5FsFNHQDWnGH9HJwiCxhUxWiyD4qLlPV1cQ6DuHDNr8=; b=
	jUEWFPFLplYL3pEJZ1XYMoe0MvnYw7WOxoQ+cxlhd5FhLTiVPRy7MSj5qVarrZfc
	sGpApWjyZa+2BiKBiy77O9guh9H1eqKodznjUIRO7fgAlOk2p5yeGK4nLEfwJpeL
	IKxfVF3qZ0Kcb4+I+vjpdndAt8e26xq7cF4HkUwXFSs70eHDOcrfFTZKGICareVP
	xcF9c/4djrTUoaw+uuXiwAe91ch4zXY/NNaO0MyUILjT4+CaVl5XwTlIFSYaKoH5
	sLZh2y8rQPHGUt+mq8OI2srwwqFdQvrAaQlPT5Pc+s8/udwyAfwQwbOYoGP72ish
	D9Lxlbgt93IFxB7mmJrd9A==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4805e2c6re-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 03:47:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56M1RQVS038445;
	Tue, 22 Jul 2025 03:47:37 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801t8te9r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 03:47:37 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 56M3lZj5031915;
	Tue, 22 Jul 2025 03:47:36 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4801t8te8u-4;
	Tue, 22 Jul 2025 03:47:36 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Avri Altman <avri.altman@sandisk.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: Re: [PATCH] scsi: ufs: core: Improve return value documentation
Date: Mon, 21 Jul 2025 23:46:57 -0400
Message-ID: <175315388509.3946361.9865852407962374771.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250623215909.4169007-1-bvanassche@acm.org>
References: <20250623215909.4169007-1-bvanassche@acm.org>
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
 definitions=2025-07-21_05,2025-07-21_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=706
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507220028
X-Authority-Analysis: v=2.4 cv=WaYMa1hX c=1 sm=1 tr=0 ts=687f09da b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=VwQbUJbxAAAA:8 a=h4hMIWmyErcOlFBlmwAA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12062
X-Proofpoint-GUID: 95m7Xc45GClFtTKLaLKDc9j82hZzVEV2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIyMDAyOCBTYWx0ZWRfX2tArGkgOtP0v
 yGcXeguRh/Sck52eZOgT8dqOdnBvKM2SAHl4b/zQpciWjZObfiGpZkoCs3Vsc1nTxJ+vRkWSPYV
 zbYYdaiMr0IKU5X5WtO+LVzfs0JdvOsoR5I2CJTZCV3RN6mNIhc7q3+iIYzXiYAThteQdT/TwYS
 0oWwgFJUnUfhVM5CyrMcpybKFX008G7V5E9yF2biY7I1f8CyCHX0cb7o0HRFQ2tGJR2dxDhMI8r
 IoenT7dQtWfSYj9M5C3zwALYZm+9GXlgtDAxZXpBhAwRU8RLWScgUK5dX9XErZ9YwolkaTAlx8N
 H+0Fjv4p974QsuV4Vk3hhXxAq/4Hgpxlfq72CEs8I1IvlB35qWrl3/70N02rUpoIRF54o4bdwym
 9I2elLHJyEyJSWtUACA3GklLyuP3g+Z2yE6Vie/VYwWujk8Pak/z4XtrAKZK3KK4OC5KZjyC
X-Proofpoint-ORIG-GUID: 95m7Xc45GClFtTKLaLKDc9j82hZzVEV2

On Mon, 23 Jun 2025 14:59:01 -0700, Bart Van Assche wrote:

> Some functions return a negative value to indicate an error while other
> functions return a value != 0 to indicate an error. Document the return
> value behavior where this documentation is missing and fix the return
> value documentation where necessary. Add warnings to detect mismatches
> between documentation and implementation. This matters because several
> sysfs callback functions only work correctly if a negative value is
> returned upon error.
> 
> [...]

Applied to 6.17/scsi-queue, thanks!

[1/1] scsi: ufs: core: Improve return value documentation
      https://git.kernel.org/mkp/scsi/c/cc59f3b68542

-- 
Martin K. Petersen	Oracle Linux Engineering
