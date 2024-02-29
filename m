Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B4353612E
	for <linux-scsi@vger.kernel.org>; Thu, 29 Feb 2024 18:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709229935; cv=none; b=WfDzQ5UxIydgZTXSeCQ/usU2zgIkyLH1JvGwQ+osKIQZfmywWXCnvILS4l6aRBPa7px9N2+oPSVqfE+Os4r8LVek1+uP4W5RCHVTgUEFTfHwh6wN1SVD3YinxyNtgGU+tRWntbov3ZUfzNs2N5E8iYtUtQRPe2eJw4SGOSp/JfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709229935; c=relaxed/simple;
	bh=6JrR6fW9shVuu0XjG35/bgBygv9W3i6G7fVLtIfrJvE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iDsiOp7oZ+9Q+QvIhvMxyzOfIW7Ot4HfuFSN59l2v5H3eRYguVrG1jWvhHSaiM2q/oby1U8izyR7pkEbCZIjHiT+PI+i8HgpBfD5Jqnq/M8uJPAHzjkIt+rsmPJw5hz4N3ozcjgey948R61PVa/jh0opKvmDtcLn9Y5opkKWQBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1dc1ff58fe4so10866485ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 29 Feb 2024 10:05:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709229933; x=1709834733;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RCn8qW2l7vpRvxLAuoZX+hWkVmxFqetBqhx2zkzcwys=;
        b=qSClCa5uBmZ5InluuZq8CiL6YAulrq7X68POYWXUNaR4pW6Mxwm7J0vAAzhJOMKaml
         Li9smanZxXovVlcaPWFLd2R2SJut9BZzHQfTLEh07EOpCp2HNg5dZ343y4YCvr8ZmtDY
         3TtnO5zOidX+P0pY+fNlyZQdeFDwQyT8ebnJU9eXUSA0hp9jGO4Qqwu7S0KS+QGz03dS
         Tecem99lt/eOHoHo0gl7hb2eoKO+2uOfW/qkM7E2XZ2QY7XPdV8SdhtJhgythEGJQSjh
         mFQkJygzSY0oj7m1BYLFmOzHzpnbUtLIZ3AdIYZNogTQ/cXakp+RF/XeeFHU01f06KDs
         MWzQ==
X-Gm-Message-State: AOJu0Yzy44Zb4OadBPmBRFFxqHJz+MgRmCmhdt8CJWSQEtthD/Mp1rBY
	evA1LDfy8WM7qLvn9g3QDssSOuALnzZ65g7ujkMBYyIpqU1qYsE0
X-Google-Smtp-Source: AGHT+IE0hjqiVMVc1AeLzrHZjYfvXgTaaHlfDyae3R/l5P37L+MFohwXgeGC7ullIotobHrHaM7PTg==
X-Received: by 2002:a17:903:1104:b0:1dc:7279:8a3e with SMTP id n4-20020a170903110400b001dc72798a3emr3388173plh.21.1709229933332;
        Thu, 29 Feb 2024 10:05:33 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:2491:7db1:8e45:9513? ([2620:0:1000:8411:2491:7db1:8e45:9513])
        by smtp.gmail.com with ESMTPSA id y15-20020a17090264cf00b001dcc18c7e3fsm1821744pli.148.2024.02.29.10.05.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Feb 2024 10:05:32 -0800 (PST)
Message-ID: <eec0d0d1-9fe3-457f-8150-e5cbe19a9f23@acm.org>
Date: Thu, 29 Feb 2024 10:05:31 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi/sd_zbc: Use READ(10)/WRITE(10) for zoned UFS devices
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Niklas Cassel <cassel@kernel.org>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20240229172333.2494378-1-bvanassche@acm.org>
 <d28c3a75-0a90-4720-a510-7e6847d76f8b@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <d28c3a75-0a90-4720-a510-7e6847d76f8b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/29/24 09:29, Damien Le Moal wrote:
> On 2024/02/29 9:23, Bart Van Assche wrote:
>> +	if (sdev->type == TYPE_ZBC) {
>> +		/* READ16/WRITE16/SYNC16 is mandatory for ZBC devices */
>> +		sdev->use_16_for_rw = 1;
>> +		sdev->use_16_for_sync = 1;
> 
> scsi_add_lun() sets use_10_for_rw to "1" so can we clear it to "0" here again
> like was done in the sd_zbc.c hunk below that you removed ?
Hi Damien,

Although it would be easy to make that change, will it cause any
difference in behavior? sd_setup_read_write_cmnd() checks the value of 
.use_16_for_rw before it checks the value of .use_10_for_rw. Hence, the
value of .use_10_for_rw does not matter if .use_16_for_rw is set.

Thanks,

Bart.
