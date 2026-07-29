Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0FAF42C4F6
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2026 16:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785343723; cv=none; b=T38nO3IUb/IBFhK6oDzpvs4TNZmgw2l4fPs8TH4psXGfw4pVPBZKNTwDDa+CbNPGrlMZ9rroJi6BiHk590Ee9HJySt4nLQkCUqUJrc5t5b9bpxVfdQX7XoYCkPbMutalDomVxUNs+7RX5Finwtl++oaJ86Ul39u5JLE7h1NIL08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785343723; c=relaxed/simple;
	bh=/J9ngDScHHyzSbdbs9+GKyRCAq9BD1eAro+JLlQa8ek=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lS6FrjrSBFnaVHZ97PJAuv/Z8YNWffdZngztuaKN0ElMaG0LV16gInNYlI83vAbDxXuOkZAjdm3qge4enOZrTEgDCCK/csVoK4Y5pMxslraEoUbImm20iqoKd2xvWxab19Y1jgZI8gXWqYOkIQs25snQlAeTBxsKxp1lb8QNEAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GakEKsUA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GakEKsUA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25B4B1F000E9;
	Wed, 29 Jul 2026 16:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785343722;
	bh=Py1wHYw/mz2WxIFAGsWWXlzRpPL7MqVm1X1JgzIx7k8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GakEKsUADiLq8QPYXHIwNk36U6wmsYIYvrxu17+sHYa/Z+tn4mQ9Zh/Q3mGvQVHot
	 TwdYn7uHE0uTnZIBfefEID0FStYYCvSa/ZxGPcy717djKb6LxBIvQ9B3Ye399SNnIf
	 IcckVPSiOUvQVZrGWOm7LgQzvULGhnjPIQ3qCWyjH3TFzQv3rReSlBPge5tmOFXULS
	 VFgGUoXnZjmp7V2/N1tkEz9eb2yorSMudtMwTu/onrhaJzr67jC7QxuU2tVRDtj5Ls
	 chujeCCDsAKBZs7l6gKFqXe866omiipOWeOxY+nTlR2zuckqnqVbOOCMA7Rn3Mj9Sn
	 m0ZAs6Cpdh6Hg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 23/27] scsi: sd: add multipath disk attr groups
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260729105107.255712-24-john.g.garry@oracle.com>
References: <20260729105107.255712-1-john.g.garry@oracle.com>
 <20260729105107.255712-24-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 29 Jul 2026 16:48:41 +0000
Message-Id: <20260729164842.25B4B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Medium] Result: Dead Code. The newly defined sysfs attribute groups for =
multipath disks are never assigned or registered, rendering the patch's fun=
ctionality completely dead.
- [Medium] Result: Latent Type Confusion. The `sd_mpath_disk_attr_group` la=
cks an `is_visible` callback, exposing it to a fatal type-confusion or NULL=
 dereference crash if mistakenly wired up to standard SCSI disks.
- [Medium] Result: Speculative Use-After-Free. Uncanceled delayed work caus=
ed by the `delayed_removal_secs` sysfs configuration risks a UAF on `mpath_=
head` teardown.
--

--- Patch [23]: [PATCH v6 23/27] scsi: sd: add multipath disk attr groups -=
--
commit 681fea1e5bfb430f8ec567b5c630bf2528c332b3
Author: John Garry <john.garry@linux.dev>

scsi: sd: add multipath disk attr groups

Set multipath disk attr groups, which includes delayed disk removal and
everything from mpath_attr_group.

> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 242a15bc2c5bb..36c745cbb2619 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -4006,6 +4006,42 @@ static int sd_format_disk_name(char *prefix, int i=
ndex, char *buf, int buflen)
>  	return 0;
>  }
> =20
> +static ssize_t sd_mpath_device_delayed_removal_store(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t count)
> +{
> +	struct mpath_head *mpath_head =3D mpath_bd_device_to_head(dev);

[Severity: Medium]
Does the teardown path in mpath_head_uninit() contain an explicit
cancel_delayed_work_sync(&mpath_head->remove_work)? If a delayed work is
scheduled via this sysfs store function, could it race with mpath_head
teardown and trigger a use-after-free if the work isn't canceled?

> +
> +	return mpath_delayed_removal_secs_store(mpath_head, buf, count);
> +}
> +
> +static ssize_t sd_mpath_device_delayed_removal_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct mpath_head *mpath_head =3D mpath_bd_device_to_head(dev);
> +
> +	return mpath_delayed_removal_secs_show(mpath_head, buf);
> +}
> +
> +static DEVICE_ATTR(delayed_removal_secs, S_IRUGO | S_IWUSR,
> +		sd_mpath_device_delayed_removal_show,
> +		sd_mpath_device_delayed_removal_store);
> +
> +static struct attribute *sd_mpath_disk_attrs[] =3D {
> +	&dev_attr_delayed_removal_secs.attr,
> +	NULL
> +};
> +
> +static const struct attribute_group sd_mpath_disk_attr_group =3D {

[Severity: Medium]
Should this group include an is_visible() callback? Without one, if this
attribute group is ever mistakenly attached to generic, non-multipath SCSI
disks, accessing the attribute would trigger mpath_bd_device_to_head() on
an invalid device pointer, potentially causing a type confusion or NULL
dereference crash.

> +	.attrs		=3D sd_mpath_disk_attrs,
> +};
> +
> +__maybe_unused
> +static const struct attribute_group *sd_mpath_disk_attr_groups[] =3D {

[Severity: Medium]
Are these attribute groups actually registered anywhere? The array is defin=
ed
as __maybe_unused, but it doesn't appear to be hooked up to any device
class (e.g., sd_mpath_disk_class.dev_groups) or passed to device_add_disk()
in this patch. Will these attributes ever be visible to userspace?

> +	&sd_mpath_disk_attr_group,
> +	&mpath_attr_group,
> +	NULL
> +};

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260729105107.2557=
12-1-john.g.garry@oracle.com?part=3D23
