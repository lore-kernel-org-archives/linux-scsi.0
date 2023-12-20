Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5DA41206
	for <linux-scsi@vger.kernel.org>; Wed, 20 Dec 2023 16:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-20422793decso20825fac.3
        for <linux-scsi@vger.kernel.org>; Wed, 20 Dec 2023 08:44:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703090664; x=1703695464;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4gAlnbJFlIMBW8/Qv5AjI+o81Qb92xZ1s//F4Mf6ThY=;
        b=uL1cmSB4vEVG7nuAQ6xkdyANcXv/56rQRITwfS/YKWSb3ow/O+QVLB16B03qkjnpug
         QoqyU+/Bq3NE/f88Jw3bYdsDhmjeb6hRbQSVpx7Kcp/34/oBn+y2LR68FL+ryJTzhDkx
         t3tsvdJlIFz8M+NIuH4wIq11pcgfeNDVyFKewd2SXUqq6jfUFJT2zQAeSwOIJGIy9nRu
         rYv6S5xUbT3mhpXQRLR3TxYGObgzkUdvNixoEl2T53Qe5umfiT6fJUrg0EVVfKV69qhD
         9Tt2yP3A68xDQWN+nvstLa/P0AiQimMtALOBB0XdnxfK87lDD/mXeVtv2ewC7GcrscCl
         StMw==
X-Gm-Message-State: AOJu0Yz1BHtpJhT/S5IRjVJZh9Si3JgasXOkmlxvMU33umtU2bRevgcz
	yyDb4HVmcjbpXQ2hsN9AcrI=
X-Google-Smtp-Source: AGHT+IF1IqWAO6Hew0JJiUA/R4X3R/VmjIuf4ksmq7GJxFl1fO2BH3uivNiqRFVklmfBk1lhHQ7vJQ==
X-Received: by 2002:a05:6870:3d95:b0:203:7bef:1691 with SMTP id lm21-20020a0568703d9500b002037bef1691mr12279821oab.109.1703090663806;
        Wed, 20 Dec 2023 08:44:23 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:b2aa:4964:8bfa:71c? ([2620:0:1000:8411:b2aa:4964:8bfa:71c])
        by smtp.gmail.com with ESMTPSA id b16-20020a63cf50000000b005aa800c149bsm7114pgj.39.2023.12.20.08.44.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Dec 2023 08:44:23 -0800 (PST)
Message-ID: <fd0b2b2e-c6f6-4b0e-a092-8ed79af1fb45@acm.org>
Date: Wed, 20 Dec 2023 08:44:21 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: ufs: Remove the ufshcd_hba_exit() call from
 ufshcd_async_scan()
Content-Language: en-US
To: Manivannan Sadhasivam <mani@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, Daniel Mentz <danielmentz@google.com>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>,
 Stanley Jhu <chu.stanley@gmail.com>, Avri Altman <avri.altman@wdc.com>,
 Can Guo <quic_cang@quicinc.com>, Asutosh Das <quic_asutoshd@quicinc.com>,
 Bean Huo <beanhuo@micron.com>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 Arthur Simchaev <Arthur.Simchaev@wdc.com>
References: <20231218225229.2542156-1-bvanassche@acm.org>
 <20231218225229.2542156-3-bvanassche@acm.org>
 <20231220144813.GH3544@thinkpad>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20231220144813.GH3544@thinkpad>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/20/23 06:48, Manivannan Sadhasivam wrote:
> On Mon, Dec 18, 2023 at 02:52:15PM -0800, Bart Van Assche wrote:
>> Calling ufshcd_hba_exit() from a function that is called asynchronously
>> from ufshcd_init() is wrong because this triggers multiple race
>> conditions. Instead of calling ufshcd_hba_exit(), log an error message.
> 
> This also means that during failure, resources will not be powered OFF. IMO, a
> justification is needed why it is OK to left them powered ON.

I have never seen ufshcd_async_scan() fail other than during hardware bringup.
Has anyone else ever observed a ufshcd_async_scan() failure?

>> Reported-by: Daniel Mentz <danielmentz@google.com>
>> Fixes: 1d337ec2f35e ("ufs: improve init sequence")
> 
> No need to backport this patch?

Isn't the "Fixes:" tag sufficient? I don't think that it it necessary to add a
"Cc: stable" tag if a "Fixes:" tag is present.

Thanks,

Bart.
