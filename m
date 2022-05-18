Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A3EEC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 18 May 2022 22:39:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbiERWjN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 May 2022 18:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbiERWjL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 May 2022 18:39:11 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38F917D3A3
        for <linux-scsi@vger.kernel.org>; Wed, 18 May 2022 15:39:10 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id p8so3435000pfh.8
        for <linux-scsi@vger.kernel.org>; Wed, 18 May 2022 15:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=TwGOpsZXmKjMebcqrmfjeutofyqjwqigUU8vU4Hxsjg=;
        b=ltO2bQWW4c9ju/2uK55hWAnRfjLi5f6mWGgzjz+VPPbGZ9A+Y4IqXH3hn1+sOU0dgX
         3kzudr1+8/ovu8n19SlVF4F8g6lWWCnvNZPtj3FENTwMhz8oV2+JX2J/wfE0MHsroYv1
         65ezdDzYMJ03lYT5W919MXR/+aWgKuaOxk7wQjYfWH1DNzxQMqo5WPFH5lF4J0Q1VkAB
         LWjqwoh+x5b10U22YJQQAzXg0sMYMTmi8g3MWKaaOa3ejSvZfPrziZmGewd6tMdd4XXG
         YTJRg1XzLyscAApvAZ5nzeisLEfndH+iMkGbPUIDOV+dJq8SJKLwZRllbeuf/Y5cS3vN
         ZYUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=TwGOpsZXmKjMebcqrmfjeutofyqjwqigUU8vU4Hxsjg=;
        b=mfVzoylgNN6FmnPzN2sWP16UJia8Im2/pfmqinZLq5jb3UT6YI8T7euYaIhYZgJJAa
         HDCbG45TVxF2XApMEMpg7ntEALJW3zfuNxxY+W68LIWQGj+Xi0FDYyt9YxA3QVJTHJHk
         poCovxZ9xlQ4bbbEk8B+1XN0c/rWPgDZxsRfTlwh0KszETDSfyuF70cJjOjpPDzhEbga
         jqcv6iEVkYD9XU/AhTmqbIl5nk1wYqdeF44xsaVmI0S569pYHr+oQkBd98xp0KaARnEH
         yfputaZ2jf6fTSYR+3iP0KaUD109+jpDN5fzxpEK88MI9OPNw7PlJnR0ZMCCUSq7X0dd
         soUA==
X-Gm-Message-State: AOAM532guOb0DFXdDXznfD9ctp0K1qV/gEpPs4+b7fM/bbI4MeDStCcQ
        ZNNSF4cxLCiUahzlKDqbtw2seg==
X-Google-Smtp-Source: ABdhPJy7E1edQgt3ih3y4+NE5mAm66sIVfltCyXZCC1mkjHKtj6Ok+XbL/9nyPA5caK7Eaik3CwV4g==
X-Received: by 2002:a05:6a02:208:b0:3c6:9898:e656 with SMTP id bh8-20020a056a02020800b003c69898e656mr1406244pgb.560.1652913550177;
        Wed, 18 May 2022 15:39:10 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id u1-20020a170903108100b0015f2b3bc97asm2147095pld.13.2022.05.18.15.39.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 May 2022 15:39:09 -0700 (PDT)
Message-ID: <c412b561-defe-dd86-1d4a-14dc10fc20fb@kernel.dk>
Date:   Wed, 18 May 2022 16:39:08 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 1/3] blk-mq: remove __blk_execute_rq_nowait
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
References: <20220517064901.3059255-1-hch@lst.de>
 <20220517064901.3059255-2-hch@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220517064901.3059255-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/17/22 12:48 AM, Christoph Hellwig wrote:
> +	} else {
> +		/*
> +		 * Prevent hang_check timer from firing at us during very long
> +		 * I/O
> +		 */
> +		unsigned long hang_check = 
> +			sysctl_hung_task_timeout_secs;

Trailing whitespace and odd formatting here, I fixed it up.

-- 
Jens Axboe

