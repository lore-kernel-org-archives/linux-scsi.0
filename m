Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDAE91A73B;
	Fri, 12 Jan 2024 03:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-7bed8faf6ebso156416539f.2;
        Thu, 11 Jan 2024 19:46:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705031199; x=1705635999;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GDiATViGYPJHZv3qTCOphZ9Lj2x7128zuJp/8zdZPZw=;
        b=H8xwF//36pFgmjOWcIRYYmubAVwSKyBP+s8khL841q92H4btXDd//pqZ6E1P3Qm0uk
         TB31tviVAkDbqHS/saEyfBXewKV8ACJOuE5lwSdz75VYswtDrZGMB8rx9wJuaeetYZe5
         Ku8pTXrX0y1jwAaQWDJfdsuMJXvxppJt47wWq9/DB2AA/GYzJ2QttjstMrtDLwBLC28J
         AUpMd8ob2xCqo3Pw7IzluGe6lNrCdiiBwKLd5fs/2+ci9dGUaiXqRF6qeNqcYE6iZlbY
         ABOtIy4YxlLJOCQqpMduUH6J6EczDShw50MxfqllnxERA+VW4rxgnHFgZU+RAH87FGaD
         RccQ==
X-Gm-Message-State: AOJu0YyijORPa8AjnKioQivXxEuHHkfL/x+y4MvyTd3m5SJJAlUiZdTc
	96expYbYiUr8BgqODL+7TF8=
X-Google-Smtp-Source: AGHT+IHq8tQC7rJ5B9DiB0fTiCcYZmZPgo5KeNAhU4wNZcyAqXEhds1hklyUDsSPgmwKRYy36A5H1Q==
X-Received: by 2002:a05:6e02:491:b0:35f:af09:23d1 with SMTP id b17-20020a056e02049100b0035faf0923d1mr414504ils.28.1705031198810;
        Thu, 11 Jan 2024 19:46:38 -0800 (PST)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net. [73.231.117.72])
        by smtp.gmail.com with ESMTPSA id i136-20020a636d8e000000b005cebb10e28fsm2059768pgc.69.2024.01.11.19.46.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jan 2024 19:46:38 -0800 (PST)
Message-ID: <5eed1649-135d-445c-b725-c6ae2d76b699@acm.org>
Date: Thu, 11 Jan 2024 19:46:36 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Report] blk-zoned/ZNS: non_power_of_2 of zone->len]
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, Ming Lei <ming.lei@redhat.com>
Cc: linux-block@vger.kernel.org, Yi Zhang <yi.zhang@redhat.com>,
 John Meneghini <jmeneghi@redhat.com>, linux-nvme@lists.infradead.org,
 hch@lst.de, Keith Busch <kbusch@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>,
 Jaegeuk Kim <jaegeuk@kernel.org>, Pankaj Raghav <p.raghav@samsung.com>
References: <ZaCSOH7L+Nm6PvcN@fedora>
 <20503cd0-3a99-45bb-8374-40296a3cb92a@kernel.org> <ZaCyC5RIAcbkBYeL@fedora>
 <6fe89190-a8ff-47c3-a6c4-7d69296c9883@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <6fe89190-a8ff-47c3-a6c4-7d69296c9883@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/11/24 19:34, Damien Le Moal wrote:
> On 1/12/24 12:29, Ming Lei wrote:
>> Just saw Bart's work on supporting non-power_of_2 zone len:
>>
>> https://lore.kernel.org/linux-block/dc89c70e-4931-baaf-c450-6801c200c1d7@acm.org/

Hmm ... weren't these patches developed by Pankaj Raghav from Samsung?

>> IMO FS support might be another topic, cause FS isn't the only user,
>> also without block layer support, the device isn't usable, not mention FS.
> 
> And if the FS requires a power of 2 zone size, that will create fragmentation of
> the zoned device support: some devices will be usable with an FS, others not.
> Not nice at all. That is *not* something that exists today, for any block
> device. I am not very keen on going down such route.

F2FS supports zone sizes that are not a power of two. Recent Android
kernels have support for zone sizes that are not a power of two in the
block layer since UFS vendors requested support for this. We prefer to
have support in the upstream kernel for zone sizes that are not a power
of two because having to carry out-of-tree patches is painful.

Thanks,

Bart.

