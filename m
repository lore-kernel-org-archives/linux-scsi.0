Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D416C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Nov 2021 23:18:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238104AbhKYXV6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Nov 2021 18:21:58 -0500
Received: from mail-pf1-f172.google.com ([209.85.210.172]:34621 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350974AbhKYXT5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Nov 2021 18:19:57 -0500
Received: by mail-pf1-f172.google.com with SMTP id r130so7186719pfc.1
        for <linux-scsi@vger.kernel.org>; Thu, 25 Nov 2021 15:16:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YfO1nn2R77/NSuJ9masp+eEnJaY8wiPxfloXTYf8Agg=;
        b=RONfKaAh0prfuHKuFK3UoS/Zc7Ns4079Gs1TE+3drvmsuMQoSxD4iWDp6s680lj7co
         bDH7xc0nYWfVXt2WlWYePw7DGsE8Y1VH3oa6gNC05yd7krNIQOLSWrY+jjuIZDTOXUL3
         LDCyzDe2tdWGXC06NUZSIjSIJYm+q/ijnjG8/moDtMQ7BW+tPvFoF6nYqd5ZJYHOIixI
         V+rErXEIQE3lAcyOAXy7I4MTNfRpQBt1KRR7iRciRSGZNYb/Q1j7TyeBVB49uQ0EDcq8
         boqfB4luOYYl4kDKiouaR7wos2BTASVyijfEIsv/sJ1XOjsehN5zxmnlb1BLiw0HcaK5
         04DA==
X-Gm-Message-State: AOAM530HJuMFroY7YKOpGWdHqo7qZ+JFcs1s4n41BGKgDsW35mRw970n
        T7zp7V3uiuz/SWrZXf+FocS/vfG+FTU=
X-Google-Smtp-Source: ABdhPJz2VaVsMFJkbf/muoIlH8H4PhMSxcTZVZECEYilxu2AwTc+/LP7cRKHprd61gKjyvSM1SUUhQ==
X-Received: by 2002:aa7:864f:0:b0:4a2:ea0a:a16d with SMTP id a15-20020aa7864f000000b004a2ea0aa16dmr17630586pfo.11.1637882205219;
        Thu, 25 Nov 2021 15:16:45 -0800 (PST)
Received: from [192.168.50.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id h15sm4997669pfc.134.2021.11.25.15.16.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Nov 2021 15:16:44 -0800 (PST)
Subject: Re: [PATCH 01/15] scsi: allocate host device
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>
References: <20211125151048.103910-1-hare@suse.de>
 <20211125151048.103910-2-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <bcd4e4f3-e7e1-7e3c-c0c6-8262bd82434c@acm.org>
Date:   Thu, 25 Nov 2021 15:16:42 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211125151048.103910-2-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/25/21 7:10 AM, Hannes Reinecke wrote:
> +/**
> + * scsi_get_host_dev - Create a virtual scsi_device to the host adapter
                           ^^^^^^
                           Attach?

> @@ -500,7 +500,8 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
>   		kfree_rcu(vpd_pg80, rcu);
>   	if (vpd_pg89)
>   		kfree_rcu(vpd_pg89, rcu);
> -	kfree(sdev->inquiry);
> +	if (!scsi_device_is_host_dev(sdev))
> +		kfree(sdev->inquiry);
>   	kfree(sdev);

kfree() accepts a NULL pointer so please leave out the new if-test.

> -#define MODULE_ALIAS_SCSI_DEVICE(type) \
> +#define MODULE_ALIAS_SCSI_DEVICE(type)			\
>   	MODULE_ALIAS("scsi:t-" __stringify(type) "*")

The above change seems not related to the rest of this patch? Can it be left out?

Otherwise this patch looks good to me.

Thanks,

Bart.
