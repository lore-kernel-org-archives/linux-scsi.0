Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E174231F990
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 23:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785452519; cv=none; b=KUn5bEvg/igv8BtMc3azX3oJtx5cSsJPBXXhOhVizPJLODEE+aG9RKK56Q/aGCmvPWhyw+iAK0hm3jNQx36hXPwuWTA32kczjGkADsZARh7VtBRZt1h+1aG9im5IXlE4Zc5roeamDlJ24z/OCIVlKN93VKnhBsCyJh44/NIjdaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785452519; c=relaxed/simple;
	bh=T6U5yqO3heqcTC+5eWg7xGa6rKrYD0g96t5UE6XgCPM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Jq9Ys74p58LjRyg1N/RuXzh+Bp4md2lxEUWKg9gyVIxb+9NvrIclnWJS3+EnEQkY3hTevTbJkO0fdGVUV5yNnL8CAlstqQ6eaR2NbhpNH7uNoDnl3S1f06FozHL15tRZ0RV0Yu+0gjUfAf4a+++vpaqgPVZlsxnK9KVAP+iduf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=leiXZPPt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="leiXZPPt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51D8D1F000E9;
	Thu, 30 Jul 2026 23:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785452517;
	bh=xkZ+z6USa46+kiqKZY4W/Pbop9oRnYVy5hVRt3PJwmc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=leiXZPPtI/6UEIOhCz80wz9aDenNgqfSpnZmLP2nGclyKjqCsi7bboouLbwX4wr1m
	 1NGN4Kh1bWiOWzuHD+HPf1RT5ZWFM8wT+nd8Dus1GEvZhVYCyGzOHeZ2udD1A23fwS
	 J8ehLT29nQkhfk4S2eMgNUU0lZ+GZb5Vjz2iQMHWvxUxSuxl4gDxDGBbjZ4qTfI97Y
	 f0sknyb8hqdjj4XQfCMDHhQQ7vupvHg9tsTlT0MxYil1sg078Gy0ghQ2Ff/7P05N6T
	 noEptuIqT0Flnt6XPXshZrJK5GMjv55UdE+0L13JL6OykutUfhMqKpWBVcv9LCgJ1n
	 CEUzQOJoeHPdQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 05/57] scsi: BusLogic: Introduce two local variables
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <b30f5a73d3af6821005f5e6a28fc71dfa9b7081a.1785451174.git.bvanassche@acm.org>
References: <cover.1785451174.git.bvanassche@acm.org>
 <b30f5a73d3af6821005f5e6a28fc71dfa9b7081a.1785451174.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 23:01:56 +0000
Message-Id: <20260730230157.51D8D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The driver incorrectly uses spin_unlock_irq() and spin_lock_irq() =
to temporarily drop the host lock in paths protected by spin_lock_irqsave()=
 or inside hardirq handlers, unconditionally enabling local interrupts and =
violating IRQ context guarantees.
--

--- Patch [5]: [PATCH v3 05/57] scsi: BusLogic: Introduce two local variabl=
es ---
commit 0f5e462089dbe7ff33a0eecd6a02a423a0f2c9ec
Author: Bart Van Assche <bvanassche@acm.org>

scsi: BusLogic: Introduce two local variables

The patch introduces two local variables to prepare for enabling lock conte=
xt
analysis. No functionality has been changed.

> diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
> index 5304d2febd63e..f2a6ed710c770 100644
> --- a/drivers/scsi/BusLogic.c
> +++ b/drivers/scsi/BusLogic.c

[ ... ]

> @@ -2915,9 +2915,9 @@ static enum scsi_qc_status blogic_qcmd_lck(struct s=
csi_cmnd *command)
>  	 */
>  	ccb =3D blogic_alloc_ccb(adapter);
>  	if (ccb =3D=3D NULL) {
> -		spin_unlock_irq(adapter->scsi_host->host_lock);
> +		spin_unlock_irq(shost->host_lock);

[Severity: High]
This isn't a bug introduced by this patch, but does using spin_unlock_irq()
here unconditionally enable interrupts while we are inside a
spin_lock_irqsave() block?

Since blogic_qcmd_lck() is wrapped by DEF_SCSI_QCMD() which acquires the lo=
ck
with spin_lock_irqsave(), it appears dropping the lock with spin_unlock_irq=
()
will unexpectedly enable local interrupts and corrupt the IRQ state context.

This same pattern also appears to exist in blogic_resetadapter() when called
from the hardirq handler blogic_inthandler() during adapter internal errors.

Could this lead to unexpected nested interrupts or IRQ storms on error path=
s?

>  		blogic_delay(1);
> -		spin_lock_irq(adapter->scsi_host->host_lock);
> +		spin_lock_irq(shost->host_lock);
>  		ccb =3D blogic_alloc_ccb(adapter);
>  		if (ccb =3D=3D NULL) {
>  			command->result =3D DID_ERROR << 16;

[ ... ]

> @@ -3062,10 +3062,10 @@ static enum scsi_qc_status blogic_qcmd_lck(struct=
 scsi_cmnd *command)
>  		   be initiated soon.
>  		 */
>  		if (!blogic_write_outbox(adapter, BLOGIC_MBOX_START, ccb)) {
> -			spin_unlock_irq(adapter->scsi_host->host_lock);
> +			spin_unlock_irq(shost->host_lock);

[Severity: High]
This is also a pre-existing issue, but won't this spin_unlock_irq() call
similarly enable local interrupts unexpectedly for the same reasons as abov=
e?

>  			blogic_warn("Unable to write Outgoing Mailbox - Pausing for 1 second\=
n", adapter);
>  			blogic_delay(1);
> -			spin_lock_irq(adapter->scsi_host->host_lock);
> +			spin_lock_irq(shost->host_lock);
>  			if (!blogic_write_outbox(adapter, BLOGIC_MBOX_START,
>  						ccb)) {
>  				blogic_warn("Still unable to write Outgoing Mailbox - Host Adapter D=
ead?\n", adapter);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785451174.gi=
t.bvanassche@acm.org?part=3D5
