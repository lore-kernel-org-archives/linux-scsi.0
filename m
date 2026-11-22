Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795364080;
	b=smYt0LoPb3uhdWKDnKDK9YI4kgB5xEfS+Z1CCz7IFiVg6RO0k4zwkmH2VTeZ+p3s+QXZ
	 kp6pOcrtGrR+JHKwpA6u26fc5ws2Fx9Eq1F2U4KX9xgX8jnOHOeBzGOIjq5/cs+eo38px
	 z5+KSMj1I/yRc0Zw6qcBbubcNwEBvsoxGZC0d4SGhfLXavp5OtTnYp1qOHoK7O2ht8BuG
	 ZdPzPwoyN8/Ieydgz5iWqXRUuIyXfJ8b/VD6co6jDDpVJAsdyuc8/Uy3ntAVTBfzV1l9P
	 ECWeGWdTnSDqs4A5EbIcgXeL7y32uzvWwedaMFE5NiUv5dEVAWIG8eY6vTxcsSenzuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795364080;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=u6sDWGOByAoO4+PqC8vlMBbAF4hZGbW9o447yt4qgjM=;
	b=O3UJCQ/plUo2UK6FV+iVs6/kj229+b7vmkeOc4ovcvqgyEEmdVlLw7HrO2eh5bokICsx
	 8RvJkKKFzoLORK6tbHK6apR5tPe4KAhCxZKWskZ/m+zFnLtIRNtqNy7G4B664jVqVhge3
	 pSdCOKbTk3+Wdi/yQt3hRYcTsyZ3x/2qaa/1EvS+1m0KPP6defkHIfFGo0HKxJIhaI0/L
	 ZILI2tEm9Dc1LgOPHy2EXdGv3Nb4AgshtSyuYdf9USlTQUAtjr7ghsOeXRTVJAfF1P+pJ
	 SedtZreDAPeM9jOwodNnCduMwhLSWJpSAgzc2tcivF1vFXQVHnAhKmHsbyhts9sAy7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cvp7FcrF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8CE606A320
	for <linux-scsi@vger.kernel.org>; Sun, 22 Nov 2026 16:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cvp7FcrF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F13411F000CA;
	Sun, 22 Nov 2026 16:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795364080;
	bh=u6sDWGOByAoO4+PqC8vlMBbAF4hZGbW9o447yt4qgjM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cvp7FcrFVjPbT+0xt/4o/dS6cOUdZd081JJiJa59pBr4amTX35OpregND2xJ29H+Y
	 6B3z81uKcqhMYcUzFyOWVDvMoWswCZ68ywJTmarL+FQjIZfPCCHMQsLWcvJ7xYwa+i
	 RlDhnuy1BFfonKRFSVFlQ+n20zv/3gapTX1dkqg2fWZZ3zsREJnRsN+VQBh4B6lrsz
	 cV5y7BbGr2QAbFk8meLsb7xWPAjnWaGUtazf3KAQhOstvuAIyfknLlUU9zg0l7U1Wm
	 VhX7OcUaKHJU4WQX8Uok2z582aamByzD4SQxZofBO9y16kaSA2AsCEyNIg+HB43cup
	 Y04upM5T8F0jw==
Message-ID: <sashiko-outbox-228089@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: 53c700: fix invalid frees in m68k driver remove
 paths
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ziheng Wei" <zihengw03@163.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261122160447.519889-1-zihengw03@163.com>
References: <20261122160447.519889-1-zihengw03@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 22 Nov 2026 16:14:39 +0000
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
- [Critical] scsi: bvme6000: sysfs use-after-free and DMA leak in
  bvme6000_probe() [1]
--

commit 2fe2668801f69445d6459a951360087fb2a1f6f8
Author: Ziheng Wei <zihengw03@163.com>

scsi: 53c700: fix invalid frees in m68k driver remove paths

This commit retrieves hostdata from host->hostdata[0] instead of
shost_priv(host) in the m68k 53c700 driver remove callbacks so kfree()
frees the NCR_700_Host_Parameters allocation rather than an interior
pointer.

[ ... ]

> diff --git a/drivers/scsi/bvme6000_scsi.c b/drivers/scsi/bvme6000_scsi.c
> index 23301edf100d9..4054f788d1617 100644
> --- a/drivers/scsi/bvme6000_scsi.c
> +++ b/drivers/scsi/bvme6000_scsi.c
> @@ -93,7 +93,8 @@ static void
>  bvme6000_device_remove(struct platform_device *dev)
>  {
>  	struct Scsi_Host *host =3D platform_get_drvdata(dev);
> -	struct NCR_700_Host_Parameters *hostdata =3D shost_priv(host);
> +	struct NCR_700_Host_Parameters *hostdata =3D
> +		(struct NCR_700_Host_Parameters *)host->hostdata[0];
> =20
>  	scsi_remove_host(host);
>  	NCR_700_release(host);

[Severity: Critical]
This problem wasn't introduced by this patch, but in bvme6000_probe()
[1], does the request_irq() failure path leave host registered in
sysfs and leak the script DMA memory?

drivers/scsi/bvme6000_scsi.c:bvme6000_probe() {
    ...
	host =3D NCR_700_detect(&bvme6000_scsi_driver_template, hostdata,
			      &dev->dev);
    ...
	if (request_irq(BVME_IRQ_SCSI, NCR_700_intr, 0, "bvme6000-scsi",
			host)) {
		printk(KERN_ERR "bvme6000-scsi: request_irq failed\n");
		goto out_put_host;
	}
    ...
 out_put_host:
	scsi_host_put(host);
 out_free:
	kfree(hostdata);
 out:
	return -ENODEV;
}

NCR_700_detect() allocates DMA memory for hostdata->script and registers
host via scsi_add_host().  Jumping to out_put_host without calling
scsi_remove_host(host) and NCR_700_release(host) leaks the DMA buffer and
leaves orphaned sysfs entries that can trigger a use-after-free after
hostdata is freed.

[1] https://sashiko.dev/#/bug/linux-a5cb5983-a660-49d3-a7cf-4b23466e8a59

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261122160447.5198=
89-1-zihengw03@163.com?part=3D1
