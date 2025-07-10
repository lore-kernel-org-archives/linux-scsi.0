Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688D6226CFF;
	Thu, 10 Jul 2025 13:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752154164; cv=none; b=LmYBRWAkelloN9Is6J/pvzeBWKCYY2eef5ViIe5EOnkK/xKu6aiG0KY+MKt0jdVZew/WfMof1XKiszxEUnSqnZWSgDuKkYorerP5TO9f5aGBkZ8qCO6dmRatsIPK2AP2ztZLh6P43OUpGNM01Vfn4sfDi+xb3z9DVPEjn0OLK+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752154164; c=relaxed/simple;
	bh=QT4uJs+tWZcw1TbR3zjG7l7Y/uCgIXWvWRNm9KUxxkw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SctvtNQx0lrBd17udV71OXvMPXhDzZcfc9tk7ZNCyV0R6cwilkf+XXPHvsBTKNemw8tfQPapy8SNLp5nrwia2YLSwD8AvFz3eTwwT+U1H8j6KrrcioajZ40b5Jh29BbwxAoCPjJ4GvmzgzKAk/li+ofhL+huAljAQ3HVNFXW7K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WdhoEKcF; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WdhoEKcF"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5561d41fc96so1092813e87.1;
        Thu, 10 Jul 2025 06:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752154158; x=1752758958; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=piqCxXsuVfG+cbp1axCZg3t9wi+Ugx0SKEh/NShY52o=;
        b=WdhoEKcF6cEWqdNBB7ML5nwhwjg2uHZ/sUg59aa7exE6jxHrTA4F3aOcjvbxuwfHeH
         gN8AnyfTfipIhXGXapbD5Rb5cYYKlHUCJsZ1KaEuBssdeLHdlIW6VNoR4FGeGfsbWRPH
         kJyghXJmzvvSqVLaX1knH/E3VkEr9CMiuSFohQI1D8AAlTSYCmPRfcWkvYB5BkMZr98R
         XOfxrJ8AOfQkmCRUYQbZ0ZlfXM2TdPmwjnft3kUETDaMUUaddmBQMXfxqagDGvBy/7eT
         tiVrp5wSNBNAGKcPu4GKuu2sBFumWA+MG4rXoJcMIbPLPt6N0wsPYYHwibFOy/cG+F5w
         fpvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752154158; x=1752758958;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=piqCxXsuVfG+cbp1axCZg3t9wi+Ugx0SKEh/NShY52o=;
        b=AVtPktUheeqOAFL6Cwxo/bqsUQho8aNUF/ubiVYCulQB4P9IiU8oVvnXEoCydR0WfO
         T5M7kzj6/JlnV5b0xvtsgyAcBBVkLcP8RL9cCMq0kUAwlxZafSwBeNCPUWSrmF96yx7V
         FO5nBkYCuxc/tsbtQy1Pwlg9TRkILLxJgWh1XbqbFd2Wy8ONno0NeSgwxC6coIHeKg2S
         HvUJwretPhQGfi9H9S8ESmtbiBwtOqnfqIIp+4CcxMOj58SEJvfu7WVNXts09CVZpox1
         0WTMwgl1GvSCwSx3b8C+0Qe9puDsnFNRRT2tZB0cadUj5R+ysx9ZR0UfbZp9jExbY3Ax
         zZJA==
X-Forwarded-Encrypted: i=1; AJvYcCWBd6KjKU+hyK96zfFamVA8H1ILANABQSdA4tdPXDs6klOiqKNrMUYLaRPO3MFphGzN130HHcmUJWpDFw==@vger.kernel.org, AJvYcCWatKavrGfcaCop5SrKXhkLtxOLpWfDKm9FXs7MPAUT1OXmVeE4zrUwaz9bZG4YAe6SwK7yuLjWlDFNuNot@vger.kernel.org, AJvYcCWf6FFMCYzUZ2nxgYyNeJQX+rB/RBtKuCwEyDBkysobN5KMOllCeFSgOtvRAh/Q8wh9sSCPJ4IaxczUDyk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxb6CKNLLoa98RWhfdJfSITf/16mjb5sv7Q6uap1QlGbKTadOLh
	O4v2TNruPfaEnAFNsi7/9ASkDDdIxI1FtesnABLuVUE9ArFdOxspmgdJxYHUio7sXN9dqfShMN+
	BJZcb2jngo0/1BMnDOI5lSOiV1ZVEMM7iw7wzk/Y=
