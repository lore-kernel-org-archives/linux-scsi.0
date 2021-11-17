Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E97FC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 07:25:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 645EF6321A
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 07:25:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233144AbhKQH2m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Nov 2021 02:28:42 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:57998 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231547AbhKQH2m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Nov 2021 02:28:42 -0500
Date:   Wed, 17 Nov 2021 08:25:41 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637133942;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vblSOwk8WY8Wbht9jIU+VQDIA+N8xtAsFZfUXoQLMU8=;
        b=kmhukvnhJTe597OCSDVWQgXYK2zl6pnm1ldjoOXt9hN/1GSS77MtLaFqo6uEcLwSSTqe2z
        sVQGMXXuiiClUEbZ0g2X4SUB281P+T62VU/VWkhyU449apgl8VMb+sIHthfF3059HRgdwN
        1A9EJ8frBOM9fRFR6fo3FCjC6Im5TqyNFMGSRccmqqRhHCot5FtjAF3uRP6nfBeLVhSkwj
        qzQAFuFZEZHH3y7uWzea62jBGS8wDFlWUhQkO0FM5E2GeS1dcG+UkNDCrscasLNJkEcqTc
        wX2XZbqVw/nY551w7o8tD/qQOvQxH/Zgwavf7RsqW8O/8BtefIh+ex3RBa1kqQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637133942;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vblSOwk8WY8Wbht9jIU+VQDIA+N8xtAsFZfUXoQLMU8=;
        b=g5JiPL8QJW7dvwGvH4yVf5ubxSsCScKPQa03vioTKkolVHpwb1RXEUBwRMXVJCSOVVkXkw
        5M2717DPQbs8e1CA==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Davidlohr Bueso <dave@stgolabs.net>
Cc:     martin.petersen@oracle.com, jejb@linux.ibm.com, hare@suse.de,
        tglx@linutronix.de, linux-scsi@vger.kernel.org,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <dbueso@suse.de>
Subject: Re: [PATCH 1/3] scsi/libfc: Remove get_cpu() semantics in
 fc_exch_em_alloc()
Message-ID: <20211117072541.fpgp23twyaawiool@linutronix.de>
References: <20211117025956.79616-1-dave@stgolabs.net>
 <20211117025956.79616-2-dave@stgolabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211117025956.79616-2-dave@stgolabs.net>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-11-16 18:59:54 [-0800], Davidlohr Bueso wrote:
> The get_cpu() in fc_exch_em_alloc() was introduced in:
> 
>     f018b73af6db ([SCSI] libfc, libfcoe, fcoe: use smp_processor_id() only when preempt disabled)
> 
> for no other reason than to simply use smp_processor_id()
> without getting a warning, because everything is done with
> the pool->lock held anyway. However, get_cpu(), by disabling
> preemption, does not play well with PREEMPT_RT, particularly
> when acquiring a regular (and thus sleepable) spinlock.
> 
> Therefore remove the get_cpu() and just use the unstable value
> as we will have CPU locality guarantees next by taking the lock.
> The window of migration, as noted by Sebastian, is small and
> even if it happens the result is correct.
> 
> Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

> diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
> index 841000445b9a..be37bfb2814d 100644
> --- a/drivers/scsi/libfc/fc_exch.c
> +++ b/drivers/scsi/libfc/fc_exch.c
> @@ -825,10 +825,9 @@ static struct fc_exch *fc_exch_em_alloc(struct fc_lport *lport,
>  	}
>  	memset(ep, 0, sizeof(*ep));
>  
> -	cpu = get_cpu();
> +	cpu = raw_smp_processor_id();
>  	pool = per_cpu_ptr(mp->pool, cpu);
>  	spin_lock_bh(&pool->lock);
> -	put_cpu();

The `cpu' variable is later ORed into ep->oxid. I haven't figured out
why this is important/ required. The ep variable/ `fc_exch' is allocated
from a per-CPU memory pool and is later released to the same pool but
the pool's CPU number is not obtained from fc_exch::oxid but there is a
pointer to its pool stored in fc_exch::em. 
So it remains a mystery to why the CPU number is stored here.

>  	/* peek cache of free slot */
>  	if (pool->left != FC_XID_UNKNOWN) {

Sebastian
