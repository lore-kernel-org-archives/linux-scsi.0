Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793742202;
	b=nDwBb51tEM/X4E1DnqaKlABffWS1yKupvieCfIxqDq+alHzeHEvwumJ3GqTH/QsP9S6L
	 WigTRFmUutVwTSgfspw2AtlOMMqwaUpSfDqokVAXF6yrTTvEeMw4+MVeU7khjl5dnFzlO
	 ugEgBEUEH8EfDjAxdJdU9KqDjVL8JbVsRCyx3SmL60qSr/uoWbR98uJvnt+a1Aoe37reN
	 Kx/PhfYOanyXduCV3Dd8zd5Fo4rhSrlOQbimHbxIA28RKxuQkqOgN7ERttHkC0b13d+Zq
	 IZDas9nmgharLoc+9RcVu4jFn6sZOUSLIOM/13SHpfeoYXUMa4rJ58OEKzYzTP1hDbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793742202;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Scanned-By;
	bh=Gdx/WQdxu5mNkZRNRx7LJXwK9h4DO072qzsRF6KgrFQ=;
	b=qaL51JF+Ek+zvxRR2VbUnUi4JpbIxHQyTY+03G3pcLgryYMbkpzl3h1IdC8WWtb51d7A
	 HlCZS3i+CvL1x2wp5mEFib3jSLl+Khxvac8qIXOZ6Lj0B4W/DZhHqfW2Cj6Zuay0n0QoQ
	 2Zzsi+fWJhISjQqlmLETP0OG/XEDHByO0kT+m74Yg4QOvmlSNaSQcO8DMEIIA1XdEbb8u
	 xY8/iDp5AECg0/+ZKWrMERk/KE1LfFxqNuA7ZLa1A4nViUStP48f7Ydzq4TgJScsB/xta
	 1mKpoFkJQ/2YOM7sDBkn0sAa6u5XAKiSs9CVmrnsE76I++Srr6APWU24Lhh4HIDwZrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b="P/sHOt4o";
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8BDB606D835
	for <linux-scsi@vger.kernel.org>; Tue,  3 Nov 2026 21:43:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C8BDB606D835
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=P/sHOt4o
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793742200;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Gdx/WQdxu5mNkZRNRx7LJXwK9h4DO072qzsRF6KgrFQ=;
	b=P/sHOt4ogENWbCgi9EWRBIx65oOiPOkFDrQuuKaI8fsVf0ldoT1vg/G6+Hn535LuJwRnyp
	5KEHlp6HenW4dbl6k7+NZWguJYwM0f5nlRl6yYqHnIeSo29iaIEwk5Eq9pW8uGSLfgrwYd
	+EQxr/U9aOgXvjfE7s6Tr/pzh8GWl9A=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-649-YYDZYaQiMUuMg9E1mMQlNA-1; Tue,
 03 Nov 2026 16:43:17 -0500
X-MC-Unique: YYDZYaQiMUuMg9E1mMQlNA-1
X-Mimecast-MFC-AGG-ID: YYDZYaQiMUuMg9E1mMQlNA_1793742196
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BB1E5195604E;
	Tue,  3 Nov 2026 21:43:15 +0000 (UTC)
