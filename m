Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF1853A1
	for <linux-scsi@vger.kernel.org>; Wed, 24 Jan 2024 03:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706065262; cv=none; b=HMAzZ+uHTdWs7xTO06u0MH11uhEvAeyk8uI645w+5CdBPLIDzLwO4ZjM5wZEl9nfPjhtLGGfZ2Lz3qPb2CdexYBrLMayFbcFY8QuJGcBhe2EYUwKSt7649Wwm6yf4R2OZaKRs1Mm0vqYZzVeeRBGl4/Mo/2XII3m1OzdyJ0LUcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706065262; c=relaxed/simple;
	bh=3P6S8YZMO9uzZpNld310tdWWeBx5F6PpBd0c+doRBgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ErQMse/4fzWIxWNhSncpMNVS7Xfaj12lH2pvYSR/RJ7Je6oU/RlougdqEAe6fCHilMODpZHdmVfV5ve0JJGb2zlPvayuFEBhE8FHIpa4OarlqnC1DPEeLpRPQYW7sFcTxmjp0B0V3kRFzoCBLvxKkLnZNY0Bl2Tq8AyQfOaH2eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TXmzEgeZ; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TXmzEgeZ"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40O2xZMQ013806;
	Wed, 24 Jan 2024 03:00:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=10nUyqnGjFzpWex9UTXJZG+aVDguEhCT5tiG4HeAs8I=;
 b=TXmzEgeZDuGUHsDK6awzdvB7jqYUxwTqPwsW4PcDOA/UE8OGQxTBbkkqxP/Td6c6/zOE
 5xjOJIDYFRgu6+mqho4RlyFLQxhIWa+765ol75/zBR6LetAT4Kodgvu9i5VlxqEvvTcM
 wNImZM8Y/f09uiqukkvfhYMGM9a62L2NzxyINyvhn+1M1Fg49Zh0UNoXTb63Dvotyl3b
 I9mxkVQjGjlH9EaobF/sWG3N+CK4SO2alws+A8nMp2lu5meHXw49wxyCu+BhEH1c37GS
 a8/CimXUvYZwa4yt+58pfLBmaUmH3Bdcdt1yelH2FFJ3i5NWG0WM/B/S1nWheXKF8Sxm AQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vr7cur0jt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Jan 2024 03:00:56 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40O1RSIx040813;
	Wed, 24 Jan 2024 03:00:56 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vs3168jmj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Jan 2024 03:00:56 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40O30rRw012869;
	Wed, 24 Jan 2024 03:00:55 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3vs3168jht-3;
	Wed, 24 Jan 2024 03:00:55 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Ming Lei <ming.lei@redhat.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH] scsi: core: move scsi_host_busy() out of host lock for waking up EH handler
Date: Tue, 23 Jan 2024 22:00:44 -0500
Message-ID: <170606516775.594851.16997861687403168509.b4-ty@oracle.com>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20240112070000.4161982-1-ming.lei@redhat.com>
References: <20240112070000.4161982-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-23_15,2024-01-23_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=784 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401240021
X-Proofpoint-ORIG-GUID: IWLNsODD3yD0Bu6eGXCfUVEw6B1V-W5-
X-Proofpoint-GUID: IWLNsODD3yD0Bu6eGXCfUVEw6B1V-W5-

On Fri, 12 Jan 2024 15:00:00 +0800, Ming Lei wrote:

> Inside scsi_eh_wakeup(), scsi_host_busy() is called & checked with host lock
> every time for deciding if error handler kthread needs to be waken up.
> 
> This way can be too heavy in case of recovery, such as:
> 
> - N hardware queues
> - queue depth is M for each hardware queue
> - each scsi_host_busy() iterates over (N * M) tag/requests
> 
> [...]

Applied to 6.8/scsi-fixes, thanks!

[1/1] scsi: core: move scsi_host_busy() out of host lock for waking up EH handler
      https://git.kernel.org/mkp/scsi/c/4373534a9850

-- 
Martin K. Petersen	Oracle Linux Engineering
