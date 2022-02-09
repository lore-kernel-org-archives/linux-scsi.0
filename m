Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 092B7C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 00:24:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234048AbiBIAYg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 19:24:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbiBIAYf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 19:24:35 -0500
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48695C06157B
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 16:24:35 -0800 (PST)
Received: by mail-pj1-f41.google.com with SMTP id c5-20020a17090a1d0500b001b904a7046dso1972102pjd.1
        for <linux-scsi@vger.kernel.org>; Tue, 08 Feb 2022 16:24:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=FldS+rOSo1WxI96jAdmEPgEMac4qXzh8efmnm+VNH/w=;
        b=JtY/sLvmJIa/ovrmmWRZUQF13n38fEa9mH1zUzfAFNvklGUfU5CsR+ehhhBuz7Wgk6
         Va6UekXjDxkt3QKhBw+JWXjwxdBjkbAd7vB8zwoKqexbf3pPKdaZbFa3Bmb/tz4RjLR2
         CagkZP0E/d9TvkZbgdpt8xRLaJUkywx7G57CilmIsdXavp5YlTbvO4JwXhSv5vltpMXE
         Q4Jk7mEBcvwiu+CPOiH8WJVJxXB4zYE4HYDG/QQcxgQC4teAGHQ+kLqEz+ji8J1QY3nq
         z4UXYkJNxNiFXZXbz2eqeDamEzdi6yHmGeZx0Nhqz1rYHTIJiIm3O+a0DuQyUBoTaOJr
         htMA==
X-Gm-Message-State: AOAM533S/GQHq2DZ897RLlMlTT9TZlP1elfELvBEPdQwmet8I/VpMl67
        X3BQ7+XqDFIKWdPRGVsCEIQ=
X-Google-Smtp-Source: ABdhPJwh7dUl6LXz+6moE1tgKNP1Rg8hO116SXOog0lPoRYkQfodUiRv7cAD5fRxg4YpC22VLW1Img==
X-Received: by 2002:a17:90a:5984:: with SMTP id l4mr577314pji.80.1644366274623;
        Tue, 08 Feb 2022 16:24:34 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id a20sm11037238pfv.150.2022.02.08.16.24.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Feb 2022 16:24:33 -0800 (PST)
Message-ID: <5d074125-7905-3d81-2b98-5aa152b803de@acm.org>
Date:   Tue, 8 Feb 2022 16:24:32 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v2 44/44] scsi: core: Remove struct scsi_pointer from
 struct scsi_cmnd
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.com>,
        Christoph Hellwig <hch@lst.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-45-bvanassche@acm.org>
 <61a02adf-823d-a933-8efd-4e0aa85873d5@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <61a02adf-823d-a933-8efd-4e0aa85873d5@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/8/22 09:54, John Garry wrote:
> On 08/02/2022 17:25, Bart Van Assche wrote:
>>       /*
>> -     * The following fields can be written to by the host specific code.
>> -     * Everything else should be left alone.
>> +     * The fields below can be modified by the SCSI LLD but the fields
>> +     * above not.
> 
> "but the fields above not" - this sounds a bit odd, maybe this is 
> better: "but the fields above may not be modified"

may not -> must not? See also https://en.wiktionary.org/wiki/must_not. 
Anyway, I can make that change.

> And I don't think that we need to mention SCSI in that comment ..

I can leave the word "SCSI" out.

Thanks,

Bart.
