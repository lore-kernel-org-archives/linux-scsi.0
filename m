Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458E82F52
	for <linux-scsi@vger.kernel.org>; Fri,  5 Jul 2024 03:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720151811; cv=none; b=HdqAHLFkpOzA+MeidsR9MKxkMUFSoocLpNCfmhwewkRrk59ABeKe24b4FcWsJQXAvvBaQg0QthmZ+GJI6wRDOOL/ZmktW9qip35XLBJfL5M7JfdKLeJrzc0YvYCnqGVIxIL0C1NkdMktuL+tnCrJnEbzYbVJm5G0wb4udUJTw6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720151811; c=relaxed/simple;
	bh=CWEGlTd6UL2iqM8AdfBWtO5PW/Ene8RXcioeYmxF4IY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UcwPAhyKdcLDvpe7G5sLwlGAkzHH4nLu5wXN4be4ls9L6AGZCGjWKO6egobxKpC60RRpjZVkZELYhfxTJikOGN1IZzHplVG87cKdTPejHABZ3GLOvU60/edo43qOQxLLTk/QZpdoWSRwXpZGzzAKUq2ympPcjYxtcCWCgnTcWII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WC4qxfY2; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WC4qxfY2"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 464NHPuP010202;
	Fri, 5 Jul 2024 03:56:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=fUkrBQmRDOAxIe2yUgO4lwZfbGY34jJ7VWOeUTA54mQ=; b=
	WC4qxfY2Cee6pkjlZyzRAX2Ljv9q7/s0zIlpfXrG3BWU0OCrpybbuN7NCtqVX2q4
	4kVAW81Nih0e09vhzO7/ELMeA9v5aFMAvoLDLH6R0sw58/XGJvQuVEK9Zod48PwQ
	ftCbbOToc3ciJz+364FFFjPNen2hzWhJqvwme+BaFsZCb4OIYefgr8ElGALKL1k+
	CH3v6haMhYo0PbjOvRBfhUHLE/+ZTj988y70KzQRdrZXyHhQINTqGtALiXsNx5tJ
	vKYgVQtCTxaZKHZjp6490D5KN2PU++ikejnG+xeIFzkJvIHznne7s03CMNHNoN3T
	vmDzfXPRDTG9qiQ4sSzWdQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4029vstxrg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Jul 2024 03:56:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4650564x021700;
	Fri, 5 Jul 2024 03:56:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4028qh0kr8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Jul 2024 03:56:36 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4653uZPS027535;
	Fri, 5 Jul 2024 03:56:35 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4028qh0kqx-1;
	Fri, 05 Jul 2024 03:56:35 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, avri.altman@wdc.com, alim.akhtar@samsung.com,
        jejb@linux.ibm.com, peter.wang@mediatek.com
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com, tun-yu.yu@mediatek.com,
        eddie.huang@mediatek.com, naomi.chu@mediatek.com,
        chu.stanley@gmail.com
Subject: Re: [PATCH v3 0/2] ufs: core: fix ufshcd_abort_all racing issue
Date: Thu,  4 Jul 2024 23:56:01 -0400
Message-ID: <172015149442.1643711.2561274429120142425.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240628070030.30929-1-peter.wang@mediatek.com>
References: <20240628070030.30929-1-peter.wang@mediatek.com>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2407050027
X-Proofpoint-GUID: vaoepKtEW_cWsHiA58dNHEx3LaZ-ZDIm
X-Proofpoint-ORIG-GUID: vaoepKtEW_cWsHiA58dNHEx3LaZ-ZDIm

On Fri, 28 Jun 2024 15:00:28 +0800, peter.wang@mediatek.com wrote:

> This series fixes race condition KE in ufshcd_err_handler, which call
> ufshcd_abort_all abort an already completed request by ISR in MCQ mode.
> 
> V3:
>  - Modify ufshcd_mcq_req_to_hwq to distinguish cmd is completed or not
>  - Split two patches and add more race description.
> 
> [...]

Applied to 6.10/scsi-fixes, thanks!

[1/2] ufs: core: fix ufshcd_clear_cmd racing issue
      https://git.kernel.org/mkp/scsi/c/9307a998cb98
[2/2] ufs: core: fix ufshcd_abort_one racing issue
      https://git.kernel.org/mkp/scsi/c/74736103fb41

-- 
Martin K. Petersen	Oracle Linux Engineering
