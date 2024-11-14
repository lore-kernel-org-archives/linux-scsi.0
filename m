Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF71B1F76D6
	for <linux-scsi@vger.kernel.org>; Thu, 14 Nov 2024 02:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731552684; cv=none; b=Uof2TaMzNR6ceXpjGqeZvberhd6QBCZ9223CzGduDd454a8XAX9pUhJrMy9ftDGk90c7gAO9EwtY1gqjTcnCOFajISEZJ4D8lRi0nsI00qNUQUVKdhReWZEzgQ8fXmF1LIzxS7eeC/f1MsJC3JF1mVQMlyedMksDsttg3vXf9rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731552684; c=relaxed/simple;
	bh=Xfh/62SG62fAGHV6/8KwPcnLhd8cDPwPbzS01iF8Dhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DbeFsi1C3b6NYl5+nmWsriOFSir0g9B2z+WLARs+aZpy7FY8TKivaPdBuUFWngLcxhzQNlIkvQu8od+4YlfxoM9dkncT5VxL4ASW0pUq/xnQbz+6jhFPIm9FqzhMlRImXPhtw/Ou/2gaAyN/FZJLPGaetgpEfaWOKAmpm6VSyFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Jh+oHnOs; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Jh+oHnOs"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AE1gZkw002835;
	Thu, 14 Nov 2024 02:51:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=vQQ6yYcCBuGoOUbgaI7fMs/P7KwlSVUjzjbhZO9M7DA=; b=
	Jh+oHnOs4h6pw5Eg9ygW3YKKd0L51Uxyb36EzVmcOP/pqjwZLOq6qmD3ENAbjPc0
	/ggfclwLf2GG5/GcZEfPvdwAeXjZbzvurAJOXENJVRaQVgWTb/n0mJyOfylAveU5
	ce8OuY7xO5f8mounYfFHVLzYGzIY8czup6c0oefo0QQgMXZMG7gE/EmTfLmUOSGU
	9lJTWy+BpVWtI9YSV26JENlX5/7yKLjEsn1BnBOO9cqLy5W/r7rU5gHg1C9HM7Yr
	Sl8luxlRmy6rlrdD53G+y2wLD8qnVAWi/qZxkQslZd30dB4sc/ot0hPTh2j3ZMrL
	Kn5neJdJHc7zvsx32d7N5g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0k5g4eu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Nov 2024 02:51:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AE1RWS7022894;
	Thu, 14 Nov 2024 02:51:01 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42vuw0p25b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Nov 2024 02:51:01 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4AE2ojZA003527;
	Thu, 14 Nov 2024 02:51:01 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 42vuw0p1vg-14;
	Thu, 14 Nov 2024 02:51:01 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
        Ye Bin <yebin@huaweicloud.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        anil.gurumurthy@qlogic.com, sudarsana.kalluru@qlogic.com,
        zhangxiaoxu5@huawei.com
Subject: Re: [PATCH] scsi: bfa: fix use-after-free in bfad_im_module_exit()
Date: Wed, 13 Nov 2024 21:50:07 -0500
Message-ID: <173155154795.970810.6890942220297040127.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241023011809.63466-1-yebin@huaweicloud.com>
References: <20241023011809.63466-1-yebin@huaweicloud.com>
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
 definitions=2024-11-14_01,2024-11-13_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411140021
X-Proofpoint-ORIG-GUID: VLSMaXgCYtQdyiuMuAIsfMX5vJVQhDoI
X-Proofpoint-GUID: VLSMaXgCYtQdyiuMuAIsfMX5vJVQhDoI

On Wed, 23 Oct 2024 09:18:09 +0800, Ye Bin wrote:

> There's issue as follows:
> BUG: KASAN: slab-use-after-free in __lock_acquire+0x2aca/0x3a20
> Read of size 8 at addr ffff8881082d80c8 by task modprobe/25303
> 
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x95/0xe0
>  print_report+0xcb/0x620
>  kasan_report+0xbd/0xf0
>  __lock_acquire+0x2aca/0x3a20
>  lock_acquire+0x19b/0x520
>  _raw_spin_lock+0x2b/0x40
>  attribute_container_unregister+0x30/0x160
>  fc_release_transport+0x19/0x90 [scsi_transport_fc]
>  bfad_im_module_exit+0x23/0x60 [bfa]
>  bfad_init+0xdb/0xff0 [bfa]
>  do_one_initcall+0xdc/0x550
>  do_init_module+0x22d/0x6b0
>  load_module+0x4e96/0x5ff0
>  init_module_from_file+0xcd/0x130
>  idempotent_init_module+0x330/0x620
>  __x64_sys_finit_module+0xb3/0x110
>  do_syscall_64+0xc1/0x1d0
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>  </TASK>
> 
> [...]

Applied to 6.13/scsi-queue, thanks!

[1/1] scsi: bfa: fix use-after-free in bfad_im_module_exit()
      https://git.kernel.org/mkp/scsi/c/178b8f38932d

-- 
Martin K. Petersen	Oracle Linux Engineering
