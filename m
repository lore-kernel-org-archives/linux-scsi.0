Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6476330E82B
	for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2026 06:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776408977; cv=none; b=aF5HX6gL/afKtyWd37hAVcPxIWritAlzEIu9Sxi1auwHXIylU1SpzstgO+flzeEgMcgahr0IYQmCyM7FLq44O2KuqlHOP67JcedGvSTd//YrOzcDWhdjr4w7ZCy3vtSfT6Ea//m3x1fpBtoEaAa1snZuc+vgs1XFTNEJIgrii/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776408977; c=relaxed/simple;
	bh=wDxHhAHlIyoXxfnkRr9SdUl0bEA3unu7hXdUWxP33/4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G+g7s8JusFfo/CEuxVIr0GiiMRJtGhlOkGiOSicuoexZy1QvVgT57Nn9ssv3QLKU5gUg/cfRkf5lI9ak2xH70FX9x/cCRRX6t7man+/gSmPIzMNQ7heh5pH7SHK/AuAiOkQ/cOPTRhsjPAW2Wkk2Yr+hmN0hP0uMspH5UlQ5utw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AYoeXQN2; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AYoeXQN2"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4852a9c6309so2521605e9.0
        for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2026 23:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776408975; x=1777013775; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Joo3YULEg4XAiWGz4cE4Xxni1DieVC2g4vJjbCxQH00=;
        b=AYoeXQN21qq4ocVNwmtQgqnkJ08eS+rq0LiXH/0SoJVHJT7mKu4HSwXSqXKlMP9KkQ
         pU0pAISinpMUhKiuC2wWOH43bGldYw+LfeGhoGeZMDZVeEFYPtRHcb/YSCzx52J3fY/U
         T+G/s2/MI1Eo0/fQnN89knz8tsDGHjwDTFbqY3H5nfE1OkuGZLhwuPZDnDiMXsMTJNNv
         xU2O4bQGwnzkFyhy7gM+5d6DZWhIwW4h9NdODWLKG5Y8YHZEU6alOcqNwCZUAfxww3TG
         NIfI05w1yhICr1LB/EGPwRWDAkTKrW+t1DcJ6PpmfMWn2Ge585zxOagV9MxWzftovWz6
         nINA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776408975; x=1777013775;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Joo3YULEg4XAiWGz4cE4Xxni1DieVC2g4vJjbCxQH00=;
        b=LXmFOgeFq76lbCNzz1sWwvDiWjzgGQRQ+wcTRHxM9bwWqj7NwVWpwj4jaOIfTucLHL
         72Yv/u33OeRnMeHGIBYH8zEoLTh4AySy2696XFyp+6hwjRGf9twM4arcJjI+DfsruGGC
         EXzcNQ7He2H7MNCYHX9CI0TjxkFQ1SbAtevYEYHMTw5DoljxUS+BnwFBlR9QnodmAKvF
         CTtndt8Vl3VYi89y7+FGogzCpx6GervPKY9tJnsq6gxHVFoP6wOaWcrM//Zk+xMQe/h4
         c+6pQXLZpf8OUSRckfb/wt89J6AjlbBi3f3kQ4LJHclpw+L8mzj5+VmbkVGqWpbChguL
         ZeBg==
X-Forwarded-Encrypted: i=1; AFNElJ8E4X2enYbGs3y5+F2nUS07sMJPRGiFmwCfrEHA4JNthhk5A178cyfUupCyeS3Kbuoysbfxf8ibOFwk@vger.kernel.org
X-Gm-Message-State: AOJu0YyGJIgHAHXqNuXuicjzCdquI2pzqlPeE1K6Dbcb7kWWKRYzxEyj
	U7dGeefI1NL3ziRB/VnPtk1TuxVZCSyWOMNouEFhgH5c2R3rzfRHAaDNL5zdn6sWpp4=
X-Gm-Gg: AeBDieswRpKvvSVDhso57STnvylz/TRhRWram2gK1wQw62QZN3Vi4vuUDN6+gA1gLdZ
	Ij2ToFT1n3r3kCH7Me60nRrfeS8TNfMiLHqguWSDxaGnL2KDb30ibvE1qDptQzIGc5o+JRTS2Zp
	jR1BQmrEcfNl/BLxuxO5QNfq1Xo3udtYz45E5fXwm7ABK750VuV0Rg3p/Fs6NBYfX5F/tBumUVA
	KWjJBuhnid88oC4cYXht7hdj2waYZvqNplLm3NrpXr6wcwY4puNqT3gdm9kDxCzxsJPPYs2AICq
	526+Y7B0b2M9EvtXNrv5Yd7jXYl+sXwdJYrLIFVY3hHhCGa92DRk5sv907BYxiBIZgSOB5w0oIm
	CTFvQf94mgPYO1DEtJhLaEz8ZjhV29NHusubUyx8A3BSBJWIBq99E1hECFStLbqaFAIwuxMYDsX
	lgvX6E2uf8s4Lw9833uIutkxZGpH1/xdi+48RQBU1Bv8ArvBiKC/+uNro6YUw4UouKWgJg8LYDo
	mdLiX0=
X-Received: by 2002:a05:600d:8451:b0:487:20ee:bef6 with SMTP id 5b1f17b1804b1-488fb745684mr17367155e9.11.1776408974807;
        Thu, 16 Apr 2026 23:56:14 -0700 (PDT)
Received: from ?IPV6:2001:a61:2ae4:301:12fa:de76:8d51:fc21? ([2001:a61:2ae4:301:12fa:de76:8d51:fc21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fb6dfa33sm14975665e9.0.2026.04.16.23.56.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2026 23:56:14 -0700 (PDT)
Message-ID: <5028645d-e91c-4196-b118-81fd513f5d31@suse.com>
Date: Fri, 17 Apr 2026 08:56:13 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] [SCSI] advansys: fix host resource leak in EISA probe
 error path
To: Guangshuo Li <lgs201920130244@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260416165935.3958686-1-lgs201920130244@gmail.com>
 <b1a6b96d-07d2-4a19-b9db-2cd8d878895c@suse.com>
 <CANUHTR_qm94JQn-FKa9BfRgxadXKbXJmJEof6ZdE070=Xi4mGw@mail.gmail.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <CANUHTR_qm94JQn-FKa9BfRgxadXKbXJmJEof6ZdE070=Xi4mGw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/17/26 08:29, Guangshuo Li wrote:
> Hi Hannes,
> 
> Thanks for the feedback.
> 
> On Fri, 17 Apr 2026 at 13:56, Hannes Reinecke <hare@suse.com> wrote:
>>
>>
>> You must be kidding ... EISA is died over a decade ago.
>>
>> If you _really_ are concerned about this please remove EISA support
>> completely from the driver.
>>
> 
> I agree that EISA is obsolete, and I understand that this path is
> unlikely to matter on modern systems. My intent was simply to clean up
> an inconsistency I noticed while reviewing the existing error handling
> code.
> 
> If maintaining the EISA path is not worthwhile, I’m fine with dropping
> this patch. I can also take a look at what removing the EISA support
> would involve.
> 
Please, drop the patch, and rather invest time to check how to drop
EISA support. Fixing issues for code paths which are never exercised
is a bit pointless.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
