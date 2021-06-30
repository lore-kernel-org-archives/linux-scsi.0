Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB2DCC11F65
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Jun 2021 16:01:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 891CF61477
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Jun 2021 16:01:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235947AbhF3QET (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Jun 2021 12:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235866AbhF3QER (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jun 2021 12:04:17 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B876FC061756;
        Wed, 30 Jun 2021 09:01:47 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id g3so1790368qth.11;
        Wed, 30 Jun 2021 09:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=VgquIkFATUQKw2xt3ccqyQ1g7M1FlKGEVH4Mz2jCNRI=;
        b=DplxWWnBRscwYwyslDYWKPnlapJHw/L4Vj/NBY4Z5vdfE+uuxjPMEbKPcTLz/KvWsb
         jo8xoWrnaJ2+jSbbmqfvv+JI+z5AgLL1/+cTIL7Q463PO1mCL55Hjrv5G92ayL5mpHGk
         b1VEeOhAnLMYFk+JKmAfmXmfrxtBc2Jr3YvrNaqeeOlIGXR3B5TdPl1gp+MlcRARZuwC
         DSSyQVwQpLZBirUn9LFc1lzGdq+tpqbgTHcV7d7xiX60TWLsapRyozQJ8Hiqjb5vYMUI
         vFOb1mNgtDPCWhNw2XPexbZG4b1ZUfh/cmBjLqk9O2VbX5N+yHMjucvuk6NlqMHSfnMy
         B04A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=VgquIkFATUQKw2xt3ccqyQ1g7M1FlKGEVH4Mz2jCNRI=;
        b=VPzdGS7EORDc7SwP/vo+BT6WWVxkM32jwGXEN1AtgcwqBikMSIMGcrtIDhny6uS1pC
         VTXXqcSdgonLFraQDtLvgOS4NOn3nCsh9B3cckZ4cKkGlf3PgxRPqw0v5/nXskihulZF
         LNeg2pXKWkvhJ9R8aeDRMk2ulayEY0S2V7+ezstTY2MG29v6oya4foz2LDTkjSm9zvyx
         cvzKLA9cfEfcuyDhI9wmh1ExX0OXmyCbpqfg5wenEsCcNqCCBKilJ/MSVu9SXUb5UOOW
         PvwDGSWdAbmHFLQPAEqP2zVV+svGoOCx+JdZ8M4eE3uv4erSjO0f+r8GsAjoppeM6ONa
         lrZQ==
X-Gm-Message-State: AOAM5324xvZrapYPbw8eKigZlD2yh9Rvj4WagFWtiktccafBvo7FDuV8
        K6OeJvEK+mn/iF2/Zq+b4TI=
X-Google-Smtp-Source: ABdhPJzgZOIfAqvQLKW7HIlxfQhxyqklQuVF+2ZjmG9wirCVM1cQyIUH/wyJMWixkXFiXVuDp0RRkQ==
X-Received: by 2002:ac8:4a84:: with SMTP id l4mr23006857qtq.372.1625068906828;
        Wed, 30 Jun 2021 09:01:46 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net. [68.160.176.52])
        by smtp.gmail.com with ESMTPSA id m189sm13546973qkd.107.2021.06.30.09.01.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 09:01:45 -0700 (PDT)
From:   Mike Snitzer <snitzer@gmail.com>
X-Google-Original-From: Mike Snitzer <kbusch@kernel.org>
Date:   Wed, 30 Jun 2021 12:01:45 -0400
To:     Martin Wilck <mwilck@suse.com>
Cc:     Christoph Hellwig <hch@lst.de>, Alasdair G Kergon <agk@redhat.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, dm-devel@redhat.com,
        Hannes Reinecke <hare@suse.de>,
        Daniel Wagner <dwagner@suse.de>, linux-block@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Benjamin Marzinski <bmarzins@redhat.com>, nkoenig@redhat.com,
        emilne@redhat.com
Subject: Re: [PATCH v4 1/3] scsi: scsi_ioctl: export
 __scsi_result_to_blk_status()
Message-ID: <YNyVafnX09cOIZPe@redhat.com>
References: <20210628095210.26249-1-mwilck@suse.com>
 <20210628095210.26249-2-mwilck@suse.com>
 <20210628095341.GA4105@lst.de>
 <4fb99309463052355bb8fefe034a320085acab1b.camel@suse.com>
 <20210629125909.GB14372@lst.de>
 <2b5fd35d95668a8cba9151941c058cb8aee3e37c.camel@suse.com>
 <20210629212316.GA3367857@dhcp-10-100-145-180.wdc.com>
 <1aa1f875e7a85f9a331e88e4f8482588176bdb3a.camel@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1aa1f875e7a85f9a331e88e4f8482588176bdb3a.camel@suse.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jun 30 2021 at  4:12P -0400,
Martin Wilck <mwilck@suse.com> wrote:

> On Di, 2021-06-29 at 14:23 -0700, Keith Busch wrote:
> > On Tue, Jun 29, 2021 at 09:23:18PM +0200, Martin Wilck wrote:
> > > On Di, 2021-06-29 at 14:59 +0200, Christoph Hellwig wrote:
> > > > On Mon, Jun 28, 2021 at 04:57:33PM +0200, Martin Wilck wrote:
> > > > 
> > > > > The sg_io-on-multipath code needs to answer the question "is
> > > > > this a
> > > > > path or a target error?". Therefore it calls blk_path_error(),
> > > > > which
> > > > > requires obtaining a blk_status_t first. But that's not
> > > > > available
> > > > > in
> > > > > the sg_io code path. So how should I deal with this situation?
> > > > 
> > > > Not by exporting random crap from the SCSI code.

Helpful as always Christoph... ;)

> > > So, you'd prefer inlining scsi_result_to_blk_status()?
> > 
> > I don't think you need to. The only scsi_result_to_blk_status()
> > caller
> > is sg_io_to_blk_status(). That's already in the same file as
> > scsi_result_to_blk_status() so no need to export it. You could even
> > make
> > it static.
> 
> Thanks for your suggestion. I'd be lucky if this was true. But the most
> important users of scsi_result_to_blk_status() are in scsi_lib.c
> (scsi_io_completion_action(), scsi_io_completion_nz_result()).
> 
> If I move scsi_result_to_blk_status() to vmlinux without exporting it,
> it won't be available in the SCSI core any more, at least not with
> CONFIG_SCSI=m.

For what you're trying to accomplish with this patchset, you only need
sg_io_to_blk_status() exported.

So check with Martin and/or Bart on the best way to give
sg_io_to_blk_status() access to the equivalent of your
__scsi_result_to_blk_status() without exporting it.

I'd start by just folding patches 1 and 2, fixing up the logic Dan
Carpenter pointed ouit, and only exporting sg_io_to_blk_status().

Mike
