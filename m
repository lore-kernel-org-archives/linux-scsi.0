Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B27E181CEC
	for <linux-scsi@vger.kernel.org>; Wed, 10 Apr 2024 20:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712782277; cv=none; b=nX3XwdJMAxW+8qXOmuIW7VzLj5Y7KkcF421KJdE73VpxDfUJ+vwjMZUlj0+rYjW+mSKEkSe8L/PmcTryCfw6NuqKPjBO3mcTB6w1hlpa0xbjpyyoFoHHFfzOvuaGzHjml7VPrTDj3zAD5CyBlLlQvz/cCRUEMKROfSMkp6NX/CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712782277; c=relaxed/simple;
	bh=5Y1bo2xjZi4LtFXeRude1iDHNoJkScv+UidtLv+b62I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UhPKXSbhKu4K/TnxrzJFrvzvTLFH6j0eZclimzbXIXAmXOye+zDbDP+t9kJxMnD5gPeMqDYZTutuLEruFzdZkfZ9rImN7sevBpUZzKS6D2Km8HNWilweiDWqorse3lQh2WbEtBjNRvZm2UjXRdLywEDZJMi4D75FFDCnE5nBMsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wvmYwFnC; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wvmYwFnC"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a51aac16b6eso310541966b.1
        for <linux-scsi@vger.kernel.org>; Wed, 10 Apr 2024 13:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712782273; x=1713387073; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x1GhQ8TpIVNLLFZSHOojawW5gSTYZkwN3L6+cXSKLuw=;
        b=wvmYwFnCBrV4nUo6c1L94kjUamCzueYBaNEf5FjLpjg2AW6MO+t4EOiHrOsK/jZXw3
         jYquEIQ97jqIb/ty4YEKyZqHkrBqj9KVPM3CwjPNUYDOt3GXg6OMZlZs4F81RLXdx8Iq
         b5oWfCBq4GTbEIaFpEgylHxxUMVdgUVCjssjgpKKuPHGmd32jFeAddqpocmMY1LjCBhM
         LCu9mJvvhXuLEhmwaMY3xAyZxoAckJVhCcamoYIpcqyKSA2G7jpxm2Om1TydKPq/QiHe
         pFpCo6caLGZpeCPQNKkTV+L/irBvFcMZ+EaKdGbdf71AQ1xna4FE7uaKgWodwmli3abj
         FlIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712782273; x=1713387073;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x1GhQ8TpIVNLLFZSHOojawW5gSTYZkwN3L6+cXSKLuw=;
        b=QUAQ+xvk1KJX+B8zG+qYdxrRz6MCEHOyBsDn9zcJujcK2VgEuxKk6Bz3M2VsMkeoQC
         KdKTCUrtS9xz+Q7UpDHCx8Vn9BTr9vWtrkispSniOa0lQbQBU4CMyLXidiEKr5PqzmPp
         xpyFmtHDqfDEkpV+K19sJkTB5nliO/uAHE6GzIcjnn9IsBicNbHEAFS/CTCwPPaDmGkv
         uD1h6I0hgSxDzUhmccSTDrbGA342ptk2ycvpifU68TwkeU4+doBFnc4yxGrobgMzzoPA
         9hHQParjBXmWThPFtfhQ7BQtPNJ8d3CdcKusbTiN1eSyUt73MS0DcSVx6XYNyU5pRHgX
         VIjg==
X-Forwarded-Encrypted: i=1; AJvYcCVtOoAJzTEzpDbg48Uixf38GdCDW1lnJFr7uilbu2z6lIrhnpIo5M9VbTYX4k1jXUeGbTTseLzpgRNwytNqWFu+e9Je9JgJJr8pqQ==
X-Gm-Message-State: AOJu0YxC6kjrIaTseCvroBO4L2mGcy5T1yLDQerHoBc1r5y+WITNdQ0Z
	9PMwIKMfm2sHKWFmm3L6RmOkQ+afy6Kpc5iRlyo3+9OEVz0hiUAiIhkhGu7YXFT6BADMpeDRd9t
	0vrLdg7k17IXEJ9QngQGzgWiZrZpVloDKRTyA
