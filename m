Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E15289824
	for <linux-scsi@vger.kernel.org>; Thu, 20 Nov 2025 04:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763612189; cv=none; b=ofZXDTVxs7bSZrHCS23x0P95/Y9XKq9hLrsbiVpcTjnufodSCTvxPazvYAD63qdbqNtU09bDfXOyVX6FalpSgMHPjlBqJRV5lKHY309v8ukHBBe7rHFZhvN1Uuv+8qhJIkCRE3Z806PX6j4TBh8eTNfFH3kr3e/syCGEkFNL67M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763612189; c=relaxed/simple;
	bh=30zL/yTx8fvLdlXRX6xIaSIDrWQcqP7dqU9hhe+qdFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kdJAssF4MSxxmKtWVABqOCdGwWYA2JWIhSpJtgtmqr3OJm0FHA6vFrfdNhfL3kR1DMGgDVrv7k8y7KyWTmx0TN0qXuN4/jWyZO5WeXdeDjHKRnAX0lp7l8g4FqUc2yGb1cQKZlNuX1C2auRZHdR/jKNd1oDVjJDz/30bNXK9I6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bj3lN1XY; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bj3lN1XY"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK1OgpR031011;
	Thu, 20 Nov 2025 04:16:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=qnfj0YTCpeiLQ6IVmSCTtVtDpWsoMkOM0S7dQALl5ys=; b=
	bj3lN1XYKFdrjK7JVbS6RkIgP4NF8iqh5/gt1kIzEvqPXTEr9K5Ag9UAj6ZJe9fn
	ywelVBp8g5KenlK4rTSNqG8TFC81idVXWlmm3/viQtoR598aIwmCkNL00hYLMopP
	h9FSTXwA5O371qa/MmkqaGm7LCtcvmn5NrffN4gcnLoofYkBN+F/LYZi9iBk1ftW
	G3Gi1GdMwR2bzqwIqbe3hMBMnQbd2ijmE/janmuiEXTjZ1Jj92wbr1uz+ae+rq/a
	rWbwvxy8v4elU6rVqLDZaBi3R3ra6eVzY3JVYUwinj3ajR5GG7M7ahhBsB38y3GC
	Vk8XQ2P9BMb1xSE/rybf7g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aej968bhp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 04:16:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK2drQF007212;
	Thu, 20 Nov 2025 04:16:22 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefybh49j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 04:16:22 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5AK4GKPV012546;
	Thu, 20 Nov 2025 04:16:21 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4aefybh471-3;
	Thu, 20 Nov 2025 04:16:21 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v8 00/28] Optimize the hot path in the UFS driver
Date: Wed, 19 Nov 2025 23:15:52 -0500
Message-ID: <176357169010.3229299.17397404904114047362.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031204029.2883185-1-bvanassche@acm.org>
References: <20251031204029.2883185-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-20_01,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 malwarescore=0 adultscore=0 mlxlogscore=894 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511200020
X-Authority-Analysis: v=2.4 cv=DYoaa/tW c=1 sm=1 tr=0 ts=691e9617 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=lEJPKUlkNUVdK2lYoccA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: egGmx6simXFSWOC4dcQyUOUbzrDWzxlX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfX0imFPPbZm3/Y
 WhY+fBYlyAcNO1qBQxnFQ7M1F/NmA77r38XZel7YZmWaBAZ7LY91IIYp7+zH0KAlUPz2lvwgsPC
 wVZvfLj727KnevGt2da6FJm3jW3TlsidZyGEzRZ7t1HyRukOSomDXbdJZnoKFkcmxiC5Hw5NNkK
 gbf8ydn5bDwoD3AjvTwHuEnlFPNTJxuntK+Wi44KHZSPvplpRuUujRrhHrToSYvpSJEuyrm7ebi
 OlW+dECopB5ip3gVEMhlPs/lvhhwtuKUtAuVuK0rF20DOSw1hyfvNoH7s1/ve4BsXtyMSEqjcy5
 9DnvTjIZQAcSNomLQbeaqQm8+wrhSVIKBzEUxXdxKvToMDjy4v/j+uwFps/lUU9M0JmDnsQuojx
 0XbLwRxqHO+y7PvO4paNUlhf14M5Nw==
X-Proofpoint-ORIG-GUID: egGmx6simXFSWOC4dcQyUOUbzrDWzxlX

On Fri, 31 Oct 2025 13:39:08 -0700, Bart Van Assche wrote:

