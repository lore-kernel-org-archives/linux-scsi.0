Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2EDF1A4F3C
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2026 01:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782179382; cv=none; b=I2RqHInX4gvjBKoDAD1yjnbRAJ7SqZTt+1LIAjz2WdnI30KLy11xtFT5mS8mD6Z20+V3+vtNQFG1Y3kTFh0IaWV8hSVtkZHP0eFo+TUko+e8r5M+7qAtb/9wzNhRX2ku0hLPyeOv+fKju5tidENppbjIqAtr6ak0GUeL/2qJBUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782179382; c=relaxed/simple;
	bh=cBQA8InB8SoS3J8pVTSu4kN91teYjRKhwtkQm3jKX4g=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=KYObMTjPvFGF4X9dR2Ie+Y8p99qESISzVcGjBxPgAsmoKwRrGdfs7R02Be/LG81Ri85DYENZmHnV3gjlyCupV1JtUtPVazwBrenvVMVjCKK75O7No4TH21uL73lBu/ngyLjsCdqcnsk6GOtzAluR3AGt7HaJNJXes2gN+EEzBO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y+w186UF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y+w186UF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64A231F000E9;
	Tue, 23 Jun 2026 01:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782179381;
	bh=AkMspGrpPnVYlxkUxkbd5bTJu/T2ESCnyPv4sUIl2FU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Y+w186UFMoG20lMZ7esbPdNqlu1Yu6r/rN7OIJxRUr/Rzqo9kFChEoa5NFkT18l5N
	 z1n19NeQFcYOQfwd5mRlbT5ps7Y3dMfOcOHB2zB39UDozjmo1ROmQEC5QCF6l3O82q
	 OPbnTzl+z2U9l4zNGUS6Wpv2DYIMbOp0KiECesht7kLCSfTvu2rGZcLzYBBUyYwF08
	 xHsZl63iWqltts4v7YC+z+sz5t61eX20pnI2p9Sk3pRIdcosnKx0fSe5oV0IeDaAde
	 xvtAG5ECNl6z92YFGOWkCBT7bUOLZLku1WmAb5dEs2YxoBnIKfUmWpf4YOp7TEX9BJ
	 vSa4syJfhcNKQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 01/29] ibmvfc: move target list from host to protocol
 specific channel groups
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260623013035.3436640-2-tyreld@linux.ibm.com>
References: <20260623013035.3436640-1-tyreld@linux.ibm.com>
 <20260623013035.3436640-2-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 01:49:40 +0000
Message-Id: <20260623014941.64A231F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The driver schedules a background work item (`vhost->rport_add_wor=
k_q`) but never explicitly flushes or cancels it during host removal or mod=
ule unloading, leading to a leaked work struct and a potential use-after-fr=
ee.
--

commit 455b96a57ea40cd18201b8e8603264b5cfb84e0c
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

ibmvfc: move target list from host to protocol specific channel groups

Prepare the driver for protocol-specific target management by moving
the target list and target count out of struct ibmvfc_host and into
struct ibmvfc_channels.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvf=
c.c
> index 3dd2adda195ee..9129014364423 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
[ ... ]
> @@ -6276,7 +6276,7 @@ static void ibmvfc_rport_add_thread(struct work_str=
uct *work)
>  		if (vhost->state !=3D IBMVFC_ACTIVE)
>  			break;
> =20
> -		list_for_each_entry(tgt, &vhost->targets, queue) {
> +		list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue) {

[Severity: High]
This isn't a bug introduced by this patch, but does the driver leak the
rport_add_work_q on module removal?

In ibmvfc_remove(), the vhost structure is freed via scsi_host_put() after
teardown:

drivers/scsi/ibmvscsi/ibmvfc.c:ibmvfc_remove() {
    ...
	kthread_stop(vhost->work_thread);
	fc_remove_host(vhost->host);
	scsi_remove_host(vhost->host);
    ...
	scsi_host_put(vhost->host);
}

However, the teardown sequence never explicitly flushes or cancels
vhost->rport_add_work_q.

If the work thread is actively running or pending on the system workqueue:

drivers/scsi/ibmvscsi/ibmvfc.c:ibmvfc_rport_add_thread() {
	struct ibmvfc_host *vhost =3D container_of(work, struct ibmvfc_host,
						 rport_add_work_q);
	...
	spin_lock_irqsave(vhost->host->host_lock, flags);
    ...
}

Could it execute after the vhost is deallocated, leading to a use-after-free
when accessing the lock or other memory?

>  			if (tgt->add_rport) {
>  				did_work =3D 1;
>  				tgt->add_rport =3D 0;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623013035.3436=
640-1-tyreld@linux.ibm.com?part=3D1