X-Gm-Gg: ASbGncsRN6BMu6ZM5aaXRft0wQBI6k9kzeaeT+/K5hsMEyYVfyXyK/+p2ulboNQbWQG
	MBj3/8NbJ+YXbSPogNuUevquoKUwHuj/S3HD0GdY7rWvp5vTlwN5OBurRi/9Zh9ytvlOxufxQrz
	Nb8sqMYi6eujKlt2HZSMViNQg+d4daJyPV4ruFFfhnP/WBqibVxFhKeuA2w+bYXzLHZpa60WNqO
	aZR
X-Google-Smtp-Source: AGHT+IGjNgUJ/H9riNAilbUH8PcKjpUwWpLd+w7gGSVY7R1BBXUiEdy2K06vfMxch2Md2cDv6Xa8DdeQP24hUJnC9hU=
X-Received: by 2002:a05:6512:3055:b0:553:2e42:fffb with SMTP id
 2adb3069b0e04-5592e3e10c9mr968505e87.33.1752154158148; Thu, 10 Jul 2025
 06:29:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250706092522.9298-1-pranav.tyagi03@gmail.com>
In-Reply-To: <20250706092522.9298-1-pranav.tyagi03@gmail.com>
From: Pranav Tyagi <pranav.tyagi03@gmail.com>
Date: Thu, 10 Jul 2025 18:59:05 +0530
X-Gm-Features: Ac12FXwmXCqGKG1PpHjcwsfz2aUtwCdpqzLfV1sJRe4M5S2L69rvhq9nulNa-ME
Message-ID: <CAH4c4j+XskhzM-Kuv+gTAaBL8o+63kbOPGS6xqQYQ3_Fd0UMCA@mail.gmail.com>
Subject: Re: [PATCH] target/core: replace strncpy with strscpy
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: skhan@linuxfoundation.org, linux-kernel-mentees@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 6, 2025 at 2:55=E2=80=AFPM Pranav Tyagi <pranav.tyagi03@gmail.c=
om> wrote:
>
> strncpy() is deprecated and its use is discouraged. Replace strncpy()
> with safer strscpy() as the p_buf buffer should be NUL-terminated, since
> it holds human readable debug output strings.
>
> Signed-off-by: Pranav Tyagi <pranav.tyagi03@gmail.com>
> ---
>  drivers/target/target_core_transport.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/targ=
et_core_transport.c
> index 0a76bdfe5528..9c255ed21789 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -1112,7 +1112,7 @@ void transport_dump_vpd_proto_id(
>         }
>
>         if (p_buf)
> -               strncpy(p_buf, buf, p_buf_len);
> +               strscpy(p_buf, buf, p_buf_len);
>         else
>                 pr_debug("%s", buf);
>  }
> @@ -1162,7 +1162,7 @@ int transport_dump_vpd_assoc(
>         }
>
>         if (p_buf)
> -               strncpy(p_buf, buf, p_buf_len);
> +               strscpy(p_buf, buf, p_buf_len);
>         else
>                 pr_debug("%s", buf);
>
> @@ -1222,7 +1222,7 @@ int transport_dump_vpd_ident_type(
>         if (p_buf) {
>                 if (p_buf_len < strlen(buf)+1)
>                         return -EINVAL;
> -               strncpy(p_buf, buf, p_buf_len);
> +               strscpy(p_buf, buf, p_buf_len);
>         } else {
>                 pr_debug("%s", buf);
>         }
> @@ -1276,7 +1276,7 @@ int transport_dump_vpd_ident(
>         }
>
>         if (p_buf)
> -               strncpy(p_buf, buf, p_buf_len);
> +               strscpy(p_buf, buf, p_buf_len);
>         else
>                 pr_debug("%s", buf);
>
> --
> 2.49.0
>
Hi,

This is a gentle follow-up on this patch. I would like to
know if there is any update on its state.

Regards
Pranav Tyagi
