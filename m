Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713925;
	b=YbQ+q7Y1e0jNQRbRG6l1cMPzUSpB/hueZYQBcOe975JWKTek9hrKBu2jagp663M2V9xm
	 +44Z05rMH+W1ptfZf/09N2DVA5zen+lf5JYMa2jgkoXaFYgotyjT/HvPDFjFLXL1gXTgl
	 +8k/IP4ZbGa+2/sp9dM0aFuZrUzdNE90NjxgKDrJmsLsl4FrJ75a7Epgi7GUqeZ+FmCt6
	 DXooTMunL2IDc8C5FA57xT66rHHre5ToI/+mq76nRUYBeVJdVUp/Kl1xmGfgRmc+wHYNq
	 Yhp444DdbGWyyUVvMLF9KgC8Gf+PfsMSIH8/UNp3KX2Lc33BGmWsEWiQzzAEvaTxdBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713925;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Scanned-By;
	bh=3CiB6pHb/Xg9TLgDzg5nxHTYIzZ/5IkLEI/qgRbMHzo=;
	b=DzX9LvXx1vUm5d/0UXRRXbbnlg5ZPIJWskNDJ9eLHOrLp4/95zBPJp6/97ODL24Dgrkn
	 ETycMrChtryrr+yF3BsYU0XdY4CulIbJX5tD/VBoCsY+25EvRNHkAb2q8+LTbthm6mVMr
	 8RplPbf0Pj4juvvPuTNe3D85W1aIQ8aj8cFuuEvlDHE3ibfz8sA8bGSeH/D/o1Hgza/gp
	 3tBpcWxGuJCSppGjYeX8OX7GPX10Stz1rJS5c0kfwxcVYNaJANtqAWl/a84olALAzfVkV
	 Z0bF2osmvEhYdBWT63iPYCxv6vM4lrYXaRKTou7fHVQ+yZ/FqUq+G8o/z6NKdkfPVtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b="h/0/JH22";
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076EC606D806
	for <linux-scsi@vger.kernel.org>; Tue,  3 Nov 2026 13:52:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 076EC606D806
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=h/0/JH22
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793713922;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3CiB6pHb/Xg9TLgDzg5nxHTYIzZ/5IkLEI/qgRbMHzo=;
	b=h/0/JH22sw23sC46Vl422EYL3Bq63S927IKR9XZbRavEFdw0D5HViG56TBOZ09MxaPPdIx
	rNgYDmFMQP8ncRHXFyyK6/ULZBfhCiIlgBupAGvxqNWuD0WxSiMrwgrB2yFCkhuG+nKO2Y
	astMsEp3MkefYQR0fVgCTtO7mx06gTI=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-518-hvePkwNkNtOmG3aq1m2fhg-1; Tue,
 03 Nov 2026 08:52:01 -0500
X-MC-Unique: hvePkwNkNtOmG3aq1m2fhg-1
X-Mimecast-MFC-AGG-ID: hvePkwNkNtOmG3aq1m2fhg_1793713919
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 470E71800646;
	Tue,  3 Nov 2026 13:51:59 +0000 (UTC)
