Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5438FC0A;
	Tue,  1 Jul 2025 02:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751338223; cv=none; b=KT8Q0I3XWiJIUANm6JlaCmqEub/SC4fHJtEDSpkCn6r4DI/bQK7c9f6rijTvdITsBW6c6B1Tyr0wE2+IxXDpSELyoW0ePClkBU+xwDf/j72K2HCexE9mKriT09szQggEM8n4fJjTCVhyNw6Frm/VvzIaY4GzhJku5t5dXc0CwEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751338223; c=relaxed/simple;
	bh=TaJjkkMAtMyilMlPoCXrfBgXDZqu5+p/dSDz1gVA8l4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LWFXL7Mp078sLm56/csZBS3GgmlEuJM5MDQCBnNuiB4zYlxhUzf19sfRzYMG19oNDVTqonvRAwQu1o5loRTUBKK+Jf9sNkuGMC4+ghKff/Q/yZaG9Oa/2Rpv6cts0n9IrRp6vvIY17HcjyyFIrrMdRZxvP2KeyZ8WRlp2eS11Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YGwPAQmr; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YGwPAQmr"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2349f096605so30933125ad.3;
        Mon, 30 Jun 2025 19:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751338221; x=1751943021; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0gUDd/VhewzNMfjifK2zCnAoxWB+Qij5GThYsfQSrB8=;
        b=YGwPAQmrvA8GjTzb5nVlWLnRGccMDhsySkfkFlmgafb3o8z4dXk1puUCVtE+cEnSGd
         Z2+CwxBtsNSKVoMCzLWkVm7DsE4TB9aqOBmqZTohaA66rO77uXtuG/lM2TxyFEK2lvFy
         0pd9bcKRTJpaqnSrt4JuTujgwNW9ZirP9qH+UWfqOnhEZF1+VrANMlka7u+fJfbxyztv
         Rfc0G6SosCoD7dopDp76xC47AEnfdwLTfvo3mHZa36Rdyr4LwI6EBcD7c7L+zXCO/ypq
         Q5Ra4UE+Ct/8R09PsB/eUnN2zn6iMbHjt2fzQd/JxTl9SweZRKFijOMHl1fsGCfA6/EZ
         B72w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751338221; x=1751943021;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0gUDd/VhewzNMfjifK2zCnAoxWB+Qij5GThYsfQSrB8=;
        b=lhVmpZ4NheouI340eTSRefW+IETaae9oBMCGcD8KUBlj3URO3OL69OOrsAhOqW0nyN
         crQ8/M/iAc66lrCeC1Up2LDxUAZyzQjFV0wQVuO8M3PX8OUgt8MbGsJBigw/X+TmjhDD
         DqIGLdhXKq4Q8KFLhk/mQlnKhf1I1TYtjkAmg4qcjvsOfI7lJt3pmrnoUrqhapC3ZcwS
         EFUoVmmfvZ1lkLzetBI0S6vhs08twd/feqMJgoSu+qOhDJrGPVguPmYwxNynDKnby4S8
         rh4pYgHepGjjhgb81pVYf/0IgoT+J38SdCWwK7iXVbrnOmzz5IivtWWapUHxnYx2shc+
         RJBg==
X-Forwarded-Encrypted: i=1; AJvYcCUZASWRvslLt6SdBYVW95JDGjhOSS9MvJdh2EGhTHhxv4604T2UDUn739IpKcq0CsOcdRH9a4cHHj1OQFw=@vger.kernel.org, AJvYcCXnuyC1g+LS5SuSjl79Qdjc6H2uTKVK/SEhzSpV89ZMW1e90IEZdcFdwxkKJQeOTL8ng3Gt9ICOug1OgA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzhPLFxp2+Pj4pvpOnxvhqppalr2/sXBbUGb3RCwfS7AMOI1p0o
	1hhtzRZYRDkUvgO1AjImecFwvdnk7vKansoIcfh+p+HZUNeASfaKs8aVFBgbZw==
X-Gm-Gg: ASbGnctWAQO7JqOMM5+62/OOElaHCUcSDccTKbjNVQMYPgd9qEegWOtAX4MaMOA38Cw
	3JBPN8NupJ6LePscICBaTddq3B8fF84Lt9KAmszk4U9Kn9r/5vNLTTJi8DAdK3ZpEEyFtY5reG0
	NlaRIFCJ+P67Lp3O95pS75/psgaH6i5SfELclNM8tXv9v4smcZwrjetjqJYT67Pi1jSMGdwdvH9
	DQrXnEjaFa46+a6R/eUWL9pp68IQPT1TEGOwCxWec6WdygdBdsmb2ufWPmUvI/oGziboBq1f88o
	+34fK83Sexp5+tJ5aSCBe0SafzrhRBu4DcdkKYoBPkkJfgPG+SWC8xo2r2nQ9W9tBY3lcByI4ew
	hIqpe
X-Google-Smtp-Source: AGHT+IG6hTc8brOl9s7bdLpqzfwOfSXJqPevjp0lpRaMqxsJNNQhXwy3/8SnFjnJjR+qmjscGIPNWg==
X-Received: by 2002:a17:903:244e:b0:234:c7e6:8459 with SMTP id d9443c01a7336-23ac40e021fmr176244025ad.20.1751338221070;
        Mon, 30 Jun 2025 19:50:21 -0700 (PDT)
Received: from [192.168.0.150] ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acb3b0047sm98261595ad.160.2025.06.30.19.50.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jun 2025 19:50:20 -0700 (PDT)
Message-ID: <6538b497-6e65-4e02-a102-7f9649dbf231@gmail.com>
Date: Tue, 1 Jul 2025 09:50:17 +0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: Format scsi_track_queue_full() return values as
 bullet list
To: Bart Van Assche <bvanassche@acm.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux SCSI <linux-scsi@vger.kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Rob Landley <rob@landley.net>
References: <20250626041857.44259-2-bagasdotme@gmail.com>
 <159d1b84-665f-4bc7-865c-59b15232a477@acm.org>
Content-Language: en-US
From: Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <159d1b84-665f-4bc7-865c-59b15232a477@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/26/25 23:16, Bart Van Assche wrote:
> On 6/25/25 9:18 PM, Bagas Sanjaya wrote:
>> - * Returns:    0 - No change needed, >0 - Adjust queue depth to this 
>> new depth,
>> - *         -1 - Drop back to untagged operation using host->cmd_per_lun
>> - *             as the untagged command depth
>> + * Returns:    * 0 - No change needed
>> + *        * >0 - Adjust queue depth to this new depth,
>> + *         * -1 - Drop back to untagged operation using host- 
>> >cmd_per_lun
>> + *           as the untagged command depth
>>    *
>>    * Lock Status:    None held on entry
>>    *
> 
> Here is an example from Documentation/doc-guide/kernel-doc.rst:
> 
>        * Return:
>        * * %0        - OK to runtime suspend the device
>        * * %-EBUSY    - Device should not be runtime suspended
> 
> Wouldn't it be better to follow that example and to move the list under
> 'Returns:' and to move it more to the left?
> 

Ack. I will do that in v2.

Thanks.

-- 
An old man doll... just what I always wanted! - Clara
