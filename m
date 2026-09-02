Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5769388E6F;
	Wed,  2 Sep 2026 20:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788380946; cv=none; b=ei4LNqd26AWjMmF2E83wxbfxNJWqt3y+Nnk2+IiDVEgm7dzGzRNABMQxkFToIA2XxN8JqdQ3RlekmApxKc9SKW6t50XGL0MArXk+XhFUpW1PJNi1j5YPrcp2pWhoZzXJhZR33thPHAk+Qz02foWVbnaOpuX8k2dvOBIlH0/DDfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788380946; c=relaxed/simple;
	bh=GYsSWGNbF/bfcdlErn3oiNNvvnmJ0vS0+jKODtxyp7E=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=PBEPmhRRAnolwg63LZm546zzKo8vZU9eKkZHFtrSEL/1S5GMaacgPs6KqT4vbb5V9Mo1ee0MKEEGYtgZ8ORpj31UXYFxjTHlcYk8A0r3TGijSCs7ShqoGqsalbpFvxArq08BLigh/yjxc9D1c4NNaEasLlSDQHOoyND6coGoT3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ZZKlc6FQ; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ZZKlc6FQ"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 682I1k1C607698;
	Wed, 2 Sep 2026 20:29:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=bQvV3fX8kzsGZh3s1468/I5/2DdnTQ
	a8LB6Sjq6Ve08=; b=ZZKlc6FQukvOSRSVLwxLIIra8sPFyJ8+yXU50QBZrmPIHB
	qJCiKt9Z7TB5YEORqQwsZ5CxQSPn8zzgAzqPqTHUQJBjd9mBSUGYDnzRh5Q/B6UP
	HSjfJDpo+2ZjhNUCWuLsDJ0A6E/AHvAZN89oaQhuQStWbMI+MmPDmvV6byTzCZN6
	VZw7X1QqJWiZpXsdeEgv/RL3893HF0BwiwSiz7sWCqYVNmxlZd0duQO91bMzK4me
	PJy7dAUTBfqcAi02VmCAg1mLs30AWHiiR/2p1PNLI/seKq1wP0rn75XF1KjuWjWH
	szMMGhcC4kdclvzSGsWMmBDW/B3JZzTVvaTeLxjA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gbmuj15bg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 02 Sep 2026 20:29:03 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 682KQeE8025329;
	Wed, 2 Sep 2026 20:29:02 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gcceyc1kv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 02 Sep 2026 20:29:02 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 682KT1A529164148
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 2 Sep 2026 20:29:01 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CD2FA5803F;
	Wed,  2 Sep 2026 20:29:01 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 99CAA58054;
	Wed,  2 Sep 2026 20:29:01 +0000 (GMT)
Received: from d (unknown [9.61.186.94])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTPS;
	Wed,  2 Sep 2026 20:29:01 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
Subject: Re: [PATCH v7 1/8] scsi: ibmvfc: add basic FPIN support
In-Reply-To: <20260831213004.085A21F000E9@smtp.kernel.org>
References: <20260831-ibmvfc-fpin-support-v7-0-77d0b9809080@linux.ibm.com>
	<20260831-ibmvfc-fpin-support-v7-1-77d0b9809080@linux.ibm.com>
	<20260831213004.085A21F000E9@smtp.kernel.org>
Date: Wed, 02 Sep 2026 15:29:00 -0500
Message-ID: <87ld9j1joz.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Vyj4DqEg9yPppTYDCPcjL_aCP2a9Kk8w
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAyMDE3NyBTYWx0ZWRfX//yVkTAT6Lr4
 j/iBv8KxPiwO0QUBI9EBj5NawY0Zwoq6kE9ZpoQhaNbgZdmjqUwnn7Q+/MjAUrE0yr8yvYy5XqJ
 kLBjZn4jqN/tAvx3ct/omFQ09ySYJuveOsVPIuzql8b0/wyTGg4U310AU4f5YLbn6B7GFTO3bQ7
 bdmDOtZck6q0NcRxCyYF2kisHhM5TvWEhqfInXkc9bnSplnRqFon8TY/bSR1+6FnGBqlhTlXk4S
 SRcmSQPH8Ofr5MfE/hrHi3uFb+nhr134oQ7k+oJY9Tsetr6PgdbB/NUPo+T49zvJY8OaVgu99Y8
 PrsVm52kUAV1iuSR5aicijOOSQZYYNiMjyYfvEF0Cir0XNlKi/j9ZFS6M7irB0qviktcz2AtZDa
 B0j2Lgd+wYIWcD25QeKcBpCIfAWJcTO28q6gEXN4SSZ3LdMZnfgJ/0ALJ+zWnqOvN2ZGos3QSmr
 CuKlxaJIc84qDxBGAUA==
