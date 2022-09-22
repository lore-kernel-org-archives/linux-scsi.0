Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2F3BC54EE9
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Sep 2022 17:00:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbiIVQ76 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Sep 2022 12:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbiIVQ7z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Sep 2022 12:59:55 -0400
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC71A2F3BC
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2022 09:59:47 -0700 (PDT)
Received: by mail-pj1-f54.google.com with SMTP id s90-20020a17090a2f6300b00203a685a1aaso2786146pjd.1
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2022 09:59:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=VJtyPK1+naxtkcuX47wfc0DX4m8R5y/j/dUq+tW8jzQ=;
        b=UKpNajy8n8CvNfYFynk7NrlMSh+eKsocfgNy5KblZO7BFgOKalfNSpvvWCnaSX8UwR
         dBkQyOUc/l5DEzO3jodIxUYB4cRBPROSeFmWVgR921HlAMULFdT/78egdb/JqJwO8YxA
         HuuJ1QKddFAc6FNToVsHU/eLH/QHQRZtXg6EjY/XT7LTWriiSAnKyGJW+nv3UjU2MlCs
         mDHmbfIgJ1EkDKcbLaW4bThmuQ/XqBUs4vcTGsdocCUsx7lfn/pyWtnkxFZ/EVKTnmKK
         7oypeMAXHLSP4UJ3Nvl/1G2vxrdEM5Of5ROk1LOxM09Oq02aJIRVeZSqjN2HV86sqvy5
         9P2g==
X-Gm-Message-State: ACrzQf1/Oyjt9QeEVU2gn9YO1juMHKftRwuavY/8YHCkJv7A9+Ik6Zr+
        EZktRtyK7gY7AuBJYjgxhGk=
X-Google-Smtp-Source: AMsMyM6GXZurN2epi+JO5RrZmxpSI1nQqJZmo6WRdmpJPsXiMyMMtvYEAa+JxSLcJHnp3gu5nqQeLQ==
X-Received: by 2002:a17:90b:1bc2:b0:200:a97b:4ae5 with SMTP id oa2-20020a17090b1bc200b00200a97b4ae5mr4816467pjb.147.1663865986888;
        Thu, 22 Sep 2022 09:59:46 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:7c7b:f882:f26a:23ca? ([2620:15c:211:201:7c7b:f882:f26a:23ca])
        by smtp.gmail.com with ESMTPSA id u11-20020a17090a400b00b0020396a060cdsm32019pjc.13.2022.09.22.09.59.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Sep 2022 09:59:46 -0700 (PDT)
Message-ID: <aed47648-09fa-77bf-55d0-27fb7c477405@acm.org>
Date:   Thu, 22 Sep 2022 09:59:44 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH RFC 02/22] scsi: Allow passthrough to override what errors
 to retry
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20220922100704.753666-1-michael.christie@oracle.com>
 <20220922100704.753666-3-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220922100704.753666-3-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/22/22 03:06, Mike Christie wrote:
> +	while ((failure = &scmd->failures[i++])) {

Has this patch been verified with checkpatch? I don't think that the 
Linux kernel coding style allows assignments inside conditions.

Thanks,

Bart.
