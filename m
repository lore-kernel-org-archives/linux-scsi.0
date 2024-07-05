Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147D061FE8
	for <linux-scsi@vger.kernel.org>; Fri,  5 Jul 2024 03:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720151656; cv=none; b=vF+HxRPBJW590Pcixkq0OtyMUuuiQnb+8LkAQfR9sHhPWQoDdArB+e/bHRe48z/AyBdV0WqctInEdvZG/rlef+NmFOPsYFfNxhT2Vbnwup0ahMTMJ3CmeajefAGPz4754eUDmel+NXXzfa+vA0mO9Wtdb/sipQQ8/nKfcKLeSUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720151656; c=relaxed/simple;
	bh=32sM7087iS6rjg1GnC9T5D8N7jMILwtl7yL2kZ4Ub3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u42LUMiKkz7FtjCKoFhty5UfMpJ4bMuJLXRrGRG7HavMcWS3TN5paiObDO7g5BV0fyJDUhaMSt/97ht8v/CiyC6JpOCVWknaz7wCjTCYHLYUz6HMUEFQkAXQt0qAH3zeUDAKQjlg9DSDBsV/UqmRPtPwL8zdqWyhjd49WUS6+oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WKunTvkP; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WKunTvkP"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4651U1uB011421;
	Fri, 5 Jul 2024 03:54:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=O+Ash3Zo0H5Kaju2YaOEctBO5MPZKdAAam6vAexvoz8=; b=
	WKunTvkPTbPbmQ+NNYwiflGl+b9e3t8Z5rFrRw+M6j5ZPISPXnlt+QAaS6TRTfm+
	4cqNGSEtnswLSfzDZLkFPx5YF5YpFX0Mau/4hNTinoLQ34dJAnHfyZ07Ar7GAECB
	s2UTkRZIl/XGEwYKZ5NeDvcvAtSRtNPDMXRxka0RKwuQLQJ4Ozrr3DfrZFxy7MzI
	3X3iC2fglxXhOyHhrW6UpaKVfVG9AZpzShtE5AIKxP89rvII8AR6dbPmi3vPjdIu
	zcyyIqMDwrn0b7s8wgz5mkgQQL8DeIIMtjMT/dyS4k1wG50bQDPrLPFbsyl12qtB
	I7tnzBjnJWgvV/nUXmFGyg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 402923320b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Jul 2024 03:54:07 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46510Hdm010183;
	Fri, 5 Jul 2024 03:54:07 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4028qh9xyu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Jul 2024 03:54:06 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4653s6dI010018;
	Fri, 5 Jul 2024 03:54:06 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4028qh9xyf-1;
	Fri, 05 Jul 2024 03:54:06 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>, Bean Huo <beanhuo@micron.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: ufs-pci: Add support for Intel Panther Lake
Date: Thu,  4 Jul 2024 23:53:27 -0400
Message-ID: <172014707938.1511036.9632536987790059128.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618073158.38504-1-adrian.hunter@intel.com>
References: <20240618073158.38504-1-adrian.hunter@intel.com>
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
 definitions=2024-07-04_21,2024-07-03_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 adultscore=0 bulkscore=0 mlxlogscore=813 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2406180000 definitions=main-2407050027
X-Proofpoint-GUID: dgvZSoRLk3iRFMD3-iiyXp9Bwsj0sUIU
X-Proofpoint-ORIG-GUID: dgvZSoRLk3iRFMD3-iiyXp9Bwsj0sUIU

On Tue, 18 Jun 2024 10:31:58 +0300, Adrian Hunter wrote:

> Add PCI ID to support Intel Panther Lake, same as MTL.
> 
> 

Applied to 6.11/scsi-queue, thanks!

[1/1] scsi: ufs: ufs-pci: Add support for Intel Panther Lake
      https://git.kernel.org/mkp/scsi/c/bdee2f1dcd84

-- 
Martin K. Petersen	Oracle Linux Engineering
