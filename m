Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95538C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jun 2022 11:06:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243980AbiFCLGS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jun 2022 07:06:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242241AbiFCLGJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jun 2022 07:06:09 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA6DE3C494
        for <linux-scsi@vger.kernel.org>; Fri,  3 Jun 2022 04:05:58 -0700 (PDT)
Date:   Fri, 3 Jun 2022 13:05:54 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1654254356;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7utYxrYCw2OweZyE2twgWDzo4lfhsXkbxwhY74joFzQ=;
        b=1FVVDcj0tmhMHzjb0Hi2FQqDjyb0c6wE+I9480kJXyxfA72113pyyMe6aXcjZ+mKmlLSBN
        Cf7gNlwYdayD8Nby3Is4fxCfZNoS8ZeeVFy2E9ALb6HGY5FQVdP3e9srxCoYXaR1JMvg7+
        uskDIPlRVLCsgvhCSs06y6LjQJ64fJXArHAc2TQib5ob79/JWpGe42vmFIZEdbGa6c9fBk
        SBW+UJOn3Bc5ANrhcY4GwRohMDZAhMbwLr1F/Zi28xOgqbSye7eIo3th6vH0pcAeWL9Bej
        Nvl0wgVu63d2UtIs7u+p8fom8v/UjJIJnA7ldrOYfJc3mfM+l/IqeFluxxENKg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1654254356;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7utYxrYCw2OweZyE2twgWDzo4lfhsXkbxwhY74joFzQ=;
        b=Oc5YLYfdkgllR9u7O9z7uUaXOXdTkz73KUv006nb5Hsky/CCptIhi0a6NGVWCLq3o/FCtB
        dI6O2rmVvA+mWrCg==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Davidlohr Bueso <dave@stgolabs.net>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        ejb@linux.ibm.com, tglx@linutronix.de,
        Michael Cyr <mikecyr@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 06/10] scsi/ibmvscsi_tgt: Replace work tasklet with
 threaded irq
Message-ID: <Ypm8H1yicMAQjpt4@linutronix.de>
References: <20220530231512.9729-1-dave@stgolabs.net>
 <20220530231512.9729-7-dave@stgolabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220530231512.9729-7-dave@stgolabs.net>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022-05-30 16:15:08 [-0700], Davidlohr Bueso wrote:
> diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
> index eee1a24f7e15..fafadb7158a3 100644
> --- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
> +++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
> @@ -2948,9 +2948,8 @@ static irqreturn_t ibmvscsis_interrupt(int dummy, void *data)
>  	struct scsi_info *vscsi = data;
>  
>  	vio_disable_interrupts(vscsi->dma_dev);
> -	tasklet_schedule(&vscsi->work_task);
looks good.

> -	return IRQ_HANDLED;
> +	return IRQ_WAKE_THREAD;
>  }
>  
>  /**
> @@ -3340,7 +3339,7 @@ static void ibmvscsis_handle_crq(unsigned long data)
>  		dev_dbg(&vscsi->dev, "handle_crq, don't process: flags 0x%x, state 0x%hx\n",
>  			vscsi->flags, vscsi->state);
>  		spin_unlock_bh(&vscsi->intr_lock);

So if you move it away from from tasklet you can replace the spin_lock_bh()
with spin_lock() since BH does not matter anymore. Except if there is a
timer because it matters for a timer_list timer which is invoked in
softirq context. This isn't the case except that there is a hrtimer
invoking ibmvscsis_service_wait_q(). This is bad because a hrtimer is
which is invoked in hard-irq context so a BH lock must not be acquired.
lockdep would scream here. You could use HRTIMER_MODE_REL_SOFT which
would make it a BH timer. Then you could keep the BH locking but
actually you want to get rid of it ;)

> -		return;
> +	        goto done;
>  	}
>  
>  	rc = vscsi->flags & SCHEDULE_DISCONNECT;

Sebastian
