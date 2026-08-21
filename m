Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8711A3B71BC;
	Fri, 21 Aug 2026 15:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787324951; cv=none; b=XTYu8LwinMuJDiR0JAUUZrZNaw+S2pb7Pbj00oUnQ188GSRhb2OQ/vgmWnOgYuIFQ4Kk7hkeItDxC2E15+UzNxf7RfnU0l8pURFHW5NmMxZ2bgBvvocaLgRQ9yPViMlFwKIf2rIleCGfZrWz2klf5xWVVLKlcX0Zw1z3PMErWbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787324951; c=relaxed/simple;
	bh=2M0sknvFBcnZobC8fknQgyBYV+vCNtMtJIfgIdku1EE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=UCtNlkHg+M8eXFqYNDN1t5W93ZQl0bO4kxXS3jbCpMOdsI6aGcXQuRUF3PN25w7sqf/Xiet2d5TI4gzaGIyfHaifTM/D/1ak/tRiWnrg9tKHKH9gqskzaD+aUQZl537Ij3/+EIxxQOLwrRsyA7smGLm8ZPVjE0qdL0ZM/i4mKxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=kcKQE9kx; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="kcKQE9kx"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67LD1shN1473086;
	Fri, 21 Aug 2026 15:09:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=D/I8wNCLpiCZiGYR9vdsznNbLCaS3J
	kvPW0Oxgw0BfY=; b=kcKQE9kxl6BFl7jxtrptRgcADVraGdYGqvg5e6RqjUYnDu
	2PQWP3MLJZAPpnflYEvQ0Yc2w5JFGT4ZNJuWrq984xcZTkbYdZ261E/J+riI+Q0H
	+tVZzOlXaSUE6yQpJLgMQdzUDaj+Ems2aBCBBA+FYn7L1jIPzEsq2aIMEP2rl4y0
	GmQqu3JkRioUHyYgsBGrep1CcEF03sNZdWluc75SJnhQYRy6WGtEixlWfQCayXxu
	1/iph1u1qN9NgvYQ4OdjIGXjGnwyFSLnXpKPtnIz719uvG+I9f6kM18xxmR0Sx7d
	B6tuMUmK3z0vQJhZrCS/5xCZqcMHEGxamyclSxaw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g4yu4j5v5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 Aug 2026 15:09:08 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67LEuStb030715;
	Fri, 21 Aug 2026 15:09:07 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4g33xhna3g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 Aug 2026 15:09:07 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67LF96iR31916782
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Aug 2026 15:09:06 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 86D4258053;
	Fri, 21 Aug 2026 15:09:06 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4F86158059;
	Fri, 21 Aug 2026 15:09:06 +0000 (GMT)
Received: from d (unknown [9.61.29.95])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 21 Aug 2026 15:09:06 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
Subject: Re: [PATCH v6 1/8] scsi: ibmvfc: add basic FPIN support
In-Reply-To: <20260817203721.748DA1F000E9@smtp.kernel.org>
References: <20260817-ibmvfc-fpin-support-v6-0-62a2d525e70d@linux.ibm.com>
	<20260817-ibmvfc-fpin-support-v6-1-62a2d525e70d@linux.ibm.com>
	<20260817203721.748DA1F000E9@smtp.kernel.org>
Date: Fri, 21 Aug 2026 10:09:05 -0500
Message-ID: <87a4qfy0ha.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIxMDExNyBTYWx0ZWRfX8vnQoBDBRHXN
 Z+j1ppr4QzV39vKefOwHVNvD9SpUzFpeBkhqH3H4GyELXyTndLyvYPPF9T1nvDI5whahnNRp8Kh
 S4fD1mNeRHsXM7LoDjJOGtXDZSPPgj8=
X-Proofpoint-GUID: lTRWMZ-BzEBxVyXmNqZ5JSbZuu1_KSig
X-Proofpoint-ORIG-GUID: lTRWMZ-BzEBxVyXmNqZ5JSbZuu1_KSig
X-Authority-Analysis: v=2.4 cv=RPmD2Yi+ c=1 sm=1 tr=0 ts=6a886a14 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8 a=SSEG4e8NmIKCVIdz0EEA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIxMDExNyBTYWx0ZWRfX+MIU/sPZzUcZ
 Simm2LJ5VxL9c8eXbX57bEiY7WHjFG/vLJVE6IV3BA0Z88x6EFBKMmhIUYXPg08XE6UX8cdDRov
 fy/WOe1q1BgI7JuX/zpZw/5qj9InBk2qrK1S8ZQk4fnEyLpcWsUzmLsXHBlaiDFZY9LoSyxrD0N
 sORMI4rVrK+nxprd/PuMdDVEBwwXyKlbAaytXECag5iIDZl0Tb4f+cfEoSU6Ua3Fg0VfNb5jObJ
 YEfjVfFWDYifLgAv8CB6cn9Ny7oSWkPN7ly018Zfz8CmldBr2jD/ZS0ssh+e19aPqp6iV48B0II
 NHY20KspBgP38DVZjXI9cUhDgmcmdOmvNf+eB8hvWSyBjVlmogcgPAssHEZlHXSYXfmjwMlzfPN
 l2m33UI2/nexz2pkLuY6al69tc88v1UEcic+MtRJHLUYlzPEPxhcyBw99w03jZ+iGLYdnIefwm4
 1I/yfVxve8byC+vtk4g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-21_04,2026-08-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 phishscore=0 adultscore=0 spamscore=0 priorityscore=1501
 bulkscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608210117

sashiko-bot@kernel.org writes:

