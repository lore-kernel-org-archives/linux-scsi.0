Return-Path: <SRS0=hsTv=24=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BF6CC3F68F
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jan 2020 00:19:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 717C42072E
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jan 2020 00:19:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B4LQddkf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbgAGATY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jan 2020 19:19:24 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:60039 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727025AbgAGATX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jan 2020 19:19:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578356362;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P6DKJqEOe4vhsCWKNTqOKkUCkY52yGXVAFKOlUKBEWs=;
        b=B4LQddkf/6YhUODI9BvwUFDr0RqmUcgaAH+HX6x2uPqu1EDL/SK5wILumMRC5DbEZ4hpmV
        +xUR9xBEbOuUryL+fLMc6XC+hOo5uPd/GfZWgSGHnbLrEzhRtyJkJNVLTT+/1xw4h1XrBw
        AQvKOhW2XEAc1gVvYp5YNgs9E6Jur8M=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-310-_oq9EQZ9NyS35xcnZy1gEA-1; Mon, 06 Jan 2020 19:19:19 -0500
X-MC-Unique: _oq9EQZ9NyS35xcnZy1gEA-1
Received: by mail-qt1-f197.google.com with SMTP id b14so8218875qtt.1
        for <linux-scsi@vger.kernel.org>; Mon, 06 Jan 2020 16:19:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P6DKJqEOe4vhsCWKNTqOKkUCkY52yGXVAFKOlUKBEWs=;
        b=P5IlSfd3Pl/yvzhhftvJ4w9C2Hxt90GkjgbgMLM/dhYSz72uAe85PgUEhpuNBoLojE
         eGxT4l4fSuuoaU38zBVtCV/cNXqIDs+kUzqJZRXS/xbAOdcp49GHMwgUliGl2jVgocWl
         +X72VBZfTU5J/D9i7rDNm0b0RnZUaOjPSFAg0cZoix4F2ii/SxaItVbhkpVX5tuAzE7d
         EXF3sJ2QBUJLr44kTAKyHjT3Mn4XPr5ZSv6IgL2FFROr5OcR3ugwEKoc/aDSoQMUsl7+
         rczwVOhisvrFpeWPC1RJb9cnKThC0XOVZRikfweeHdMo7FrKxs8pPDq86VUW+hHK7uKD
         wKMw==
X-Gm-Message-State: APjAAAVS/1DQq2yUbA5xQXxMXpoCOgheE0TTZzUteToih+XolfliqMyZ
        1bYja/eKrk8a5wjYk+xXXiHZd3T94FF/3vqE5LA+WV5J4+DYbZcREbGiByTE7MX7eHTs043ZDyQ
        OgT7d4D7bEP09vk/Y+gDn+nfFtQPXTW3lifdrDQ==
X-Received: by 2002:a05:620a:78f:: with SMTP id 15mr10781733qka.295.1578356358794;
        Mon, 06 Jan 2020 16:19:18 -0800 (PST)
X-Google-Smtp-Source: APXvYqwJKN93GGwNU9UovvnmTG1xqjy4nzbN2izviq9dtjrnRSJfQEtYKlj5BpLwckCuiU2VHx3CPvzGp0ntCgA4OY4=
X-Received: by 2002:a05:620a:78f:: with SMTP id 15mr10781716qka.295.1578356358552;
 Mon, 06 Jan 2020 16:19:18 -0800 (PST)
MIME-Version: 1.0
References: <20191223225558.19242-1-tasleson@redhat.com> <20191223225558.19242-10-tasleson@redhat.com>
 <20200104025620.GC23195@dread.disaster.area> <5ad7cf7b-e261-102c-afdc-fa34bed98921@redhat.com>
 <20200106220233.GK23195@dread.disaster.area>
In-Reply-To: <20200106220233.GK23195@dread.disaster.area>
From:   Sweet Tea Dorminy <sweettea@redhat.com>
Date:   Mon, 6 Jan 2020 19:19:07 -0500
Message-ID: <CAMeeMh-zr309TzbC3ayKUKRniat+rzurgzmeM5LJYMFVDj7bLA@mail.gmail.com>
Subject: Re: [RFC 9/9] __xfs_printk: Add durable name to output
To:     Dave Chinner <david@fromorbit.com>
Cc:     Tony Asleson <tasleson@redhat.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > >> +
> > >>    if (mp && mp->m_fsname) {
> > >
> > > mp->m_fsname is the name of the device we use everywhere for log
> > > messages, it's set up at mount time so we don't have to do runtime
> > > evaulation of the device name every time we need to emit the device
> > > name in a log message.
> > >
> > > So, if you have some sooper speshial new device naming scheme, it
> > > needs to be stored into the struct xfs_mount to replace mp->m_fsname.
> >
> > I don't think we want to replace mp->m_fsname with the vpd 0x83 device
> > identifier.  This proposed change is adding a key/value structured data
> > to the log message for non-ambiguous device identification over time,
> > not to place the ID in the human readable portion of the message.  The
> > existing name is useful too, especially when it involves a partition.
>
> Oh, if that's all you want to do, then why is this identifier needed
> in every log message? It does not change over the life of the
> filesystem, so it the persistent identifier only needs to be emitted
> to the log once at filesystem mount time. i.e.  instead of:
>
> [    2.716841] XFS (dm-0): Mounting V5 Filesystem
>
> It just needs to be:
>
> [    2.716841] XFS (dm-0): Mounting V5 Filesystem on device <persistent dev id>
>
> If you need to do any sort of special "is this the right device"
> checking, it needs to be done immediately at mount time so action
> can be taken to shutdown the filesystem and unmount the device
> immediately before further damage is done....
>
> i.e. once the filesystem is mounted, you've already got a unique and
> persistent identifier in the log for the life of the filesystem (the
> m_fsname string), so I'm struggling to understand exactly what
> problem you are trying to solve by adding redundant information
> to every log message.....
>

Log rotation loses that identifier though; there are plenty of setups
where a mount-time message has been rotated out of all logs by the
time something goes wrong after a month or two.

