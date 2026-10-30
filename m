Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793379484;
	b=05vfbE9H1422jOmEUHy+m8eJEekyZzk/HTa+tT5X0fWcqttTaGTNQcUF9XTQHTsFLNab
	 rkSZUlTYZGntF0ZSrtMliE6Sw0VgDDsbSCLFVwzgch656YhH4mDlMxmOMHDh/dGJPkyzr
	 UH+BZEE36igxSl4HYLCbMezpPQu6XSKubF6RU3xZN1aylkZAlIz3TggnGLsDOu6SGTBxv
	 k733vCY3RBaLIzi2N2BC2lzJFxK1ZwpfKRnvCG1pOETM5bRpTqYbY6tv4KQi1oP3UqjGu
	 XWo1Rkk6tg/GsLweDv/+I5GtA/bY0g/9zbl/oBVN7U92K5uIAbu4z2ofFmkKNFoR8Fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793379484;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Gs0rI+5ABWijLT/lJaJHw4+lAMveWUxz1GnPI5swUXw=;
	b=b03seTXFw/sQza78VqOgn+0dBHdgM0GsJ1WGV3UiTJXeB4Hz5RxUWXG1QhHhxfPNGSBd
	 8fWIqJt6zPOQqvZLQYstjkcMaxJNsSN0p+Afu3uIMgcJxdCsjKV5s73tQFKFJlCLTAaYz
	 BKKv8nxnhg/V1jbjPejqga2BqblnDwNs+3Kzwu68Hpa/+slnzULoHlt9EellbLAp/W4KF
	 6kuCfBGDxQD/Ia7SIQGQfPFbBy1Kh5wbOsl4FFzTVs8wWifdr59/qQ37CyswMN6gpjFNK
	 LAHezXolcLWv6i1bHBUGUCra966xPDN1vcjHW/rvUfl/RudaX09wwz0krmU3byn6bhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cmx43o7r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DEE4606A31C
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2026 16:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cmx43o7r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD111F000C1;
	Fri, 30 Oct 2026 16:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793379483;
	bh=Gs0rI+5ABWijLT/lJaJHw4+lAMveWUxz1GnPI5swUXw=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=cmx43o7r29s0XxvJXw/62AERXyZhzlr1dX5/sGfYoRQwGOFxQ+4pmTEsb9hmGCbu9
	 plOXvjgLbKnZ+DOQfVCe0Iajw53ld1A3DoAEAHdDHG/sNFBWQAK93/dsGttjF/1phW
	 onhjxmxNwuy/fMlfNApDjekejclTdtOShOkjjM8Ai/AmYLDG3oKcZsqbBjYt/GFIri
	 SgvbrfcLbnMO3cyLB4JgwkMJmMyQCux3L8Or/P0EBk07GxkkKk2Rso3Hf5aCzGcBZx
	 RMlyz6uA20U2rW8Js4A+866RkyduNBUYWqtqtx6EZNS5B9Jc05hKYbqwbEfVsSZ2It
	 2NLb9ZfrGreXQ==
Message-ID: <sashiko-outbox-191294@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/1] scsi: core: Restart a stopped queue when sysfs sets
 a device running
Reply-To: sashiko-reviews@lists.linux.dev
To: "Brian Bunker" <brian@purestorage.com>, linux-scsi@vger.kernel.org
In-Reply-To: <20261030164229.10037-2-brian@purestorage.com>
References: <20261030164229.10037-1-brian@purestorage.com>
 <20261030164229.10037-2-brian@purestorage.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 16:58:03 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: core: store_state_field() unquiesces device while transport =
is blocked
--

commit 4cd1c48b68b2c4d68b2b301b92ebce5b3fae1723
Author: Brian Bunker <brian@purestorage.com>

scsi: core: Restart a stopped queue when sysfs sets a device running

This commit calls scsi_start_queue() in store_state_field() when transition=
ing
a SCSI device to SDEV_RUNNING via sysfs so that a device offlined while its
transport had blocked the queue does not hang during the subsequent rescan.

> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index fe54792ed69e4..f5416a1548bd3 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -811,8 +811,16 @@ store_state_field(struct device *dev, struct device_=
attribute *attr,
>  		ret =3D 0;
>  	} else {
>  		ret =3D scsi_device_set_state(sdev, state);
> -		if (ret =3D=3D 0 && state =3D=3D SDEV_RUNNING)
> +		if (ret =3D=3D 0 && state =3D=3D SDEV_RUNNING) {
> +			/*
> +			 * The device may have been offlined while blocked by
> +			 * its transport, so its queue can still be stopped.
> +			 * The transport's unblock skips a running device and
> +			 * would never restart it, so restart it here.
> +			 */
> +			scsi_start_queue(sdev);
>  			rescan_dev =3D true;

[Severity: High]
Does transitioning the device to SDEV_RUNNING and calling scsi_start_queue()
while sdev->queue_stopped is set unquiesce the device while its transport or
host still actively has it blocked?

sdev->queue_stopped is set in scsi_stop_queue() when a device is blocked via
scsi_device_block() or scsi_internal_device_block_nowait(). When a transport
or host later unblocks an SDEV_OFFLINE device,
scsi_internal_device_unblock_nowait() in drivers/scsi/scsi_lib.c already
restarts the queue:

	switch (sdev->sdev_state) {
	case SDEV_BLOCK:
	case SDEV_TRANSPORT_OFFLINE:
		sdev->sdev_state =3D new_state;
		break;
	case SDEV_CREATED_BLOCK:
		if (new_state =3D=3D SDEV_TRANSPORT_OFFLINE ||
		    new_state =3D=3D SDEV_OFFLINE)
			sdev->sdev_state =3D new_state;
		else
			sdev->sdev_state =3D SDEV_CREATED;
		break;
	case SDEV_CANCEL:
	case SDEV_OFFLINE:
		break;
	default:
		return -EINVAL;
	}
	scsi_start_queue(sdev);

So if an SDEV_OFFLINE device still has sdev->queue_stopped set when
store_state_field() runs, the transport or host has not unblocked it yet.
Unquiescing the queue and moving the device to SDEV_RUNNING in that state
appears to cause several regressions:

1. Some transports and drivers rely on scsi_block_targets() or
scsi_host_block() keeping request queues quiesced for mutual exclusion rath=
er
than rejecting commands in queuecommand. For example, in
include/scsi/scsi_transport_srp.h, srp_chkready() returns 0 even when
rport->state is SRP_RPORT_BLOCKED:

	switch (rport->state) {
	case SRP_RPORT_RUNNING:
	case SRP_RPORT_BLOCKED:
	default:
		return 0;
	case SRP_RPORT_FAIL_FAST:
		return DID_TRANSPORT_FAILFAST << 16;
	case SRP_RPORT_LOST:
		return DID_NO_CONNECT << 16;
	}

While srp_reconnect_rport() in drivers/scsi/scsi_transport_srp.c blocks the
targets, srp_rport_reconnect() in drivers/infiniband/ulp/srp/ib_srp.c
recreates RDMA channels and reinitializes ch->free_tx without locking under
the guarantee that queues are stopped:

	scsi_block_targets(shost, &shost->shost_gendev);
	res =3D rport->state !=3D SRP_RPORT_LOST ? i->f->reconnect(rport) : -ENODE=
V;

Similarly, aacraid (aac_suspend(), aac_shutdown(), aac_pci_error_detected(),
and aac_reset_adapter() in drivers/scsi/aacraid/linit.c) relies on
scsi_host_block() to keep queues stopped while tearing down adapter resourc=
es.

2. If the host was blocked via scsi_host_block(), a subsequent
scsi_host_unblock() in drivers/scsi/scsi_lib.c stops iterating on the first
device where scsi_internal_device_unblock() returns an error:

	shost_for_each_device(sdev, shost) {
		ret =3D scsi_internal_device_unblock(sdev, new_state);
		if (ret) {
			scsi_device_put(sdev);
			break;
		}
	}

Because scsi_internal_device_unblock_nowait() returns -EINVAL when
sdev->sdev_state is SDEV_RUNNING, unblocking the host will abort on this
device and leave any remaining devices on the host stuck in SDEV_BLOCK with
stopped queues.

3. When transport recovery times out (such as session_recovery_timedout() in
drivers/scsi/scsi_transport_iscsi.c calling scsi_target_unblock(&session->d=
ev,
SDEV_TRANSPORT_OFFLINE)), scsi_internal_device_unblock_nowait() rejects
SDEV_RUNNING with -EINVAL, leaving the device in SDEV_RUNNING on a timed-out
session instead of transitioning it to SDEV_TRANSPORT_OFFLINE.

4. On iSCSI and FC, while the session or rport is blocked,
iscsi_session_chkready() and fc_remote_port_chkready() return
DID_IMM_RETRY << 16. Once error recovery has finished
(!scsi_host_in_recovery(cmd->device->host)), __scsi_queue_insert() in
drivers/scsi/scsi_lib.c requeues the command and kicks requeue_work
immediately:

	blk_mq_requeue_request(scsi_cmd_to_rq(cmd),
			       !scsi_host_in_recovery(cmd->device->host));

With the queue unquiesced by store_state_field(), won't the rescan I/O (and
any other queued requests) spin in a tight zero-delay requeue loop until the
transport unblocks or the command runtime expires while holding the device
lock in scsi_rescan_device()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030164229.1003=
7-1-brian@purestorage.com?part=3D1
