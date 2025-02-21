Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA2B1D47AD;
	Fri, 21 Feb 2025 03:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740108489; cv=none; b=jjSCyzMk0cHYvB78U9ahx9mS7AFbg7RvvxMO+1r0eiUjbu8KM5mbr6dNe7Mxhi1WkhEJRGOCa46ropPnhqEQPYJ2ObukTb6ISLj7iBa1kAzTDxaF7rtwCUnjbc3shP0e6sh2KVmXX8MfpkA20Jt15iZh9c+1cEmCDe8IFqvEFmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740108489; c=relaxed/simple;
	bh=m0UZa4D/Y9XWr5/GmCyP0tstSxb7e2xG3bEZzwn1JHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qaq+QDEIA6j1CAHkl+2wH8NBJjaxvQ/AmYaoMAhHJ+DDgNybvFZ9ZTIqcATMembrIuU5Yp5UkvyaMfLfryQrFQK+litjvSCnaqiGm5JyXMLcCyPEQYlTOV7Rc4/+pxTa3ABASSEZ0C0xPHkyzNyXubJMptIXEqLm9c5OLUQwMLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DRiP/xus; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DRiP/xus"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51KLrZNQ028671;
	Fri, 21 Feb 2025 03:27:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=j1e2q47A8U8fcTZcdkdi/wUAfAuX6B4PNpGcn7q7hhA=; b=
	DRiP/xusSJ4IgWEQ2nHKL6qFzTqFLfIl9aV6KGtagHijWKNjmxmEA1LfdaWt1iGq
	nl9HbZFROU9yk0Mv6UO7K7Om1fJ5opD0ygnk0aGX/377QXdMYHhK+ZTafmUTgOSF
	YsPwDiG8pGZDjJ+CGd/lv9rtGUehkpyoLoH/x9HLXUMcrD4Xl0BEW2ZU6KrSGo/q
	LsUyC0aXI9hCL6hc8Cy8ZoIe3V2sPoWcDPBYMqDW4LLk2yUAf8+lcPZHip7AwMnf
	xqywiQItNicbL+F9+sBENjcXqJfgHUHcDdQ2jZfMIF9anjOs66kgF67xtoIS3hZY
	t0pReuE72VE2Frwo2FvAuA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44w00mwg2q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Feb 2025 03:27:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51L2UoNq025190;
	Fri, 21 Feb 2025 03:27:49 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44w08yu5nk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Feb 2025 03:27:48 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 51L3RmE2001656;
	Fri, 21 Feb 2025 03:27:48 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 44w08yu5n6-1;
	Fri, 21 Feb 2025 03:27:48 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Arthur Simchaev <arthur.simchaev@sandisk.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        avri.altman@sandisk.com, Avi.Shchislowski@sandisk.com,
        beanhuo@micron.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, bvanassche@acm.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] ufs: core: bsg: Fix memory crash in case arpmb command failed
Date: Thu, 20 Feb 2025 22:27:24 -0500
Message-ID: <174010841900.1417860.9136632960046999013.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250220142039.250992-1-arthur.simchaev@sandisk.com>
References: <20250220142039.250992-1-arthur.simchaev@sandisk.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-20_09,2025-02-20_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 bulkscore=0
 mlxscore=0 spamscore=0 mlxlogscore=971 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2502210022
X-Proofpoint-ORIG-GUID: fqCSwqdLLTknd736sl1XVqvQjqafh3C6
X-Proofpoint-GUID: fqCSwqdLLTknd736sl1XVqvQjqafh3C6

On Thu, 20 Feb 2025 16:20:39 +0200, Arthur Simchaev wrote:

> In case the device doesn't support arpmb, the kernel get memory crash
> due to copy user data in bsg_transport_sg_io_fn level. So in case
> ufs_bsg_exec_advanced_rpmb_req returned error, do not set the job's
> reply_len.
> 
> Memory crash backtrace:
> 3,1290,531166405,-;ufshcd 0000:00:12.5: ARPMB OP failed: error code -22
> 
> [...]

Applied to 6.14/scsi-fixes, thanks!

[1/1] ufs: core: bsg: Fix memory crash in case arpmb command failed
      https://git.kernel.org/mkp/scsi/c/f27a95845b01

-- 
Martin K. Petersen	Oracle Linux Engineering
