Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36C91C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Dec 2021 04:24:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240067AbhLHE2D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Dec 2021 23:28:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58410 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244192AbhLHE1s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Dec 2021 23:27:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638937456;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hnkeec58MbvU+mMJ3s+6/jmIYG3nDgFfteK0w/klgc8=;
        b=I8ShHuJWecM0T6/Z6SckjNoXc8Rr6tA6QRdVUFGRQG6dHDbnXBNNAv26mvoxEjs117pIRT
        KOF+wy86BCS1LzM6ocQJQ9+0QurSbdrw9sg6eO+7ErS76vk/1HaqdMEbDbGH+UoWO3bh+h
        dSX1yuMSt5Bk80TzTwk0NUpi6UOVRwE=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-418-NTNgl__fMeygp-DCDVGJRA-1; Tue, 07 Dec 2021 23:24:15 -0500
X-MC-Unique: NTNgl__fMeygp-DCDVGJRA-1
Received: by mail-lf1-f72.google.com with SMTP id o11-20020a056512230b00b0041ca68ddf35so533246lfu.22
        for <linux-scsi@vger.kernel.org>; Tue, 07 Dec 2021 20:24:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hnkeec58MbvU+mMJ3s+6/jmIYG3nDgFfteK0w/klgc8=;
        b=xkd+WVnMJ42XOTx+oP+nqLcHCmbYfPCpfSrS5IlBSrcd8RSPDE5iK3xBOJoNYe5Utz
         SHVfWveqQC7cIzMbCw+SXZhPPF192/o29jI/tAhm3GDp7Ut/vn30DA/T0fCcQ12O5JOG
         MnI7wK39vklRTtH0OAlosQ4SAkJUQVOuA1/0eZceAEXQ+psIQz+uRBsEoyCyf2B/Kskd
         wNMNuKseY3juPZfvelhBE7YMn38Gon+r30JXhZ6ftxxbf/JpVN3gSxnSMYQ2Wx2tYydi
         DemWdev6/zP/gXpNlTOyWOhsNvnxsXjX16sGdxSKiBM8v7Jp5+/r8qdUhKWePOWjtlZK
         lNSA==
X-Gm-Message-State: AOAM532Dx7Hg9i+1ABwBm9JUGIqf/H6QMHUWMmEJlvRTzhVX9FVfFs7d
        ky70yrPJLwtOK+4dgYop0UUOpgkzrvu5sqXyQgoma+2gJm9Ngaa+WQxGziIYnYqfgKoXXzg3W60
        Gng95JQJH5p/nAgMfvJ1Aez7+iOSjLXxWk67mKg==
X-Received: by 2002:a2e:b742:: with SMTP id k2mr47717007ljo.107.1638937453520;
        Tue, 07 Dec 2021 20:24:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxXBQhZIWJ2mKjBeEXvEJ+Z6rREz17GcGHg85bnccKQVzrnxg0n0UvNDUoskUxyeTOvEpr4ldqQWQWb+dL+jYg=
X-Received: by 2002:a2e:b742:: with SMTP id k2mr47716983ljo.107.1638937453292;
 Tue, 07 Dec 2021 20:24:13 -0800 (PST)
MIME-Version: 1.0
References: <20211207025117.23551-1-michael.christie@oracle.com>
In-Reply-To: <20211207025117.23551-1-michael.christie@oracle.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 8 Dec 2021 12:24:02 +0800
Message-ID: <CACGkMEtHm-6pBAdc=ZuXggMwdZ9X1ysnZjUxQFzyBaWtyP5SHg@mail.gmail.com>
Subject: Re: [PATCH V5 00/12] vhost: multiple worker support
To:     Mike Christie <michael.christie@oracle.com>
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>, mst <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Dec 7, 2021 at 10:51 AM Mike Christie
<michael.christie@oracle.com> wrote:
>
> The following patches apply over linus's tree and the user_worker
> patchset here:
>
> https://lore.kernel.org/virtualization/20211129194707.5863-1-michael.christie@oracle.com/T/#t

It looks to me it gets some acks, maybe we need to nudge the
maintainer to merge that? This may simplify the review.

Thanks

