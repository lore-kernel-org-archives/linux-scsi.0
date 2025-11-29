Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67964A23;
	Sat, 29 Nov 2025 03:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764387037; cv=none; b=bSAYeF/stDsOi42RFMmXmHqFyM0E2a0qpkTRzQVEdLVNxmpeqpzBJwOQhV+bGKDFYBhiZ3IYn6MbvrQxuAXQe0GcW48txjn7EX3D9rDybvQTymHj50odN5E//Np0YcZbQ+E+674IUb4HImFhrfDiwJ0RyBZc8+NyR3QtOvmQbkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764387037; c=relaxed/simple;
	bh=4DlvwCplMgwm0kuZ2rU73Qn7BFvMivUYSvU90ACrNL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pHoyd2TgrF0rWLpAX6cD1cB7rgcIE4qR/oGXxqviFHEZ+Wpia+cSsUSUrdPpQ/CrBIPJ+vHvi/9rIVyOZLLxuW04kUVYEksG70e45+VQtRNAH9JGfDwkVKvG2cVLEFbNRbIn06hZ7MOj3VjKlnIefaeDLcYqI6FToWBtROK4+A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dqtPXF6X; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dqtPXF6X"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AT3MV3c804549;
	Sat, 29 Nov 2025 03:30:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=cVH5p1F5RaTGWBSnZK2psExOjVQZUNECA2zV6BuVo9w=; b=
	dqtPXF6XPjay1OyEjlAFHLsn1e3DEf/enFOuLh7DjsF73DXZviWOCUD8OGvruE75
	DfRhCJ2Bo90kdeLgg4gWs8X2baTFjbXGpWKuCy6CRXXQvHcsj0LsuRfx7fxfjC/g
	1QZelTXTbV9krpTgu8wcxTq3XGrYGM6VJ6UufL+gFAluYk7u/Fq1zQTroYSaNVYO
	0ZHwmwJhgfDhMUf+RyO03SvysK1By+G9M/FdyRk8dYFTGxgp8Ope4/DJOCdyjDpg
	h1QizLGYl3vvnUwLjMbgleKjUgu5Pr5j0W1ZRRiRNwDi+Cm8TD1jrZnU/LH7bmG6
	QFxiiXVZJoYph//tforSYw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aqrvc003d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 29 Nov 2025 03:30:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AT1Xa7a031965;
	Sat, 29 Nov 2025 03:30:21 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aqq961nb5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 29 Nov 2025 03:30:20 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5AT3UEpP015090;
	Sat, 29 Nov 2025 03:30:20 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4aqq961n85-7;
	Sat, 29 Nov 2025 03:30:20 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: njavali@marvell.com, Zilin Guan <zilin@seu.edu.cn>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, jianhao.xu@seu.edu.cn
Subject: Re: [PATCH] scsi: qla2xxx: Fix improper freeing of purex item
Date: Fri, 28 Nov 2025 22:30:06 -0500
Message-ID: <176438479590.3682470.14841073923853792072.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251113151246.762510-1-zilin@seu.edu.cn>
References: <20251113151246.762510-1-zilin@seu.edu.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=886
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511290024
X-Authority-Analysis: v=2.4 cv=ZeYQ98VA c=1 sm=1 tr=0 ts=692a68ce cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=adQosAKi50IBXOjU6NIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI5MDAyMyBTYWx0ZWRfX1+y5Z0QswS7M
 6IrKCsZ4H8bphfFh4OMm2s7L/sYeGMeX8vQm4cJX7qkDJ126c9JqBvGP23tHQ15EGkN75xucp6n
 AwiVpfuNBvbgLoMGFgZGGm8n8LGnfBdKaWHPkeMrx910Ss9prXRntA7gPfDW0NSI50qHjrUnOhR
 2X85yY6AXXGJc3fEJ634uRAEeDJgxZrlsLeoLoeFpgFe/1KcyF7peySwru5HgWD+yXs4Ow/a5qn
 3Ibs8Pkx/clb91enyRiu1zWKcBuoVBNSmGjlYlSLVCLDG54Rkv/VzonxqD0YDmliO6WIExn4Zvk
 /CifinCX17qX1pCjcvTAW08LOUk3066KneKsAykFvvgXhrx834CnOCh3z4eMbiraJpYnKvg2XVl
 OSacvM4lRBcWSXrr0tfhDASjfo4xPw==
X-Proofpoint-ORIG-GUID: d9WTMUSLb_FkdBqD8tSoz-JzcFc7ku9R
X-Proofpoint-GUID: d9WTMUSLb_FkdBqD8tSoz-JzcFc7ku9R

On Thu, 13 Nov 2025 15:12:46 +0000, Zilin Guan wrote:

> In qla2xxx_process_purls_iocb(), an item is allocated via
> qla27xx_copy_multiple_pkt(), which internally calls
> qla24xx_alloc_purex_item().
> 
> The qla24xx_alloc_purex_item() function may return a pre-allocated item
> from a per-adapter pool for small allocations, instead of dynamically
> allocating memory with kzalloc().
> 
> [...]

Applied to 6.19/scsi-queue, thanks!

[1/1] scsi: qla2xxx: Fix improper freeing of purex item
      https://git.kernel.org/mkp/scsi/c/78b1a242fe61

-- 
Martin K. Petersen
