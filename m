Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 024EA41B8CC
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2026 11:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784201852; cv=none; b=Ih1kt4kWYj1zFJ3qY/y3uDGrLDZ923d+3dV3AV5HWL4EQOd4nKAQjSGtQp997PqvnrODIUzoKZ0N39FeXTpB6Ox9YBSzwAspRj9IXJhKDvcx8/lnxwSRJBvYyYjk2ivQvVS3ng6EVKLcdZr7m3+wosdXg+SLajh/69RkG5z7N5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784201852; c=relaxed/simple;
	bh=WNj3Cb83YaTSSnZ5GjuYXJxBIGHnstimI3/VrEkdEHY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=UXeX1zOfT/D1HIZdXotqbzrnLArOq2SUoxT49hYrVv9HHBiMD91OFp2Z6L0a0pqsIb8ATtxGlhBe2XZpcKeC1uAbULnjYynaXywbSjPurdy+s/A/zqPtZ5X3wcLjNYnkmmF18mS7h7rK1mlI7tSL5QNdpGnFDfj8uCoY3IxdgtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=h0djj8i3; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="h0djj8i3"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id E02671A1023
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2026 11:37:25 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id A4C1A602B8;
	Thu, 16 Jul 2026 11:37:25 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id F352511BD1C1E;
	Thu, 16 Jul 2026 13:37:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1784201844; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=hGAdanQ0EykvoHJUcc1Zu9YWEiMeLtBzES4GvUPbn3k=;
	b=h0djj8i3FIxgRDW7iei4xWcMuZ5XtEPB6Ha2iMzl+zHEQAEIgRwsVY4gSti8PjQNCLYCqu
	VkS62jOtE/BabaxJ0TyRFEZ5bniPsVJwHN8Qf3wzOywS72Car3VCQ8/VkadAEpdXkDDHxl
	uUzQF8ASEoj94yvhNC0sZI+Nmy0t9kf2WnBY+tk8y2f6voaCft0jSRLkmMFx5yDgpusumh
	ps+bEecz6/Ryh4Cj15bH+YUEOV37VQ1Ec99YkskVeeymOP8Nm1dqz7ykhKXoylUa9gS4GY
	Vnjo4bWXml+H4u5AdvhRARYs8a1CogGx55pwjm0PkGDU6xjFPWiAdLAOb4pjfw==
From: Gregory CLEMENT <gregory.clement@bootlin.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
 <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>, Neil
 Armstrong <neil.armstrong@linaro.org>, =?utf-8?B?5a2Z6a2BIChLdWkgU3VuKQ==?=
 <kui.sun@unisoc.com>, =?utf-8?Q?Andr=C3=A9?= Draszik
 <andre.draszik@linaro.org>, Sebastian
 Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH] ufs: core: Revert "Delegate the interrupt service
 routine to a threaded IRQ handler"
In-Reply-To: <b70eb60a01f971bed68c42c5b555929db5f835df.1784135511.git.bvanassche@acm.org>
References: <b70eb60a01f971bed68c42c5b555929db5f835df.1784135511.git.bvanassche@acm.org>
Date: Thu, 16 Jul 2026 13:37:17 +0200
Message-ID: <87se5j5fo2.fsf@BLaptop.bootlin.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Last-TLS-Session-Version: TLSv1.3

Hello Bart,

