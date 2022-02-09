Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D542C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 07:56:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234820AbiBIH4h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 02:56:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiBIH4d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 02:56:33 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 278C1C0613CA;
        Tue,  8 Feb 2022 23:56:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1QlWDn92UQ5AsU9+yqgoQ21HGVUJbCNA19V+fHfieKE=; b=tjV0CgiQGKSmPUvKTFd1KwxTrb
        cQ2xvuqbUx7Z6ObEOmVImNzBRZdZ0bCfqWuEuzl4nnXqsNQFNMR2e3TjHSjj+uld3eLo+G0NufLTq
        e7aAXIajAeiHDxOk7uV8sReREWLIg68eoRxowvYIdBwnvDG3N3Bkn6RMDGHKXM+e8/l3gfip08IMW
        oTXyQFQXMpRaybO9dliKTKPX2hy/VJ9d8ErSpfX7KEz3b/rq0a0ChE0IHH1hMWn2xzaQASt5xTa5w
        NV8aisWryFAvy2W61auRUHBnurL0mJ40NuaSZj7pNUC542KwSWnBgU9GnER4xGKtPgKFQBUxshmR/
        Rd+BaKlg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nHhq6-00GYV7-64; Wed, 09 Feb 2022 07:56:34 +0000
Date:   Tue, 8 Feb 2022 23:56:34 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH REPOST] irq_poll: Add local_bh_disable() in cpu_dead
 notifier
Message-ID: <YgNzsnIE9bwQZ1Zg@infradead.org>
References: <YgJ/XWVxxWDVBBVA@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgJ/XWVxxWDVBBVA@linutronix.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Feb 08, 2022 at 03:34:05PM +0100, Sebastian Andrzej Siewior wrote:
> __raise_softirq_irqoff() adds a bit to the pending sofirq mask and this
> is it. The softirq won't be handled in a deterministic way but randomly
> when an interrupt fires and handles the softirq in its irq_exit() routine or
> if something randomly checks and handles pending softirqs in the call
> chain before the CPU goes idle.
> 
> Add a local_bh_disable/enable() around the IRQ-off section which will
> handle pending softirqs.

And I still haven't seen any good explanation of why this is useful.
