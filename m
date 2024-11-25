Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C13219F49E
	for <linux-scsi@vger.kernel.org>; Mon, 25 Nov 2024 13:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732541067; cv=none; b=C7SuaejLWFGlDD7BvxWIlEOTvhDse2FpxT4bwHfveE2jCRIO9f3DWfZ3fNNfHxZvoFHokVrn91ISSKYQgFRTaCu3yUN/R6ENiNNwh6SpOTv3Cz7Zo21pshPtE5tIXL4LEEyLMUPRCnsWU0EHrBfQbYTKKWHKfjGgM1jTG8LhUnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732541067; c=relaxed/simple;
	bh=fvmA0EvjxJSV8pEBLJzL62Cxu0a3QR8VbMczo1FAqzE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EhFidxI/zyEQRxbTGUKQfR3HOiJAbJGczp4W0ANs/eYCmgR5nNVn3XbzZpDNo1gTPk+Z13jQ4vSq77sF6NgbGPZK8TJexITjmGCiQ+3PtJaOqX+el0jVBU5AWVzNejuVwYovrRUem9rwrXKy4NL6ZPWTEyDGf3Xr7PQNZa0j7dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ea8IsYVt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ea8IsYVt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732541064;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WmKKgR4+rtXMhTZRByXMroyLmJe+zrCm8j5jwh8XE8k=;
	b=ea8IsYVtX6H5moqAQER3T4OgBl9huaVlwR1CLU06/sQ75R2w6MBgNva70zmmxksbU1ieH8
	/H3g2mqB9S5hyoLMZqcPtYCTMhxhh6Fn9cPO+FzSYMAOjQ6FUTfrFmaLpiK4+Vtm7WgIrU
	XZBtKQw1wzJJWufvMvFjF+fK/nC/sqs=
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com
 [209.85.219.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-540-s7t3JERrMRu4uHDnTXk48w-1; Mon, 25 Nov 2024 08:24:23 -0500
X-MC-Unique: s7t3JERrMRu4uHDnTXk48w-1
X-Mimecast-MFC-AGG-ID: s7t3JERrMRu4uHDnTXk48w
Received: by mail-yb1-f198.google.com with SMTP id 3f1490d57ef6-e389bce28b5so6981173276.1
        for <linux-scsi@vger.kernel.org>; Mon, 25 Nov 2024 05:24:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732541062; x=1733145862;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WmKKgR4+rtXMhTZRByXMroyLmJe+zrCm8j5jwh8XE8k=;
        b=rMzAPsEapuqIvR8WYurOvkg3nosRt7AfFVjqELBOXbhQUz6d7T5ZauYy47VDNtf6pX
         QRKImigQxdDP1tpXE4MG76uz90ap7fl2JjzNrI42wgAsymCFPYTA8TBxtmI/4+ozKRuC
         VlFgEvth4ONTdn8YwptbudUBiLtZLqyRnPI7vcCrMoTyZ3YtcsOnxiUajR4hOWlBo45R
         fyzd8HrLzUfrUw9iF1sM6XKkfdC6/58OpXMavOfaAwuxWl4ZnHCw68oFX5oMc6Cl0PTS
         +fYC8HFtVYb9btNfWrgnRz96WzIO55e4r1UsqVABrD5Yut/zHwkQWHE5fSHKOfYHNRcS
         HLLg==
X-Forwarded-Encrypted: i=1; AJvYcCVbz+gfpSgw+iLCyr4VM7FZTSq+WPUAAFUlgYltE7DoRwibHgA3dYuXOlNFYCW5xMsdbixF3L3oBuif@vger.kernel.org
X-Gm-Message-State: AOJu0YymcQS8IJf/lusNgAbJ8KRV6STgdfF0ULMgQiYrZcw0tUKlc8RA
	YTQIlQZaWXZEtFPnfsPeuWQSYc6OcVyCqQg7KiDHAYEPc7N7fmaGYg2+gPcXA5z4h5dtNDcHTi2
	bDSS8ZjidXdJlZS0mYzuVY9AMql2vdKT418omwv3MaZDgef056sRES0B5BIg=
X-Gm-Gg: ASbGncu7a+us3eISE1plMT6PiE9L2q3KtWFNyawB6/6oNR5YZCcqu/GBl2lpp63BvnA
	CDlRCnyZK3TTZF7OUsf/G/8rXknTTKJFZrDC6PvtloNlGOXwXzwIaUOwaMvKBdo8IuIjZIPLYjS
	b7UIreYp2xhOgjxbsNzV+eYj9+NlzLNKi34nvvgm/LtPpvnI/pBjDb09p4P6HuaujU3YVTeuKrJ
	kkOdIEiDdS6hIGdEmUN4Ud2LqVjWyVEURZYy2uOtcRNPm8iKIGKqn3AVzHo9bUrTv6fnCjx7Nei
	kjIgNm/jMXVHXSz7N0W1rQQumg==
X-Received: by 2002:a05:6902:154d:b0:e29:1627:d4d3 with SMTP id 3f1490d57ef6-e38f8bdb42cmr10896697276.41.1732541062385;
        Mon, 25 Nov 2024 05:24:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG4NA8XnwIz7IRxfi/si6PGo1EODhpOTTazZ904UEWvyKIpL4pbWMcStTqL+Npw+K7Qdq5ybA==
X-Received: by 2002:a05:6902:154d:b0:e29:1627:d4d3 with SMTP id 3f1490d57ef6-e38f8bdb42cmr10896657276.41.1732541062025;
        Mon, 25 Nov 2024 05:24:22 -0800 (PST)
Received: from [192.168.1.205] (pool-173-76-156-230.bstnma.fios.verizon.net. [173.76.156.230])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4653c4900d0sm45392261cf.84.2024.11.25.05.24.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Nov 2024 05:24:21 -0800 (PST)
Message-ID: <3c6aa1ec-b8ea-be31-eeee-9b6f9354b5d0@redhat.com>
Date: Mon, 25 Nov 2024 08:24:20 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] scsi: storvsc: Do not flag MAINTENANCE_IN return of
 SRB_STATUS_DATA_OVERRUN as an error
