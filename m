Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795543910;
	b=uCHpm4LAukPEGbWaMpp5NBhlFA677xb6pWsZunSRT3jyNKH7Yh7G0pKS8wjbMbQD6A4V
	 0ow8/xs6O0W4nOuHKwRU8RWNifTQ95AEZ0ma4X1nmxDlezCDlcWn0cqVBju0+mm3nJzsD
	 tO9/Y/izfNs62p3rcs6HSzVoPXcpHljAKG79yfOaKHcyReE0MKFdwPjJxkbKQ1Gg/GfeI
	 H/m13X5H9+4yzQWq3/hqCcGbML0YFLItbDKZ1qEXuI8ZZT9bO0Lypsa4LswIYdbNL9Uij
	 UwDRHe/P4s27jrKuw0oVVZfqZOE3uvvShuh2CWw1bnjKowifokiQXTDKvYruMl+Rb/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795543910;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=GrbSqv2qOnqGJuOQBi37+hLXNwT57TNPO7n3moJfXOY=;
	b=ZnXuwoE1m+PnsZneF5EtAgvEydbqlO3NSAGBRpX4+DpXzfltsUHsDQ/IDcpvrQpnbXqP
	 4I0AKxq0MngNYc2rbuVXUdBRvfTLe9q1MQGp/LQmixUWMiC3dNrcwfXl171rr9br9HtBZ
	 FWEM3SnoAFIoW8eHLc7+FtXsPMwbcHiz7Z3S7mIPQXS4Rtah7W/Wd0h/U09f3iuvwncDD
	 xxuF3agh+v2twKU0i136rDpJzAxZLPI8+pArPVI4C20xT1CeQotMlNY5yoYAvvckteS9O
	 2P4YoMwVovuf1rLWYFVGbUW5y48FOVbCIhYvfgk+xZahYwOo0zCo7ITiMTImi5UNLDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="W/+gyGE5";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7B9606A323
	for <linux-scsi@vger.kernel.org>; Tue, 24 Nov 2026 18:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W/+gyGE5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE4891F000E0;
	Tue, 24 Nov 2026 18:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795543909;
	bh=GrbSqv2qOnqGJuOQBi37+hLXNwT57TNPO7n3moJfXOY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=W/+gyGE5+WhfFkGMnRuxcskg7LhemlIhNMAnpQq3KoXbUQN6yLVzn55l2/9k0scaq
	 xH4ZXn3aXN76kMWs03L8SDhRtYLnyYZeg+3XlemcVklaObwf/K/1iDsu40opuQOwu/
	 o+faEDeXTeEpV6buAiScPMHtXxWTm4jcStmL+6ik7ki632J7BKFGX0P6f/Nf84h95U
	 8+1gMzcjLSv5xQ/LCbzZKT9lG/ytIojBu/ALcjNLDEb/C5P99CbtK+jiRrVtkXIX7D
	 SYgHsVvb6UM6+NeCwSLb/0P2XKA17f5RAMs0IaMfqiByk+qTeLEh2QjKaW4vCF55Wk
	 cC24J0Y05Kvcw==
Message-ID: <sashiko-outbox-231801@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: snic: Disable the devcmd2 WQ before freeing its
 results ring
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yuho Choi" <oss.patchbox@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261124180234.400564-2-oss.patchbox@gmail.com>
References: <20261124180234.400564-2-oss.patchbox@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 18:11:49 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [Critical] enic: DMA use-after-free in vnic_dev_deinit_devcmd2() [1]
--

commit 69fa45723f24d1ae5b1a578c30346f49638a7cfb
Author: Yuho Choi <oss.patchbox@gmail.com>

scsi: snic: Disable the devcmd2 WQ before freeing its results ring

This commit reorders vnic_dev_deinit_devcmd2() to disable the devcmd2 work
queue before freeing the devcmd2 results descriptor ring.

> diff --git a/drivers/scsi/snic/vnic_dev.c b/drivers/scsi/snic/vnic_dev.c
> index 22303f8275836..44a2cc59821c8 100644
> --- a/drivers/scsi/snic/vnic_dev.c
> +++ b/drivers/scsi/snic/vnic_dev.c
> @@ -421,8 +421,8 @@ static void vnic_dev_deinit_devcmd2(struct vnic_dev *=
vdev)
>  	vdev->devcmd2 =3D NULL;
>  	vdev->devcmd_rtn =3D NULL;
> =20
> -	svnic_dev_free_desc_ring(vdev, &dc2c->results_ring);
>  	svnic_wq_disable(&dc2c->wq);
> +	svnic_dev_free_desc_ring(vdev, &dc2c->results_ring);
>  	svnic_wq_free(&dc2c->wq);
>  	kfree(dc2c);
>  }

[Severity: Critical]
This problem wasn't introduced by this patch, but can the adapter still
perform DMA to freed memory [1] when svnic_wq_disable() times out, or
along the svnic_dev_init_devcmd2() error path and the matching devcmd2
teardown code in enic and fnic?

svnic_wq_disable() returns -ETIMEDOUT if the hardware does not acknowledge
stopping the queue, yet vnic_dev_deinit_devcmd2() ignores its return value
and unconditionally frees both dc2c->results_ring and dc2c->wq.ring while
the queue remains active.

In the same file, svnic_dev_init_devcmd2() also frees dc2c->results_ring
before calling svnic_wq_disable():

drivers/scsi/snic/vnic_dev.c:svnic_dev_init_devcmd2() {
    ...
err_free_desc_ring:
	svnic_dev_free_desc_ring(vdev, &dc2c->results_ring);

err_free_wq:
	svnic_wq_disable(&dc2c->wq);
	svnic_wq_free(&dc2c->wq);
    ...
}

The identical devcmd2 init and deinit paths in
drivers/net/ethernet/cisco/enic/vnic_dev.c and
drivers/scsi/fnic/vnic_dev.c likewise free results_ring before calling
vnic_wq_disable() and ignore the disable return value before freeing the WQ
descriptor ring.

[1] https://sashiko.dev/#/bug/linux-20f156a6-d2c2-49bc-b1ee-432c3af0d669

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124180234.4005=
64-2-oss.patchbox@gmail.com?part=3D1
