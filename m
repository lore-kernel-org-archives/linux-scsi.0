Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3856FC0015E
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Aug 2023 18:24:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbjHASYa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Aug 2023 14:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231734AbjHASY3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Aug 2023 14:24:29 -0400
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72510213D
        for <linux-scsi@vger.kernel.org>; Tue,  1 Aug 2023 11:24:21 -0700 (PDT)
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6874d1c8610so1278353b3a.0
        for <linux-scsi@vger.kernel.org>; Tue, 01 Aug 2023 11:24:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690914261; x=1691519061;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1R19dJl8Oxllgeh2tsReZOY+mg5ktVL7w4u0zQtaD3E=;
        b=hFrqaqnRa0C0HEkXxwfgQ2DxbOHL2Y7fW3jPr6d+y2dxnOxOorYLRIkvoF4Yq0osJ3
         OlQ4AXzR4lXJlAb634Fhso98l5tF/jfDbOUZIJ1kxHfqeuNFaPxR4fXjZjkNlm1zsTqj
         JresgDZPXFxkGWUFZ9pqNZl0Fc53Mlsp8+b9gtLh99rsIVeqSNX1vbxy3YkwoN1mGUs5
         f+1E0VFz263L2bJvhKJbSVRuDRB81vbMlGUR4jpD+60FUIt3TowIZx/lPXvHYXhcjhs0
         JafshONYOfojyva7kGOSNr9J/cZ0N34pvqM4RDmNhjPi5o5lg1OXo22Z9e6C4rb9K02t
         Hwdg==
X-Gm-Message-State: ABy/qLbuaqUE09Ql8MJYS7VacWv2HsHh09H1dEHi1oxhPncd/+lBcD1+
        vXS8Kx5eoaIeMxJiErIlu/M=
X-Google-Smtp-Source: APBJJlHdjtxlz1fXBmWYbIixyQ1A+4h0hwRruwEFvlFUnwaKMUeCwV/18zzWIcEChU/8XOzLb9uSFQ==
X-Received: by 2002:a05:6a00:a85:b0:668:69fa:f78f with SMTP id b5-20020a056a000a8500b0066869faf78fmr15572696pfl.1.1690914260707;
        Tue, 01 Aug 2023 11:24:20 -0700 (PDT)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id e18-20020a62aa12000000b006875493da1fsm1514553pff.10.2023.08.01.11.24.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Aug 2023 11:24:20 -0700 (PDT)
Message-ID: <e1b78551-a476-436c-7a80-229f1260279d@acm.org>
Date:   Tue, 1 Aug 2023 11:24:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH -next] SCSI: fix possible memory leak while device_add()
 fails
Content-Language: en-US
To:     Zhu Wang <wangzhu9@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, gregkh@suse.de, kay.sievers@vrfy.org,
        tonyj@suse.de, linux-scsi@vger.kernel.org
References: <20230801095357.44778-1-wangzhu9@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230801095357.44778-1-wangzhu9@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/1/23 02:53, Zhu Wang wrote:
> If device_add() returns error, the name allocated by dev_set_name() need
> be freed. As comment of device_add() says, it should use put_device() to
> decrease the reference count in the error path. So fix this by calling
> put_device, then the name can be freed in kobject_cleanp().
> 
> Fixes: ee959b00c335 ("SCSI: convert struct class_device to struct device")
> Signed-off-by: Zhu Wang <wangzhu9@huawei.com>
> ---
>   drivers/scsi/raid_class.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/raid_class.c b/drivers/scsi/raid_class.c
> index 898a0bdf8df6..2ba4da8d822d 100644
> --- a/drivers/scsi/raid_class.c
> +++ b/drivers/scsi/raid_class.c
> @@ -242,8 +242,10 @@ int raid_component_add(struct raid_template *r,struct device *raid_dev,
>   	list_add_tail(&rc->node, &rd->component_list);
>   	rc->dev.class = &raid_class.class;
>   	err = device_add(&rc->dev);
> -	if (err)
> +	if (err) {
> +		put_device(&rc->dev);
>   		goto err_out;
> +	}
>   
>   	return 0;

Please move the new put_device() call under the "err_out:" label.

Thanks,

Bart.


