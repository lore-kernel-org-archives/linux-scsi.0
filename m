Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5F05F573
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jan 2024 14:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706018402; cv=none; b=srLCXCJsGBOcWeDxhtxaHVbA6hYYt7s0e6QN1GVlQ4QBN8CA/AVUxaUnf39CegAL4+3HVMkSCKCuZtkNn9bmj6CxFOzUsnfyLX1IFGVUypim5tSA9GsFiHQTiJTKNzMmg6Hb8iOP7B74iKjd94AK5iJPv6cRPkuKDmY7SD/HY1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706018402; c=relaxed/simple;
	bh=eF5kZ7CkOdNZ9/O8kdqY6GKw6sdqhRH2JFGbNPrLTIc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WpFoUq15GUHj0n8xUdIsVKbweRz3kvRGWerie5u8uSwYzCWk/GWX/GxxcdEIR+QJKDrOCg0Xi/29To7/hM5KQRhnniBfdPTd5TFdVrw+wdXurG8BM8XlCBuHi/3wdLwZ7mdH5Ezq77S3mj3JHTxDbdhQrlE70lEUKdpqsA9bKB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com; spf=none smtp.mailfrom=linux.vnet.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=tsoG/LQ2; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.vnet.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="tsoG/LQ2"
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40NDcItf009369;
	Tue, 23 Jan 2024 13:59:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=vPf4dAM8NREw+VjIulbEL9CWeuiP5dmjZu72J/95G0A=;
 b=tsoG/LQ2Dph3/TWS01If30mhU7SoUM3SH2Zr9ZAzi+W2r2jxXeJrTJUCbhFUjy2S28Ev
 yiSMt9xTrYosLaAbqFqkoVWBS9B5lgt+eYKVy37p2w/xcDjTn8GHSvwAKOh6emAT1fgl
 A6Ky0VW5NkIBTdjzEh6NU4MVrv9mMCsobgYCgCCUj4zNR41qSLTBJpwwHFpJAnw4bzFi
 B0jLAqexG6rqZ+6t8DS9/xdsBM3j86QukBq5/pNLHBqeB/gcH7deKGDOOo9GOvhiRfWp
 M+/5snMLejod7gfN3bydUzf1iSFEZTnDv+EqL3ETxM+ITJnIjSA7ImjDtmWfSYxWzcWd 8g== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vtegw8jex-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jan 2024 13:59:57 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40NDeOJM017891;
	Tue, 23 Jan 2024 13:59:56 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vtegw8jeh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jan 2024 13:59:56 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 40NCOuQg025653;
	Tue, 23 Jan 2024 13:59:56 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3vrsgnyf4v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jan 2024 13:59:56 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 40NDxt2c23659250
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jan 2024 13:59:55 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 418BA58059;
	Tue, 23 Jan 2024 13:59:55 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D248858053;
	Tue, 23 Jan 2024 13:59:54 +0000 (GMT)
Received: from [9.10.86.82] (unknown [9.10.86.82])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 23 Jan 2024 13:59:54 +0000 (GMT)
Message-ID: <a6de9328-ef14-4ced-b6ae-0d3be78e68c7@linux.vnet.ibm.com>
Date: Tue, 23 Jan 2024 07:59:54 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: Update max_hw_sectors on rescan
Content-Language: en-US
To: John Garry <john.g.garry@oracle.com>, linux-scsi@vger.kernel.org
Cc: brking@pobox.com, jejb@linux.ibm.com, martin.petersen@oracle.com
References: <20240117213620.132880-1-brking@linux.vnet.ibm.com>
 <5326306f-9515-4153-9ef2-e978e775a27f@oracle.com>
 <62618192-aa11-40e2-97a0-ecc819815d0d@linux.vnet.ibm.com>
 <b8299e31-b3f9-40af-82d6-d347c473600d@oracle.com>
From: Brian King <brking@linux.vnet.ibm.com>
In-Reply-To: <b8299e31-b3f9-40af-82d6-d347c473600d@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: MWqyu9BePU2Lt0W1KAv4UsP-blH8TID1
X-Proofpoint-ORIG-GUID: e4Go2teow-yLWhYNqEWICVh6lA5oZQvT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-23_06,2024-01-23_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 suspectscore=0 clxscore=1015 spamscore=0
 impostorscore=0 mlxscore=0 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401230102

