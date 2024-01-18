Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0664B29437
	for <linux-scsi@vger.kernel.org>; Thu, 18 Jan 2024 17:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705598536; cv=none; b=KNm8oaNUIbj/D1Vua1Jzecd7x9TnA/AIgo/Lno3tDkEjGEp8OGxEXlxIHbVTP8IjK727u5u2y+oSVHTfbn9O1xgGbD/M7WmweYeJAm7XJC7uILk3fu/+WLZK4dMjrHth4qnHnZLw1blk+Owd/NKh7EWpCF9uUkmzAP/I5xMKJEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705598536; c=relaxed/simple;
	bh=hunrIZdP+PE9Cv3ODciAYsvPfq0Cg1UHxm37KNSbuV0=;
	h=Received:DKIM-Signature:Received:Received:Received:Received:
	 Received:Received:Received:Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-TM-AS-GCONF:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details; b=aakRDWtRja2RvX39Yzi/IspOEoiycE2Fj6QFMIcCBDF1HJPZyUzUz0ScUIgObew+B20/OFSbGT4SuLiv10867ucXyM5F8Spb2swtGnmmj58ZXFd0LRpfuPP9rQhvttl1pySir0sEwwR4EPtYzIRylq3w2Zy6sI2olsAV8Sl1yKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com; spf=none smtp.mailfrom=linux.vnet.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=EQh3j4ot; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.vnet.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="EQh3j4ot"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40IG7Wax015627;
	Thu, 18 Jan 2024 17:22:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=DAuk1ACt/0TihD5mew8Rm8OpVUwzUd0WEQdjIPyKjKk=;
 b=EQh3j4otJ67MLsGYTRiVP46rPYGosDFEPdNXIGDcG3b5yU2v3SR2FtyKzqn4kFvcQttz
 lXLo5RRiP1+Lrtk07Kh+9VLBIujqtVHh0kq2WfGJFzCvxotwIEgPrSKuDqRGfEJv3+Hl
 J1/rsLNH4muKBF0QL2i6UYbCRIl5rbvZVsS9vYbiwBu4MV7wegjV14VJ9qtkTJRuYsRF
 Q6gSoeeZNPfprgd2iqr07joF1ZisS0JNNudfpUGWVlQXKOQO2GdDAa/qjh1nslWptuFA
 lR/PSqYPT9W5mhHN3wRen8lQQsNpcEDbKgvfuJW3UEGy2erlTUpXu7p+McgXaDTeeaNu Sw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vq77qtjk0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Jan 2024 17:22:12 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40IH0R1D012270;
	Thu, 18 Jan 2024 17:22:12 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vq77qtjjp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Jan 2024 17:22:12 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 40IH0OWQ030434;
	Thu, 18 Jan 2024 17:22:11 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3vm72kcakv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Jan 2024 17:22:11 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 40IHMAlY19530346
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Jan 2024 17:22:10 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 77D8358043;
	Thu, 18 Jan 2024 17:22:10 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3BF6A58055;
	Thu, 18 Jan 2024 17:22:10 +0000 (GMT)
Received: from [9.10.86.82] (unknown [9.10.86.82])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 18 Jan 2024 17:22:10 +0000 (GMT)
Message-ID: <62618192-aa11-40e2-97a0-ecc819815d0d@linux.vnet.ibm.com>
Date: Thu, 18 Jan 2024 11:22:09 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: Update max_hw_sectors on rescan
To: John Garry <john.g.garry@oracle.com>, linux-scsi@vger.kernel.org
Cc: brking@pobox.com, jejb@linux.ibm.com, martin.petersen@oracle.com
References: <20240117213620.132880-1-brking@linux.vnet.ibm.com>
 <5326306f-9515-4153-9ef2-e978e775a27f@oracle.com>
Content-Language: en-US
From: Brian King <brking@linux.vnet.ibm.com>
In-Reply-To: <5326306f-9515-4153-9ef2-e978e775a27f@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: RPrcNbOvAute8PLG18-JugfTPyqJooK-
X-Proofpoint-ORIG-GUID: qg-g3pv43IL3VXJjjJdunPDHJM9MOUkH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-18_08,2024-01-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 phishscore=0 bulkscore=0 clxscore=1011 mlxlogscore=999
 impostorscore=0 malwarescore=0 adultscore=0 suspectscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401180126

On 1/18/24 9:44 AM, John Garry wrote:
> On 17/01/2024 21:36, Brian King wrote:
>> This addresses an issue discovered on ibmvfc LUNs. For this driver,
>> max_sectors is negotiated with the VIOS. This gets done at initialization
>> time, then LUNs get scanned and things generally work fine. However,
>> this attribute can be changed on the VIOS, either due to a sysadmin
>> change or potentially a VIOS code level change. If this decreases
>> to a smaller value, due to one of these reasons, the next time the
>> ibmvfc driver performs an NPIV login, it will only be able to use
>> the smaller value. In the case of a VIOS reboot, when the VIOS goes
>> down, all paths through that VIOS will go to devloss state. When
>> the VIOS comes back up, ibmvfc negotiates max_sectors and will only
>> be able to get the smaller value and it will update shost->max_sectors.
> 
> Are you saying that the driver will manually update shost->max_sectors after adding the scsi host? I didn't think that was permitted.

That is what happens. The characteristics of the underlying hardware can change across
a virtual adapter reset. 

Thanks,

Brian

> 
> Thanks,
> John
> 
>> However, when LUNs are scanned, the devloss paths will be found
>> and brought back online, still using the old max_hw_sectors. This
>> change ensures that max_hw_sectors gets updated.
>>
>> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
>> ---
>>   drivers/scsi/scsi_scan.c | 6 +++++-
>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
>> index 44680f65ea14..01f2b38daab3 100644
>> --- a/drivers/scsi/scsi_scan.c
>> +++ b/drivers/scsi/scsi_scan.c
>> @@ -1162,6 +1162,7 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
>>       blist_flags_t bflags;
>>       int res = SCSI_SCAN_NO_RESPONSE, result_len = 256;
>>       struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
>> +    struct request_queue *q;
>>         /*
>>        * The rescan flag is used as an optimization, the first scan of a
>> @@ -1182,6 +1183,10 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
>>                   *bflagsp = scsi_get_device_flags(sdev,
>>                                    sdev->vendor,
>>                                    sdev->model);
>> +            q = sdev->request_queue;
>> +            if (queue_max_hw_sectors(q) > shost->max_sectors)
>> +                blk_queue_max_hw_sectors(q, shost->max_sectors);
>> +
>>               return SCSI_SCAN_LUN_PRESENT;
>>           }
>>           scsi_device_put(sdev);
>> @@ -2006,4 +2011,3 @@ void scsi_forget_host(struct Scsi_Host *shost)
>>       }
>>       spin_unlock_irqrestore(shost->host_lock, flags);
>>   }
>> -
> 

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


