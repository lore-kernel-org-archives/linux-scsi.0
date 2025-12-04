Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0490530AAA6
	for <linux-scsi@vger.kernel.org>; Thu,  4 Dec 2025 07:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764834922; cv=none; b=HjcobKOofGSZswjZMoSZBmn/kjpmmnO9NIFBeNAFRySGiZEbVXYvtvOZBkFMVu6jn8UKHcnb4SaiFnCMl++KOeA5wOVm9V9TWmboxRoqF1lkdHCpvAJst53CJltJ7QeI4gb1ifXbU6NhQFE0z8g+f0ez56YvZefpfS4SvVzr84s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764834922; c=relaxed/simple;
	bh=Nr65EzR7vyW922umpMnQt38AWJf6EqfIjLJkIOHxt7U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nBzqdRH2SarpwV79+xydXS/jg0vGZIFLpcjBae3hEj63Z1wXs52kArVXmjX0rgXh8bFUlDMzIHR4BPMMDHJBSGbkVD35PQQMzBvfTMXzkTwGWxRcV2EU6IJME3vaEasPy/UYx8bbAXYfGCohwkNS6Z/aKMk5drAuUQayv8ks08o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bt85l26Z; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bt85l26Z"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-477a1c28778so7971465e9.3
        for <linux-scsi@vger.kernel.org>; Wed, 03 Dec 2025 23:55:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1764834918; x=1765439718; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aNqWmaRIUahG7eokd7tz3AyijC2RFWL/z3RSgG90az0=;
        b=bt85l26Z1r/wQV9J/BA1WaVoAWvU1eh2TxpLFkqAUw/lchMfNdvDmGaVXscyFwiYOm
         5ZZGvcCgiPinT5TTe/5kOuJMc7y/LCJcXO8odUTyv+73q/dYyuji18XuM/+NcNlFXNTt
         9li6LT/KtTCCv1b8oc4ha/51Z//nUbNbX+lntrNNYb0KrZysrRb/PzZ8ysuAA/HuTh2D
         a9GNOkWBfE+TDkSr+QPwY74H9cAp2Kj1btgYcrSkcftuXGhK4HcKazdckB00a/Y/2Vov
         GRvJNWlwv2Pa/QzuCkxajM8MuCjonAZeeDQjwrkhcA+6u2MQc5aEffjTEUBLCEdyNnZX
         qT7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764834918; x=1765439718;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aNqWmaRIUahG7eokd7tz3AyijC2RFWL/z3RSgG90az0=;
        b=rDKvv0eh1UOKt86FPpVZjxGb6giyJgEV94u49h4tk+nz+3vcGxGIaZMZXpUGmQDE5z
         rNvagZzDD9thAjFLtPX7CsOKrqxhcdKzXCovXnPC2u3ameJshC/CXwQuhgwNExvOY4dc
         5SRbhAuM0DyNJe7h5bmZDYyU0FR9M72SA6ubWy4Ba/6UmmgJElgg75VzYjAAVKAp6rfe
         Dcd1dVABe4MAsfCETK0VpUmPwjZoadj46XgPsln3bAXJ9O9l1OHRNSaZITHiBwpnB9Yq
         gF0tWG/CHpTMUsMaJGs/WNq+Li4APD1SlT56j2z9Rh5L0ruIDT4ijCrrsMDeaPpVOI+D
         6JlQ==
X-Forwarded-Encrypted: i=1; AJvYcCWCMFY2Z57tcCYcBN99ECx72kKNjD10VtZFC2Amt1THtI/wASRzgDXhyapg0KBE3Qb1lV3pKgSXbhsg@vger.kernel.org
X-Gm-Message-State: AOJu0YwBuC4sq5inWQRiuJfvKiMMaU0A1busDJMWzY5oh8ew3CQgmWKE
	FMn0pmkp2tsfZOq4V6awsMP6usT2ptd+zk/p795UU3eDnIic2u4MIafV7q9Bzjr0u84=
