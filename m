Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D49E4C001E0
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Oct 2023 05:07:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233263AbjJWFHG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Oct 2023 01:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233252AbjJWFHF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2023 01:07:05 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CCF9AF
        for <linux-scsi@vger.kernel.org>; Sun, 22 Oct 2023 22:07:02 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id 38308e7fff4ca-2c5720a321aso15423331fa.1
        for <linux-scsi@vger.kernel.org>; Sun, 22 Oct 2023 22:07:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1698037620; x=1698642420; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kf58qID1cOmKTp3aYLs4Y1mi5q9prbPNj5vrglTKqco=;
        b=T+nenI8V8lY5JUWHbWnq9OSUZDdVZg/pEjXGvTrM1ognDsmnFPhzK6CuNMN/W9PSOk
         bv44jP89m8hDDbAHJHP44XDthDngxMt5/cRlj0q6t9kMkKbEQNDUfLeFtPWG6GfJlBYn
         cq+pByU2uT5HAP9YT1vO1VjP4X/xguKdrLBSc9X7YTWEeECC85pE78ysOuOibkDNAaHM
         Raq/YVIJ4h7gUNjyaohYTu2vOpuvVaBZqWL3xcUp14PaJsBImWHwQMKi2roQhsEnFu7q
         Y0B+n0VCqSp2UBRKO1ZFVnztbYpbGRRNERtCxr2J8DMfRFE8K0RjuYoCaGnVfQUjjyN6
         iorA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698037620; x=1698642420;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kf58qID1cOmKTp3aYLs4Y1mi5q9prbPNj5vrglTKqco=;
        b=LdT+E9gV0YwHhAg+PkhA1kRkv3Bf2eayJM1VU6G+v95UkMjsawP2C7xtOxMDciWGE+
         xD4c4dIyjNyMMaNW4YArbRlvHPp+HIMETb4Lg+b3EjE/XTXeradacdrfFVmP4LJyrdZa
         lPkyNSkXD2TTNMPmFZRg6Z3BGXPR3C1s3U6sRlpDzps8nhxIBoMD3gSotxooOv5r9xAi
         aQ9QYURG1PDZMq40Ncm3QFGU/dl4K9GlQa/S8jjn65Gun21c1PZ36SV2eVHeKU4Nc/2/
         MMibHfW79epKKwjw6X/oVHUQMr0v4qsBAkX3GsNvyzfjG9egXx+D0T2BxwUsU3unDm6o
         860A==
X-Gm-Message-State: AOJu0Yzyzot6brnGdzyyKj4+Ql71Aztt357/0u8eZOkJ6kAMRsvI3spo
        frj51v/67MEnsWRFTpnkuTSxcfxorQmlzEroP3g=
X-Google-Smtp-Source: AGHT+IG4dSKfcA5+PvJsg5jWu66vVOJv9CrJQX00MnAX6jY7qTIJgQh/moaZg78bQagBHbC9HqJEsQ==
X-Received: by 2002:a2e:9c0b:0:b0:2bc:c89e:d8df with SMTP id s11-20020a2e9c0b000000b002bcc89ed8dfmr4326937lji.48.1698037620214;
        Sun, 22 Oct 2023 22:07:00 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id v19-20020a05600c471300b00405959bbf4fsm8469006wmo.19.2023.10.22.22.06.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Oct 2023 22:06:59 -0700 (PDT)
Date:   Mon, 23 Oct 2023 08:06:56 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Wenchao Hao <haowenchao22@gmail.com>
Cc:     Wenchao Hao <haowenchao2@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/2] scsi: scsi_debug: delete some bogus error checking
Message-ID: <d8ec82e6-5ba5-4945-825c-0e622c62f5b6@kadam.mountain>
References: <f96d6366-9271-4020-ab66-f75737a1e8bd@moroto.mountain>
 <d2cb55a9-6bc0-47a0-a812-418d187c2c00@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2cb55a9-6bc0-47a0-a812-418d187c2c00@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Oct 21, 2023 at 01:28:50AM +0800, Wenchao Hao wrote:
