Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497B239854;
	Wed, 31 Jan 2024 21:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706736765; cv=none; b=N7j334shQc4cQDXtc80tjg+QQB0G6hLf5LLxUya+J20pNmci9s46bHP1cc3OZuYiJImXV6ZikOUUBiI30fkBVz8kFsY57VC7arR/5BJedak6I5uad7utJku8uBO1cJsDHwswcbz1F5BRyfv7mdti1Ea4fzWO+gIzx/OtwirQr7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706736765; c=relaxed/simple;
	bh=9KaJ1NQ4uWjrCeAzMKubPLDIpfhEl6lq1rXXgQYZHHY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=klAwlhHQVI57PN2d058z0lLIHdkhUdTUnq751RBXyYdLCGQW6lgUl/m1S8wQsWDp5PKleGsWfhRlCupCh6ictM79x5sha+UftPbdcnb9s2cgv91h6QAcSjl9s7PCLVaQzULsFHxV4p8xb9+RRgrx+CD9RcodvLrLIQshX19NuJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-295a7fd8eecso146363a91.0;
        Wed, 31 Jan 2024 13:32:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706736763; x=1707341563;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5MwFWSTm8x1EYmd1E0khesOs7llM5BfsoMZnNZqeoV8=;
        b=ul4QhYCRkWYEodWcZmY0bf4eI1SJLzWB3NKsV2Psf3DD/ifBwhfw2vJAm57iTfnom7
         BpJUWnkwW38NajTyMyfAoOMCRtDZWapRpRGeCt60MSs2AmflejyhZDfltHAPHfj3vWsu
         8o/MOuQ3OQwuUiehOYv90xAWMlthCS7lqLJzxt3r9izHpCUtC+zGDTkGwrSkjzhrizCS
         9Dz88PBSubyL3PiLmGARkvnVWu6e0O/ndNJE0BygrSaqseKq1ZTBwztQ4P1jtkm+eQgK
         pDtkdejx/KrmaUHTUjOiDhPz7qtGoHOwiEQ3cGF1Z/dLUsavxMv+g1hqqPkamirVdzzi
         UKAg==
X-Gm-Message-State: AOJu0YxZzjmYrysVf4bVvmav7nKt4vCh7w4d8iVhdBajBNdcDTlWnG5K
	KfHCIaL12N/k3i6RW2f+Ka/upnsMmoeCQhVO1Mr7zavCOGB7zB1S
X-Google-Smtp-Source: AGHT+IGzvBwihM/L6P1J5chw10lzfw56+al91cf3mgzMFsL8RVmiy3S/tdW08rk0wyAzI7m74T/eyQ==
X-Received: by 2002:a17:90a:d811:b0:296:d85:d3d2 with SMTP id a17-20020a17090ad81100b002960d85d3d2mr262820pjv.34.1706736763405;
        Wed, 31 Jan 2024 13:32:43 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:1d95:ca94:1cbe:1409? ([2620:0:1000:8411:1d95:ca94:1cbe:1409])
        by smtp.gmail.com with ESMTPSA id mp4-20020a17090b190400b0029601383d02sm667121pjb.45.2024.01.31.13.32.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Jan 2024 13:32:42 -0800 (PST)
Message-ID: <d7c1f279-464d-4ecd-8e65-87d2ced984dc@acm.org>
Date: Wed, 31 Jan 2024 13:32:40 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/4] block: Make fair tag sharing configurable
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Ming Lei <ming.lei@redhat.com>, Keith Busch <kbusch@kernel.org>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Ed Tsai <ed.tsai@mediatek.com>, Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 "yukuai (C)" <yukuai3@huawei.com>
References: <0d23e3d3-1d7a-f76b-307b-7d74b3f91e05@huaweicloud.com>
 <f1cac818-8fc8-4f24-b445-d10aa99c04ba@acm.org>
 <e0305a2c-20c1-7e0f-d25d-003d7a72355f@huaweicloud.com>
 <aedc82bc-ef10-4bc6-b76c-bf239f48450f@acm.org>
 <20240118073151.GA21386@lst.de>
 <434b771a-7873-4c53-9faa-c5dbc4296495@acm.org>
 <20240123091316.GA32130@lst.de>
 <ac240189-d889-448b-b5f7-7d5a13d4316d@acm.org>
 <20240124090843.GA28180@lst.de>
 <38676388-4c32-414c-a468-5f82a2e9dda4@acm.org>
 <20240131062254.GA16102@lst.de>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240131062254.GA16102@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/30/24 22:22, Christoph Hellwig wrote:
> On Mon, Jan 29, 2024 at 04:03:11PM -0800, Bart Van Assche wrote:
>> Would you agree with disabling fair sharing entirely?
> 
> As far as I can tell fair sharing exists to for two reasons:
> 
>   1) to guarantee each queue can actually make progress for e.g.
>      memory reclaim
>   2) to not unfairly give queues and advantage over others
> 
> What are you arguments that we do not need this?

Regarding (1), isn't forward progress guaranteed by the sbitmap
implementation? The algorithm in __sbitmap_queue_wake_up() does not guarantee
perfect fairness but I think it is good enough to guarantee forward progress
of code that is waiting for a block layer tag.

Regarding (2), the fairness algorithm in the blk-mq code was introduced
before fairness of the sbitmap implementation was improved. See also commit
0d2602ca30e4 ("blk-mq: improve support for shared tags maps") from 2014 and
commit 976570b4ecd3 ("sbitmap: Advance the queue index before waking up a
queue") from 2022. The current code in the sbitmap implementation is
probably good enough if request queues share a tag set. It would be
interesting to verify this with two null_blk driver instances with
shared_tags and different completion_nsec values.

Thanks,

Bart.

