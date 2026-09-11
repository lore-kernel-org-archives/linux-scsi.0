Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86CB449E12E;
	Fri, 11 Sep 2026 00:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789087592; cv=none; b=SBT+KQB4lOjGot+N4f3U5iKCriXZNVoGlGSAiqnWvoM4iucku9zqpTDQ1tHLzhODZ9xaoimIBfatFOpU0zuO+XszaFD5tPUpPPsu9sMAnTuFLe9FWIGfgOJoEvudSh5F4e3uH65rEY+ObuFyvAf/nBj8eiBrBXnZzBBcFg0DonU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789087592; c=relaxed/simple;
	bh=Wn49dzqiPhq2tHgc+bHw8nR0+C6KvQqRtDQF9AgFZxo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d57EMcTQl7mtiYHryXn2iYSuyOI3QzOAEVH1ED3X51aL7WRlq+aYBm14T9B4BiujZN/e7z0CcG1q3uNA/CRrsCtTRG8BsWuvBn1HrOS60QKY81S0hQQuYztwv5X6sGAHpt4Yn0rIyuMyQW1AzpcVtOX9SgMdeuK7syIaxm3AUwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ZyGIhGor; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ZyGIhGor"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68ALVYMK4107093;
	Fri, 11 Sep 2026 00:46:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=hNgini
	MbT8YWyUzF7euU1xLlBvGDL6S11xecgkHQ8Hk=; b=ZyGIhGorSJ+qdTT32uDJh8
	JLO2BK4YOlBAhrQgEFTvbqQIrLn4v59Fjlwfr2Lie26lE92o6amrMzGEEL9Qbsy/
	e6OfC9PavkpMmwaOR9umrGq2KgKmhtUF475RD1h7p7jQ9Okf8IMY4GLAB0t1bblA
	/tP0wYcVsSKEReJdj2iuBqQ8U3Aa/HlLk21u/d9cTEx5F5bx7ACFSgDwUVfcuiPN
	CtQeOc36nPEyCFChINzuvYaONP+AI9QYjpxTMm7DqyyRyCaRwCTJmyVYokboqxmm
	chpgy9V81XCr++jOBbmD04Dx1I3rckQeaDoJiRMevdfDr7BvYAXP+gQU4ofDsVcA
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gkd8t0cuc-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 00:46:27 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68ALYw1e661933;
	Fri, 11 Sep 2026 00:46:27 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gkvnrkhwn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 00:46:27 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68B0kQW89175682
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Sep 2026 00:46:26 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 295B758063;
	Fri, 11 Sep 2026 00:46:26 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D7BA95803F;
	Fri, 11 Sep 2026 00:46:25 +0000 (GMT)
Received: from [9.61.103.123] (unknown [9.61.103.123])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 11 Sep 2026 00:46:25 +0000 (GMT)
Message-ID: <73526f68-6487-4f08-ae68-9321642c6b5e@linux.ibm.com>
Date: Thu, 10 Sep 2026 17:46:25 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 1/9] scsi: ibmvfc: add basic FPIN support
To: sashiko-reviews@lists.linux.dev, Dave Marquardt <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
References: <20260909-ibmvfc-fpin-support-v8-0-b27183b055af@linux.ibm.com>
 <20260909-ibmvfc-fpin-support-v8-1-b27183b055af@linux.ibm.com>
 <20260909192921.842681F000FF@smtp.kernel.org>
Content-Language: en-US
From: Tyrel Datwyler <tyreld@linux.ibm.com>
In-Reply-To: <20260909192921.842681F000FF@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTExMDAwNiBTYWx0ZWRfX2SVejNLh3yl4
 IYFJU4zMpn3OnfPFUmlxawuTZSs8dvN9w1sZue+PdxgKpRCfUTL9RSpPm/iZkmnQL0KRWAu9LX8
 wAM8cQpmvdl3K+bek4jUj+C3B4Ppalg=
X-Proofpoint-ORIG-GUID: YxMyU3xUrjrwJaBQFDlIt62d1zjVWaBw
X-Proofpoint-GUID: YxMyU3xUrjrwJaBQFDlIt62d1zjVWaBw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTExMDAwNiBTYWx0ZWRfXwOAyudgZpLP2
 W2eOdDCbhqThY78rTP9/LGqSX6+62Qpke8jT+6/rgFmBv1y5AaEzQRw4V+UPHrbs9l01JVJfupl
 7c3bwS+AAu6TB+Ni7xRcmLB+JYp0fFUyNXo1aazEwlIztzIoIikt+Un44AIAhgYaNqji2NG8qri
 UjRPNZYWOJL6U9xe9mxloNCg8f6Qt+v+ybs/AT9UKICpAEvLHHpkb3yenx+FU5gEQPA5+XvGB/N
 CNqYs3MZBdoE7vlCjkMM4Ly0wnzjedyPLxebtu/N8+WY3+hJXBNfibc3v3j5e9dbsNJUB8Zaanz
 jfFwRTZPGqqrUuek5lw10kvCcahu1zeN4Mmr0K8wuzOUuPPXBMHQohsogvqittBahLvsid++6UC
 YU4oDPGFS7bDBTf9OrDayvp2ASKZN++Gjjz9Lbvwmy366c+a+wpg5x1oj86gBYdYvJzH/i7pWCO
 /0ImsiFpbI5mQ3AkZXg==
X-Authority-Analysis: v=2.4 cv=PIGaavqC c=1 sm=1 tr=0 ts=6aa34f63 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=fjlTSyrWkZEg5QtQpkIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_07,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 bulkscore=0 adultscore=0 suspectscore=0
 lowpriorityscore=0 impostorscore=0 clxscore=1015 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609110006

