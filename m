Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54822D47A5
	for <linux-scsi@vger.kernel.org>; Tue,  6 May 2025 04:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746505567; cv=none; b=uZPwx+c11f2ZJDos+r/gU3FjJ5pLnSZg44ehtTiczgu6cIASDS6VNhjTdH0Ewd68JN1GMa+4L5Fd2vZT5s2z2jjnBhWdU/9oJZikQrH43h0L3FDsjX8/S6vum9ty87vgn09/AEEda5MlSFy+gPyBz+7s112MEFaPYnV4XPEYei8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746505567; c=relaxed/simple;
	bh=EaNYWgYDp2gLlKn57lJ9nA9AIPFmOugU0Bnm0N4XwsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pwdbqdaEMvoCGR2dHphmLpPEdnvm4kGVs0PgTVykFO0287bNjc5UnQj53Weir0MkZf6RRNyDxM0UXNPBIyuzRweFT0cvC/7ZRGBnjTifs2G1LuDU6zE1U9KPWx8yUTw9orraTUtD3TAcy8PO6CqQiKWqh0cZPu4R0w4gSN+ZI0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HJeL3qAG; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HJeL3qAG"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54638Bvc002299;
	Tue, 6 May 2025 04:25:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=NHx/XgFQrLlS7/HqQso4GdMxNIp3KC2oHkpr/9vouHA=; b=
	HJeL3qAGfZaEkMRWQoIYsh4XZhXA17mIAisZ7PVdGaTnNwg6UcnZP7SIfl7+bohi
	p4G77z63G70E2W9VfPmpEvwNjjEnm3QoIZd38a/F7etgNhvE5ie3IgoqXJkGImRd
	HclYJ9ahIUmx4OVpOmZOIcarNYLElJ7IL6MFqD0VjqRN3av3GnjjMJYHdrS5ZGCj
	JxkhQBosYGIZgXuuh6ukDPQqRG3ksf20qnOjHHdTOwyWWnULeaAPmpdrLOq0QKWd
	NoxNkA2fPLk3785GJOZZg1FPSlYDXjlcN0et0tHAaeTE6BrzCAV8COaBBjgq/Fzk
	j0rpHYaJFWDlQGTcFmM98w==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46fa80r24u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 May 2025 04:25:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5462CcPG036099;
	Tue, 6 May 2025 04:25:54 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46d9k8gpn6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 May 2025 04:25:54 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5464Pr46012838;
	Tue, 6 May 2025 04:25:53 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 46d9k8gpmt-1;
	Tue, 06 May 2025 04:25:53 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: scott.teel@microchip.com, scott.benesh@microchip.com,
        gerry.morong@microchip.com, mahesh.rajashekhara@microchip.com,
        mike.mcgowen@microchip.com, murthy.bhat@microchip.com,
        kumar.meiyappan@microchip.com, jeremy.reeves@microchip.com,
        hch@infradead.org, James.Bottomley@HansenPartnership.com,
        joseph.szczypek@hpe.com, POSWALD@suse.com, cameron.cumberland@suse.com,
        Yi Zhang <yi.zhang@redhat.com>, Don Brace <don.brace@microchip.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/5] smartpqi updates
Date: Tue,  6 May 2025 00:25:19 -0400
Message-ID: <174649624850.3806817.16750220972374045020.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250423183229.538572-1-don.brace@microchip.com>
References: <20250423183229.538572-1-don.brace@microchip.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-06_02,2025-05-05_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2504070000 definitions=main-2505060039
X-Authority-Analysis: v=2.4 cv=GqBC+l1C c=1 sm=1 tr=0 ts=68198f53 b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VwQbUJbxAAAA:8 a=3757S1Q47rFMJO7XUq4A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: uVHaSNWOBv7ulNRrwVpvCgcqnDpUIKdk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA2MDAzOSBTYWx0ZWRfXxaa/Jf1GHUxd IWSDS+mcUe7uze1EXaBmqOuFEg+Cka/3w2zs6ur+boxoLiSiloVcusB6rGMs8s0iLJcXT+nNGFV HRShEG62bzAs+8toqdaFihpS0wRAOiQnBgW8txhbQxXkJNQgdoUW3o0BvFnJcJg7L7wn4kp2u0+
 759kl1yQph0J9fxtvm15iMg0ISIQZKrtGXb+8C5Frv6YszMlRSRr6iW9fDFd4YSpmjpo0O3naXi pUbGjz6dJRxP3onJTaNaM7DCwVLbo3QlYeV1azZkNeGtqFCfJ7Jx4CLQjAKVgzLRoKYSdG2Dbnt klk0dWgzEK0jdChqyUdjLMjTWakdMalqefbbcCe32T8HPG8R0krnEaaHUGQwxBj8xbB2RnCAe9n
 VcH+8pXjB1PQDrcw3niezLDhfFvb4Ndzub6CfD+1adrWEpkGMSVVe+7Pqwih8vh/yrVqt+gV
X-Proofpoint-ORIG-GUID: uVHaSNWOBv7ulNRrwVpvCgcqnDpUIKdk

On Wed, 23 Apr 2025 13:32:24 -0500, Don Brace wrote:

> These patches are based on Martin Petersen's 6.16/scsi-queue tree
>   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
>   6.16/scsi-queue
> 
> There are two main functional changes in this patch series:
> smartpqi-take-drives-offline-when-controller-is-offline
> smartpqi-fix-smp_processor_id-call-trace-for-preemptible-kernels
> 
> [...]

Applied to 6.16/scsi-queue, thanks!

[1/5] smartpqi: take drives offline when controller is offline
      https://git.kernel.org/mkp/scsi/c/32c79c268078
[2/5] smartpqi: add new pci ids
      https://git.kernel.org/mkp/scsi/c/01b8bdddcfab
[3/5] Enhance WWID Logging Logic.
      https://git.kernel.org/mkp/scsi/c/001164fc3082
[4/5] smartpqi: fix smp_processor_id() call trace for preemptible kernels
      https://git.kernel.org/mkp/scsi/c/42d033cf4b51
[5/5] smartpqi: update driver version to 2.1.34-035
      https://git.kernel.org/mkp/scsi/c/6e6d9e85bad2

-- 
Martin K. Petersen	Oracle Linux Engineering
