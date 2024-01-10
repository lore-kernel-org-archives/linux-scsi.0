Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016CD4EB34
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jan 2024 20:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-5c229dabbb6so1731481a12.0
        for <linux-scsi@vger.kernel.org>; Wed, 10 Jan 2024 12:52:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704919972; x=1705524772;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7HCWixB0gW8r5PuWZf5r8eyWF2Fw5F/rlIwOsDkSqh4=;
        b=qHFyKe4olZzPppnhzJjrRaaaF+V+Q5VhAk3TBXo+kcmO3TDqHUz3bOL2rFQt5hiwkL
         9cA1chk2oBsW5zIs5n/OByETwV3QXpKsrJayojHJQaYS5vYvENuddvGcWl1Vb88+60hX
         oQ3qks5U3ViS9RrXSMYFkqd1z0x0pNYPrSnBt8skrtZ0Cjel321QiNVXwEjeBg3EEVzY
         LQ8TMdUMD9p37iMDeGvZnVuN7ayo2tzv17FAp7cmKJ5fzWqCt0mLO5jOJW7dPrOwbW6N
         93ae9NYpOQeJStCeIzpfvZ9oKJtP784+nH4JzUCxJzoR6W+GrbXhVaHjHlMRAkR72TR/
         glAA==
X-Gm-Message-State: AOJu0YyIVE83gFYEMOwiNDtqAN0YzGbKASznKFdu3Op+37mpM8sWh4gW
	6PKoc8iioAjh23R+WsL924s=
X-Google-Smtp-Source: AGHT+IHtRE5HEfVks1ymhTL+9xe6Qxfpfy6zrelKuSX1rO92E3Jqmteaq+hZ4lyqv79kRvAbdiSBWA==
X-Received: by 2002:a17:90a:d10:b0:28d:2b9d:e273 with SMTP id t16-20020a17090a0d1000b0028d2b9de273mr99978pja.74.1704919972069;
        Wed, 10 Jan 2024 12:52:52 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:2b84:6ee3:e813:3d8d? ([2620:0:1000:8411:2b84:6ee3:e813:3d8d])
        by smtp.gmail.com with ESMTPSA id sn4-20020a17090b2e8400b0028bbf4c0264sm2015458pjb.10.2024.01.10.12.52.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jan 2024 12:52:51 -0800 (PST)
Message-ID: <1c34e2e4-4bc5-4142-bc21-3db3a55f638e@acm.org>
Date: Wed, 10 Jan 2024 12:52:50 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Regression] Hang deleting ATA HDD device for undocking
Content-Language: en-US
To: Niklas Cassel <Niklas.Cassel@wdc.com>
Cc: Kevin Locke <kevin@kevinlocke.name>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>
References: <ZZw3Th70wUUvCiCY@kevinlocke.name>
 <c7c4769c-5999-4373-90df-f2203ecfc423@acm.org>
 <ZZxvPtrf5hLeZNY5@kevinlocke.name>
 <8bbbd233-69c6-4f20-904c-332bb838cc42@acm.org>
 <ZZ2-hMYVJlF4ayqk@kevinlocke.name>
 <d585753a-b5f3-410f-a949-8b52252307ab@acm.org> <ZZ8CzOaXBkxyKxNw@x1-carbon>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ZZ8CzOaXBkxyKxNw@x1-carbon>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/10/24 12:49, Niklas Cassel wrote:
> However, I'm worried that applying that libata patch will simply hide
> an actual problem in SCSI, which might lead to someone else stumbling
> on this SCSI bug in the future.
> 
> Thoughts?

Since the hang is caused by submitting a SCSI pass-through command, I'm
not sure this issue can be called a SCSI core bug. Aren't users on their
own who mix SCSI pass-through commands with commands submitted by the sd
driver?

Thanks,

Bart.

