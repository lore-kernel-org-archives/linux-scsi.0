Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9BCB241691
	for <linux-scsi@vger.kernel.org>; Thu, 31 Jul 2025 04:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753937085; cv=none; b=K1NnUqY/Mhc/m6XrHKhJt7rXafoph6NCncI663dMlUTHhq3a/rQ8ZrsFVsYCVZdLocktWqDhi4F1N09Re7ULxfYYOTqZAsm9ihouGtPgHuin7X/EycdLJerSknlC1iCom5RFo1kTlW0VRNXHX4xHHMF1q1cCktAgg0CWQdO7tnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753937085; c=relaxed/simple;
	bh=BMJIPAvYfcUHPG+EXpeASPj8tyb2uOmt3IE00dWhOkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZlHQ1huEBAhNAkVKCImmbL91CrAb0TxX2xevkdrfDimyRYekdUKriEb3x2ArzYoS1HIynANvixlkXLbIMw/d5NyKJHOwI3HkdNMq0Dv53xmbugQvXUQvfCmvypqMgvdliGYU2U4ZkhWvZ82r04Vl2907jhC4fALUZDM2eqEEtiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jQRr717V; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jQRr717V"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56V2g1Rn029710;
	Thu, 31 Jul 2025 04:44:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=7/qjRu24vp9Jb7oaDTzsNWi/wxtGEzjbnILnGkh9oE4=; b=
	jQRr717V2A3CQfctXPeR75Cncte3AgH2Mt0VcuhoXsgVR3enZVxvgArZdzBTXTkR
	wl/ghgeldpJ2fTtLZqtuSfyTBjwx0n2ltz6QCMWrWcYESvvwkWcO2IZJQFmt0uGU
	DvvLsboo9qfG4wz2RsVpaZrzn9Tbk+6mNvyyUnMDgihjmIngt1c+rm8YGMCvhOM8
	r9cDyZB7YDebQyDZ2FVum7al9Idk30RiSz6k8tUSb1bEyhb7gFua7YNQX8Tm+WZo
	aYO1C5KU101+ykR6FdrFbIIQu8sQe+CWlu7OXZvJSAwo3CQ9QcZoqStxIiZcmqzj
	W7BR1fY08sZarh/vioG6Jw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 487y2p06ct-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Jul 2025 04:44:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56V4c3M0016800;
	Thu, 31 Jul 2025 04:44:34 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 484nfjb2tn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Jul 2025 04:44:34 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 56V4iX3t035411;
	Thu, 31 Jul 2025 04:44:33 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 484nfjb2tg-1;
	Thu, 31 Jul 2025 04:44:33 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        James EJ Bottomley <James.Bottomley@HansenPartnership.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@sandisk.com>,
        Archana Patni <archana.patni@intel.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH V2 0/8] scsi: ufs: ufs-pci: Fix hibernate state transition for Intel MTL-like host controllers
Date: Thu, 31 Jul 2025 00:44:19 -0400
Message-ID: <175375581148.455613.3233167362118052054.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250723165856.145750-1-adrian.hunter@intel.com>
References: <20250723165856.145750-1-adrian.hunter@intel.com>
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
 definitions=2025-07-31_01,2025-07-30_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507310030
X-Authority-Analysis: v=2.4 cv=COwqXQrD c=1 sm=1 tr=0 ts=688af4b3 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=VwQbUJbxAAAA:8 a=A5lkQ37IXSJDz04Gj2cA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12070
X-Proofpoint-ORIG-GUID: -zceX2PyidEzGGTSJ2PVz7hJrPZleOwJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzMxMDAyOSBTYWx0ZWRfX6+dLpIrfrFrg
 yXhA2RLJPTUOS5pWyUCbrh4Idqfx+/YKhqk3/Bxpq/+SHqy6ui6HEg9WT39kz/bTt8XYj7Zq+mN
 zxQ5STyV6E/yN+++yMj1W1lnM79Er/6J/uIngI456zyfs9eHnepLv/TaT6kgR07ne1ZGEg/7ZQE
 8TmCpvATiKy0DreM4bibmBkgIv6rnC9it2H8Vcxz1qU4Uppq23YkpHJogZxbCMbZMNezkJxhKoz
 T6tIZWjvKJoHAQQnlpSwANkpFBHXwanS0IHCOt7fz6pX3x22NAVHG9sxPT+TNpE4HG6kYxiSAFT
 7Q4S9csQDolHphttaLBvmiKiEiW/5zXYYF/QWHyYP4P2jz/8yo11jjRrA1RFXn05mlSMGiAt+mi
 8p7wRaCXQmQeiJL6Gv9KFr1DjAOtkv2GhVHJEfd7BuDp2xm73fpis3wNS1niuP4WFygR0lZ9
X-Proofpoint-GUID: -zceX2PyidEzGGTSJ2PVz7hJrPZleOwJ

On Wed, 23 Jul 2025 19:58:48 +0300, Adrian Hunter wrote:

> Here is V2 of a couple of fixes for Intel MTL-like UFS host controllers,
> related to link Hibernation state.
> 
> Following the fixes are some improvements for the enabling and disabling
> of UIC Completion interrupts.
> 
> 
> [...]

Applied to 6.17/scsi-queue, thanks!

[1/8] scsi: ufs: ufs-pci: Fix hibernate state transition for Intel MTL-like host controllers
      https://git.kernel.org/mkp/scsi/c/4428ddea832c
[2/8] scsi: ufs: ufs-pci: Fix default runtime and system PM levels
      https://git.kernel.org/mkp/scsi/c/6de7435e6b81
[3/8] scsi: ufs: ufs-pci: Remove UFS PCI driver's ->late_init() call back
      https://git.kernel.org/mkp/scsi/c/28a60bbbe739
[4/8] scsi: ufs: core: Move ufshcd_enable_intr() and ufshcd_disable_intr()
      https://git.kernel.org/mkp/scsi/c/497027eade8c
[5/8] scsi: ufs: core: Remove duplicated code in ufshcd_send_bsg_uic_cmd()
      https://git.kernel.org/mkp/scsi/c/c5977c4c0731
[6/8] scsi: ufs: core: Set and clear UIC Completion interrupt as needed
      https://git.kernel.org/mkp/scsi/c/b4c0cab4eb8d
[7/8] scsi: ufs: core: Do not write interrupt enable register unnecessarily
      https://git.kernel.org/mkp/scsi/c/d402b20f9c31
[8/8] scsi: ufs: ufs-pci: Remove control of UIC Completion interrupt for Intel MTL
      https://git.kernel.org/mkp/scsi/c/22b246e3fc5e

-- 
Martin K. Petersen	Oracle Linux Engineering
