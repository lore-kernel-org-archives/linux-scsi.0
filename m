Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793620118;
	b=eAEZ2d69D0049Fuxo4B/FYlwAsgHchNLoRRzBQUqRd+3QDp9Iig7knwA/zqWjrYglI0F
	 /gER4/C14G07TS2VyEXuWbZQfexP4I0bdMrkzV+K//wSdCAmRweO9yFh4Z+IloHi/yb1A
	 YshH4PkY8hLXrBHpCa1GHwsxMUt2/8ZoU3ZKTjONYpfCJVJebDa32JRViRIZCsZNK3NDW
	 CaTYH/tmJjbeaMLWQw2fwMqt4FkmVxiESCP/G3Uahk4k71ESMpPLE4GAwBbVXOBguh2/h
	 MG9RIC0btv77D/MvIVFCIURBG6AHgw0aa7g0chst6YyaWebjoUlp2ZIkWAHKa+8Gqbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793620118;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=ziwl8QBf1v7FFJqjlJ23GJJU3dSmhwP3y1Fomlh8GfI=;
	b=bkDIsu2X/1zsFxDlf5Lx0hFJOmEwDP8QwEY8juOetQDceSRRzzVITN0l0DjV/0i4aWBQ
	 D+BhKItNNznDx+tOKwVJjzZC90RlUYHCP5EOjpx/uDLSei42dfnNbH+iD7XCkrX0Wb9Np
	 rO3RvGQ03ui8QvgB3VZzG6M2w/Vu5Lh1j8jZ24ACA/GIpTOgbUHhtiPppZy5pFXpECt55
	 gxRQteVyH41PgCP+XxukgCrXCp4Tr005vboH1V515CnkYX1qyyRT99rCUWDAeEJPb+XF0
	 9QbEPGQcJDWjk+YqfpTlHzK1y5HKJTl/7Cr2k48Winwj9lFaDoOqPxwTHceURyxAQNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=J7gTOC1C;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=BA4AL+1t;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084F5606A324
	for <linux-scsi@vger.kernel.org>; Mon,  2 Nov 2026 11:48:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 084F5606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=J7gTOC1C;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=BA4AL+1t
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793620117;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ziwl8QBf1v7FFJqjlJ23GJJU3dSmhwP3y1Fomlh8GfI=;
	b=J7gTOC1CgeZwOs6WKx9m6KCUmR0lPQoVxNuxZEgVkGJc9tkzmBb8AAsdNntD09+2CkrIng
	8MLO0EKVL3QxvMzHVZI5+IAstXwqQ6z9WIkgs2SiOoINkZyW8EPCcTmon/3pooo2+peCas
	I1B9ZEgd8T2be11DWCO75BODB4aagxg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-79-EB2aKRKEPaK9wH5HNkXoIw-1; Mon, 02 Nov 2026 06:48:35 -0500
X-MC-Unique: EB2aKRKEPaK9wH5HNkXoIw-1
X-Mimecast-MFC-AGG-ID: EB2aKRKEPaK9wH5HNkXoIw_1793620115
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4a359b714f8so27634785e9.2
        for <linux-scsi@vger.kernel.org>; Mon, 02 Nov 2026 03:48:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793620115; x=1794224915; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ziwl8QBf1v7FFJqjlJ23GJJU3dSmhwP3y1Fomlh8GfI=;
        b=BA4AL+1tDw6p0mAIjU8bJ0wLTgoOmoEdR8ugCJZp5mJOTR/yX2qCACU6y1hH8PSXE9
         ymFqyO3bYNXxs1IWQOsf/F5oItlfOt0nZqQY2deBaFoU4MQKpTlL8/P2c5qrpt0acya2
         YYcCm4Zs4mBw5uAA0Mv78QyNfQwv8kKlkY7eUafE4EGL1961UwrqDOobGMzERPW0Gk/k
         N/KAaOnCkhrOcrjhsbB2tB51exaghtwuBuq5zBimVPqCWyt+anFtjp0BdgTozjUWVpcn
         b+ARarFiJJJp5i3M6KsMBzrbwSIbAyKW0hiNW+alp4xwJf1FX+Noswj/oDyB2CuVTAN0
         /NxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793620115; x=1794224915;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ziwl8QBf1v7FFJqjlJ23GJJU3dSmhwP3y1Fomlh8GfI=;
        b=iwFnUqNyD9lKV8vf0q7d4np+oD4HPMMwre7po/9uF9qJVn7lR18wIZ3D2Kb6ybOjlr
         L8yvH3KhmQNDA/fmb5EuifNFRUwqBQMUarjsg3G7X5A79kI0wCSqK5RIpefTe2n5gOzv
         cD30Ytatl1oeWWWSB2XywRPLvFpu82f0KsXiR+jmso3W3umuJKnvAVwT1InWk8QGc41A
         dJ3OwNMvM4IRugYNAOrG4Ew7lBpoqskyftJNvBNQnKAxmm98wRrFSnWc2UAK1feqJQx6
         5rLF4HW6OC+Dy0P3qJZBUtWHxkjjFXtVN+HAZTlLChzE6HOwaIC4gBkFyCYUAZX3olLy
         wJjg==
