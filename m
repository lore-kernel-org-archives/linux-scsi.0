Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2311A38DF
	for <linux-scsi@vger.kernel.org>; Thu, 19 Sep 2024 15:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726761242; cv=none; b=CeVSoX1F1unXX1+e7qnpxSjPjrd8xpgl68j+ryg7O+7bX28powLT7OTajOEw8NdBfaaMnF5Kxoh2eMsgNcU7eeggWmxCpCKHX6I2c9ggxIx9lAalIZ/6kj79wsCth0GYnbVOzHowY8GdjO15Tr9KQtGWcYPrqVN2YwZufmTHMEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726761242; c=relaxed/simple;
	bh=sEJKPfeCBoRR6EA4sjjCe5ik/KfKv/1tj/ySBPlZpoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ukVGv7S1RuIXGeHWXzPgUSb1ufwnWGqjSmdg7Psxb0oIbSFFxO49QR88FSF+aKRcDhi+dqxESGQjQrY3diWZrED3rH56KBY0ZTkCclHho0ctpnMbjFqnxBspd9STjeNrNePjov10t9mASUrqQcR+1j4IgaxDStRfejE6PmLimCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Z6uDgvIl; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Z6uDgvIl"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48JEii8U008059;
	Thu, 19 Sep 2024 15:53:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=rYwYL8+72FWnfLYD8I47bFf0E21JGw6zXRAvXMU0Elc=; b=
	Z6uDgvIl7LtLEGQs+B9Y7jCQQ49r6uedPwJBfLc4tFlCGFv8OgwdZeP3AwZp5Lor
	4W2JxdkgqsnrMdntPkY27eFv3gC6/C2JG/4a3zXudnVulR9czT76OzoimPhAXVPF
	SAnkPK+r0yAuZ147RCdSrCbNIAx47Uv42pBLh6aM0/EuR58EwZlUes3+OKvD+365
	nIi+nxCfi/k0DKUiMgY9gp89+Ris1BczBA5Qopz1nizMCk9kA3QwB/JOcHkVYLhR
	BJA2BpN+xvL1gXbxOwucWttLtJxAGin0Oah5H/DzWC5gSkDI0xH0kiEPa879F82y
	zZZDd/QZrX+2LusJlNEewg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41n3sd4mga-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Sep 2024 15:53:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48JEa5cd010189;
	Thu, 19 Sep 2024 15:53:55 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41nyb9xjfp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Sep 2024 15:53:55 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 48JFri8x031813;
	Thu, 19 Sep 2024 15:53:55 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 41nyb9xj7h-11;
	Thu, 19 Sep 2024 15:53:55 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Justin Tee <justintee8345@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, jsmart2021@gmail.com,
        justin.tee@broadcom.com
Subject: Re: [PATCH 0/8] Update lpfc to revision 14.4.0.5
Date: Thu, 19 Sep 2024 11:52:57 -0400
Message-ID: <172676112054.1503679.9908085096924319727.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240912232447.45607-1-justintee8345@gmail.com>
References: <20240912232447.45607-1-justintee8345@gmail.com>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409190105
X-Proofpoint-ORIG-GUID: ni8AdgpyyJTr2D-c5igJ0dF9KT0IrgJr
X-Proofpoint-GUID: ni8AdgpyyJTr2D-c5igJ0dF9KT0IrgJr

On Thu, 12 Sep 2024 16:24:39 -0700, Justin Tee wrote:

> Update lpfc to revision 14.4.0.5
> 
> This patch set contains bug fixes related to HBA state clean ups, FCP
> discovery on older adapters, kref imbalances, log message improvements,
> and support for a new diagnostic loopback testing mode.
> 
> The patches were cut against Martin's 6.12/scsi-queue tree.
> 
> [...]

Applied to 6.12/scsi-queue, thanks!

[1/8] lpfc: Add ELS_RSP cmd to the list of WQEs to flush in lpfc_els_flush_cmd
      https://git.kernel.org/mkp/scsi/c/93bcc5f3984b
[2/8] lpfc: Update phba link state conditional before sending CMF_SYNC_WQE
      https://git.kernel.org/mkp/scsi/c/fc318cac66ac
[3/8] lpfc: Restrict support for 32 byte CDBs to specific HBAs
      https://git.kernel.org/mkp/scsi/c/05ab4e7846f1
[4/8] lpfc: Fix kref imbalance on fabric ndlps from dev_loss_tmo handler
      https://git.kernel.org/mkp/scsi/c/d1a2ef63fc8b
[5/8] lpfc: Ensure DA_ID handling completion before deleting an NPIV instance
      https://git.kernel.org/mkp/scsi/c/0a3c84f71680
[6/8] lpfc: Revise TRACE_EVENT log flag severities from KERN_ERR to KERN_WARNING
      https://git.kernel.org/mkp/scsi/c/1af9af1f8ab3
[7/8] lpfc: Support loopback tests with VMID enabled
      https://git.kernel.org/mkp/scsi/c/eeb85c658e1b
[8/8] lpfc: Update lpfc version to 14.4.0.5
      https://git.kernel.org/mkp/scsi/c/b071c1a9099c

-- 
Martin K. Petersen	Oracle Linux Engineering
