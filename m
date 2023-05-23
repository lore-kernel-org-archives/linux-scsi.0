Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BC42C77B75
	for <linux-scsi@archiver.kernel.org>; Tue, 23 May 2023 14:57:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237163AbjEWO5M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 May 2023 10:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbjEWO5L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2023 10:57:11 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F4BE9
        for <linux-scsi@vger.kernel.org>; Tue, 23 May 2023 07:57:09 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-3f606a80d34so15077745e9.0
        for <linux-scsi@vger.kernel.org>; Tue, 23 May 2023 07:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684853828; x=1687445828;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/1Wj0P6YeefVDWUhmrWZwCaqFzfv9dXPwxlScY7Er8M=;
        b=amAVpLeJyPwKhmefM8/EOAHIHLVYlyiJwOdyk6pFO51tvPzhlvX3vOOTggg8tP73YP
         xzBcgusJeBauUJv950RurKmsemJ2NIovZeXxHoSjgHPPXKwDHJOzF7ubHJypOLSO/94t
         fxh1gxyVKCabr2VdjelC711MlJn8t3xT0VqLz+t4luwAUZOkRnPLHWHNHnbv8WtviXub
         l9BC48BpOuZQWtJmqRXoSBdlhBJYqo3gS1F2xU4Q12EYp3piOG5NNY0Oik+Dv+wf1mUP
         d6DAqS4DQ+uhq4ZkhN31RUWDwQxpRS2MDrbKQQxtO7Ay2z84UfxDTggFZK1hQIE7NH7c
         Wm3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684853828; x=1687445828;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/1Wj0P6YeefVDWUhmrWZwCaqFzfv9dXPwxlScY7Er8M=;
        b=W+boLZfz231Y4X1w+cIIwBleX+fT5tbsSqTAPptMCzkW3ism2mEnZQ+4yLBPji8jn5
         sSFk/XrHsIc2llIPah2n9YKoJlUaLKtyvkoLUsHoz7rqYs0Zye+XlX2GlRxIkzGUqJ1+
         eMR9tNC7xiNQO2KJzXBPFpQUL5oIAoHDtoThBD5/CM1Rd9x52kPDrnSQ0l+2rv9lQ1pK
         tcfp8lvBi8/ZIDHWUxSopFIwO2qD3PryLltg2L6jJf/QK7ZW8LkYovTcAZbjd+TwdmoD
         kye5Rg4jyS/lMhtBr3qpOUCp7u61QxTPjiCXad5w0LIIx6lTQbuVMweeEdJODap8bxrr
         4SAg==
X-Gm-Message-State: AC+VfDwDThIvPljJJJj/qtLBEeW3kw6BTqqSkMlcMnN8HRk/mI9FF7q8
        sYZ0GkVBZoVdBXN9xaB5LmfvCw==
X-Google-Smtp-Source: ACHHUZ4Tf0ls0pXCeCE4Vy0Kg1p+ousOsWikkiU/FrmHmlgOsVxZrCE7R6nE7OjJLyNkfOhVRDCXLQ==
X-Received: by 2002:a5d:4e8c:0:b0:306:37ec:656c with SMTP id e12-20020a5d4e8c000000b0030637ec656cmr10823357wru.66.1684853828416;
        Tue, 23 May 2023 07:57:08 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id n1-20020adfe781000000b002c54c9bd71fsm11388835wrm.93.2023.05.23.07.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 07:57:05 -0700 (PDT)
Date:   Tue, 23 May 2023 17:57:03 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Tomas Henzl <thenzl@redhat.com>
Cc:     Dongliang Mu <dzm91@hust.edu.cn>, Jing Xu <U202112064@hust.edu.cn>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        hust-os-kernel-patches@googlegroups.com,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: mpt3sas: mpt3sas_debugfs: return value check of
 `mpt3sas_debugfs_root`
Message-ID: <3c4b372f-db4b-43b4-b5ab-7f4860cf6f20@kili.mountain>
References: <20230423122535.31019-1-U202112064@hust.edu.cn>
 <6e69b57c-80ae-8b6e-cb5f-9e05da46ecd6@redhat.com>
 <1484408f-f68e-4354-ab59-56af9cd1ef14@kili.mountain>
 <b7154e2c-0438-87d1-9edc-7eb1aad40cd1@hust.edu.cn>
 <81d236bb-3913-4eef-bf71-6d17535d6d79@kili.mountain>
 <892bc614-9e2e-904b-29e0-62daeb855f79@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <892bc614-9e2e-904b-29e0-62daeb855f79@redhat.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, May 23, 2023 at 04:48:12PM +0200, Tomas Henzl wrote:
> On 5/8/23 16:38, Dan Carpenter wrote:
> > On Mon, May 08, 2023 at 09:40:41PM +0800, Dongliang Mu wrote:
> >>>>> diff --git a/drivers/scsi/mpt3sas/mpt3sas_debugfs.c b/drivers/scsi/mpt3sas/mpt3sas_debugfs.c
> >>>>> index a6ab1db81167..c92e08c130b9 100644
> >>>>> --- a/drivers/scsi/mpt3sas/mpt3sas_debugfs.c
> >>>>> +++ b/drivers/scsi/mpt3sas/mpt3sas_debugfs.c
> >>>>> @@ -99,8 +99,6 @@ static const struct file_operations mpt3sas_debugfs_iocdump_fops = {
> >>>>>   void mpt3sas_init_debugfs(void)
> >>>>>   {
> >>>>>   	mpt3sas_debugfs_root = debugfs_create_dir("mpt3sas", NULL);
> >>>>> -	if (!mpt3sas_debugfs_root)
> >>>>> -		pr_info("mpt3sas: Cannot create debugfs root\n");
> >>>> Hi Jing,
> >>>> most drivers just ignore the return value but here the author wanted to
> >>>> have the information logged.
> >>>> Can you instead of removing the message modify the 'if' condition so it
> >>>> suits the author's intention?
> >>>
> >>> This code was always just wrong.
> >>>
> >>> The history of this is slightly complicated and boring.  These days it's
> >>> harmless dead code so I guess it's less bad than before.
> >>
> >> Hi Dan and Tomas,
> >>
> >> Any conclusion about this patch? The student Jing Xu is not sure about how
> >> to revise this patch.
> > 
> > The correct fix is to delete the code.
> > 
> > Debugfs code has error checking built in and was never supposed to be
> > checked for errors in normal driver code.
> > 
> > Originally, debugfs returned a mix of error pointers and NULL.  In the
> > kernel, when you have a mix of error pointers and NULL, then the NULL
> > means that the feature has been disabled deliberately.  It's not an
> > error, we should not print a message.
> > 
> > So a different, correct-ish way to write write debugfs error handling
> > was to say:
> > 
> > 	mpt3sas_debugfs_root = debugfs_create_dir("mpt3sas", NULL);
> > 	if (IS_ERR(mpt3sas_debugfs_root))
> > 		return PTR_ERR(mpt3sas_debugfs_root);
> I'm fine with this as well, I could wish we get a fix for the exact same
> case of debugfs_create_dir in mpt3sas_setup_debugfs and ideally all the
> debugfs_create* in  mpt3sas_debugfs.c in a single patch. But this patch
> is ok even if that wasn't possible.
> tomash

No, you didn't read until the end.  That will break the driver badly.

This *used* to be a correct-ish way that *used* to work but it was never
the what Greg wanted.  So to discourage people from doing it, Greg made
it *impossible* to check for if debugfs has failed.  Literally, the only
correct thing to do now is to delete the debugfs checking.

regards,
dan carpenter