On 9/9/26 12:29 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [High] Reordering `scsi_remove_host()` to execute after `ibmvfc_release_crq_queue()` causes a reliable deadlock and an infinite command requeue loop during module removal.
> - [Medium] NVMe over FC targets will not process FPIN events because they are incorrectly filtered out by `ibmvfc_find_target`.
> - [Medium] Missing `put_device()` and `scsi_host_put()` in the KUnit test `ibmvfc_async_fpin_test` causes resource leaks.
> --
> 
> commit bba4f1f01d900a3f01556bca91e5e90f72a7c959
> Author: Dave Marquardt <davemarq@linux.ibm.com>
> Subject: scsi: ibmvfc: add basic FPIN support
> 
> This commit implements support for a basic level of Fabric Performance
> Impact Notifications (FPIN) in the ibmvfc driver. It adds an async event
> handler for IBMVFC_AE_FPIN events that offloads processing to a dedicated
> workqueue, along with FPIN conversion routines and a KUnit test module.
> 
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> index b3bc3ce872d6d..0dde8dcf43de3 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> 
> [ ... ]
> 
>> @@ -3261,16 +3266,259 @@ static const char *ibmvfc_get_link_state(enum ibmvfc_ae_link_state state)
>> +static struct ibmvfc_target *ibmvfc_find_target(struct list_head *target_list,
>> +						__be64 scsi_id, __be64 wwpn,
>> +						__be64 node_name)
>> +{
>> +	struct ibmvfc_target *tgt;
>> +
>> +	list_for_each_entry(tgt, target_list, queue) {
>> +		if (scsi_id && cpu_to_be64(tgt->scsi_id) != scsi_id)
>> +			continue;
>> +		if (wwpn && cpu_to_be64(tgt->ids.port_name) != wwpn)
>> +			continue;
>> +		if (node_name && cpu_to_be64(tgt->ids.node_name) != node_name)
>> +			continue;
>> +		if (!tgt->rport)
>> +			continue;

This should be (!tgt->rport || !tgt->nvme_remote_port)>
> [Severity: Medium]
> Does this check unintentionally filter out NVMe over FC targets?
> 
> Since NVMe targets populate tgt->nvme_remote_port instead of tgt->rport,
> this check forces ibmvfc_find_target() to always skip them.
> 
>> +		return tgt;
>> +	}
>> +
>> +	return NULL;
>> +}
>> +
>> +/**
>> + * ibmvfc_process_async_work - Process IBMVFC_AE_FPIN async CRQ from work queue
>> + * @work: pointer to work_struct
>> + */
>> +static void ibmvfc_process_async_work(struct work_struct *work)
>> +{
> 
> [ ... ]
> 
>> +	spin_lock_irqsave(vhost->host->host_lock, flags);
>> +	tgt = ibmvfc_find_target(&vhost->scsi_scrqs.targets, crq->scsi_id,
>> +				 crq->wwpn, crq->node_name);
>> +	if (!tgt) {
>> +		/* Target not found in scsi_scrqs, search nvme_scrqs */
>> +		tgt = ibmvfc_find_target(&vhost->nvme_scrqs.targets,
>> +					 crq->scsi_id, crq->wwpn,
>> +					 crq->node_name);
>> +	}
> 
> [Severity: Medium]
> Because of the rport check in ibmvfc_find_target() mentioned above, won't
> this fallback search for NVMe targets always return NULL?
> 
> This appears to be dead code that will cause Fabric Performance Impact
> Notifications for NVMe over FC targets to be silently dropped.

See the change above.
> 
> [ ... ]
> 
>> @@ -6952,8 +7221,6 @@ static void ibmvfc_remove(struct vio_dev *vdev)
>>  	ibmvfc_wait_while_resetting(vhost);
>>  	kthread_stop(vhost->work_thread);
>>  	flush_work(&vhost->rport_add_work_q);
>> -	fc_remove_host(vhost->host);
>> -	scsi_remove_host(vhost->host);
>>  
>>  	spin_lock_irqsave(vhost->host->host_lock, flags);
>>  	ibmvfc_purge_requests(vhost, DID_ERROR);
>> @@ -6962,6 +7229,10 @@ static void ibmvfc_remove(struct vio_dev *vdev)
>>  	ibmvfc_complete_purge(&purge);
>>  	ibmvfc_release_sub_crqs(vhost);
>>  	ibmvfc_release_crq_queue(vhost);
>> +	destroy_workqueue(vhost->fpin_workq);
>> +	vhost->fpin_workq = NULL;
>> +	fc_remove_host(vhost->host);
>> +	scsi_remove_host(vhost->host);
> 
> [Severity: High]
> Can this reordering of scsi_remove_host() cause an infinite stall during
> module removal?
> 
> By the time scsi_remove_host() is called here, ibmvfc_release_crq_queue()
> has already run, overwriting the host state to IBMVFC_NO_CRQ. When the
> SCSI midlayer attempts to flush devices during removal,
> ibmvfc_host_chkready() will return DID_REQUEUE. The midlayer will retry
> the command repeatedly, leading to a deadlock since the hardware
> communication queues are already gone.
> 

Yeah, this is wrong. There is a reason that xxx_remove_host() calls were ahead
of the rest of the driver cleanup. The destroy_workqueue() call should have just
been moved ahead of those calls.

Seeing as Dave is now on vacation and I've already Acked the rest of the series
I'll send a v9 for this particular patch seeing as the rest of the series
depends on it.

-Tyrel
