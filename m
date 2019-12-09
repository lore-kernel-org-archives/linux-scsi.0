Return-Path: <SRS0=QSh0=Z7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED647C43603
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 03:10:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C367A2071A
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 03:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575861047;
	bh=EB2YpaWu4xz71ABGteOELs6xI2WRD092KsDmrSaOY2w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=mM/jIMKHtlyZ32QgtsDDR0AlX7LsZHkHc0DkihO/UDDBvxBBkXXr8LnLoRTE00PDk
	 KOvvW4s/+K1nVPEwHSQdCZ+DZwN/D9RKE7x6CYbJfdhvQzh+IiFU5G9ZSDwzw52Dba
	 Aoow65YcntPi9CR+Rr2Zxp2KtXQaqqwBwKdJLg+A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbfLIDKn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 8 Dec 2019 22:10:43 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:38767 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726748AbfLIDKn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Dec 2019 22:10:43 -0500
Received: by mail-lj1-f196.google.com with SMTP id k8so13848298ljh.5
        for <linux-scsi@vger.kernel.org>; Sun, 08 Dec 2019 19:10:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IsO7dZNBIbPprBYyThs91AYRzpngSHQwAmXmPwKBIg0=;
        b=MEH4ND4Nbsa4gl4HUUT5shBi2298BFMiOLZ4+lFC2yve4Ysbypny+1LndDWz1cqNTn
         4oOqiljoOg+6px1pt4OX19oYw3KLSxMURevpnBdU9w0Twjw/NymP62DqGoJk504Xl2N3
         6N3ACDfBvVDPRNdQ8p5o0tC5Mtx69DXAZkVXg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IsO7dZNBIbPprBYyThs91AYRzpngSHQwAmXmPwKBIg0=;
        b=T6RK6hc4WVseQlo1N7emavRVn7P4QT1WaKT+acA1VIP4E1fINRq+iBv3DL3BfJrFze
         2DevCDH7NFVhKcu2yrhDBiElI8RjP/AN4Kh63GIKAwik//qMgIk3gKjMs7ASNOBvx22J
         o4x6p6Wp4y0xoO1epozDVo0Eg/DNgGSOFKTlPNizPK5GCYIU1fpP3tpV99u76HORcneU
         fEyNmTzyRfXc/r5KfYA23pe44ijzGC3eZm8gI/634Hpv35agIwBPOnZur7qt9bkXCCNb
         fO0qpL4jfOGIUGX/19c8bpW1lmK1hQXDmmQou23VLRNgt0xcMu7VtRqwp8zQUERZFONi
         Tg3Q==
X-Gm-Message-State: APjAAAWMy6kkdliwfCthAyRqZ70QCs5TRJ1Z8WwJxJOE2Itj6mH4B+pK
        mhekqcIgN3e5cOYtHNuUDCQl029+J+U=
X-Google-Smtp-Source: APXvYqzeIz9Ai/jEbZItJ/9J59i6I/fv4znsXacJAn0MyKG30w5DWRgcyMSATn/Xo7ZetIYKce29TA==
X-Received: by 2002:a2e:90c6:: with SMTP id o6mr15208491ljg.93.1575861041038;
        Sun, 08 Dec 2019 19:10:41 -0800 (PST)
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com. [209.85.208.173])
        by smtp.gmail.com with ESMTPSA id r20sm9990817lfi.91.2019.12.08.19.10.40
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Dec 2019 19:10:40 -0800 (PST)
Received: by mail-lj1-f173.google.com with SMTP id d20so13816339ljc.12
        for <linux-scsi@vger.kernel.org>; Sun, 08 Dec 2019 19:10:40 -0800 (PST)
X-Received: by 2002:a2e:99d0:: with SMTP id l16mr15611418ljj.1.1575861039824;
 Sun, 08 Dec 2019 19:10:39 -0800 (PST)
MIME-Version: 1.0
References: <30808b0b-367a-266a-7ef4-de69c08e1319@internode.on.net>
 <09396dca-3643-9a4b-070a-e7db2a07235e@internode.on.net> <CAHk-=wjj8SQx4YzS8yw7ZJJKiVLBY0g=d8rCSyPCM=8Pzmz+Zg@mail.gmail.com>
 <20191209025209.GA4203@ZenIV.linux.org.uk>
In-Reply-To: <20191209025209.GA4203@ZenIV.linux.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 8 Dec 2019 19:10:23 -0800
X-Gmail-Original-Message-ID: <CAHk-=whY0GL-FpnjUmc7fjDqz-yRJ=QBO7LT6aEzt-_raAb1bw@mail.gmail.com>
Message-ID: <CAHk-=whY0GL-FpnjUmc7fjDqz-yRJ=QBO7LT6aEzt-_raAb1bw@mail.gmail.com>
Subject: Re: refcount_t: underflow; use-after-free with CIFS umount after
 scsi-misc commit ef2cc88e2a205b8a11a19e78db63a70d3728cdf5
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Arthur Marsh <arthur.marsh@internode.on.net>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Dec 8, 2019 at 6:52 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> FWIW, the thing that is IME absolutely incompatible with bisection
> is CONFIG_GCC_PLUGIN_RANDSTRUCT.  It can affect frequencies badly
> enough, even in the cases when the bug isn't directly dependent
> upon that thing.

It will easily affect timing in major ways, yes.

You're right that at least the CI bots might want to disable it for
bisecting. Or force a particular seed for RANDSTRUCT - I seem to
recall that there was some way to make it be at least repeatable for
any particular structure.

         Linus
