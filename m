Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794621227;
	b=jJ+CraDqmcxtC5T7imKtGBg7uSSNvV6SfYpVUSWyMQpQyUs6S92sZyKBz8NbXpBTBXHH
	 8lq6gir0olIJ1lVrvzrF2JwCKxMrCwoH4tfz8dLVHab+Yde64xKpTPIx6dbdmbiso1047
	 +ylXICJuV632/dWESrvUiLufVeSpj/YSXrbdGG3tJ2tfRecTT+7R68l9KzdPhdRjjkd+C
	 ORboMUsTMV2tBo/NZmiYcht3+dRCC3sblcdJJrtHrdk4SzmU+b/EC1juuRHKJKl7O/RLb
	 IY+JDkSPDhzN6TfF6Sql+fjHN0f07fIk+Jl59lszlnOYjubcSRJuKWOYRTsQiIlOIYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794621227;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ujMbuC+ryE3QkLS/Znl/BFnzKczK1w5j83UWyXwLoYg=;
	b=ar1tpt0vO5lu2CQnxVsv5XV6sPgv3nPoS6oPeDvrARbpbYXiFBpBmJzTMG9cGtRB6bI9
	 tVdKtoRFApCdDPX3w5IH8efhFNHm8n/fhbAy6NML0GzIO3OiSW/9c2hkk+/r7W1wn7J/P
	 htOspV0UCjuevAkJm9CTXnrF0ae8d6SrLyRmGXARfKcGEDHP6SJOCSi4A8WjWD+3Pj926
	 e1jBu/bsUijbDj+LGF2ouCDfYMRqW5FiCN5Wyr2ANqRMZOVT9jJNbouXmnBreyOVpsylR
	 b8bWnLyMRvnM6D0jPDp+G5jY3JAn9pOQIiECpg5M7t+++IcBIDTP/Imo0oEVTLxFVzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ebg256y6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F486606A335
	for <linux-scsi@vger.kernel.org>; Sat, 14 Nov 2026 01:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ebg256y6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8CB61F000C4;
	Sat, 14 Nov 2026 01:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794621226;
	bh=ujMbuC+ryE3QkLS/Znl/BFnzKczK1w5j83UWyXwLoYg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ebg256y61fIs3Rh6rifudodM071zVdEcORWdMNWmH/ugggRpv4RC636RrdO9/LtdX
	 9ThQ0dYJ1Qc1NsEvxkiY8Bslb4h/7btDRnsAaKSXjyyjeX44aT7/zM4OSjOvUoCjJE
	 1YeA4ggHNOizSREaSqFp41ekKdAwKFlpkX20LyDRxm5cqa31pe/J9NXux3sqmlM8+4
	 TCR7JfJ7oYmNAr58I7bXkI9LdpB9SsPtWQutmBk3Ne5/Dd5e302BjO6lBxnR3Yx0Bt
	 Vb26DgOEHofqSVKy8YihsIhBHAlZEM+uszqnLyfG0dz7Lqj20Di+GBneSEP0f6s/pW
	 X4HHgj2Alq3SA==
Message-ID: <sashiko-outbox-214016@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] scsi: mvumi: stop the controller bus-mastering
 before freeing its buffers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261114014430.489668-2-yhlee@isslab.korea.ac.kr>
References: <20261114014430.489668-1-yhlee@isslab.korea.ac.kr>
 <20261114014430.489668-2-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 01:53:46 +0000
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
- [Critical] scsi: mvumi: use-after-free in mvumi_scan_events() [1]
--

commit 6112f67dbb3f3b038c8e964976da10c7659388c5
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: mvumi: stop the controller bus-mastering before freeing its buffers

This commit moves pci_disable_device() ahead of mvumi_release_fw() and
scsi_host_put() in mvumi_detach_one() so bus-mastering is disabled before
freeing the controller's buffers.

> diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
> index 91c2db697c691..8d22d370d8608 100644
> --- a/drivers/scsi/mvumi.c
> +++ b/drivers/scsi/mvumi.c
> @@ -2548,9 +2548,9 @@ static void mvumi_detach_one(struct pci_dev *pdev)
> =20
>  	mhba->instancet->disable_intr(mhba);
>  	free_irq(mhba->pdev->irq, mhba);
> +	pci_disable_device(pdev);
>  	mvumi_release_fw(mhba);
>  	scsi_host_put(host);
> -	pci_disable_device(pdev);

[Severity: Critical]
This problem wasn't introduced by this patch, but can mvumi_scan_events()
race with mvumi_detach_one() [1] and cause a use-after-free on mhba?

When an interrupt fires, mvumi_launch_events() allocates an mvumi_events
work item and schedules mvumi_scan_events() on the system workqueue.
mvumi_detach_one() frees the IRQ and drops the last reference to host
(which contains mhba) via scsi_host_put() without flushing or cancelling
pending event work items:

CPU0                              CPU1 (kworker)
mvumi_detach_one()
  free_irq(mhba->pdev->irq, mhba)
  mvumi_release_fw(mhba)
  scsi_host_put(host)
                                  mvumi_scan_events()
                                    mvumi_get_event(mu_ev->mhba, ...)
                                      <-- use-after-free

Flushing the scheduled event work after free_irq() and before tearing
down mhba and calling scsi_host_put() would avoid this.

[1] https://sashiko.dev/#/bug/linux-dec460b7-008c-478a-8da9-a7f1503e9e30

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261114014430.4896=
68-1-yhlee@isslab.korea.ac.kr?part=3D1
