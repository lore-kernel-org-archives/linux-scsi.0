Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4FDC13AA47
	for <linux-scsi@vger.kernel.org>; Sat, 26 Oct 2024 01:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729906717; cv=none; b=ewB6WJtv+WjbnyGs/LJCmOXt3SUAQxQWzrgvVqb9uhQAP5W+z483V5gw1oJHFRTnDEiW6W7L+jMn4/7kHK1VUKrEA0vqhtF7XQVGzmLfdXKXEc2kai17xcL3qLVvxI5tm3ajKwAncsKuaZnWJKIRBHVsGcTzqsQAa+dMXs8CXa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729906717; c=relaxed/simple;
	bh=mi8zlPIoVNg6Nqti9gfq3RKOb2hUhTbTMySnjTRzN/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Uz7qdT22yeQ8XC5w0tpbIvvD6WL+sQvHvIadzWWzlF4WVZ0+k0K0sw5ARszB4ypyMmybQXWZlpzWJJm8sETljl4AGxgCzJIkAz2UvLGY1OQSU9G1mOiOPN/ECyHWVyMQlMQAPZ6lsme5l2q5epBLqxhXaDEzO7daSInavZJl3zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jkufGLMO; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jkufGLMO"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49PJdTgk009555;
	Sat, 26 Oct 2024 01:38:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=p69pmxmJfyOFiqAdZeW4yVFxeX2poWJzG8zjBPhSl8E=; b=
	jkufGLMO+Ujm+Mvie56/GYwakyJ4MM4HJIjqQIE7l5bpXUukTReFNUb4FJteR0+7
	4/Bqm4zMfHTyZ/qRRFmy5GQQxsYVAkVKYn2dVjinoG9RTaAjhcMxDMJiV4XGd/Xn
	pS8qOdbcWJRqf81gAkHqiHyqb7J9OuiPFaXawR9dsde8MSy2Sd1jy0nf/wnjtV1T
	Q7CA4yk6M9HF9fs1TLd5zeh8FeKe0ePjr63Oe3/PcSTSk45YN+9bdt+2hWBG+TEQ
	c4CiB6GPma2wrzUE03E890dcz/K1JBwO55N36lrPasylRA1XEWkwvISjNviQvg6q
	BoBSHv7DD5bZvOgDzCJ3JQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42c55v65mg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 26 Oct 2024 01:38:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49Q1XBU2017107;
	Sat, 26 Oct 2024 01:38:24 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42gpv40360-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 26 Oct 2024 01:38:24 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 49Q1cMKb028982;
	Sat, 26 Oct 2024 01:38:23 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 42gpv4031v-2;
	Sat, 26 Oct 2024 01:38:23 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James.Bottomley@HansenPartnership.com, Yihang Li <liyihang9@huawei.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linuxarm@huawei.com
Subject: Re: [PATCH v2 00/13] scsi: hisi_sas: Some fixes for hisi_sas
Date: Fri, 25 Oct 2024 21:37:27 -0400
Message-ID: <172952538716.1368542.15294931117871391815.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008021822.2617339-1-liyihang9@huawei.com>
References: <20241008021822.2617339-1-liyihang9@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-25_14,2024-10-25_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 mlxlogscore=988 mlxscore=0 suspectscore=0 adultscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2410260012
X-Proofpoint-GUID: 6S-83KgInLkdbRUOsm7txwvjg_bGeXOk
X-Proofpoint-ORIG-GUID: 6S-83KgInLkdbRUOsm7txwvjg_bGeXOk

On Tue, 08 Oct 2024 10:18:09 +0800, Yihang Li wrote:

> This series contains some fixes including:
> - Adjust priority of registering and exiting debugfs for security;
> - Create trigger_dump at the end of the debugfs initialization;
> - Add firmware information check;
> - Enable all PHYs that are not disabled by user during controller reset;
> - Reset PHY again if phyup timeout;
> - Check usage count only when the runtime PM status is RPM_SUSPENDING;
> - Add cond_resched() for no forced preemption model;
> - Default enable interrupt coalescing;
> - Update disk locked timeout to 7 seconds;
> - Add time interval between two H2D FIS following soft reset spec;
> - Update v3 hw STP_LINK_TIMER setting;
> - Create all dump files during debugfs initialization;
> - Add latest_dump for the debugfs dump;
> 
> [...]

Applied to 6.13/scsi-queue, thanks!

[01/13] scsi: hisi_sas: Adjust priority of registering and exiting debugfs for security
        https://git.kernel.org/mkp/scsi/c/e6702e391932
[02/13] scsi: hisi_sas: Create trigger_dump at the end of the debugfs initialization
        https://git.kernel.org/mkp/scsi/c/436a97c5d288
[03/13] scsi: hisi_sas: Add firmware information check
        https://git.kernel.org/mkp/scsi/c/2c335fa7e69c
[04/13] scsi: hisi_sas: Enable all PHYs that are not disabled by user during controller reset
        https://git.kernel.org/mkp/scsi/c/08a07dc71d7f
[05/13] scsi: hisi_sas: Reset PHY again if phyup timeout
        https://git.kernel.org/mkp/scsi/c/64359afb7068
[06/13] scsi: hisi_sas: Check usage count only when the runtime PM status is RPM_SUSPENDING
        https://git.kernel.org/mkp/scsi/c/4ca4ce000610
[07/13] scsi: hisi_sas: Add cond_resched() for no forced preemption model
        https://git.kernel.org/mkp/scsi/c/2233c4a0b948
[08/13] scsi: hisi_sas: Default enable interrupt coalescing
        https://git.kernel.org/mkp/scsi/c/a220bffebabe
[09/13] scsi: hisi_sas: Update disk locked timeout to 7 seconds
        https://git.kernel.org/mkp/scsi/c/90b24856b311
[10/13] scsi: hisi_sas: Add time interval between two H2D FIS following soft reset spec
        https://git.kernel.org/mkp/scsi/c/3c62791322e4
[11/13] scsi: hisi_sas: Update v3 hw STP_LINK_TIMER setting
        https://git.kernel.org/mkp/scsi/c/90f17e3431d9
[12/13] scsi: hisi_sas: Create all dump files during debugfs initialization
        https://git.kernel.org/mkp/scsi/c/9f564f15f884
[13/13] scsi: hisi_sas: Add latest_dump for the debugfs dump
        https://git.kernel.org/mkp/scsi/c/cae668130c07

-- 
Martin K. Petersen	Oracle Linux Engineering
