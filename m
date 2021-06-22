Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D608C2B9F4
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Jun 2021 10:27:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5977C613B7
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Jun 2021 10:27:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbhFVK3T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Jun 2021 06:29:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29857 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229702AbhFVK3R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 22 Jun 2021 06:29:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624357621;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=siR5F5coGX/fvj955knbP4EoltfJ1YJx6jJhEHOgFcw=;
        b=cPq+HYVTRpXpPLGOvzjM/EzpzBUWAVSxAj9tDPgorY6SjOogncLRKlqMHm8FqqljGizl09
        SYPC8VQn7cr2IwBsQ8pyThnqx1v6pJonKViCSQ1G9/Q/MYS10nV6eaTQiEAgA8bJiRdN/O
        ZZ+hBP+tEeLh/oHKds76nlYuagCZxkY=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-513-dKl7KSCHPxiIsPLAESb5Hw-1; Tue, 22 Jun 2021 06:26:58 -0400
X-MC-Unique: dKl7KSCHPxiIsPLAESb5Hw-1
Received: by mail-qv1-f71.google.com with SMTP id k12-20020a0cfd6c0000b029020df9543019so17543085qvs.14
        for <linux-scsi@vger.kernel.org>; Tue, 22 Jun 2021 03:26:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=siR5F5coGX/fvj955knbP4EoltfJ1YJx6jJhEHOgFcw=;
        b=o/cXCzCxcQ4t1hLlGUG+Cn9qJQg74qXoG3b2Svi5CDRikg+L2HkJaIL3AzZ6Wkwtor
         /A/meq+XFuAwmvynyLxkGl7D30DbaH9DssD23dOjJM8fyPNHPIrWlafrJzh89no7iy5x
         drFDJMUJsJmDZu0Go0kjQRjP02wt/qt5N3mv9xea6u3jNLsFVR9c79P1MBoVWUdZRiMp
         OcxanllRmtmDz5HqY7Hea7YWjwtd7JBubkJliOXOrT6tih8mcBRdziZc/PxuFhA0sncY
         IueYdxgHiodEgspj6vgTT5QOAzXXCzkfBTKAKqFfvulhxjFAPAAqfqSzja8jni248gh/
         99JA==
X-Gm-Message-State: AOAM532/Hr14cb8KWpLxe5cLfuyRIf2QJqRldjj+bfweTJBiPgQSAiYz
        aXhlUs6vq4jGgCCPRRhU/jT1zcrGn/GVjAfOtZeNOzBXfcrhcN/AhKuuIK8uFepAK9lbBQirdya
        z44SMouQ99RdsM+ksqJrid/+Eh8UvBZ+o+LtFhA==
X-Received: by 2002:a25:6b51:: with SMTP id o17mr3764571ybm.149.1624357618001;
        Tue, 22 Jun 2021 03:26:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx51iJzo3VQdY7wvp65huVXeoq6ZRKEMI6FlXVXnnznFYjauaClofHKuKy4zgoJo/B0s4g+7Wgoq/dtKokW8Ds=
X-Received: by 2002:a25:6b51:: with SMTP id o17mr3764548ybm.149.1624357617775;
 Tue, 22 Jun 2021 03:26:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210622024654.12543-1-bvanassche@acm.org>
In-Reply-To: <20210622024654.12543-1-bvanassche@acm.org>
From:   Ming Lei <ming.lei@redhat.com>
Date:   Tue, 22 Jun 2021 18:26:46 +0800
Message-ID: <CAFj5m9LeEKBqFb684r1GuojWW0TuMLgvHd8bwiVq=qekyxZb7g@mail.gmail.com>
Subject: Re: [PATCH] scsi: Inline scsi_mq_alloc_queue()
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ed Tsai <ed.tsai@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jun 22, 2021 at 10:47 AM Bart Van Assche <bvanassche@acm.org> wrote:
>
> Since scsi_mq_alloc_queue() only has one caller, inline it. This change
> was suggested by Christoph Hellwig.
>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Ed Tsai <ed.tsai@mediatek.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Ming Lei <ming.lei@redhat.com>

