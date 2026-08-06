Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA1348F85B
	for <linux-scsi@vger.kernel.org>; Thu,  6 Aug 2026 20:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786048694; cv=none; b=D5HbDfQTUNkSWNeaHyl7sb0erF1MBgvKNEJTnYfQVvDj+AzIg0RMhk1Z9YbmhySm0TQjLcka9vV0EQSpmcTKkazO9hqzUQbU//tB7pBTWdMdQJoFyGjDlxDY7nFWWGz6lR/1RChXkNsCFc0Lzy66Jwu6Uehj9hOSht9j/qEhJdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786048694; c=relaxed/simple;
	bh=lgDMAjhesqYIGKofv1Vd9l8WLC5T7f2LmBH1egJTZjg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ROQShDnmU4CL7qnC1XdeLWKPPKbbpYQOh7T4mujBNkXOVfHp4oMYFrhpIg5pHB96bpMSJCLQU1FmCapRPhsn4Yancv6RuY42Sr66OUEp/mPSYSIoo4MO+wB32yauvh5crsQHtODv+GewpWRJRT/cxKezPZujBk29YlStpunq1Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FklXSXgy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FklXSXgy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BF171F000E9;
	Thu,  6 Aug 2026 20:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786048691;
	bh=LjdQdVLFzjpV0NEgvhMsxNxfZ+W/7OEE+aCCmZ9nyRs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FklXSXgydLepqdOM/anWsnvTCw+8TaB6Cpi1Jzo5WDF//JgW4h2s+6yaPo4Kxuuxe
	 o3Vh6zv0mD3rNgrydskChe6RT57+9m6Tq2Sl0QdRSjbbuhog2RpWHV4bRyd6xnlOnx
	 4BKi5ONPlXyA4h3+vBMUCNIn02IEfcAP1UsCiJggfwB3kE7Lq0jsZ+Ltwe6VzuIl+D
	 VjkLfEw5aZVo7UZ7HODDkz/XZ2++tk4ilENmi1kcVgcLlyixuztV7RCeszbGrQ0H0r
	 jGCTu7BBCW/WyIt8v7emZAv+KxFFHfK/uDsUSIfAz31O8NYRt+rptJhcq6Rpd0YmC5
	 ufqd6sB2kcwIw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 4/5] scsi: elx: efct: free the RQ buffers already
 allocated when one fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ali Ahmet Memis" <ali@iusegentoo.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260806202205.345326-5-ali@iusegentoo.com>
References: <20260806192345.328621-1-ali@iusegentoo.com>
 <20260806202205.345326-5-ali@iusegentoo.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 06 Aug 2026 20:38:10 +0000
Message-Id: <20260806203811.2BF171F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Extensive memory and DMA buffer leaks on device probe and initiali=
zation error paths.
- [High] Double-free and use-after-free vulnerability on the error path of =
efct_hw_new_rq_set().
- [High] Unsafe teardown of stats_timer leading to Use-After-Free and timer=
 wheel corruption.
- [High] Invalid use of `timer_setup()` within the timer callback.
- [High] Error path in efct_hw_setup_io() leaks successfully allocated hw->=
io[i] inner objects.
--

--- Patch [4]: [PATCH v2 4/5] scsi: elx: efct: free the RQ buffers already =
allocated when one fails ---
commit be8b053b462b939279de3cc82f2caf1d37ac0767
Author: Ali Ahmet Memis <ali@iusegentoo.com>

scsi: elx: efct: free the RQ buffers already allocated when one fails

efct_hw_rx_buffer_alloc() allocates an array of descriptors and then a
coherent DMA buffer for each entry. When one of those allocations fails it
frees the array and returns NULL, leaving every buffer allocated before it
mapped. This commit uses efct_hw_rx_buffer_free() for the entries that
were filled in to fix the leak.

> diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct=
_hw.c
> index db68516e80750..d645ce256b8aa 100644
> --- a/drivers/scsi/elx/efct/efct_hw.c
> +++ b/drivers/scsi/elx/efct/efct_hw.c
> @@ -1170,6 +1170,10 @@ efct_get_wwpn(struct efct_hw *hw)
>  	return get_unaligned_be64(p);
>  }
> =20
> +static void
> +efct_hw_rx_buffer_free(struct efct_hw *hw, struct efc_hw_rq_buffer *rq_b=
uf,
> +		       u32 count);
> +
>  static struct efc_hw_rq_buffer *
>  efct_hw_rx_buffer_alloc(struct efct_hw *hw, u32 rqindex, u32 count,
>  			u32 size)
> @@ -1196,7 +1200,7 @@ efct_hw_rx_buffer_alloc(struct efct_hw *hw, u32 rqi=
ndex, u32 count,
>  						   GFP_KERNEL);
>  		if (!prq->dma.virt) {
>  			efc_log_err(hw->os, "DMA allocation failed\n");
> -			kfree(rq_buf);
> +			efct_hw_rx_buffer_free(hw, rq_buf, i);
>  			return NULL;
>  		}
>  	}

