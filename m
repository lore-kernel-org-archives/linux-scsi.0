Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793649984;
	b=Lytx4KTFIdrunTAsajrP9g4SAQWS3VrCBDjWOiyj6G0+cmk6GxZwtKNTz4UZY7Z79qO2
	 zOSBq3H2yx/gt29ml1+2B+SgE7JcVd+M7B6k9FSoFfIsgTXQfVPkXpa5cCUeCzxqYRZvD
	 YE/rU+3w+1wajVcEF01TgnRDaYQB4pLPyZYD5KRh8B0xClul/oTRWA91o9Efd5hv2432S
	 9Ocz6GV+YeoxiAjBFUzUbwFEKk13G7lVT+SOK3KyvaqCOIAgU5wEHnKlnduq1JuYz3Gmb
	 prlht1rX040U7G35Fv08KRrxNFTZbGUC/+eIPrhTBnmn6U1waTG/QlOiV9T3eMIO6OA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793649984;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Scanned-By;
	bh=loLXagEnBUuSSHP3j0cjXB3Ekg44KHkg/qF2k3+NA5M=;
	b=mqsy29mYnb7cXdAxSM7KbNMT1iMBe7vH92pbYdBYRik5iHJoy8mreoW04knMmLLXgDM+
	 kB+i4yAGCm2NJShSVqqQjEvX54qbPg+EYnDl3X6jP7T+D6zkA26VaZXDvQSi17GM17PS7
	 uerC0zrivw2YCJxfXaLK+xXwZKVP/iahzQ2SB37nhJ0YEUJBwX6PM9VcWSssNpiAgpZTi
	 Iu9GVaSk8gsKheS+x5WVFmVhnZLcPhnl7cXX8JcMUMg8DyODlaOx6NZYBUlhgo5ajldV/
	 1iTRJ48cX9ebSTqqKDJK3ljbmQ0EKGSN6Xo+E2zR1TSO3FyeOjxmCjRGjWXi6hhPM0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ZmaEs6os;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693B9606A32D
	for <linux-scsi@vger.kernel.org>; Mon,  2 Nov 2026 20:06:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 693B9606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ZmaEs6os
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793649982;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=loLXagEnBUuSSHP3j0cjXB3Ekg44KHkg/qF2k3+NA5M=;
	b=ZmaEs6osnXY6zqPSNa00JI3b5CGScNV2utc6EUlXm8AgxVHhBG7T8oHUdAPRqttqB1Pcas
	Calke3hkMqv6nTMF6A9RLtwkpEYT9+XNN4B93PLkWNn/JXFaRC97gZDIn33AEkaHkUVKQu
	Vs1MKsQRHhm9jFQir9kB8cs98Cty+Xo=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-240-wSa3VeRJNwqtusXtcS2FQw-1; Mon,
 02 Nov 2026 15:06:18 -0500
X-MC-Unique: wSa3VeRJNwqtusXtcS2FQw-1
X-Mimecast-MFC-AGG-ID: wSa3VeRJNwqtusXtcS2FQw_1793649977
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F1F311956055;
	Mon,  2 Nov 2026 20:06:16 +0000 (UTC)
