Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A668400987
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 14:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791813743; cv=none; b=EQMKzAMqk5pQXNilniW27O9fkBzeiPLlzAl2Mtjmyta/NcVUrmmJjNgEFKzD/acSPpsxioOa7p13QAWFyT7vVkyGg/jzl//j8GRxfA5fX1eUogMJyXGv48syugNp/49WQ2CqJM3N0x7bJEMfXAHT56M86XSuNf4f++qxdicJEL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791813743; c=relaxed/simple;
	bh=/R+g3Ca6HlPI5QXWDolDPKQZJmpNVpsx2VFTr9k+hkw=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=qslYYueXwrUSTmyT8jibu4exG+gNYX+PVmfAZ1LyHkcMCq1VArpJcnhEcWqKM8imY939qu8wtT7fKdQw6tOLasHfYZOBOwyVFm88cco2m6GjU8EfcUqN0FAueGPVFBIEf9YAKrTeBTDcAkZjyJIwkzTKDP550YkNmnsHIMjXTMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bn6fiQ/G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bn6fiQ/G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A46321F0089B;
	Mon, 12 Oct 2026 14:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791813741;
	bh=/0p/HGpHptJ8+z8M4SJQ5zhJ2RwFzPDf6Tx0NVbgcqo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bn6fiQ/GtsjxecuX8UjSvgkiBAQhHcTqU3O2c2d8J04Ylo5tGt2ygXj8LNL5bYaUK
	 SRq7UxYFD7XcfMVRmQjx5ixzghzp6gfMMZ9JC5IAmb2oVmxNla3k+O4SOBndBWOtSt
	 J/VHJv+q7v26MZAOAmaZTx9RwS9cZ+37A6vgiHTDHgvOB3Wt2tOqS3BO/M4Pv7Eate
	 hnFWDAWeDNBWcLvnygTIlAW5lwm/9ZD/tNt+TL9/sQRyvR6Y7MNc8CZDX+3RAoF/wQ
	 e8hs6wc+9ADPjXHKTX4KqzVDOv2PFw0wJrxGTb4vXADUz5/0vmnwsPjtmSZE0c9P5l
	 eJwNdi43MRKEA==
Message-ID: <sashiko-outbox-168230@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 6/9] zloop: add degrade_element control command
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261012130121.1902634-7-dlemoal@kernel.org>
References: <20261012130121.1902634-1-dlemoal@kernel.org>
 <20261012130121.1902634-7-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 14:02:21 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] block: documentation format string mismatch for element_id in zloop=
_ctl_show()
--

commit 09c168795398e63847062539d79768bb5214f9cb
Author: Damien Le Moal <dlemoal@kernel.org>

zloop: add degrade_element control command

This commit introduces a new degrade_element control command to allow users
to mark storage elements of a zloop device as degraded. The user specifies =
the
element ID to be degraded via the element_id option. Operations to zones
served by degraded elements will then be failed.

> diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
> index 11481577b9cb2..26d8335508a16 100644
> --- a/drivers/block/zloop.c
> +++ b/drivers/block/zloop.c

[ ... ]

> @@ -2303,6 +2384,10 @@ static int zloop_ctl_show(struct seq_file *seq_fil=
e, void *private)
>  	seq_puts(seq_file, zloop_ctl_ops[1].name);
>  	seq_puts(seq_file, " id=3D%d\n");
> =20
> +	/* Degrade element operation */
> +	seq_puts(seq_file, zloop_ctl_ops[2].name);
> +	seq_puts(seq_file, " id=3D%d,element_id=3D%d\n");

[Severity: Low]
Does this documentation output accurately reflect the expected format?

The option parser for zloop uses match_uint() for ZLOOP_OPT_ELEMENT_ID:

drivers/block/zloop.c:zloop_parse_options() {
    ...
		case ZLOOP_OPT_ELEMENT_ID:
			if (match_uint(args, &token)) {
				ret =3D -EINVAL;
				goto out;
			}
			opts->element_id =3D token;
			break;
    ...
}

If a user follows the %d documentation from zloop_ctl_show() and provides a
signed negative integer, the parser will reject it. Should the output string
in zloop_ctl_show() use %u instead to match the parser's requirement and av=
oid
misleading users?

> +
>  	return 0;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012130121.1902=
634-1-dlemoal@kernel.org?part=3D6
