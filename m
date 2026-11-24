Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795519124;
	b=07NH91lDxKcXYVn4cUs/03VAZFbMcpo2Ppnf10OtEm3P+PE5G/2X6FJTpm+M9wWLm8yF
	 diMaRa1sSg8pSpkzKCqLQ/IK3mJ+oNb7ktOdGq0lJcd4mX/mcgDeOlgNMKbJhpQf/QkDR
	 1H4hKNgPv2zKgnphbwdeX/X1f2v/AmRVoIz6TAKUU4BV6EUGh4tCYKpXongEJI1EzckQ1
	 k9FWbYnrMRaE5DZoMQKXqez2BEI00xtD3QMB8yu+SWuYFis0Dy+niD4sDpPbFcoP0VLR+
	 NxNYlrK2tidNyKRrKZxphguN+ZD+GGBR81S1jP7Shor3ffy76XSXY3XkcZTBj5Qcr0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795519124;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=mA4LE/emd+3B+vU+AyDJ3tB2QaU8gqYcqLN5LKEAkiU=;
	b=NIA8ODtLQskLvhToctGNNd+hvWGqffj8EBDy2Xu/xQYISUzMJJCflGb4ktEYgPPc2DLh
	 JAXrd/VJF5Du+k3eHXru2yyHKoxaeXtk78CRZwd2LFiOiI6PJipxQGsM0NFDq2yDRsbKv
	 QOJ1BSd4dXGfYiaXwMHO3oVrKir/cZTJQVtk74z/SW4q6c+pClq5egzYmVsQYw1Ux3QGG
	 TQXx49QicvBeme2RbFSBgcRNxWUHv+BlRL6+U52lNgpWjLwwXQxdX9jZAh5Yg0iA+6YS/
	 uZbd/Y1VYixP3FsJhW51nZkWRiG0RTKwiDcfG46IZ2rHvdsNPzKYjf33Kr6pk0AzNlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g91CHdRv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739C5606A685
	for <linux-scsi@vger.kernel.org>; Tue, 24 Nov 2026 11:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g91CHdRv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D473A1F000D1;
	Tue, 24 Nov 2026 11:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795519123;
	bh=mA4LE/emd+3B+vU+AyDJ3tB2QaU8gqYcqLN5LKEAkiU=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=g91CHdRv4LK2Ovh04F52Tc+dhvyP5Vx4DDjOG4Nf+XIQiH7cp+WQrscfqoEuCO6sb
	 4iwMwWekidXHp4C5o62+mrsBmO034mRsvKdihZSUQXqFfCh4slt0zcumOjXlFIzste
	 VY8FnsQ//HMd8SkGh8ruzDtrSR5MtAghyL8/0iyjEaWMH9WCS19xfNH+JFaoIZKZsi
	 6E22Zc7TzNpMz7CT0JOHCheQI5IIig58mn/Tf531WZw4NahiAUQ5EqCRcYViGyoz3I
	 erQVS0cskxUHiqHtJb2eZYxliTYW5PjfdLotDOI8v/xnoH14VQAhe6Iim/3MDstHyC
	 Ac1klFywKU7Vw==
Message-ID: <sashiko-outbox-231035@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC] scsi: aacraid: free aborted management FIBs on late
 completion
Reply-To: sashiko-reviews@lists.linux.dev
To: "Benjamin Saiz" <benj.saiz@gmail.com>, linux-scsi@vger.kernel.org
In-Reply-To: <20261124110444.3485-1-benj.saiz@gmail.com>
References: <20261124110444.3485-1-benj.saiz@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 11:18:43 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] scsi: aacraid: race on fib->done in aac_hba_send() and
  aac_intr_normal()
- [Medium] scsi: aacraid: double free on -ERESTARTSYS in
  aac_send_safw_bmic_cmd()
--

commit bdfff41a3eec2c252b35e5b8c632cb03cf063779
Author: Benjamin Saiz <benj.saiz@gmail.com>

scsi: aacraid: free aborted management FIBs on late completion

This commit calls aac_fib_free() in aac_intr_normal() when completing a
management FIB whose caller was interrupted and marked fib->done =3D=3D 2.

