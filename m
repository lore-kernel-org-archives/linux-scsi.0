Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99ED3594A;
	Wed,  4 Mar 2026 18:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772648060; cv=none; b=pth8vBtqFnSEKTeZ1gq0QlG6HeWJIaUSpACA5V5krjjG7jCtaONNByNIQKtbfNCmyR9H917rhaOGjFxB2bBrEVcaQindzqngaBxHgpK7AejGNkUPlNN429YJm6a39mk1HjhpUV/L+JhD5GqFaLVb+coq4Bu8j3eNUiZCcc9NlQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772648060; c=relaxed/simple;
	bh=N0t/81yrJUe5Rx8j5uGDsCVNdplsl+rfxZdcT4DcAwo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CL1QLJi/FTNS8XEL7Xhpi8AmoujQ6LxALG6GzxxPFDulsSDf1L5uNi4KMwl2oDaj+61sMIVa3fRTg4KZdLvSmY/2Y096wwBcoXeGoSbCqcEAhCfJKN+Gy0v45wEPimvCb7ZRPb5BTCLPS9c361N4fSPdfq+gVnw5xd2usOhPmpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=E6kavG2h; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="E6kavG2h"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 624AXUpg1941479;
	Wed, 4 Mar 2026 18:14:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=z95qgG
	9jgMcU2Mk11/ghoYOk/oTcNwfxCeln3bivKbw=; b=E6kavG2hD1c7SvLYFItWgG
	977W7QHE83uMtf5b7DD5luDeWy1n8MC+WzDQLHXc7uzkmO6JLLUaQ7dg0LtSvuMV
	VkslGpNvRHwq390syU6GRRwLlz6NLisyYS0BQmX6i6c3GzWdRrZRBZx6jTEbqmCU
	ykPBbMAekMT0o3bcvrRDGpoYrpUHi+Jetl1ADm6B4zVI26NdNu3I/edeDmclUs/Q
	USwS8a0FYBRNW7IcPujO5lpAFd00GIk0YWU6yYFSvVy9MwsL1rV2AacUcTxgLj33
	CdNYNXu91woTDsC/SolP83ScfuAcCzbxEFSxHAF7GONVnPwhnruDUSJ8aeMyrs0g
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ckssmr8t1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Mar 2026 18:14:11 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 624FVDtd010284;
	Wed, 4 Mar 2026 18:14:11 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cmc6k7s18-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Mar 2026 18:14:11 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 624IE9sd62587294
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 4 Mar 2026 18:14:10 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A174F5803F;
	Wed,  4 Mar 2026 18:14:09 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 85FE058055;
	Wed,  4 Mar 2026 18:14:08 +0000 (GMT)
Received: from [9.57.45.114] (unknown [9.57.45.114])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  4 Mar 2026 18:14:08 +0000 (GMT)
Message-ID: <c3ce317d-5314-4339-862d-051440df619a@linux.ibm.com>
Date: Wed, 4 Mar 2026 13:14:07 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] scsi: virtio_scsi: move INIT_WORK calls to
 virtscsi_init
To: Eric Farman <farman@linux.ibm.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
        mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
        stefanha@redhat.com, eperezma@redhat.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        mjrosato@linux.ibm.com, frankja@linux.ibm.com
References: <20260226204345.1904786-1-jdaley@linux.ibm.com>
 <20260226204345.1904786-2-jdaley@linux.ibm.com>
 <77b2b44d7101d55151c8e9852ce41783205ed987.camel@linux.ibm.com>
Content-Language: en-US
From: Joshua Daley <jdaley@linux.ibm.com>
In-Reply-To: <77b2b44d7101d55151c8e9852ce41783205ed987.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA0MDE0OCBTYWx0ZWRfX4KpazI42zp4Q
 nvCMLCxG0s7tGjhqmxqKZ4gtV/Z+LkqAJ/BUd0A1hVoPrmVbdIQAyPVbw7mJ7q4oCuB6V8c59Qf
 z4P2t99M0hKhjCric1CW73OS8lRkXs0HC14SKdjaMag/UN5bV7QXdRq33I93ezcG468W12GygV4
 W+cD2l6omwRv2yGN8rCCipiJVUZ3ZL2fynBin50NrJSgXYnNtXbMeb6d7SUKu9gf4MXU1rf5nHN
 FcER47W/r8JNh56WKeV50sg+Wi1loQrN6xWCwrZMSUiGm/glmGIozhGnc764mFsKlMqQwqnUXAl
 aayr3HnWCi1Qe/NqQe9B5FNThIkiHNOgbE/d0O4VgNp3+Qa3OPB8S+RAxQ1VXah4/XACZ0IjhH7
 zyqGJrgz8yXPofv2n6DuyfkDL6sX/NroRaFT/t9/xait9hM+8O4XVdYQcrQ5AfpRb9NeDOrxksN
 TU5Hog3h1LAIBSk+0ig==
X-Proofpoint-ORIG-GUID: UWWdT2tYBCkJBGFJiu7PLn4JWP3ZAbku
X-Proofpoint-GUID: UWWdT2tYBCkJBGFJiu7PLn4JWP3ZAbku
X-Authority-Analysis: v=2.4 cv=AobjHe9P c=1 sm=1 tr=0 ts=69a87673 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8
 a=eS4R6lfaZEnlwP-vdxAA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-04_07,2026-03-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 impostorscore=0 malwarescore=0
 spamscore=0 clxscore=1015 suspectscore=0 adultscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603040148

On 3/3/2026 4:45 PM, Eric Farman wrote:
> On Thu, 2026-02-26 at 21:43 +0100, Joshua Daley wrote:
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
> 
> The fact that the INIT_WORK points to virtscsi_handle_event(), which itself calls
> virtscsi_kick_event() and re-inits the workqueue struct today, does seem odd. Moving this to _init,
> as part of the _probe() process, seems correct to me. One nit below, but FWIW:
> 
> Reviewed-by: Eric Farman <farman@linux.ibm.com>
> Tested-by: Eric Farman <farman@linux.ibm.com>
> 
>> ---
>>   drivers/scsi/virtio_scsi.c | 6 +++++-
>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
>> index 0ed8558dad72..173092931df6 100644
>> --- a/drivers/scsi/virtio_scsi.c
>> +++ b/drivers/scsi/virtio_scsi.c
>> @@ -242,7 +242,6 @@ static int virtscsi_kick_event(struct virtio_scsi *vscsi,
> 
> Just before this hunk is a prototype for virtscsi_handle_event(), since it was previously used in
> this function but defined afterwards. I suspect it can be removed now?
> 

Yes, looks like it can be removed safely. That should probably be done in a separate patch.

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
>> +
>>   	err = 0;
>>   
>>   out:

