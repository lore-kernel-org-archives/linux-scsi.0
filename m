Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617F546F482;
	Thu, 17 Sep 2026 07:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789630701; cv=none; b=nmld6aq+chyY/J02XHMItWPeIFNuKksCBXAOaqXTVuCeJI5JiHu//CvPsIn/CM87A4cqWI3QvBAVpTkkjLOaCwsZdLLWUgFVy38Hgw8DATGXjzutsVNbE5D/Y/FxfkbNUwnwCJVfJ2AQJyYziZXOHO6GqRbpTBofzROjusGuMhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789630701; c=relaxed/simple;
	bh=7IVb2GpNex+Q3zeOySD37Y2eJHUw3f89zRMbeRg1p8Y=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qZFL73gGfN6qMA1ME9iCwQzFVk+1dbZi2MsEjXp05mW9ipt5ppabjKinKtE49QrgPeceHnPyQ3tI2/Oeo7ZYpmUGPc/XUvGgDOJaKrcXP4hnZdRCkBbE09UWMVUiDQ+yL1ItyedIgWlYcjcNvDAwOoDYWBctqT3XeGx0cICdi+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eidDD0Hg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eidDD0Hg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 100061F00893;
	Thu, 17 Sep 2026 07:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789630700;
	bh=TNrmOzHwD6xXc0sWOUCNVFhhf1k2QOBK2AnwV4XNMY8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eidDD0Hg/CJLHWx70ku4SQ/gsXn9lGG0vBuZYHK71gr9alw45PzSWBFm5FSflYpwN
	 xyNy59C+BAZ4kfr0TnB6Prv9WkA0KWmSAtjzZ9RnXEm1CkMisk2b6pnX3SvrwLWt2s
	 HwFKxA2AuJeycEFDVxzhE8GvDURf02iVl0K4vHKvHfDrh9UndIYteV2riLarDfoWo3
	 ACvGoNhjFEq0RAIWtFWyrBb+svJm4V1TgW3qaoMrKzyWCBIbZbLoScvUdeDCrxaW5F
	 ILxGycsAMJleu/8vYcejAkls1lO/ZgnAPv6ks5TiaeTXX2475wHiCipLcTW3z1Gltb
	 cny6TWahZ1Q+Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 05/28] ALSA: usb-audio: Refactor
 usb_audio_make_longname() to use seq_buf
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bill Wendling" <morbo@google.com>
Cc: linux-scsi@vger.kernel.org, conor+dt@kernel.org, "Chuck Lever" <cel@kernel.org>, intel-xe@lists.freedesktop.org, devicetree@vger.kernel.org, media-ci@linuxtv.org, robh@kernel.org, dri-devel@lists.freedesktop.org, dmitry.torokhov@gmail.com, "Anna
 Schumaker" <anna@kernel.org>, linux-input@vger.kernel.org, "Jeff Layton" <jlayton@kernel.org>
In-Reply-To: <20260915081910.4142719-6-morbo@google.com>
References: <20260915081910.4142719-1-morbo@google.com>
 <20260915081910.4142719-6-morbo@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 07:38:18 +0000
Message-Id: <20260917073819.100061F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] alsa: usb-audio: string corruption in usb_audio_make_longname() =
on seq_buf overflow
--

commit 4261f1e1f38e25d5a907e1a1ad3aeefb3e4075ae
Author: Bill Wendling <morbo@google.com>

ALSA: usb-audio: Refactor usb_audio_make_longname() to use seq_buf

This commit refactors usb_audio_make_longname() to use struct seq_buf=20
instead of deprecated string functions like strlcat() for building the
device longname.

Link: https://github.com/KSPP/linux/issues/370 [1]

> diff --git a/sound/usb/card.c b/sound/usb/card.c
> index 9307da95efbef..bdca8085fca66 100644
> --- a/sound/usb/card.c
> +++ b/sound/usb/card.c

[ ... ]

> @@ -667,44 +670,61 @@ static void usb_audio_make_longname(struct usb_devi=
ce *dev,
>  		s =3D preset->vendor_name;
>  	else if (quirk && quirk->vendor_name)
>  		s =3D quirk->vendor_name;
> -	*card->longname =3D 0;
> +
> +	seq_buf_init(&sb, card->longname, sizeof(card->longname));
> +
>  	if (s && *s)
> -		strscpy(card->longname, s);
> +		seq_buf_puts(&sb, s);
>  	else if (dev->manufacturer && *dev->manufacturer)
> -		strscpy(card->longname, dev->manufacturer);
> -
> -	if (*card->longname) {
> -		strim(card->longname);
> -		if (*card->longname)
> -			strlcat(card->longname, " ", sizeof(card->longname));
> +		seq_buf_puts(&sb, dev->manufacturer);
> +
> +	if (seq_buf_used(&sb)) {
> +		char *trimmed;
> +
> +		seq_buf_str(&sb);
> +		trimmed =3D strim(card->longname);
> +		if (trimmed !=3D card->longname)
> +			memmove(card->longname, trimmed, strlen(trimmed) + 1);
> +		sb.len =3D strlen(card->longname);
> +		if (sb.len)
> +			seq_buf_putc(&sb, ' ');

[Severity: Medium]
Does this seq_buf_putc() call leave the string without a null terminator if
the buffer subsequently overflows?

strim() and memmove() remove leading and trailing spaces by shifting the
string and inserting a null terminator, but they leave the old shifted
characters in the buffer immediately after the new null terminator.
seq_buf_putc() then overwrites the new null terminator with a space, but
does not append a new one to maintain string safety.

If any subsequent seq_buf_puts() calls (like shortname, path, or speed)
exceed the 80-byte capacity, they silently abort and place the buffer into
an overflow state without writing a new null terminator.=20

At the end of usb_audio_make_longname(), seq_buf_str() sees the overflow
state and places a null terminator only at the very end of the buffer, not
at the logical string end.

Can this expose duplicated characters or trailing spaces when the device
manufacturer string and subsequent concatenated parts exceed 80 bytes?

>  	}
> =20
> -	strlcat(card->longname, card->shortname, sizeof(card->longname));
> +	seq_buf_puts(&sb, card->shortname);
> =20
> -	len =3D strlcat(card->longname, " at ", sizeof(card->longname));

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915081910.4142=
719-1-morbo@google.com?part=3D5
