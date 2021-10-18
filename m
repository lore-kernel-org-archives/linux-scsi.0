Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE9C1C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 11:49:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A730960EE5
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 11:49:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231718AbhJRLve (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Oct 2021 07:51:34 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:38122 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231695AbhJRLve (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Oct 2021 07:51:34 -0400
Date:   Mon, 18 Oct 2021 13:49:20 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634557762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VCowd5tUEa307yzRla1kgKpTzzoCVfRRX64Jit4X4hI=;
        b=toTnZqbZJ+MnxfzlgELt+IHVXtPHmkwCTcP0uerKCKIOpLdJNM32vySadAeP+oNiSfb55/
        e7VIcSkx0R/MlVPcnezaLnQGMvDFjayutIpczN721NZ0rW+rifQHck3zaMJkAe7BY/wNTV
        S51ra8I5atJrjULcVFD1T1jZmexgzGbKAL7kkIlQCtiYS+bvxHNa35AdlZrBimeGkRQqpY
        tN1w8mEtsK7iWbGtJ9ZFT57ENNYnC0HSqCw6JE8E6KVu0eR/lza30fiw68oqzQxmLiwCv/
        5pdfLSnHIhkN5k9csZprSuNlBfLZ6knKR+y745ykWo0CZq0Dp9SfPrPQwq+uyA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634557762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VCowd5tUEa307yzRla1kgKpTzzoCVfRRX64Jit4X4hI=;
        b=wBmwpdSo0E/3uCtmkCyaCX85/zQJ2Kwj8VW9NluG/FkZYoxbSrKQe80w54E44KnwWOrl3i
        LKT7gt8fbCLG2BBA==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] irq_poll: Use raise_softirq_irqoff() in cpu_dead notifier
Message-ID: <20211018114920.5rtvalux2w22j5ku@linutronix.de>
References: <20210930103754.2128949-1-bigeasy@linutronix.de>
 <YW1SIE08f3X3joxe@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YW1SIE08f3X3joxe@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-10-18 03:53:20 [-0700], Christoph Hellwig wrote:
> On Thu, Sep 30, 2021 at 12:37:54PM +0200, Sebastian Andrzej Siewior wrote:
> > __raise_softirq_irqoff() adds a bit to the pending sofirq mask and this
> > is it. The softirq won't be handled in a deterministic way but randomly
> > when an interrupt fires and handles softirq in its irq_exit() routine or
> > if something randomly checks and handles pending softirqs in the call
> > chain before the CPU goes idle.
> > 
> > Add a local_bh_disable/enable() around the IRQ-off section which will
> > handle pending softirqs.
> 
> This patch leaves me extremely confused, and it would even more if I was
> just reading the code.  local_irq_disable is supposed to disable BHs
> as well, so the code looks pretty much nonsensical to me.  But
> apparently that isn't the point if I follow your commit message as you
> don't care about an extra level of BH disabling but want to force a
> side-effect of the re-enabling?  Why not directly call the helper
> to schedule the softirq then? 

This side-effect is actually the way it works most of the time. There is
one exception in the network stack where do_softirq() is called manually
after checking for pending softirqs. I managed to remove one instance in
commit
   fe420d87bbc23 ("net/core: remove explicit do_softirq() from busy_poll_stop()")

just wasn't so lucky with the other one (yet). Other than that, it is
either local_bh_enable() that ensures that pending softirqs are
processed or __irq_exit_rcu().
Same as preempt_enable() ensure that a context switch happens if the
scheudler decided that one is needed but the CPU was in a
preempt-disabled section at that time.

Anyway. Even with s/__raise_softirq_irqoff/raise_softirq_irqoff/ you are
not much better off. The latter will wake ksoftirqd but it might result
in setting the NEED-resched bit which is not checked by
local_irq_enable(). So you end up waiting until random spin_unlock()
which has the needed check. Nothing here does that here but probably
something before the CPU-HP code is left.

Sebastian
