Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2729516D330;
	Mon,  5 Aug 2024 21:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722892713; cv=none; b=a25qSsp8ZqxKraI0BLDwFfQkhBaBi8it2B08CByVA6hxUTO/cRG2+lGag0TvnZm1A/AEZKpP2f+X/Dr7X0pNV+RA8Pj5nGgT0PlofF/ws5H0Y/RWvukwiGKH85Z9m0FhxWl1jZO5M+uKMqMDxCFH6UGKFEj5iL1CPUNLA3LrAVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722892713; c=relaxed/simple;
	bh=0X61mTXD+KUaSCixrcqOblNBf2K/7/iiTDNr6lM8/A8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LIMAxsRy1//Ixd9yzyNLAsYJlWRxSI/ww1a9T+hjoRH60vPxfkuQxyrAqlxw74BLmzviTnTy0T0vU1B4G43OhzZjpdwlx1HkHLHle+VEfa5e3C/tk143Zca9ltSv+dmPZnEgGhDcV8DGLX49WtV5r6nZ8k8SZpxVBrqUXVnEpXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GWe/VvaV; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GWe/VvaV"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 475KjUW9005372;
	Mon, 5 Aug 2024 21:18:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=LDmAJg7to+8Cwezn8AirJBPukU1zaOuXvSewEUx3Yqk=; b=
	GWe/VvaVJjOyFmxZSiuzl5iQ72pcK/hbUbrmRBN2Ii7BOGQOxImsk+UqwutsB4pV
	AmQCamcA7pmPrCQ+JIYFpedgMz73P8Eo0PJgvbfBVkeCLhU0mAe2CrTQGWa4jAco
	zLk+q9vYip6kBvDcWZj5FW47Qx4aUAcPMaIsd/o5jGeGlzInB1eViRCFLXghSlqz
	Wf1GJyGfkOdREc6a76SR5bT6fnlBjRXh+CyVuovbCq6FmiffO/cQHSSjtBnUJZ85
	CIqaxw2m+LSR5jDr7hC4oUTp0G1yQPdktmI8obubm2BbEvTKvQLjPWqz9mMUj4qn
	mxz/exB14j3s5pWJ9HXTwA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40sbb2krq0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Aug 2024 21:18:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 475JpbeB035058;
	Mon, 5 Aug 2024 21:18:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40sb07ydht-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Aug 2024 21:18:25 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 475LINEN035403;
	Mon, 5 Aug 2024 21:18:25 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 40sb07ydcw-3;
	Mon, 05 Aug 2024 21:18:25 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        Kees Cook <kees@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 0/2] scsi: aacraid: struct sgmap: Replace 1-element arrays with flexible arrays
Date: Mon,  5 Aug 2024 17:17:27 -0400
Message-ID: <172289240513.2008326.10809568054475318270.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240711212732.work.162-kees@kernel.org>
References: <20240711212732.work.162-kees@kernel.org>
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
 definitions=2024-08-05_09,2024-08-02_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxlogscore=700 mlxscore=0 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408050151
X-Proofpoint-GUID: ie4JBda4ys12U6ZgEWdckrnDYwLPNZ6H
X-Proofpoint-ORIG-GUID: ie4JBda4ys12U6ZgEWdckrnDYwLPNZ6H

On Thu, 11 Jul 2024 14:57:36 -0700, Kees Cook wrote:

> This replaces some of the last remaining uses in the kernel of 1-element
> "fake" flexible arrays with modern C99 flexible arrays. Some refactoring
> is done to ease this, and binary differences are identified. For the
> on stack size changes in patch 2, the "yes, that is the source of the binary
> differences" debugging patch can be found here[1].
> 
> Thanks!
> 
> [...]

Applied to 6.12/scsi-queue, thanks!

[1/2] scsi: aacraid: Rearrange order of struct aac_srb_unit
      https://git.kernel.org/mkp/scsi/c/6e5860b0ad49
[2/2] scsi: aacraid: struct {user,}sgmap{,64,raw}: Replace 1-element arrays with flexible arrays
      https://git.kernel.org/mkp/scsi/c/fdb1db6ea7f6

-- 
Martin K. Petersen	Oracle Linux Engineering