> On 2023/10/20 22:15, Dan Carpenter wrote:
> > Smatch complains that "dentry" is never initialized.  These days everyone
> > initializes all their stack variables to zero so this means that it will
> > trigger a warning every time this function is run.
> > 
> > Really debugfs functions are not supposed to be checked for errors so
> > this checking can just be deleted.
> > 
> > Fixes: f084fe52c640 ("scsi: scsi_debug: Add debugfs interface to fail target reset")
> > Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> > ---
> > See my blog for more information on the history of debugfs error
> > checking:
> > 
> > https://staticthinking.wordpress.com/2023/07/24/debugfs-functions-are-not-supposed-to-be-checked/
> > ---
> >  drivers/scsi/scsi_debug.c | 7 -------
> >  1 file changed, 7 deletions(-)
> > 
> > diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> > index 0a4e41d84df8..c0be9a53ac79 100644
> > --- a/drivers/scsi/scsi_debug.c
> > +++ b/drivers/scsi/scsi_debug.c
> > @@ -1127,7 +1127,6 @@ static const struct file_operations sdebug_target_reset_fail_fops = {
> >  static int sdebug_target_alloc(struct scsi_target *starget)
> >  {
> >  	struct sdebug_target_info *targetip;
> > -	struct dentry *dentry;
> >  
> >  	targetip = kzalloc(sizeof(struct sdebug_target_info), GFP_KERNEL);
> >  	if (!targetip)
> > @@ -1135,15 +1134,9 @@ static int sdebug_target_alloc(struct scsi_target *starget)
> >  
> >  	targetip->debugfs_entry = debugfs_create_dir(dev_name(&starget->dev),
> >  				sdebug_debugfs_root);
> > -	if (IS_ERR_OR_NULL(targetip->debugfs_entry))
> > -		pr_info("%s: failed to create debugfs directory for target %s\n",
> > -			__func__, dev_name(&starget->dev));
> >  
> >  	debugfs_create_file("fail_reset", 0600, targetip->debugfs_entry, starget,
> >  				&sdebug_target_reset_fail_fops);
> > -	if (IS_ERR_OR_NULL(dentry))
> > -		pr_info("%s: failed to create fail_reset file for target %s\n",
> > -			__func__, dev_name(&starget->dev));
> >  
> >  	starget->hostdata = targetip;
> >  
> 
> 
> Thank you for the fix, the check for debugfs_create_file() is added because 
> scsi_debug driver is often used to test abnormal situations, here just check
> and prompt a log, so maybe you should not remove it and fix the issue
> following changes:
> 

No, the correct thing is to remove it.  This is explained in my blog
article linked to earlier.

https://staticthinking.wordpress.com/2023/07/24/debugfs-functions-are-not-supposed-to-be-checked/

commit ff9fb72bc07705c00795ca48631f7fffe24d2c6b
Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Wed Jan 23 11:28:14 2019 +0100

    debugfs: return error values, not NULL
    
    When an error happens, debugfs should return an error pointer value, not
    NULL.  This will prevent the totally theoretical error where a debugfs
    call fails due to lack of memory, returning NULL, and that dentry value
    is then passed to another debugfs call, which would end up succeeding,
    creating a file at the root of the debugfs tree, but would then be
    impossible to remove (because you can not remove the directory NULL).
    
    So, to make everyone happy, always return errors, this makes the users
    of debugfs much simpler (they do not have to ever check the return
    value), and everyone can rest easy.

In your code, if there is an error the debugfs code will print an error and
your code will print an info.  The info adds nothing.  Also if debugfs fails
to load you are already screwed so the info adds nothing.

In your code if the user disables CONFIG_DEBUGFS then printing "failed to create
fail_reset file for target" is wrong.  The user did that deliberately.  No need
to complain about the user's deliberate choices.  If it's really necessary to
have CONFIG_DEBUGFS then enforce that with Kconfig.

regards,
dan carpenter
