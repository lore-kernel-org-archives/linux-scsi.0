Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794237269;
	b=rAQ6IW2EQLrxYg8Wj/Bezox5OX5+Jq6G5fm6WAPH6pTFQy5z8hdL+cX6SmztHce+1q9M
	 n6pc3XJBSb/5L6SQjU2eeNcJ1HaNAwKz79h1PGIR0EywVOARLVBgauHChPglCv+q/us0n
	 bV2k8/HFlFmNxj7+xvSRNu15ymEx3Y0IhKgJrCi7qSIjkrS8u7OE/b6XlHhYHrE49JeQX
	 QMEfJoyMApbgoR+zE0hRZq8jLv2ib3mb9jdlOErRCGLK9sGfPl+OtHk9wxyDSpTwD8pbn
	 A+eeipI5E54vSCPKlLXcoMWZrRXAYYtKPaRovR2F5EJ2QUxKhjcUnjRHQIeqhuxLuGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794237269;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Scanned-By;
	bh=p66YjuZUERp8DvJZY4JdqHSsqpUZEslDN4DOOe6L+lA=;
	b=SSBiK0iQUcq9kjPpCuNSEWBXoMQaT75YqftrZSNqhUyO4U23PbfGuLgs9bbkDDeE4gnL
	 94QmfC9pgvUv7qLh0kIm6yM8HbBpNwHouNnnR6tFppQBJlkordwMXmmhtUCL2/jDk/Phh
	 sbMR9KGl7+nUCfNqM/76zky9qUWFl64dQkBMgtu2Y5qvyqyADA16dE+tzLSzn8uTd32kN
	 oWQ8eRSs6OXFseHkWu3ObY8x4NE3zrLyLZPXzhcXQiJjTlOjnmkVXcp7xzH9IMxcY3ues
	 zqS7nshjKcA4EqIsTO89m2TFgnGCkZr4R95Mlbt5o7YxwjUKyf8UTMCeFdCA526I8EA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=U9h54ba5;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C81606A321
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 15:14:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 22C81606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=U9h54ba5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794237267;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p66YjuZUERp8DvJZY4JdqHSsqpUZEslDN4DOOe6L+lA=;
	b=U9h54ba5kh6eMTiHWVDyfsP4JD/QBOWMm/37xE+CVtUiAqORHpL2pRhQQy2Xp/LqQh5soB
	wkLp93nnLVlX/9taZ+FUqyVM3v0xQ4NLoy4P+cnKrnM/DLbbXVoLoMaHwXkc+BwUj34N+R
	eDMHAa/7rPZN3+RMsrBTlvZcfzVSwWE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-178-rwOSsI06N2GlokMiHUUWcQ-1; Mon,
 09 Nov 2026 10:14:21 -0500
X-MC-Unique: rwOSsI06N2GlokMiHUUWcQ-1
X-Mimecast-MFC-AGG-ID: rwOSsI06N2GlokMiHUUWcQ_1794237259
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A25231955F1A;
	Mon,  9 Nov 2026 15:14:18 +0000 (UTC)
