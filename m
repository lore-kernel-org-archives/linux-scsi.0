Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C30EC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 14:12:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CEB66128C
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 14:12:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbhDMONM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 10:13:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49299 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238507AbhDMONL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Apr 2021 10:13:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618323171;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J+fH9MKaeEmWD3rhSgX6grdnxmCJ54qDtsQpZEgHRuk=;
        b=a8+RqZxjypts9rTv5t/G5aG4Qn4saZ74VVMt8GeK9z87MwqUodddXWk2RJ3EtPPwiyrURx
        Wsc2ny9vIYrM+1gejyoHmJAc5JQJnc2YJDhuI6D1JWA6hKjSlIyskaEe7h6jw6MBBkHx05
        uTIVABgD2BJE5XBcdjRNrEoR2/EB3ic=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-579-Ck7ECpE_OaaIbLHiqlVKaA-1; Tue, 13 Apr 2021 10:12:49 -0400
X-MC-Unique: Ck7ECpE_OaaIbLHiqlVKaA-1
Received: by mail-oi1-f198.google.com with SMTP id y189-20020acaafc60000b0290159da8ecff0so4880777oie.4
        for <linux-scsi@vger.kernel.org>; Tue, 13 Apr 2021 07:12:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J+fH9MKaeEmWD3rhSgX6grdnxmCJ54qDtsQpZEgHRuk=;
        b=FdtyB1Fow82qRR/fUPQXYKfI2bex45jGDQ65vxJ33K7TviQWKuqqezhmzT9AucWfm1
         vrd0H52cn1mPx56Kl4LfBbqblKoFB8IP8cyAF5iOrdXzlHUJXZGcT2Dw7suJjnKEGtDb
         QH9deSTK3qjT/jmnhBszZ5m71e5t3QtD2OdQDa2+DJjGvQZ7Lb1WAxuv1TUBgXsw07BC
         LQDNm3ynCfkR7M9p3nt7Ula/QIQaNY7zweDVE7w2JGDjSskmOy02QD2JGsry6qg0Fs/4
         K0M3UmnFevsRVQHs4dDyRXomqiFKKtw1ScFs1ozWv/wSncD6atDZYLyf2HpEtLiLuDCQ
         B9qg==
X-Gm-Message-State: AOAM531ouISRkYhIXI54BZEM0vwfUJpJdmaJ1U21c6i9N0hA8kgKJ4vN
        VBPYUhN6mLIUc887kkwh57I9XTOBYJ+HvatvrhiGcr1z7Red3Qxcs5ctE/exrydMsV4w4pxCes3
        V4Eye+E75X94Vm/teBPG2ffmfdv3BOmvWHBbopA==
X-Received: by 2002:a9d:63d5:: with SMTP id e21mr4023881otl.93.1618323168588;
        Tue, 13 Apr 2021 07:12:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz+iUwLxXdGxPjdEJ/ZkzcxIR7+SkaJUj6b65YazEFzvP5gdMsCArT7TVz2O1SUN2GCba2bCN346f/ZvSwigGk=
X-Received: by 2002:a9d:63d5:: with SMTP id e21mr4023861otl.93.1618323168384;
 Tue, 13 Apr 2021 07:12:48 -0700 (PDT)
MIME-Version: 1.0
References: <1617325783-20740-1-git-send-email-loberman@redhat.com>
 <3ab37563-c620-395c-bd12-74376962728d@acm.org> <3a8e9cfadbb646ed5a520d4972c1f450aae6b5d2.camel@redhat.com>
 <3579fa05385e8f13b15b3e2ca184a33619dd627d.camel@redhat.com> <4b4cb739-a76d-711b-6c7a-0661fc6c4896@acm.org>
In-Reply-To: <4b4cb739-a76d-711b-6c7a-0661fc6c4896@acm.org>
From:   John Pittman <jpittman@redhat.com>
Date:   Tue, 13 Apr 2021 10:12:37 -0400
Message-ID: <CA+RJvhyE_Z1VyPeRxKrGdXur6+bdBweUKGAF6Eb810LZgdy3Ug@mail.gmail.com>
Subject: Re: [PATCH] scsi_mod: Add a new parameter to scsi_mod to control
 storage logging
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Laurence Oberman <loberman@redhat.com>, linux-scsi@vger.kernel.org,
        hare@suse.de, Ewan Milne <emilne@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        David Jeffery <djeffery@redhat.com>,
        dgilbert <dgilbert@interlog.com>, axboe@fb.com,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Good morning Laurence.  I guess we still need Martin's opinion, but
considering how many customers I've had to help get past this, I'd
welcome an easy way out.  Thanks.

Reviewed-by: John Pittman <jpittman@redhat.com>

On Fri, Apr 9, 2021 at 4:59 PM Bart Van Assche <bvanassche@acm.org> wrote:
>
> On 4/8/21 8:56 AM, Laurence Oberman wrote:
> > Hi Bart the original macro is the same so I think best not to change it
> > other than the wrapper I added. What are your thoughts.
>
> Hi Laurence,
>
> Since the current definition is not optimal from a source code
> readability standpoint and since this patch changes the sd_printk()
> definition I think this is a great opportunity to improve that
> definition. Please note that I don't have a strong opinion about this.
>
> Bart.
>

