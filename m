Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6D94D112
	for <linux-scsi@vger.kernel.org>; Mon, 12 Aug 2024 21:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723499141; cv=none; b=XzfkvQYo51hx670U3Yc2H1YWoaOe1Gtw/y35ndUhIEcQKrXLrjqTG1tOVUuXq45uBwKoGD1fUsvMsQWowSNpT25mM+CJ2Eq0aoEXPFsyhyJBqxtBHJkic3v/WiP+18jyeQzMW2EFXOisl7VZYBqPMkrkwj52LIvqH+vevHOlVyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723499141; c=relaxed/simple;
	bh=Vx/wHnM3Z/EIlBFw705kOsY5pVorH6F9kjuzVr0jjnI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nlEtJNmYz4/c5AWEsrAsDsEQ9DT2HDCQ6hm3rgN39heG7b4kAiLaQtBiVVuHD19SI5kskTsdCNqHYmOMpLvrFpQAGI5qab+yXucfc8FlHXIx38OzvdlidAfDY3/uCcf/j2UKPzay4xOvimz/ruSwlSE08BNl3X0wicYb5I6ZKRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com; spf=none smtp.mailfrom=linux.vnet.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=eS/M23on; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.vnet.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="eS/M23on"
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47CDuRr0001885;
	Mon, 12 Aug 2024 21:45:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:date:mime-version:subject:to:cc:references:from
	:in-reply-to:content-type:content-transfer-encoding; s=pp1; bh=f
	ix8GPrnZhQhL//un93cfdaPTb/42VH6vv44OZ3Sas0=; b=eS/M23on3aSZxorJ0
	sTljip8aw0JYhAq3nwsiTs5MLbRtPvNjHU3g1jNfT8KROcVG3VqXKyXllRjcngJR
	t51kXTK5hq3NsjCrgLZuyiJ9msQnNXmbrpzXRNdNi6N83X9aUTKuhczv5zJGa05c
	w3vVRpGQuSdBgESFxfGPhB/3UasuRTBzdTZjQ6UthZ6c2dPYzPtPlM625t1E0zt9
	yOv1llbimnPjO2OvX1AIXw0kiSlaOd/2jzsOnT/y7FrWxSPRbSbnzsOkQI9RyUUn
	Wh21Eh7I9Orf7iemCEMkGCItRe9nDrvlFxOfrtfHv/2KivprgLOlYJxipvPKubJa
	xVgew==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40x005x1f3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 12 Aug 2024 21:45:33 +0000 (GMT)
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 47CLjWii009126;
	Mon, 12 Aug 2024 21:45:32 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40x005x1f1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 12 Aug 2024 21:45:32 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 47CICO8f010088;
	Mon, 12 Aug 2024 21:45:31 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 40xjx0gkde-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 12 Aug 2024 21:45:31 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 47CLjSco33948258
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Aug 2024 21:45:30 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4FD1C58051;
	Mon, 12 Aug 2024 21:45:28 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ECE5B5805C;
	Mon, 12 Aug 2024 21:45:27 +0000 (GMT)
Received: from [9.61.145.135] (unknown [9.61.145.135])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 12 Aug 2024 21:45:27 +0000 (GMT)
Message-ID: <cd5c3b50-e928-4e2c-b4c4-d5fb03ae514d@linux.vnet.ibm.com>
Date: Mon, 12 Aug 2024 16:45:27 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ibmvfc: Add max_sectors module parameter
To: Martin Wilck <mwilck@suse.com>, Brian King <brking@linux.ibm.com>,
        martin.petersen@oracle.com
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
        tyreld@linux.ibm.com, brking@pobox.com
References: <20240730175118.27105-1-brking@linux.ibm.com>
 <646b3701a9a3d8131eb7f0bf16c0fa6b1a0d49b4.camel@suse.com>
Content-Language: en-US
From: Brian King <brking@linux.vnet.ibm.com>
In-Reply-To: <646b3701a9a3d8131eb7f0bf16c0fa6b1a0d49b4.camel@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: zsW78nPYPBNWyiOjCRmb6grSK5AtE30G
X-Proofpoint-GUID: grDD0-hDyLGeepU-CtIQ9-pwSfarYsHc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-12_12,2024-08-12_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 phishscore=0 clxscore=1011 mlxscore=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2408120159