> There have been multiple reports of performance regressions caused by
> commit 3c7ac40d7322. Hence this revert.
>
> This patch reverts most of the following commits:
> * 3c7ac40d7322 ("scsi: ufs: core: Delegate the interrupt service routine =
to
>   a threaded IRQ handler")
> * 6475cfb81fc4 ("scsi: ufs: core: Avoid IRQ thread wakeup during active U=
IC
>   command")
>
> This patch preserves the following commits:
> * 034d319c8899 ("scsi: ufs: core: Fix interrupt handling for MCQ Mode")
> * eabcac808ca3 ("scsi: ufs: core: Fix IRQ lock inversion for the SCSI host
>   lock")
>
> Neil, please check whether this patch series fixes the stalls that you
> reported: [f2fs-dev] [PATCH 0/4] Reduce the time spent in interrupt conte=
xt
> (https://sourceforge.net/p/linux-f2fs/mailman/linux-f2fs-devel/thread/4b3=
37c7f-2fbd-47b6-9c8c-587e7b5513f1%40kernel.org/#msg59345049).
>

This patch appears to be a good solution to fix the issue I reported
with PREEMPT_TR enabled. I don't currently have the hardware available
to test it, but as soon as I do, I will test this patch.
Thanks,

Gregory


> Cc: Neil Armstrong <neil.armstrong@linaro.org>
> Cc: =E5=AD=99=E9=AD=81 (Kui Sun) <kui.sun@unisoc.com>
> Cc: Andr=C3=A9 Draszik <andre.draszik@linaro.org>
> Cc: Gregory CLEMENT <gregory.clement@bootlin.com>
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Fixes: 3c7ac40d7322 ("scsi: ufs: core: Delegate the interrupt service rou=
tine to a threaded IRQ handler")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/ufs/core/ufshcd.c | 39 +++------------------------------------
>  1 file changed, 3 insertions(+), 36 deletions(-)
>
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 79331c2bd38d..56c96a3b10e2 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -7356,7 +7356,7 @@ static irqreturn_t ufshcd_sl_intr(struct ufs_hba *h=
ba, u32 intr_status)
>  }
>=20=20
>  /**
> - * ufshcd_threaded_intr - Threaded interrupt service routine
> + * ufshcd_intr - Main interrupt service routine
>   * @irq: irq number
>   * @__hba: pointer to adapter instance
>   *
> @@ -7364,7 +7364,7 @@ static irqreturn_t ufshcd_sl_intr(struct ufs_hba *h=
ba, u32 intr_status)
>   *  IRQ_HANDLED - If interrupt is valid
>   *  IRQ_NONE    - If invalid interrupt
>   */
> -static irqreturn_t ufshcd_threaded_intr(int irq, void *__hba)
> +static irqreturn_t ufshcd_intr(int irq, void *__hba)
>  {
>  	u32 last_intr_status, intr_status, enabled_intr_status =3D 0;
>  	irqreturn_t retval =3D IRQ_NONE;
> @@ -7403,38 +7403,6 @@ static irqreturn_t ufshcd_threaded_intr(int irq, v=
oid *__hba)
>  	return retval;
>  }
>=20=20
> -/**
> - * ufshcd_intr - Main interrupt service routine
> - * @irq: irq number
> - * @__hba: pointer to adapter instance
> - *
> - * Return:
> - *  IRQ_HANDLED     - If interrupt is valid
> - *  IRQ_WAKE_THREAD - If handling is moved to threaded handled
> - *  IRQ_NONE        - If invalid interrupt
> - */
> -static irqreturn_t ufshcd_intr(int irq, void *__hba)
> -{
> -	struct ufs_hba *hba =3D __hba;
> -	u32 intr_status, enabled_intr_status;
> -
> -	/*
> -	 * Handle interrupt in thread if MCQ or ESI is disabled,
> -	 * and no active UIC command.
> -	 */
> -	if ((!hba->mcq_enabled || !hba->mcq_esi_enabled) &&
> -	    !hba->active_uic_cmd)
> -		return IRQ_WAKE_THREAD;
> -
> -	intr_status =3D ufshcd_readl(hba, REG_INTERRUPT_STATUS);
> -	enabled_intr_status =3D intr_status & ufshcd_readl(hba, REG_INTERRUPT_E=
NABLE);
> -
> -	ufshcd_writel(hba, intr_status, REG_INTERRUPT_STATUS);
> -
> -	/* Directly handle interrupts since MCQ ESI handlers does the hard job =
*/
> -	return ufshcd_sl_intr(hba, enabled_intr_status);
> -}
> -
>  static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag)
>  {
>  	int err =3D 0;
> @@ -11233,8 +11201,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem=
 *mmio_base, unsigned int irq)
>  	ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
>=20=20
>  	/* IRQ registration */
> -	err =3D devm_request_threaded_irq(dev, irq, ufshcd_intr, ufshcd_threade=
d_intr,
> -					IRQF_ONESHOT | IRQF_SHARED, UFSHCD, hba);
> +	err =3D devm_request_irq(dev, irq, ufshcd_intr, IRQF_SHARED, UFSHCD, hb=
a);
>  	if (err) {
>  		dev_err(hba->dev, "request irq failed\n");
>  		goto out_disable;

--=20
Gr=C3=A9gory CLEMENT, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
