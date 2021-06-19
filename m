Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86378C49361
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 15:45:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6587861040
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 15:45:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234658AbhFSPrM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Jun 2021 11:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233796AbhFSPrL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Jun 2021 11:47:11 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A7FCC061574;
        Sat, 19 Jun 2021 08:45:01 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id x10so6225254plg.3;
        Sat, 19 Jun 2021 08:45:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YrKUdhs9GVQYxmJPM/9UcnT6/8KVsjpYC1ye5V/AvUI=;
        b=MSOq84oNJOvVkiUUx/pG32BxE8cC/P9etMZabrNcpeYyYmmT196L/lNPlKM9a0tZvj
         fH5o3cg+GxnBJ9ztiifpSvXFWzNWrAMYksof7vz2Y67/AGxhudgYJ3MP7cMElbYlpdpn
         1cGrSDTE4xzPYMiqUS0hO5kANF5PnICjS7qDDLixy/AnJE+ZBnkZpPZ6cnFuSUgiY9RJ
         YRPpermSKQHbtjLZXj3dTjz6w/peuLnlo4VVBqs8SR5Lrl53RYlnOSSn9tVE3cL2l1gh
         guDam35xUz/WTjaoxFtAU0JWw1Sj/gSGnBE6BzRdn8bz7DLNIgWmbqWy1mKFpnb/A+0P
         WRHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YrKUdhs9GVQYxmJPM/9UcnT6/8KVsjpYC1ye5V/AvUI=;
        b=ipaTsotkWSNRza5Xt8xu78YhGoEzfaBCzpk+lMsalGo8A9NuRzbXkaRWE65PYSim9q
         JMKPWXwPzJdetSYGLdbxLvUarB1erWoIBj9qd3VF9HCvlfW303CGSe7N4765q/eOEJ+j
         Du/s074xQqcAOXVOPpneOYhVumYKSbmhzDbBLf3/w8q2QngR6gBlaBQXCGhBl4D4jrEn
         iAdQw5ET51GyRHDjNCzwjNeczPaGkwcyEcb+Yn/OHI/Oo5KzQlkDo4QmLtFsHEEFAkmw
         5E/lxXtz0X342+CSYjQs9YsVWCfH5Sh2t4ZijbWzRc+4pI1iLQy6NB3mdpGzXjW7ikjo
         0VBw==
X-Gm-Message-State: AOAM531+nglnQi6DHzIqIPV0FP1IoaHSQSxw1wb1DdxO/+Ls1GTfWXjZ
        8Sy6BLc+/zVkbFBIrj35F3QablN1+fs=
X-Google-Smtp-Source: ABdhPJzP6jP+A//wvqCL5vYEQd89Alei78k2cmUYKskv703OjGqaqD9BDQIHuPyAJ1w9weBRPd5ZTw==
X-Received: by 2002:a17:903:1043:b029:11e:7489:9bad with SMTP id f3-20020a1709031043b029011e74899badmr9796847plc.34.1624117500508;
        Sat, 19 Jun 2021 08:45:00 -0700 (PDT)
Received: from [10.230.185.151] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p1sm10735453pfn.212.2021.06.19.08.44.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Jun 2021 08:45:00 -0700 (PDT)
Subject: Re: [PATCH] scsi: elx: libefc: fix IRQ restore in
 efc_domain_dispatch_frame()
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        James Smart <james.smart@broadcom.com>
Cc:     Ram Vegesna <ram.vegesna@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Daniel Wagner <dwagner@suse.de>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <YMyjH16k4M1yEmmU@mwanda>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <63e4d110-90a7-48ab-31df-e8f4c00115a6@gmail.com>
Date:   Sat, 19 Jun 2021 08:44:54 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <YMyjH16k4M1yEmmU@mwanda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/18/2021 6:43 AM, Dan Carpenter wrote:
> Calling a nested spin_lock_irqsave() will overwrite the original "flags"
> so that they can not be enabled again at the end.
> 
> Fixes: 3146240f19bf ("scsi: elx: libefc: FC Domain state machine interfaces")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>   drivers/scsi/elx/libefc/efc_domain.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)

Thanks!

Reviewed-by: James Smart <jsmart2021@gmail.com>

-- james


