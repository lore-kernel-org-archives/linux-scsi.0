Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7563936923F
	for <linux-scsi@vger.kernel.org>; Thu,  9 Apr 2026 02:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775702615; cv=none; b=RW+Rx7/GNxdxnFvSkjPFjTK6EyxmG5VOFb747hvRyd3Tr7ghLFE10aTF9pjs6ecYqDCHcjeNQHQ6C536h7M5UB5qlfumsOqrwEY3hWEQhCZ+6jnJlqZPmYFtcHZxTGSiNiEj01XyvzaeBhb5yHwfGDZ/hsxuMVIVaUtNuXZEUT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775702615; c=relaxed/simple;
	bh=1Z5W59JSN6+/0sseSeTNmrXov1Hs4VoJGXrPHnVHUK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fEUxcBWqmNi9ss+yQW2VZv8MyyF2jJ2j/FO4aANPZCiedtbyAt3mP9iYCB9BBnvelZcV+QVeyIEA3m/vpJfRqo8c3BUmqhSLfONXbt9+97rKsS+rHFgEaonAhLp7hhrlayMk7DGFDaVStMlc8bKnwjAFKsYHl8SgWKNLJ3KUTBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GASiu3r8; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GASiu3r8"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 638NtSra051751;
	Thu, 9 Apr 2026 02:43:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=cK+ZYvoeprxSTU8XLywHOAVBdbrlbRTuPrnttUHW3+o=; b=
	GASiu3r8OGDGG9BE+nYNrYO7vjmhaFcR/vcFD9+54RuLGNlKGlrPJq3ZZlERVbn2
	1n21RssTxO/jlWZitvmVuCff1L7FFtAdR7/wfL+x6zN0Gt9UkNSnMRAD7se9y5Z1
	EnIJ1qOwrB+j48GWgBMHD/RAQcm1MNmuVbArGsi4OmiRt1C/+uqFN5/9cjPQyzYU
	8nX7bAQyOuqZiZQcLe3MM2Zb6PkpyP98Og9/x+oW8PR1tSzkfUqjUK9jI/nojy+J
	2hdF3gcnO33wP9s5ODRlnU+EKgvGlydm8kneSRXGhRZ5UHl/TCejVLfBkYhGacKY
	j1v3uxEdMH1T0/z++68j8A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dcmqamx8y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Apr 2026 02:43:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6391KahL003443;
	Thu, 9 Apr 2026 02:43:30 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dcn5xhrbk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Apr 2026 02:43:30 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 6392hSUt031599;
	Thu, 9 Apr 2026 02:43:30 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4dcn5xhr6t-4;
	Thu, 09 Apr 2026 02:43:30 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Justin Tee <justintee8345@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, jsmart833426@gmail.com,
        justin.tee@broadcom.com
Subject: Re: [PATCH 00/10] Update lpfc to revision 15.0.0.0
Date: Wed,  8 Apr 2026 22:43:00 -0400
Message-ID: <177569866595.3870441.6456322385833021287.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331205928.119833-1-justintee8345@gmail.com>
References: <20260331205928.119833-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-08_07,2026-04-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 adultscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2604010000
 definitions=main-2604090023
X-Proofpoint-ORIG-GUID: qfhnhPE-y6D7BzpA7XzRwyuqEfTlCQ_R
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDAyMyBTYWx0ZWRfX8lmdQf0xQAQz
 tuDXL2HZ/DxWRyYOujhPlP4xV0xlhoQoXdzRemD8WgbT1tEhwB/HTiCQ3RCkGV8rBT0RBkc0U3R
 jMdnAs98qKoUHup9W+qwQsTeg3pPyKTQkdTKa7dfZyic5qAabdu/lolD/SAk/M8/Y+49W4w34EX
 qbMcVkJd4ZObDlzBf7li0YaOJ+R7tKF3jN6bTjNlnMGQqJ/EvvzBaDoTyyCMcsOgc7u78RZ6aOC
 qRPo3zCGsRMt2B7gSn/xEzVKGaDztw8UzsRl9wUmkTfRI+mtXA2XBZalYkgF2FYu39wJaXMhHiU
 Pz1EfcduQ4mcxggZoy75R5oXaatpKSsy8qSbZuaV0HplvulOD4sQ00xRWTvZ73iQXWKJfvHxHzm
 1uTQsbPBmSX8dX4Z6TdibICnybImG0HWCVqu+ZYDhBqwm+Eock5WswAA5VeOlNAmSup4pqI83C3
 +VAIJv6juISz2yAJynKxXx4rtmNo1fkQVmfSa1PQ=
X-Authority-Analysis: v=2.4 cv=AsTeGu9P c=1 sm=1 tr=0 ts=69d71253 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=VwQbUJbxAAAA:8
 a=QMOXFBlFPN1GjIz2dsQA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12291
X-Proofpoint-GUID: qfhnhPE-y6D7BzpA7XzRwyuqEfTlCQ_R

On Tue, 31 Mar 2026 13:59:18 -0700, Justin Tee wrote:

> Update lpfc to revision 15.0.0.0
> 
> This patch set adds support for the G8 ASIC found on the LPe42100 series
> adapter models.
> 
> Updates are made to irq affinity assignment, mailbox command handling
> related to initialization, SGL construction, firmware download
> diagnostics, and the removal of an outdated performance feature.  We also
> add 128G link speed selection and support.
> 
> [...]

Applied to 7.1/scsi-queue, thanks!

[01/10] lpfc: Break out of IRQ affinity assignment when mask reaches nr_cpu_ids
        https://git.kernel.org/mkp/scsi/c/e32b5e8f0950
[02/10] lpfc: Select mailbox rq_create cmd version based on sli4 if_type
        https://git.kernel.org/mkp/scsi/c/35f22f84bed1
[03/10] lpfc: Log mcqe contents for mbox commands with no context
        https://git.kernel.org/mkp/scsi/c/f75754f2feaa
[04/10] lpfc: Add REG_VFI mailbox cmd error handling
        https://git.kernel.org/mkp/scsi/c/5b402a8aceb1
[05/10] lpfc: Remove deprecated PBDE feature
        https://git.kernel.org/mkp/scsi/c/384075eb19b2
[06/10] lpfc: Update construction of SGL when XPSGL is enabled
        https://git.kernel.org/mkp/scsi/c/ba6dec7e703e
[07/10] lpfc: Check ASIC_ID register to aid diagnostics during failed fw updates
        https://git.kernel.org/mkp/scsi/c/a1421afa0ddb
[08/10] lpfc: Introduce 128G link speed selection and support
        https://git.kernel.org/mkp/scsi/c/39d1d94166da
[09/10] lpfc: Add PCI ID support for LPe42100 series adapters
        https://git.kernel.org/mkp/scsi/c/49b9f31e52b2
[10/10] lpfc: Update lpfc version to 15.0.0.0
        https://git.kernel.org/mkp/scsi/c/7f1e2c1cce1c

-- 
Martin K. Petersen
