Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04CC5C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Oct 2022 21:39:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbiJSVjI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Oct 2022 17:39:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231223AbiJSVjH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Oct 2022 17:39:07 -0400
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 544F51974E7
        for <linux-scsi@vger.kernel.org>; Wed, 19 Oct 2022 14:39:06 -0700 (PDT)
Received: by mail-pf1-f171.google.com with SMTP id y8so18429804pfp.13
        for <linux-scsi@vger.kernel.org>; Wed, 19 Oct 2022 14:39:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Uf4bKbERnz0CTxr7JiU1eWgzpd5a5AfRTHnl/HC78yc=;
        b=WEjMJ5uj1ZbtyEs3S+hb/uhYb3WwucyQ+yOp08iinSX+4hmGfesTiHP8/jBpJqF1pZ
         n0ufAPdL9rNUI1rSRDi5ElngYcAqjSGejVAbgtG0EEQSoPF85I4uHg39QjvqnG3x1RF6
         9gwZTlUxsmiSDzg8Qv9iUvG0g0JKNagXBkm4G55XoylAMfNNxCCf+Aw9FBPsqo+VzCk8
         FnU7DKHkJMm64Bchtk6nugXY/r+II33VONFqP9zWcuppDtZuJ6mi9vYOSASYW3FYi5hb
         HItDM44jC/AFXlu6WQsPDNb5BvOCX+S2VATgxObqvR5kdKKNNhp8wLWEPx2NyJSdptJH
         iigQ==
X-Gm-Message-State: ACrzQf08jTw/CkwUJZfQUqoEdFvaiA+sWM5LXWXXdyEwdHijQOkF5UvW
        sX1bLtF05KsSkZZv18tdCO4=
X-Google-Smtp-Source: AMsMyM7tdsDiSBBow+PbXMdiNTIW3SsOjTtB9WPyNC+nVQsfnOwjDOUwr0F7QDsQkBzyaS7fHWfesg==
X-Received: by 2002:a63:5243:0:b0:43c:96a:8528 with SMTP id s3-20020a635243000000b0043c096a8528mr8841084pgl.47.1666215545759;
        Wed, 19 Oct 2022 14:39:05 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:8280:2606:af57:d34? ([2620:15c:211:201:8280:2606:af57:d34])
        by smtp.gmail.com with ESMTPSA id o12-20020a170902d4cc00b0016d9d6d05f7sm11299305plg.273.2022.10.19.14.39.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Oct 2022 14:39:04 -0700 (PDT)
Message-ID: <90c6275c-1be3-a975-acd3-32ef96174fba@acm.org>
Date:   Wed, 19 Oct 2022 14:39:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v4 36/36] scsi: Add kunit tests for scsi_check_passthrough
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221016195946.7613-1-michael.christie@oracle.com>
 <20221016195946.7613-37-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221016195946.7613-37-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/16/22 12:59, Mike Christie wrote:
> +config SCSI_KUNIT_TEST
> +	bool "KUnit tests for SCSI Mid Layer" if !KUNIT_ALL_TESTS
> +	depends on SCSI && KUNIT
> +        default KUNIT_ALL_TESTS

Is it on purpose that spaces are used to indent the above line instead 
of a tab?

> +	help
> +	  Run SCSI Mid Layer's KUnit tests.
> +

[ ... ]

> diff --git a/drivers/scsi/scsi_test_error.c b/drivers/scsi/scsi_test_error.c

Isn't the convention to use the "_test.c" suffix for unit tests 
(scsi_test_error.c -> scsi_error_test.c)?

> + * KUnit tests for the scsi_error.c.

Should "the" perhaps be left out from the above line?

Otherwise this patch looks good to me.

Thanks,

Bart.