>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> index 93b9f699c2e53..22b4d639e74be 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>
> [ ... ]
>
>> @@ -6945,6 +7213,9 @@ static void ibmvfc_remove(struct vio_dev *vdev)
>>  	ENTER;
>>  	ibmvfc_remove_trace_file(&vhost->host->shost_dev.kobj, &ibmvfc_trace_attr);
>>  
>> +	destroy_workqueue(vhost->fpin_workq);
>> +	vhost->fpin_workq = NULL;
>> +
>
> [Severity: High]
> Is the fpin_workq destroyed too early during driver removal?
>
> If an asynchronous FPIN event arrives from the fabric after this point but
> before the CRQ is torn down in ibmvfc_release_crq_queue() later in the
> function, ibmvfc_handle_async() could be called and attempt to queue work:
>
> ibmvfc_handle_async()
>     ...
>     queue_work(vhost->fpin_workq, &aw->async_work_s);
>
> Could this result in a NULL pointer dereference?

Yes, this is a problem. I've fixed it for v7.

>>  	spin_lock_irqsave(vhost->host->host_lock, flags);
>>  	ibmvfc_link_down(vhost, IBMVFC_HOST_OFFLINE);
>>  	spin_unlock_irqrestore(vhost->host->host_lock, flags);
>
> [ ... ]
>
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
>> new file mode 100644
>> index 0000000000000..64a517a74af8e
>> --- /dev/null
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
>
> [ ... ]
>
>> +static void ibmvfc_async_fpin_test(struct kunit *test)
>> +{
>> +	u64 post[IBMVFC_AE_FPIN_CONGESTION_CLEARED + 1];
>> +	u64 pre[IBMVFC_AE_FPIN_CONGESTION_CLEARED + 1];
>> +	enum ibmvfc_ae_fpin_status fs;
>> +	struct fc_host_attrs *fc_host;
>> +	struct ibmvfc_async_crq crq[IBMVFC_AE_FPIN_CONGESTION_CLEARED + 1];
>> +	struct ibmvfc_target *tgt;
>> +	struct ibmvfc_host *vhost;
>> +	struct list_head *queue;
>> +	struct list_head *headp;
>> +
>> +	headp = ibmvfc_get_headp();
>> +	if (list_empty(headp))
>> +		kunit_skip(test, "No ibmvfc devices available");
>> +	queue = headp->next;
>> +	vhost = container_of_const(queue, struct ibmvfc_host, queue);
>> +
>> +	KUNIT_ASSERT_GE_MSG(test, vhost->scsi_scrqs.num_targets, 1, "No targets");
>> +	tgt = list_first_entry(&vhost->scsi_scrqs.targets, struct ibmvfc_target, queue);
>
> [Severity: Medium]
> Is it safe to iterate over the global ibmvfc_head list and access
> vhost->scsi_scrqs.targets without acquiring the ibmvfc_driver_lock or
> host_lock?
>
> If a device is unbound or a target logs out concurrently while the test
> runs, could the lists mutate and cause an invalid pointer dereference?

I'm not particularly concerned about this. I'm running the KUnit tests
on a quiet system.

>> +	KUNIT_EXPECT_NOT_NULL(test, tgt->rport);
>> +
>> +	fc_host = shost_to_fc_host(vhost->host);
>> +
>> +	pre[IBMVFC_AE_FPIN_LINK_CONGESTED] = READ_ONCE(fc_host->fpin_stats.cn_device_specific);
>> +	pre[IBMVFC_AE_FPIN_PORT_CONGESTED] = READ_ONCE(tgt->rport->fpin_stats.cn);
>
> [Severity: Medium]
> Since KUNIT_EXPECT_NOT_NULL() allows execution to continue on failure, could a
> NULL tgt->rport be immediately dereferenced on the following lines when reading
> tgt->rport->fpin_stats.cn?
>
> Should this use KUNIT_ASSERT_NOT_NULL() instead to abort the test and prevent a
> crash?

Changed to KUNIT_ASSERT_NOT_NULL() in v7.

>> +	pre[IBMVFC_AE_FPIN_PORT_CLEARED] = READ_ONCE(tgt->rport->fpin_stats.cn_clear);
>> +	pre[IBMVFC_AE_FPIN_PORT_DEGRADED] = READ_ONCE(tgt->rport->fpin_stats.li_failure_unknown);
>> +	pre[IBMVFC_AE_FPIN_CONGESTION_CLEARED] = READ_ONCE(fc_host->fpin_stats.cn_clear);
>> +
>> +	for (fs = IBMVFC_AE_FPIN_LINK_CONGESTED; fs <= IBMVFC_AE_FPIN_CONGESTION_CLEARED; fs++) {
>> +		crq[fs].valid = 0x80;
>> +		crq[fs].link_state = IBMVFC_AE_LS_LINK_UP;
>> +		crq[fs].fpin_status = fs;
>> +		crq[fs].event = cpu_to_be64(IBMVFC_AE_FPIN);
>> +		crq[fs].scsi_id = cpu_to_be64(tgt->scsi_id);
>> +		crq[fs].wwpn = cpu_to_be64(tgt->wwpn);
>> +		crq[fs].node_name = cpu_to_be64(tgt->ids.node_name);
>> +		ibmvfc_handle_async(&crq[fs], vhost);
>> +		msleep(1U);
>> +	}
>
> [Severity: Medium]
> Is msleep(1U) a reliable way to wait for the fpin_workq to process the
> offloaded FPIN event?
>
> Under load, it seems like 1 millisecond might be insufficient, causing the test
> to read stale counters and fail intermittently. Would it be safer to use
> flush_workqueue(vhost->fpin_workq) here instead of a hardcoded sleep?

Good idea. I've changed all of the KUnit tests throughout the series to
use flush_workqueue() rather than msleep() in v7.

-Dave