X-Google-Smtp-Source: AGHT+IH/6bvw3f4KsllOQFuwhwfMvpS3Z1+mQmaaM+cttz+rZprPbWRgznuK3b8bwl8WwF/+1jCqgZgXt/A36rlsdPk=
X-Received: by 2002:a50:bb05:0:b0:56d:fca8:d2d6 with SMTP id
 y5-20020a50bb05000000b0056dfca8d2d6mr2997121ede.6.1712782273338; Wed, 10 Apr
 2024 13:51:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <5445ba0f-3e27-4d43-a9ba-0cc22ada2fce@cox.net> <CAFhGd8pTAKGcu2uLzUDDxto1sk5-9zQevsrXp-xL0cdPcGYaGg@mail.gmail.com>
 <d45631ac-3ee6-45cc-8b5a-fab130ce39d7@cox.net> <CAFhGd8p=R4P6J9KoMGcXij=fN=9sixVzjuz95TLKP1TexnvV8Q@mail.gmail.com>
 <202404081602.1B1773256@keescook>
In-Reply-To: <202404081602.1B1773256@keescook>
From: Justin Stitt <justinstitt@google.com>
Date: Wed, 10 Apr 2024 13:51:01 -0700
Message-ID: <CAFhGd8pdTzJae4257o5fNBiJ+GdRUzoCDH3xe6cTMqBHcsR=AA@mail.gmail.com>
Subject: Re: startup BUG at lib/string_helpers.c from scsi fusion mptsas
To: Kees Cook <keescook@chromium.org>
Cc: Charles Bertsch <cbertsch@cox.net>, linux-scsi@vger.kernel.org, 
	MPT-FusionLinux.pdl@broadcom.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Apr 8, 2024 at 4:19=E2=80=AFPM Kees Cook <keescook@chromium.org> wr=
ote:
> I think something like this, memtostr:
>
> diff --git a/include/linux/string.h b/include/linux/string.h
> index 9ba8b4597009..5def02c7c0ce 100644
> --- a/include/linux/string.h
> +++ b/include/linux/string.h
> @@ -422,6 +422,30 @@ void memcpy_and_pad(void *dest, size_t dest_len, con=
st void *src, size_t count,
>         memcpy(dest, src, strnlen(src, min(_src_len, _dest_len)));      \
>  } while (0)
>
> +/**
> + * memtostr - Copy a possibly non-NUL-term string to a NUL-term string
> + * @dest: Pointer to destination NUL-terminates string
> + * @src: Pointer to character array (likely marked as __nonstring)
> + *
> + * This is a replacement for strncpy() uses where the source is not
> + * a NUL-terminated string.
> + *
> + * Note that sizes of @dest and @src must be known at compile-time.
> + */
> +#define memtostr(dest, src)    do {                                    \
> +       const size_t _dest_len =3D __builtin_object_size(dest, 1);       =
 \
> +       const size_t _src_len =3D __builtin_object_size(src, 1);         =
 \
> +       const size_t _src_chars =3D strnlen(src, _src_len);              =
 \
> +       const size_t _copy_len =3D min(_dest_len - 1, _src_chars);       =
 \
> +                                                                       \
> +       BUILD_BUG_ON(!__builtin_constant_p(_dest_len) ||                \
> +                    !__builtin_constant_p(_src_len) ||                 \
> +                    _dest_len =3D=3D 0 || _dest_len =3D=3D (size_t)-1 ||=
       \
> +                    _src_len =3D=3D 0 || _src_len =3D=3D (size_t)-1);   =
       \
> +       memcpy(dest, src, _copy_len);                                   \
> +       dest[_copy_len] =3D '\0';                                        =
 \
> +} while (0)
> +
>  /**
>   * memset_after - Set a value after a struct member to the end of a stru=
ct
>   *
>
>
> I've also identified other cases where this pattern exists, so I think
> we can apply this and any needed fixes using it instead of strscpy().
>

For visibility, Kees has a series [1] which introduces memtostr and
also fixes up drivers/message/fusion/mptsas.c.

Charles, can you try out that series?

> --
> Kees Cook

[1]: https://lore.kernel.org/all/20240410023155.2100422-2-keescook@chromium=
.org/

Thanks
Justin
