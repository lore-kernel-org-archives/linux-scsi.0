Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E771C3BC673;
	Mon, 23 Mar 2026 16:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282589; cv=none; b=niSGECb4wjfFuzSmXXZtb+ns+dIr1IOhi3c9PL4Gu35wPo73owboUosjFXk4DulBekI2EQsZ/m6sdiV9FnvEY0v6+JiIES/VbJ5AYesLGa/mmHx/RdX0bMml+x7JB+a/xWnX1nv7IiflBE7guVRDkQFNTNHTdG5UJnuHe9iH7po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282589; c=relaxed/simple;
	bh=Ac47um6VFGboHcVVDqA1Mwa2OWWgTPeJqjiloK+fTBk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iozXcKi8ENcngsvQiY9JThn4wovrgQwPDOCrkp/CSQAQQ9PbGGQK4aNMwkJxmuj8B+8SZN/zu/2U0caxFvE+3XY8cVjhrfQc6dsHw8Y4cEd0gX8AUe4KzdU0f2/8NlilPRDixWhtQAZ0uhb18ywWCSUOCZHzWW7amVM2DjezZaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=YVCpqBx+; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="YVCpqBx+"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62NCnllt506491;
	Mon, 23 Mar 2026 16:16:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=GZKijk
	GxKosNvKg3aUhfv+D+VJnVZA4i8TST5GgRf58=; b=YVCpqBx+RlwFhHYP3U+6cl
	6ZyJOzbZS2PvO5W0ZtSaj4FGRebdqr/ZVClsv2YTH32oD7XsI9pji0KVozFIT5nU
	mwQr1WJ3TanzAKkB9ZlajNoWqADyNoGap6ssnE7u4iAcsXFqA2P0cOLG/DluUjtp
	C/I4V6XGhWlk873gMm6GuEOf/B/ZWHIZQEVkMKWNbxHjXdW6ADclLEZDui213yBK
	DWycPGn8RDp6VvYuqCrTWAGiBWpx9nm6HdelJtit2iiuCm76OxnpatRNYLvm0aQK
	Hu3upXa2O6pyJJ3e0c2vplHHAqDVjaRXmkwaxckeegXKNArSSRJ1GBy2FrolL7uQ
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d1kxq7qf4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 23 Mar 2026 16:16:20 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62NCXUdd026695;
	Mon, 23 Mar 2026 16:16:19 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4d275knysk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 23 Mar 2026 16:16:19 +0000
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62NGFsYH30081718
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Mar 2026 16:15:54 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DA6C758067;
	Mon, 23 Mar 2026 16:16:17 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D70DB5805D;
	Mon, 23 Mar 2026 16:16:16 +0000 (GMT)
Received: from [9.61.243.72] (unknown [9.61.243.72])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 23 Mar 2026 16:16:16 +0000 (GMT)
Message-ID: <4a93583c-47a1-4700-a7bb-da75fbd231dc@linux.ibm.com>
Date: Mon, 23 Mar 2026 12:16:16 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/3] scsi: virtio_scsi: move INIT_WORK calls to
 virtscsi_init
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux.dev, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com, eperezma@redhat.com,
        James.Bottomley@HansenPartnership.com, mjrosato@linux.ibm.com,
        farman@linux.ibm.com, frankja@linux.ibm.com
References: <20260316153341.2062278-1-jdaley@linux.ibm.com>
 <yq14imbkzxr.fsf@ca-mkp.ca.oracle.com>
Content-Language: en-US
From: Joshua Daley <jdaley@linux.ibm.com>
In-Reply-To: <yq14imbkzxr.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xuoNBhgZ4rXF3vDnSjN-8tZ3fCR21xPc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIzMDEyMiBTYWx0ZWRfX3KcPwbgqq1z5
 tPqOyhPBReaBn7yvZE98dPDMDH/FYgvl/CIg2C7zO64NkrbMpYYfB6WYIdlTvkSFOFunIepcekP
 Yw2kZyWd9LHy68lQKcjS2CIzlFeNDe7fk9ocA0TSCc9G5XfsuxMKqAJpRSVOggALZEvCwMv8MdU
 31UaIn5kt0p05CG0HsP+GbbK8rXRPn5TUOEhFU78z3KwtpfGNlJUm75n2W/6VkOFi+6/R5sqTDh
 WKuExVgVGeYnQwecKCDzC6y3kObS0/yQZALIR/JPyYPkVnjVnwUj7VKRI6Ht2hwMJYhV71+cfAr
 QdmOuQKZ3FgmyuJjOo/zni8aJTHkdpkXFT0JdPQcZDNKoskSLFe6cSMOvkLofxOJ2294TVAkZfd
 QWD2Oqbzcm2VwszOEd++OrPg+3MiQf8eFT5y07vCpoxLlJBeFH+ukOJtIoJLnDD38+JLVW9aj+z
 Y7WvbilUS5YwM/ZOV2Q==