X-Gm-Gg: ASbGncvt7M2as4qHxvdLLoQnHmEkC3Z9TcwGdM+T9uyI5+1Vb4U1s29NdVb59pzEmkB
	6zvvyxev8kH/kDiwCcjVZH+sFwywZnQ7YFev1Juqn6NH/d6gfWssfdjIEmW7qyy51jjGak2D/MB
	85S2R7xHbnKFVsoxh+efDWAbG+e4o3FfF6EYaMgzhgh9yuvPVFfwvvHfBkVF5juWoEuAhSdjL2Q
	svb+oddJlEsIpbDTNEFVfD2hsS0NZjOLgueVuh0hZxcp1ZQ+LeffxV2xTte0YKJmfgFOkXYr2kI
	Ym/bn4FSdAC1ruhsFzq9xtt9CVifP6Ugy+F336TgpJBqvh3V3QHdJk5d23TugUwW7Jz8sDL+H+P
	lLOY7vM/4nAAC3ok/OmysoDclVb0y074rlEHaA4t5uwYqamXRHNffiQpmi7H+YuRzAFxeHHdZXC
	u8yuroCFbRhR3n0/z8t12kQvqG/p9SHf4qMAIMfUSXFlSDnxjc
X-Google-Smtp-Source: AGHT+IE3fLkRdBTP31CtaOocc2Iq10kuLI2Dan4rlMES+LVg28qoLNgDZsK5s8Q1I964TqWRpM6IbQ==
X-Received: by 2002:a05:600c:b8d:b0:477:6d96:b3e5 with SMTP id 5b1f17b1804b1-4792f244cdamr17960795e9.7.1764834918243;
        Wed, 03 Dec 2025 23:55:18 -0800 (PST)
Received: from ?IPV6:2001:a61:2bb0:d301:fe89:8fc1:2b97:d5b8? ([2001:a61:2bb0:d301:fe89:8fc1:2b97:d5b8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4792b05ce9bsm32850545e9.8.2025.12.03.23.55.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Dec 2025 23:55:17 -0800 (PST)
Message-ID: <e792b704-6f06-47a9-82b1-af0e4a0da4d9@suse.com>
Date: Thu, 4 Dec 2025 08:55:16 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] scsi: core: Fix error handler encryption support
To: Bart Van Assche <bvanassche@acm.org>,
 Christoph Hellwig <hch@infradead.org>, Po-Wen Kao <powenkao@google.com>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>
References: <20251203073310.2248956-1-powenkao@google.com>
 <aS_pE4nf7wQ031Y8@infradead.org>
 <34848777-b370-4a63-8b08-c3246d214167@suse.com>
 <88900700-7f37-4c3e-878e-cf5f68f006cc@acm.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <88900700-7f37-4c3e-878e-cf5f68f006cc@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/3/25 16:55, Bart Van Assche wrote:
> On 12/2/25 10:42 PM, Hannes Reinecke wrote:
>> There had been an intersection with the reserved command stuff, but
>> now that Bart has dusted things off there I guess I should give it
>> another go.
> 
> Does that patch series perhaps involve allocating a reserved command
> from inside the SCSI error handler? Won't that break SCSI LLDs that
> restrict the queue depth to one? I think that the following SCSI LLDs
> only support one command (.can_queue = 1):

reserved commands are only implemented for adapters which require an
LLD specific 'tag' to send TMFs (eg fnic, aacraid, or hpsa).
Most HBAs (especially the older ones) are not that elaborate, and
there TMFs are not commands per se but rather operations on the HBA.

EG fdomain host_reset is just settings some bits in some registers,
no command allocation needed at all.

So for those we don't need to allocate _any_ commands for TMFs,
consequently we don't need to implement reserved commands and
hence TMFs are not guarded by .can_queue at all.

> * drivers/scsi/fdomain.c
> * drivers/scsi/mac53c94.c
> * drivers/scsi/ppa.c
> * drivers/scsi/imm.c
> * drivers/scsi/aha152x.c
> 
Cheers,
Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
