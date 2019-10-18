Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EE29CA9EAB
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 15:13:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27E75222C5
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 15:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571411592;
	bh=pzDE1n0YiuxtPgLDCC29Lmj45rwffh951llpqts7Ox4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=LOSHRGy/p4qWtc3EXMkPtGuGvCaJp+/9PLsnZcm7jY9cwc7RsB81ZM+MvvaycEzTP
	 F7enIOXTWI6GbUb+lIOcD8D6LkJiWWhHSZv4DUEiBn+jI6zn6S1E+qyNomLDTQwQOT
	 lPKpCeZg0/7aJEqiXmvNzFfhITk4tYbA8yyVrGBI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406825AbfJRPNL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 11:13:11 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:43396 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393118AbfJRPNL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Oct 2019 11:13:11 -0400
Received: by mail-lj1-f196.google.com with SMTP id n14so6577841ljj.10
        for <linux-scsi@vger.kernel.org>; Fri, 18 Oct 2019 08:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m4AT2pHM5eKiwWql/S0na26YGuwD55vsY36Ry4jT4KQ=;
        b=byTTQL4kWuo+knbXr4HK+U5vcM49k7bpeNN86fwXjOdo13eqT9Ke6Hpk84xg6WDxKw
         XyAvkGflJXdhc9Lh6KLDZOjWDQ5ALYLzBy6stXZOF522j1XmCkMxRDtV4hWYQfwoThGf
         aIi2dL5srZ6vvcRbEOZVVdhs6oY/EniH0RegQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m4AT2pHM5eKiwWql/S0na26YGuwD55vsY36Ry4jT4KQ=;
        b=L0K7JPsDO5XWF1e7RPOxfLEO2AcxN5OwOgNIkTDtlDl4DaAMR64qqXHVeiGkuvTl+y
         D0c5CVbnu5y5ghhvA6I8bSMK9hsWyQbQGZ1GVv3ypI0Ch5pxBWmbjafaLeS8uhDHoQCx
         6xHdGbBuqcN4MEOADk8AJGsqPBB2yu+XB0ontMiK4fk8ufQseDrCOT9UaXaRzkLVeVkF
         eLPdZFu8S/dRvcafzAikLi9+AoDmPaD2Cf6AHUzqEERcyapZI/QH8ZlO8MzqV4mZoNg9
         9MRJr/jRe8vFLBhejcOELXN+Fgb5No0pWqk3sHnIiEdnylXJQKvn384/VEzSDBK12UR6
         JuRw==
X-Gm-Message-State: APjAAAUogKwGPrafQuz1tdLEp3eAABnjMnOChjI6h3I1HNgf9KX9MYX8
        OLhjPTEoTozwppA0AqDuXwnODSsPDS0=
X-Google-Smtp-Source: APXvYqxhn9Y4nELdzDp0utfO0hD8E3B2m/NA33Zqp8zGurYoPcFwVfPdR8dJW/MvbcxrW4WQ9OEw/g==
X-Received: by 2002:a2e:5b9d:: with SMTP id m29mr6509667lje.146.1571411588708;
        Fri, 18 Oct 2019 08:13:08 -0700 (PDT)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com. [209.85.167.43])
        by smtp.gmail.com with ESMTPSA id c69sm5636671ljf.32.2019.10.18.08.13.06
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Oct 2019 08:13:07 -0700 (PDT)
Received: by mail-lf1-f43.google.com with SMTP id w6so5012692lfl.2
        for <linux-scsi@vger.kernel.org>; Fri, 18 Oct 2019 08:13:06 -0700 (PDT)
X-Received: by 2002:ac2:43c2:: with SMTP id u2mr6556317lfl.61.1571411586269;
 Fri, 18 Oct 2019 08:13:06 -0700 (PDT)
MIME-Version: 1.0
References: <1571166922.15362.19.camel@HansenPartnership.com>
 <20191018103540.GC3885@osiris> <yq1pniui429.fsf@oracle.com>
In-Reply-To: <yq1pniui429.fsf@oracle.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 18 Oct 2019 08:12:50 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi1UwQdaO_SBscZHJA8CnrCx8rXT+s6Xgf5zAri=BkRTw@mail.gmail.com>
Message-ID: <CAHk-=wi1UwQdaO_SBscZHJA8CnrCx8rXT+s6Xgf5zAri=BkRTw@mail.gmail.com>
Subject: Re: [GIT PULL] SCSI fixes for 5.4-rc3
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Steffen Maier <maier@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Oct 18, 2019 at 6:21 AM Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
> Linus, these two commits were in a separate postmerge branch due to a
> dependency on changes merged for 5.4 in the block tree. The patches fix
> two issues in the intersection of the request cleanup changes from block
> (b7e9e1fb7a92) and the request batching changes (8930a6c20791) that were
> made to SCSI during the 5.4 cycle.

Pulled. I don't know if you'll get the pr-tracker-bot reply when the
pull request was in the middle of a thread like this, but it probably
doesn't matter. We'll see.

The "in the middle of a thread" probably matters more to me - just as
a FYI, when there's some discussion thread where the developers are
already actively involved, I tend to just scan the emails
superficially, and could easily have missed that there was a pull
request hidden in the conversation..

              Linus