X-Authority-Analysis: v=2.4 cv=bLEb4f+Z c=1 sm=1 tr=0 ts=69c16754 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=c92rfblmAAAA:8
 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=byxyWA6WYpdcyn2hWYIA:9 a=QEXdDO2ut3YA:10
 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-GUID: xuoNBhgZ4rXF3vDnSjN-8tZ3fCR21xPc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-23_04,2026-03-23_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 clxscore=1015 phishscore=0 impostorscore=0
 malwarescore=0 lowpriorityscore=0 suspectscore=0 bulkscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603230122

On 3/19/2026 10:19 PM, Martin K. Petersen wrote:
> 
> Hi Joshua!
> 
>> This patch avoids a kernel warning that may occur if a virtio_scsi
>> controller is detached immediately following a disk detach. See the
>> commit message for details. The following are instructions to
>> produce the warning (without the proposed patch).
> 
> A few issues were flagged. Please review:
> 
>    https://sashiko.dev/#/patchset/20260316153341.2062278-1-jdaley%40linux.ibm.com
> 
> Thanks!
> 

Hello,

I've reviewed Sashiko's comments and concluded that this series requires further changes. I will 
prepare a new version. Below are my responses to Sashiko's comments.

Thanks!

---

 From Sashiko:
> 
> commit a1db3f127c8402cd51cacfe63d01f15805153a29
> Author: Joshua Daley <jdaley@linux.ibm.com>
> 
> scsi: virtio_scsi: kick event_list unconditionally
> 
> The event_list processes non-hotplug events (such as LUN capacity
> changes), so remove the conditions that guard the initial kicks in
> _probe() and _restore(), as well as the work cancellation in _remove().
> 
>> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
>> index 0ed8558dad72..982f49bc6c69 100644
>> --- a/drivers/scsi/virtio_scsi.c
>> +++ b/drivers/scsi/virtio_scsi.c
>> @@ -983,9 +983,7 @@ static int virtscsi_probe(struct virtio_device *vdev)
>>  		goto scsi_add_host_failed;
>>  
>>  	virtio_device_ready(vdev);
>> -
>> -	if (virtio_has_feature(vdev, VIRTIO_SCSI_F_HOTPLUG))
>> -		virtscsi_kick_event_all(vscsi);
>> +	virtscsi_kick_event_all(vscsi);
> 
> Does this code violate the virtio-scsi specification?
> 
> The specification mandates that a driver must not place buffers into the
> event virtqueue if neither VIRTIO_SCSI_F_HOTPLUG nor VIRTIO_SCSI_F_CHANGE
> has been negotiated.
> 
> By completely removing the VIRTIO_SCSI_F_HOTPLUG check without expanding it
> to check for VIRTIO_SCSI_F_CHANGE, could this unconditionally populate the
> event queue and cause strict implementations to reject the buffers or
> transition the device into a broken state?
> 

Stefan Hajnoczi <stefanha@redhat.com> addressed this already. "No, this is a hallucination."

>>  	scsi_scan_host(shost);
>>  	return 0;
> [ ... ]
>> @@ -1002,8 +1000,7 @@ static void virtscsi_remove(struct virtio_device *vdev)
>>  	struct Scsi_Host *shost = virtio_scsi_host(vdev);
>>  	struct virtio_scsi *vscsi = shost_priv(shost);
>>  
>> -	if (virtio_has_feature(vdev, VIRTIO_SCSI_F_HOTPLUG))
>> -		virtscsi_cancel_event_work(vscsi);
>> +	virtscsi_cancel_event_work(vscsi);
> 
> Can this introduce a use-after-free race during device removal that breaks
> bisection?
> 
> If a concurrent worker thread executing virtscsi_handle_event() reaches
> virtscsi_kick_event(), it invokes INIT_WORK(&event_node->work, ...).
> INIT_WORK() clears work->data bits to 0.
> 
> If cancel_work_sync() runs concurrently in virtscsi_cancel_event_work(), it
> might read work->data as 0, falsely conclude the work item is idle, and
> return immediately without waiting for the work to complete.
> 
> virtscsi_remove() would then proceed to free the vscsi structure via
> scsi_host_put(), while the worker thread continues and dereferences the now
> freed vscsi->event_vq.vq_lock.
> 
> While this specific race appears to be fixed later in the patch series by
> commit b602884db439 ("scsi: virtio_scsi: move INIT_WORK calls to
> virtscsi_init"), removing the feature guard here exposes all virtio-scsi
> instances to this crash, which might break bisection.
> 

see below

>>  	scsi_remove_host(shost);
>>  	virtscsi_remove_vqs(vdev);
> [ ... ]
>> @@ -1028,9 +1025,7 @@ static int virtscsi_restore(struct virtio_device *vdev)
>>  		return err;
>>  
>>  	virtio_device_ready(vdev);
>> -
>> -	if (virtio_has_feature(vdev, VIRTIO_SCSI_F_HOTPLUG))
>> -		virtscsi_kick_event_all(vscsi);
>> +	virtscsi_kick_event_all(vscsi);
> 
> Could this cause workqueue linked list corruption during suspend and resume?
> 
> When PM suspend begins, freezable workqueues are frozen. Any unhandled event
> from virtscsi_complete_event() leaves its work item queued. virtscsi_freeze()
> tears down virtqueues but does not cancel pending work or set stop_events =
> true.
> 
> Upon resume, virtscsi_restore() unconditionally calls virtscsi_kick_event_all()
> here, which executes INIT_WORK() on all event nodes. Executing INIT_WORK() on
> an actively queued work_struct blindly resets its list pointers, which silently
> corrupts the frozen workqueue's doubly-linked list. This can lead to a kernel
> panic when the workqueue is subsequently thawed.
> 
> Prior to this patch, this issue only affected devices that negotiated
> VIRTIO_SCSI_F_HOTPLUG, but removing the guard exposes every virtio-scsi
> device to this suspend/resume crash.
> 

Both this and the previous review comment are based on the current issue with the INIT_WORK call 
being located in virtscsi_kick_event().

As the Sashiko pointed out, this is addressed later in the series.

Performing this patch first does extend the INIT_WORK issue to devices that do not negotiate 
hotplug, having a somewhat negative effect on bisection. So in that regard it makes sense to reorder 
the patches such that the INIT_WORK call is moved first.

>>  	return err;
>>  }

