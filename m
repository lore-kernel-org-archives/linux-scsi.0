Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914F336D9F0;
	Tue,  3 Mar 2026 14:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772546453; cv=none; b=hX6H8Y/vFpHPXENGBqZMc44xF98pwtaWa+lPnd5l95xohlHAQMeV8p4nOJVEtttfpDxcQ+6RqPG0hl6ju/wYt/hfMF4YKai/soCLMR+aRRkdbPbriTH4hC0jd8vDErtL/sztNybirMpYEe9Cqv7EmzSrGHChWV0jzxnj1iLgt7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772546453; c=relaxed/simple;
	bh=+4Y4elGeYSzecADu/iTBeQx3K18SQ4UNZhH+2MTgKHM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KKdLvBC99ZYvm9em1y50RUT0wWVEbFOI6YqxzaA+QoKz1Oub7YBkUrmGcVUTYXQr0KLRjB/kWrVTj7UZyA+Z1G1J9Gr/1PYmcQfRSTqmzL1n1LTOVLZR9HYLinaHPBTK7AO5lMhdrcCGcEwUsu7AKSReh6oA24HDHsvZ//YrrP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=kM2iKVLc; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="kM2iKVLc"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6231vMlZ859950;
	Tue, 3 Mar 2026 14:00:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=zXc5r5
	tNYGXofU9kUtFF8uWuNYi071TaUzmIzuN6JlY=; b=kM2iKVLcO1eHLaZYCoc/0g
	JcHon0E+BJxn+h9gK/cCihzgJ0wm5NG7zPYTAFQj8UCpEPGOPmcz2d4RRIuPk9y4
	4WkXOPFAP6nvJMqTN5bKwTuWzcAW64iyaxScIlc7h9mWabiiJfYXPbsFOsBO+94M
	jNF7vHlLkkyOqx2QFuP3+VXNXlglzVNX40n2LRbodcZAGfKACKeEz/Vcc8EBojYP
	5rfkLKErD/DpJ/Hai7m52J4V0/DlUaTSAcvwt0J2Ixyk/uXu4U3joUL7JpuLZ5kX
	F1tCFs4WveubdK2VPyHbH17hjkKMNsUM0bM9ZanGA2/gDsZg1ULAs4kvZSef5TFQ
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ckskbtx08-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Mar 2026 14:00:25 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 623Aw4Sc027704;
	Tue, 3 Mar 2026 14:00:24 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cmcwjaa16-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Mar 2026 14:00:24 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 623E0Odm25952820
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 3 Mar 2026 14:00:24 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5799F58056;
	Tue,  3 Mar 2026 14:00:24 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 926FA58062;
	Tue,  3 Mar 2026 14:00:17 +0000 (GMT)
Received: from [9.124.211.174] (unknown [9.124.211.174])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  3 Mar 2026 14:00:17 +0000 (GMT)
Message-ID: <17568a92-982a-4aff-89db-e665f31b59f3@linux.ibm.com>
Date: Tue, 3 Mar 2026 19:30:14 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/13] libmultipath: Add bio handling
To: John Garry <john.g.garry@oracle.com>, hch@lst.de, kbusch@kernel.org,
        sagi@grimberg.me, axboe@fb.com, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225153225.1031169-1-john.g.garry@oracle.com>
 <20260225153225.1031169-5-john.g.garry@oracle.com>
 <a6ffe0f5-7ec3-423c-8702-cf4248fdc168@linux.ibm.com>
 <20a7c554-b641-48d0-9bdd-fa79d74d3a58@oracle.com>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <20a7c554-b641-48d0-9bdd-fa79d74d3a58@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: wJeC1T16fJU0X3qu-uLJPTckAja8IFf-
X-Authority-Analysis: v=2.4 cv=b66/I9Gx c=1 sm=1 tr=0 ts=69a6e979 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=TURKr1gTI-SBg4foBj0A:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAzMDEwOCBTYWx0ZWRfX5RVVS2hwM973
 dN9qupE3ZjsE/2gJy9zvp3gQEbBMXxPJPhxPALnarWOpyZQ/CA4eRZ2hUtSmO+WA6eRO5ZnhwvP
 xbY9s4kEfsmg8HUhWzIo/xeUt+NsIeeZYbDuPky3yMALZ07XwIH3eU9SHov5HavQYnRLMlpSlJI
 OU1PgNCKEffk0BbgzXEAPNh+mcMpYzuaTl0oKQS2TYZ9vVW50Qybn4a/ELzwEqsGsB6yBxajALT
 ABHq78i2YS6H4Ti0JBaHQsTxTVaMdYNWNy2sPs6NzljOzdNV+qWSuzmNjfpJ/QwV4XZUk0f/55p
 XDPWMjtpv8eIciHjjQHwiusUYhI7mvxYTJHpkJAAVNpdQ1KPY9jLSwvH9Tt0QLCwTPIFAm5+C2x
 UrfJ8nhC3Fac8QcXh7rBhEGXLOL5C0uZbCgFixhr6kQfAmtX9AB2hald/jHqBPZ8gsIwCF8aoyV
 bwEN9E/Faski+wCvj/g==
X-Proofpoint-GUID: wJeC1T16fJU0X3qu-uLJPTckAja8IFf-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_05,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 phishscore=0 clxscore=1015 adultscore=0
 bulkscore=0 impostorscore=0 malwarescore=0 spamscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603030108

On 3/2/26 9:22 PM, John Garry wrote:
> On 02/03/2026 12:39, Nilay Shroff wrote:
>>> static struct mpath_device *mpath_find_path(struct mpath_head 
>>> *mpath_head)
>>>   {
>>>       enum mpath_iopolicy_e iopolicy =
>>> @@ -243,6 +243,66 @@ static struct mpath_device 
>>> *mpath_find_path(struct mpath_head *mpath_head)
>>>       }
>>>   }
>>> +static bool mpath_available_path(struct mpath_head *mpath_head)
>>> +{
>>> +    struct mpath_device *mpath_device;
>>> +
>>> +    if (!test_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags))
>>> +        return false;
>>> +
>>> +    list_for_each_entry_srcu(mpath_device, &mpath_head->dev_list, 
>>> siblings,
>>> +                 srcu_read_lock_held(&mpath_head->srcu)) {
>>> +        bool available = false;
>>> +
>>> +        if (!mpath_head->mpdt->available_path(mpath_device,
>>> +                &available))
>>> +            continue;
>>> +        if (available)
>>> +            return true;
>>> +    }
>>> +
>>> +    return false;
>>> +}
>>
>> IMO, we may further simplify the callback ->available_path() to return 
>> true or false instead of passing the result in a separate @available 
>> argument.
> 
> I have to admit that I am not keen on this abstraction at all, as it is 
> purely generated to fit the current code.
> 
> Anyway, from checking mainline nvme_available_path(), we skip checking 
> the ctrl state if the ctrl failfast flag is set (which means mpath_head- 
>  >mpdt->available_path returns false). But I suppose the callback could 
> check both the ctrl flags and state (and just return a single boolean), 
> like:
> 
> if (failfast flag set)
>      return false;
> if (ctrl live, resetting, connecting)
>      return true;
> return false;
> 
Yes I think, as now the ->dev_list (or ns sibling) iterator is handled 
within libmultipath code, the above logic makes sense. We should plan to 
simplify nvme_available_path() as per the above pseudo code.

Thanks,
--Nilay
