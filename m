Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC5FBC001DF
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Oct 2023 17:29:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377702AbjJTR3I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Oct 2023 13:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbjJTR3H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Oct 2023 13:29:07 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5650D7;
        Fri, 20 Oct 2023 10:29:02 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-6b5cac99cfdso987380b3a.2;
        Fri, 20 Oct 2023 10:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697822942; x=1698427742; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NxB8vtzhJUprPLKYP1Ef80ZPGLv0Ykbm1oiksB9CNqo=;
        b=i55LKdik00kaTmHcfGHC+4iW4DSxfbq08j46wehLxgakkMCgzwIJ58HQCDvkNJgei5
         DIYBhbUc+YQcy1RegXCxPA4ENnnK9Hl1LgD1YwHZMb5j2Rf44yP43+Mk+L7OCVrbnY14
         hI7hIryoBSqnyefEW21rAtb4kQHk+UmrrmrB1lDnA6RIO2ITcEw/3Z/JEs6z5vNmiToS
         mxshMeD9cXDQg7co7SCaO3Ik/BFNB/tS+dloUqmJCJ3UnsbJLLPqznPK0XtOerZOWN0r
         sw7uFoW6kQcxrfz9oT/Ewe2i2cRo1HayOWVZJR5N5pCtL1UwYR9qlJ6m3CgaEQF0DLQC
         +ALw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697822942; x=1698427742;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NxB8vtzhJUprPLKYP1Ef80ZPGLv0Ykbm1oiksB9CNqo=;
        b=bWTw+5CWXzWsp2uaC3cWG5PsnhE+HhgmCRgs/MHgEUOmfdWqtz7iV5lIbdMsnEi1MO
         ZWMjUnLvB11aaSJdGcJmxNQ8Wg8gafxvZ2k72NcRf97XPKCd2gTsSvwlKEfSNdne5nJj
         wLkAySpOgtIX4k0MJ//cebfCUMrP7zO0+IfTfyO5VdqaRUwKfDONDbCEKFZgVmjJWMD6
         6zF4WiprY9o0+qbGxFKvWNk+egLIqqSvW8GT9/uvc5SEi6kN6ftVQRZFeUoRHOil1Iw5
         DZy/ZSjYsgq40s04IU2jbzzR5cJdbeXtIFcXBNX8qJpUkIXaqKdR0z1ikiGcYr9ShjsD
         8woA==
X-Gm-Message-State: AOJu0YzFbt8NmJ/xV8hh8kr1wL6w5t2nAjOtfpaqOhciyV4pxByf3GBS
        Sur+Fa/82LuAvES0op5U7pU5xOL5lKd8X/qE
X-Google-Smtp-Source: AGHT+IEIO++MhDiW2A0cmoep73n/pDwBrHZus56cH9G+41Iy7TbfquNrCIf0vsHII6D2kTBcfJvZYQ==
X-Received: by 2002:a05:6a20:4321:b0:14e:b4d5:782d with SMTP id h33-20020a056a20432100b0014eb4d5782dmr2601313pzk.2.1697822942105;
        Fri, 20 Oct 2023 10:29:02 -0700 (PDT)
Received: from [0.0.0.0] (74.211.104.32.16clouds.com. [74.211.104.32])
        by smtp.gmail.com with ESMTPSA id u7-20020aa78487000000b00694fee1011asm1778804pfn.208.2023.10.20.10.28.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Oct 2023 10:29:01 -0700 (PDT)
Message-ID: <d2cb55a9-6bc0-47a0-a812-418d187c2c00@gmail.com>
Date:   Sat, 21 Oct 2023 01:28:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: scsi_debug: delete some bogus error checking
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@linaro.org>,
        Wenchao Hao <haowenchao2@huawei.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <f96d6366-9271-4020-ab66-f75737a1e8bd@moroto.mountain>
From:   Wenchao Hao <haowenchao22@gmail.com>
In-Reply-To: <f96d6366-9271-4020-ab66-f75737a1e8bd@moroto.mountain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/10/20 22:15, Dan Carpenter wrote:
> Smatch complains that "dentry" is never initialized.  These days everyone
> initializes all their stack variables to zero so this means that it will
> trigger a warning every time this function is run.
> 
> Really debugfs functions are not supposed to be checked for errors so
> this checking can just be deleted.
> 
> Fixes: f084fe52c640 ("scsi: scsi_debug: Add debugfs interface to fail target reset")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---
> See my blog for more information on the history of debugfs error
> checking:
> 
> https://staticthinking.wordpress.com/2023/07/24/debugfs-functions-are-not-supposed-to-be-checked/
> ---
>  drivers/scsi/scsi_debug.c | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 0a4e41d84df8..c0be9a53ac79 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -1127,7 +1127,6 @@ static const struct file_operations sdebug_target_reset_fail_fops = {
>  static int sdebug_target_alloc(struct scsi_target *starget)
>  {
>  	struct sdebug_target_info *targetip;
> -	struct dentry *dentry;
>  
>  	targetip = kzalloc(sizeof(struct sdebug_target_info), GFP_KERNEL);
>  	if (!targetip)
> @@ -1135,15 +1134,9 @@ static int sdebug_target_alloc(struct scsi_target *starget)
>  
>  	targetip->debugfs_entry = debugfs_create_dir(dev_name(&starget->dev),
>  				sdebug_debugfs_root);
> -	if (IS_ERR_OR_NULL(targetip->debugfs_entry))
> -		pr_info("%s: failed to create debugfs directory for target %s\n",
> -			__func__, dev_name(&starget->dev));
>  
>  	debugfs_create_file("fail_reset", 0600, targetip->debugfs_entry, starget,
>  				&sdebug_target_reset_fail_fops);
> -	if (IS_ERR_OR_NULL(dentry))
> -		pr_info("%s: failed to create fail_reset file for target %s\n",
> -			__func__, dev_name(&starget->dev));
>  
>  	starget->hostdata = targetip;
>  


Thank you for the fix, the check for debugfs_create_file() is added because 
scsi_debug driver is often used to test abnormal situations, here just check
and prompt a log, so maybe you should not remove it and fix the issue
following changes:

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 67922e2c4c19..d37437fa9eba 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1144,8 +1144,8 @@ static int sdebug_target_alloc(struct scsi_target *starget)
                pr_info("%s: failed to create debugfs directory for target %s\n",
                        __func__, dev_name(&starget->dev));
 
-       debugfs_create_file("fail_reset", 0600, targetip->debugfs_entry, starget,
-                               &sdebug_target_reset_fail_fops);
+       dentry = debugfs_create_file("fail_reset", 0600, targetip->debugfs_entry,
+                                    starget, &sdebug_target_reset_fail_fops);
        if (IS_ERR_OR_NULL(dentry))
                pr_info("%s: failed to create fail_reset file for target %s\n",
                        __func__, dev_name(&starget->dev));
