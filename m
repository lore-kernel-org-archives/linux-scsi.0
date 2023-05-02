Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38C40C77B7E
	for <linux-scsi@archiver.kernel.org>; Tue,  2 May 2023 15:54:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234592AbjEBPyb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 May 2023 11:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234556AbjEBPy3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 May 2023 11:54:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D6C1FDE
        for <linux-scsi@vger.kernel.org>; Tue,  2 May 2023 08:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683042794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DvI30K6rMw48L/vuYdVlLHdx9lMtZjuptjIrhFdSm2E=;
        b=NitvRE3ls1GFNPsnNt4h91hIns28Cxeug5HwGjAaaXiZTx0wSg1rkQsyk/nOC8KmqWH58H
        ZBdSCFVd/H8+QnWfU1OlOAdFnZ5Iy8IP1105XStuNPig2SW2nOXuCPfG3inQFyKS/v14SJ
        U4whOSReIrbwAHOUumYDQNDfny0X/+E=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-634-gPTwkylcOFupynedu1mkHw-1; Tue, 02 May 2023 11:53:13 -0400
X-MC-Unique: gPTwkylcOFupynedu1mkHw-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-50bc9da53a3so2372888a12.1
        for <linux-scsi@vger.kernel.org>; Tue, 02 May 2023 08:53:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683042792; x=1685634792;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DvI30K6rMw48L/vuYdVlLHdx9lMtZjuptjIrhFdSm2E=;
        b=DzB6Hb/9LWdPg1JoC32+gcl6mK6903aeJAg2nMq2dcl7ochGpaQE0soyp44iYPUpyz
         LuIWoHdRnUv0jg9FkF+PP0uXYYpky8kbJNnI/EJvYthbo5iP5R76x6YI0EStaCU349I6
         x6QBkHJkzWVW+sOAUOcvxo8cYnWhiLyjERQioUbpjFRbciUc/ubg58YhnnGsBDn0ImKk
         2nhOG6KFxpN6N33keX1gcIVbJvJRwesUtxBJ1T8V8H0E7obvOgqXX9Otz1WbqwhgwdDU
         kJnX6jGOvVh2GOUzNDnI/3PuVIpRxFzuVRhcQyUlTYX//7Ur+5ted1qUw4qdXT7MQJ7R
         ofEQ==
X-Gm-Message-State: AC+VfDwkHv38aKfaX3nD63H2nN03OdScvHGUCApkn26UE/l2AeblDK5z
        sb1uQDVDj2tIRxR1qvzlXHdKzZR5s0qts30gC8/pBYYKrKxS9wRZuPLHMc7ZNGSTda95f/JDIH0
        nGkjTHs/TtU6tbTV4mSkxXg==
X-Received: by 2002:aa7:cd16:0:b0:50b:cbcf:7d9a with SMTP id b22-20020aa7cd16000000b0050bcbcf7d9amr3850748edw.20.1683042792063;
        Tue, 02 May 2023 08:53:12 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ72o/JwbIjdPsW9CjYjPjv6Gf80qvAecqyGbq5q/eeTy0wqoaeUgUIxkiN36AEqfkwIco65Qg==
X-Received: by 2002:aa7:cd16:0:b0:50b:cbcf:7d9a with SMTP id b22-20020aa7cd16000000b0050bcbcf7d9amr3850725edw.20.1683042791739;
        Tue, 02 May 2023 08:53:11 -0700 (PDT)
Received: from [192.168.0.107] (ip4-83-240-118-160.cust.nbox.cz. [83.240.118.160])
        by smtp.gmail.com with ESMTPSA id v17-20020aa7d9d1000000b0050bd53f982fsm588713eds.92.2023.05.02.08.53.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 May 2023 08:53:11 -0700 (PDT)
Message-ID: <6e69b57c-80ae-8b6e-cb5f-9e05da46ecd6@redhat.com>
Date:   Tue, 2 May 2023 17:53:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] drivers: mpt3sas: mpt3sas_debugfs: return value check of
 `mpt3sas_debugfs_root`
To:     Jing Xu <U202112064@hust.edu.cn>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     hust-os-kernel-patches@googlegroups.com,
        Dongliang Mu <dzm91@hust.edu.cn>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230423122535.31019-1-U202112064@hust.edu.cn>
Content-Language: en-US
From:   Tomas Henzl <thenzl@redhat.com>
In-Reply-To: <20230423122535.31019-1-U202112064@hust.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/23/23 14:25, Jing Xu wrote:
> Smatch complains that:
> mpt3sas_init_debugfs() warn: 'mpt3sas_debugfs_root' is an error 
> pointer or valid
> 
> There is no need to check the return value of the debugfs_create_dir() 
> function, just delete the dead code.
> 
> Fixes: 2b01b293f359 ("scsi: mpt3sas: Capture IOC data for debugging purposes")
> Signed-off-by: Jing Xu <U202112064@hust.edu.cn>
> Reviewed-by: Dongliang Mu <dzm91@hust.edu.cn>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_debugfs.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_debugfs.c b/drivers/scsi/mpt3sas/mpt3sas_debugfs.c
> index a6ab1db81167..c92e08c130b9 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_debugfs.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_debugfs.c
> @@ -99,8 +99,6 @@ static const struct file_operations mpt3sas_debugfs_iocdump_fops = {
>  void mpt3sas_init_debugfs(void)
>  {
>  	mpt3sas_debugfs_root = debugfs_create_dir("mpt3sas", NULL);
> -	if (!mpt3sas_debugfs_root)
> -		pr_info("mpt3sas: Cannot create debugfs root\n");
Hi Jing,
most drivers just ignore the return value but here the author wanted to
have the information logged.
Can you instead of removing the message modify the 'if' condition so it
suits the author's intention?
Also there are other similar issues in this file.

Regards,
Tomas


>  }
>  
>  /*

