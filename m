Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B533385A1;
	Sat, 23 May 2026 03:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779506149; cv=none; b=Zwi7IIG5krLWIswKk0+TB/92m+uitrYRFKS674hI0ajn4XKua0UU5vVRdEwGaUlK3uq08LXHRiCyeGLKM3HEcfZskmx2BPR52TSPZj3VQjxAdpqFQI3zP139fhdHVvbKOqXygdLk+Be+6DHU33s7PYm030UqupvZvY7FH8QSAo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779506149; c=relaxed/simple;
	bh=D+UkudCfbAhIRCNNmJa6F6v25jKthQbVJqDrxKwzIUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WGY4mRp+SEGC9EpfjPkPgrllf1JR+G7UP/7wNlm5jvKqyEAp9U04t5bcFWChvBnPyLBBX4ilDYTPYhQHlmyf4brFiGjTnobPW/FkgbOI7Prs3NAmy222juCvYGRdqV/5eIKOTJtEtOWUwwlriRFJLJU/fYnAROWX6gLKgqCoig4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dHFlEtI0; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dHFlEtI0"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64N39WwS2601827;
	Sat, 23 May 2026 03:15:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=lfSRTPCyUWXbqWg/cnk5ooGegN5lcBDcvuFM9cOvFGg=; b=
	dHFlEtI09GkyesbH3PQYH7+ov4/kvIGiCkNX/t8GFsp3/iHLlZaFUooKZP/oCz78
	e/i1RJWK8QU1dyCi5e+PEzK2J0UPmRwexCHQvP8IwieXhCZ7qW5DzoiIiG9bvDcf
	mpP4jm/vk9A4i8Q+QEnPKKcVcSY0tpf+WCa5/qcZ52EpQXEjpJ4KE72FivIB06L0
	4fgNPhqNuVlujwredyVo1n665npjpoSxbeseumVYOsmMZ8gBqb2tMmgRkftcSWGK
	Erntrc7rDX0Q9qSE7MCMpouJc8HR9NxeP7emi78TfLh1pqPxtWACPCQyFfMxg96V
	W693oIIvfm66lVWw6n9rsg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4eb2nb88ka-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 03:15:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64N3F6Sa032434;
	Sat, 23 May 2026 03:15:16 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4eb2p6hsf7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 03:15:16 +0000 (GMT)
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 64N3F9e6032824;
	Sat, 23 May 2026 03:15:16 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4eb2p6hs6k-7;
	Sat, 23 May 2026 03:15:16 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James.Bottomley@HansenPartnership.com, Yihang Li <liyihang9@huawei.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, liyihang9@h-partners.com, liuyonglong@huawei.com,
        prime.zeng@hisilicon.com
Subject: Re: [PATCH v2] scsi: hisi_sas: Add slave_destroy interface for v3 hw
Date: Fri, 22 May 2026 23:14:21 -0400
Message-ID: <177913641785.1181900.12141785729910228752.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260425082056.2749910-1-liyihang9@huawei.com>
References: <20260425082056.2749910-1-liyihang9@huawei.com>
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
 definitions=2026-05-23_01,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0 lowpriorityscore=0
 mlxlogscore=639 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2605230029
X-Authority-Analysis: v=2.4 cv=bPcm5v+Z c=1 sm=1 tr=0 ts=6a111bc5 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=8s9zEkiQXfZbc6UabmsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: XCqvrPzr93v277iDMKa9hqz8lmdroRrr
X-Proofpoint-ORIG-GUID: XCqvrPzr93v277iDMKa9hqz8lmdroRrr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIzMDAyOSBTYWx0ZWRfXwIoidE2K6XDX
 rROOo3qcXHolv4MP3N+eR87cLxRCNahHPcBMotfaie6wgy6cdlQD5PNqg6oQCAyNdkiaK3lsVoU
 U+f/VjAg+l+dAodS1e1yiDwqbmEO2wJgoave7p4Z5uMMXxn/nHgW44ndQc5tMpDThT9jjFaYl6e
 KpsO90Ka/GqEgr4qm+Bf+lJhUYfinE9DC1g5Z9VUJuAF9HKe654PqPxcCKgzMUFdwHWSwywc3qr
 FKHzu1H1CW3f1TUr4xBi9KoUqurvRafUNj0zSIKJf9iRPR17nDwa1wNUUg9BBDgwPe8RX+MBfEn
 +2OIO5ZTA7bB2FZLJc3QHv7a7eNVudlkkqSFQhGJbffJqghKNaRGsnkUMYodIgjbglaIRaboEIE
 zhEZ6JyCvNOJvi1C/kLFGc6FBIgFrnqUAXOVsAO0B50IEDlMV7xjBrxoxCRoxmAQ+8i3OOHvT9m
 lJhn7pxaO32o83b6PmQ==

On Sat, 25 Apr 2026 16:20:56 +0800, Yihang Li wrote:

> WARNING is triggered when executing link reset of remote PHY
> and rmmod SAS driver simultaneously. Following is the WARNING log:
> 
> WARNING: CPU: 61 PID: 21818 at drivers/base/core.c:1347 __device_links_no_driver+0xb4/0xc0
>  Call trace:
>   __device_links_no_driver+0xb4/0xc0
>   device_links_driver_cleanup+0xb0/0xfc
>   __device_release_driver+0x198/0x23c
>   device_release_driver+0x38/0x50
>   bus_remove_device+0x130/0x140
>   device_del+0x184/0x434
>   __scsi_remove_device+0x118/0x150
>   scsi_remove_target+0x1bc/0x240
>   sas_rphy_remove+0x90/0x94
>   sas_rphy_delete+0x24/0x3c
>   sas_destruct_devices+0x64/0xa0 [libsas]
>   sas_revalidate_domain+0xe4/0x150 [libsas]
>   process_one_work+0x1e0/0x46c
>   worker_thread+0x15c/0x464
>   kthread+0x160/0x170
>   ret_from_fork+0x10/0x20
>  ---[ end trace 71e059eb58f85d4a ]---
> 
> [...]

Applied to 7.2/scsi-queue, thanks!

[1/1] scsi: hisi_sas: Add slave_destroy interface for v3 hw
      https://git.kernel.org/mkp/scsi/c/67b85a88265d

-- 
Martin K. Petersen