Received: from localhost (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4F6BF1955F43;
	Mon,  2 Nov 2026 20:06:16 +0000 (UTC)
Date: Mon, 2 Nov 2026 15:06:15 -0500
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Cc: Hannes Reinecke <hare@suse.de>, mst@redhat.com, jasowangio@gmail.com,
	mkp@kernel.org, James.Bottomley@hansenpartnership.com,
	pbonzini@redhat.com, eperezma@redhat.com,
	virtualization@lists.linux.dev, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, sashiko-bot@kernel.org,
	kwolf@redhat.com
Subject: Re: [PATCH v2] scsi: virtio_scsi: implement eh_host_reset_handler
Message-ID: <20261102200615.GC1738758@shajnocz.csb>
References: <20260911164417.33860-1-ngocthang2710.1999@gmail.com>
 <28865bba-ac60-4c6e-aec8-64b1fcdb1c8f@suse.de>
 <20260914133144.15509-1-ngocthang2710.1999@gmail.com>
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
In-Reply-To: <20260914133144.15509-1-ngocthang2710.1999@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Mon, Sep 14, 2026 at 08:31:44PM +0700, Nguyen Ngoc Thang wrote:
> Once virtscsi_eh_timed_out() lets SCSI EH run on an unresponsive host,
> abort and device reset both fail the same way (same dead ctrl vq), and
> since virtio_scsi implements neither target nor bus reset, EH falls
> through to scsi_eh_offline_sdevs(), which frees the stuck commands' DMA
> buffers without any guarantee the device has actually stopped touching
> them. If bus mastering (or whatever broke the transport) comes back
> later, the device can still write into memory the kernel has already
> reused.
> 
> Add a real eh_host_reset_handler instead. virtio_reset_device() is the
> guarantee scsi_eh_offline_sdevs() was missing: once it returns, the
> device will not touch guest memory again, so it is safe to hand
> outstanding commands' buffers back. Reuse virtscsi_remove_vqs() +
> virtscsi_init() -- the exact sequence already used across
> suspend/resume -- to tear the virtqueues down and rebuild them.
> 
> Verified with a QEMU virtio-scsi repro (PCI_COMMAND_MASTER cleared
> mid-write): EH now runs abort -> device reset -> host reset -> abort ->
> device reset -> host reset -> offline, then dd's stuck fsync returns
> EIO and D-state drains to 0, in ~244s total. No task remains
> uninterruptibly blocked.

By the way, there is a known limitation in the QEMU virtio-scsi
implementation where some reset-related operations are implemented
synchronously (can block vCPUs and QEMU activity while waiting for I/O
to drain in some situations) instead of asynchronously. Recently there
has been work in QEMU to make VIRTIO device reset asynchronous, for
example, but it needs to be implemented on a per-device basis and
virtio-scsi hasn't taken advantage of it yet.

Please let me know if you'd like to discuss or contribute. It's
something that is on my radar but not until 2027.

> 
> Suggested-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
> ---
> v1 -> v2: implemented eh_host_reset_handler as suggested by Hannes
> Reinecke in review of the original RFC, instead of relying solely on
> the EH loop falling through to offline.
> ---
>  drivers/scsi/virtio_scsi.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index b4f20c487718..9698f4f91cc6 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -833,6 +833,8 @@ static enum scsi_timeout_action virtscsi_eh_timed_out(struct scsi_cmnd *scmnd)
>  	return SCSI_EH_NOT_HANDLED;
>  }
>  
> +static int virtscsi_host_reset(struct scsi_cmnd *sc);
> +
>  static const struct scsi_host_template virtscsi_host_template = {
>  	.module = THIS_MODULE,
>  	.name = "Virtio SCSI HBA",
> @@ -846,6 +848,7 @@ static const struct scsi_host_template virtscsi_host_template = {
>  	.eh_abort_handler = virtscsi_abort,
>  	.eh_device_reset_handler = virtscsi_device_reset,
>  	.eh_timed_out = virtscsi_eh_timed_out,
> +	.eh_host_reset_handler = virtscsi_host_reset,
>  	.sdev_init = virtscsi_device_alloc,
>  
>  	.dma_boundary = UINT_MAX,
> @@ -947,6 +950,27 @@ static int virtscsi_init(struct virtio_device *vdev,
>  	return err;
>  }
>  
> +/*
> + * No bus/target reset in virtio-scsi, so EH lands here after device

The choice to use the VIRTIO device reset in virtscsi_host_reset() looks
good to me, but I would like clarification on this comment. virtio-scsi
does have I_T_NEXUS_RESET and I believe this is the modern equivalent to
the pre-SCSI-6 TARGET RESET. Is it really the case that virtio-scsi
doesn't have target reset? And do you want to go ahead and implement
.eh_target_reset_handler() using I_T_NEXUS_RESET?

> + * reset also times out. A virtio reset guarantees the device won't
> + * touch guest memory again, so stuck commands can be freed safely.
> + * Same teardown/rebuild already used for suspend/resume.
> + */
> +static int virtscsi_host_reset(struct scsi_cmnd *sc)
> +{
> +	struct virtio_scsi *vscsi = shost_priv(sc->device->host);
> +	struct virtio_device *vdev = vscsi->vdev;
> +
> +	scmd_printk(KERN_INFO, sc, "host reset\n");
> +
> +	virtscsi_remove_vqs(vdev);

This is synchronous and may take a long time. I noticed that some SCSI
drivers have a timeout that returns FAILED when the low-level host reset
operation takes too long. This can be done here too but would require
adding a timeout to virtio_reset_device() (i.e. see the virtio-pci
implementation that loops until the device register indicates reset is
complete).

> +	if (virtscsi_init(vdev, vscsi))
> +		return FAILED;
> +
> +	virtio_device_ready(vdev);

Missing virtscsi_kick_event_all() like in virtscsi_restore()?

> +	return SUCCESS;
> +}
> +
>  static int virtscsi_probe(struct virtio_device *vdev)
>  {
>  	struct Scsi_Host *shost;
> -- 
> 2.43.0
> 

