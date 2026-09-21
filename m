Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68CE40E8C5;
	Mon, 21 Sep 2026 20:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790022229; cv=none; b=eLOSpPQ7Y0iPdu4e9SUx/nal1m4xjGs7rYJfvhfkfdInLp21GY6yw8rDqC+xWGZqFhS8/BABnNtG0wFiAFTizDVQFV42hj/IaiM/uS1uROFuxjpauA7Ynf5YL4o/+3uZHs8Pnm9vXc9JPFK/Dj5QRBEvRHkQC4cdtuUUszff0Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790022229; c=relaxed/simple;
	bh=z5l8g/fSk/f3xd8J8Gb4NVyrVB7oVYjXbnaxeI/zi6g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fRrhieWIFw08MuZ5HRa53Seunqrb9fG0XnllIbxtcbijSydJRUVg7x31RTSXFmmpSMn7hfb5A5pMUOvc4MOo0TJ+zlPMg3WQQcIWyK2gbEaXm2xQyplnsGtljT3TEq+t5M1lhUOxyTxu2MzasLG3XrlZtBtgvSWWpzj6RZVaEBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=LRFbOXns; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="LRFbOXns"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68LF8NL71869624;
	Mon, 21 Sep 2026 20:23:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=pMYwha
	DBsrTBK1GjqA0mi3g44RZV39kByQYw8JFv+fk=; b=LRFbOXnsr+zns+ogPxagtJ
	TfnPwU+TdT7kQW2AoNU5IJYpjVDmsMSYGX/NJzJJ93A05Bdx+QMfSDTUsc2YcBrr
	gE6OIAiAJ6p8fkdzSoh2WlaMTjzsbD4w/ajAo68Np9X/ii/v/GFJjUmeTc8BQVbo
	nf/sfzIqZLWcOmsAK6AGj/dYXhKPG92ekqRDLq0biZ1AS5v2SzISDLQI1XhnIqb2
	uPkTyFBkqzec+Fy36rLksfslfvGVZx74ki8mX3iFyDDpSNrJBH5/lj+0TtBZJqjT
	fEOMnJFBXFVn33voxRfisisWmiTFT4z8+ZFYjfDvvuiHxTKvAZj+MtsaMOQgqERQ
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gskgs2jxr-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 21 Sep 2026 20:23:46 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68LJI6rr1451425;
	Mon, 21 Sep 2026 20:23:46 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gt67gpvtc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 21 Sep 2026 20:23:46 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68LKNjGH26083902
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 21 Sep 2026 20:23:45 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2099A58054;
	Mon, 21 Sep 2026 20:23:45 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C09C45805A;
	Mon, 21 Sep 2026 20:23:44 +0000 (GMT)
Received: from [9.61.11.58] (unknown [9.61.11.58])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 21 Sep 2026 20:23:44 +0000 (GMT)
Message-ID: <c53d3fa9-3e66-4010-87a4-e9cd61789381@linux.ibm.com>
Date: Mon, 21 Sep 2026 13:23:43 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 1/9] scsi: ibmvfc: add basic FPIN support
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260911054832.1311668-1-tyreld@linux.ibm.com>
 <20260911054832.1311668-2-tyreld@linux.ibm.com>
 <20260911060658.68FDC1F000FF@smtp.kernel.org>
Content-Language: en-US
From: Tyrel Datwyler <tyreld@linux.ibm.com>
In-Reply-To: <20260911060658.68FDC1F000FF@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=V/XoQuni c=1 sm=1 tr=0 ts=6ab19253 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=sCSsoGvkdPsomjlc5osA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: i-WBcODpY6xcarKkSm9ofUnSY1Ler4xK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDI5NCBTYWx0ZWRfXwMuCStUQaXjN
 nxuPbNLCGrPLHAVi5jxstfUQPXZ7LAwZfXP2ih51K7vmyUqN9lqs+zFU9EeCCpMRk4QdkQo/EYU
 NjNaX+joozMiLizykwI6UJJFdtYKi9MPvPlAO/INqpAETwMkJEj5ahO/eMN+rXyaTyC+ysO1E3A
 /x5MbmpuT3VQzoxBUp6CSkkXgpRHQ1XLt6GJk/QE/S1GztzG4LbE1J92bk46mY5AQt1Ckw7dWct
 JLq+M2t+CAPVpMFMR5jvYQ9ii+AUJoDbv2TeNp+o5F645K02vTXe1ST6b8PBgjO+qFZqM6I6vkl
 rJhmYoKTkfSML2KxUklsmEC8guWM/lpGyCwNkKIO11rxW3PrEqt8oQyG+u8Nvo0Oaacd9u+TMmQ
 GgSNfYpH3rbjNWL8yuSj+LPUDqe8wE10Gv5Ti795/fX41E1EIg50cZO/Qr5opS6JNJ0KLa6VC0c
 VMKlN3R2TS0P3HQdmYA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDI5NCBTYWx0ZWRfXwqBQQyKUzwAA
 WIhEHAbx0k7wGaGGfmpGa8DXuVOyjU6hykBazHzwy8BDf0QgVSogNd3DzWSEJVIep4EMoQZY1G8
 VUJiXt/dSyKzH6mgydGL9FMMthe99hI=
