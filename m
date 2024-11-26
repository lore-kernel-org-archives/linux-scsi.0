Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B295653;
	Tue, 26 Nov 2024 05:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732598351; cv=none; b=MECanhRICiDrsvFEeKNxx1vS48zGL8I4d7t5at2W8GeWONcdIU+OWXWkYtIsZTmgHMkcPhdF54VeT6b6rYqUk689dv+4TtmBb43h5UkPGZ/p+Wo3KX6Qn068lBuqPwDm6w+ChLSa8w7qzPeFv2y63MD1vuZFbOzXY2XtA/QlFW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732598351; c=relaxed/simple;
	bh=SsXKeG4iKHIGl4IQNsH9J1ULRa5IOJVawi5c5nZBkDo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q8GWwFwyQDx/jlaG4rk+7IRqAtyf6usxbAdA3aAIVHx9GLMpr9FiCr75IFbU3GcY0Ysf+ARpYfjmeZKqxe5fLfqe+NRBFiMLT+DVBug8nOkojLTRqByg9N5sxPdEuH1tPTC6lNtCJiNk/D5ATLYDL08rSTWEFNEkAWsts+9430E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VRh15urY; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VRh15urY"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-7e9e38dd5f1so4420520a12.0;
        Mon, 25 Nov 2024 21:19:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732598349; x=1733203149; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VfgrFkIill8XZ44XmDBIgcIATqnyraRsPjCSbdmLm0M=;
        b=VRh15urYiZoDkTV/EiAfpEmwCFWvaIs1l14UzuarMGhqOxmEJwZmwQxfq2FQwj9kTE
         RTkwGsXZNueLiQZDNWu1pQ37Be9nDay6keO0Cbaag0fcHMPb+COtla39uD/eQ2Jk7lT+
         m+TzSy56PCEltOaigG4IN1+Xy5A62DUEouAOl9J0D+/EHc5cjVhDZSpQTbXa0+wQ6cvR
         Z9WK6zoJ1dsRfIna/H6CPGS+VjJ6rwCoM/h+hJ3w7w6Y/32zY11/mSR0bmNP/NvkYQm8
         mSuIYyC5a0yI7+Ymz1MkqctqC3MYmOWjv0iiAtPFc7g2A3PTiPhJYB0oZ95RwIdgtaq1
         +aew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732598349; x=1733203149;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VfgrFkIill8XZ44XmDBIgcIATqnyraRsPjCSbdmLm0M=;
        b=GhOAr33XIx0JaqTMSUOK/geQEgjJHK30gT2P0l/MI3sg0J9foZS7TY0m9V1Rv2C3JL
         K8JO7muabMRdRd+OtQOWVjJRgDZjrr8hpGTDwfndZBKgVq0k6Fq7MwFi0dIAAzD8I4P9
         k+PFdkxamZunYwct48wXB2bakHd6pdhW4dQU8KqunKxpZqNPg/URQggkJ93TmzSdYZa5
         dv3domD3zJRXKD5dGNEZfij+/mMny9vV2WAYrsIdyPxfJ3cIhPC6REidkz2ZOsBqJdid
         MK1keN2exLuPrKXIkuE1+zMTc4N7fa0u29uofD2RkbMYvGujByONJNVeNccvtBOSmgsE
         mwNQ==
X-Forwarded-Encrypted: i=1; AJvYcCUWL6B+PPSOVMNDGpnGc9RywvynaHfRdVYNpceYcjLUjBYHBDPPaZurXS6dTq5HKbJbUYb+u5Ed+UH07uU=@vger.kernel.org, AJvYcCXWs+g8dzZAeXQooo578RHvQd0dCAJp+duWcynk9vP2K9GoFsj9LNeQYpSRqIPFWKjI080/BG7rvWWyeg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyjR8bCKLKIeoiEPx+nyjsh/5fot7pxfyk4cgYds5+bGWqJBwWU
	0HUh9RaaHOIM6wfqO6pSObIKY8IeWp/vi352R+vrFsFrsfgSNroo
X-Gm-Gg: ASbGncvkiiwZ6i+AvY0iIKwr8D4tgjr4nvRr+CLFPMFcUN0qLEVrq+slU3ys4CUSGXF
	KI+UXLA03Z8S38XFt6aU76WYx7r4U3JDtBtd9xtB86GFvaRB0/0fKUivU7MSTtwq9PSO2LxVFBY
	ZZSvPTCCNj2Aqp873QCktJbkipA69L391bDti11yMU3KXEg/nO7dVRq1kbWzRFUMlM+yULIIxOp
	x7ravGh+8bXxxok+y6cJNDd8jTsoO6dHwV6iRF16025kHi6L7pUihsIi+PodEsj
X-Google-Smtp-Source: AGHT+IFrJNQcj02XB1WYSEjBx4IyMnzG3hPlXoB2Ggdu/AGwMkwtMpSPMOnxThdC55a44X3wZc9cTA==
X-Received: by 2002:a05:6a20:6a21:b0:1e0:d0b8:20bb with SMTP id adf61e73a8af0-1e0d0b82440mr6190683637.20.1732598349448;
        Mon, 25 Nov 2024 21:19:09 -0800 (PST)
Received: from [192.168.0.203] ([14.139.108.62])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2129db87dc9sm75376735ad.7.2024.11.25.21.19.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Nov 2024 21:19:08 -0800 (PST)
Message-ID: <fa2b0f11-d8bc-4d7c-b6dd-435eeacd6d37@gmail.com>
Date: Tue, 26 Nov 2024 10:49:03 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: sg: fix slab-use-after-free Read in sg_release
Content-Language: en-US
To: Bart Van Assche <bvanassche@acm.org>, dgilbert@interlog.com
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+7efb5850a17ba6ce098b@syzkaller.appspotmail.com
References: <20241120125944.88095-1-surajsonawane0215@gmail.com>
 <d4695943-51b8-40f2-bf2c-3a6436081887@gmail.com>
 <dc9ee4e6-5410-4635-9970-d0b2a5d02d81@acm.org>
From: Suraj Sonawane <surajsonawane0215@gmail.com>
In-Reply-To: <dc9ee4e6-5410-4635-9970-d0b2a5d02d81@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/25/24 22:33, Bart Van Assche wrote:
> On 11/25/24 6:30 AM, Suraj Sonawane wrote:
>> Hello!
> 
> Which person are you addressing with this email?
> 
I apologize for not clarifying earlier—my email was intended for 
everyone who might be reviewing the patch.

>> I wanted to follow up on the patch I submitted. I was wondering if you 
>> had a chance to review it and if there are any comments or feedback.
> 
> Sending a ping after 5 days is too quick. I think that you should wait
> at least a week before sending a ping.
> 

Thank you for pointing out that sending a follow-up after five days 
might be too soon. I truly appreciate your guidance on this. The reason 
for my follow-up is that, as a mentee in the Linux Kernel Bug Fixing 
Program, I need to include updates on my contributions in my progress 
report. I’ll make sure to wait at least a week before sending any future 
follow-ups.

> Bart.
> 


