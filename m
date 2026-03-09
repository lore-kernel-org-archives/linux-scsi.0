Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24AC0349B1B;
	Mon,  9 Mar 2026 21:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773090221; cv=none; b=MIHKtQKu3mV1Aqp+w6QWI8IGmXkyvOFqYoCb30ZQYXEwmIzWdAgFqS+lJwn+VUlXiilmBKUKxKU/GJknRikzOOmML3K1INkqR5VQJAmpqn2+bBcwb7ALRd+ZxGsLCZ8IBc58PZS3otwaihGvTWSS0JEUnPa8851kNgiAwCGt+MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773090221; c=relaxed/simple;
	bh=y8v3Lf4tZ+XMPIXhXOcBuTioKqcpmkK5qnE9DpFuHBM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i+Iy5xhEd+tBszQPwB1LRDMgb6XWkmyJYT0AOegMHOedGWoubh9im1IZMNmUx6g5XbO2uMbcHySvh7+X5gyQkyOyZ9IdwxdLJnQONCd1iuOkpjUUp0BE/B2giFLIGhIuCKcoAZQTfQbANR7nbeFaB1xVquF0E4XraRH7/sXWvnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=VEWHzheP; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="VEWHzheP"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 629EC9ki1342364;
	Mon, 9 Mar 2026 21:03:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=JsmA42
	3ES6yhRhqRaSB7QVKlJUBxa/jr/bdqYCO1F4Q=; b=VEWHzheP/OXP65A5U05l2g
	ur6g166SSWQBxy120r2gW/2FAmL19VnJDxMRhzHI2Bsb0iGHoPb+jxeDe1whWdN+
	+uXNk8j3Yv2r/QUtz0FWVgpU3J1Olxiec0AK2tp4fT67zY8XcM9GMTno6IRNX8q6
	iRKe9YSs48TRGylfdWYjJ5hC1gAyRw6XHnGM9HY+epHdACBuGxJRRc56q+wAHmx6
	WuF2vgvd0rKqcMSWFYyBp2ePpFs74T5ztVSMSaBQ97zjoZNspRkhEmKddTFHd8vG
	jIcDwqsjD6geMqglNxhX6+GXslPqyVOf6PNa7r4rGnMqAnL1KhiuXxDf7UUsiJVw
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4crcvm8enr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Mar 2026 21:03:33 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 629Ib2Kw021521;
	Mon, 9 Mar 2026 21:03:32 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4crxbspptk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Mar 2026 21:03:32 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 629L384D11272796
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 9 Mar 2026 21:03:08 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7C2CA5805A;
	Mon,  9 Mar 2026 21:03:30 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9C62358066;
	Mon,  9 Mar 2026 21:03:29 +0000 (GMT)
Received: from [9.61.243.36] (unknown [9.61.243.36])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  9 Mar 2026 21:03:29 +0000 (GMT)
Message-ID: <55a1fe3d-617f-4ddc-8d71-a8b498eb186f@linux.ibm.com>
Date: Mon, 9 Mar 2026 17:03:28 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] scsi: virtio_scsi: move INIT_WORK calls to
 virtscsi_init
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux.dev, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, eperezma@redhat.com,
        James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        mjrosato@linux.ibm.com, farman@linux.ibm.com, frankja@linux.ibm.com
References: <20260226204345.1904786-1-jdaley@linux.ibm.com>
 <20260226204345.1904786-2-jdaley@linux.ibm.com>
 <20260309030617.GB8611@fedora>
Content-Language: en-US
From: Joshua Daley <jdaley@linux.ibm.com>
In-Reply-To: <20260309030617.GB8611@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wWeUu3ClrgZgppFygrY5feoBh4SzouMD
X-Proofpoint-ORIG-GUID: wWeUu3ClrgZgppFygrY5feoBh4SzouMD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA5MDE4NyBTYWx0ZWRfX8djx/KdBQeeJ
 k0c14AzogNu3zKGJ2UxeiuBED/seiP+X/O4zI8NrnpTYt/GImh8RjNQSVjCGARon7bpMbD4xZmh
 KyAx3A6xcNwfFImTKL7f7m9YM5J0zJk6IyTpa4hS7FvCsOTVH3YriCBYTI/JyfriKAEvbhP3lsA
 +wtm3W6OtHiu5L5B1kDpJ0koqYicSd4lSvYTSr7AaR8zU/SIdQnHz0/t5lj+5j0vp7RUdrbzGcj
 a5C73AOFVtzeb07T3zMoWvTxpQTPrdd/QAEPfPN4weaRROpVXWUMnaD1ah8U88zSeu94FLCiyDR
 BpJZl0lbuFgsJ2J7egJm5K0sReIeJsxIGcprihzcMiiNbJXmQzmfO5C2JVjecA2h+eI4JPCK01x
 +tlnKl4ldYbSbonVCYBkVyx6IDm8RAdpPkvGAk/CzGkRMcPMTC8biebrCgNSaFhAGpFrMdwxnMC
 mIMwqa38SlNT7Q8mGxg==
X-Authority-Analysis: v=2.4 cv=B5q0EetM c=1 sm=1 tr=0 ts=69af35a5 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8
 a=CZWh6ol4fLqJlshxPbMA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-09_06,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 clxscore=1015 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603090187

