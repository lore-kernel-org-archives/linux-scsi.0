Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B20221E3DE
	for <linux-scsi@vger.kernel.org>; Wed, 16 Oct 2024 02:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729046455; cv=none; b=BM4hbmu4l8lb87ztlw18rl6qMipwy71LlGvWqEGWoOfgQtOCiwfABLvdoy0VKQZlBNakr0oJu+GLFJksOgrf2ZbKO9u3ocrH6rkXEz5UNXsMpRNou4U7LOW58itNu1B+HvZDMm+kuue0trHSstPLsfopZg2kcU8NAaPcQc3wwhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729046455; c=relaxed/simple;
	bh=hO7FB+dDkQB0cnx6VNl0rS+b5uikJAKXD/QaY8KN5KA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cvZ4X2tQxYzfdx3/NDOasHEENxbqNe0eJrFx/lPlj8og4v8gUS2kQDowFDAR8IW9SqS4d6qOTzOHzLAHBrX2WcZLkr+pY6wiOqwKWzYrtVab3m2SUcn+onKJ1BZiizuPxh8Lw6Ep6ra2X1KXVX550JUUOq6N2R5EcwTGEGF70Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=aV3YVCck; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aV3YVCck"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49G2MaFP016575;
	Wed, 16 Oct 2024 02:40:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=tcEvuEM9onGz/V1106HeyzNpRoQpriuZgDonwy35bLM=; b=
	aV3YVCckwVQjJzUVDl75aQhzeq48pNd9+/8+J4766Mtjvy6jVol2KIOR6tuBhwyR
	y5xNDMoqzu8KMDX3sE04kbLCIhIFRlZrzqCyIgrEFUOTxQkvBwoV4oQNaZnB+wNI
	dWJ6KlYTbafEdpoDk4jLTzxnjU05BkPmEAHipyZdp699BWpeAaZkTzvHrokRXl8p
	Lla489fKRvK4o4m+gtJzMFAuj9tjAe1vsY8unZ9QxwMOUCpdHfBpwhjEBppZIO/z
	ARG/zet2M6ayIFCryMR4m+ZX47aPGxYIXFsxH9GPwpJT5fwqdogHGaKxvQQX92Pl
	G+FRGZ/Des0DXDTRPPF8vg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427h5ck0n3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 02:40:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49G0cfeN027269;
	Wed, 16 Oct 2024 02:40:48 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 427fjesxyj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 02:40:48 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 49G2elfx001510;
	Wed, 16 Oct 2024 02:40:47 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 427fjesxyf-1;
	Wed, 16 Oct 2024 02:40:47 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH] scsi: mptfusion: Remove #ifndef __GENKSYMS__ / #endif
Date: Tue, 15 Oct 2024 22:40:02 -0400
Message-ID: <172852338080.715793.8658348033771386342.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.1
In-Reply-To: <20240930201347.1837690-1-bvanassche@acm.org>
References: <20240930201347.1837690-1-bvanassche@acm.org>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=652 adultscore=0
 spamscore=0 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2410160016
X-Proofpoint-ORIG-GUID: DyIASVVezTQXFe_T-XTu9wVNNWWIbT0o
X-Proofpoint-GUID: DyIASVVezTQXFe_T-XTu9wVNNWWIbT0o

On Mon, 30 Sep 2024 13:13:47 -0700, Bart Van Assche wrote:

> Except for preventing build errors, there shouldn't be any conditionals in
> kernel drivers on __GENKSYMS__. Hence remove an #ifndef __GENKSYMS__ / #endif
> pair from the MPT Fusion driver.
> 
> 

Applied to 6.13/scsi-queue, thanks!

[1/1] scsi: mptfusion: Remove #ifndef __GENKSYMS__ / #endif
      https://git.kernel.org/mkp/scsi/c/09822c231ae6

-- 
Martin K. Petersen	Oracle Linux Engineering
