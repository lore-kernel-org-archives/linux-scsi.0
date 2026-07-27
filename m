Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3717237CD30
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jul 2026 15:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785165834; cv=none; b=WiH7a41M/w6/qfQpOl1G8JxNtM80GwZ5+rV1VwXNH4IBHN5H4FLsxu8REqaOf1t603ziA8xSbENgETW1O5W/H+NbOrOyDHU2LWPo07rJq+qShS6qHEgAXEg9E8566qpMLRCzAv5SzdnLKlF39JIQmHm6tOia1PrzzawmXaTpwsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785165834; c=relaxed/simple;
	bh=sHR0wqjdOCam7QWo913gol6XIP1r5+oBrvQ+EgiUaVU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=CEob4qZC8z2lfxesjEBeLLDQZY7Z34H3CyPM3exSlf19TtXw1AzNe79/ARNMZeaIRgIuzhET9qtzrCEhnW+GM4WfclQMvO/LO5yMaCoukzvgGB75f3pcq5gzAGmr+u0cLFKoYdPQqMPCTxTdvN9UFtVRPuGrHn6tBMAWnGCAwms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hq9TLgws; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hq9TLgws"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6216D1F000E9;
	Mon, 27 Jul 2026 15:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785165832;
	bh=7e0nEKJCYXgyQ8ix9xCn5vup7mBM9QdEGpcTSQ/P1tA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hq9TLgwsonvxzRhqpVN+TlEaQOFwP50wz+HiwBAnv6JjTN4RnWfKm6NQnYDpkiEWc
	 sHUyh7JtIvxc0Rdv7Hc2Q1EdfXskCxy27SOQ7x3YL3ZXJmaqv0JynitiVWg7g8w9VM
	 PP4T14DcJ5TYD814AlC9lm1jcjTroJf3MBFa6+Zh2UhVVUmbPih0Au19QGct5hCOU4
	 vEZkM5tha0BKqdaF5ZfVkmF5DHmzZji9BqTWnBwbBm8R8Nj2sqlv3oNYfeOyRNmhx+
	 jgpIvyAbDLexjyXbQYyIbiQWg3btMASIGoNu7TX2cJwYhkNggEsa50gh79omznhThT
	 94FN2ejfNr8Vw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 21/27] scsi-multipath: add delayed disk removal
 support
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260727144234.3802948-22-john.g.garry@oracle.com>
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
 <20260727144234.3802948-22-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 27 Jul 2026 15:23:51 +0000
Message-Id: <20260727152352.6216D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The delayed_work struct for removing the multipath head is never i=
nitialized for SCSI.
--

--- Patch [21]: [PATCH v5 21/27] scsi-multipath: add delayed disk removal s=
upport ---
commit 75d6c7bf920e841ac7f62e67cc466430605858b8
Author: John Garry <john.g.garry@oracle.com>

scsi-multipath: add delayed disk removal support

Add support in core code for delayed disk removal support. In this, the
callback calls into the scsi_driver to do the necessary removal work.

> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index eae5864ce5826..ed9c83189942a 100644
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c
[ ... ]
> @@ -360,7 +360,34 @@ static bool scsi_mpath_available_path(struct mpath_d=
evice *mpath_device)
[ ... ]
>  static struct mpath_head_template smpdt =3D {
> +	.remove_head =3D scsi_mpath_remove_head_work,

[Severity: High]
Does enabling this feature lead to an uninitialized work struct regression?

When delayed removal is triggered, it calls mod_delayed_work() on
mpath_head->remove_work. However, the initialization path for SCSI multipath
heads appears to omit INIT_DELAYED_WORK() for this work struct.

In drivers/scsi/scsi_multipath.c:scsi_mpath_alloc_head():

	if (mpath_head_init(&scsi_mpath_head->mpath_head))
		goto out_free;

mpath_head_init() zeroes the structure but does not initialize remove_work.

Could this lead to a panic in the workqueue core when operating on an
uninitialized work struct?

>  	.is_disabled =3D scsi_mpath_is_disabled,
>  	.is_optimized =3D scsi_mpath_is_optimized,
>  	.available_path =3D scsi_mpath_available_path,

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260727144234.3802=
948-1-john.g.garry@oracle.com?part=3D21
