Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F63218871F;
	Thu, 26 Jun 2025 23:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750979309; cv=none; b=s3Z0H0MHwK0AkbUabWhrW6wYDt+Q6K3dR7IVyB9KDTJ73HGFsDh7CLI1JZHpsGHSI/eg4hSP8W7dffPus5bD84Ibg2voF4N5A1beUF5Brxgz3R1uVHwXFN7hbxoS3g6WGmBIFOFOx2Wh4ECGqkmjdacDraqlIOYRg5Fy15KjklA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750979309; c=relaxed/simple;
	bh=SNfpXrlXe/EqYPDNhi4LL4SuiR71SP/o0IESvGZ8nBw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=asFytFdkfE0GxHvm4pjQBIOLebxflUfIY+w/yuObGSO3aDV9ggaoJp6iVKY3O/6FLD5CKFJOEZE8CRm5VjguXbffeSvDgdgvuXhvRb5HL4WSmckukHLTkp/s1/c2jMJGM9CY1BqvfQUDOl+H02YwDV0UzTA9fh1IeR2vb7oxefo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jl+rOWvK; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jl+rOWvK"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-749068b9b63so1172969b3a.0;
        Thu, 26 Jun 2025 16:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750979307; x=1751584107; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GnT5+ruvbNYdj+EvduSQIeU+Nd4XJFuoLHpJ8CNx10w=;
        b=jl+rOWvKOltRoPpTZeY08YFWDs53Mu/Po4Xse3vnoD2jZtAvK9T6LrL+vBbhNFePdG
         iuBaN0KLMRAhBXapyIeU2MYcch0A7TdRFsYOPsV01QCChfCYffhsDp0WFDmefdGOdJHS
         ejPfL2gZzr8ysnlXDVV7+v4QMV+OFwCUrxLcbpqCcAneswEemgeaxxEqOh/dwdkYLv8g
         +Fse5Z8nWR1Hykn32Qc10q6os2m9eK/ui5sYqqHMuvx3HW5fKF4eKcch6PAQs0IWyyKt
         r0c+c61TamKDf6qk3BfXAZ8QY1PhO9n2lJhSmRia31tcotSJOLdrR/TSXOSXq8fJSYXd
         K3bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750979307; x=1751584107;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GnT5+ruvbNYdj+EvduSQIeU+Nd4XJFuoLHpJ8CNx10w=;
        b=j7ck1Gr6kct/D6t6nIy0ApQ/2FtiV+zP9g7kmW3feL472WjQkuqZH154BDxbfNJK7I
         YszHhMij/4AdWa1+XDqMQQ7Zp5oueXhKCPi2tgGhPUh4ydskJiZZByUWDCX4jxzA2ir1
         iIHAww7hgsbeKsRrXdgZx/8WTlx2OxGPP+b4xCuGhSXK2qSswiyZ5Vev+K0uJ/L87hyh
         3HIx25IBjJCUx6sB0L6KWrj8gT7vSstL9pbtsXiIv87+diI7IC72V2niwfXIp/PqqWTY
         rvvdrcgK2zWxc3Ca05lu3vEdgFWBlqc6BjmsllT8W6UeVe6UlGEP+Hf4X8cqb93AHKpz
         N3dw==
X-Forwarded-Encrypted: i=1; AJvYcCV/SRLmexAQ7L3AGdur3KAlJKJp/As5S5ux6LcPhlaypvBhGJ9Nbjrd2RCEh061drXB7M4geG7VE+fSvw==@vger.kernel.org, AJvYcCVjnMCNST8uFsorWP8lBriZlVgdHZBBKLy6m7M/4/jS6KXj/kmy5o0m6H3dg0J+jCfe3DPHgAH9Bk9Hbr0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwfZst5xU1hMHgIIASJ3nI312hSJXEA3gJsuzECfrpwO7aBzGAA
	4Ud7DHTJO6nRe2hdUBHVYLXLc2RX/YJk5qz7soEEAGL4V43EDhBROaoZta0daA==
X-Gm-Gg: ASbGnctGvWZak0IUhNHhLJO5IDHtia1+hGtRdJHWuonREsRk7bGojcgvhZ+IusoXbdu
	MyFgqS0Lz0h6ocfBGsrYMXao/mOCzQDpRXvIB/xSZyVempmZB81f7wfEH2bFCtjjfOogFL/Mf33
	u59zpBXl0DHb+7KA5DFcfeOTgVaXif4s+DLBfTpigMzl71gaAcGgxPsV19EKj4kSHJVxP3EQ5aw
	hEIa1D+qtRTMaFbv96mXgRTNg7/66XAoUtVxKDloykAcoBT0aO/pO7zUhynRHzgq6p8I64oBkAn
	tUVH4mzFaROJlOWlxklff92nSFlXU+4KWEXaWPllgNOc/6BZQh3pXNt+uIGkMnUF3+/2AA==
X-Google-Smtp-Source: AGHT+IFkmcQUrOCO6zaITV8e/fmz/bD6LzgUMMwJW3brWPmBbFHQQLHgJjq/uno4Viu+7bF8etdRkw==
X-Received: by 2002:a05:6300:8e0f:b0:220:81e2:eae4 with SMTP id adf61e73a8af0-220a1802be3mr780395637.39.1750979307560;
        Thu, 26 Jun 2025 16:08:27 -0700 (PDT)
Received: from [192.168.0.150] ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74af5581020sm721813b3a.87.2025.06.26.16.08.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Jun 2025 16:08:26 -0700 (PDT)
Message-ID: <89c663de-35bb-4a40-b547-19512319d28d@gmail.com>
Date: Fri, 27 Jun 2025 06:08:24 +0700
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

Ack.

Thanks.

-- 
An old man doll... just what I always wanted! - Clara
