Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 447BDC04FE1
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Aug 2023 16:51:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233222AbjHBQvw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Aug 2023 12:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232603AbjHBQvZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Aug 2023 12:51:25 -0400
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF5DF30FA
        for <linux-scsi@vger.kernel.org>; Wed,  2 Aug 2023 09:50:57 -0700 (PDT)
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2680a031283so4300071a91.3
        for <linux-scsi@vger.kernel.org>; Wed, 02 Aug 2023 09:50:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690995046; x=1691599846;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4FVzVJaYZ6GCrB12rl7s+PsKQySdxZj2TWGUmnlXmB0=;
        b=V5bUp1uQnFyBxSUuj+QFKYklWXrY6eERKua+Kz+k36H1SYNcZ1q6XfLcYqLSrvEoKS
         wzB/JuF7DEjiAalrbuIkHvUglf2ATd87GP6oMPCX3+FsFdLKoVIlGdPppAHQoHny5eED
         nB4kXp3kBnOXdn54yfphm+PifadFCVzYGwaH7S1avx4moEOc3xKEBVPd3w0iSfo4UtUF
         wsJi6MsgCK47+lzH1tHCLXrmJI/E+h9kv3luGOoMLELU9lqCcoWBQ7f7f0oCcAiR+9/K
         ES1hgUvIf/WlKjv3IGHwxHfAcyASkWxpyoO+ZafYdJjkzDcRBR2pWRNaYCFw6gLJBLMy
         hieg==
X-Gm-Message-State: ABy/qLbeqUXCk99OUDbLfE6v6lqk31BZ8MaelL8pVZ3NfBNXwg4s1Kek
        u//ySI70jN9Tq3fnPW4EjMc=
X-Google-Smtp-Source: APBJJlGSfElJnPiK5PHd4lrChSVFlK7ZGy3kka0hccbgJKG7syNLBHyS4Gjkrmrb34TAQj1v0Yqjkw==
X-Received: by 2002:a17:90a:fd98:b0:263:4e41:bdb4 with SMTP id cx24-20020a17090afd9800b002634e41bdb4mr14305700pjb.33.1690995045749;
        Wed, 02 Aug 2023 09:50:45 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:3b5d:5926:23cf:5139? ([2620:15c:211:201:3b5d:5926:23cf:5139])
        by smtp.gmail.com with ESMTPSA id k7-20020a17090aaa0700b002684b837d88sm1321971pjq.14.2023.08.02.09.50.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Aug 2023 09:50:44 -0700 (PDT)
Message-ID: <82ab3a04-e0ee-0911-ab11-e0b8f9e554ec@acm.org>
Date:   Wed, 2 Aug 2023 09:50:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH -next v2] SCSI: fix possible memory leak while
 device_add() fails
Content-Language: en-US
To:     Zhu Wang <wangzhu9@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, kay.sievers@vrfy.org, tonyj@suse.de,
        gregkh@suse.de, linux-scsi@vger.kernel.org
References: <20230802023521.208194-1-wangzhu9@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230802023521.208194-1-wangzhu9@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/1/23 19:35, Zhu Wang wrote:
> If device_add() returns error, the name allocated by dev_set_name() need
> be freed. As comment of device_add() says, it should use put_device() to
> decrease the reference count in the error path. So fix this by calling
> put_device, then the name can be freed in kobject_cleanp().
> 
> Fixes: ee959b00c335 ("SCSI: convert struct class_device to struct device")
> Signed-off-by: Zhu Wang <wangzhu9@huawei.com>
> 
> ---
> Changes in v2:
> - Move the new put_device() call from under if to under err_out label.
> ---
>   drivers/scsi/raid_class.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/raid_class.c b/drivers/scsi/raid_class.c
> index 898a0bdf8df6..d9dd86a185f7 100644
> --- a/drivers/scsi/raid_class.c
> +++ b/drivers/scsi/raid_class.c
> @@ -249,6 +249,7 @@ int raid_component_add(struct raid_template *r,struct device *raid_dev,
>   
>   err_out:
>   	list_del(&rc->node);
> +	put_device(&rc->dev);
>   	rd->component_count--;
>   	put_device(component_dev);
>   	kfree(rc);

Please perform the error recovery actions in the opposite order of the 
corresponding actions - this means swapping the list_del() and 
put_device() calls.

Thanks,

Bart.
