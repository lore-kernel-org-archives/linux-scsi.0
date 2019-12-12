Return-Path: <SRS0=+Znx=2C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EE72C43603
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Dec 2019 17:34:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84216206C3
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Dec 2019 17:34:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730196AbfLLRem (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Dec 2019 12:34:42 -0500
Received: from mout.kundenserver.de ([217.72.192.74]:48639 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730100AbfLLRem (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Dec 2019 12:34:42 -0500
Received: from mail-qk1-f181.google.com ([209.85.222.181]) by
 mrelayeu.kundenserver.de (mreue108 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MlNl5-1i18OL1FIT-00lq4z; Thu, 12 Dec 2019 18:34:40 +0100
Received: by mail-qk1-f181.google.com with SMTP id t129so2261477qke.10;
        Thu, 12 Dec 2019 09:34:39 -0800 (PST)
X-Gm-Message-State: APjAAAVKwmNojhrY5Vfyjre+83waJcdEUK8M8ykutTouEzed1OseoMXO
        HtVagddILdXlaoV8vmUhX0XNh5LVsi+PWn01+7o=
X-Google-Smtp-Source: APXvYqy6Sndmzm9YVyEhO3BdHaJC4VcQeM7sV3nbNQomHx6PpWYF3DgdNXyFb0rlI7Vazj/BGSb3gFISJSZPIAKOaVc=
X-Received: by 2002:a37:4e4e:: with SMTP id c75mr9035153qkb.3.1576172078788;
 Thu, 12 Dec 2019 09:34:38 -0800 (PST)
MIME-Version: 1.0
References: <20191211204306.1207817-1-arnd@arndb.de> <20191211204306.1207817-3-arnd@arndb.de>
 <20191212162506.GA27991@infradead.org>
In-Reply-To: <20191212162506.GA27991@infradead.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 12 Dec 2019 18:34:22 +0100
X-Gmail-Original-Message-ID: <CAK8P3a1AmFAL3qOe3vt-i2L2hjovHhfjSYCyyLHO4ghGAwNZuA@mail.gmail.com>
Message-ID: <CAK8P3a1AmFAL3qOe3vt-i2L2hjovHhfjSYCyyLHO4ghGAwNZuA@mail.gmail.com>
Subject: Re: [PATCH 02/24] compat: scsi: sg: fix v3 compat read/write interface
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Douglas Gilbert <dgilbert@interlog.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        y2038 Mailman List <y2038@lists.linaro.org>,
        Steffen Maier <maier@linux.ibm.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-block <linux-block@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:foLM2G0r8GVxsTyoJoIOaSk6pMqnEnutYdtpMtbAXngt8SsI6Nd
 62AtMeQDmPkmF9iG90vfarvk8zub1ZycyG+G18+7qLogwroak5Z1rv9PPvUjxYi4uXc3ahr
 DuHw9PsksiotlaUcdWT3UfExJiFpi12TLrcVf0NBCHXFX6Fitvna3LKkMny9eDeJqjGVnUZ
 ZMvk9MUOFs8OYhQCi7P1Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:70jwafmxM6w=:ewSuIuy9w+AR0MM2ZqohRj
 NvfNmxBJysJd1S+7NCjJolPemXh7F5Y3YOEfAFQ5TYBowEUlgpHkJc7sVKmdWKEtO8evJVXbJ
 zqA5JOke6QM4pTR8R41cQeRAFIEWnLUelS9E1VJlp9JC2wRVUaIqmawgVdST0JPyFyk8vuU6/
 qTS2UkSgxelqz8d/SqGa/bGwEuHWQKVe7AUkEkWjlBd21xl6HMQ7ew+L1CH3luWf6A8tQJ9se
 sVebl8BcICrgSq564qYkHvZAf0UJxn0Cha4zUjfzgwhB0P/16KFRLlaowBVre5rPh5vHqKH+A
 0wru7TIgjYmhaYwx4us79kk4hZnKX++RtezA0khoF/cjlqEqVRoKhVTPePsSY4ObF3lDoZQ9u
 azIlb2uBPZFVZgrEJJg5eM9TWmCitReYkC4FCTr/YQ8peWIMNN3B8vkWdZgoUC/+hUP7rAU7l
 2B6tLqTZTkc9rYhry6d7fzqRUwfJH0AH4DpJiPycCGl5N8z4K+RUO8zivVBUpEyNUG40hu8Ho
 WhHqn/TN6ffYKaEpiTTYXADyPYaFkPxZuALmi5/TY5Y7PWDlncTN85raHEI1uKv473g6rTqzJ
 Ym6ayc+unIbeUJwX+0ZUiCMflym1PWg87zJ/8sV+snIwXxXseQmNBiO9BqBn2VtGnD6Hz89IK
 JplRv9FpAfKEHyyUHRga83gg4dAKSSS0rTjlKEaBHanK4vL4ezs65yZ3JYe59htj+i00qRWgy
 PEXEhlBP5CR/ky/jEWUKWiPm8pZDIo2cswB97+Fi2RLcNRn2oeBmX48J/IVyCiUlT4x/oq7WZ
 gB0sc2+hdZB4YmB79B+d9BmZvy6LhUvgGavvFYoKEEMUugxyYAb+3VbCRhjwjPdHbm98dHTJi
 Iq96OTktMcugZO0sNTag==
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Dec 12, 2019 at 5:25 PM Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, Dec 11, 2019 at 09:42:36PM +0100, Arnd Bergmann wrote:

> > --- a/drivers/scsi/sg.c
> > +++ b/drivers/scsi/sg.c
> > @@ -198,6 +198,7 @@ static void sg_device_destroy(struct kref *kref);
> >
> >  #define SZ_SG_HEADER sizeof(struct sg_header)
> >  #define SZ_SG_IO_HDR sizeof(sg_io_hdr_t)
> > +#define SZ_COMPAT_SG_IO_HDR sizeof(struct compat_sg_io_hdr)
>
> I'd rather not add more defines like this.  The raw sizeof is
> much more readable and obvious.

Done. I actually had it that way in the previous submission and then changed
it for consistency. I considered removing SZ_SG_IO_HDR as well,
but decided not to make Doug's life harder than necessary -- he has nother
50 or so patches on top of this that he needs to rebase.

> I find the structure here a little confusing, as it doesn't follow
> the normal flow.  What do you think of:
>
>         if (count >= SZ_SG_HEADER) {
>                 if (get_user(reply_len, &old_hdr->reply_len))
>                         return -EFAULT;

I don't see much benefit either way. Changed it now it as you suggested.

Thanks for the review!

      Arnd
