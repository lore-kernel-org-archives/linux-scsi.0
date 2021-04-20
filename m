Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B3B9C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 06:53:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00AF06101C
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 06:53:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbhDTGxo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Apr 2021 02:53:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25932 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230244AbhDTGxn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Apr 2021 02:53:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618901580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/PfnWms+EwnH/NoSnBR5gBWjr0TH1/sCBu/QK5oLjTo=;
        b=dGGQxQvXK4+CynDV/KZpMUZZ0YahZv4iS8Tbe12QuR65s/rzafNobIvC4p5jVYazAYW9mi
        7QY/qlJq7sku6RAo+F1/2/kUT2ceBENLwzxq5oN7X56nZmZ/lGT1j99Ev+jiT2eqeOPOyv
        9HCEJRcleYvSgggYkV4VBZJkU2j5nY4=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-582-SAlxfq1NPJSXP2Fieipjyw-1; Tue, 20 Apr 2021 02:52:58 -0400
X-MC-Unique: SAlxfq1NPJSXP2Fieipjyw-1
Received: by mail-ej1-f71.google.com with SMTP id re9-20020a170906d8c9b029037ca22d6744so4384285ejb.0
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 23:52:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/PfnWms+EwnH/NoSnBR5gBWjr0TH1/sCBu/QK5oLjTo=;
        b=C3sTgQZO8/Euhyv+C/OfHmTpGg6DGbtP1cdsc3mVQE2KLNYwhEHpXl5Ijl7h62L4Uq
         1AXMeYy/ZR78A7Zl5VCNqbXsoDRZ97b+tJkkAsVwLOcygBk9A0FyQZuOz482cyu5m8hz
         jcP2vmH/mzYsVkB8TvNPrU2BxN9FVa70yzzCupj3Wp49PJ5yEKLKdLOIEUogIxjrQ5gv
         ndI/Q2XXPHMb5EFLZlktmdooHZHAgy3YUPH0dmqJOikvHtXjhy7ZN9REuO5zz+2bDm3G
         Gy815SxfxC4r0YXs8zxEgpVP4BNdpcHxsGFWfVp6/tYzaeIH+Y6Y0QsZVf1MxUccdp18
         57MQ==
X-Gm-Message-State: AOAM53121tji2FMcmLDNWVWeIwLVrOFKGSr8Ag7NZ67BPWEOzwIrpzIL
        Xh+rS1ts3gG6f36+rdVGC9ODLayrULCC6XxgKEGgQSaySvdRUHofv6PKTKF6UBtBvfZ1dRjXJ/J
        o4AyGA04qglNwM8wp3jDPYa8meGU7+9cPJEyJPw==
X-Received: by 2002:aa7:d48a:: with SMTP id b10mr24597374edr.202.1618901577469;
        Mon, 19 Apr 2021 23:52:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyq21JqQVeKWDLnvEsuqxvhuS1RMZIhV1OoFAVE4Q6/XPt0hJSdogosAfMLEOSlMENqdvslSiGad4Mp/wzYIJQ=
X-Received: by 2002:aa7:d48a:: with SMTP id b10mr24597355edr.202.1618901577289;
 Mon, 19 Apr 2021 23:52:57 -0700 (PDT)
MIME-Version: 1.0
References: <9a6145a5-e6ac-3d33-b52a-0823bfc3b864@huawei.com>
 <cb326d404c6e0785d03a7dfadc42832c@mail.gmail.com> <YHbOOfGNHwO4SMS7@T590>
 <87ceccf2-287b-9bd1-899a-f15026c9e65b@huawei.com> <YHe3M62agQET6o6O@T590>
 <3e76ffc7-1d71-83b6-ef5b-3986e947e372@huawei.com> <YHgvMAHqIq9f6pQn@T590>
 <f66f9204-83ff-48d4-dbf4-4a5e1dc100b7@huawei.com> <YHjeUrCTbrSft18t@T590>
 <217e4cc1-c915-0e95-1d1c-4a11496080d6@huawei.com> <YHlNS3RqsYDMA3jQ@T590>
 <89ebc37c-21d6-c57e-4267-cac49a3e5953@huawei.com> <ccdaee0e-3824-927c-8647-e8f44c1557dc@interlog.com>
 <f9b143ac-c5df-eedc-13da-8e0c2399abb4@acm.org> <993c3ae5-a7e2-aa6d-a6f3-147f06e9d015@interlog.com>
In-Reply-To: <993c3ae5-a7e2-aa6d-a6f3-147f06e9d015@interlog.com>
From:   Ming Lei <ming.lei@redhat.com>
Date:   Tue, 20 Apr 2021 14:52:49 +0800
Message-ID: <CAFj5m9LPe=TdJgz2iJ7U6UT4=x-5aE=YbRgOQ80RHfpp62GQQQ@mail.gmail.com>
Subject: Re: [bug report] shared tags causes IO hang and performance drop
To:     dgilbert@interlog.com
Cc:     Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Apr 20, 2021 at 12:54 PM Douglas Gilbert <dgilbert@interlog.com> wrote:
>
> On 2021-04-19 11:22 p.m., Bart Van Assche wrote:
> > On 4/19/21 8:06 PM, Douglas Gilbert wrote:
> >> I have always suspected under extreme pressure the block layer (or scsi
> >> mid-level) does strange things, like an IO hang, attempts to prove that
> >> usually lead back to my own code :-). But I have one example recently
> >> where upwards of 10 commands had been submitted (blk_execute_rq_nowait())
> >> and the following one stalled (all on the same thread). Seconds later
> >> those 10 commands reported DID_TIME_OUT, the stalled thread awoke, and
> >> my dd variant went to its conclusion (reporting 10 errors). Following
> >> copies showed no ill effects.
> >>
> >> My weapons of choice are sg_dd, actually sgh_dd and sg_mrq_dd. Those last
> >> two monitor for stalls during the copy. Each submitted READ and WRITE
> >> command gets its pack_id from an incrementing atomic and a management
> >> thread in those copies checks every 300 milliseconds that that atomic
> >> value is greater than the previous check. If not, dump the state of the
> >> sg driver. The stalled request was in busy state with a timeout of 1
> >> nanosecond which indicated that blk_execute_rq_nowait() had not been
> >> called. So the chief suspect would be blk_get_request() followed by
> >> the bio setup calls IMO.
> >>
> >> So it certainly looked like an IO hang, not a locking, resource nor
> >> corruption issue IMO. That was with a branch off MKP's
> >> 5.13/scsi-staging branch taken a few weeks back. So basically
> >> lk 5.12.0-rc1 .
> >
> > Hi Doug,
> >
> > If it would be possible to develop a script that reproduces this hang and
> > if that script can be shared I will help with root-causing and fixing this
> > hang.
>
> Possible, but not very practical:
>     1) apply supplied 83 patches to sg driver
>     2) apply pending patch to scsi_debug driver
>     3) find a stable kernel platform (perhaps not lk 5.12.0-rc1)
>     4) run supplied scripts for three weeks
>     5) dig through the output and maybe find one case (there were lots
>        of EAGAINs from blk_get_request() but they are expected when
>        thrashing the storage layers)

Or collecting the debugfs log after IO hang is triggered in your test:

(cd /sys/kernel/debug/block/$SDEV && find . -type f -exec grep -aH . {} \;)

$SDEV is the disk on which IO hang is observed.

Thanks,
Ming

