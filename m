Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58D63EB102;
	Mon,  7 Sep 2026 03:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788750378; cv=none; b=SNhe16bXSJ7Cji2GHpvivBVEQH6mBo4jwoaJkT/JWQpko1qhtApQzkq5+tZx7c8zlYjB7++fPgz+BY90FmJzyTcqg6uRSSRefqFLZckjderUJMkNUI6PpFoJ06o6F0bLxUoI6rBiXG97dvuuv6d0WI56WJw44PDeFqGGxZA6mis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788750378; c=relaxed/simple;
	bh=RH0S24QzMuhW/hyX16thrm/nTEdZ2Q9n4qgiFfm562Q=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WppfY1vkLqcHz0qhs1np2CzdKvxoLSrYBz6BBHcVEddcaEC7wbE16Aykw+mubpXkd2cgXrHq5EIZ3pZHwanti08/4c09xKdE8IQR5pxbz9KavKsZmziBIFbdQaSjHWoXZ4fd/fr0RbydC6qNJAH5vZfu6+IVF2NHvcI2IfXzenk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WGRA8N8c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WGRA8N8c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CD861F00A3A;
	Mon,  7 Sep 2026 03:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788750374;
	bh=qJvGj9sB96pReyFJjIDQklrShNDVaNVqN1+o+K/v5VE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WGRA8N8cKecSBm+XxVhiVQ7caSf5TpnDFbU2TGv6HoM/7XCrN4NQQ45xr4xJXBajC
	 HqtRtmadz+dJ/woyOEkIdb30lLK8rFJCumwcukLDTaewMOi6hZffYJo4WEvnw3RtuH
	 /P5HTMTuUeyyAYNC3oHLLy+9oIyRn75KI9JUpW18LCAn8XRVKmWi2aeEOPBSausojP
	 Vla0MJvqMOrMR8w07SARr/guWMOqG78JzepSh25mj1Gxw/xTMvt30uVsp3JbNM8TEx
	 iz0ijvLo2eGLv4RDAdZzBPyWci0F3K4sWn0xxDnGRlr031VfCiD9xmSApbwwewuRfN
	 VTeuNW81oOshA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 33/40] scsi: storvsc: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-ide@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-s390@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, cassel@kernel.org, linux-scsi@vger.kernel.org, dlemoal@kernel.org
In-Reply-To: <20260907024343.1046387-34-dlemoal@kernel.org>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-34-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 03:06:13 +0000
Message-Id: <20260907030614.4CD861F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Use-After-Free of a destroyed workqueue in storvsc_remove().
--

commit 78aa8a5b1c990af91c1c28201470aeedf9180e53
Author: Damien Le Moal <dlemoal@kernel.org>
Subject: scsi: storvsc: use 16-bits defined sense codes

This commit refactors the storvsc driver to use the 16-bit sense_code field
of struct scsi_sense_hdr and replaces hard-coded additional sense codes
with enum values. No functional change is intended.

> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index ef3cd3bc7390e..625db97d1a03e 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
[ ... ]
> @@ -1049,8 +1049,12 @@ static void storvsc_handle_error(struct vmscsi_req=
uest *vm_srb,
>  			 * want scsi_report_sense() to output a message
>  			 * that a sysadmin wouldn't know what to do with.
>  			 */
> -			if ((asc =3D=3D 0x3f) && (ascq !=3D 0x03) &&
> -					(ascq !=3D 0x0e)) {
> +			if (scsi_sense_asc(sshdr) =3D=3D
> +			    ASC_TARGET_OPERATING_CONDITIONS_HAVE_CHANGED &&
> +			    sshdr->sense_code !=3D
> +			    INQUIRY_DATA_HAS_CHANGED &&
> +			    sshdr->sense_code !=3D
> +			    REPORTED_LUNS_DATA_HAS_CHANGED) {
>  				process_err_fn =3D storvsc_device_scan;
>  				set_host_byte(scmnd, DID_REQUEUE);
>  				goto do_work;

[Severity: High]
This is a pre-existing issue, but does this error handling path have a
use-after-free vulnerability during device teardown?

If the Hyper-V host sends a device removal request, storvsc_remove()
is called which destroys the workqueue before waiting for outstanding I/O
requests to drain:

storvsc_remove() {
    ...
    destroy_workqueue(host_dev->handle_error_wq);
    scsi_remove_host(host);
    storvsc_dev_remove(dev);
}

If the host then sends an I/O error completion (like a data overrun)
for an outstanding request while the host is being removed,
storvsc_command_completion() handles it by calling storvsc_handle_error().

When storvsc_handle_error() takes the goto do_work path shown above, it
will eventually call queue_work() using the already destroyed workqueue
pointer:

do_work:
    ...
    queue_work(host_dev->handle_error_wq, &wrk->work);

Can this sequence cause a use-after-free when queue_work accesses the freed
memory, and is this reachable by an untrusted Hyper-V host?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907024343.1046=
387-1-dlemoal@kernel.org?part=3D33
