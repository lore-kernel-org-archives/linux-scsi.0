Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8301FC433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jun 2022 10:11:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233451AbiFBKLo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jun 2022 06:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233441AbiFBKLn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jun 2022 06:11:43 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 804DA23281D
        for <linux-scsi@vger.kernel.org>; Thu,  2 Jun 2022 03:11:42 -0700 (PDT)
Date:   Thu, 2 Jun 2022 12:11:33 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1654164695;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sf8wmuaMl5IZQ6ha8Q1wLQBaB/lcJrsIghmRxFJVuQc=;
        b=uXufA0dHpkHzIgfoAoS0eF+O5QJ8ILnZJ1URGE9PYCVepPEvxUMh3auOtM9Bx4YuPA9b8e
        23qb+D2EmwFNwTa0l3mu4jOTFXP/YE/pE5GRmN8fyrntGOWXBLB4lh0Olb/HT+G92eqnlf
        J1V0ZY2LllC7Xx9F+8syLd+Qw0qq8pRvxmA5bEen+e3bBztceIiz7gdYTr5elqFfDTVdMc
        XB3cFC5xeZ9qgXk0Qe7qK846Wb5GjfcvXjigZ25W3Lor0701GlMnHD37NxGKfjLPS/cMaL
        XHt4gnc0rGrUjhJJqJaRDxxW6XNxRWI/Q48Nv5nHQE0sfqR/SQiiQ19dYWMgPA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1654164695;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sf8wmuaMl5IZQ6ha8Q1wLQBaB/lcJrsIghmRxFJVuQc=;
        b=gNEY5MTDCZQfseoGGeez4d5GlrB+syP+hvdRB4QRGQ+4yKRsU9D3lqnpXJrTcvAtJ5H/8b
        S3o1deVG3b2nlQBw==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Davidlohr Bueso <dave@stgolabs.net>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        ejb@linux.ibm.com, tglx@linutronix.de,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        megaraidlinux.pdl@broadcom.com
Subject: Re: [PATCH 03/10] scsi/megaraid_sas: Replace instance->tasklet with
 threaded irq
Message-ID: <YpiM1dNxZTh0NLM7@linutronix.de>
References: <20220530231512.9729-1-dave@stgolabs.net>
 <20220530231512.9729-4-dave@stgolabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220530231512.9729-4-dave@stgolabs.net>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022-05-30 16:15:05 [-0700], Davidlohr Bueso wrote:
> Tasklets have long been deprecated as being too heavy on the system
> by running in irq context - and this is not a performance critical
> path. If a higher priority process wants to run, it must wait for
> the tasklet to finish before doing so. A more suitable equivalent
> is to converted to threaded irq instead and deal with the command
> completion in task context.
>=20
> While tasklets do not run concurrently amongst themselves, the
> callback can compete vs megasas_wait_for_outstanding() so any races
> with threads will also be present with the async thread completing
> the command.

So that fusion part of the driver has a different tasklet/isr so we have
always the same callback except in the one case=E2=80=A6
The s/tasklet/irqthread/ looks okay but that fusion part of the driver
which also does some eye brow raising:
The way irqpoll is scheduled does not look promising. We have:
|         if (!irq_context->irq_poll_scheduled) {
|                 irq_context->irq_poll_scheduled =3D true;
|                 irq_context->irq_line_enable =3D true;
|                 irq_poll_sched(&irq_context->irqpoll);
|         }

so we lack disabling the interrupt source. This means the interrupt will
continue trigger except on edge-trigger devices. Here however it might
also trigger if "another work item" is added. This might be reason why
|         if (irq_context->irq_poll_scheduled)
|                 return IRQ_HANDLED;

was added to megasas_isr_fusion() to skip that case. We also have this
piece:
|         if (irq_ctx->irq_line_enable) {
|                 disable_irq_nosync(irq_ctx->os_irq);
|                 irq_ctx->irq_line_enable =3D false;
|         }

in megasas_irqpoll(). It might have not been enough. But this a bold
move if this is not an MSI interrupt but an actual shared interrupt.
Without any proof I would say that disabling the interrupt source in HW
is cheaper than invoking disable_irq_nosync(). Also invoking
disable_irq_nosync() from the point where it should be disabled looks
late.

I would suggest to get rid of irqpoll, disable the interrupt source
before returning IRQ_WAKE_THREAD. I have currently no idea how to deal
with
|	if (threshold_reply_count >=3D instance->threshold_reply_count)

within the threaded-IRQ. It runs at SCHED_FIFO/50 so a cond_resched()
won't do a thing. It might not be a issue, it might=E2=80=A6

So the while the s/tasklet/irqthread/ part look okay, the part where the
interrupt source seems not to be deactivated looks bad.

> Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>

Sebastian