> This patch series optimizes the hot path of the UFS driver by making
> struct scsi_cmnd and struct ufshcd_lrb adjacent. Making these two data
> structures adjacent is realized as follows:
> 
> @@ -9040,6 +9046,7 @@ static const struct scsi_host_template ufshcd_driver_template = {
>      .name           = UFSHCD,
>      .proc_name      = UFSHCD,
>      .map_queues     = ufshcd_map_queues,
> +    .cmd_size       = sizeof(struct ufshcd_lrb),
>      .init_cmd_priv  = ufshcd_init_cmd_priv,
>      .queuecommand   = ufshcd_queuecommand,
>      .mq_poll        = ufshcd_poll,
> 
> [...]

Applied to 6.19/scsi-queue, thanks!

[00/28] Optimize the hot path in the UFS driver
        https://git.kernel.org/mkp/scsi/c/ab57a18665a2
[01/28] scsi: core: Support allocating reserved commands
        https://git.kernel.org/mkp/scsi/c/d604e1ec246d
[02/28] scsi: core: Move two statements
        https://git.kernel.org/mkp/scsi/c/21008cabc5d9
[03/28] scsi: core: Make the budget map optional
        https://git.kernel.org/mkp/scsi/c/a47c7bef5785
[04/28] scsi: core: Support allocating a pseudo SCSI device
        https://git.kernel.org/mkp/scsi/c/d630fbf6fc8c
[05/28] scsi: core: Introduce .queue_reserved_command()
        https://git.kernel.org/mkp/scsi/c/11ea1de3fc4b
[06/28] scsi: core: Add scsi_{get,put}_internal_cmd() helpers
        https://git.kernel.org/mkp/scsi/c/a2ab4e33286d
[07/28] scsi_debug: Abort SCSI commands via an internal command
        https://git.kernel.org/mkp/scsi/c/581ca490353c
[08/28] ufs: core: Move an assignment in ufshcd_mcq_process_cqe()
        https://git.kernel.org/mkp/scsi/c/dd4299af9b04
[09/28] ufs: core: Change the type of one ufshcd_add_cmd_upiu_trace() argument
        https://git.kernel.org/mkp/scsi/c/9f8e09230f53
[10/28] ufs: core: Only call ufshcd_add_command_trace() for SCSI commands
        https://git.kernel.org/mkp/scsi/c/60a1f6a8ad33
[11/28] ufs: core: Change the type of one ufshcd_add_command_trace() argument
        https://git.kernel.org/mkp/scsi/c/ffa5d8c15300
[12/28] ufs: core: Change the type of one ufshcd_send_command() argument
        https://git.kernel.org/mkp/scsi/c/3e7fff3fee5b
[13/28] ufs: core: Only call ufshcd_should_inform_monitor() for SCSI commands
        https://git.kernel.org/mkp/scsi/c/ae7bf255b10e
[14/28] ufs: core: Change the monitor function argument types
        https://git.kernel.org/mkp/scsi/c/f59568f4e27a
[15/28] ufs: core: Rework ufshcd_mcq_compl_pending_transfer()
        https://git.kernel.org/mkp/scsi/c/63a5b959c854
[16/28] ufs: core: Rework ufshcd_eh_device_reset_handler()
        https://git.kernel.org/mkp/scsi/c/f18fac1e2b72
[17/28] ufs: core: Rework the SCSI host queue depth calculation code
        https://git.kernel.org/mkp/scsi/c/e8ea985a8314
[18/28] ufs: core: Allocate the SCSI host earlier
        https://git.kernel.org/mkp/scsi/c/f46b9a595fa9
[19/28] ufs: core: Call ufshcd_init_lrb() later
        https://git.kernel.org/mkp/scsi/c/45e636ea1294
[20/28] ufs: core: Use hba->reserved_slot
        https://git.kernel.org/mkp/scsi/c/d3fd0fd77686
[21/28] ufs: core: Make the reserved slot a reserved request
        https://git.kernel.org/mkp/scsi/c/1d0af94ffb5d
[22/28] ufs: core: Do not clear driver-private command data
        https://git.kernel.org/mkp/scsi/c/e5f9cc2af9a8
[23/28] ufs: core: Optimize the hot path
        https://git.kernel.org/mkp/scsi/c/22089c218037
[24/28] ufs: core: Pass a SCSI pointer instead of an LRB pointer
        https://git.kernel.org/mkp/scsi/c/176b93004c34
[25/28] ufs: core: Remove the ufshcd_lrb task_tag member
        https://git.kernel.org/mkp/scsi/c/9a2c9500921d
[26/28] ufs: core: Make blk_mq_tagset_busy_iter() skip reserved requests
        https://git.kernel.org/mkp/scsi/c/4b6c0d9cca35
[27/28] ufs: core: Move code out of ufshcd_wait_for_dev_cmd()
        https://git.kernel.org/mkp/scsi/c/a11c015c8a4f
[28/28] ufs: core: Switch to scsi_get_internal_cmd()
        https://git.kernel.org/mkp/scsi/c/08b12cda6c44

-- 
Martin K. Petersen
