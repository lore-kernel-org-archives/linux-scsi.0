Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC73119258E
	for <linux-scsi@vger.kernel.org>; Fri, 27 Jun 2025 05:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751003368; cv=none; b=RHzvgcDOk4XXXhNhDe6BNSfFnQHzkUOz3pvvKWHJxEZyqkUlgE3THULAmOhYK0cW+dP3tYI0uyqm6SoaUc+S/lHdVTYYUGvKidgkWpa1nnkU46Adbt4siizKmsQL+wwkRWt1JE/ikk7GRUPmmFHvHwD6xg3p2SWgko8SbXTPeJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751003368; c=relaxed/simple;
	bh=wv8WgiNuXIdgqxYK5gMF5gfVYTEXHzjuKR9R6isA6bY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sVf4jExpmWveH4W0XfEz7uHiiL5aC/mJHY5RBekCNWw5qiCJOkoftDH1VXas19Uc7FsD1vyOiDMQJxMKroJcoeOpu5oqWrLobYjNEWwWmrZYBAxIQBkoVLtz0nTrTex1ElP91sGBxxPuIJDWqpxLdSY7jiA8HerAWKnoETTnRvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hq1gx0sK; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hq1gx0sK"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-312e747d2d8so2621276a91.0
        for <linux-scsi@vger.kernel.org>; Thu, 26 Jun 2025 22:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751003366; x=1751608166; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B+XyrbCD3sAMl680WQBc8MpGRbMi2P/A4WAwKZ9tCJM=;
        b=Hq1gx0sKtX1Ws0MupQE3nwEgE+XElu8FfMrYUBsqiL6x3VRaVNqlTHfwDFmTsrXms/
         GlQr2SEScH0pHz6u2nsFJkCr8M1y7ZJVqkO5/VedfslvG8YddqdVgr39gKCuZsDVKVln
         85dEZBylpUYjODp38KE4y3DegbUrbCGi1XmgoZGyrvpkpxoMPaOFbkoIt/jB/hpxbeCm
         Dehah5ayLKu0EFrAFDLCg6sHXEQdI6DUNSnnnVlMpu9ggu1nnt37N2pMjh+/AVkGakTw
         h0IS4+exeSULTkLzdCmmKmzVKcGk7Umlw4/5gH/6/+FuuY4jHy2OgZWYuMLPJ7d24FM4
         mBXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751003366; x=1751608166;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B+XyrbCD3sAMl680WQBc8MpGRbMi2P/A4WAwKZ9tCJM=;
        b=rHLUMuLN21gTVIOdnDwBBnjesgfJaRQMWxuCiGbBDYvljjYvJYzpupITIjlWt2A77N
         ZQGngHCx6RgiUm/x+bM75WEx1FKH6F9xCLCIeBaplTQplpPzNVdaCZHLtcIp8vwypzJl
         UlMGePBjYanFWQJHa5zXRwqYLTHfcK9R55+kFXMl5Zrjn+pzxYNyArhydVjLP6qsIh5D
         Z/USCmuVtUMEyaof9Kz+hBc8ByqhXzOWWJtSjtdrHvK2H5bH1AATwHibIAaNIrs5+BEe
         FNrr665PRB1k3rRirBZ+TtGYm0nhbAMqCxGOfEU0UzWbCP3itLi0WZUuKA47FEkSP/Zi
         HqEw==
X-Gm-Message-State: AOJu0YyNEOOJgzYnysFkVbXIBCRgt6rVGY+oea6DKV/hiAaU5JgB57Qw
	3VOgDbXO4shm88tCDHLlVggOTpkRTY77HsDih61nAJuhAdVKaFVt2iu6HPi2RVikX7SuMfiKOm+
	yBRxJERnfrU0FfpfDME4f03yqEekGaXk5A1m1Dwk=
X-Gm-Gg: ASbGncvAecUgdIFsrCRN8hUCoxEJjICbiywGX3THzbgxhQdm/pVMWU3cWgzrpDAO11L
	t4dyuJVVJTJaDgGfsJEUqyo1kC5vU5uo8Hgk+isFmhdT3C4kT/qWbwsfq40AggTH5rWrG7zoi5f
	h7qDvnm8xti6cTH9tG0qYd+MnLjnlxTCx6zMltvFaEFfZH
X-Google-Smtp-Source: AGHT+IHlPq6OjyYZXktBrwG/MYxzwq+g6w3DD/w/r8K2K44Xjn/+dy/Cw1F3ZXTE5MLWRO7/EaAXN6HhONSnm0A3EoI=
X-Received: by 2002:a17:90b:184e:b0:313:d7ec:b7b7 with SMTP id
 98e67ed59e1d1-316edf2f071mr8210826a91.13.1751003365798; Thu, 26 Jun 2025
 22:49:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250620105344.455283-1-shankari.ak0208@gmail.com>
In-Reply-To: <20250620105344.455283-1-shankari.ak0208@gmail.com>
From: Shankari Anand <shankari.ak0208@gmail.com>
Date: Fri, 27 Jun 2025 11:19:13 +0530
X-Gm-Features: Ac12FXwlL81rm8luw826SL9z4ojB-M5n6V_QdxllMka4a2aAAVL_Jnyf76757Ws
Message-ID: <CAPRMd3kWNoUpu-wJQG43R_C-h2Npc_5AYieS_sKrHr-wEa_Z6w@mail.gmail.com>
Subject: Re: [PATCH] scsi: sysfs: replace scnprintf() with sysfs_emit() in sdev_show_blacklist()
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,
I wanted to kindly follow up and ask if this patch could be picked up
for review. Please let me know if there=E2=80=99s anything I should revise
Thanks!

On Fri, Jun 20, 2025 at 4:23=E2=80=AFPM Shankari Anand
<shankari.ak0208@gmail.com> wrote:
>
> Documentation/filesystems/sysfs.rst mentions that show() should only
> use sysfs_emit() or sysfs_emit_at() when formating the value to be
> returned to user space. So replace scnprintf() with sysfs_emit().
>
> Signed-off-by: Shankari Anand <shankari.ak0208@gmail.com>
> ---
>  drivers/scsi/scsi_sysfs.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index d772258e29ad..074b02e4cf9e 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -1095,14 +1095,14 @@ sdev_show_blacklist(struct device *dev, struct de=
vice_attribute *attr,
>                         name =3D sdev_bflags_name[i];
>
>                 if (name)
> -                       len +=3D scnprintf(buf + len, PAGE_SIZE - len,
> +                       len +=3D sysfs_emit(buf + len,
>                                          "%s%s", len ? " " : "", name);
>                 else
> -                       len +=3D scnprintf(buf + len, PAGE_SIZE - len,
> +                       len +=3D sysfs_emit(buf + len,
>                                          "%sINVALID_BIT(%d)", len ? " " :=
 "", i);
>         }
>         if (len)
> -               len +=3D scnprintf(buf + len, PAGE_SIZE - len, "\n");
> +               len +=3D sysfs_emit(buf + len, "\n");
>         return len;
>  }
>  static DEVICE_ATTR(blacklist, S_IRUGO, sdev_show_blacklist, NULL);
> --
> 2.34.1
>
