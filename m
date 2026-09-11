Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E5D337B030
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 09:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789119094; cv=none; b=NxSVoO8N255/5uMUSi1AMLoXTmFkSGzjwzvFAdaZYgiG+/rCR0DY1cR3YLKSNyMZKGAReavbWpoL4T2Pv1Y9KOOZ6CF/4RtPTECb+S9Adh/rnPcrD51mqSUEI9a/6al7rFpcvDDbZRiTfVlt7yTCNH6AAFaJBy4B8xrIGyJHEhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789119094; c=relaxed/simple;
	bh=T23Qberhy/W4eULj5+bo2obpW0pBdvgaY0FBWZLRBEU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jD5KSud1OksihcycTZSliZXQCXfiUVVnV3kgLNHbdugL63Cyg68OkO/1UFF6TV8e49aofcbwkaG03E3FMnAXUZpArgeenqabisxyXZlDhYONwDjEUHOY/5GGOHmqbNIZP//2NR6OyFH+QuulzUTILJ7n8zTJgTAXh8uIL4mQVTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uv7OQzc9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uv7OQzc9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25DC51F000FF;
	Fri, 11 Sep 2026 09:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789119093;
	bh=w+gy+fGfnEmSHlADfkiuU7AU3bRiXqkAjjIifYmoErA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Uv7OQzc9lpeLWlyITSZL7kFsTu7p8QHm5js/WCVAAzccsThJq0EoPHUgQtowhGCfU
	 Y5ppQgjEy7Q8+TOD09N5h0138CVTbs/7x1IcMoonXfOMtluEcjPJQXLzh+tXWmlFsr
	 EETY4Hd54XSq1ogCDdPdyv8dWUxgQL+hOQ08VcZe0lBoMwfkHB3fES6i0z4lZe5j/C
	 +QR+CdCwhCBKk82D0c6KgVN4qDNsQMLoleDKaJk9XMdhiDq4KILe3s6Ux6oTMKAKrP
	 AO2Q46VIJn8ufHYT+ujThHLPMrulNfGkicZtAV/i0iIIDHvjeWskBotjWaZEndETQO
	 V+G4TwdEY4RMA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/4] scsi: pm8001: free MSI-X vectors before INT-X
 fallback
Reply-To: sashiko-reviews@lists.linux.dev
To: "Peng Hao" <flyingpenghao@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260911091011.94676-5-flyingpeng@tencent.com>
References: <20260911091011.94676-1-flyingpeng@tencent.com>
 <20260911091011.94676-5-flyingpeng@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 11 Sep 2026 09:31:32 +0000
Message-Id: <20260911093133.25DC51F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Early registration of interrupt handler causes a race conditio=
n leading to a NULL pointer dereference.
- [High] The INT-X fallback path is unreachable dead code, and the driver f=
ails to initialize if MSI-X allocation fails.
--

commit 41233b053e82eb6b313eebe72e0ecc8e816d565f
Author: Peng Hao <flyingpenghao@gmail.com>

scsi: pm8001: free MSI-X vectors before INT-X fallback

pm8001_setup_msix() may allocate MSI-X vectors before
pm8001_request_irq() decides to use INT-X. The fallback currently leaves
those vectors allocated. It also leaves max_q_num set to the MSI-X
vector count even though only one legacy interrupt is used.

Free allocated vectors before requesting INT-X, clear number_of_intr and
restore the single-queue configuration. Clear number_of_intr as well
when MSI-X IRQ registration fails after the vectors have been freed.

> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm80=
01_init.c
> index a747de9a3ca0a..4bf6c747be8b8 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c

[ ... ]

> @@ -1087,6 +1088,12 @@ static u32 pm8001_request_irq(struct pm8001_hba_in=
fo *pm8001_ha)
>  	}
> =20
>  use_intx:

[Severity: High]
This is a pre-existing issue, but is this INT-X fallback path actually
reachable?

Looking at pm8001_request_irq(), if pm8001_setup_msix() fails it immediately
returns the error rather than falling back to use_intx:

    rc =3D pm8001_setup_msix(pm8001_ha);
    if (rc) {
        ...
        return rc;
    }

    if (!pdev->msix_cap || !pci_msi_enabled())
        goto use_intx;

Since pm8001_setup_msix() only succeeds if MSI-X is supported and enabled,
the subsequent checks for !pdev->msix_cap and !pci_msi_enabled() will never
be true.

Does this leave the fallback as dead code, causing driver initialization to
fail completely instead of using legacy interrupts when MSI-X fails?

[Severity: Critical]
This is a pre-existing issue, but does setting up the INT-X interrupt here
introduce a race condition?

The interrupt handler is registered here during pm8001_alloc() via
pm8001_request_irq(), but hardware queues and pointers are not initialized
until later in pm8001_pci_probe() when calling chip_init().

If a shared INT-X line or pending hardware state causes an interrupt to fire
immediately, the handler will schedule a tasklet executing process_oq().
This function reads from the uninitialized queue pointers:

process_oq()
    circularQ->producer_index =3D cpu_to_le32(pm8001_read_32(circularQ->pi_=
virt));

Since pi_virt is still NULL before chip_init() is called, could this result
in a NULL pointer dereference?

> +	if (pm8001_ha->number_of_intr) {
> +		pci_free_irq_vectors(pdev);
> +		pm8001_ha->number_of_intr =3D 0;
> +	}
> +	pm8001_ha->max_q_num =3D 1;
> +
>  	/* Initialize the INT-X interrupt */
>  	pm8001_dbg(pm8001_ha, INIT, "MSIX not supported!!!\n");
>  	pm8001_ha->use_msix =3D false;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260911091011.9467=
6-1-flyingpeng@tencent.com?part=3D4
