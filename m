Return-Path: <SRS0=/8H4=AU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 776F5C433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 15:26:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49612207FC
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 15:26:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KFOX3IMI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbgGIP0d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jul 2020 11:26:33 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26007 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726410AbgGIP0c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2020 11:26:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594308391;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yld9cODJlBHmX+0+k8U+y9B+t1vzYK9Zv/haolnPDn0=;
        b=KFOX3IMIFVymJ+c8cpvsN2z/cP1xgNw598KAXVqCJKa5mwU3a1ci5gkhGfVXY257C9bkTC
        YczYF6mtbFMfQ1IguMoR3LEY4nzpSLSjB7n0o/GhT9j0N2oO1ZZbYF19soQsElPTOowitk
        P1VZkKnLbr7Olq6MJCb8aSFgYirPZ08=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-444-c9i1Z7U3MiKWRS5W4TwkEw-1; Thu, 09 Jul 2020 11:26:29 -0400
X-MC-Unique: c9i1Z7U3MiKWRS5W4TwkEw-1
Received: by mail-wm1-f69.google.com with SMTP id v11so2498361wmb.1
        for <linux-scsi@vger.kernel.org>; Thu, 09 Jul 2020 08:26:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Yld9cODJlBHmX+0+k8U+y9B+t1vzYK9Zv/haolnPDn0=;
        b=Wjgz7IJRb422G56iTFzaePOKLyOgx7VaiLni/suH5k7Y6ZDVsuO7ztfGvanaPnAaCg
         Yw7hfdMla12ouCk7MacwyMdeNQ1fp1tOPDKWfHO52+JKaEw2OoghBxw9iGYKmWkcustY
         Wi4f8QNSHJuqetihYgWStVkyvHKlN+UiYRzL2L101bCw92ORo102aD7LhrAkZIqepbdg
         0RBsuUepf1ZFt4l9199dB4GLlTzd5QQKzUlERF4jFRFcG4FkGfUZnKdU4TabcZJGn3w+
         HreG1vOAhkX/ewt59eOKY5Mts4uwxagqvhTwz1JyeZqKczi/3NRcmz4SMJ47blnEYk72
         y4zg==
X-Gm-Message-State: AOAM5316HVFxH0lA0xNA/+CNko61IDqbf8CM9LANk121/SfZCRUKE1Rc
        n1QndwP7RhGGGLUPfU/91m9ipM6p/FNNZf8g7f/hy80FYWBjGoU8+OHj4I+lHP9GYkua4WojYsK
        M/nbs7t/shs0m6nTRJnRRmg==
X-Received: by 2002:a1c:7313:: with SMTP id d19mr500864wmb.147.1594308388637;
        Thu, 09 Jul 2020 08:26:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx7dLDkZ4/BZL2j48IHZwmCZYpcCKvTnAn2jv2FLYWLH187tJjjXAZRllb881rA5jAJPriTPw==
X-Received: by 2002:a1c:7313:: with SMTP id d19mr500850wmb.147.1594308388450;
        Thu, 09 Jul 2020 08:26:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id g14sm6012304wrm.93.2020.07.09.08.26.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2020 08:26:27 -0700 (PDT)
Subject: Re: [PATCH] scsi: virtio_scsi: remove unnecessary condition check
To:     Xianting Tian <xianting_tian@126.com>, mst@redhat.com,
        jasowang@redhat.com, stefanha@redhat.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     virtualization@lists.linux-foundation.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1594305992-8458-1-git-send-email-xianting_tian@126.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6e8405da-b960-f4f7-b46b-442ddab8d983@redhat.com>
Date:   Thu, 9 Jul 2020 17:26:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <1594305992-8458-1-git-send-email-xianting_tian@126.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09/07/20 16:46, Xianting Tian wrote:
> kmem_cache_destroy can correctly handle null pointer parameter,
> so there is no need to check if the parameter is null before
> calling kmem_cache_destroy.
> 
> Signed-off-by: Xianting Tian <xianting_tian@126.com>
> ---
>  drivers/scsi/virtio_scsi.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index bfec84a..5bc288f 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -1007,10 +1007,8 @@ static int __init init(void)
>  		mempool_destroy(virtscsi_cmd_pool);
>  		virtscsi_cmd_pool = NULL;
>  	}
> -	if (virtscsi_cmd_cache) {
> -		kmem_cache_destroy(virtscsi_cmd_cache);
> -		virtscsi_cmd_cache = NULL;
> -	}
> +	kmem_cache_destroy(virtscsi_cmd_cache);
> +	virtscsi_cmd_cache = NULL;
>  	return ret;
>  }
>  
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