To: Michael Kelley <mhklinux@outlook.com>,
 "kys@microsoft.com" <kys@microsoft.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "wei.liu@kernel.org" <wei.liu@kernel.org>,
 "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
 "decui@microsoft.com" <decui@microsoft.com>,
 "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
 "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "bhull@redhat.com" <bhull@redhat.com>,
 "emilne@redhat.com" <emilne@redhat.com>,
 "loberman@redhat.com" <loberman@redhat.com>
References: <20241122162355.2859481-1-cavery@redhat.com>
 <SN6PR02MB4157B4A80A1BCF778117DC13D4232@SN6PR02MB4157.namprd02.prod.outlook.com>
Content-Language: en-US
From: Cathy Avery <cavery@redhat.com>
In-Reply-To: <SN6PR02MB4157B4A80A1BCF778117DC13D4232@SN6PR02MB4157.namprd02.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 11/22/24 13:11, Michael Kelley wrote:
> From: Cathy Avery <cavery@redhat.com> Sent: Friday, November 22, 2024 8:24 AM
>> This patch partially reverts
>>
>> 	commit 812fe6420a6e789db68f18cdb25c5c89f4561334
>> 	Author: Michael Kelley <mikelley@microsoft.com>
>> 	Date:   Fri Aug 25 10:21:24 2023 -0700
>>
>> 	scsi: storvsc: Handle additional SRB status values
>>
>> HyperV does not support MAINTENANCE_IN resulting in FC passthrough
>> returning the SRB_STATUS_DATA_OVERRUN value. Now that
>> SRB_STATUS_DATA_OVERRUN
>> is treated as an error multipath ALUA paths go into a faulty state as multipath
>> ALUA submits RTPG commands via MAINTENANCE_IN.
>>
>> [    3.215560] hv_storvsc 1d69d403-9692-4460-89f9-a8cbcc0f94f3:
>> tag#230 cmd 0xa3 status: scsi 0x0 srb 0x12 hv 0xc0000001
>> [    3.215572] scsi 1:0:0:32: alua: rtpg failed, result 458752
>>
>> This patch essentially restores the previous handling of MAINTENANCE_IN
>> along with supressing any logging noise.
>>
>> Signed-off-by: Cathy Avery <cavery@redhat.com>
>> ---
>>   drivers/scsi/storvsc_drv.c | 16 ++++++++++++++++
>>   1 file changed, 16 insertions(+)
>>
>> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
>> index 7ceb982040a5..088fefe40999 100644
>> --- a/drivers/scsi/storvsc_drv.c
>> +++ b/drivers/scsi/storvsc_drv.c
>> @@ -149,6 +149,8 @@ struct hv_fc_wwn_packet {
>>   */
>>   static int vmstor_proto_version;
>>
>> +static bool hv_dev_is_fc(struct hv_device *hv_dev);
>> +
>>   #define STORVSC_LOGGING_NONE	0
>>   #define STORVSC_LOGGING_ERROR	1
>>   #define STORVSC_LOGGING_WARN	2
>> @@ -980,6 +982,13 @@ static void storvsc_handle_error(struct vmscsi_request
>> *vm_srb,
>>   	void (*process_err_fn)(struct work_struct *work);
>>   	struct hv_host_device *host_dev = shost_priv(host);
>>
>> +	// HyperV FC does not support MAINTENANCE_IN ignore
>> +	if ((scmnd->cmnd[0] == MAINTENANCE_IN) &&
>> +		(SRB_STATUS(vm_srb->srb_status) == SRB_STATUS_DATA_OVERRUN) &&
>> +		hv_dev_is_fc(host_dev->dev)) {
>> +		return;
>> +	}
>> +
> Could use the following coding instead to avoid the explicit check of srb_status:
>
> @@ -981,6 +981,16 @@ static void storvsc_handle_error(struct vmscsi_request *vm_srb,
>          struct hv_host_device *host_dev = shost_priv(host);
>
>          switch (SRB_STATUS(vm_srb->srb_status)) {
> +       case SRB_STATUS_DATA_OVERRUN:
> +               /*
> +                * Hyper-V does not support MAINTENANCE_IN, resulting in FC
> +                * passthrough returning DATA_OVERRUN. But treating as an
> +                * error incorrectly puts ALUA paths into a fault state.
> +                */
> +               if ((scmnd->cmnd[0] == MAINTENANCE_IN) &&
> +                               hv_dev_is_fc(host_dev->dev))
> +                       return;
> +               fallthrough;
>          case SRB_STATUS_ERROR:
>          case SRB_STATUS_ABORTED:
>          case SRB_STATUS_INVALID_REQUEST:
> @@ -988,7 +998,6 @@ static void storvsc_handle_error(struct vmscsi_request *vm_srb,
>          case SRB_STATUS_TIMEOUT:
>          case SRB_STATUS_SELECTION_TIMEOUT:
>          case SRB_STATUS_BUS_RESET:
> -       case SRB_STATUS_DATA_OVERRUN:
>                  if (vm_srb->srb_status & SRB_STATUS_AUTOSENSE_VALID) {
>                          /* Check for capacity change */
>
>>   	switch (SRB_STATUS(vm_srb->srb_status)) {
>>   	case SRB_STATUS_ERROR:
>>   	case SRB_STATUS_ABORTED:
>> @@ -1161,6 +1170,12 @@ static void storvsc_on_io_completion(struct storvsc_device *stor_device,
>>   	stor_pkt->vm_srb.sense_info_length = min_t(u8, STORVSC_SENSE_BUFFER_SIZE,
>>   		vstor_packet->vm_srb.sense_info_length);
>>
>> +	// HyperV FC does not support MAINTENANCE_IN ignore
> For consistency, prefer to not use C++ style comments.
>
>> +	if ((SRB_STATUS(vstor_packet->vm_srb.srb_status) == SRB_STATUS_DATA_OVERRUN) &&
>> +		(stor_pkt->vm_srb.cdb[0] == MAINTENANCE_IN) &&
>> +		hv_dev_is_fc(device))
>> +		goto skip_logging;
>> +
> Just wondering:  There's already a hack earlier in this function for
> INQUIRY and MODE_SENSE commands that sets scsi_status and
> srb_status to indicate success. What if this case did the same? Then
> nothing would be logged, and a special case would not be needed in
> storvsc_handle_error().  Or do you still need the error and sense info to
> propagate to higher levels?  (in which case what you've done here is OK)
>
> Michael
>
It sounds like a reasonable idea. I'll try it out.

Cathy

>>   	if (vstor_packet->vm_srb.scsi_status != 0 ||
>>   	    vstor_packet->vm_srb.srb_status != SRB_STATUS_SUCCESS) {
>>
>> @@ -1181,6 +1196,7 @@ static void storvsc_on_io_completion(struct storvsc_device *stor_device,
>>   			vstor_packet->status);
>>   	}
>>
>> +skip_logging:
>>   	if (vstor_packet->vm_srb.scsi_status == SAM_STAT_CHECK_CONDITION &&
>>   	    (vstor_packet->vm_srb.srb_status & SRB_STATUS_AUTOSENSE_VALID))
>>   		memcpy(request->cmd->sense_buffer,
>> --
>> 2.42.0

