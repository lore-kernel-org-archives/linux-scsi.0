Return-Path: <SRS0=73BN=CK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5687C433E2
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Sep 2020 10:07:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B480207EA
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Sep 2020 10:07:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZDL+Sj5o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbgIAKG7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Sep 2020 06:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbgIAKG6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Sep 2020 06:06:58 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC52C061244;
        Tue,  1 Sep 2020 03:06:58 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id n23so650161otq.11;
        Tue, 01 Sep 2020 03:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pDrlWYFFkJJmssRq429+R+iuI/x8+DPm+PEwzlRDqBQ=;
        b=ZDL+Sj5oxpSQaoR6SHTUZZvCQ7FGrawiRYTcPP1ISEjV8Nh0SjcZHoAjzrG1DsVkjY
         T5Tu+mYaFHH2GFeUbajP6d4BqB+fIIQZu6bJfRL5EfGJsks7NzlgkMBHX1Jq+Jf3+Sge
         +5AZ8xmnLs45iWiRvRTdu4ePGcd/03w44lK3fLLdI+kcinJIScOq0oXTEqxanPoEML0i
         qi6PD9aKlthYNS8YFTglNlsu7ouvD7XOaP/sbT1RgMViL5oQGjof4DM3LjtqV3/TEh57
         3P9WZHWSk9t+Lk8irPJb/fcHeoVTD0vjwJRL6pXoBrl2pge0s6wRSamce0MqUG9W/k0i
         A5tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pDrlWYFFkJJmssRq429+R+iuI/x8+DPm+PEwzlRDqBQ=;
        b=DslHrc1rN5D8GaEEZcw1nJ3a2dCwCz6cKltslmpLUdYRZkSY9pu4SP5eMgu5JdN6YG
         7WaU7mpjJNeFg6c/aZgYaG6aOE6J8zWuFG8SChe2W8w0bdD9aakPUKn33x36FtFBYYLa
         7pv1jn0l6oL52LRx96MAGP+YUWQFfyXaNvgA51/NDUnr8F/Yw0lxyfxWanMd58xaMP11
         37MyFZp3piKPylkfgYBRQI6PI3wya2EUs/D+nAzCEQK6NIT87MYe6ElM6VdcXDbywbmh
         DDZKHB0405LSwIoJw0BeJf+T3boRPfIJGU9CKIPgKLeBdSvcKCoBObahUxNRRvNqoFbD
         HwtA==
X-Gm-Message-State: AOAM530fIKpK5jqPFPANQgCxBZFuyoU+YL5UCgBBY0sssKdAqkAsQH+Y
        cZQKJbAKLadiUKbxSXoLlC9hwxmekOODPwdm2qE=
X-Google-Smtp-Source: ABdhPJx4lXxBvlL1JVdxVRRP212exraJg+7ZOk+1qs7Vpy3WfCLZR53D+a2GsBQpTXygcuosjRHnzjW/vlzvjKLf66U=
X-Received: by 2002:a05:6830:2246:: with SMTP id t6mr832583otd.264.1598954817468;
 Tue, 01 Sep 2020 03:06:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200817085409.25268-1-allen.cryptic@gmail.com>
 <1597675318.4475.11.camel@linux.ibm.com> <202008171227.D3A4F454D8@keescook> <1597694252.22390.12.camel@linux.ibm.com>
In-Reply-To: <1597694252.22390.12.camel@linux.ibm.com>
From:   Allen <allen.lkml@gmail.com>
Date:   Tue, 1 Sep 2020 15:36:46 +0530
Message-ID: <CAOMdWSKmNVQTpJtdEMNHc5SS75WNS7F0duzQi14kg62R4Un8zA@mail.gmail.com>
Subject: Re: [PATCH 0/8] scsi: convert tasklets to use new tasklet_setup()
To:     jejb@linux.ibm.com
Cc:     Kees Cook <keescook@chromium.org>,
        Allen Pais <allen.cryptic@gmail.com>,
        martin.petersen@oracle.com, kashyap.desai@broadcom.com,
        sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        target-devel@vger.kernel.org, megaraidlinux.pdl@broadcom.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > > >
> > > > Commit 12cc923f1ccc ("tasklet: Introduce new initialization
> > > > API")' introduced a new tasklet initialization API. This series
> > > > converts all the scsi drivers to use the new tasklet_setup() API
> > >
> > > I've got to say I agree with Jens, this was a silly obfuscation:
> > >
> > > +#define from_tasklet(var, callback_tasklet, tasklet_fieldname) \
> > > +       container_of(callback_tasklet, typeof(*var),
> > > tasklet_fieldname)
> > >
> > > Just use container_of directly since we all understand what it
> > > does.
> >
> > But then the lines get really long, wrapped, etc.
>
> I really don't think that's a problem but if you want to add a new
> generic container_of that does typeof instead of insisting on the type,
> I'd be sort of OK with that ... provided you don't gratuitously alter
> the argument order.
>
> The thing I object to is that this encourages everyone to roll their
> own unnecessary container_of type macros in spite of the fact that it's
> function is wholly generic.  It's fine if you're eliminating one of the
> arguments, or actually making the macro specific to the type, but in
> this case you're not, you're making a completely generic macro where
> the name is the only thing that's specific to this case.
>
> >  This is what the timer_struct conversion did too (added a
> > container_of wrapper), so I think it makes sense here too.
>
> I didn't see that one to object to it ...

Since we could not get the generic API accepted, can I send out V2
which would use container_of()?

Thanks,

-- 
       - Allen
