Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AD0BC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Nov 2023 18:38:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233818AbjKNSim (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Nov 2023 13:38:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbjKNSim (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Nov 2023 13:38:42 -0500
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B9A511D
        for <linux-scsi@vger.kernel.org>; Tue, 14 Nov 2023 10:38:39 -0800 (PST)
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1cc5916d578so53228835ad.2
        for <linux-scsi@vger.kernel.org>; Tue, 14 Nov 2023 10:38:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699987119; x=1700591919;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hy1n0/8u3PwF6j6276DbIjmSec9r2RIIuDvVnbpQa1c=;
        b=RveEfpGigud2L0YgA1XW4AV+62RQLl6/X5OesHvBUC6mL7P3alGq4NiJYsYFFFTH2e
         iiFJUVfZitDvRRYltURP1XJqNvBk5xJPRaINjDxZDzX9Vp/VHLzec356tYwX6+c1GN4S
         l4sBKLAZVBlXGR9YyTnhI4awJbN8SnTjhEZdINQm25aBcbohdJ/Dyyf0PiIY07GeK7bF
         +zlkvfH2J2Ao3NWvNlpe96QSaIGp29Fu+d1uwQdUi60Ugqf9Ud8+5rEKoYPA+ve0iRUJ
         AKhhNpGj+BKsFz4zwqj7ANMogbm9F7FrgD17bFbtp8U5RuKLy0ZcQ1N5kgCBH42Rg/Wh
         0/xA==
X-Gm-Message-State: AOJu0YzFABUyYBj/Bv+VsJpds8IyYoYIMVGmiEaYz7dgd+nhYL77bjE9
        UAy2hx0o79ivJthuWiKZgtY=
X-Google-Smtp-Source: AGHT+IGprhxDBxW1SxnXmowmM8qUMtwSha7jTXx9bezDV8274sbthwDFAkoK88Glfvmw+BT0NebnZg==
X-Received: by 2002:a17:902:9f97:b0:1cc:6dd3:e73c with SMTP id g23-20020a1709029f9700b001cc6dd3e73cmr3145683plq.49.1699987118728;
        Tue, 14 Nov 2023 10:38:38 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:2278:ad72:cefb:4d49? ([2620:0:1000:8411:2278:ad72:cefb:4d49])
        by smtp.gmail.com with ESMTPSA id n2-20020a1709026a8200b001c44dbc92a2sm5932457plk.184.2023.11.14.10.38.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Nov 2023 10:38:38 -0800 (PST)
Message-ID: <be65d44e-671d-48dc-906d-8cf04e8ae234@acm.org>
Date:   Tue, 14 Nov 2023 10:38:36 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 20/20] scsi: Add kunit tests for
 scsi_check_passthrough
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        john.g.garry@oracle.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20231114013750.76609-1-michael.christie@oracle.com>
 <20231114013750.76609-21-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20231114013750.76609-21-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/13/23 17:37, Mike Christie wrote:
> Add some kunit tests for scsi_check_passthrough so we can easily make sure
> we are hitting the cases it's difficult to replicate in hardware or even
                      ^^^^^^^^^^

It seems like the words "for which" are missing here?

> +config SCSI_KUNIT_TEST
> +	tristate "KUnit tests for SCSI Mid Layer" if !KUNIT_ALL_TESTS
> +	depends on KUNIT
> +	default KUNIT_ALL_TESTS
> +	help
> +	  Run SCSI Mid Layer's KUnit tests.
> +
> +	  If unsure say N.
> +

Is a help text required for KUNIT Kconfig entries or is this something that
can be left out?

Please rename SCSI_KUNIT_TEST into SCSI_LIB_KUNIT_TEST such that different
unit tests can be selected individually. More tests will be added by my
patch series that improves zoned write performance.

Thanks,

Bart.