> commit b602884db439878b4fde9b7b100a2b2263958fdf
> Author: Joshua Daley <jdaley@linux.ibm.com>
> 
> scsi: virtio_scsi: move INIT_WORK calls to virtscsi_init
> 
> The last step of virtscsi_handle_event is to call virtscsi_kick_event,
> which calls INIT_WORK on it's own work item. INIT_WORK resets the
> work item's data bits to 0.
> 
>> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
>> index 982f49bc6c69..15ca2a2d7aa4 100644
>> --- a/drivers/scsi/virtio_scsi.c
>> +++ b/drivers/scsi/virtio_scsi.c
>> @@ -242,7 +242,6 @@ static int virtscsi_kick_event(struct virtio_scsi *vscsi,
>>  	struct scatterlist sg;
>>  	unsigned long flags;
>>  
>> -	INIT_WORK(&event_node->work, virtscsi_handle_event);
>>  	sg_init_one(&sg, event_node->event, sizeof(struct virtio_scsi_event));
>>  
>>  	spin_lock_irqsave(&vscsi->event_vq.vq_lock, flags);
> [ ... ]
>> @@ -898,6 +897,9 @@ static int virtscsi_init(struct virtio_device *vdev,
>>  	virtscsi_config_set(vdev, cdb_size, VIRTIO_SCSI_CDB_SIZE);
>>  	virtscsi_config_set(vdev, sense_size, VIRTIO_SCSI_SENSE_SIZE);
>>  
>> +	for (i = 0; i < VIRTIO_SCSI_EVENT_LEN; i++)
>> +		INIT_WORK(&vscsi->event_list[i].work, virtscsi_handle_event);
> 
> Can this code corrupt the workqueue's linked list during system resume?
> 
> Event works are queued on system_freezable_wq in virtscsi_complete_event():
> 
> virtscsi_complete_event() {
> 	...
> 	if (!vscsi->stop_events)
> 		queue_work(system_freezable_wq, &event_node->work);
> }
> 
> During system suspend, virtscsi_freeze() resets the virtio device but does
> not cancel pending event works, as it lacks a call to
> virtscsi_cancel_event_work(). Because the workqueue is freezable, pending
> works remain actively linked in the workqueue's internal pending list.
> 
> Upon system resume, virtscsi_restore() runs and calls virtscsi_init(),
> which unconditionally executes this INIT_WORK() during resume:
> 
> virtscsi_restore() -> virtscsi_init() {
> 	...
> 	for (i = 0; i < VIRTIO_SCSI_EVENT_LEN; i++)
> 		INIT_WORK(&vscsi->event_list[i].work, virtscsi_handle_event);
> }
> 
> Calling INIT_WORK() on a work item that is actively linked in a workqueue
> executes INIT_LIST_HEAD(&work->entry), overwriting its list pointers while
> adjacent workqueue list elements still point to it. This can result in a
> corrupted workqueue linked list when the workqueue is thawed.

This appears to be a valid concern.

INIT_WORK need only be called on the event nodes ONCE in the lifetime of the device, it should not 
be recalled on resume, especially since work may remain frozen in the workqueue and have its data 
corrupted by this call.

Lets move the calls to virtscsi_probe() instead of virtscsi_init().
