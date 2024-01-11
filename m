Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E510B38F
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2024 01:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1d3ef33e68dso33700295ad.1
        for <linux-scsi@vger.kernel.org>; Wed, 10 Jan 2024 17:00:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704934826; x=1705539626;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cqEhOhgw+UJXiNIMoRt3yz/W3H227WV8euwyuXh6Yz0=;
        b=oQRJ4qtwzbcWUcsis0ItqNfhSYBFg4r2ID9r9WOCuL5JvD6ZyqvyvU72opfAuSO4CX
         Rox+YdzzJ4Pf4Ei5WhRZjae6lDiKiYYF+w2FPON/S0Kwuu1TVZMYZV9HQknnwSWAP/+e
         okIGPCqWI476gISFbME9ESBGqTZZsnoi1P2VGnjHjLE+9ruaaffFPOLwESpnH4GulRPr
         B0IJb7KS3WpzNIBR5WJD56kimzIcw8nupNPs9Gf5n6LUN1H/shbjXgezrGwT/GJeMysX
         IQSL2nVXs9QW5pOSQTYntasCoJuZaknLc0Ee1M/nJc5VT8vAJA3grmSt3W3u1o1Ujwey
         VjzQ==
X-Gm-Message-State: AOJu0Yye4+SQu2I2rOToJcALPjfv5MNElunPlqVeBqrrjCSP8uns6J2b
	6gmDUdQSKKmVEt9/agxOM0Y=
X-Google-Smtp-Source: AGHT+IE4pI6l3JRhQAbpJRUDKyq84tLPLHrFrijaQ2cb7xmw329SYeUvi37ZPxdObdZJiWnEOOZdQw==
X-Received: by 2002:a17:902:7849:b0:1d5:629:2e6f with SMTP id e9-20020a170902784900b001d506292e6fmr406707pln.44.1704934825833;
        Wed, 10 Jan 2024 17:00:25 -0800 (PST)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net. [73.231.117.72])
        by smtp.gmail.com with ESMTPSA id p4-20020a1709028a8400b001d43af66d28sm4248399plo.152.2024.01.10.17.00.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jan 2024 17:00:25 -0800 (PST)
Message-ID: <bf673c51-32d7-426a-9591-f6ac5b8b21a4@acm.org>
Date: Wed, 10 Jan 2024 17:00:24 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Regression] Hang deleting ATA HDD device for undocking
Content-Language: en-US
To: Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Niklas Cassel <Niklas.Cassel@wdc.com>
Cc: Kevin Locke <kevin@kevinlocke.name>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
References: <ZZw3Th70wUUvCiCY@kevinlocke.name>
 <c7c4769c-5999-4373-90df-f2203ecfc423@acm.org>
 <ZZxvPtrf5hLeZNY5@kevinlocke.name>
 <8bbbd233-69c6-4f20-904c-332bb838cc42@acm.org>
 <ZZ2-hMYVJlF4ayqk@kevinlocke.name>
 <d585753a-b5f3-410f-a949-8b52252307ab@acm.org> <ZZ8CzOaXBkxyKxNw@x1-carbon>
 <1c34e2e4-4bc5-4142-bc21-3db3a55f638e@acm.org>
 <4214e790-cc9b-40ef-96c3-167569cddb44@opensource.wdc.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <4214e790-cc9b-40ef-96c3-167569cddb44@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/10/24 15:01, Damien Le Moal wrote:
> On 1/11/24 05:52, Bart Van Assche wrote:
>> On 1/10/24 12:49, Niklas Cassel wrote:
>>> However, I'm worried that applying that libata patch will simply hide
>>> an actual problem in SCSI, which might lead to someone else stumbling
>>> on this SCSI bug in the future.
>>>
>>> Thoughts?
>>
>> Since the hang is caused by submitting a SCSI pass-through command, I'm
>> not sure this issue can be called a SCSI core bug. Aren't users on their
>> own who mix SCSI pass-through commands with commands submitted by the sd
>> driver?
> 
> I would not expect a correct result from a user mixing up passthrough and
> regular kernel sd management, however, having the system hang is not acceptable
> I think. So we should fix this, avoiding this hang. Is Niklas patch OK for that ?

Hi Damien,

There are two patches in Niklas' email so I'm not sure which patch you
are referring to. I'm not enthusiast about the SCSI patch in his email
because that patch would reintroduce the superfluous queue runs that I'm
trying to get rid of.

Thanks,

Bart.