Received: from localhost (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C44F5195608D;
	Tue,  3 Nov 2026 21:43:14 +0000 (UTC)
Date: Tue, 3 Nov 2026 16:43:13 -0500
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Hannes Reinecke <hare@suse.de>
Cc: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>, mst@redhat.com,
	jasowangio@gmail.com, mkp@kernel.org,
	James.Bottomley@hansenpartnership.com, pbonzini@redhat.com,
	eperezma@redhat.com, virtualization@lists.linux.dev,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	sashiko-bot@kernel.org, kwolf@redhat.com
Subject: Re: [PATCH v2] scsi: virtio_scsi: implement eh_host_reset_handler
Message-ID: <20261103214313.GA2159241@shajnocz.csb>
References: <20260911164417.33860-1-ngocthang2710.1999@gmail.com>
 <28865bba-ac60-4c6e-aec8-64b1fcdb1c8f@suse.de>
 <20260914133144.15509-1-ngocthang2710.1999@gmail.com>
 <20261102200615.GC1738758@shajnocz.csb>
 <c5460180-e134-423a-b67f-a58a00106eb8@suse.de>
 <20261103135156.GB2072598@shajnocz.csb>
 <bdef8300-8570-4103-8c8b-cb978c88eb81@suse.de>
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
In-Reply-To: <bdef8300-8570-4103-8c8b-cb978c88eb81@suse.de>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Tue, Nov 03, 2026 at 05:26:44PM +0100, Hannes Reinecke wrote:
> On 11/3/26 2:51 PM, Stefan Hajnoczi wrote:
> > On Tue, Nov 03, 2026 at 08:27:52AM +0100, Hannes Reinecke wrote:
> > > On 11/2/26 9:06 PM, Stefan Hajnoczi wrote:
> > > > On Mon, Sep 14, 2026 at 08:31:44PM +0700, Nguyen Ngoc Thang wrote:
> > > > > Once virtscsi_eh_timed_out() lets SCSI EH run on an unresponsive host,
> > > > > abort and device reset both fail the same way (same dead ctrl vq), and
> > > > > since virtio_scsi implements neither target nor bus reset, EH falls
> > > > > through to scsi_eh_offline_sdevs(), which frees the stuck commands' DMA
> > > > > buffers without any guarantee the device has actually stopped touching
> > > > > them. If bus mastering (or whatever broke the transport) comes back
> > > > > later, the device can still write into memory the kernel has already
> > > > > reused.
> > > > > 
> > > > > Add a real eh_host_reset_handler instead. virtio_reset_device() is the
> > > > > guarantee scsi_eh_offline_sdevs() was missing: once it returns, the
> > > > > device will not touch guest memory again, so it is safe to hand
> > > > > outstanding commands' buffers back. Reuse virtscsi_remove_vqs() +
> > > > > virtscsi_init() -- the exact sequence already used across
> > > > > suspend/resume -- to tear the virtqueues down and rebuild them.
> > > > > 
> > > > > Verified with a QEMU virtio-scsi repro (PCI_COMMAND_MASTER cleared
> > > > > mid-write): EH now runs abort -> device reset -> host reset -> abort ->
> > > > > device reset -> host reset -> offline, then dd's stuck fsync returns
> > > > > EIO and D-state drains to 0, in ~244s total. No task remains
> > > > > uninterruptibly blocked.
> > > > 
> > > > By the way, there is a known limitation in the QEMU virtio-scsi
> > > > implementation where some reset-related operations are implemented
> > > > synchronously (can block vCPUs and QEMU activity while waiting for I/O
> > > > to drain in some situations) instead of asynchronously. Recently there
> > > > has been work in QEMU to make VIRTIO device reset asynchronous, for
> > > > example, but it needs to be implemented on a per-device basis and
> > > > virtio-scsi hasn't taken advantage of it yet.
> > > > 
> > > > Please let me know if you'd like to discuss or contribute. It's
> > > > something that is on my radar but not until 2027.
> > > > 
> > > > > 
> > > > > Suggested-by: Hannes Reinecke <hare@suse.de>
> > > > > Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
> > > > > ---
> > > > > v1 -> v2: implemented eh_host_reset_handler as suggested by Hannes
> > > > > Reinecke in review of the original RFC, instead of relying solely on
> > > > > the EH loop falling through to offline.
> > > > > ---
> > > > >    drivers/scsi/virtio_scsi.c | 24 ++++++++++++++++++++++++
> > > > >    1 file changed, 24 insertions(+)
> > > > > 
> > > > > diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> > > > > index b4f20c487718..9698f4f91cc6 100644
> > > > > --- a/drivers/scsi/virtio_scsi.c
> > > > > +++ b/drivers/scsi/virtio_scsi.c
> > > > > @@ -833,6 +833,8 @@ static enum scsi_timeout_action virtscsi_eh_timed_out(struct scsi_cmnd *scmnd)
> > > > >    	return SCSI_EH_NOT_HANDLED;
> > > > >    }
> > > > > +static int virtscsi_host_reset(struct scsi_cmnd *sc);
> > > > > +
> > > > >    static const struct scsi_host_template virtscsi_host_template = {
> > > > >    	.module = THIS_MODULE,
> > > > >    	.name = "Virtio SCSI HBA",
> > > > > @@ -846,6 +848,7 @@ static const struct scsi_host_template virtscsi_host_template = {
> > > > >    	.eh_abort_handler = virtscsi_abort,
> > > > >    	.eh_device_reset_handler = virtscsi_device_reset,
> > > > >    	.eh_timed_out = virtscsi_eh_timed_out,
> > > > > +	.eh_host_reset_handler = virtscsi_host_reset,
> > > > >    	.sdev_init = virtscsi_device_alloc,
> > > > >    	.dma_boundary = UINT_MAX,
> > > > > @@ -947,6 +950,27 @@ static int virtscsi_init(struct virtio_device *vdev,
> > > > >    	return err;
> > > > >    }
> > > > > +/*
> > > > > + * No bus/target reset in virtio-scsi, so EH lands here after device
> > > > 
> > > > The choice to use the VIRTIO device reset in virtscsi_host_reset() looks
> > > > good to me, but I would like clarification on this comment. virtio-scsi
> > > > does have I_T_NEXUS_RESET and I believe this is the modern equivalent to
> > > > the pre-SCSI-6 TARGET RESET. Is it really the case that virtio-scsi
> > > > doesn't have target reset? And do you want to go ahead and implement
> > > > .eh_target_reset_handler() using I_T_NEXUS_RESET?
> > > > 
> > > Would probably not a bad idea to use I_T_NEXUS_RESET here.
> > > Not sure what it does internally, though; _is_ there a nexus
> > > to reset?
> > 
> > Whether there is any benefit to I_T_NEXUS_RESET may depend on the device
> > implementation. In QEMU:
> > - LOGICAL_UNIT_RESET resets just 1 LUN
> > - I_T_NEXUS_RESET resets all LUNs
> > - VIRTIO device reset also resets the HBA itself
> > 
> > In practice QEMU's I_T_NEXUS_RESET is unlikely to fix things if
> > LOGICAL_UNIT_RESET wasn't sufficient. Maybe it will help on other device
> > implementations though.
> > 
> > I think the Linux driver mapping should be:
> > - .eh_device_reset_handler() -> LOGICAL_UNIT_RESET
> > - .eh_target_reset_handler() -> I_T_NEXUS_RESET
> > - .eh_host_reset_handler() -> VIRTIO device reset
> > 
> I guess 'target_reset' is pretty much pointless for modern setups.
> If lun reset doesn't work it's pretty much guaranteed that target_reset
> won't help, either.
> (Unless you are on SAS, then it might, as I_T nexus reset actually
> resets the SAS link and such does something useful).
> Problem is that in most cases LUN reset fails as the _communication_
> to the LUN is interrupted, and hence sending another TMF across the
> same communication channel won't help, either.
> For virtio that would mean that we'd have to reset the virtio queues;
> can we even do that in a meaningful fashion?

The virtqueues can only really be reset by VIRTIO device reset
(.eh_host_reset_handler()).

Stefan

