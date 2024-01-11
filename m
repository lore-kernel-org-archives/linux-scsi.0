Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E5255769;
	Thu, 11 Jan 2024 19:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6d9af1f12d5so4793868b3a.3;
        Thu, 11 Jan 2024 11:22:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705000924; x=1705605724;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jW7VBEl6To0KnhKQxbLDFYXLP0Sg9gEqU1I4AR7/hzg=;
        b=qrEw4004YytqYFIZ4VDrp/737jWuksOe5mbfpdns+8PjEDNy2bch9ZmOeTQ+wtywY3
         u8zpMODbWq0PNZe3iFmrjVxSSi+UJ8c+a9uOQ/1fP2x7KDrqFYFVJFdYz4AjQKNDvMF2
         xhm2gooprio8D55jiHzvK4FpHGovwTkJcwdFWFDwivzYLOxwCNADezrmJ0D1HtTCyjvP
         9J6XaWFDactKh+CWS/czOh/rIa+nq6wghFEPqkEgTDBsQsin5LoU3AjdHpJjiV8a9ce7
         uikAV0/fvlUE0lhOviLjg91Gi6yiDiW6lNFygkPCxEpM9Vf9L5zB50Gv7systmw+tMra
         EWYg==
X-Gm-Message-State: AOJu0YwqCsK2QXejcqsC/QOqpD4JoNjdP8HOdT54YGz6EZJM8eYoAYsS
	twW1q2GLR+fxHsytvKIHFgg=
X-Google-Smtp-Source: AGHT+IGzr4/FcXmgket9GjUO8qWqfC2Q86Gf2gnW5Nso+WNfxajVTAOvxXhAlSR3/KxPy7jUInzfUg==
X-Received: by 2002:a62:4d43:0:b0:6da:b014:860 with SMTP id a64-20020a624d43000000b006dab0140860mr208071pfb.28.1705000923969;
        Thu, 11 Jan 2024 11:22:03 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:bef8:2106:339:e85f? ([2620:0:1000:8411:bef8:2106:339:e85f])
        by smtp.gmail.com with ESMTPSA id c23-20020aa78817000000b006d96dc803b3sm1604535pfo.12.2024.01.11.11.22.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jan 2024 11:22:03 -0800 (PST)
Message-ID: <1d3866af-ffca-4f97-914d-8084aca901ab@acm.org>
Date: Thu, 11 Jan 2024 11:22:01 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/4] block: Make fair tag sharing configurable
Content-Language: en-US
To: Yu Kuai <yukuai1@huaweicloud.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
 Keith Busch <kbusch@kernel.org>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Ed Tsai <ed.tsai@mediatek.com>, Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20231130193139.880955-1-bvanassche@acm.org>
 <20231130193139.880955-2-bvanassche@acm.org>
 <58f50403-fcc9-ec11-f52b-f11ced3d2652@huaweicloud.com>
 <8372f2d0-b695-4af4-90e6-e35b86e3b844@acm.org>
 <c1658336-f48e-5688-f0c2-f325fd5696c3@huaweicloud.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <c1658336-f48e-5688-f0c2-f325fd5696c3@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/25/23 04:51, Yu Kuai wrote:
> Are you still intrested in this patchset? I really want this switch in
> our product as well.
> 
> If so, how do you think about following changes, a new field in
> blk_mq_tag_set will make synchronization much eaiser.
Do you perhaps see the new field as an alternative for the
BLK_MQ_F_DISABLE_FAIR_TAG_SHARING flag? I'm not sure that would be an
improvement. hctx_may_queue() is called from the hot path. Using the
'flags' field will make it easier for the compiler to optimize that
function compared to using a new structure member.

Thanks,

Bart.
