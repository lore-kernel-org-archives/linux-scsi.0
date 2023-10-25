Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 989F6C25B6D
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Oct 2023 04:07:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232691AbjJYEHk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Oct 2023 00:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232562AbjJYEHj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Oct 2023 00:07:39 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D4F5137
        for <linux-scsi@vger.kernel.org>; Tue, 24 Oct 2023 21:07:36 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id ffacd0b85a97d-32dbbf3c782so210566f8f.1
        for <linux-scsi@vger.kernel.org>; Tue, 24 Oct 2023 21:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1698206855; x=1698811655; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ffh1hc5+xa7pdyDr+SRzq0H2ZTdMTKrRahcZ7F1PnBI=;
        b=PvnAZ3txpUeZ2/gW4Ke9J1F/JU5tBTNscKZc9e8G/18e96aMo7X4xL2/3eBkuzHvWV
         is3GrPy2cIjF3GxrGoWoJTu0CTFN+HY8RHaaYSFJ1U8Eeria6jJ8th0GmLvZVhykRdRD
         grga75UQAfTahZNnn5KFAWtBkyR3yDmvs78VcWLJzoJ57hbmkKBAQkgJnwlPKJaVk1zS
         lP7HtXKN5f3ME0V5Cf7QcAK2TgBKiaLgM4x+NQqcwxOsaF+kHo9BgKk5SdCsNSYfqZEG
         tMzu4H08sdNzN1M+LhwemOiKqLBqQrLg4S3k3xLIA4vY5oxC6u5pEs63S9xEuYF7Rrx0
         dHOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698206855; x=1698811655;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ffh1hc5+xa7pdyDr+SRzq0H2ZTdMTKrRahcZ7F1PnBI=;
        b=o/zkP5S1j93PLfgfDqRPmnARqdkxXIS1N6PcvP35RdULOpY2qLUDNOpe1JRRLfhh1H
         u/yn2j1oUk+GCMijIb+srjLEWhfJ/y5uVX1qZR78jZQfmNBulDEM41iPye58K51bLh6Q
         35myT7lUJaKouuw6WgmqLpOqdRr5F2uXHYUlZyzLSnTytrQRenuPOApjLwoidsLz8iTI
         BWnvJnpsVTRmWwS9anwq8ef03mbb/N2CJOKe9btZuCZs7xjL25YqlB2a2i09n7dC6JhV
         0/DEdnQycgF/cTBpMi0eCeU31l0zrwmnAOGLyRWZwR81tfxMcK6OkdluT+mE/XS/r5Cd
         vLUg==
X-Gm-Message-State: AOJu0YymNjbiCGmg2GerX/MaPSTQ3seVsvecviGqZmgmO9RmslDmP83O
        UmYdC9RyRwx48ijU5OFWyIPH6g==
X-Google-Smtp-Source: AGHT+IGnsflWEFj9kmnbEqGjA6gOQ1vVEZ1jGDutnomG+MGT1NN/xSTeV1TZUMzgtVdXz2qL7DKGNw==
X-Received: by 2002:adf:b198:0:b0:32d:cae5:3573 with SMTP id q24-20020adfb198000000b0032dcae53573mr17923061wra.32.1698206855013;
        Tue, 24 Oct 2023 21:07:35 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id e16-20020adfef10000000b0032d8354fb43sm11210237wro.76.2023.10.24.21.07.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Oct 2023 21:07:34 -0700 (PDT)
Date:   Wed, 25 Oct 2023 07:07:30 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Wenchao Hao <haowenchao22@gmail.com>
Cc:     Wenchao Hao <haowenchao2@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/2] scsi: scsi_debug: delete some bogus error checking
Message-ID: <d49244a3-6d00-483b-9ae5-ac45de5169b2@kadam.mountain>
References: <f96d6366-9271-4020-ab66-f75737a1e8bd@moroto.mountain>
 <d2cb55a9-6bc0-47a0-a812-418d187c2c00@gmail.com>
 <d8ec82e6-5ba5-4945-825c-0e622c62f5b6@kadam.mountain>
 <f882e8ba-c563-4c9a-99ab-50b20fe7b1b0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f882e8ba-c563-4c9a-99ab-50b20fe7b1b0@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Oct 25, 2023 at 12:49:48AM +0800, Wenchao Hao wrote:
