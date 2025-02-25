Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33CB7E9
	for <linux-scsi@vger.kernel.org>; Tue, 25 Feb 2025 00:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740443606; cv=none; b=PfRaUYfNgWBn+bG0+VSe0jSZkj1gcCnJ2skBPRp4C6BPxlTAhkr02HjFYxja26VrzRlfdlg6jyB9sQR73lS4y5yVmqAEkLM9a48jYcn5/3diVtruguiQSYxpsuN9SVAScfIEqMKtWoExDmqqsYFxzDtsUKoKgz02NBLuVpdrP0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740443606; c=relaxed/simple;
	bh=JK1XNHhaEooLEVY9BZSXGQkjBqkHKUi6u6wLHtQQjHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KLqsfC3ZvItO6MPaHaHoxdYWHmBXBIY2zrYHQiWrU/q8vKPjBx72vcYJBBoLgdU9ih5jKZ89ymjiSZ8MjXVUM+fSezCoNiKrlKc2X8XNeds4YUXV3mwHPS2fqkCrFySevrjcblg5mgYd9H6tKhuD/hAhB11Gfkzt49UHKs3nRfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Vas7O94U; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Vas7O94U"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51OMK2TW002395;
	Tue, 25 Feb 2025 00:33:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=cpWcDUpHIbyWpaFUme1eOaEhy73vlcBCLKsE/uvzzBQ=; b=
	Vas7O94UGXzBpsSAowqBJ68puaHsLLErfKMehlszEVFjsMvS9+fNWhukxhjsuXfH
	DF3/q5lCKR9zecoLV5bSnoXBv3JMEohJxETZgjtxjS9zgjh/vRpaH44nWill8KCp
	/kX+euVF1CByth5H6fueP4Fe4J2d6tlefKd+U1X18rjkzuC18RDoQ4D3cUPMLhkU
	HNl34YWNCvMPVRXljf6TjGqR9Iih6muI8a+R1XV4oN8W5CcSTom5pqIxznADn8mN
	v6QiuwJeFxD1kVs7THFMB+tBQfiE/o/JIBLG5swaYhRz39YLatxFMR1qgIzyJOaE
	Mt/Ymss+Ns8iHcrVaQkZyQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44y5603x5h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Feb 2025 00:33:22 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51ON10gq025295;
	Tue, 25 Feb 2025 00:33:21 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44y51f0q9a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Feb 2025 00:33:21 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 51P0XI21025171;
	Tue, 25 Feb 2025 00:33:20 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 44y51f0q87-5;
	Tue, 25 Feb 2025 00:33:20 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        sathya.prakash@broadcom.com, ranjan.kumar@broadcom.com,
        suganath-prabu.subramani@broadcom.com, sumit.saxena@broadcom.com
Subject: Re: [PATCH 0/5] mpt3sas driver udpates
Date: Mon, 24 Feb 2025 19:32:50 -0500
Message-ID: <174044345139.2973737.18100372323027044318.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <1739410016-27503-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1739410016-27503-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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
 definitions=2025-02-24_11,2025-02-24_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=838
 phishscore=0 mlxscore=0 suspectscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2502250001
X-Proofpoint-GUID: LyRdn18XgylB8x3K3JpmV3maq1fz8k6l
X-Proofpoint-ORIG-GUID: LyRdn18XgylB8x3K3JpmV3maq1fz8k6l

On Wed, 12 Feb 2025 17:26:51 -0800, Shivasharan S wrote:

> This patch series adds support for the MCTP passthrough function over the
> MPI interface for management commands.
> Also fix issue related to task management handling during IOCTL timeout.
> 
> Shivasharan S (5):
>   mpt3sas: Update MPI headers to 02.00.62 version
>   mpt3sas: Add support for MCTP Passthrough IOCTLs
>   mpt3sas: Report driver capability as part of IOCINFO command
>   mpt3sas: Send a diag reset if target reset fails
>   mpt3sas: update driver version to 52.100.00.00
> 
> [...]

Applied to 6.15/scsi-queue, thanks!

[1/5] mpt3sas: Update MPI headers to 02.00.62 version
      https://git.kernel.org/mkp/scsi/c/70684dcbec3a
[2/5] mpt3sas: Add support for MCTP Passthrough commands
      https://git.kernel.org/mkp/scsi/c/c72be4b5bb7c
[3/5] mpt3sas: Report driver capability as part of IOCINFO command
      https://git.kernel.org/mkp/scsi/c/8c2465e20200
[4/5] mpt3sas: Send a diag reset if target reset fails
      https://git.kernel.org/mkp/scsi/c/5612d6d51ed2
[5/5] mpt3sas: update driver version to 52.100.00.00
      https://git.kernel.org/mkp/scsi/c/51edde19f008

-- 
Martin K. Petersen	Oracle Linux Engineering
