Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C65A7C4361B
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 16:09:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9728E2223E
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 16:09:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbgLDQJa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 11:09:30 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:48330 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727008AbgLDQJa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2020 11:09:30 -0500
Date:   Fri, 4 Dec 2020 17:08:47 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1607098128;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Xy/9QtTx3UpO4JIfYbYMImqZERsY61stjvd6BB0ENZ4=;
        b=MJ7bYsHV7TPIHmu2rNgwoX3+TkJCeN95hlA9vXvetWgdnoWHUXrG9WdUjlS909EN1EEe2g
        1Qnr9iN2uAr8VHq58yxyMrozhPe0NzmBgfDXYihLgnkJJgS08GNZ3EWBPI3Vu7c8reVaMz
        0EFa0zum8OUzPhdXl0EVaBgLsjW/9py0xaoVcQ5J3FCRCYQF3oMlmhUasNKsvW1BQVCbmy
        PAr2RPjDTj/OW5IC+0lHc+OPG6uZ2dsTlXrtxwUmvMpBrwa/1SsErE+v30C3hAGZXFZMGH
        exCqxquoGieoosONyTESnZ796EoK2wEriTkr6GWoYm/GtYFssSMRlYu8XiMsBQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1607098128;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Xy/9QtTx3UpO4JIfYbYMImqZERsY61stjvd6BB0ENZ4=;
        b=w4Pul5+kYZfht3cMhIbq7t7Dln2VSt/wCSjR5W/wGVyZSnBNDBRUFuo8kMlIqIwE40HlRz
        ENVLMwaEX8+SKbBg==
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
To:     Finn Thain <fthain@telegraphics.com.au>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi/NCR5380: Remove in_interrupt() test
Message-ID: <X8pfD5XtLoOygdez@lx-t490>
References: <58cf6feeaf5dae1ee0c78c1b25c00c73de15b087.1606805196.git.fthain@telegraphics.com.au>
 <20201201170547.d6ff743eeuh6en6s@linutronix.de>
 <alpine.LNX.2.23.453.2012040953030.6@nippy.intranet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.23.453.2012040953030.6@nippy.intranet>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Dec 04, 2020 at 10:08:08AM +1100, Finn Thain wrote:
...
>
> You've put your finger on a known problem with certain
> NCR5380_poll_politely() call sites. That is, the nominal timeout, HZ / 64,
> is meaningless because it is ignored in atomic context. So you may as well
> specify 0 jiffies at these call sites. (There will be a 1 jiffy timeout
> applied regardless.)
...
>
> However, I can see the value in your approach, i.e. passing a zero timeout
> to NCR5380_poll_politely() whenever that argument is unused. And I agree
> that this could then be used to inhibit sleeping, rather than testing
> irqs_disabled().
>
> So if you really don't like irqs_disabled(), perhaps you can just keep the
> better parts of your two attempts, i.e. passing 0 to
> NCR5380_poll_politely() where appropriate and facilitating that by adding
> a new can_sleep parameter to do_abort() and NCR5380_transfer_pio(), as in,
...
>
> Does that sound like a reasonable compromise?
>

Yes, of course. Thanks a lot.

I've sent a v2.

--
Ahmed S. Darwish
Linutronix GmbH