X-Forwarded-Encrypted: i=1; AKwUvBxxHnwrYYni/xrzcdxkVJEkgSupSz4OgV614knOTBtFSZBK8BGJAbzZlV/7PZTH/iODKUbT2WoHuWzw@vger.kernel.org
X-Gm-Message-State: AFq9FYLbkKmr/FTb07RRlF1sJfDon2l2JblE3IGihXbMbfw4sONJM/kj
	1NObpSHz/ZnIQcqtPX1x6bpiuL+cm4mi0whGhs06glQgtzqKy82/AJi9NcwEriJ6qbLku52Gcw+
	LI42mMWNnts7sa5uANl+VRRp0Ik09460+ysEiSoiYTTLP6wuxptunKf96l6tll1o=
X-Gm-Gg: AYBFou2esbG9iES+CIGi8maXpa3Sp/gjKQwftbBglI65upTN8RSvOZsBweU7/bpMuck
	1zpBgW4HY7LvFTXARfnT8KN37Brqfg36WculMEv8OKUPCxPc2GOSHrJr8Uyas4W6TfGirjFc//K
	DTop304Dj/iWz7e43NG1I3CyLYhAUusl/AcRFUMVToWk4BhM44Z3/9nV/N/tP6t6y6zHlIr9wZM
	Drx9o7phG6JldfODs2G2lCIM9v1/77iQZmP91I/QSI7pYZDogx5adK12v6VO5RUr+U1VqvTvzSX
	W2p9F3cRlbNIREFNYLtReF0JEoGacDHPchmkuCcJhtOwON4kciscvSl/9fRm+L6kvbxIQCC12Ci
	KesY+vXUynL3LzNYlOHJdQRlBs0Se4raV9JxA8OnRQA==
X-Received: by 2002:a05:600c:46d1:b0:4a1:825a:56fd with SMTP id 5b1f17b1804b1-4ac18a88fa6mr234177025e9.32.1793620114451;
        Mon, 02 Nov 2026 03:48:34 -0800 (PST)
X-Received: by 2002:a05:600c:46d1:b0:4a1:825a:56fd with SMTP id 5b1f17b1804b1-4ac18a88fa6mr234176455e9.32.1793620113987;
        Mon, 02 Nov 2026 03:48:33 -0800 (PST)
Received: from redhat.com ([2a0d:6fc0:1501:b100:9ea2:fd21:b361:8dab])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ac0a66caefsm216985365e9.5.2026.11.02.03.48.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 03:48:33 -0800 (PST)
Date: Mon, 2 Nov 2026 06:48:30 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Cc: Hannes Reinecke <hare@suse.de>, jasowangio@gmail.com, mkp@kernel.org,
	James.Bottomley@hansenpartnership.com, pbonzini@redhat.com,
	stefanha@redhat.com, eperezma@redhat.com,
	virtualization@lists.linux.dev, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, sashiko-bot@kernel.org
Subject: Re: [PATCH v2] scsi: virtio_scsi: implement eh_host_reset_handler
Message-ID: <20261102064501-mutt-send-email-mst@kernel.org>
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
> 
> Suggested-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>


This is not posted correctly:

- start a nbew thread do not reply
- against some tree which is not upstream

I papered over it


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

so move the function here?

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
> +	if (virtscsi_init(vdev, vscsi))
> +		return FAILED;
> +
> +	virtio_device_ready(vdev);
> +	return SUCCESS;
> +}
> +
>  static int virtscsi_probe(struct virtio_device *vdev)
>  {
>  	struct Scsi_Host *shost;
> -- 
> 2.43.0
> 

