Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA7BBC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 10:53:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E5CD610A3
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 10:53:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbhJRKze (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Oct 2021 06:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbhJRKzd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Oct 2021 06:55:33 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF806C06161C;
        Mon, 18 Oct 2021 03:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=PYEyLBKPEiLefC1Su7n2R+mYeFRQvlAM8yBTFCwjueM=; b=rUm5vNgAbVR2F1C34gVTJtaGvk
        LCA6vlXmUdo8OXuSXVQP17YcMzmFfetDFOhd8TXwUMmuo+eWowynPchij8+M5TkAqqR9D4LwbUQX0
        5tMRTcaoKk91bsghDtgYFbTFYmC3JAlcOe3cTXKbTftJndnbTUZHE9xuUO8wMJ+gIIMhgjPoV30Zt
        6OeK8DLtENvhIEidAMRN7vQ9t0Q7Lx3DqAnw1gxY9/nGAHVk94freh8hGP2Beo4XBbFAa9klqzYkn
        vSNlWVk593z1y0ciGhz5W/am3OrVbZPXjUZNHybtrPKGMNwANrD8jaJXp/Rcpv7rWclFVZfbTkU7a
        W92gUEqA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mcQGe-00F9Mm-NY; Mon, 18 Oct 2021 10:53:20 +0000
Date:   Mon, 18 Oct 2021 03:53:20 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] irq_poll: Use raise_softirq_irqoff() in cpu_dead notifier
Message-ID: <YW1SIE08f3X3joxe@infradead.org>
References: <20210930103754.2128949-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210930103754.2128949-1-bigeasy@linutronix.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 30, 2021 at 12:37:54PM +0200, Sebastian Andrzej Siewior wrote:
> __raise_softirq_irqoff() adds a bit to the pending sofirq mask and this
> is it. The softirq won't be handled in a deterministic way but randomly
> when an interrupt fires and handles softirq in its irq_exit() routine or
> if something randomly checks and handles pending softirqs in the call
> chain before the CPU goes idle.
> 
> Add a local_bh_disable/enable() around the IRQ-off section which will
> handle pending softirqs.

This patch leaves me extremely confused, and it would even more if I was
just reading the code.  local_irq_disable is supposed to disable BHs
as well, so the code looks pretty much nonsensical to me.  But
apparently that isn't the point if I follow your commit message as you
don't care about an extra level of BH disabling but want to force a
side-effect of the re-enabling?  Why not directly call the helper
to schedule the softirq then? 
