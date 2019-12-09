Return-Path: <SRS0=QSh0=Z7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21191C2D0C0
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 02:23:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2CDC2080D
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 02:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575858206;
	bh=ckJe1f9z+0yhWD6XSFJBjDXQNPIHJUlBowWUcrDFwnM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=qBm+b5HFmsuq5yz96t3dBz4aN42ijgmzYuFJvumxL4VyJQUbcFZUYtURLoBWTba7I
	 yf7Xoydwl/HD2YpZUc7FIM6q9zwVncL0aDUJYvmnzujit/TBSLqfWclXj0r+ktkBwD
	 j50sNQGuIY80HWh2nHcToF1qd+ORtn+qnY3F2nuc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfLICXX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 8 Dec 2019 21:23:23 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:39188 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726834AbfLICXX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Dec 2019 21:23:23 -0500
Received: by mail-lf1-f68.google.com with SMTP id c9so8896591lfi.6
        for <linux-scsi@vger.kernel.org>; Sun, 08 Dec 2019 18:23:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jtNlyNh+mGdA2q4AO/JzXYXFrnuZqMnTZ+qQdX6qkbw=;
        b=dZTJ7Zvl+X4Orlt5MxUX7caFe5OE31NxlNViH1WqR1xDkCBQ5UDeD13DvceCigkefe
         NkUu8l4gfBUHZtIbZVYr5+fPLPBcJzA6yphObSdWg1lXpEgnqyLssA5GvFfNgnMwdzMh
         tAhKKkBhHK2297EJrC4yT/2mx9cAPYvsAmndE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jtNlyNh+mGdA2q4AO/JzXYXFrnuZqMnTZ+qQdX6qkbw=;
        b=o4KJGfuDAAoRD5TB8VMr1osxCEpxeQXB/Lq3Y7tHXkSG86Fe8AQSfpGlX35TXvXd2Y
         ZiRSxbpPrrHIJAukaDjDj5HFGs08z8UlfEGA4QUN/x0Th0D6/t2F9w7ygUwooo87MVyN
         J6znRe1EFAOD0/Cs66Btly/em8xvrLYvWjYzcLlRk0wBLQ3IOjSZn8LdGiZsxWFxziay
         9gFcRGtCtRpuyZTnSdcvFBpyuFgOGpavfFmqxLsRxGwYeS5O5kx5Mtfsb6poSFkebO8y
         3bsNQvAaBrwT4zZ5y14gFRXpaVUZtYxZkOAjfr/Y4EIPhXs8mKY8hnLcWEv8VLnp21eB
         U0zQ==
X-Gm-Message-State: APjAAAU6eZ3B/kodTa+bGP4EikPCFeNAWNDxF45uDjtS2pSmtKVU+mDz
        VGIQ7GG/zBpKvsy4F/ZX44nk27n4Eg0=
X-Google-Smtp-Source: APXvYqwb8nkfXd61WBcZVFvxB+WInxktm8NEZaqDOUu3vVqO5SS0kW8lNhyvEFJlBA2v2ynL1jqCDw==
X-Received: by 2002:ac2:5388:: with SMTP id g8mr13660908lfh.43.1575858200429;
        Sun, 08 Dec 2019 18:23:20 -0800 (PST)
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com. [209.85.208.178])
        by smtp.gmail.com with ESMTPSA id n30sm11406281lfi.54.2019.12.08.18.23.19
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Dec 2019 18:23:19 -0800 (PST)
Received: by mail-lj1-f178.google.com with SMTP id h23so13769978ljc.8
        for <linux-scsi@vger.kernel.org>; Sun, 08 Dec 2019 18:23:19 -0800 (PST)
X-Received: by 2002:a2e:241a:: with SMTP id k26mr15164274ljk.26.1575858198831;
 Sun, 08 Dec 2019 18:23:18 -0800 (PST)
MIME-Version: 1.0
References: <30808b0b-367a-266a-7ef4-de69c08e1319@internode.on.net> <09396dca-3643-9a4b-070a-e7db2a07235e@internode.on.net>
In-Reply-To: <09396dca-3643-9a4b-070a-e7db2a07235e@internode.on.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 8 Dec 2019 18:23:02 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjj8SQx4YzS8yw7ZJJKiVLBY0g=d8rCSyPCM=8Pzmz+Zg@mail.gmail.com>
Message-ID: <CAHk-=wjj8SQx4YzS8yw7ZJJKiVLBY0g=d8rCSyPCM=8Pzmz+Zg@mail.gmail.com>
Subject: Re: refcount_t: underflow; use-after-free with CIFS umount after
 scsi-misc commit ef2cc88e2a205b8a11a19e78db63a70d3728cdf5
To:     Arthur Marsh <arthur.marsh@internode.on.net>
Cc:     SCSI development list <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Dec 8, 2019 at 5:49 PM Arthur Marsh
<arthur.marsh@internode.on.net> wrote:
>
> This still happens with 5.5.0-rc1:

Does it happen 100% of the time?

Your bisection result looks pretty nonsensical - not that it's
impossible (anything is possible), but it really doesn't look very
likely. Which makes me think maybe it's slightly timing-sensitive or
something?

Would you mind trying to re-do the bisection, and for each kernel try
the mount thing at least a few times before you decide a kernel is
good?

Bisection is very powerful, but if _any_ of the kernels you marked
good weren't really good (they just happened to not trigger the
problem), bisection ends up giving completely the wrong answer. And
with that bisection commit, there's not even a hint of what could have
gone wrong.

             Linus
