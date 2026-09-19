Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 302F01DB95E
	for <linux-scsi@vger.kernel.org>; Sat, 19 Sep 2026 01:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789782675; cv=none; b=mByuITaCI5lFrgPn/CV6kmgnazoJapit69EWpGwpBz0FMs13JXzXLRtsg6FL+dohYPzSaESbU+fLcjv/EWW+DrtghhvlwqBxfGv5NKH/2Wwh42wpgddkbOOEVFFteGUiYTjO4TfwyklQe1/ry+hsQrfP8jeSTUoFwGDdpEdZNnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789782675; c=relaxed/simple;
	bh=zGHqxXGgbvhORZ6vuqVDW1pgzODUbZC4kKJ+I+BzYdY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=iq+e0XNBee5P1py0TjdlSYhW4JQ0exDwTCXlMaDnwpA5si+lKh1Uuk3l8Bv2zeVLFXmMEyEtzHcp7ZNkKvw7sOvxeJ2Ehtd8/D5Oq+nORlUe/P44W5nuszQpWdWHPadS9qMA6iaUC/FkBjG27qJ4D97+yKxLJ01dcgmueL+a1N8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZRfB0XU1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZRfB0XU1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92B691F000FF;
	Sat, 19 Sep 2026 01:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789782673;
	bh=oexh3bBqhT+JCEVRZs90lJD7TH0H4p5W60ARJB3qXMI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZRfB0XU1le0rMyMCtdx+45I/nG+77Kmc/ollfOEA+xKTfqvLFBm2TwKIImg+Y53ck
	 n38nrbcuc3ctyhrlHI36VdliySW4pZbisi+syhA7PA/nfgY8TAUUgqaVLtSVY7oZu8
	 OPgcvY/Xt8t4x5LiDtJENjkoj/Qj0GGx7tIYETiWXzR3jZZq9rbMxw8YfmwPyLe81x
	 daD4JMHEl8EIN3AYgz7++0U+dfacOB7dxWMUnHnK024ecbWBxC/nFN0uN70gOtaVnF
	 jLudnoUCzTsySJsQHcPcZrTVn1UIJdxDsDl4yT9rMT/6lPKljyAruD3Shtr55NkDeX
	 0A5lO3zsN1m2g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 01/20] scsi: ibmvfc: initialize evt->tgt for NVMe FCP
 commands
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260919013306.2948028-2-tyreld@linux.ibm.com>
References: <20260919013306.2948028-1-tyreld@linux.ibm.com>
 <20260919013306.2948028-2-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 19 Sep 2026 01:51:13 +0000
Message-Id: <20260919015113.92B691F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: ibmvfc: data race on fcp_req->private assignment can cause s=
tale pointer dereference
--

commit 76065f9b570dd8183dec90d4771dd155a1cacca2
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

scsi: ibmvfc: initialize evt->tgt for NVMe FCP commands

ibmvfc_nvme_fcp_io() submits NVMe FCP requests without setting evt->tgt
on the allocated event. ibmvfc_init_event() does not initialize this
field, so it retains whatever value was left in the pool-allocated event
structure. Fix this by assigning evt->tgt =3D rport->private.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c b/drivers/scsi/ibmvscsi/=
ibmvfc-nvme.c
> index 9ac2671a3567d..9ed6522c2e9e3 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
> @@ -359,6 +359,7 @@ static int ibmvfc_nvme_fcp_io(struct nvme_fc_local_po=
rt *lport,
>  	ibmvfc_dbg(vhost, "vfc-nvme-mq-%d\n", evt->hwq);
> =20
>  	ibmvfc_init_event(evt, ibmvfc_nvme_done, IBMVFC_CMD_FORMAT);
> +	evt->tgt =3D rport->private;
>  	evt->fcp_req =3D fcp_req;
>  	fcp_req->private =3D evt;

[Severity: High]
Can a concurrent timeout read an uninitialized or stale tgt pointer here?

The assignment fcp_req->private =3D evt is performed locklessly and without
memory barriers. On weakly ordered architectures like POWER, this allows the
new evt pointer to be visible to other CPUs before the initialization
evt->tgt =3D rport->private is committed to memory.

The block layer starts the timeout timer before invoking the driver's
.queue_rq callback, meaning the timer can fire concurrently with submission.
If a timeout occurs, the concurrent ibmvfc_nvme_fcp_abort() handler reads
abort_req->private locklessly and accesses abt_evt->tgt to build the TMF
payload.

Observing an uninitialized or stale tgt pointer could result in a NULL
pointer dereference or use-after-free.

Would it be better to use smp_store_release() for fcp_req->private =3D evt
and smp_load_acquire() in the abort path to ensure the handler sees the ful=
ly
initialized event object?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260919013306.2948=
028-1-tyreld@linux.ibm.com?part=3D1
