Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795537680;
	b=WcxJNWB/C55GcqHAJSiQow+o6Bo6b1M6zWy3TQGuQbLt7sAN2Sj7lQ1rn+x//IX1027M
	 eeMbpHZ4J2iV2NqVkiJiTqCEfjLwPVZ7ZPwhYic9rikwV/K5sZ2MLB72IWKEJkaL3tgf9
	 CLbW1B8W5oNwJgQRUiyM+ZMcFQlRaxjyBv97eGLEvN9Y9+ZW6tN+gcWwbmcGcwQkI+kdX
	 OQ/1lQy+97Xr73+k6yq32976xSWJZ8K8zH8VW6cMZSBG2mcKAzsiuYKkDGOdqFQjNWR8r
	 OqtZKRtmzN46S8KhZwtnf8Kh6FHIfSVU97Umq8sSBh3Cn6VuQjo9Hy5nbryTvFbDjuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795537680;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=8g3+HGbDjv/9wXSX9NT8dk6rTKT1jQO4faTcZj+QBZ4=;
	b=xJU3bbY/niwSW390x9J2zgfGmT/in1ovXeMbDcx0Z0tKAgWovXbQtYIPZ9QX1C8w+Vaj
	 1cJycqIoU7tHoj+xefYTx+TuHniC5NadorM8lq+mgzr70piAJcWKGgosn6ZLflUzUaWh+
	 MV/pQ8XiCXEiEFT4kKhCwmnzVfQaFr7fQ767q9isP8434jb1QNwB7YoTJmot2mH5ZXs9+
	 GfwLwjQAhC25+GXiB9RpcIcYBcCrU/jBYfIu2e7apdKaAMQNO98iTIDHURDORw0rLMjkQ
	 RSH4pKSKK5VrWFXn8z2t5/YyuVSR3EztSO4wKebvgO0lgwNZ4NxDKwd5rOnp/KPLS1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nz1oXW7Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A8D606A321
	for <linux-scsi@vger.kernel.org>; Tue, 24 Nov 2026 16:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nz1oXW7Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B0CE1F000C4;
	Tue, 24 Nov 2026 16:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795537680;
	bh=8g3+HGbDjv/9wXSX9NT8dk6rTKT1jQO4faTcZj+QBZ4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nz1oXW7Z+8VXinzPj8c6iAaL57aRKG7zJy7c7QAkabrmHI2Vy7z8kBlldXAsAldjE
	 GIvhP2tOS9DA05JK5RXzq/0141uQzTtTYggJmQw9f66L8GfTmeLcFelz0ibsqTZPRI
	 CcYSN893kkOkLxKbsivAl71YAsV9GZNH88lo4Wk7cwCVM2RhtdEbDFDtsdF2Utow1M
	 vs7GCP1ZSXCryDk4ASF4RyfQQcCvDNOIvrt3CKWJHiBu251abJce2o2F/N6RsXn9Ew
	 iyUPhbsQ0xkI7+0GXzC8wWpbPYvrPuQ3jALcwawjWWaXCj2Cwtnf7MAB/foOCknLqT
	 Yp5eELC59uKpw==
Message-ID: <sashiko-outbox-231566@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v19 01/13] scsi: ibmvfc: fix IRQ leak and guard
 deregister on channel reg failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261124-ibmvfc-fpin-support-v19-1-2aaffe5fe7d2@linux.ibm.com>
References: <20261124-ibmvfc-fpin-support-v19-0-2aaffe5fe7d2@linux.ibm.com>
 <20261124-ibmvfc-fpin-support-v19-1-2aaffe5fe7d2@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 16:27:59 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] scsi: ibmvfc: missing Fixes trailer for commit 39e461fddff0
--

commit c52f4fb1ca94991b548f671385702800578be375
Author: Dave Marquardt <davemarq@linux.ibm.com>

> scsi: ibmvfc: fix IRQ leak and guard deregister on channel reg failure
>
> If request_irq() fails during ibmvfc_register_channel(), the error path
> disposes of the IRQ mapping via irq_dispose_mapping() but leaves scrq->irq
> populated with the stale virq number. A subsequent call to
> ibmvfc_deregister_channel() during teardown or reset cleanup then
> unconditionally invokes free_irq() and irq_dispose_mapping() on the stale
> IRQ descriptor, triggering kernel warnings.
>
> Fix this by:
> 1. Explicitly setting scrq->irq to 0 after irq_dispose_mapping() in the
>    ibmvfc_register_channel() error path.
> 2. Guarding free_irq() and irq_dispose_mapping() with a check for scrq->i=
rq
>    in ibmvfc_deregister_channel() so unmapped or unregistered queues are
>    safely skipped.
>
> Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
> Acked-by: Tyrel Datwyler <tyreld@linux.ibm.com>

[Severity: Low]
Should this include a Fixes: tag for the commit that introduced the
sub-CRQ IRQ mapping and cleanup paths?

  Fixes: 39e461fddff0 ("scsi: ibmvfc: Map/request irq and register Sub-CRQ =
interrupt handler")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124-ibmvfc-fpi=
n-support-v19-0-2aaffe5fe7d2@linux.ibm.com?part=3D1