Received: from localhost (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 18CBC1800677;
	Tue,  3 Nov 2026 13:51:57 +0000 (UTC)
Date: Tue, 3 Nov 2026 08:51:56 -0500
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Hannes Reinecke <hare@suse.de>
Cc: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>, mst@redhat.com,
	jasowangio@gmail.com, mkp@kernel.org,
	James.Bottomley@hansenpartnership.com, pbonzini@redhat.com,
	eperezma@redhat.com, virtualization@lists.linux.dev,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	sashiko-bot@kernel.org, kwolf@redhat.com
Subject: Re: [PATCH v2] scsi: virtio_scsi: implement eh_host_reset_handler
Message-ID: <20261103135156.GB2072598@shajnocz.csb>
References: <20260911164417.33860-1-ngocthang2710.1999@gmail.com>
 <28865bba-ac60-4c6e-aec8-64b1fcdb1c8f@suse.de>
 <20260914133144.15509-1-ngocthang2710.1999@gmail.com>
 <20261102200615.GC1738758@shajnocz.csb>
 <c5460180-e134-423a-b67f-a58a00106eb8@suse.de>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c5460180-e134-423a-b67f-a58a00106eb8@suse.de>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Tue, Nov 03, 2026 at 08:27:52AM +0100, Hannes Reinecke wrote:
> On 11/2/26 9:06 PM, Stefan Hajnoczi wrote:
> > On Mon, Sep 14, 2026 at 08:31:44PM +0700, Nguyen Ngoc Thang wrote:
> > > Once virtscsi_eh_timed_out() lets SCSI EH run on an unresponsive host,
> > > abort and device reset both fail the same way (same dead ctrl vq), and
> > > since virtio_scsi implements neither target nor bus reset, EH falls
> > > through to scsi_eh_offline_sdevs(), which frees the stuck commands' DMA
> > > buffers without any guarantee the device has actually stopped touching
> > > them. If bus mastering (or whatever broke the transport) comes back
> > > later, the device can still write into memory the kernel has already
> > > reused.
> > > 
> > > Add a real eh_host_reset_handler instead. virtio_reset_device() is the
> > > guarantee scsi_eh_offline_sdevs() was missing: once it returns, the
> > > device will not touch guest memory again, so it is safe to hand
> > > outstanding commands' buffers back. Reuse virtscsi_remove_vqs() +
> > > virtscsi_init() -- the exact sequence already used across
> > > suspend/resume -- to tear the virtqueues down and rebuild them.
> > > 
> > > Verified with a QEMU virtio-scsi repro (PCI_COMMAND_MASTER cleared
> > > mid-write): EH now runs abort -> device reset -> host reset -> abort ->
> > > device reset -> host reset -> offline, then dd's stuck fsync returns
> > > EIO and D-state drains to 0, in ~244s total. No task remains
> > > uninterruptibly blocked.
> > 
> > By the way, there is a known limitation in the QEMU virtio-scsi
> > implementation where some reset-related operations are implemented
> > synchronously (can block vCPUs and QEMU activity while waiting for I/O
> > to drain in some situations) instead of asynchronously. Recently there
> > has been work in QEMU to make VIRTIO device reset asynchronous, for
> > example, but it needs to be implemented on a per-device basis and
> > virtio-scsi hasn't taken advantage of it yet.
> > 
> > Please let me know if you'd like to discuss or contribute. It's
> > something that is on my radar but not until 2027.
> > 
> > > 
> > > Suggested-by: Hannes Reinecke <hare@suse.de>
> > > Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
> > > ---
> > > v1 -> v2: implemented eh_host_reset_handler as suggested by Hannes
> > > Reinecke in review of the original RFC, instead of relying solely on
> > > the EH loop falling through to offline.
> > > ---
> > >   drivers/scsi/virtio_scsi.c | 24 ++++++++++++++++++++++++
> > >   1 file changed, 24 insertions(+)
> > > 
> > > diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> > > index b4f20c487718..9698f4f91cc6 100644
> > > --- a/drivers/scsi/virtio_scsi.c
> > > +++ b/drivers/scsi/virtio_scsi.c
> > > @@ -833,6 +833,8 @@ static enum scsi_timeout_action virtscsi_eh_timed_out(struct scsi_cmnd *scmnd)
> > >   	return SCSI_EH_NOT_HANDLED;
> > >   }
> > > +static int virtscsi_host_reset(struct scsi_cmnd *sc);
> > > +
> > >   static const struct scsi_host_template virtscsi_host_template = {
> > >   	.module = THIS_MODULE,
> > >   	.name = "Virtio SCSI HBA",
> > > @@ -846,6 +848,7 @@ static const struct scsi_host_template virtscsi_host_template = {
> > >   	.eh_abort_handler = virtscsi_abort,
> > >   	.eh_device_reset_handler = virtscsi_device_reset,
> > >   	.eh_timed_out = virtscsi_eh_timed_out,
> > > +	.eh_host_reset_handler = virtscsi_host_reset,
> > >   	.sdev_init = virtscsi_device_alloc,
> > >   	.dma_boundary = UINT_MAX,
> > > @@ -947,6 +950,27 @@ static int virtscsi_init(struct virtio_device *vdev,
> > >   	return err;
> > >   }
> > > +/*
> > > + * No bus/target reset in virtio-scsi, so EH lands here after device
> > 
> > The choice to use the VIRTIO device reset in virtscsi_host_reset() looks
> > good to me, but I would like clarification on this comment. virtio-scsi
> > does have I_T_NEXUS_RESET and I believe this is the modern equivalent to
> > the pre-SCSI-6 TARGET RESET. Is it really the case that virtio-scsi
> > doesn't have target reset? And do you want to go ahead and implement
> > .eh_target_reset_handler() using I_T_NEXUS_RESET?
> > 
> Would probably not a bad idea to use I_T_NEXUS_RESET here.
> Not sure what it does internally, though; _is_ there a nexus
> to reset?

Whether there is any benefit to I_T_NEXUS_RESET may depend on the device
implementation. In QEMU:
- LOGICAL_UNIT_RESET resets just 1 LUN
- I_T_NEXUS_RESET resets all LUNs
- VIRTIO device reset also resets the HBA itself

In practice QEMU's I_T_NEXUS_RESET is unlikely to fix things if
LOGICAL_UNIT_RESET wasn't sufficient. Maybe it will help on other device
implementations though.

I think the Linux driver mapping should be:
- .eh_device_reset_handler() -> LOGICAL_UNIT_RESET
- .eh_target_reset_handler() -> I_T_NEXUS_RESET
- .eh_host_reset_handler() -> VIRTIO device reset

> > > + * reset also times out. A virtio reset guarantees the device won't
> > > + * touch guest memory again, so stuck commands can be freed safely.
> > > + * Same teardown/rebuild already used for suspend/resume.
> > > + */
> > > +static int virtscsi_host_reset(struct scsi_cmnd *sc)
> > > +{
> > > +	struct virtio_scsi *vscsi = shost_priv(sc->device->host);
> > > +	struct virtio_device *vdev = vscsi->vdev;
> > > +
> > > +	scmd_printk(KERN_INFO, sc, "host reset\n");
> > > +
> > > +	virtscsi_remove_vqs(vdev);
> > 
> > This is synchronous and may take a long time. I noticed that some SCSI
> > drivers have a timeout that returns FAILED when the low-level host reset
> > operation takes too long. This can be done here too but would require
> > adding a timeout to virtio_reset_device() (i.e. see the virtio-pci
> > implementation that loops until the device register indicates reset is
> > complete).
> > 
> Never, ever, return FAILED from a host reset.
> That will induce a non-recoverable error, and you have to reset the
> OS to get the virtio devices back.
> Not something you'd want to do I guess.
> 
> Yes, I know that host reset can take a long time. But normally
> host reset would be the last resort, so really when you have to
> call it your system has exhausted all other options.

Okay.

Stefan

