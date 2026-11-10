Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794353884;
	b=ulEyMHUKdN+/5EqB80edP1lcphzKZCeRwVPfF78u4S1F+cUI0ZK04nWtyI/Ps5rYQ48d
	 9HpexQE0hkm7oSQTnWZwixO7LggjbhH7RwT+aqpDeUP3lxWLM1/VDaW5tlLYBvQbP04nE
	 VrYfC+SQ/te/ppoX/3CA5Xu3TQmI8MCWryW9SofPxiiuHGH6Wc2QL3Ani+3uTwy45++38
	 4L2ey06HG3mYYrLejsoyB4SQHA1OaKFrqr8WehFWgTtOdEb0cp4loKtoB+v1o0Zz7glfx
	 Kidayxy+f8f42af/PEx+kQt1MNw3wxqVAFewlQb6qKp6lJ+8tH9AvLRipYlIqxMgAMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794353884;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=3Zo3v4U+Gczwr3NvRXT1n0ItnwpM98u0Wts2kT0FvuI=;
	b=Cn49tn7OxPfSmcRpatLq6MRGQnoDvDc5XdmtyfG061U8uT+wb5qxNrIJaAhFjou3KuG7
	 UoDsbtFf7EqHAkVhoiVRGWOAB6fmuu36tiNECpGXcpkg+gQllLdg27NScjg1RRuFLWMJ9
	 lpeFbnjHS4PFy60SeetSrhQVmmNsVzpLRjTbfBdKsXuaWj1ZsXPbNFLqGE+mYEYLi6wd0
	 6qSGPFFn4wFb/kJFYvhBcZurxtoEbDbExslId3nMkuFIGqnqsubJ9PyAocdp50n6Erl1Z
	 rYr2KMEbNsCnGirshbJ/ggQxbQyfAB/3JFuPrj6IDfBrYOLNGCIaWSQjRQqJy0Mye6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ndV6lIEg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED5A606A31C
	for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2026 23:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ndV6lIEg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD68C1F0093C;
	Tue, 10 Nov 2026 23:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794353883;
	bh=3Zo3v4U+Gczwr3NvRXT1n0ItnwpM98u0Wts2kT0FvuI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ndV6lIEgcYeRkK9AuBHt8COzUIroxFDdUqqVlDrUD+X5Mfz7u0AjN7swaetE9CXEf
	 jwsl8hEqzfiY5XE7UTZsQVmS8s7CGGQgi6M0wutiINKoAysOITVHj4dkEedpycHbSV
	 kjMO+AJyiqVjjhYN6f5x1Pquq83CodpzQhCT8EBf7AInI2BaDXlyErmgiK4ylBclLp
	 eXJVPX7waWsnEi691VDwCKLvPPNikfkkB51H25TpMs8te/Eri7jKK5bdeXxks0dVe8
	 2iMOh9Dz7MnhJjcZWNUxMGqDUe7qzKBMDBPD5z6mKzUPlksy0hrY7YCY3ifTOyx5TF
	 F6zNGvyUCSJxA==
Message-ID: <sashiko-outbox-207945@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] xen/scsiback: unbind the IRQ before draining in-flight
 requests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261109122654.30859-1-yhlee@isslab.korea.ac.kr>
References: <20261109122654.30859-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 23:38:03 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] xen/scsiback: premature IRQ unbind in scsiback_disconnect()
  races with responses
--

commit 3923ae443e53c8e678c6827dafcd0fcc2ee96487
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

xen/scsiback: unbind the IRQ before draining in-flight requests

This commit moves unbind_from_irqhandler() and clearing info->irq ahead of
waiting for nr_unreplied_reqs to reach zero in scsiback_disconnect() so the
threaded IRQ handler cannot admit new requests after the drain finishes.

> diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
> index c7036e0e41bda..647a3c7e2a2b3 100644
> --- a/drivers/xen/xen-scsiback.c
> +++ b/drivers/xen/xen-scsiback.c
> @@ -603,11 +603,13 @@ static int scsiback_gnttab_data_map(struct vscsiif_=
request *ring_req,
> =20
>  static void scsiback_disconnect(struct vscsibk_info *info)
>  {
> +	/* Stop admitting requests before draining the in-flight ones. */
> +	unbind_from_irqhandler(info->irq, info);
> +	info->irq =3D 0;
> +
>  	wait_event(info->waiting_to_free,
>  		atomic_read(&info->nr_unreplied_reqs) =3D=3D 0);
> =20
> -	unbind_from_irqhandler(info->irq, info);
> -	info->irq =3D 0;
>  	xenbus_unmap_ring_vfree(info->dev, info->ring.sring);
>  }

[Severity: High]
Does unbinding and zeroing info->irq before wait_event() introduce a
regression where scsiback_send_response() races with delayed_free_irq()
or notifies IRQ 0 while in-flight requests are still draining?

In-flight commands complete on target_completion workqueues via
scsiback_cmd_done(), which calls scsiback_do_resp_with_sense() ->
scsiback_send_response() before scsiback_put(info) decrements
info->nr_unreplied_reqs.  In scsiback_send_response(), info->irq is read
outside info->ring_lock and passed to notify_remote_via_irq() in
preemptible context without RCU protection:

CPU0                              CPU1 (kworker)
scsiback_disconnect()             scsiback_cmd_done()
                                    ...
                                    scsiback_send_response()
                                      irq =3D info->irq;
  unbind_from_irqhandler(...)
    ...
    xen_free_irq(irq)
      queue_rcu_work(..., &rwork)
  info->irq =3D 0;
  wait_event(..., nr_unreplied_reqs =3D=3D 0)
  [RCU grace period elapses]
  delayed_free_irq()
    set_info_for_irq(irq, NULL)
    kfree(irq_info)
    xen_irq_free_desc(irq)
                                      notify_remote_via_irq(irq)
                                        evtchn_from_irq(irq)
                                          irq_info->evtchn <-- use-after-fr=
ee
                                    scsiback_put(info)

Once info->irq =3D 0 becomes visible during wait_event(), every completing
request calls notify_remote_via_irq(0).  IRQ 0 is a valid Xen IRQ number:
xen_allocate_irq_dynamic() allocates descriptors via
irq_alloc_desc_from(0, -1), so on platforms where nr_legacy_irqs() is 0
(such as ARM64 or x86 Xen PV domains with null_legacy_pic, where
VIRQ_TIMER binds to IRQ 0 at boot), info_for_irq(0) is non-NULL with a
valid event channel and notify_remote_via_irq(0) sends spurious
notifications to that channel.

Unbinding before wait_event() also closes the event channel via
xen_evtchn_close() before in-flight responses are pushed to the ring,
dropping completion notifications during the drain.  Calling
disable_irq(info->irq) before wait_event() and keeping
unbind_from_irqhandler(info->irq, info) after wait_event() would stop
scsiback_irq_fn() synchronously while keeping info->irq valid until all
in-flight requests have completed.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109122654.3085=
9-1-yhlee@isslab.korea.ac.kr?part=3D1
