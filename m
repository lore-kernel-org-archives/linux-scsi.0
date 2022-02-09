Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5A35C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 18:27:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232235AbiBIS1O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 13:27:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231371AbiBIS1N (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 13:27:13 -0500
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE7B1C0613C9
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 10:27:16 -0800 (PST)
Received: by mail-pf1-f179.google.com with SMTP id x15so3323673pfr.5
        for <linux-scsi@vger.kernel.org>; Wed, 09 Feb 2022 10:27:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IOadrRpAawF/EowwiW3O7pe19UMYtVnWkTsKE3g0yTY=;
        b=xHLeu/bPFU39ZaSJlgh2IZwUyTjFL3juChZFzkGDA9NHe/Cv55xwFBFfr4Gjz4llg0
         gW5IjO8KTKQoyf+u8k3uk7Ep01gariFCrJ+XZdbjukMCuPJMVC5dGs8b0F1kRrmIDHPY
         fELp/FiZdC2rUz6MYiXLRazKN4DZ3+GrVDj0oICqe1KajsaWmQmhFgizyyqxWcYTRL3I
         9qJjldFUbRtjOSE1aiBjGf4oJWrFV4L+bhXRC2fuvAR7N+z2G1cgTyDR6s2A5GfWrENR
         jBnMAvjopMRILKl0tfd5DLT4YTH4TaYErzwCDobvrpuoVx21CKDiv1He4rDyZj4tDCDF
         ScyQ==
X-Gm-Message-State: AOAM530zmkZb/YDK6ruYs7WSkuziYiW1kBvku0u1161gdhImirQjsVE+
        LuTqONojQVe5TwEfBx0XRpY=
X-Google-Smtp-Source: ABdhPJwlVOZace1fq4YmXlqiJVF1MnKNmTRtYBKiT1Wh7a4XKYMwpLbL6lDDeb0MmZkOwuqnJSr6SQ==
X-Received: by 2002:a65:4286:: with SMTP id j6mr2875433pgp.619.1644431236342;
        Wed, 09 Feb 2022 10:27:16 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id h26sm14534837pgm.72.2022.02.09.10.27.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Feb 2022 10:27:15 -0800 (PST)
Message-ID: <05d0a3ab-ac64-5f59-8e4f-25cff2c8ce8a@acm.org>
Date:   Wed, 9 Feb 2022 10:27:14 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v2 21/44] imm: Move the SCSI pointer to private command
 data
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-22-bvanassche@acm.org>
 <9a73879b-cc52-0db3-5fe6-d3226ad709fc@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <9a73879b-cc52-0db3-5fe6-d3226ad709fc@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/8/22 23:58, Hannes Reinecke wrote:
> On 2/8/22 18:24, Bart Van Assche wrote:
>> +struct imm_cmd_priv {
>> +    struct scsi_pointer scsi_pointer;
>> +};
>> +
> Why the indirection?
> You can use 'struct scsi_pointer' directly as payload, no?

The indirection makes it easy to add more private command data in the 
future. However, I don't have a strong opinion about this. I can remove 
the indirection if you prefer this?

Thanks,

Bart.
