Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522571C27;
	Sat, 17 Aug 2024 01:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723858449; cv=none; b=t+ZQQx8gJ2pG4iFKMMWWG0uhAuFiI+4D1jJfR7dcKFDPA0K/AN2SuqGMydu7rHIsGfhkC44wkNedLngdaVrJz2pv+zpR2q7YNweL/alO9luASqgskkHSbGrxHevwQsbMEHQcUtSTW3+fPnNToKQVpLEaVwwzOofATfCO+MJ+h/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723858449; c=relaxed/simple;
	bh=WYGrtmRDGi5gX7rw4w5gWOMbvpyBuamVjOjeU7/9xqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o7a3SeWlV0BPkcT0NySs/IfgPyXWIEF1284JO/AtiF2myjJQkISKXjIIUT/8WUZ+LGJGSgJgtr/0LrjmyFo7MmKv/7EjnAWwSam7jymwcisg+xL7HzM5wTncdWyzC+FH/y5IeuIAvk1Tokdu0thse3KuB0rfX48xPihTWXgc42c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=H1THmsOl; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="H1THmsOl"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47GLCcKe015131;
	Sat, 17 Aug 2024 01:34:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=9XL9MTqU4nwkDPx0AuEJ9ok87Z0m5iSH5jxYU83mEfk=; b=
	H1THmsOlVSbskSNLEUmVsebMFDKPzeacWmZT4kVIKP9BisrMdEeII6Y2uPhTnhEU
	PibMqtMSY1KjIiLVwaSZ8/qX4Tt3Rgt5bJRbqFSivJ8f7hJt0aAJ5teUqoqgzzaZ
	dF3xJQOH6f33lfGnrMVOcTIwKaDUxP5cubPdSUsK4ACqz8vtqrYN6Jeosgn9vP1B
	X34dA2lugBBOa8zOL8xQk2aRYiR5eC/zYUGmbus35xWkkjnt4aBsS4nmOjjdEksA
	Y/RbX4rDnGVoVo4dzoHCfkLsm1+WL8Zbnvlt9xmNe4n9CoTgbxXKBhM0jWDSNVnd
	vsrWR4qymZ5VgX9ucrhKrQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40x039dhqu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Aug 2024 01:34:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 47H1XWKa020951;
	Sat, 17 Aug 2024 01:33:59 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 412ja6r026-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Aug 2024 01:33:59 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 47H1Xx3x021117;
	Sat, 17 Aug 2024 01:33:59 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 412ja6r01x-1;
	Sat, 17 Aug 2024 01:33:59 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Avri Altman <avri.altman@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Keoseong Park <keosung.park@samsung.com>,
        Manivannan Sadhasivam <manisadhasivam.linux@gmail.com>
Subject: Re: [PATCH v4 0/2] scsi: ufs: Add host capabilities sysfs group
Date: Fri, 16 Aug 2024 21:33:23 -0400
Message-ID: <172385819636.3430749.12789495756986082340.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240811143757.2538212-1-avri.altman@wdc.com>
References: <20240811143757.2538212-1-avri.altman@wdc.com>
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
 definitions=2024-08-16_18,2024-08-16_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=569 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408170009
X-Proofpoint-ORIG-GUID: eye9iivTrM0PN4xgu62NleqFdtuRob9k
X-Proofpoint-GUID: eye9iivTrM0PN4xgu62NleqFdtuRob9k

On Sun, 11 Aug 2024 17:37:55 +0300, Avri Altman wrote:

> This patch series add sysfs entries for the host capabilities registers.
> This platform info is otherwise not available. Please consider this
> patch series for the next merge window.
> 
> Thanks,
> Avri
> 
> [...]

Applied to 6.12/scsi-queue, thanks!

[1/2] scsi: ufs: Prepare to add HCI capabilities sysfs
      https://git.kernel.org/mkp/scsi/c/b9d104465a6c
[2/2] scsi: ufs: Add HCI capabilities sysfs group
      https://git.kernel.org/mkp/scsi/c/f51d74819577

-- 
Martin K. Petersen	Oracle Linux Engineering
