Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D927C41513
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Aug 2023 17:53:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbjHNRxJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Aug 2023 13:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231682AbjHNRwx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Aug 2023 13:52:53 -0400
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 137CA10E5;
        Mon, 14 Aug 2023 10:52:49 -0700 (PDT)
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1bc3d94d40fso39799445ad.3;
        Mon, 14 Aug 2023 10:52:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692035568; x=1692640368;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MdAIHrxCDtbJFB+bjjGvaYp9s0dcVCNQWk34C/Zh6L0=;
        b=RylPiY4slPWmqFSYFIwMaJqIUc+RIIgw6ORO+vXDaAUj0P70aw8zltkJv31K5qGcqH
         qEOj/TfEYs1H4LS/KeAHC4fV6JvwXmA8K8wYZnZYZPm2LXDAfD90hdgz+LoIz3ZEqlPE
         /5gv/MLNQy8s0HKKun9iI8qZK1T9fGdWlO5gEclLYQcnpr9kVwOrAefpwNsVT/YAja9J
         Fa16+LXHxqZseMUjnzEXwwm4eQsr0QRk/mieL3/evK4g34IEaxgawKf2JYe00S53CyEA
         NpK2c1gWSGjnb111Qkd6exye0g9NuId1g8KOGJgvyMg8PttU38J7ZSzpPCvzv1Hty0P1
         NdNw==
X-Gm-Message-State: AOJu0Yzw4qc40JpwhcQy8Kj/KxQbBwtxrzQnTC1cPbN7Ctw0B0z6V534
        wJCOgt0uAqiPJYdtmyH8a3o=
X-Google-Smtp-Source: AGHT+IEuUoPcFdnrvWUq3quQblttMDVWELCZEnHVX+2iTd7Pl1tkBCj6eofjFYCK7JGtPH7M8+dxBw==
X-Received: by 2002:a17:902:d490:b0:1bd:e64c:5c7e with SMTP id c16-20020a170902d49000b001bde64c5c7emr3252821plg.61.1692035568480;
        Mon, 14 Aug 2023 10:52:48 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:e105:59a6:229c:65de? ([2620:15c:211:201:e105:59a6:229c:65de])
        by smtp.gmail.com with ESMTPSA id ji1-20020a170903324100b001b9cea4e8a2sm9686105plb.293.2023.08.14.10.52.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Aug 2023 10:52:47 -0700 (PDT)
Message-ID: <6cc02f16-97f2-113e-0ec6-ffd1a02916ae@acm.org>
Date:   Mon, 14 Aug 2023 10:52:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.1
Subject: Re: [PATCH v8 3/9] scsi: core: Call .eh_prepare_resubmit() before
 resubmitting
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230811213604.548235-1-bvanassche@acm.org>
 <20230811213604.548235-4-bvanassche@acm.org>
 <29cca660-4e66-002c-7378-2d2df5c79a08@kernel.org>
 <057e08f2-7349-bcad-c21d-11586c059fac@acm.org>
 <02d18d6a-ece5-f8f6-0c6c-4468c86c9ea1@kernel.org>
 <ee3e2f36-1089-f95c-8145-ea91d5912fde@acm.org>
 <5b6f882b-82ab-6a00-4a2d-4e93b8c1d973@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <5b6f882b-82ab-6a00-4a2d-4e93b8c1d973@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/13/23 21:18, Damien Le Moal wrote:
> I was more thinking of a mean to not call scsi_call_prepare_resubmit() at all if
> no zoned devices with use_zone_write_lock == true are involved.

That sounds easy to implement. I will include this change when I repost this
patch series.

Thanks,

Bart.


