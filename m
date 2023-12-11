Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cF5NBJ3z"
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0632C4
	for <linux-scsi@vger.kernel.org>; Mon, 11 Dec 2023 12:08:14 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-a00cbb83c80so560094666b.0
        for <linux-scsi@vger.kernel.org>; Mon, 11 Dec 2023 12:08:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702325293; x=1702930093; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/I2A+kU/heU05z60USe87SZbkTbX5b5JkqKjVk3UqXg=;
        b=cF5NBJ3zDm6UtbpRASgd/4nia5UP9rhx1b9ZdES84QqTc0UQtEFk1W4dAoJNLkPkCl
         synJ+ZgNv1DGQccuXsfjUC0WcdJMBqhVB+C4xr6Hz/XlUlduvEk7dPXsC2rz6u5RaJ3/
         CFzOMRWX8+r+ovz8XpDZfs5Gaqr6m/fyUiwazYGc1xlPV+OofnFVxtljFZhYEIbfPf9U
         Gzl3C3s6LLGRLRiCDfwvCdeJ4QkoNc+0P6MphGZkEw4mY+bZRy/N559V5vyaw0HR6l/M
         SsoIoKWkng1KIw+iclAPRKTNYMfVU3sa2t1UQ22h0mcgFBIZ4dj5kAv28RKfn1QLl+ud
         OvXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702325293; x=1702930093;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/I2A+kU/heU05z60USe87SZbkTbX5b5JkqKjVk3UqXg=;
        b=jWfovL2k1uOo9SoBr2tNw0grzncDXcZdtq8OI2jw5AiN2FtFyG8MzjP7+GP3uhK82H
         atekKW2prk5WuqWuBNxVA+Ve3sdKCdoNuNj3vLDapdXZoesg2XnqUzTkQKZKQUmGdTKs
         ArpCcgs/cR8PKzQF3awOGcZmfdyLM4Kgv6B1GKO6IFqjLuglmGd3D/DyUMHl2J1/tRPO
         1322i5HhXZLw3Ys5/BRCesuT5+bJbzpNNsPkNeQwNGY/Bxwuph7MYKMkQfSh4A0TqwH4
         QsDncwjBhmSwPZ0EkfX3a8eweSs4U40oZzs5AusGe7WIBBWkFofm4MLX07y7EgCikm5w
         pjtw==
X-Gm-Message-State: AOJu0Yx2WS/K7H29nTCFv5FE61OSs/7tvjOiJ5Q/vnB1uzMqoq9lVZhs
	akjYLFXQmZ6cImezAWoxtlkAjsOvCbpbTe8+7QQiMw==
X-Google-Smtp-Source: AGHT+IGXWT5n91RWJekDXeM3hMRjGYDx8afvDMNTJMGu/CYe6+JgNLgbri08rgqjREwCSjnzSSN53VpS3dertjRjGGA=
X-Received: by 2002:a17:907:1dce:b0:a18:35e2:de31 with SMTP id
 og14-20020a1709071dce00b00a1835e2de31mr2027740ejc.63.1702325293358; Mon, 11
 Dec 2023 12:08:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231024-strncpy-drivers-scsi-fcoe-fcoe_sysfs-c-v1-1-1e0026ee032d@google.com>
 <9f38f4aa-c6b5-4786-a641-d02d8bd92f7f@acm.org>
In-Reply-To: <9f38f4aa-c6b5-4786-a641-d02d8bd92f7f@acm.org>
From: Justin Stitt <justinstitt@google.com>
Date: Mon, 11 Dec 2023 12:08:01 -0800
Message-ID: <CAFhGd8oQ-Z8e65-TOZPmNHR-rsPVRXNY8UZMDFcUScKZ6bbtJQ@mail.gmail.com>
Subject: Re: [PATCH] scsi: fcoe: replace deprecated strncpy with strscpy
To: Bart Van Assche <bvanassche@acm.org>
Cc: Hannes Reinecke <hare@suse.de>, "James E.J. Bottomley" <jejb@linux.ibm.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 24, 2023 at 1:01=E2=80=AFPM Bart Van Assche <bvanassche@acm.org=
> wrote:
>
> On 10/24/23 12:52, Justin Stitt wrote:
> > diff --git a/drivers/scsi/fcoe/fcoe_sysfs.c b/drivers/scsi/fcoe/fcoe_sy=
sfs.c
> > index e17957f8085c..7a3ca6cd3030 100644
> > --- a/drivers/scsi/fcoe/fcoe_sysfs.c
> > +++ b/drivers/scsi/fcoe/fcoe_sysfs.c
> > @@ -279,12 +279,10 @@ static ssize_t store_ctlr_mode(struct device *dev=
,
> >       if (count > FCOE_MAX_MODENAME_LEN)
> >               return -EINVAL;
> >
> > -     strncpy(mode, buf, count);
> > +     strscpy(mode, buf, count);
> >
> >       if (mode[count - 1] =3D=3D '\n')
> >               mode[count - 1] =3D '\0';
> > -     else
> > -             mode[count] =3D '\0';
> >
> >       switch (ctlr->enabled) {
> >       case FCOE_CTLR_ENABLED:
>
> Please consider to remove the code for copying the sysfs string and to
> use sysfs_match_string() instead.
>

Sorry, I'm not too familiar with sysfs strings here.

Let me know what you think of this patch [1].

> Thanks,
>
> Bart.
>

[1]: https://lore.kernel.org/r/20231211-strncpy-drivers-scsi-fcoe-fcoe_sysf=
s-c-v1-1-73b942238396@google.com

Thanks
Justin
