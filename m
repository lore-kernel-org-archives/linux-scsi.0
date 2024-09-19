Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474971DFF8;
	Thu, 19 Sep 2024 15:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726761229; cv=none; b=bG0AXIFiRLPfCCSGyM/3C5KAUlZ0ofYPWM27uQ4WMBeJriibktMv7o2Ia3t3m+bpQGCgvQ7/6B8aVsHLdqO33UATlLEV6eqprOPsyhsHnbuujwiroWB8q+WnGyd9Z6OJYKnXMyDdr3lpTvQ++HR8CF+LBZ5qqjFpaOZLKX1BlDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726761229; c=relaxed/simple;
	bh=+GXy4rtW8HjEfO1GxqkZCmCZR5XIZsFMc8rJlH7bSMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sYUtMlDIBVIr8X4EbokI55CqPgC0dv5n5ZRDZ9vNjJoJFQ7zqZ3mH4jr4njtcErd6pwaWjY6ujh+QxSS7NlBvuWPpmXGmN1Cp1tG75rMSK+X2/6qLGZlCRCArooINBg6/4R5FuiVhFk0Mf1B/aZona89/S4d4Z5dwSk8DMaDQT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nNPXuguF; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nNPXuguF"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48JEb4Kv014325;
	Thu, 19 Sep 2024 15:53:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=YSGJ0py9Kb0wL2o0WyoTq47y0b2eEGcxm0N27Z1bH9k=; b=
	nNPXuguF6xjjXR/2LDPaUv3UlmmZhasOddcS1XrFEijidb2X26CzJYSrR1tWmpzb
	txPZta516876UVQlpzmaOR2XD4fKS5j/pi4J/zQ6Tl8j8XHbFex7+UlugNsYv2Lc
	+Ucs5X7lT4jr7ZPfu/5iEZUH4R+ltX7Z6j7D/MT0E3SsooiXu/+VCYHnTsl0sd8k
	GfcSHKx+Avd6Pw9/ga6EwtF6Uk+bKhoM6cLZDP71lSFgSyOhLcRiexckbCnu7vqn
	hU5ySPHJLod4MA7tcWo/R5tohB1m3Tag8LsSp/KqqEckvJJ9ARfxqR61tWkn7xo7
	xMQGhuuf3s97k+Ybl1M7Bg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41n3n3mhxu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Sep 2024 15:53:46 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48JFHG1i010473;
	Thu, 19 Sep 2024 15:53:45 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41nyb9xj8w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Sep 2024 15:53:45 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 48JFri8f031813;
	Thu, 19 Sep 2024 15:53:45 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 41nyb9xj7h-2;
	Thu, 19 Sep 2024 15:53:44 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: libcxgbi: Remove an unused field in struct cxgbi_device
Date: Thu, 19 Sep 2024 11:52:48 -0400
Message-ID: <172676112036.1503679.8936206482923788401.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <58f77f690d85e2c653447e3e3fc4f8d3c3ce8563.1725223504.git.christophe.jaillet@wanadoo.fr>
References: <58f77f690d85e2c653447e3e3fc4f8d3c3ce8563.1725223504.git.christophe.jaillet@wanadoo.fr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-19_12,2024-09-19_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=887 bulkscore=0
 adultscore=0 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409190105
X-Proofpoint-GUID: VCuLG5tLrnc6qv3XkndkJmd7iohqPzKi
X-Proofpoint-ORIG-GUID: VCuLG5tLrnc6qv3XkndkJmd7iohqPzKi

On Sun, 01 Sep 2024 22:45:27 +0200, Christophe JAILLET wrote:

> Usage of .dev_ddp_cleanup() in libcxgbi was removed by commit 5999299f1ce9
> ("cxgb3i,cxgb4i,libcxgbi: remove iSCSI DDP support") on 2016-07.
> 
> .csk_rx_pdu_ready() and debugfs_root have apparently never been used since
> introduction by commit 9ba682f01e2f ("[SCSI] libcxgbi: common library for
> cxgb3i and cxgb4i")
> 
> [...]

Applied to 6.12/scsi-queue, thanks!

[1/1] scsi: libcxgbi: Remove an unused field in struct cxgbi_device
      https://git.kernel.org/mkp/scsi/c/45fad027df61

-- 
Martin K. Petersen	Oracle Linux Engineering
