Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CBBEC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Mar 2022 05:07:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237978AbiCDFHu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Mar 2022 00:07:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237971AbiCDFHo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Mar 2022 00:07:44 -0500
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EA8F17E356
        for <linux-scsi@vger.kernel.org>; Thu,  3 Mar 2022 21:06:57 -0800 (PST)
Received: by mail-pl1-f169.google.com with SMTP id z11so6761646pla.7
        for <linux-scsi@vger.kernel.org>; Thu, 03 Mar 2022 21:06:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Iyg0lLG0agtvt+YAP/2UVsFJHIF67Oxeov3ak6OfnXs=;
        b=fGP0ZON3lbomrHUTfEF3gQ07HH3OoIruneC8DFRu72Rl5UbPIwZatrl5qLkzx+5QVH
         JeD0V+yML2XKihsdI9ausdKLjpdpRA/QIpswj4GW0fVyUyZA5lG6IEzpgmWVRfpZm7aE
         mu3bNXSK4AmRBRGgF/esPZv2ZUv2E7Ar4Ggv8AAnPvRyqwwgmLqiBMpihnuAZ4hk+fDN
         UtiJwO31uC4EVbAFa6EWelMFWiy1buk8XNshKOX3I28iBf8zjgB4YZ/p66kxd28SB4gP
         509C4PDi+G5B6j0d9iTk8oeNl98CK3Arx5LqALdllK75JborUqZhmb1DUZkge7HWKTkd
         VbNg==
X-Gm-Message-State: AOAM532m+FgCJRVpyNvsPxo4eHidBC7F+cPhbPfD1cleWv15Dj1RuL0T
        K1RI4N1t6SxxUDJwR9nYxRI=
X-Google-Smtp-Source: ABdhPJzpUy38JpJk9sWE0Pr6t6mSCEGhwWqPXCAgtN4ks/CN8LUmZIEM+IONtIl/61TmLgKp/5I3CQ==
X-Received: by 2002:a17:902:f684:b0:151:93ab:3483 with SMTP id l4-20020a170902f68400b0015193ab3483mr13639237plg.4.1646370416329;
        Thu, 03 Mar 2022 21:06:56 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id k190-20020a633dc7000000b0037c921abb5bsm868117pga.23.2022.03.03.21.06.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Mar 2022 21:06:55 -0800 (PST)
Message-ID: <ad4bba42-291f-fea6-0ee7-39d0d9286b37@acm.org>
Date:   Thu, 3 Mar 2022 21:06:53 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 08/14] scsi: sd: Optimal I/O size should be a multiple of
 reported granularity
Content-Language: en-US
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bernhard Sulzer <micraft.b@gmail.com>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
 <20220302053559.32147-9-martin.petersen@oracle.com>
 <8459576c-3f04-14d1-24d2-0edfd814a454@acm.org>
 <yq1bkymtmbp.fsf@ca-mkp.ca.oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <yq1bkymtmbp.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/3/22 19:45, Martin K. Petersen wrote:
>> On 3/1/22 21:35, Martin K. Petersen wrote:
>>> +	if (min_xfer_bytes && opt_xfer_bytes & (min_xfer_bytes - 1)) {
>>> +		sd_first_printk(KERN_WARNING, sdkp,
>>> +				"Optimal transfer size %u bytes not a " \
>>> +				"multiple of preferred minimum block " \
>>> +				"size (%u bytes)\n",
>>> +				opt_xfer_bytes, min_xfer_bytes);
>>> +		return false;
>>> +	}
>>
>> Hmm ... what guarantees that min_xfer_bytes is a power of two? Did I
>> perhaps overlook something?
> 
> Nothing in the spec, obviously, but I think we'd have a lot of headaches
> further up the stack if that wasn't the case.
> 
> Do you know of any devices that report something unusual here?

Hi Martin,

I'm not aware of any devices that report an unusual OPTIMAL TRANSFER LENGTH 
GRANULARITY value.

Since this code is not in the hot path, how about using the modulo operator 
instead of binary and?

Thanks,

Bart.


