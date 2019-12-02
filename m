Return-Path: <SRS0=lopX=ZY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E64CC432C3
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Dec 2019 21:58:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53E482073C
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Dec 2019 21:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575323900;
	bh=RFyQOZq83qYdIN6R6bKMfwpnyADQiSNkcTiQSqDTWx4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=mrjLvkjdowkcgOB+W0XG9CxQ8N3x7PM+d88irEyy1qRAeL3/XBSGw14wm5c2A4yfM
	 p4H+/W6zdEN1LtnYeTUN3oa0L23N/CsISft1mB18z8wxq2/Bh/Zvgu18vfophq0yWE
	 79lxgsY1CtS7GfgNSWu77VP8+kuEx2OBp46jcFck=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbfLBV6S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Dec 2019 16:58:18 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:39064 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbfLBV6R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Dec 2019 16:58:17 -0500
Received: by mail-lj1-f196.google.com with SMTP id e10so1288207ljj.6
        for <linux-scsi@vger.kernel.org>; Mon, 02 Dec 2019 13:58:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AouDAgA+J4VybjzNvK6JJ1TaiqXLV/JGnpANufytYVM=;
        b=NWARLlNt+JDbaPQTlbt/lW+z4ZiRUQtoroXOODH5gyyBcR1jSXyl99/JGwHHvI6rjG
         ilQ6WOfhi1QDoOdZ6MgYvA4Ur6Mi4YohIK3ZW3Dp7b/Fg7mABEzEeRZ9HfixQdriPM3I
         hXluwApQE6wB/zXtq0ygo/a7X7Oyr+BrlkUV4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AouDAgA+J4VybjzNvK6JJ1TaiqXLV/JGnpANufytYVM=;
        b=kVWgkOLJF8WlLoigf5K+O5MM5vguUwlDHkn+FdDjiTZRblGJ6YW+vQ9codpVJ8h9zy
         DMLCPJErXcrX0WTIrMBqdx3NKL1AzbMTJmeujK27wYz1sqmxDBdR2SybXaasfACNJCxS
         J5pGnG7uRPGKlYTi0j6sAEihTH76ytsAmZb6YlNiuuUHByfJytXtoHGNQmZTy5/0mDw7
         JSh3EEz9E/iCGn8Rb51y+Rz3NKtc4LP5UvoqXzWlEW+dTxpKFHDafyhb2+Zjbg+rJcHP
         JBw85WMiMeqte0KNLdQx5P4pRz86yiJN+0EVm0KA7nuBdHaFiIh/ZjhSTfvBH8z/QkSX
         2VTQ==
X-Gm-Message-State: APjAAAWGVIZQWAZb/mV666YTrwy2Ii0H1HgmTKynu2BN/lSk1omJ0yUP
        Z2XrGdfTemSuOx8RhHCvnS0cJcYppec=
X-Google-Smtp-Source: APXvYqwRbrx1+ZzyknZZC3S3jrESK35hHXz7ItgciMWrWvwldUL/36+RsJGESkKuREZ+ThiwFM12iA==
X-Received: by 2002:a2e:970e:: with SMTP id r14mr553171lji.57.1575323894816;
        Mon, 02 Dec 2019 13:58:14 -0800 (PST)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com. [209.85.208.179])
        by smtp.gmail.com with ESMTPSA id r125sm217548lff.59.2019.12.02.13.58.13
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Dec 2019 13:58:13 -0800 (PST)
Received: by mail-lj1-f179.google.com with SMTP id h23so1262872ljc.8
        for <linux-scsi@vger.kernel.org>; Mon, 02 Dec 2019 13:58:13 -0800 (PST)
X-Received: by 2002:a2e:9041:: with SMTP id n1mr568601ljg.133.1575323892985;
 Mon, 02 Dec 2019 13:58:12 -0800 (PST)
MIME-Version: 1.0
References: <1575137443.5563.18.camel@HansenPartnership.com>
In-Reply-To: <1575137443.5563.18.camel@HansenPartnership.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 2 Dec 2019 13:57:57 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjWNpPW91wyEj4FC4pOimWEUtLVb_RwQgB+9h2OO6ynyA@mail.gmail.com>
Message-ID: <CAHk-=wjWNpPW91wyEj4FC4pOimWEUtLVb_RwQgB+9h2OO6ynyA@mail.gmail.com>
Subject: Re: [GIT PULL] first round of SCSI updates for the 5.4+ merge window
To:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Nov 30, 2019 at 10:10 AM James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
>    The two major core
> changes are Al Viro's reworking of sg's handling of copy to/from user,
> Ming Lei's removal of the host busy counter to avoid contention in the
> multiqueue case and Damien Le Moal's fixing of residual tracking across
> error handling.

Math is hard. You say "The two major core changes are.." and then you
list _three_ changes.

Anyway, the sg copyin/out changes by Al conflicted fairly badly with
Arnd's compat_ioctl changes.

Al did

  c35a5cfb4150 ("scsi: sg: sg_read(): simplify reading ->pack_id of
userland sg_io_hdr_t")

which avoided doing a whole allocation of an 'sg_io_hdr_t' to just
read the one field of it.

But Arnd did

  98aaaec4a150 ("compat_ioctl: reimplement SG_IO handling")

which created a get_sg_io_hdr() helper that copied the 'sg_io_hdr_t'
from user space the right way for both compat and native, which
basically relied on the old approach.

So I effectively reverted Al's patch in order to take Arnd's patch in
the crazy sg legacy case that presumably nobody really cares about
anyway, since everybody should use SG_IO rather than the sg_read()
thing. But I know not everybody is.

I added a comment in that place:

              /*
               * This is stupid.
               *
               * We're copying the whole sg_io_hdr_t from user
               * space just to get the 'pack_id' field. But the
               * field is at different offsets for the compat
               * case, so we'll use "get_sg_io_hdr()" to copy
               * the whole thing and convert it.
               *
               * We could do something like just calculating the
               * offset based of 'in_compat_syscall()', but the
               * 'compat_sg_io_hdr' definition is in the wrong
               * place for that.
               */

since it turns out that the one 'pack_id' field we want does have the
same format in compat  mode as in native mode ("int" and
"compat_int_t" are the same), it's just at different offsets. But the
definition of 'compat_sg_io_hdr' isn't available in that place.

I'm leaving it to Al and Arnd to decide if they want to fix the
stupidity. I tried to make the minimally invasive merge resolution.

Al, Arnd? Comments?

It looks like linux-next punted on this entirely, and took Al's
simplified version that doesn't work with the compat case. Maybe I
should have done the same - if you use read() on the /dev/sg* device,
you deserve to get broken for the compat case. And it didn't
historically work anyway. But it was kind of sad to see how Arnd fixed
it, and then it got broken again.

I really really wish we could get rid of sg_read/sg_write() entirely,
and have SG_IO_SUBMIT and SG_IO_RECEIVE ioctl's that can handle the
queued cases that apparently some people need. Because the read/write
case really is disgusting.

                Linus
