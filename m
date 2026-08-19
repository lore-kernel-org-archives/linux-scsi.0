Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD853A7590
	for <linux-scsi@vger.kernel.org>; Wed, 19 Aug 2026 22:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787177435; cv=none; b=YVs+y4N+ZcHlhRV8agpC6SfmjxqZefw7vf28YEopy7pZGNhZ1t9+976PMQp0fCk+dwJI6WANa6Aarc1mhtV1VEtUzu/PWcOZ6fexTV1U1Xkv4jHRy1GEmowlqBTx9JDwaDMtGN6mRaGTB94HQQVpfGMkdz5HEb9oFMEgFIwQhLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787177435; c=relaxed/simple;
	bh=HxXAJeMpXpZec0+7aC6XONZ+0HSFxNE1TAni9kBu2CA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uyyirRqjK2pcDlnqQFVjUOv5w4XRCvtzdHpGTwS2fQQlbN5xUDoCzEJ7NIwNfYHMmtm6FPb/lC6IxaA2PTr6vHUNOW5kuxxGHVE4sjbFdMvc1aeSottEn92NQPAzvWGI9LBgZzmKuAxxnB6OqKdb3/Abu+0AIT1EwRtgOFlpNVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UAI0f20m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UAI0f20m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEF5C1F000E9;
	Wed, 19 Aug 2026 22:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787177434;
	bh=zV6BfKyaQDpxYMU2FDm3oXecLWRxBgaqNZ+bDmYitgc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UAI0f20mPgTLwCvIs9UxwaHE0zIVPRw/IfrTe0wEqs0sJw7I/I/I601ZmL62KvzNv
	 sxHVPi3IqJTwAuXqAdtQ9abYzFf9pVrzRsdytuSMokd9IVzH5qCM9+ZMGsLUsBabdl
	 k40n9L6Gfd4gl+epcB1AEgMuLVc4zkZXfpH+ENNhMe9TczpOoRqsfbA7atSTW3kKe0
	 lq07LcYfr0saR1e5EFTTlyNkv8E7b3RyPzc/zLFnv07vdhb9VagAvXJ/yHPWV6++Vu
	 r6bZuypnzHv5i2sR6kjTNHTxbPLbBZP9WGZFHSyz4Z+inxbiq3+htdWBn5TspKXvfZ
	 XDNeofn0OitDA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: csiostor: fix inverted sscanf() check in
 csio_store_dbg_level
Reply-To: sashiko-reviews@lists.linux.dev
To: "Rodrigo Gobbi" <rodrigo.gobbi.7@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260819220318.176167-1-rodrigo.gobbi.7@gmail.com>
References: <20260819220318.176167-1-rodrigo.gobbi.7@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 19 Aug 2026 22:10:33 +0000
Message-Id: <20260819221033.EEF5C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Medium] The sysfs store function `csio_store_dbg_level` returns 0 on suc=
cess instead of the number of bytes consumed (`count`), which will cause us=
er-space writers to enter an infinite loop.
--

--- Patch [1]: [PATCH] scsi: csiostor: fix inverted sscanf() check in csio_=
store_dbg_level ---
commit e7ce8f094df22bd78f194c7117aa937439236e6d
Author: Rodrigo Gobbi <rodrigo.gobbi.7@gmail.com>

scsi: csiostor: fix inverted sscanf() check in csio_store_dbg_level

csio_store_dbg_level() has an inverted return check on sscanf():
the existing check treats a truthy return as an error, so every
valid write to the "dbg_level" sysfs attribute was rejected with
-EINVAL. This has been broken since the driver was first added.

> diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/cs=
io_scsi.c
> index b1de615cf3162..d64b47ee1bbe0 100644
> --- a/drivers/scsi/csiostor/csio_scsi.c
> +++ b/drivers/scsi/csiostor/csio_scsi.c
[ ... ]
> @@ -1441,12 +1440,11 @@ csio_store_dbg_level(struct device *dev,
>  	struct csio_lnode *ln =3D shost_priv(class_to_shost(dev));
>  	struct csio_hw *hw =3D csio_lnode_to_hw(ln);
>  	uint32_t dbg_level =3D 0;
> +	int ret;
> =20
> -	if (!isdigit(buf[0]))
> -		return -EINVAL;
> -
> -	if (sscanf(buf, "%i", &dbg_level))
> -		return -EINVAL;
> +	ret =3D kstrtou32(buf, 16, &dbg_level);
> +	if (ret)
> +		return ret;
> =20
>  	ln->params.log_level =3D dbg_level;
>  	hw->params.log_level =3D dbg_level;

[Severity: Medium]
This is a pre-existing issue, but does csio_store_dbg_level() need to return
the number of bytes consumed (count) instead of 0 on success?

According to the sysfs API contract, a successful store callback must return
the number of bytes consumed. Returning 0 instructs the VFS that 0 bytes we=
re
written, which causes user-space utilities like echo to indefinitely retry
writing the remaining buffer, resulting in an infinite loop.

Since this patch fixes the parsing bug that previously rejected all valid
numeric input, it looks like the success path will now be reachable for the
first time:

drivers/scsi/csiostor/csio_scsi.c:csio_store_dbg_level() {
    ...
	ln->params.log_level =3D dbg_level;
	hw->params.log_level =3D dbg_level;

	return 0;
}

Could this return value be updated to count to prevent the infinite loop?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260819220318.1761=
67-1-rodrigo.gobbi.7@gmail.com?part=3D1
