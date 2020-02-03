Return-Path: <SRS0=0hmW=3X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7727C3524D
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Feb 2020 09:16:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BCFE20721
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Feb 2020 09:16:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="ehBfDw2q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727708AbgBCJQ6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Feb 2020 04:16:58 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:42966 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726244AbgBCJQ6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Feb 2020 04:16:58 -0500
Received: by mail-ot1-f66.google.com with SMTP id 66so12936949otd.9
        for <linux-scsi@vger.kernel.org>; Mon, 03 Feb 2020 01:16:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GAYxMmWNN6Zq5JBx1Vo2F6Uct5E25DQ2i09kRUX3Fc4=;
        b=ehBfDw2q5JGgy0gvjZ0jKXI+uFHrajHRZ3yaHnGlHYVOw0DCbTTTWhea/ng/IUYKa+
         wCpHjqR6zIjve4CvP2YLODJcsQINChtfRg6Cl3bptbJbA1Q1bIyovbV6hA2m/YA2mqLg
         rIdGyCFEkpJ5GCOPTqx5pfi0hEIIg7j3MNqr4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GAYxMmWNN6Zq5JBx1Vo2F6Uct5E25DQ2i09kRUX3Fc4=;
        b=Tyyq4kZXRqj9jUlAYuQD7sjFDuJgSmRk43aGAB7ZkM62W/3FphlF32AIH+Uh2DBAlf
         pVHFkUitXaSNtsrI7KrA9rkF57zTC1lcno+Vct5tUm4uPGhnzRpM4wl4anrdiUmiy1a0
         cbIeMPeHm2ZY+lMGS85nppQ6GhXSe0N8E4ex99UjF316PIFO5fCNofHj5jITZz13atgG
         bHUEzG4QW323XjbCCMjz04tv1EhbvTxLsE66eHtMGfwJCtIAT4uwtPjqg1PLYFBTOT2B
         acrzek/hap1VLCvot7L8kLZ7p6xgi/UiK0nYbqkLxBZoYeVNct56LnMN6ia2jnHO04O1
         12Gg==
X-Gm-Message-State: APjAAAX+dJsEpL8sWIXGr+vvrRMQ0acTcEoTEJCfuDx9BFgdH9qlw6EP
        N/zP2gwmV4Dzd8Vg9dFw1c7zKa9YEv11SHLMBIETtQ==
X-Google-Smtp-Source: APXvYqx2ZNnvKAO85+dZYzqBFKZqGb/8CmOh3JsmOrDnsm0a78lz1FFfzdLaIQfjLuNGOi49bWegvc0/xPfzaJhRRzU=
X-Received: by 2002:a9d:23b5:: with SMTP id t50mr16467997otb.122.1580721417001;
 Mon, 03 Feb 2020 01:16:57 -0800 (PST)
MIME-Version: 1.0
References: <20200131132350.31840-1-thenzl@redhat.com> <ff50f95a-1885-9fce-946c-f31861c06486@suse.com>
In-Reply-To: <ff50f95a-1885-9fce-946c-f31861c06486@suse.com>
From:   Sumit Saxena <sumit.saxena@broadcom.com>
Date:   Mon, 3 Feb 2020 14:46:30 +0530
Message-ID: <CAL2rwxqDTRmmk_RUEHQpf6MUu5CBaKKBu8W0D3o=y0Yygo6unw@mail.gmail.com>
Subject: Re: [PATCH] megaraid_sas: silence a warning
To:     Lee Duncan <lduncan@suse.com>
Cc:     Tomas Henzl <thenzl@redhat.com>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Feb 1, 2020 at 10:57 PM Lee Duncan <lduncan@suse.com> wrote:
>
> On 1/31/20 5:23 AM, Tomas Henzl wrote:
> > Add a flag to dma mem allocation to silence a warning.
> >
> > Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> > ---
> >  drivers/scsi/megaraid/megaraid_sas_fusion.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> > index 0f5399b3e..1fa2d1449 100644
> > --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> > +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> > @@ -606,7 +606,8 @@ megasas_alloc_request_fusion(struct megasas_instance *instance)
> >
> >       fusion->io_request_frames =
> >                       dma_pool_alloc(fusion->io_request_frames_pool,
> > -                             GFP_KERNEL, &fusion->io_request_frames_phys);
> > +                             GFP_KERNEL | __GFP_NOWARN,
> > +                             &fusion->io_request_frames_phys);
> >       if (!fusion->io_request_frames) {
> >               if (instance->max_fw_cmds >= (MEGASAS_REDUCE_QD_COUNT * 2)) {
> >                       instance->max_fw_cmds -= MEGASAS_REDUCE_QD_COUNT;
> > @@ -644,7 +645,7 @@ megasas_alloc_request_fusion(struct megasas_instance *instance)
> >  open-isns-updates.diff.bz2
> >               fusion->io_request_frames =
> >                       dma_pool_alloc(fusion->io_request_frames_pool,
> > -                                    GFP_KERNEL,
> > +                                    GFP_KERNEL | __GFP_NOWARN,
> >                                      &fusion->io_request_frames_phys);
> >
> >               if (!fusion->io_request_frames) {
> >
>
> I'm fairly sure this is a good fix, but I'd appreciate more information
> in the comment, such as what warning was silenced, and why it's okay to
> silence it rather than "fix" it. I know from experience that, when
> choosing which commits to backport, more information is better than less.
This code allocates DMA memory for driver's IO frames which may exceed
MAX_ORDER pages for few
megaraid_sas controllers(controllers with High Queue Depth). So there
is logic to keep on reducing controller
Queue Depth until DMA memory required for IO frames fits within
MAX_ORDER. So or impacted megaraid_sas controllers,
there would be multiple DMA allocation failure until driver settles
down to Controller Queue Depth which has memory requirement
within MAX_ORDER. These failed DMA allocation requests causes stack
traces in system logs which is not harmful and this patch
would silence those warnings/stack traces.

With CMA (Contiguous Memory Allocator) enabled, it's possible  to
allocate DMA memory exceeding MAX_ORDER.
And that is the reason of keeping this retry logic with less
controller Queue Depth instead of calculating controller Queue depth
at first hand which has memory requirement less than MAX_ORDER.

Thanks,
Sumit
>
> --
> Lee Duncan