> diff --git a/drivers/scsi/aacraid/dpcsup.c b/drivers/scsi/aacraid/dpcsup.c
> index 169c41d080a15..a965f18fe4849 100644
> --- a/drivers/scsi/aacraid/dpcsup.c
> +++ b/drivers/scsi/aacraid/dpcsup.c
> @@ -379,8 +379,10 @@ unsigned int aac_intr_normal(struct aac_dev *dev, u3=
2 index, int isAif,
>  					mflags);
> =20
>  				FIB_COUNTER_INCREMENT(aac_config.NativeRecved);
> -				if (completed)
> +				if (completed) {
>  					aac_fib_complete(fib);
> +					aac_fib_free(fib);
> +				}
>  			}
>  		} else {
>  			struct hw_fib *hwfib =3D fib->hw_fib_va;

[Severity: Medium]
Can freeing fib here cause a use-after-free and double free when a
synchronous native HBA command in aac_hba_send() is interrupted by a
signal?

In aac_hba_send(), fibptr->done =3D 2 is written outside fibptr->event_lock:

drivers/scsi/aacraid/commsup.c:aac_hba_send() {
    ...
		if (wait_for_completion_interruptible(&fibptr->event_wait))
			fibptr->done =3D 2;
		fibptr->flags &=3D ~(FIB_CONTEXT_FLAG_WAIT);

		spin_lock_irqsave(&fibptr->event_lock, flags);
		if ((fibptr->done =3D=3D 0) || (fibptr->done =3D=3D 2)) {
			fibptr->done =3D 2; /* Tell interrupt we aborted */
			spin_unlock_irqrestore(&fibptr->event_lock, flags);
			return -ERESTARTSYS;
		}
		spin_unlock_irqrestore(&fibptr->event_lock, flags);
    ...
}

If the completion interrupt arrives between the unlocked assignment and
spin_lock_irqsave(&fibptr->event_lock, flags), both sides free the FIB:

CPU0                                    CPU1 (<hardirq>)
aac_send_raw_srb()
  aac_hba_send()
    wait_for_completion_interruptible()
      /* interrupted by signal */
    fibptr->done =3D 2;
                                        aac_intr_normal()
                                          lock(&fib->event_lock)
                                          if (fib->done =3D=3D 2) {
                                            fib->done =3D 1;
                                            completed =3D 1;
                                          }
                                          unlock(&fib->event_lock)
                                          aac_fib_complete(fib)
                                          aac_fib_free(fib)
    lock(&fibptr->event_lock)
    /* fibptr->done is 1, returns 0 */
    unlock(&fibptr->event_lock)
  /* reads freed srbfib */              <-- use-after-free
  if (rcode !=3D -ERESTARTSYS)
    aac_fib_free(srbfib)                <-- double free

Because fibptr->done is now 1, the early return for done =3D=3D 2 in
aac_fib_free() does not trigger, pushing srbfib onto dev->free_fib twice
and corrupting the management FIB free list into a cycle.

Also, unlike aac_fib_send(), neither aac_fib_alloc() nor aac_hba_send()
initializes fibptr->done =3D 0, so recycled FIBs enter aac_hba_send() with
fibptr->done =3D=3D 1.  If aac_intr_normal() runs after
wait_for_completion_interruptible() is interrupted but before
fibptr->done =3D 2 is written, aac_intr_normal() sees fib->done !=3D 2 and
does not free the FIB, while aac_hba_send() overwrites fibptr->done =3D 2
and returns -ERESTARTSYS, leaking the FIB.

> @@ -432,8 +434,10 @@ unsigned int aac_intr_normal(struct aac_dev *dev, u3=
2 index, int isAif,
>  					mflags);
> =20
>  				FIB_COUNTER_INCREMENT(aac_config.NormalRecved);
> -				if (completed)
> +				if (completed) {
>  					aac_fib_complete(fib);
> +					aac_fib_free(fib);
> +				}
>  			}
>  		}
> =20

[Severity: Medium]
Does this double free fibptr when aac_fib_send() is interrupted by a
signal in aac_send_safw_bmic_cmd()?

Unlike ioctl_send_fib() and aac_send_raw_srb(), aac_send_safw_bmic_cmd()
translates -ERESTARTSYS to -ERESTART and unconditionally cleans up:

drivers/scsi/aacraid/aachba.c:aac_send_safw_bmic_cmd() {
    ...
	if (rcode =3D=3D -ERESTARTSYS)
		rcode =3D -ERESTART;

	if (unlikely(rcode < 0))
		goto bmic_error;
    ...
bmic_error:
	dma_unmap_single(&dev->pdev->dev, addr, xfer_len, DMA_BIDIRECTIONAL);
fib_error:
	aac_fib_complete(fibptr);
	aac_fib_free(fibptr);
    ...
}

Previously, the early return for fibptr->done =3D=3D 2 in aac_fib_complete()
and aac_fib_free() made those calls no-ops after an interrupted
aac_fib_send().  With this change, if aac_intr_normal() completes the
abandoned FIB before aac_send_safw_bmic_cmd() reaches aac_fib_free():

CPU0                                    CPU1 (<hardirq>)
aac_send_safw_bmic_cmd()
  aac_fib_send()
    /* interrupted, sets done =3D 2 */
    return -ERESTARTSYS;
                                        aac_intr_normal()
                                          if (fib->done =3D=3D 2) {
                                            fib->done =3D 1;
                                            completed =3D 1;
                                          }
                                          aac_fib_complete(fib)
                                          aac_fib_free(fib)
  dma_unmap_single(...)
  aac_fib_complete(fibptr)
  aac_fib_free(fibptr)                  <-- double free

fibptr->done is already reset to 1, so aac_fib_free() does not return
early and pushes fibptr onto dev->free_fib a second time.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124110444.3485=
-1-benj.saiz@gmail.com?part=3D1
