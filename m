Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AEE6C2BB3F
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Nov 2023 18:19:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbjKOSTw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Nov 2023 13:19:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbjKOSTw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Nov 2023 13:19:52 -0500
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EDA392;
        Wed, 15 Nov 2023 10:19:49 -0800 (PST)
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1cc3bb32b5dso63044415ad.3;
        Wed, 15 Nov 2023 10:19:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700072389; x=1700677189;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xu9O9Nln1wU6y4juhkOBPBC3HRW1CFO00oTOdXu/JNQ=;
        b=LmsiijdW8TGu0r+Ie6+VsGnmbHOWYEsp4gW3rRFlftRY1QuuUfZMCRCUC/QxdmiAvw
         I+Y4OkIqbRQEwexT0/Q3UmhyJH5hR/Dyl2xtmjBuNvyE1BKHqQICPkM7sATc+iFj2if5
         4dvaa7PyeTTpj/QFny0rJ1c62bqsD49UdhBNMwCphkQDdQQT7plBSceJ1jQgK7v3EyWU
         1G1qRgxocquq/nh2TFlGP+EvvzFEYlnN1D7z30XN/S5O3d9vrZKmSiHQ2r6mHQEJ8M5Q
         KFtD4OpBDroJt0dfixpN5DRfhNft04i9pl19pvDqp8NYmooBuFzjhuskfNTtGU1iT3BD
         NiYA==
X-Gm-Message-State: AOJu0YwUs2TFF8Z9fueb1rl7Q/jSz5McBmuCrr0F+dFOLf+CaFp3O/OX
        ZAZDLS4Im7rGOagnzThIAls=
X-Google-Smtp-Source: AGHT+IGs8YzooTgz6hrSHIo9UVMZhw1YJkPM3x3d7opMUtrNVmXLibid4Z/xmGE5xsQc/J7oKJJ0/Q==
X-Received: by 2002:a17:902:f707:b0:1cc:6e8f:c14e with SMTP id h7-20020a170902f70700b001cc6e8fc14emr7892380plo.15.1700072388660;
        Wed, 15 Nov 2023 10:19:48 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:56f1:2160:3a2a:2645? ([2620:0:1000:8411:56f1:2160:3a2a:2645])
        by smtp.gmail.com with ESMTPSA id ju10-20020a170903428a00b001c59f23a3fesm7509476plb.251.2023.11.15.10.19.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Nov 2023 10:19:47 -0800 (PST)
Message-ID: <d706f265-f991-45c0-a551-34ecdee55f7c@acm.org>
Date:   Wed, 15 Nov 2023 10:19:45 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/3] scsi: core: Support disabling fair tag sharing
Content-Language: en-US
To:     Yu Kuai <yukuai1@huaweicloud.com>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Keith Busch <kbusch@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Ed Tsai <ed.tsai@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        "yukuai (C)" <yukuai3@huawei.com>
References: <20231114180426.1184601-1-bvanassche@acm.org>
 <20231114180426.1184601-3-bvanassche@acm.org>
 <80dee412-2fda-6a23-0b62-08f87bd7e607@huaweicloud.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <80dee412-2fda-6a23-0b62-08f87bd7e607@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/14/23 23:24, Yu Kuai wrote:
> 在 2023/11/15 2:04, Bart Van Assche 写道:
>> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
>> index d7f51b84f3c7..872f87001374 100644
>> --- a/drivers/scsi/hosts.c
>> +++ b/drivers/scsi/hosts.c
>> @@ -442,6 +442,7 @@ struct Scsi_Host *scsi_host_alloc(const struct scsi_host_template *sht, int priv
>>       shost->no_write_same = sht->no_write_same;
>>       shost->host_tagset = sht->host_tagset;
>>       shost->queuecommand_may_block = sht->queuecommand_may_block;
>> +    shost->disable_fair_tag_sharing = sht->disable_fair_tag_sharing;
> 
> Can we also consider to disable fair tag sharing by default for the
> driver that total driver tags is less than a threshold?
I don't want to do this because such a change could disable fair tag
sharing for drivers that support both SSDs and hard disks being associated
with a single SCSI host.

Thanks,

Bart.