X-Authority-Analysis: v=2.4 cv=Osl/DS/t c=1 sm=1 tr=0 ts=6a98870f cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=yFWVqRbnEUxo6LrtKUYA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAyMDE3NyBTYWx0ZWRfX3p7FC7bdBk5w
 cCAq3laxFt42NyAEQrzX+iuyAAxLY4EtvWI5Oa+P9zzwspd50r5TvpSHQnQSzrKePWwD4xJczyL
 MGhIWlMHQUy7mOmXoPZpsJOhchLz7hI=
X-Proofpoint-ORIG-GUID: Vyj4DqEg9yPppTYDCPcjL_aCP2a9Kk8w
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-02_04,2026-09-02_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 suspectscore=0 bulkscore=0 lowpriorityscore=0
 adultscore=0 impostorscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609020177

sashiko-bot@kernel.org writes:

> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [High] Teardown ordering race allows FPIN works to execute on an unregistered `fc_host`.
> - [Medium] Lockless traversal of global `ibmvfc_head` list in KUnit test risks use-after-free.
> - [Medium] The KUnit test accesses `tgt->rport` outside of the `host_lock`.
> --
>
> commit 6a259111a28ef932ad14496cabbef71084312dfe
> Author: Dave Marquardt <davemarq@linux.ibm.com>
>
> scsi: ibmvfc: add basic FPIN support
>
> Implement support for a basic level of Fabric Performance Impact
> Notifications (FPIN) in the ibmvfc driver to enable monitoring of
> fabric congestion and link integrity events. Offloads FPIN processing
> to a dedicated workqueue and adds a KUnit test module for validation.
>
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> index b3bc3ce872d6d..78be00d31a064 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> [ ... ]
>> @@ -6962,6 +7231,8 @@ static void ibmvfc_remove(struct vio_dev *vdev)
>>  	ibmvfc_complete_purge(&purge);
>>  	ibmvfc_release_sub_crqs(vhost);
>>  	ibmvfc_release_crq_queue(vhost);
>> +	destroy_workqueue(vhost->fpin_workq);
>> +	vhost->fpin_workq = NULL;
>>  
>>  	ibmvfc_free_mem(vhost);
>>  	spin_lock(&ibmvfc_driver_lock);
>
> [Severity: High]
> Could this teardown ordering race cause a regression by allowing FPIN works to
> execute on an unregistered fc_host?
>
> Earlier in ibmvfc_remove(), fc_remove_host() is called which destroys
> fc_host->work_q and sets it to NULL. This happens before disabling FPIN
> interrupts via ibmvfc_release_sub_crqs() and ibmvfc_release_crq_queue(), and
> before destroying the new fpin_workq here.
>
> If an FPIN interrupt arrives concurrently before the queues are released,
> it can queue a work item to fpin_workq. When that work executes
> fc_host_fpin_rcv(), it calls fc_queue_event(). Because scsi_remove_host() has
> not yet executed to clear state_in_sysfs, fc_queue_event() may attempt to
> queue work to the already destroyed fc_host->work_q via queue_work(NULL, ...),
> resulting in a kernel crash.

Yes, this is a problem. I plan to solve this by moving the calls to
fc_remove_host() and scsi_remove_host() to just after the call to
ibmvfc_release_crq_queue().

-Dave
