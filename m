Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7BCDC433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jun 2022 12:30:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241818AbiFIMaY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jun 2022 08:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237974AbiFIMaX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jun 2022 08:30:23 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E227514005
        for <linux-scsi@vger.kernel.org>; Thu,  9 Jun 2022 05:30:21 -0700 (PDT)
Date:   Thu, 9 Jun 2022 14:30:17 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1654777819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Rx20vBwQrFJxboggEamckdADOxqPZbwTBqK3xGl2Ggw=;
        b=EoGAG3LeCifcc2wJNJfa2mGGcUsVm1+REYwAzKBDYfLoQT+uhikwHPu0fKWD7+kE4+IVRx
        debRveVAReWChn28q93/jAS/SKhYjXW1wzH2zB6AQ3/qpgFzpF2vECmRt5HydwUrBmSqXM
        zKnJxKlpAzjjNl/UV31YKatU9TpSKHcTKGgvC9pabVYcCNNw2FX9IaiJPVsQCD9XQOI6UN
        S6V+YqBfyIGkehTmsqGk42bpMew3Tnkxe+/H3rWf5PmfM1/OshSI3dBeYWQvrr7EfbqgKg
        rUspljf2odJCelvyz9S2Kv6grCLvfrLX567s5IjRILvCnM9BEOIdJtbZyPjQOw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1654777819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Rx20vBwQrFJxboggEamckdADOxqPZbwTBqK3xGl2Ggw=;
        b=VeE8mygK3kPVkG5+l69zYa30HBaVnhwn5vTRFwiqjcLaffU0jLclXF5nEyWpX/CwCzisRd
        wFjBimEIePkkVgBQ==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Davidlohr Bueso <dave@stgolabs.net>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        ejb@linux.ibm.com, tglx@linutronix.de,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 08/10] scsi/ibmvfc: Replace tasklet with work
Message-ID: <YqHn2Rn5nePSJ0PG@linutronix.de>
References: <20220530231512.9729-1-dave@stgolabs.net>
 <20220530231512.9729-9-dave@stgolabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220530231512.9729-9-dave@stgolabs.net>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022-05-30 16:15:10 [-0700], Davidlohr Bueso wrote:
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvf=
c.c
> index d0eab5700dc5..31b1900489e7 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
> @@ -891,7 +891,7 @@ static void ibmvfc_release_crq_queue(struct ibmvfc_ho=
st *vhost)
> =20
>  	ibmvfc_dbg(vhost, "Releasing CRQ\n");
>  	free_irq(vdev->irq, vhost);
> -	tasklet_kill(&vhost->tasklet);
> +        cancel_work_sync(&vhost->work);
s/ {8}/\t/

is there a reason not to use threaded interrupts? The workqueue _might_
migrate to another CPU. The locking ensures that nothing bad happens but
ibmvfc_tasklet() has this piece:

|         spin_lock_irqsave(vhost->host->host_lock, flags);
=E2=80=A6
|                 while ((async =3D ibmvfc_next_async_crq(vhost)) !=3D NULL=
) {
|                         ibmvfc_handle_async(async, vhost);
|                         async->valid =3D 0;
|                         wmb();
|                 }
=E2=80=A6
|                 vio_enable_interrupts(vdev);
potentially enables interrupts which fires right away.

|                 if ((async =3D ibmvfc_next_async_crq(vhost)) !=3D NULL) {
|                         vio_disable_interrupts(vdev);

disables it again.

|         }
|=20
|         spin_unlock(vhost->crq.q_lock);
|         spin_unlock_irqrestore(vhost->host->host_lock, flags);

If the worker runs on another CPU then the CPU servicing the interrupt
will be blocked on the lock which is not nice.

My guess is that you could enable interrupts right before unlocking but
is a different story.

>  	do {
>  		if (rc)
>  			msleep(100);

Sebastian
