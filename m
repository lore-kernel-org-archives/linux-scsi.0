Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F329239ACD;
	Wed, 31 Jan 2024 21:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706737356; cv=none; b=oH9jbPtQCZmYhBnWmn6CF2okUDxTEZLafWLq2rRE3/CKYQ267SimEyuWaD1xn5LQSwmlQSfGypGqlFo9eZtsZbImrH67R4KlpIn8Qu9wHRTTOL7kq4EHn/8nhCw7+SQO0y36cFZvEmL/dn5QFG9GD+7z/Ia0PG8ogrH6vJTxUKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706737356; c=relaxed/simple;
	bh=NR/hM42mf+zpAKe3h/mi6wOp69kJYWSJyh/Xm04dLVE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OQ8V7t1vLcqkif4s2/jxL+wysJ8mAEx8w+ZScHRrAef2kJCh3zpNR5k/r5VSCjHJ8BbBbTr1oHaTaLVT9owDxOdiYSYjISQPJCK+ztT8vfgzHZG5HRaYf9EZQ425mMHJiNOxIbM7w1qgem+vS4Tq1h4HKMd6RKdczME/Rh7BYEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.161.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-59a9304aef0so150605eaf.1;
        Wed, 31 Jan 2024 13:42:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706737354; x=1707342154;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NR/hM42mf+zpAKe3h/mi6wOp69kJYWSJyh/Xm04dLVE=;
        b=LV+bl1Bm7It+mxACERehkaKS1llSnKuMErn1s4RgE7jr5wir+rxr7oz3txgRNDN9X9
         khrvONfBnAsnEF1Uo/+juvJ0VtlKQcvIR1PR3OANz2+/PfyymgMPSPtfAvzi47pflQE0
         G6NvNBpMYu/50v8iff3HKQOA/ApcH0fA9TY7304TKFMoljt2rezJIHiNoJ+lODSPWMDk
         xkrRBjBrPFg+CSNdpFpk+ijKpUP2Y6UmooDmLr29GDmR+U9WpHL4y+/znRfe4YdvXPUi
         Epv3JBjGLR1vwEp8M3KZAJQwTv1B9iNvtylcbcHtj9boW3LoegeSN8UAXNErmgGPkUqA
         U8Vg==
X-Gm-Message-State: AOJu0YxrUWbytVw9LkCmejicxcqRB+Ch2kJ8uV5+ImX4JZdzMBB30i5N
	JMEgKKtmsl3Mp8c+PfS1E7mq6dHY97l5NV5nWTKU4JNbGiUhhQn1
X-Google-Smtp-Source: AGHT+IGMpTyvewWCm2i8935qebnXvENDIkUuaSZVucF0ukCgIcRkIAZqmQyXj22lKZT9HdhSSZJz5w==
X-Received: by 2002:a05:6358:7215:b0:178:a202:66b1 with SMTP id h21-20020a056358721500b00178a20266b1mr2788111rwa.25.1706737353717;
        Wed, 31 Jan 2024 13:42:33 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:1d95:ca94:1cbe:1409? ([2620:0:1000:8411:1d95:ca94:1cbe:1409])
        by smtp.gmail.com with ESMTPSA id v12-20020a056a00148c00b006de11c980e5sm8680687pfu.80.2024.01.31.13.42.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Jan 2024 13:42:32 -0800 (PST)
Message-ID: <c2469774-8ebb-4faf-af3b-c9426b8591d4@acm.org>
Date: Wed, 31 Jan 2024 13:42:30 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/4] block: Make fair tag sharing configurable
Content-Language: en-US
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Yu Kuai <yukuai1@huaweicloud.com>,
 Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>, Ming Lei <ming.lei@redhat.com>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Ed Tsai <ed.tsai@mediatek.com>, Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 "yukuai (C)" <yukuai3@huawei.com>
References: <e0305a2c-20c1-7e0f-d25d-003d7a72355f@huaweicloud.com>
 <aedc82bc-ef10-4bc6-b76c-bf239f48450f@acm.org>
 <20240118073151.GA21386@lst.de>
 <434b771a-7873-4c53-9faa-c5dbc4296495@acm.org>
 <20240123091316.GA32130@lst.de>
 <ac240189-d889-448b-b5f7-7d5a13d4316d@acm.org>
 <20240124090843.GA28180@lst.de>
 <38676388-4c32-414c-a468-5f82a2e9dda4@acm.org>
 <20240131062254.GA16102@lst.de>
 <d7c1f279-464d-4ecd-8e65-87d2ced984dc@acm.org>
 <Zbq9kVEZZBD4m4ZY@kbusch-mbp.dhcp.thefacebook.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <Zbq9kVEZZBD4m4ZY@kbusch-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/31/24 13:37, Keith Busch wrote:
> What if all the tags are used by one queue and all the tags are
> performing long running operations? Sure, sbitmap might wake up the
> longest waiter, but that could be hours.

I have not yet encountered any storage driver that needs hours to
process a single request. Can you give an example of a storage device
that is that slow?

Bart.
