Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2D20C4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Nov 2022 22:50:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbiKBWux (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Nov 2022 18:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbiKBWuw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Nov 2022 18:50:52 -0400
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21FCC959B;
        Wed,  2 Nov 2022 15:50:50 -0700 (PDT)
Received: by mail-pg1-f171.google.com with SMTP id h193so104536pgc.10;
        Wed, 02 Nov 2022 15:50:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oi/++AM86hQyi+QYKhOHsLnIasDTZEsqZxanEFqTzjY=;
        b=n8TKHQAVxbAcOckx45tiahsOCldnWRsb18PyqcsxH2JSgQlKQZG1gecSZBSIuTFSau
         260RKgaIp5mRImixuPxUufxf2JFotfqrFDtyFuWUXsJ/vL4DnMDDt6bIyaChNTnWn8z5
         CnweVmOCZ34GjeMH30vcLpkwICYo9zG+zDKaDbDwm83BpT0zLEkttZP2t0o3F02tMSxF
         Wtew8JTMb4B9hBXkBBjL9TUdShIfjZJI0TvQgdCPgugof8XCE5JYIXySXmh9xkT+crIR
         ihRrWGAvIs+79YsAHZLE8WmNAdj5nt+5vPvWsmGjnKMLtYNi86BinsG/d2+mWRtYsSpQ
         NPQA==
X-Gm-Message-State: ACrzQf1KHdLhjoHVqalG+bjez6bH5xTp1JIOaNWclIvUiqG0wZj9S1mQ
        bRM0q9whZ6IdgjJP4n2KYTo5NbIFKIc=
X-Google-Smtp-Source: AMsMyM6bPaD6vkm2t6htya5qjFAYxNj4UjVLLKBnOw0YiQYnA2cdZTgepQevyScmNi+GFrRNkBEHRA==
X-Received: by 2002:a63:5909:0:b0:46e:c98d:e07c with SMTP id n9-20020a635909000000b0046ec98de07cmr23719156pgb.530.1667429449450;
        Wed, 02 Nov 2022 15:50:49 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:22d3:f380:fa84:4b89? ([2620:15c:211:201:22d3:f380:fa84:4b89])
        by smtp.gmail.com with ESMTPSA id f26-20020aa7969a000000b0056bfd4a2702sm8928050pfk.45.2022.11.02.15.50.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Nov 2022 15:50:48 -0700 (PDT)
Message-ID: <6faaba2b-5fb3-7121-5796-af2b2f73b6e7@acm.org>
Date:   Wed, 2 Nov 2022 15:50:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v3 01/19] block: Add PR callouts for read keys and
 reservation
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
References: <20221026231945.6609-1-michael.christie@oracle.com>
 <20221026231945.6609-2-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221026231945.6609-2-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/26/22 16:19, Mike Christie wrote:
> +struct pr_keys {
> +	u32	generation;
> +	u32	num_keys;
> +	u64	keys[];
> +};
> +
> +struct pr_held_reservation {
> +	u64		key;
> +	u32		generation;
> +	enum pr_type	type;
> +};
> +
>   struct pr_ops {
>   	int (*pr_register)(struct block_device *bdev, u64 old_key, u64 new_key,
>   			u32 flags);
> @@ -14,6 +26,18 @@ struct pr_ops {
>   	int (*pr_preempt)(struct block_device *bdev, u64 old_key, u64 new_key,
>   			enum pr_type type, bool abort);
>   	int (*pr_clear)(struct block_device *bdev, u64 key);
> +	/*
> +	 * pr_read_keys - Read the registered keys and return them in the
> +	 * pr_keys->keys array. The keys array will have been allocated at the
> +	 * end of the pr_keys struct and is keys_len bytes. If there are more
> +	 * keys than can fit in the array, success will still be returned and
> +	 * pr_keys->num_keys will reflect the total number of keys the device
> +	 * contains, so the caller can retry with a larger array.
> +	 */
> +	int (*pr_read_keys)(struct block_device *bdev,
> +			struct pr_keys *keys_info, u32 keys_len);
> +	int (*pr_read_reservation)(struct block_device *bdev,
> +			struct pr_held_reservation *rsv);
>   };

Is there any pr_read_keys() implementation that won't have to divide 
@keys_len by 8? How about leaving out that argument and making callers 
store the number of elements in the keys[] array in the num_keys member 
before calling pr_read_keys()?

Thanks,

Bart.

