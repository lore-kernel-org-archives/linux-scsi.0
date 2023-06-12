Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B855C88CB2
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jun 2023 18:11:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237222AbjFLSLE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jun 2023 14:11:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbjFLSLD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jun 2023 14:11:03 -0400
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67DFFE64;
        Mon, 12 Jun 2023 11:11:02 -0700 (PDT)
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-25bc612be7cso1199721a91.1;
        Mon, 12 Jun 2023 11:11:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686593462; x=1689185462;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m7cSHR9Osde9hZfK+eZtXBg2Q6SmGt3LF/vqlGngynk=;
        b=MqYMcsIYqnz7T3Gvf9NHhquX1mAbVV42zbuk7fXDT/dc+keCea+gtq+pWoSkIwAD88
         IPcU/cmT5RoujX+LD0gFNVQ+/FZGtLBfi2HZwdVn2PUTAbyrfJBcAs0SlgCkZiYIZydb
         WXrRjcKgRn+Gz/phdRVO6CLtA1XK5C9Rv4KOlcrU0amsg91LxUrf6diVIOs/Br7dqfSf
         AgT9jAEU0J2A9YUTbcDRLXf7lBch2kqnKPgPxhQiOJSYPhyryd5hIxcWohsJPqrxJWID
         chR5XpQciAgJZg9pec2I0sSRbsW4TyMcU9/jVR8czqSH4RLmI5sGkgEuoUsXSpT0xlYT
         ZpYw==
X-Gm-Message-State: AC+VfDxOBhlsoe8T6RtbFBRWjp5cdUNxP3EzM46HtOqioA6xYaw4WTMP
        C/KxzRE73xqQUgG70MSCY3U=
X-Google-Smtp-Source: ACHHUZ59d2Vto8tuoYIpbCTZzBgawTaGn/EI2BLkdWSkiL/BHNbWbJyE6J5Jxk6opFBuTiXjt20PeQ==
X-Received: by 2002:a17:90a:4293:b0:259:30e7:7349 with SMTP id p19-20020a17090a429300b0025930e77349mr8576594pjg.8.1686593461737;
        Mon, 12 Jun 2023 11:11:01 -0700 (PDT)
Received: from [192.168.3.219] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id b19-20020a17090a551300b0025023726fc4sm9474385pji.26.2023.06.12.11.11.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jun 2023 11:11:01 -0700 (PDT)
Message-ID: <d4a535b1-2bd2-04a0-3306-a1b4b0b28625@acm.org>
Date:   Mon, 12 Jun 2023 11:11:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v5 7/7] scsi: improve warning message in
 scsi_device_block()
Content-Language: en-US
To:     mwilck@suse.com, "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
References: <20230612165049.29440-1-mwilck@suse.com>
 <20230612165049.29440-8-mwilck@suse.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230612165049.29440-8-mwilck@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/12/23 09:50, mwilck@suse.com wrote:
> -	WARN_ONCE(err, "__scsi_internal_device_block_nowait(%s) failed: err = %d\n",
> -		  dev_name(&sdev->sdev_gendev), err);
> +	WARN_ONCE(err, "%s: failed to block %s in state %d\n",
> +		  __func__, dev_name(&sdev->sdev_gendev), state);
>   }
>   
>   /**

Shouldn't this patch be merged into patch 3/7?

Thanks,

Bart.
