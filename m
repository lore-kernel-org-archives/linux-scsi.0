Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 276B4C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 07:45:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF6DC610C7
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 07:45:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbhJRHsB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Oct 2021 03:48:01 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:36624 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbhJRHsB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Oct 2021 03:48:01 -0400
Date:   Mon, 18 Oct 2021 09:45:47 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634543148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TBztQATy/ob0NKkRwBiBXIMi+G2dDH2iEcLKb8A04us=;
        b=WoN8QDVjF68CYwhUfQ2GaHB67tZGEg0/KIwuN9XJs4uMMK/xOUbF2TeN2R2mluJI1EiuW+
        /Gq8bNX8Ug6iI5fJ8QBkz3aHx5w/CCJqeD8LHei2jH3ceJhMEmGIgLa2W3ciFhICEJ0G/d
        eGtwWdug4Bt2Vyv3cdz23pI0oDX01gT+Yb5C0klKof1fEbfM8o0DuJ6t09QMWc9+GeDqJH
        nGKMRyMzRtAkEa6G6Q1HU6lmCu/3oQs0Fl9LYFXUjNFihb7ADZXwY+c0fgeSY0Gjq0Obud
        acIGCVTf8nrMNcApKMu4QI+6E3gxrR2tiQQdqfRJa7szPujc+sl00iNjkzdNoA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634543148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TBztQATy/ob0NKkRwBiBXIMi+G2dDH2iEcLKb8A04us=;
        b=PKmp5a+9hplPiYFXM0Lzq+gzfa/LsFtpJHvaUfemP7YaTlYlpmdq04YlKQ51x2rwdhHZX4
        v15WEJXvGWDJm6DA==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] irq_poll: Use raise_softirq_irqoff() in cpu_dead notifier
Message-ID: <20211018074547.p4to2viuhbfefi7r@linutronix.de>
References: <20210930103754.2128949-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210930103754.2128949-1-bigeasy@linutronix.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-09-30 12:37:54 [+0200], To linux-kernel@vger.kernel.org wrote:
> __raise_softirq_irqoff() adds a bit to the pending sofirq mask and this
> is it. The softirq won't be handled in a deterministic way but randomly
> when an interrupt fires and handles softirq in its irq_exit() routine or
> if something randomly checks and handles pending softirqs in the call
> chain before the CPU goes idle.
> 
> Add a local_bh_disable/enable() around the IRQ-off section which will
> handle pending softirqs.

ping

> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  lib/irq_poll.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/lib/irq_poll.c b/lib/irq_poll.c
> index 2f17b488d58e1..2b9f797642f60 100644
> --- a/lib/irq_poll.c
> +++ b/lib/irq_poll.c
> @@ -191,11 +191,13 @@ static int irq_poll_cpu_dead(unsigned int cpu)
>  	 * If a CPU goes away, splice its entries to the current CPU
>  	 * and trigger a run of the softirq
>  	 */
> +	local_bh_disable();
>  	local_irq_disable();
>  	list_splice_init(&per_cpu(blk_cpu_iopoll, cpu),
>  			 this_cpu_ptr(&blk_cpu_iopoll));
>  	__raise_softirq_irqoff(IRQ_POLL_SOFTIRQ);
>  	local_irq_enable();
> +	local_bh_enable();
>  
>  	return 0;
>  }
> -- 
> 2.33.0
> 

Sebastian
