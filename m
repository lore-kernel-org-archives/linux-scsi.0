Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4CF2A1AA
	for <linux-scsi@vger.kernel.org>; Tue, 15 Jul 2025 01:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752544468; cv=none; b=S2+4IFe46mHanONtYrS4ZsvQYH5GqxpkQMbuad/wqppmFUJdGH5yl5Jk8cAllY1g0hUh/TnosOtStNue895LJE0lxGXoOfbtTIhHofXhmfNWbEBDCAQcQ2BoR/UpNTaBSwvoOS9AXO7KxkVCxxN+QpxHhVidaBbwYUy1BjwXARM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752544468; c=relaxed/simple;
	bh=ZJyt+0ZFnDoe2HVHJF0zY/i+72IfDqy5nPwH7YvNHKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ReWzwGTxRFMvlrbgXCnNv7AxFDJDhisnjXuFYdXfXP4O/i6AsOK6uJN8RUPmtICIaZZdRUjKCdvjtfDGuMuir59NOIy6gYcRsuikBCgWKWxvUxIcBza539js0tRHZ3EXadwsncsF07xbjDIcN5cK8EKKl1ua6fsSVeMsAgpgUvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nypyY0ff; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nypyY0ff"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56F1Yo05027905;
	Tue, 15 Jul 2025 01:54:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=wTtp40RDrkpn0d9slNSJccGgrcJTdz7zwzV8ldvlfHU=; b=
	nypyY0ffYlwc53iq5xrGm9NMK6HMQCUXNjpLHp9BVjek4/jreWnfbqVslz8QOAIc
	cUrZlEQ4P3NAOA7oS31Wx9P627jMx1yAOkEuaNgIo6c0i5wdG4qOL8MnBAerRkZ4
	85o8Gnwf+2GNzy1Zi/BfvKCuVHAtg2wWylzDQ/Veq4u47yUPW9bzJBZC9B7GX69p
	pvBBcSicOsI6VNikNr7eCEwUo+UETh9x+dJZCCNYDU71fhsPQaHEDS1MRi0m7IpK
	GXGD1G3tFOvW1v/J8NKtXJW32ajVBNel1FY+eue896IoR+86wGtLoB+knKCj8ASl
	TbRtzeZU7x5oV2m5SjQZNQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47uhjf60nd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Jul 2025 01:54:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56F0vRdn029770;
	Tue, 15 Jul 2025 01:54:23 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ue592dy1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Jul 2025 01:54:23 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 56F1sM6Y002175;
	Tue, 15 Jul 2025 01:54:23 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 47ue592dxd-2;
	Tue, 15 Jul 2025 01:54:23 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Justin Tee <justintee8345@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, jsmart2021@gmail.com,
        justin.tee@broadcom.com
Subject: Re: [PATCH 00/13] Update lpfc to revision 14.4.0.10
Date: Mon, 14 Jul 2025 21:53:49 -0400
Message-ID: <175193808963.2586181.5269540478621026253.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250618192138.124116-1-justintee8345@gmail.com>
References: <20250618192138.124116-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-14_03,2025-07-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507150016
X-Proofpoint-GUID: Je2erFlWNRBCLEayxRGUl0Fi0atm4J_L
X-Authority-Analysis: v=2.4 cv=O6g5vA9W c=1 sm=1 tr=0 ts=6875b4d0 cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=VwQbUJbxAAAA:8 a=eNYrrxoqDexAl3KD3yMA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: Je2erFlWNRBCLEayxRGUl0Fi0atm4J_L
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzE1MDAxNiBTYWx0ZWRfX+o1G2Z214g/i hKE5QAvS2hYobj7JJQyp1CyCzY42zeyS4DOTZrJPqfE+Oab8e9K39Lda61Jk5EbqQqg/ktbl3oV P4OAZJdfltYxC8wkQwQw54tKHy9r7lvary/KmiWVEgW3VLEJIP1vGvkLNM9U47+wBmAq642eniS
 D6Rwg4fsGLc0/bwVQWQozNbVt+wa1bsgfZhqY0enaRbbNTTKyBWJE2kleoyCV7PntHss6+4WskZ u+c5xEnbFt6EtKIhpFdHlpGXscOA6WT9BrnUU9ZoI3+Y74RIO/3fNq0oG0Tg8oGeAINJcNkswwR zSYl38EJz5P7g9zMqjldEamQSncXsN1WuqSfDNWA5k09HCRjp/kWC0ZH744hVEGdrASD5yc3lA0
 Vq2AasV2rMMHtiPknYG4nOBi4KY68+NF5qvJUT2sRQuvZNQyVdl3Kgtm0f6LO395aml/iY8x

On Wed, 18 Jun 2025 12:21:25 -0700, Justin Tee wrote:

> Update lpfc to revision 14.4.0.10
> 
> This patch set contains bug fixes related to diagnostic log messaging,
> driver initialization and removal, updates to mailbox command handling,
> and string modifications for obsolete adapter model descriptions.
> 
> The patches were cut against Martin's 6.17/scsi-queue tree.
> 
> [...]

Applied to 6.17/scsi-queue, thanks!

[01/13] lpfc: Revise logging format for failed CT MIB requests
        https://git.kernel.org/mkp/scsi/c/e6d4486edd4a
[02/13] lpfc: Update debugfs trace ring initialization messages
        https://git.kernel.org/mkp/scsi/c/5459bd49f05f
[03/13] lpfc: Check for hdwq null ptr when cleaning up lpfc_vport structure
        https://git.kernel.org/mkp/scsi/c/6698796282e8
[04/13] lpfc: Skip RSCN processing when FC_UNLOADING flag is set
        https://git.kernel.org/mkp/scsi/c/37c893e36b1b
[05/13] lpfc: Early return out of FDMI cmpl for locally rejected statuses
        https://git.kernel.org/mkp/scsi/c/6b61ec3dd472
[06/13] lpfc: Simplify error handling for failed lpfc_get_sli4_parameters cmd
        https://git.kernel.org/mkp/scsi/c/5a00dfc58bfe
[07/13] lpfc: Relocate clearing initial phba flags from link up to link down hdlr
        https://git.kernel.org/mkp/scsi/c/320c3a12b40c
[08/13] lpfc: Ensure HBA_SETUP flag is used only for SLI4 in dev_loss_tmo_callbk
        https://git.kernel.org/mkp/scsi/c/1cced5779e7a
[09/13] lpfc: Move clearing of HBA_SETUP flag to before lpfc_sli4_queue_unset
        https://git.kernel.org/mkp/scsi/c/a28d10a15600
[10/13] lpfc: Revise CQ_CREATE_SET mailbox bitfield definitions
        https://git.kernel.org/mkp/scsi/c/5d655969100d
[11/13] lpfc: Modify end-of-life adapters' model descriptions
        https://git.kernel.org/mkp/scsi/c/e03bc287623f
[12/13] lpfc: Update lpfc version to 14.4.0.10
        https://git.kernel.org/mkp/scsi/c/81f2d701670f
[13/13] lpfc: Copyright updates for 14.4.0.10 patches
        https://git.kernel.org/mkp/scsi/c/f14371aceef9

-- 
Martin K. Petersen	Oracle Linux Engineering