X-Proofpoint-GUID: i-WBcODpY6xcarKkSm9ofUnSY1Ler4xK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_05,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 malwarescore=0 clxscore=1015 phishscore=0
 bulkscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609210294

On 9/10/26 11:06 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [Medium] The KUnit test `ibmvfc_async_fpin_test` leaks references to the `Scsi_Host` and the `fc_rport` device on its successful completion path.
> - [Medium] Unordered workqueue allows FPIN events to be processed concurrently, causing data races in FC transport statistics and FPIN event reordering.
> --
> 
> commit 79377784bc96c798354f5b0f5ce5007a8d857d16
> Author: Dave Marquardt <davemarq@linux.ibm.com>
>     
> scsi: ibmvfc: add basic FPIN support
>     
> This commit implements support for a basic level of Fabric Performance Impact
> Notifications (FPIN) in the ibmvfc driver. It adds an async event handler that
> offloads FPIN processing to a dedicated workqueue and passes the converted
> messages to the FC transport layer. A KUnit test module is also introduced to
> validate the FPIN event handling and statistics updates.
> 
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> @@ -3547,6 +3547,56 @@ static void ibmvfc_process_async_work(struct work_struct *work)
> [ ... ]
>> +	if (fpin) {
>> +		fc_host_fpin_rcv(tgt->vhost->host,
>> +				 sizeof(*fpin) + be32_to_cpu(fpin->desc_len),
>> +				 (char *)fpin, 0);
>> +		kfree(fpin);
>> +	} else
>     
> [Severity: Medium]
> Can the lockless modifications to fpin_stats in the FC transport layer here
> cause data races and lost statistic counts?
>     
> Multiple FPIN events arriving rapidly from the adapter are queued to the
> fpin_workq. Because the workqueue is created below as WQ_UNBOUND with
> max_active=0, these events can be processed concurrently.

Makes sense. See response below.
>     
> Furthermore, since FPIN events are stateful (e.g., congestion detected vs
> cleared), could concurrent processing deliver events out of order to the
> midlayer and userspace, leaving the system reflecting an incorrect state?
> 
> [ ... ]
>> @@ -7135,6 +7135,15 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
> [ ... ]
>> +	vhost->fpin_workq = alloc_workqueue("%s-fpin-workq-%u", WQ_UNBOUND, 0,
>> +						 IBMVFC_NAME, shost->host_no);
>     
> [Severity: Medium]
> By setting the max_active parameter to 0, which defaults to 256 concurrent
> execution threads, does this allow the unordered processing that triggers
> the data races mentioned above?

I think max_active should be set to 1 here to enforce ordered processing.

>     
> [ ... ]
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
>> --- /dev/null
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
>> @@ -0,0 +1,148 @@
> [ ... ]
>> +static void ibmvfc_async_fpin_test(struct kunit *test)
>> +{
> [ ... ]
>> +	vhost = ibmvfc_get_first_vhost();
>> +	if (!vhost)
> [ ... ]
>> +	rport = tgt->rport;
>> +	get_device(&rport->dev);
> [ ... ]
>> +	KUNIT_EXPECT_EQ(test, pre[IBMVFC_AE_FPIN_CONGESTION_CLEARED],
>> +			post[IBMVFC_AE_FPIN_CONGESTION_CLEARED]);
>> +
>> +	kref_put(&tgt->kref, ibmvfc_release_tgt);
>> +}
>     
> [Severity: Medium]
> Does this code leak the references to the Scsi_Host and the fc_rport device
> on the successful completion path?
>     
> The setup code earlier in this test acquires references via
> ibmvfc_get_first_vhost (which takes the host reference) and get_device, but
> this success path fails to drop them before returning. This could potentially
> prevent the driver from unloading after running the KUnit test module.
> 

If we are going to bother to take a reference might as well drop it.

-Tyrel

