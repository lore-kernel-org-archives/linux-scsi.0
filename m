Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC76045D91C;
	Thu,  8 Oct 2026 21:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791494653; cv=none; b=A4PjvkQKs+QLfUR00C9SRAOTOFk87p3LsfAY0h3Syyj8uwPeyyIHmjj0KadIwFKOsJ3T3FzJTpioxagUCbDbuwIDuM9T4A4RRGokPXdQj1W5A29S0HM+1KH6UfTgoy4aVyv2S0073MR9uKDDi6MRwVzw14Ui8+Js8uV3Njilq+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791494653; c=relaxed/simple;
	bh=6W4iGxkCF0gpwlQYG+XUTyboEojcoADBsj9oKycUBnw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=QjYsISAv/CAw3S9glaSahpKg1UOekDKEdQEJ6sHx43sXhy7FTyU1zv8qvXoD2kUjI4YEO952EeWKuJQhywBHXqpXwqgLO0IMy3qqpXYiqOne1XlYnJ58D+eCQzJFVAe2rP/gT05PyHKTBDWyMVEes9xAPs1SfwVtHO8heA/dTe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Rf9kDb/v; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Rf9kDb/v"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 698L5jVX2443517;
	Thu, 8 Oct 2026 21:24:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=MC60j0Y1uF9f2RJpcA3iIiMbsmF/Zi
	30qKh6k3dw2PY=; b=Rf9kDb/v3j+jNJcCYHnCDSBgkEH3iSOYDmNNn6ksB8odVS
	QvAky1fl2Yjwhwt2C6xsXL9GTlrrwXkuMvmDqvPxXuza6yWHF3NzhRKT2oR4vBwv
	dNSojyEn8rzeBttitgzHS8vhXE4OtVlisaBwhzwrbLEES6aRqtYo3KCV2stj/4sd
	h2c3kld4nI3LQCZkw06BXWmfN9QTh01FsrUlMNumuST5f1T93ohQHZ9TdVcfGYmw
	t92M6BPTWawx0fUkngi3eOdCxj1vOap0KSD3XP7qrig+Be71EtOS6rd9BklKIHmo
	wC0mFV39Yk+0dszIGts8uinXSSV7H3b7CvZFdSkg==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h5xjvp7xy-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 08 Oct 2026 21:24:05 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 698LHTk34041231;
	Thu, 8 Oct 2026 21:24:04 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4h5s34wyy4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Oct 2026 21:24:04 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 698LO3Jv30802516
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 8 Oct 2026 21:24:04 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B231058055;
	Thu,  8 Oct 2026 21:24:03 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 72B5B58059;
	Thu,  8 Oct 2026 21:24:03 +0000 (GMT)
Received: from d (unknown [9.61.176.143])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTPS;
	Thu,  8 Oct 2026 21:24:03 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: sashiko-bot@kernel.org
Cc: sashiko-reviews@lists.linux.dev, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v13 04/11] scsi: ibmvfc: add basic FPIN support
In-Reply-To: <sashiko-outbox-163317@kernel.org> (sashiko-bot@kernel.org's
	message of "Wed, 07 Oct 2026 19:41:34 +0000")
References: <20261007-ibmvfc-fpin-support-v13-0-b816abfa4fcc@linux.ibm.com>
	<20261007-ibmvfc-fpin-support-v13-4-b816abfa4fcc@linux.ibm.com>
	<sashiko-outbox-163317@kernel.org>
Date: Thu, 08 Oct 2026 16:24:02 -0500
Message-ID: <87ecdznax9.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZqIc4saVMbqaMtOp_36B0-Mp52CGWgIp
X-Proofpoint-ORIG-GUID: ZqIc4saVMbqaMtOp_36B0-Mp52CGWgIp
X-Authority-Analysis: v=2.4 cv=FoOQbGrq c=1 sm=1 tr=0 ts=6ac809f5 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=lJQNxhFVsVgsRN-BCyQA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA4MDA4NCBTYWx0ZWRfX99h1fCeI463g
 8x11qdFmMROCyq1lmWe8ImNC/uPkDhsnnt1cXygITOCLNhu52Jic8EyNDrloTBRE1Zt/tCxpcAv
 5vlUeY6sZxqKYTsCNGlKhtcHNxHDo/I=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA4MDA4NCBTYWx0ZWRfX6O6XWGVFFE2l
 uy9HlQTOyC443yvI6sfzWBLJDntIQR1MApIzQmLRT8Y2mpJKcSrrw2kpZYtiYlMcR1W7KKaghn0
 JVc3c1HwxC16wMz5YiXWlCOCRJJKsZonoGVLZQtqFZ5m54wnFfAocOp6nWjX2/Xx6t9DBMoRVlJ
 aWiCGhoUNn/Z/gOf0e07m04rzRCkr+7WpSixAyGIkExJ4qwT+7eahyDwAkWrmPAAL6/SbyAfp7u
 EIh/sGya56TRhf+5ZLWN3kLZa4JQDaNeALY9wExrl7DyZ12uOVWbGSSyVkXf4DkAhyUxpPrzsvK
 CKxI2M1Fx0KH2BTI54aU9RCrAXjufN0SwdpIAM60ZksAhp/LiTpXmpXhRCqJXQMOeX1SRhdGBfA
 +hnh60Fo1+RCBWKf8aV074FCw/vVcjMC85LsZdHODGNpiZff3tD9q+oKNx3ELmFJCr5xUkaxxq8
 0fYWp3Ox57Lt7zdb1QA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-08_07,2026-10-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0 bulkscore=0
 adultscore=0 priorityscore=1501 spamscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610080084

sashiko-bot@kernel.org writes:

> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] scsi: ibmvfc: NULL pointer dereference in queue_work on FPIN event during remove
> --
>
> commit 03a2b80a223e0071e893709993671bdb91c0e958
> Author: Dave Marquardt <davemarq@linux.ibm.com>
>
> scsi: ibmvfc: add basic FPIN support
>
> Implement support for a basic level of Fabric Performance Impact Notifications
> (FPIN) in the ibmvfc driver to enable monitoring of fabric congestion and link
> integrity events. This adds an async event handler for IBMVFC_AE_FPIN events
> that offloads processing to a dedicated workqueue.
>
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> @@ -3361,11 +3609,25 @@ static void ibmvfc_handle_async(struct ibmvfc_async_crq *crq,
>>  	case IBMVFC_AE_HALT:
>>  		ibmvfc_link_down(vhost, IBMVFC_HALTED);
>>  		break;
>> +	case IBMVFC_AE_FPIN:
>> +		if (vhost->state == IBMVFC_HOST_OFFLINE)
>> +			break;
>> +		aw = kzalloc_obj(*aw, GFP_ATOMIC);
>> +		if (aw) {
>> +			INIT_WORK(&aw->async_work_s, ibmvfc_process_async_work);
>> +			aw->vhost = vhost;
>> +			aw->crq = *crq;
>> +			queue_work(vhost->fpin_workq, &aw->async_work_s);
>
> [Severity: High]
> Does this code risk a NULL pointer dereference or use-after-free during driver
> removal?
>
> During ibmvfc_remove(), vhost->fpin_workq is destroyed and set to NULL before
> the CRQ interrupts are disabled and the tasklet is killed (which occurs later
> in ibmvfc_release_crq_queue()).
>
> If a transport event (IBMVFC_CRQ_XPORT_EVENT) arrives concurrently,
> ibmvfc_handle_crq() unconditionally overwrites vhost->state to IBMVFC_NO_CRQ.
> This erases the IBMVFC_HOST_OFFLINE state set earlier by ibmvfc_remove().
>
> If an IBMVFC_AE_FPIN event is subsequently processed by the still-active
> tasklet, the vhost->state == IBMVFC_HOST_OFFLINE safety check here in
> ibmvfc_handle_async() fails to block it. This causes queue_work() to be
> called with a NULL or already-destroyed fpin_workq pointer.

This problem has been mentioned more than once, and I thought it was
fixed. In thinking about this, I've decided to remove fpin_workq from
struct ibmvfc_host, and queue the work items to a system queue using
schedule_work().

The KUnit tests are another problem, which will be resolved by using
each test using its own work queue rather than the system work queue.

-Dave