> On 10/23/23 1:06 PM, Dan Carpenter wrote:
> > On Sat, Oct 21, 2023 at 01:28:50AM +0800, Wenchao Hao wrote:
> >> On 2023/10/20 22:15, Dan Carpenter wrote:
> >>> Smatch complains that "dentry" is never initialized.  These days everyone
> >>> initializes all their stack variables to zero so this means that it will
> >>> trigger a warning every time this function is run.
> >>>
> >>> Really debugfs functions are not supposed to be checked for errors so
> >>> this checking can just be deleted.
> >>>
> >>> Fixes: f084fe52c640 ("scsi: scsi_debug: Add debugfs interface to fail target reset")
> >>> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> >>> ---
> >>> See my blog for more information on the history of debugfs error
> >>> checking:
> >>>
> >>> https://staticthinking.wordpress.com/2023/07/24/debugfs-functions-are-not-supposed-to-be-checked/
> >>> ---
> >>>  drivers/scsi/scsi_debug.c | 7 -------
> >>>  1 file changed, 7 deletions(-)
> >>>
> >>> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> >>> index 0a4e41d84df8..c0be9a53ac79 100644
> >>> --- a/drivers/scsi/scsi_debug.c
> >>> +++ b/drivers/scsi/scsi_debug.c
> >>> @@ -1127,7 +1127,6 @@ static const struct file_operations sdebug_target_reset_fail_fops = {
> >>>  static int sdebug_target_alloc(struct scsi_target *starget)
> >>>  {
> >>>  	struct sdebug_target_info *targetip;
> >>> -	struct dentry *dentry;
> >>>  
> >>>  	targetip = kzalloc(sizeof(struct sdebug_target_info), GFP_KERNEL);
> >>>  	if (!targetip)
> >>> @@ -1135,15 +1134,9 @@ static int sdebug_target_alloc(struct scsi_target *starget)
> >>>  
> >>>  	targetip->debugfs_entry = debugfs_create_dir(dev_name(&starget->dev),
> >>>  				sdebug_debugfs_root);
> >>> -	if (IS_ERR_OR_NULL(targetip->debugfs_entry))
> >>> -		pr_info("%s: failed to create debugfs directory for target %s\n",
> >>> -			__func__, dev_name(&starget->dev));
> >>>  
> >>>  	debugfs_create_file("fail_reset", 0600, targetip->debugfs_entry, starget,
> >>>  				&sdebug_target_reset_fail_fops);
> >>> -	if (IS_ERR_OR_NULL(dentry))
> >>> -		pr_info("%s: failed to create fail_reset file for target %s\n",
> >>> -			__func__, dev_name(&starget->dev));
> >>>  
> >>>  	starget->hostdata = targetip;
> >>>  
> >>
> >>
> >> Thank you for the fix, the check for debugfs_create_file() is added because 
> >> scsi_debug driver is often used to test abnormal situations, here just check
> >> and prompt a log, so maybe you should not remove it and fix the issue
> >> following changes:
> >>
> > 
> > No, the correct thing is to remove it.  This is explained in my blog
> > article linked to earlier.
> > 
> > https://staticthinking.wordpress.com/2023/07/24/debugfs-functions-are-not-supposed-to-be-checked/
> > 
> 
> There are other places in scsi_debug which check return value
> of debugfs functions added by my previous patches, would you
> remove them?

It's harmless to check most of the time.  Technically, they should be
removed but that's like a whitespace clean up so it's not worth spending
a lot of time on unless you care about a specific driver.  Here, though,
it was an uninitialized variable bug, and try to fix bugs.

Smatch is really about fixing bugs so I have special code to not warn
about if people check debugfs code for NULL.  Normally Smatch would
complain if people check an error pointer function for NULL but with
debugfs functions it doesn't matter.

regards,
dan carpenter
