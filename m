Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794997960;
	b=Z305LtjWtArU30kIhf2TjGCGBp7XZQg+AAHNocUKMPrW7FZIJN0NT65Hb+k9vrP6v/yr
	 m3E3jvhavX0F5sYzC/PxwDP/Xk+bWLoZINiul/3vH7M0wampwW3lVznOwHffswYi47eJ1
	 a/7aG8YkWJDt0Szq+u0F2LWzf3izSqlkgIhrlLrsoMQhsPL+HL/hvVRdsgijJnbTVlO2z
	 EXdBCX+M4PAKgS+fEs8Rg4pedU8yWf4W6L4mQ/dOkSNfp1RVxTQ+znIIOF4sJVVE3iviF
	 SGZVmPqyeczjbTBVf8Pe3p1Aj30rKQxSo3qcKKKIbRGn9iMgxzI8lcbw32gOZDKoU+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794997960;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=h/c4iCqRvoU77oxWzgttSwXZFPan+P4PM0gvPSxORkI=;
	b=LczZ5jKE+VWdYhVlA8Xlcv2/GnodEGCi7uGY8OwtYsCeQsmml2Y3CspuT7LDbRCNetAC
	 ieBiR0h/4QyV6DYTbsb9CC3xa0QuC26nNNge6CFiNhEb0nld7bM50BwugWHazveaGYa28
	 6guAdeHCwnATtitVsOy4CBBofxrso41bf348yFZqrbBzTgmGcJtkOytGC5r2Ozt+Izc/M
	 7BbK8HJrIexpRAXJuALZObBUtNSRca9momgH2JsWHTglPerf8PkuihmJbcArFoWVS8gIV
	 7N7cS+YBLSHz8ghbOJLOkFECR1nswbETalSYacCexGbphUbeFYo4I69ZdfL+FNomt1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ur5r2Gap;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CCD6606A31C
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ur5r2Gap
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E61D81F000C4;
	Wed, 18 Nov 2026 10:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794997960;
	bh=h/c4iCqRvoU77oxWzgttSwXZFPan+P4PM0gvPSxORkI=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=Ur5r2Gap6+o6A7nZPcTHAGCe40nLlXpOnx50hJkaqrxayzV+Lhtay51Hxy350NaLO
	 wG4l0UcySkhLAIJ1KZB9O8pVMHdF06MCzxqRiisKbC3olC1R8tevUrzXw0Mnales5F
	 mrOx+iKnYHThxAsKsllma5+cLHqferGgIPd/NrzKllbXKAF+/NEqG+/wYpjQ0+bokQ
	 KRYMHhLsvq0Ver0pBXVuq1UdVqogIVhQ7fDHjU5s4W0tpTtTC45VMPLy67coY6Gt6b
	 JeAee/TsLpJ7tFlluREKyNvJsOcnNqNuB6jfrsaR/OW5fGUgoGCrJw5sYf2fCK+Rm9
	 vu4/UIdnoExCQ==
Message-ID: <sashiko-outbox-220700@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 12/37] scsi: mpt3sas: Fix leak and dangling pointer
 for io_uring_poll_queues
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shivasharan S" <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
In-Reply-To: <1794995806-5835-13-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1794995806-5835-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1794995806-5835-13-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 10:32:39 +0000
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
- [Medium] scsi: mpt3sas: NULL deref of io_uring_poll_queues after
  disable_msix()
- [Low] scsi: mpt3sas: missing Fixes trailer for commit 432bc7caef4e
--

commit a58948543f4caa46f0c5cf6ea2380d1623cf71c1
Author: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

> scsi: mpt3sas: Fix leak and dangling pointer for io_uring_poll_queues
>
> Free ioc->io_uring_poll_queues on the legacy-IRQ fallback path and
> NULL it after freeing.
>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>

[Severity: Low]
Should this include a Fixes tag for the commit that introduced the
allocation and cleanup of ioc->io_uring_poll_queues:

  Fixes: 432bc7caef4e ("scsi: mpt3sas: Add io_uring iopoll support")

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/m=
pt3sas_base.c
> index 8182c7ba8b9a7..24b74760d6816 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -3362,6 +3362,7 @@ mpt3sas_base_disable_msix(struct MPT3SAS_ADAPTER *i=
oc)
>  	pci_free_irq_vectors(ioc->pdev);
>  	ioc->msix_enable =3D 0;
>  	kfree(ioc->io_uring_poll_queues);
> +	ioc->io_uring_poll_queues =3D NULL;
>  }
> =20
>  /**
> @@ -3541,6 +3542,8 @@ _base_enable_msix(struct MPT3SAS_ADAPTER *ioc)
> =20
>  /* failback to io_apic interrupt routing */
>   try_ioapic:
> +	kfree(ioc->io_uring_poll_queues);
> +	ioc->io_uring_poll_queues =3D NULL;
>  	ioc->high_iops_queues =3D 0;
>  	ioc_info(ioc, "High IOPs queues : disabled\n");
>  	ioc->reply_queue_count =3D 1;

[Severity: Medium]
Can setting ioc->io_uring_poll_queues to NULL cause a NULL pointer
dereference in mpt3sas_base_pause_mq_polling() or mpt3sas_blk_mq_poll()?

Unlike the try_ioapic path in _base_enable_msix(),
mpt3sas_base_disable_msix() frees and NULLs ioc->io_uring_poll_queues
without resetting ioc->iopoll_q_start_index to ioc->reply_queue_count.
During PCIe error recovery, scsih_pci_error_detected() handles
pci_channel_io_frozen by calling mpt3sas_base_free_resources() ->
mpt3sas_base_unmap_resources() -> mpt3sas_base_disable_msix().  If slot
reset or resource remapping subsequently fails,
scsih_pci_error_detected() is called with pci_channel_io_perm_failure and
invokes mpt3sas_base_pause_mq_polling(), which computes a non-zero
iopoll_q_count and dereferences ioc->io_uring_poll_queues:

drivers/scsi/mpt3sas/mpt3sas_base.c:mpt3sas_base_pause_mq_polling() {
	int iopoll_q_count =3D
	    ioc->reply_queue_count - ioc->iopoll_q_start_index;
	int qid;

	for (qid =3D 0; qid < iopoll_q_count; qid++)
		atomic_set(&ioc->io_uring_poll_queues[qid].pause, 1);
    ...
}

In addition, if an adapter probes with poll_queues > 0 (mapping
HCTX_TYPE_POLL queues in blk-mq) and later falls back to try_ioapic
during scsih_resume() or scsih_pci_slot_reset(), ioc->io_uring_poll_queues
is NULL while HCTX_TYPE_POLL queues remain registered, so subsequent calls
to mpt3sas_blk_mq_poll() will also dereference NULL.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1794995806-5835-1-g=
it-send-email-shivasharan.srikanteshwara@broadcom.com?part=3D12
