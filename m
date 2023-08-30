Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 524C2C83F15
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Aug 2023 22:40:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343986AbjH3WkU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Aug 2023 18:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343971AbjH3WkT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Aug 2023 18:40:19 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11D30D7
        for <linux-scsi@vger.kernel.org>; Wed, 30 Aug 2023 15:40:05 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-68a3ced3ec6so156574b3a.1
        for <linux-scsi@vger.kernel.org>; Wed, 30 Aug 2023 15:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1693435204; x=1694040004; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rGoN+7ftyg9+iA8OLms4ykMa+abn+xpZnImA1JV+0nM=;
        b=TQdRhcxFF3Dphj1sDkK7sniQ99R7uXXL/XpoHnhuUokJ62pemsF+bDmiRlhtDGCDkX
         G4VUv4uWdLUId/UVC37BzV5X79EDM9aGwtAb1MUvjMVjM65e1Vx8h5y8FdFZx56pcqoF
         AL9DUdAMDQz+8ASOWq3PthdZu7PwRADRF1uDY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693435204; x=1694040004;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rGoN+7ftyg9+iA8OLms4ykMa+abn+xpZnImA1JV+0nM=;
        b=lLSOyx14tVI7azVmEfnYuhlgWEFLnNxOYZRkYiSrf7MNP7jD3pIzOqH71helFF5gmR
         rdUoZZ0txsN7LZgk/KvE4vv08e6md/aAO1dHcrD7QWCyOXSr+vQDwIQsYDHLFTL9NTcM
         XqmkdmBPukJMgTFuyeaRcLBZv8snLQx3jQIkrd6WULpVYSAQmcZ13LHo14sWe4kzoj0I
         CxGNb1s/4sCWSw2wOEtz6p0ptOh95T3FlIxfvnZTGH9IRMcWuA5+MuFVF7uuK+w2+NhA
         /Q2guicChyawRwBzQGU2AaQylDx8aTaaXJkI+xW0YY/B24aupR6tYhgMbXT6e0ESAb6H
         ne7A==
X-Gm-Message-State: AOJu0YyF8VI6o/eNfn/Kd7Su8ZDL2gIsU6JaYaZJfLB3iOcdRUvill4a
        XD1wxyUgoTgm9RUzwvYjPVZA8Q==
X-Google-Smtp-Source: AGHT+IGRKWyzdhU3vc5FYi1/P9ug7Q9xN1iOv2w05gAbb5nV2uv60V6ITd/C5QgGFEa+QRTb8kRA1Q==
X-Received: by 2002:a05:6a00:1355:b0:68a:4312:e0d6 with SMTP id k21-20020a056a00135500b0068a4312e0d6mr4657813pfu.10.1693435204510;
        Wed, 30 Aug 2023 15:40:04 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id j17-20020a62b611000000b0066a2e8431a0sm75593pff.183.2023.08.30.15.40.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Aug 2023 15:40:03 -0700 (PDT)
Date:   Wed, 30 Aug 2023 15:40:03 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Justin Stitt <justinstitt@google.com>
Cc:     Azeem Shaikh <azeemshaikh38@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-hardening@vger.kernel.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: target: Replace strlcpy with strscpy
Message-ID: <202308301538.F89E1E5E23@keescook>
References: <20230830210724.4156575-1-azeemshaikh38@gmail.com>
 <20230830215330.6gyhpq3ohkbbtsam@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230830215330.6gyhpq3ohkbbtsam@google.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Aug 30, 2023 at 09:53:30PM +0000, Justin Stitt wrote:
> On Wed, Aug 30, 2023 at 09:07:24PM +0000, Azeem Shaikh wrote:
> > strlcpy() reads the entire source buffer first.
> > This read may exceed the destination size limit.
> > This is both inefficient and can lead to linear read
> > overflows if a source string is not NUL-terminated [1].
> > In an effort to remove strlcpy() completely [2], replace
> > strlcpy() here with strscpy().
> >
> > Direct replacement is safe here since return value of -errno
> > is used to check for truncation instead of sizeof(dest).
> >
> > [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
> > [2] https://github.com/KSPP/linux/issues/89
> >
> > Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>
> > ---
> > v2:
> >  * Replace all instances of strlcpy in this file instead of just 1.
> >
> > v1:
> >  * https://lore.kernel.org/all/20230830200717.4129442-1-azeemshaikh38@gmail.com/
> >
> >  drivers/target/target_core_configfs.c |   27 ++++++++++++---------------
> >  1 file changed, 12 insertions(+), 15 deletions(-)
> >
> > diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> > index 936e5ff1b209..10a22a428267 100644
> > --- a/drivers/target/target_core_configfs.c
> > +++ b/drivers/target/target_core_configfs.c
> > @@ -1392,16 +1392,15 @@ static ssize_t target_wwn_vendor_id_store(struct config_item *item,
> >  	/* +2 to allow for a trailing (stripped) '\n' and null-terminator */
> >  	unsigned char buf[INQUIRY_VENDOR_LEN + 2];
> >  	char *stripped = NULL;
> > -	size_t len;
> > +	ssize_t len;
> >  	ssize_t ret;
> >
> > -	len = strlcpy(buf, page, sizeof(buf));
> > -	if (len < sizeof(buf)) {
> > +	len = strscpy(buf, page, sizeof(buf));
> > +	if (len > 0) {
> >  		/* Strip any newline added from userspace. */
> >  		stripped = strstrip(buf);
> > -		len = strlen(stripped);
> >  	}
> > -	if (len > INQUIRY_VENDOR_LEN) {
> > +	if (len < 0 || strlen(stripped) > INQUIRY_VENDOR_LEN) {
> >  		pr_err("Emulated T10 Vendor Identification exceeds"
> >  			" INQUIRY_VENDOR_LEN: " __stringify(INQUIRY_VENDOR_LEN)
> >  			"\n");
> 
> Should we be explicitly checking for `len == -E2BIG` instead of the more
> generic `len < 0`? Perhaps this is a nitpick but I prefer the former.

For robustness, we want to just do the "< 0" test -- that way if
strscpy() gains a new errno (for some unimaginable reason) then all the
code testing for "< 0" will continue to work sanely.

-Kees

-- 
Kees Cook
