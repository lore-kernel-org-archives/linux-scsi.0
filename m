Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DB116D330
	for <linux-scsi@vger.kernel.org>; Mon,  5 Aug 2024 21:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722892710; cv=none; b=le4lbF1sXb/LT5pKrPa0MaHUnZG6CS2K/QiGp9F5bizdHyzkvTN5eLQah/TWdvvZVTBrufeAvnvkyZUn3kqXzGMvvnBsrgUkX/7cwu/nW2Vpyy3HajDiWTPnjOvS0xEqGzVRm0smoubayTpNZPtSbgRZFjHehWf+jUCK8z2rAYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722892710; c=relaxed/simple;
	bh=khfPojtysPyP66OaE7ztIj8MA2ZP3bipJrNkud8Tzwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z8hyAXPxNBXhBms42wGCVzkymw95diyzlVew31SlqtVX5u9qWf5iwKBr/r0Tr6PhM4f0XfTQKQwxRenHlNwdTepfadvRzV6j7GWNRcw5Vs3m1nyQrdLn9YUKY2+Z5Xd8BXJB4nyZBqRgo9C4iTT4kyrQna3MhFVk2dwHSEaOXo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IawoZl5a; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IawoZl5a"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 475Kj06b028525;
	Mon, 5 Aug 2024 21:18:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=CNmsVclY7h0gLFVxm6aNogN7xlDzDeBfMejh68/ajAs=; b=
	IawoZl5a85wOGjmRjhdnzbBQY7A/Fw60Xrk1lL66jsjThnwVhX1nCiL5x/mPIhHC
	vQM0gtS7hOHEe83wrQEffEcH2Oha1+utO/HW/Axr6fF5owbPp71FRkUiT77vo8uh
	uUFB5+6JffAIQPGepireBbQbnLuz+NLyTNIHrIxzXy1VHf2olKcQoCA4NnuKqSBz
	WJDBfWzmJevpdoBW/rikdfmCrhkeXDGvwjrlanrc8LaBUvvTKPikUF5+k4R1YdVU
	S4CzCm+Na9dP8CUNjUpV85NHxBoznH7lh2UlXB2KCjYa4oJ6ulRXAuyK07SWAFD/
	sIr7a7fFEH1mgLDhRSIT0w==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40sckcbr04-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Aug 2024 21:18:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 475JZk4q035180;
	Mon, 5 Aug 2024 21:18:24 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40sb07ydgx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Aug 2024 21:18:24 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 475LINEL035403;
	Mon, 5 Aug 2024 21:18:24 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 40sb07ydcw-2;
	Mon, 05 Aug 2024 21:18:24 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Justin Tee <justintee8345@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, jsmart2021@gmail.com,
        justin.tee@broadcom.com
Subject: Re: [PATCH 0/8] Update lpfc to revision 14.4.0.4
Date: Mon,  5 Aug 2024 17:17:26 -0400
Message-ID: <172289240515.2008326.1437923395622907043.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240726231512.92867-1-justintee8345@gmail.com>
References: <20240726231512.92867-1-justintee8345@gmail.com>
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
 mlxlogscore=999 mlxscore=0 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408050151
X-Proofpoint-GUID: oEaunNXsovTEcoZJnRgX7yjN6V5V2drH
X-Proofpoint-ORIG-GUID: oEaunNXsovTEcoZJnRgX7yjN6V5V2drH

On Fri, 26 Jul 2024 16:15:04 -0700, Justin Tee wrote:

> Update lpfc to revision 14.4.0.4
> 
> This patch set contains diagnostic logging improvements, a minor clean up
> when submitting abort requests, a bug fix related to reset and errata
> paths, and modifications to FLOGI and PRLO ELS command handling.
> 
> The patches were cut against Martin's 6.11/scsi-queue tree.
> 
> [...]

Applied to 6.12/scsi-queue, thanks!

[1/8] lpfc: Change diagnostic log flag during receipt of unknown ELS cmds
      https://git.kernel.org/mkp/scsi/c/5b8963c53de1
[2/8] lpfc: Remove redundant vport assignment when building an abort request
      https://git.kernel.org/mkp/scsi/c/f1bfe3207396
[3/8] lpfc: Validate hdwq pointers before dereferencing in reset/errata paths
      https://git.kernel.org/mkp/scsi/c/2be1d4f11944
[4/8] lpfc: Fix unintentional double clearing of vmid_flag
      https://git.kernel.org/mkp/scsi/c/3976beb1b410
[5/8] lpfc: Fix unsolicited FLOGI kref imbalance when in direct attached topology
      https://git.kernel.org/mkp/scsi/c/b5c18c9dd138
[6/8] lpfc: Update PRLO handling in direct attached topology
      https://git.kernel.org/mkp/scsi/c/1f0f7679ad89
[7/8] lpfc: Update lpfc version to 14.4.0.4
      https://git.kernel.org/mkp/scsi/c/62b52495e6a1
[8/8] lpfc: Copyright updates for 14.4.0.4 patches
      https://git.kernel.org/mkp/scsi/c/5b247f03779d

-- 
Martin K. Petersen	Oracle Linux Engineering
