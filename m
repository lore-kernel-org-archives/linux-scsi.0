Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2EFD3E9C06;
	Tue, 30 Jun 2026 10:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782815306; cv=none; b=hbSUzlTol04hqGZfDIm8UWXptV6JnX+w0A3E12FuKB9dLSfyWRd8lAHq3AAcSj5BXtCFBNo/MMRChUJFAbQxaGQF0sJT9fBhWj1YTCzhB2sUImq1Ba9DKifrJwe6JX4ORneC3fKbuOdPfsKII+NwqX7ovn+jTP4PTUyMBJIwbEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782815306; c=relaxed/simple;
	bh=iAQY6TCrDj8LfUpuZjFjTTB1GWYcGsCqzNYYlW2+uJs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=lhVjjmoLxKvPYoNT0q50jxlax9I2ppu31sM2+jMsAxyx2DXfabqXvRH4JhjLqRKp7k7WqFHhPIaopvg4t0ArAeWP4j2ugEit2ZZ3bdM1PYDY/ykBvZWJiQ/+euNdma+vT9XtjYTNWPXGcXL88YbslbSR0xQ6wRRA3HI4eKVg9m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=A5lRI0nm; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="A5lRI0nm"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id ADC421A0C75;
	Tue, 30 Jun 2026 10:28:23 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 7AC176025A;
	Tue, 30 Jun 2026 10:28:23 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 5D3C1106F1D96;
	Tue, 30 Jun 2026 12:28:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1782815302; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=+45Kh3Satp3HBEK6If/oF4JoJaoBdx7zAqswznQZd8E=;
	b=A5lRI0nmyKuAE7DExkUqwE3nvY8dreV4gtcQPOB0GX52Cj+7BpicSwuwNtlHwCRNZ9KnH4
	JV3sNbXy6IiTZXvoyl+h+64ra9dtRJps61BbP4ADeCteWmLtvWPzxdyrF9/bImWU5Qan0t
	zsk22dgw27mXa9URexNbfMuMCBr86TlrhX26gDbVyVbfY2NOgcKbCrIE64i3an4C046AAD
	kFvkgF4G9TKP+tJ2DUzfrG/afQCVNxVONsGPeMh5W74SOTgWMXnxN7E/J3wJwoJEL8VK4I
	VZDN+xWCWJ3qtue/K3BoRq6c+pH+SARBEnjlbpHeChQ4oIcvovKtfkeOYxwkYQ==
From: Gregory CLEMENT <gregory.clement@bootlin.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH] scsi: ufs: core: Avoid sleeping in hard interrupt
 context when PREEMP_RT is enabled.
In-Reply-To: <20260630102343.728131F000E9@smtp.kernel.org>
References: <20260630-ufshcd-spinlock-sleep-fix-v1-1-339b05a1c6f4@bootlin.com>
 <20260630102343.728131F000E9@smtp.kernel.org>
Date: Tue, 30 Jun 2026 12:28:21 +0200
Message-ID: <878q7wb9ve.fsf@BLaptop.bootlin.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Last-TLS-Session-Version: TLSv1.3

Hello,

> Thank you for your contribution! Sashiko AI review found 2 potential issu=
e(s) to consider:
> - [Low] The static function `ufshcd_intr` becomes unused when `CONFIG_PRE=
EMPT_RT` is enabled, causing a compiler warning.
> - [Low] Typo in the newly added source code comment.

Both of Sachiko's comments are valid. I am addressing these issues in
the next version.

Gregory

> --
>
> commit 6afdc0b243918ce89eb55cea6349f608516d9d03
> Author: Gregory CLEMENT <gregory.clement@bootlin.com>
>
> scsi: ufs: core: Avoid sleeping in hard interrupt context when PREEMP_RT =
is enabled.
>
> This commit addresses a sleeping-in-hard-irq context bug under PREEMPT_RT=
.=20
> It mitigates the issue by bypassing the hard IRQ handler and directly=20
> registering the threaded interrupt handler when PREEMPT_RT is enabled.
>
>> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
>> index d3044a3089b53..6d82658a1a66b 100644
>> --- a/drivers/ufs/core/ufshcd.c
>> +++ b/drivers/ufs/core/ufshcd.c
>> @@ -11235,9 +11235,17 @@ int ufshcd_init(struct ufs_hba *hba, void __iom=
em *mmio_base, unsigned int irq)
>>  	 */
>>  	ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
>>=20=20
>> -	/* IRQ registration */
>> +	/* IRQ registration
>> +	 * In the case of PREMMP_RT, directly use the threaded
>
> [Severity: Low]
> This isn't a bug, but there is a typo in this comment ("PREMMP_RT" instead
> of "PREEMPT_RT"). The commit subject also has a small typo ("PREEMP_RT").
>
>> +	 * interrupt to avoid using a spinlock (which could sleep)
>> +	 * in the hard IRQ handler.
>> +	 */
>> +#ifdef CONFIG_PREEMPT_RT
>> +	err =3D devm_request_irq(dev, irq, ufshcd_threaded_intr, IRQF_SHARED, =
UFSHCD, hba);
>> +#else
>>  	err =3D devm_request_threaded_irq(dev, irq, ufshcd_intr, ufshcd_thread=
ed_intr,
>>  					IRQF_ONESHOT | IRQF_SHARED, UFSHCD, hba);
>> +#endif
>
> [Severity: Low]
> Will this cause a compiler warning for an unused function when building w=
ith
> CONFIG_PREEMPT_RT=3Dy?=20
>
> Because the reference to ufshcd_intr() is compiled out in the #else block=
,=20
> but its static definition remains unconditionally compiled earlier in the=
=20
> file:
>
> static irqreturn_t ufshcd_intr(int irq, void *__hba)
> {
>     ...
> }
>
> Could this break builds that have CONFIG_WERROR=3Dy enabled due to the=20
> -Wunused-function warning?
>
>>  	if (err) {
>>  		dev_err(hba->dev, "request irq failed\n");
>>  		goto out_disable;
>
> --=20
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260630-ufshcd-s=
pinlock-sleep-fix-v1-1-339b05a1c6f4@bootlin.com?part=3D1

--=20
Gr=C3=A9gory CLEMENT, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
