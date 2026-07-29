Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC7DD4BCABE
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2026 14:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785335003; cv=none; b=AQKPMbJ4bSQ7ulvaXrhNLIty/97X06/imz5/2eBmY3g/58e6YqDbDcvUjup0aFW1YNb40vxqNmY0fViPPiyz0WySauXWv82vESLgQrDoI0FhwSi4xioYVQEflQqM0GVr2q9quOep1ATW6poe+iaBIqY7JUrLeluhCuyyEF4frkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785335003; c=relaxed/simple;
	bh=3OcVp1ufcZsdB7utIMm4B6sI+zYQDwlXQ0+3kL4AIm4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cGolJeDzwJXMCF5urXsPSkWJBV3r97EzEiAM+xkWUozn03/nL3JvVGFpUwl4lfkaCgewb6lFk+DRgqmA757Bq6PtNCdt4IlFBbVSYBTXJqCFmazFMCrsZv5sAfjRTQAZOmcyAsSVLKxl/+YIoKFBmvMvPFlmVvli9U+lGjET0Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kiuOyjme; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kiuOyjme"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ADAB1F000E9;
	Wed, 29 Jul 2026 14:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785335001;
	bh=MTmFxyOkI2sXmHhrqPZxomAQQH3vGmy1SQfBsgk7KMk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kiuOyjmeW/6p1LYlTuYrg3bVVtW635e/r7Lg9JbGrjEZZqmKZvp53gbY97+NbWQA8
	 gqsjo+46MfP1zxxBpbL+8UpU9zYa3ejezrxVBLCOT4+zF0W7yqCOZ9++bV4JKgNS8+
	 vJAuKM4wuP/FlbU72kBoAR8UEwFuzJR1HfiFL/ZU40Pjy7dSW8eB9XfawOVbBLOU3E
	 mW4Gb7zKHsJA3/tmt9FwoanzgLjTCAFhbHKJHE2j30TwbJuPpvbXzNsHXbVcjNhZ0Q
	 T81srqIPwcXklbuM0HFj12OmcqOwpZINrQ32uWRu07CtyAxnGXxCWVYtIh9LMTg6jA
	 4LxeBEM6D++bg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 15/27] scsi-multipath: clone each bio
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260729105107.255712-16-john.g.garry@oracle.com>
References: <20260729105107.255712-1-john.g.garry@oracle.com>
 <20260729105107.255712-16-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 29 Jul 2026 14:23:20 +0000
Message-Id: <20260729142321.5ADAB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] The `smpdt` structure fails to implement mandatory `mpath_head_tem=
plate` callbacks, leading to a NULL pointer dereference.
- [High] The clone completion callback entirely lacks the failover resubmis=
sion logic claimed in the commit message, breaking failover handling.
- [High] The `bio_pool` mempool is destroyed before waiting for active user=
s to drain, leading to a use-after-free when in-flight cloned bios complete.
--

--- Patch [15]: [PATCH v6 15/27] scsi-multipath: clone each bio ---
commit ea53159f3e5b8959582afd4b035267bb7a201a6d
Author: John Garry <john.garry@linux.dev>

scsi-multipath: clone each bio

For failover handling, we will take the approach to resubmit each
bio.

However, unlike NVMe, for SCSI there is no guarantee that any bio submitted
is either all or none completed.

As such, for SCSI, for failover handling we will take the approach to
just re-submit the original bio. For this, clone and submit each bio.

> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index 593f94aac70e9..0d439cac6447a 100644
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c
> @@ -99,6 +99,7 @@ static void scsi_mpath_head_release(struct device *dev)
>  		container_of(dev, struct scsi_mpath_head, dev);
>  	struct mpath_head *mpath_head =3D &scsi_mpath_head->mpath_head;
> =20
> +	bioset_exit(&scsi_mpath_head->bio_pool);
>  	ida_free(&scsi_multipath_dev_ida, scsi_mpath_head->index);
>  	ida_destroy(&scsi_mpath_head->ida);
>  	mpath_head_uninit(mpath_head);

[Severity: High]
Does this code destroy the mempool before all users have drained?

When the last SCSI path is removed, scsi_mpath_head_release() calls
bioset_exit() immediately. It then calls mpath_head_uninit(), which
synchronously waits for all users to release their references.

If there are in-flight cloned bios completing, or if the block device is
still open and receives new I/O while waiting, they could access the
already-freed bio_pool via bio_put() or bio_alloc_clone().

Can this result in a use-after-free on the destroyed mempool?

[ ... ]

> @@ -237,7 +238,34 @@ static int scsi_multipath_sdev_init(struct scsi_devi=
ce *sdev)
>  	return 0;
>  }
> =20
> +static void scsi_mpath_clone_end_io(struct bio *clone)
> +{
> +	struct bio *master_bio =3D clone->bi_private;
> +
> +	master_bio->bi_status =3D clone->bi_status;
> +	bio_put(clone);
> +	bio_endio(master_bio);
> +}

[Severity: High]
Does this callback omit the failover resubmission logic mentioned in the
commit message?

When an underlying SCSI path fails an I/O, this function unconditionally
copies the error to master_bio and calls bio_endio().

Since the commit message states the approach is to re-submit the original
bio for failover handling, shouldn't there be code here to intercept the
error and requeue it, rather than immediately returning the error to the
issuer?

[ ... ]

>  static struct mpath_head_template smpdt =3D {
> +	.clone_bio =3D scsi_mpath_clone_bio,
>  };

[Severity: High]
Is this struct missing mandatory mpath_head_template callbacks?

Any I/O submission to the multipath block device invokes mpath_find_path(),
which unconditionally calls mpath_head->mpdt->is_disabled(mpath_device).

Because smpdt only initializes .clone_bio, functions like is_disabled,
is_optimized, and available_path will be NULL.

Will this cause an immediate kernel panic due to a NULL pointer dereference
when an I/O is issued?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260729105107.2557=
12-1-john.g.garry@oracle.com?part=3D15