On 8/12/24 3:22 PM, Martin Wilck wrote:
> On Tue, 2024-07-30 at 12:51 -0500, Brian King wrote:
>> There are some scenarios that can occur, such as performing an
>> upgrade of the virtual I/O server, where the supported max transfer
>> of the backing device for an ibmvfc HBA can change. If the max
>> transfer of the backing device decreases, this can cause issues with
>> previously discovered LUNs. This patch accomplishes two things.
>> First, it changes the default ibmvfc max transfer value to 1MB.
>> This is generally supported by all backing devices, which should
>> mitigate this issue out of the box. Secondly, it adds a module
>> parameter, enabling a user to increase the max transfer value to
>> values that are larger than 1MB, as long as they have configured
>> these larger values on the virtual I/O server as well.
>>
>> Signed-off-by: Brian King <brking@linux.ibm.com>
>> ---
>>  drivers/scsi/ibmvscsi/ibmvfc.c | 10 +++++++---
>>  drivers/scsi/ibmvscsi/ibmvfc.h |  2 +-
>>  2 files changed, 8 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c
>> b/drivers/scsi/ibmvscsi/ibmvfc.c
>> index a3d1013c8307..611901562e06 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
>> @@ -37,6 +37,7 @@ static unsigned int default_timeout =
>> IBMVFC_DEFAULT_TIMEOUT;
>>  static u64 max_lun = IBMVFC_MAX_LUN;
>>  static unsigned int max_targets = IBMVFC_MAX_TARGETS;
>>  static unsigned int max_requests = IBMVFC_MAX_REQUESTS_DEFAULT;
>> +static unsigned int max_sectors = IBMVFC_MAX_SECTORS;
>>  static u16 scsi_qdepth = IBMVFC_SCSI_QDEPTH;
>>  static unsigned int disc_threads = IBMVFC_MAX_DISC_THREADS;
>>  static unsigned int ibmvfc_debug = IBMVFC_DEBUG;
>> @@ -83,6 +84,9 @@ MODULE_PARM_DESC(default_timeout,
>>  module_param_named(max_requests, max_requests, uint, S_IRUGO);
>>  MODULE_PARM_DESC(max_requests, "Maximum requests for this adapter. "
>>  		 "[Default="
>> __stringify(IBMVFC_MAX_REQUESTS_DEFAULT) "]");
>> +module_param_named(max_sectors, max_sectors, uint, S_IRUGO);
>> +MODULE_PARM_DESC(max_sectors, "Maximum sectors for this adapter. "
>> +		 "[Default=" __stringify(IBMVFC_MAX_SECTORS) "]");
>>  module_param_named(scsi_qdepth, scsi_qdepth, ushort, S_IRUGO);
>>  MODULE_PARM_DESC(scsi_qdepth, "Maximum scsi command depth per
>> adapter queue. "
>>  		 "[Default=" __stringify(IBMVFC_SCSI_QDEPTH) "]");
>> @@ -1494,7 +1498,7 @@ static void ibmvfc_set_login_info(struct
>> ibmvfc_host *vhost)
>>  	memset(login_info, 0, sizeof(*login_info));
>>  
>>  	login_info->ostype = cpu_to_be32(IBMVFC_OS_LINUX);
>> -	login_info->max_dma_len = cpu_to_be64(IBMVFC_MAX_SECTORS <<
>> 9);
>> +	login_info->max_dma_len = cpu_to_be64(max_sectors << 9);
>>  	login_info->max_payload = cpu_to_be32(sizeof(struct
>> ibmvfc_fcp_cmd_iu));
>>  	login_info->max_response = cpu_to_be32(sizeof(struct
>> ibmvfc_fcp_rsp));
>>  	login_info->partition_num = cpu_to_be32(vhost-
>>> partition_number);
>> @@ -5230,7 +5234,7 @@ static void ibmvfc_npiv_login_done(struct
>> ibmvfc_event *evt)
>>  	}
>>  
>>  	vhost->logged_in = 1;
>> -	npiv_max_sectors = min((uint)(be64_to_cpu(rsp->max_dma_len)
>>>> 9), IBMVFC_MAX_SECTORS);
>> +	npiv_max_sectors = min((uint)(be64_to_cpu(rsp->max_dma_len)
>>>> 9), max_sectors);
>>  	dev_info(vhost->dev, "Host partition: %s, device: %s %s %s
>> max sectors %u\n",
>>  		 rsp->partition_name, rsp->device_name, rsp-
>>> port_loc_code,
>>  		 rsp->drc_name, npiv_max_sectors);
>> @@ -6329,7 +6333,7 @@ static int ibmvfc_probe(struct vio_dev *vdev,
>> const struct vio_device_id *id)
>>  	shost->can_queue = scsi_qdepth;
>>  	shost->max_lun = max_lun;
>>  	shost->max_id = max_targets;
>> -	shost->max_sectors = IBMVFC_MAX_SECTORS;
>> +	shost->max_sectors = max_sectors;
> 
> Would it make sense to check whether the user-provided max_sectors
> value is within some reasonable limits?

Agreed.  I'll follow up with an updated version.

Thanks,

Brian


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