On 3/8/2026 11:06 PM, Stefan Hajnoczi wrote:
> On Thu, Feb 26, 2026 at 09:43:45PM +0100, Joshua Daley wrote:
>> The last step of virtscsi_handle_event is to call virtscsi_kick_event,
>> which calls INIT_WORK on it's own work item. INIT_WORK resets the
>> work item's data bits to 0.
>>
>> If this occurs while the work item is being flushed by
>> cancel_work_sync, then kernel/workqueue.c/work_offqd_enable triggers a
>> kernel warning, as it expects the "disable" bit to be 1:
>>
>> [   21.450115] workqueue: work disable count underflowed
>> [   21.450117] WARNING: CPU: 1 PID: 56 at kernel/workqueue.c:4328 enable_work+0x10a/0x120
>> ...
>> [   21.450171] Call Trace:
>> [   21.450173]  [<000003db2e5bdc3e>] enable_work+0x10e/0x120
>> [   21.450176] ([<000003db2e5bdc3a>] enable_work+0x10a/0x120)
>> [   21.450178]  [<000003db2e5bdd86>] cancel_work_sync+0x86/0xa0
>> [   21.450181]  [<000003daae97d9e4>] virtscsi_remove+0xb4/0xd0 [virtio_scsi]
>> [   21.450184]  [<000003db2ef3b5ca>] virtio_dev_remove+0x6a/0xd0
>> [   21.450186]  [<000003db2ef9106c>] device_release_driver_internal+0x1ac/0x260
>> [   21.450190]  [<000003db2ef8edc8>] bus_remove_device+0xf8/0x190
>> [   21.450192]  [<000003db2ef88d72>] device_del+0x142/0x340
>> [   21.450194]  [<000003db2ef88fa0>] device_unregister+0x30/0xa0
>> [   21.450196]  [<000003db2ef3b2fa>] unregister_virtio_device+0x2a/0x40
>>
>> This warning may occur if a controller is detached immediately
>> following a disk detach.
>>
>> Move the INIT_WORK call to prevent this. Don't re-init event list
>> work items in virtscsi_kick_event, init them only once in
>> virtscsi_init instead.
>>
>> Signed-off-by: Joshua Daley <jdaley@linux.ibm.com>
>> ---
>>   drivers/scsi/virtio_scsi.c | 6 +++++-
>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
>> index 0ed8558dad72..173092931df6 100644
>> --- a/drivers/scsi/virtio_scsi.c
>> +++ b/drivers/scsi/virtio_scsi.c
>> @@ -242,7 +242,6 @@ static int virtscsi_kick_event(struct virtio_scsi *vscsi,
>>   	struct scatterlist sg;
>>   	unsigned long flags;
>>   
>> -	INIT_WORK(&event_node->work, virtscsi_handle_event);
>>   	sg_init_one(&sg, event_node->event, sizeof(struct virtio_scsi_event));
>>   
>>   	spin_lock_irqsave(&vscsi->event_vq.vq_lock, flags);
>> @@ -898,6 +897,11 @@ static int virtscsi_init(struct virtio_device *vdev,
>>   	virtscsi_config_set(vdev, cdb_size, VIRTIO_SCSI_CDB_SIZE);
>>   	virtscsi_config_set(vdev, sense_size, VIRTIO_SCSI_SENSE_SIZE);
>>   
>> +	if (virtio_has_feature(vdev, VIRTIO_SCSI_F_HOTPLUG)) {
>> +		for (i = 0; i < VIRTIO_SCSI_EVENT_LEN; i++)
>> +			INIT_WORK(&vscsi->event_list[i].work, virtscsi_handle_event);
>> +	}
> 
> The eventq should be populated unconditionally so that non-hotplug
> events are processed even when F_HOTPLUG is not negotiated. For example,
> LUN capacity changes are reported via the VIRTIO_SCSI_T_PARAM_CHANGE
> event. LUN capacity changes depend on F_CHANGE, not F_HOTPLUG.
> 
> There is a related bug here: the other if (virtio_has_feature(vdev,
> VIRTIO_SCSI_F_HOTPLUG)) conditionals in this file need to be revisited
> so that LUN capacity changes are reported even when F_HOTPLUG is not
> negotiated. You can test this bug with QEMU's -device
> virtio-scsi-pci,hotplug=off parameter and the 'block_resize' QEMU
> monitor command.
> 
> Do you want to write a patch or do you want me to send a follow-up?
> 
> Thanks,
> Stefan

I can write a patch. Thanks for your review.

There are 3 other if (virtio_has_feature(vdev, VIRTIO_SCSI_F_HOTPLUG)) conditionals in this file, for:

1. virtscsi_kick_event_all() called in virtscsi_probe()
2. virtscsi_cancel_event_work() called in virtscsi_remove()
3. virtscsi_kick_event_all() called in virtscsi_restore()

Should the eventq be populated truly unconditionally? Then I would just remove the conditions from 
these calls. Or would it be better to just change the conditions to also check the other feature:
if (... || virtio_has_feature(vdev, VIRTIO_SCSI_F_CHANGE))