Received: from localhost (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9DE4318004FC;
	Mon,  9 Nov 2026 15:14:17 +0000 (UTC)
Date: Sat, 7 Nov 2026 08:17:14 -0500
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Mike Christie <michael.christie@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>, mst@redhat.com,
	jasowangio@gmail.com, mkp@kernel.org,
	James.Bottomley@hansenpartnership.com, pbonzini@redhat.com,
	eperezma@redhat.com, virtualization@lists.linux.dev,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	sashiko-bot@kernel.org, kwolf@redhat.com
Subject: Re: [PATCH v2] scsi: virtio_scsi: implement eh_host_reset_handler
Message-ID: <20261107131714.GA379875@shajnocz.csb>
References: <20260911164417.33860-1-ngocthang2710.1999@gmail.com>
 <28865bba-ac60-4c6e-aec8-64b1fcdb1c8f@suse.de>
 <20260914133144.15509-1-ngocthang2710.1999@gmail.com>
 <20261102200615.GC1738758@shajnocz.csb>
 <c5460180-e134-423a-b67f-a58a00106eb8@suse.de>
 <20261103135156.GB2072598@shajnocz.csb>
 <92a8e5e4-2729-476f-82e5-e73e51a010e6@oracle.com>
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
In-Reply-To: <92a8e5e4-2729-476f-82e5-e73e51a010e6@oracle.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Fri, Nov 06, 2026 at 02:12:19PM -0600, Mike Christie wrote:
> On 11/3/26 7:51 AM, Stefan Hajnoczi wrote:
> > On Tue, Nov 03, 2026 at 08:27:52AM +0100, Hannes Reinecke wrote:
> >> On 11/2/26 9:06 PM, Stefan Hajnoczi wrote:
> >>> On Mon, Sep 14, 2026 at 08:31:44PM +0700, Nguyen Ngoc Thang wrote:
> >>>> Once virtscsi_eh_timed_out() lets SCSI EH run on an unresponsive host,
> >>>> abort and device reset both fail the same way (same dead ctrl vq), and
> >>>> since virtio_scsi implements neither target nor bus reset, EH falls
> >>>> through to scsi_eh_offline_sdevs(), which frees the stuck commands' DMA
> >>>> buffers without any guarantee the device has actually stopped touching
> >>>> them. If bus mastering (or whatever broke the transport) comes back
> >>>> later, the device can still write into memory the kernel has already
> >>>> reused.
> >>>>
> >>>> Add a real eh_host_reset_handler instead. virtio_reset_device() is the
> >>>> guarantee scsi_eh_offline_sdevs() was missing: once it returns, the
> >>>> device will not touch guest memory again, so it is safe to hand
> >>>> outstanding commands' buffers back. Reuse virtscsi_remove_vqs() +
> >>>> virtscsi_init() -- the exact sequence already used across
> >>>> suspend/resume -- to tear the virtqueues down and rebuild them.
> >>>>
> >>>> Verified with a QEMU virtio-scsi repro (PCI_COMMAND_MASTER cleared
> >>>> mid-write): EH now runs abort -> device reset -> host reset -> abort ->
> >>>> device reset -> host reset -> offline, then dd's stuck fsync returns
> >>>> EIO and D-state drains to 0, in ~244s total. No task remains
> >>>> uninterruptibly blocked.
> >>> By the way, there is a known limitation in the QEMU virtio-scsi
> >>> implementation where some reset-related operations are implemented
> >>> synchronously (can block vCPUs and QEMU activity while waiting for I/O
> >>> to drain in some situations) instead of asynchronously. Recently there
> >>> has been work in QEMU to make VIRTIO device reset asynchronous, for
> >>> example, but it needs to be implemented on a per-device basis and
> >>> virtio-scsi hasn't taken advantage of it yet.
> >>>
> >>> Please let me know if you'd like to discuss or contribute. It's
> >>> something that is on my radar but not until 2027.
> >>>
> >>>> Suggested-by: Hannes Reinecke <hare@suse.de>
> >>>> Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
> >>>> ---
> >>>> v1 -> v2: implemented eh_host_reset_handler as suggested by Hannes
> >>>> Reinecke in review of the original RFC, instead of relying solely on
> >>>> the EH loop falling through to offline.
> >>>> ---
> >>>>   drivers/scsi/virtio_scsi.c | 24 ++++++++++++++++++++++++
> >>>>   1 file changed, 24 insertions(+)
> >>>>
> >>>> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> >>>> index b4f20c487718..9698f4f91cc6 100644
> >>>> --- a/drivers/scsi/virtio_scsi.c
> >>>> +++ b/drivers/scsi/virtio_scsi.c
> >>>> @@ -833,6 +833,8 @@ static enum scsi_timeout_action virtscsi_eh_timed_out(struct scsi_cmnd *scmnd)
> >>>>   	return SCSI_EH_NOT_HANDLED;
> >>>>   }
> >>>> +static int virtscsi_host_reset(struct scsi_cmnd *sc);
> >>>> +
> >>>>   static const struct scsi_host_template virtscsi_host_template = {
> >>>>   	.module = THIS_MODULE,
> >>>>   	.name = "Virtio SCSI HBA",
> >>>> @@ -846,6 +848,7 @@ static const struct scsi_host_template virtscsi_host_template = {
> >>>>   	.eh_abort_handler = virtscsi_abort,
> >>>>   	.eh_device_reset_handler = virtscsi_device_reset,
> >>>>   	.eh_timed_out = virtscsi_eh_timed_out,
> >>>> +	.eh_host_reset_handler = virtscsi_host_reset,
> >>>>   	.sdev_init = virtscsi_device_alloc,
> >>>>   	.dma_boundary = UINT_MAX,
> >>>> @@ -947,6 +950,27 @@ static int virtscsi_init(struct virtio_device *vdev,
> >>>>   	return err;
> >>>>   }
> >>>> +/*
> >>>> + * No bus/target reset in virtio-scsi, so EH lands here after device
> >>> The choice to use the VIRTIO device reset in virtscsi_host_reset() looks
> >>> good to me, but I would like clarification on this comment. virtio-scsi
> >>> does have I_T_NEXUS_RESET and I believe this is the modern equivalent to
> >>> the pre-SCSI-6 TARGET RESET. Is it really the case that virtio-scsi
> >>> doesn't have target reset? And do you want to go ahead and implement
> >>> .eh_target_reset_handler() using I_T_NEXUS_RESET?
> >>>
> >> Would probably not a bad idea to use I_T_NEXUS_RESET here.
> >> Not sure what it does internally, though; _is_ there a nexus
> >> to reset?
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
> 
> How are vhost drivers notified of the device reset? For qemu virtio-scsi
> this would call virtio_scsi_reset right?
> 
> For vhost-scsi though, do we need to add a similar reset function?

VIRTIO device reset is handled by vhost_scsi's VHOST_SCSI_CLEAR_ENDPOINT
and VHOST_SCSI_SET_ENDPOINT ioctls called from QEMU's
hw/scsi/vhost-scsi.c:vhost_scsi_set_status(). The Linux vhost_scsi code
flushes requests and resets the device, so I don't think code changes
are needed.

Stefan

