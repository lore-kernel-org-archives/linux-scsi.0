Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15AFA1CFA9
	for <linux-scsi@vger.kernel.org>; Tue,  5 Nov 2024 02:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730774027; cv=none; b=YxsjlAPZMybKobBHBDowQhJmLVxfcdH8IdguPelMKx2zWWJyCnAdYm7urCYu4OqJwmT+RRj9jC+8hHfaUIhrLulJxO1ahc8HFSsA805/swT7LK7ocuRLnKKuIl68+25wCl+lUS9hreGOrNGiCnWi6pYb0oZ5QeDoO6UHUHgrOig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730774027; c=relaxed/simple;
	bh=R70yCyk9J7T8Q7LlcuA0+x9jP9/9EtkOrQlDiTBVxXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BMZs+cmwa2JcC09XGQYla2GidcQ2RFQcWkelDZY1S1mZAcGnjDOz96eL1PSJdJt0gRP6XP57c8K8eFyUw3dShIGHIT1Z4eBj+2nxukcVKKolzjKgE/N1l58eeTGnuzDdj9Y4UFjtS314Ex7DetfZGk55OafBCt/iTn5L/mKLuUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LNAp9kj6; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LNAp9kj6"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A52MYYM014560;
	Tue, 5 Nov 2024 02:33:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=HtPC2BhPdOaxqMumJoq4iqksB2wjahxiYimYX7ZQxbA=; b=
	LNAp9kj6xcuZhebi98eJAq41VKRZjOj+Jc0oVj/UomNFI4ccPRSxd4pTGpqcJFM4
	3JQ4q3bB+vqgWMz2Jqe70ZRQvEcitrcB8B7n3w+Mt/MB99ps4kojiQ+MMH0vn0rX
	6Ourlf7Q2kXMOWnTUrOZejI0FIGaH+H7DD46bDW6VsfXH+qtmYA7EQJ7XlkK2Lbj
	LRxDHXlrCM3frNOU3W1KlUQ3kuPosLUTAVRrS9oMhXjNgy/33UVGVm4OsfW6CJje
	yFW0oWjN91I9tnnN7+zMhFWLowu24M3bG6mFrN5wVAC8Pz3lrsRKCoRtHoMicppn
	wKzwdE1pC2Ylvc0eu8KazQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42nav249y3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 05 Nov 2024 02:33:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A51JIqq036804;
	Tue, 5 Nov 2024 02:33:32 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42nah6g2kq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 05 Nov 2024 02:33:32 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4A52XVFq017503;
	Tue, 5 Nov 2024 02:33:31 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 42nah6g2k1-3;
	Tue, 05 Nov 2024 02:33:31 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 0/6] UFS driver fixes and cleanups
Date: Mon,  4 Nov 2024 21:32:49 -0500
Message-ID: <173077364681.2354920.16396568145658818362.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241022193130.2733293-1-bvanassche@acm.org>
References: <20241022193130.2733293-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-04_22,2024-11-04_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=551
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411050019
X-Proofpoint-GUID: ne6AAQdqT57JqC716_WhIfuTMEitwYjV
X-Proofpoint-ORIG-GUID: ne6AAQdqT57JqC716_WhIfuTMEitwYjV

On Tue, 22 Oct 2024 12:30:56 -0700, Bart Van Assche wrote:

> This patch series includes several fixes and cleanup patches for the UFS driver.
> Please consider this patch series for the next merge window.
> 
> Thanks,
> 
> Bart.
> 
> [...]

Applied to 6.13/scsi-queue, thanks!

[1/6] scsi: ufs: core: Move the ufshcd_mcq_enable_esi() definition
      https://git.kernel.org/mkp/scsi/c/a085e03758b8
[2/6] scsi: ufs: core: Remove goto statements from ufshcd_try_to_abort_task()
      https://git.kernel.org/mkp/scsi/c/7df89440d0ec
[3/6] scsi: ufs: core: Simplify ufshcd_try_to_abort_task()
      https://git.kernel.org/mkp/scsi/c/9a5f6c09d0fa
[4/6] scsi: ufs: core: Simplify ufshcd_exception_event_handler()
      https://git.kernel.org/mkp/scsi/c/b5d9da58a051
[5/6] scsi: ufs: core: Simplify ufshcd_err_handling_prepare()
      https://git.kernel.org/mkp/scsi/c/2a36646012fc
[6/6] scsi: ufs: core: Improve ufshcd_mcq_sq_cleanup()
      https://git.kernel.org/mkp/scsi/c/2c73fb138da5

-- 
Martin K. Petersen	Oracle Linux Engineering