[Severity: High]
This is a pre-existing issue, but does this error path still leak memory?

In efct_hw_rx_allocate():

	if (!rq->hdr_buf) {
		efc_log_err(efct, "rx_buffer_alloc hdr_buf failed\n");
		rc =3D -EIO;
		break;
	}

If efct_hw_rx_buffer_alloc() fails for any queue index, it breaks the loop
and returns -EIO, but it appears to leak all hdr_buf and payload_buf DMA
buffer arrays that were successfully allocated in previous iterations.

Furthermore, in efct_hw_init():

	rc =3D efct_hw_rx_allocate(hw);
	if (rc) {
		efc_log_err(hw->os, "rx_allocate failed\n");
		return rc;
	}

It returns early on nested allocation failures without cleaning up its own
previous local allocations.

Finally, in efct_xport_initialize():

	rc =3D efct_hw_init(&efct->hw);
	if (rc) {
		efc_log_err(efct, "efct_hw_init failure\n");
		goto out;
	}

It jumps directly to out: on efct_hw_init() failure, skipping the hw_init_o=
ut:
label where efct_hw_teardown() is called. This seems to leak hardware
resources initialized during efct_hw_setup() and efct_hw_init() when the pr=
obe
fails.


[Severity: High]
This is a pre-existing issue, but can this error path lead to a double-free?

In efct_hw_new_rq_set():

	list_add_tail(&rqs[i]->list_entry, &cqs[i]->q_list);
	size =3D sizeof(struct efc_hw_sequence *) * rqs[i]->entry_count;
	rqs[i]->rq_tracker =3D kzalloc(size, GFP_KERNEL);
	if (!rqs[i]->rq_tracker)
		goto error;

If kzalloc() fails, it jumps to the error label:

error:
	for (i =3D 0; i < num_rq_pairs; i++) {
		if (rqs[i]) {
			kfree(rqs[i]->rq_tracker);
			kfree(rqs[i]);
		}
	}

This frees rqs[i] but does not remove it from the cqs[i]->q_list. The funct=
ion
then returns -EIO, triggering efct_hw_queue_teardown(hw), which calls
efct_hw_del_rq():

	list_del(&rq->list_entry);
	hw =3D rq->cq->eq->hw;
	hw->hw_rq[rq->instance] =3D NULL;
	kfree(rq);

The teardown iterates over the list, dereferences the already freed rq obje=
ct,
calls list_del() on it, and then calls kfree(rq) again. Does this double-fr=
ee
the object and corrupt the list?


[Severity: High]
This is a pre-existing issue, but is the teardown of stats_timer safe here?

In efct_xport_detach():

	if (timer_pending(&xport->stats_timer))
		timer_delete(&xport->stats_timer);

If the timer callback efct_xport_stats_timer_cb() is actively running on
another CPU, timer_pending() might return false. Even if timer_delete()
is called, it does not wait for the concurrent callback to finish.

This could allow efct_xport_detach() to proceed and eventually free the xpo=
rt
object while the timer callback is still executing. The callback would then
access the freed xport memory and call mod_timer(), inserting a freed timer
structure back into the kernel's active timer wheel. Should this
unconditionally use timer_delete_sync() without the timer_pending() check?


[Severity: High]
This is a pre-existing issue, but is it correct to call timer_setup() here?

In efct_xport_config_stats_timer():

	timer_setup(&xport->stats_timer,
		    &efct_xport_stats_timer_cb, 0);
	mod_timer(&xport->stats_timer,
		  jiffies + msecs_to_jiffies(timeout));

This function is called both for initial setup and from within the timer
callback itself (efct_xport_stats_timer_cb()) to re-arm the timer.

Calling timer_setup() on a timer that is actively being processed by the ti=
mer
subsystem resets the structure, clearing list pointers and lock-related fie=
lds.
Does this destroy the active timer structure and lead to kernel state
corruption?


[Severity: High]
This is a pre-existing issue, but does this error path leak the inner IO
objects?

In efct_hw_setup_io():

	hw->wqe_buffs =3D kzalloc((hw->config.n_io * hw->sli.wqe_size),
				GFP_KERNEL);
	if (!hw->wqe_buffs) {
		kfree(hw->io);
		return -ENOMEM;
	}

If the allocation for hw->wqe_buffs fails, the code frees the outer hw->io
array and returns -ENOMEM. However, it appears to completely skip the loop =
in
the error block that frees the individual hw->io[i] objects allocated prior=
 to
this, which would permanently leak them.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260806192345.3286=
21-1-ali@iusegentoo.com?part=3D4
