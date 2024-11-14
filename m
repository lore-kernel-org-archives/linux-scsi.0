Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3331F6665
	for <linux-scsi@vger.kernel.org>; Thu, 14 Nov 2024 02:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731552665; cv=none; b=YeIQ3SzMa0em6DQXZxknyoX+X3YQFCnZv5lbeikXchY/3BTKslxG1TbicU+QRToiJ7TnKZ2s9CyEFlZrEbJ0YnKPc6b7F6px59LzwiaLeFQumDMNxoZB8vuMNH4AQpXj9a62obMj1gE44+z90Tfj+U8ueDsktHibz6GFr98hjN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731552665; c=relaxed/simple;
	bh=XUFg7ODk86pLus/xZcYcgz+IOibqGj6/WZ9pm5SLKXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AZKsy8HbSeYGEK+O0GhpV3UTwLm6Ta9Ffw3MNbNCJI9JUE4mHaYs53DlERemzE8Xg1x4ZZZTD87qt8qoAWcKRnHi22nhmItrjlq+4muXI6o1OJ8+cZWirmwCpBvittRKuV5H+VF2vuzWbYPCihgTiwQIfFBgvhXfJZr87g4nBLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=E6BN6DNY; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E6BN6DNY"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AE1ftGn006704;
	Thu, 14 Nov 2024 02:50:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=0JORMG0C0968J5l9hERfDGtMBAaJVxbZDyuZioAhOZo=; b=
	E6BN6DNYlQthKcFPIERSu6bAa56gTy8T24flaKaIRQXSv/6nQyVq2k6xNmr/M0gm
	SGY//AerJSCq//ethi2B+Hk7WPnS4W73s8Ukj23pnAtx/9/n2xb2oETfMQo4VGoP
	d7RJCk43l3bnBVImkQp2T+Z6z+qVWS0jTdpciyT+xQTPj1pPUsFyKTcOzGzwXZXv
	gN56BZR0y2xOCjPIpf5WwtTJ5X/QDuc8ql6ZsnGPO0bQyqEytkUaAZG538iNXk0n
	FeVSPSiDyuyAoCKRsK79j6lk0rb90Tins5YZYDLi5i8HpywSDmlGdoAoKQmMfjOq
	Gz0uNdOcvLAa/iMmYKitBQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0nwr8gs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Nov 2024 02:50:47 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AE11Fj9022819;
	Thu, 14 Nov 2024 02:50:47 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42vuw0p1we-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Nov 2024 02:50:47 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4AE2ojYk003527;
	Thu, 14 Nov 2024 02:50:46 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 42vuw0p1vg-2;
	Thu, 14 Nov 2024 02:50:46 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Neil Armstrong <neil.armstrong@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: Re: [PATCH] scsi: ufs: core: Restore SM8650 support
Date: Wed, 13 Nov 2024 21:49:55 -0500
Message-ID: <173155154814.970810.2519647076478319790.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241106181011.4132974-1-bvanassche@acm.org>
References: <20241106181011.4132974-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-14_01,2024-11-13_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411140021
X-Proofpoint-GUID: EhYbJMsqn1hYvnUOUBto0Vk2ICfpGTNr
X-Proofpoint-ORIG-GUID: EhYbJMsqn1hYvnUOUBto0Vk2ICfpGTNr

On Wed, 06 Nov 2024 10:10:11 -0800, Bart Van Assche wrote:

> Some early UFSHCI 4.0 controllers support the UFSHCI 3.0 register set.
> The UFSHCD_QUIRK_BROKEN_LSDBS_CAP quirk must be set for these controllers.
> Commit b92e5937e352 ("scsi: ufs: core: Move code out of an if-statement")
> changed the behavior for these controllers from working fine into
> "ufshcd_add_scsi_host: failed to initialize (legacy doorbell mode not
> supported)". Fix this by setting the "broken LSDBS" quirk for the
> SM8650 development board.
> 
> [...]

Applied to 6.13/scsi-queue, thanks!

[1/1] scsi: ufs: core: Restore SM8650 support
      https://git.kernel.org/mkp/scsi/c/007cd6ba9aac

-- 
Martin K. Petersen	Oracle Linux Engineering
