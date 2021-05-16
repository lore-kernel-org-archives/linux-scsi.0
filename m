Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 778DAC433B4
	for <linux-scsi@archiver.kernel.org>; Sun, 16 May 2021 16:24:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F29161076
	for <linux-scsi@archiver.kernel.org>; Sun, 16 May 2021 16:24:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbhEPQZf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 16 May 2021 12:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbhEPQZe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 16 May 2021 12:25:34 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72607C061573;
        Sun, 16 May 2021 09:24:18 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id t15so4068130edr.11;
        Sun, 16 May 2021 09:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4iUzn3zHyIHxkXGKg+McsZZW45slq4tSdaSJBoUGIMg=;
        b=YKfs1taDo1C0l4Eibti8xcHjG2eLfSXGaUCfjU5fyLR/EttCUGQ0ItkLTTQDYaXtKi
         TkODHbQIVFn05l8RDH1zf7XSO7Y5nPZfsTKJ7asUSGSMsOoqkdtqj1VsPJzGTFDZAZTt
         wVVeC+E4iXfPxRDl9E/4oaJ6hm8kjqMdcyfW9QWG5vxzoV16XEbzlfnoW33sQyu5NtmR
         vgvHqulrMLVCq/pyJMC5v+iseW/JtMXdXSx6nLPoSae8pJxx77E06U6MxR2hkkWkwaxd
         Y0TG4gTgP7+pnjXxPGlR81LIoXxlkPZZ+qpyOtFMpQV7dZ+qxh4HHjoNW8Mdp1vhGOHc
         hDdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4iUzn3zHyIHxkXGKg+McsZZW45slq4tSdaSJBoUGIMg=;
        b=KxCToqeUOvN1pyQ2Vu7o5ScpZmkXPzc9dx9PSB97P6tDzWZTEpzHDOJ9sL4bX7AUu3
         6D5a9T5ZXO/6VpRXbcaJDlG54e4Dul777DqsxYRypGj8lS/nwFhQwk9XaLBMYw923AW4
         5gEvoqJmmKgz08wP70mz3tpYN9lpjtcymj/pIPkHsrG2EdZ1KZEkul0zCvOcZOczWv7J
         PilFMCWD3KH8A40kFL3ejxQ1giLDHeopK0RDDLzgpnQsaIxyh28Gimd9mTmWVVQ5Q/Gy
         PlcSzhzer9/BrL0IAKWPfKn9g16sYyUrghFieD6kOqD3/Sv5s2FaQEy6QGLxPrs7iFw5
         xkEg==
X-Gm-Message-State: AOAM532SNpogEGktPrGJ4p9SBxjybe0yr/Td3cade6zxLOryMO566lLe
        ns/xurCgm42uib++B2/D7qPHg+AaET0=
X-Google-Smtp-Source: ABdhPJyDzM4C1zfNV5m13Tr8f6j8lGTy26CruzisUlyDOgDdEeb7KXTrRio33kjybIP3h9LMtGdPUQ==
X-Received: by 2002:a05:6402:14c2:: with SMTP id f2mr16279825edx.69.1621182256978;
        Sun, 16 May 2021 09:24:16 -0700 (PDT)
Received: from [192.168.178.40] (ipbcc11466.dynamic.kabel-deutschland.de. [188.193.20.102])
        by smtp.gmail.com with ESMTPSA id z4sm9173852edc.1.2021.05.16.09.24.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 May 2021 09:24:16 -0700 (PDT)
Subject: Re: [PATCH] scsi: target: tcmu: fix boolreturn.cocci warnings
To:     kernel test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, linux-kernel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <202105160749.IImZN2gL-lkp@intel.com>
 <20210515230358.GA97544@60d1edce16e0>
From:   Bodo Stroesser <bostroesser@gmail.com>
Message-ID: <2dc20427-50d9-093f-40ae-b031426939a4@gmail.com>
Date:   Sun, 16 May 2021 18:24:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210515230358.GA97544@60d1edce16e0>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 16.05.21 01:03, kernel test robot wrote:
> From: kernel test robot <lkp@intel.com>
> 
> drivers/target/target_core_user.c:1424:9-10: WARNING: return of 0/1 in function 'tcmu_handle_completions' with return type bool
> 
>   Return statements in functions returning bool should use
>   true/false instead of 1/0.
> Generated by: scripts/coccinelle/misc/boolreturn.cocci
> 
> Fixes: 9814b55cde05 ("scsi: target: tcmu: Return from tcmu_handle_completions() if cmd_id not found")
> CC: Bodo Stroesser <bostroesser@gmail.com>
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: kernel test robot <lkp@intel.com>
> ---
> 
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   c12a29ed9094b4b9cde8965c12850460b9a79d7c
> commit: 9814b55cde0588b6d9bc496cee43f87316cbc6f1 scsi: target: tcmu: Return from tcmu_handle_completions() if cmd_id not found
> :::::: branch date: 6 hours ago
> :::::: commit date: 2 weeks ago
> 
>   target_core_user.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -1421,7 +1421,7 @@ static bool tcmu_handle_completions(stru
>   
>   	if (test_bit(TCMU_DEV_BIT_BROKEN, &udev->flags)) {
>   		pr_err("ring broken, not handling completions\n");
> -		return 0;
> +		return false;
>   	}
>   
>   	mb = udev->mb_addr;
> 

Acked-by: Bodo Stroesser <bostroesser@gmail.com>