On 1/19/24 3:02 AM, John Garry wrote:
> On 18/01/2024 17:22, Brian King wrote:
>> On 1/18/24 9:44 AM, John Garry wrote:
>>> On 17/01/2024 21:36, Brian King wrote:
>>>> This addresses an issue discovered on ibmvfc LUNs. For this driver,
>>>> max_sectors is negotiated with the VIOS. This gets done at initialization
>>>> time, then LUNs get scanned and things generally work fine. However,
>>>> this attribute can be changed on the VIOS, either due to a sysadmin
>>>> change or potentially a VIOS code level change. If this decreases
>>>> to a smaller value, due to one of these reasons, the next time the
>>>> ibmvfc driver performs an NPIV login, it will only be able to use
>>>> the smaller value. In the case of a VIOS reboot, when the VIOS goes
>>>> down, all paths through that VIOS will go to devloss state. When
>>>> the VIOS comes back up, ibmvfc negotiates max_sectors and will only
>>>> be able to get the smaller value and it will update shost->max_sectors.
>>>
>>> Are you saying that the driver will manually update shost->max_sectors after adding the scsi host? I didn't think that was permitted.
>>
>> That is what happens. The characteristics of the underlying hardware can change across
>> a virtual adapter reset.
> 
> That's unfortunate.
> 
> I don't think that it's a good idea to change shost->max_sectors after adding the scsi host or to add core code to condone doing it. Indeed, there is code there to limit shost->max_sectors from DMA mapping constraints in scsi_add_host() path, which should not be ignored.

Good point. However, this patch only lowers max_hw sectors if shost->max_sectors has since been decreased.

> 
> Would it be possible to initially set shost->max_sectors for this adapter at the lowest anticipated value for that adapter and don't change thereafter?

Different physical backing devices support different ranges of values and the physical backing
device can change dynamically. There is currently no defined way for the client to determine
what the lowest possible value is. The downside to adding such an attribute would be that
we'd then always be limited to an arbitrarily small value, which would limit the performance.

Thanks,

Brian

> 
> Thanks,
> John
> 
>>
>> Thanks,
>>
>> Brian
>>
>>>
>>> Thanks,
>>> John
>>>
>>>> However, when LUNs are scanned, the devloss paths will be found
>>>> and brought back online, still using the old max_hw_sectors. This
>>>> change ensures that max_hw_sectors gets updated.
>>>>
>>>> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
>>>> ---
>>>>    drivers/scsi/scsi_scan.c | 6 +++++-
>>>>    1 file changed, 5 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
>>>> index 44680f65ea14..01f2b38daab3 100644
>>>> --- a/drivers/scsi/scsi_scan.c
>>>> +++ b/drivers/scsi/scsi_scan.c
>>>> @@ -1162,6 +1162,7 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
>>>>        blist_flags_t bflags;
>>>>        int res = SCSI_SCAN_NO_RESPONSE, result_len = 256;
>>>>        struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
>>>> +    struct request_queue *q;
>>>>          /*
>>>>         * The rescan flag is used as an optimization, the first scan of a
>>>> @@ -1182,6 +1183,10 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
>>>>                    *bflagsp = scsi_get_device_flags(sdev,
>>>>                                     sdev->vendor,
>>>>                                     sdev->model);
>>>> +            q = sdev->request_queue;
>>>> +            if (queue_max_hw_sectors(q) > shost->max_sectors)
>>>> +                blk_queue_max_hw_sectors(q, shost->max_sectors);
>>>> +
>>>>                return SCSI_SCAN_LUN_PRESENT;
>>>>            }
>>>>            scsi_device_put(sdev);
>>>> @@ -2006,4 +2011,3 @@ void scsi_forget_host(struct Scsi_Host *shost)
>>>>        }
>>>>        spin_unlock_irqrestore(shost->host_lock, flags);
>>>>    }
>>>> -
>>>
>>
> 
> 

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


