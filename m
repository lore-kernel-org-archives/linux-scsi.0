Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D0B2750FB
	for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2025 03:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761795223; cv=none; b=R8iqtfK2lTud6WBq50t3PvCL5wcGx4B57oUJlvsla+FHJmhabvC/2ze5PDksQwXbArmqETkrEugvrgBZXVvENhK+O4OINsqZzU7V+pqOlWFT8/pIud61fHC0EfNKtx9yiPWgmoHBYJcuyWre07TapnC8EXMClnXwqgKg0xmDsp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761795223; c=relaxed/simple;
	bh=CpqjRIr8pyDleusYdCdvz1yMZ6dAsUA7RH5Ec1QfiIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z+I4mCCCe+IWLK1i7GIUiWQLMN0nh/exxuLquTfSOdCd9A0kyfmI3t8jATfD2rnfPLE5ovediQj8Vl7D+yvpOoVdVxGNF1Kj89slSK9bBYB+JXVNuUEVH8k1ubvpQKKXAht3Af2iNk/kLGluXEJMCv96R0MHQliZzM0QJBIWqxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hIWp9Kta; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hIWp9Kta"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59U29gL6018562;
	Thu, 30 Oct 2025 03:33:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=dWCbHuLTDw4M0L5Y/V+G/UnYkI6jhTNYJrTpJnCp7W0=; b=
	hIWp9Kta6W3Swg7PEtyjNe3nhKoKuZD4LLidFLhz92pUdpTuTIFVMa4Gt4LH/Hlv
	MnGSdEpueP81c+w8+Nmu11S4cE9Ymyry8Gv4ySnUrKp5I6CRC61MPE2raw3mzHKD
	A+CFdyPuVhxuvQP76cHIHpEn/WooalR4s2V6In27Ic15rzdepnKr0RjicJ5WSCwF
	QPDm1rcZnlVWTaLD6s4qCh47aJZNktkxaBR8JysA1KO6X8mctR6NUWsqtCam8RzO
	wOCvyJJsBM3KX8W6pGJVYgyvEa12eZ7Br6QveZIA4bSQGP6lNbO/ATjD40ogcHvQ
	vqVuIZfJBpV1XhEdLw0vOQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a3y02g2v7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 03:33:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59U3FSwK022845;
	Thu, 30 Oct 2025 03:33:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a33y01upa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 03:33:36 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 59U3XYQg034192;
	Thu, 30 Oct 2025 03:33:36 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4a33y01uh6-2;
	Thu, 30 Oct 2025 03:33:35 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Gilbert Wu <gilbert.wu@microchip.com>,
        Sagar Biradar <Sagar.Biradar@microchip.com>,
        John Garry <john.g.garry@oracle.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2] scsi: aacraid: Improve code readability
Date: Wed, 29 Oct 2025 23:33:18 -0400
Message-ID: <176178801899.1949089.5502575389744306993.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021201743.3539900-1-bvanassche@acm.org>
References: <20251021201743.3539900-1-bvanassche@acm.org>
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
 definitions=2025-10-30_01,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 mlxscore=0
 adultscore=0 mlxlogscore=740 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2510300026
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDMwMDAxNSBTYWx0ZWRfX3GSY6f9Yvo5r
 0a0CZPuHNUG9CNGjaLzQYSp8QqoaTF7m5H7nybogMbcEsjYBu1sXbKG56c2Ro/hqF2RSLVBFWfW
 fD0KI76RicIumHlHCNQhuN+dJbQn2odEI+hx4WwjXmZNH8JOBwtO5yuVY1Xjs0rbnOVvZe1xaOK
 yq5m+KutRSBbmk3E9JA324YfQYya0my/nPlGyYHvNnLgFp87ieY0Wdkr3lkEcEdfH7SqMx4yaRs
 xRQSC4R9i5Idd8NKKnu7cZVV0RWsfsm85zZW54BVFr1SoXOpp6nk6jRzhX+q1GGfQa805SNuehj
 FfUmR2k+AstXtibviflc7BT+pSIjaEnpTl3V28IVeUtlHbe86YwQf6xPOFyiuLkP8r2Bky848g9
 Z7P8CCodTbYChgx2fpYRAOPq5H53Cg==
X-Proofpoint-ORIG-GUID: fLOyGXe5NbXvsGDf4ZxICsWuL_SPT0OK
X-Authority-Analysis: v=2.4 cv=Vs4uwu2n c=1 sm=1 tr=0 ts=6902dc91 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=QZoYPMFxlp6KCyUvQ4wA:9 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: fLOyGXe5NbXvsGDf4ZxICsWuL_SPT0OK

On Tue, 21 Oct 2025 13:17:43 -0700, Bart Van Assche wrote:

> aac_queuecommand() is a scsi_host_template.queuecommand() implementation.
> Any value returned by this function other than one of the following values
> is translated into SCSI_MLQUEUE_HOST_BUSY:
> * 0
> * SCSI_MLQUEUE_HOST_BUSY
> * SCSI_MLQUEUE_DEVICE_BUSY
> * SCSI_MLQUEUE_EH_RETRY
> * SCSI_MLQUEUE_TARGET_BUSY
> 
> [...]

Applied to 6.19/scsi-queue, thanks!

[1/1] scsi: aacraid: Improve code readability
      https://git.kernel.org/mkp/scsi/c/e414748b7e83

-- 
Martin K. Petersen
