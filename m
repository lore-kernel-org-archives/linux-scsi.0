Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6550CC25B47
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Oct 2023 20:00:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232831AbjJ0UAp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Oct 2023 16:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232515AbjJ0UAo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Oct 2023 16:00:44 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2AD81B1
        for <linux-scsi@vger.kernel.org>; Fri, 27 Oct 2023 13:00:38 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-9936b3d0286so383655766b.0
        for <linux-scsi@vger.kernel.org>; Fri, 27 Oct 2023 13:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698436837; x=1699041637; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yobZYiTROnZbnWt97aXOIqRoozVbekmuSyrI2D0DmEQ=;
        b=21cD94GlI92fGvgrGKcZWzvwaqs7PFcDB/jLm5qg3U87N6CWwVlL2jA1+CWwv6VkEo
         fu7zZizsT/KJQUjYKGR3IQsGs3/VNDmYx/BzRIWinePzsG08t4DeJOIduR62HQyccEeb
         mmlziFc44tTQgjXOxXpmTSxmVf74fMnQdbm1APu+LqCB77ZYgbECTNdNnnx2eR3CybU1
         wtv8iOtQMD+aZqjfWE5eXxtmom3JMkEoXZnEGsRFFpSEy7UPIl6E5vtRQ5nutrUBC8IN
         RhlspDw8v5pTpzCHoSzxCLZxLYgq1rHYwZBrMNwkD5iFaP+N2QNxlXFVGt+BccjG+Yv5
         YZ/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698436837; x=1699041637;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yobZYiTROnZbnWt97aXOIqRoozVbekmuSyrI2D0DmEQ=;
        b=AEhczl8UWftCEEUHEaLeb+30Qa49z43BtQRz2eYvJoicKu5Ie0iI0zw8hk+o2u3T/1
         ZDDHFDLSAwZL2gmfy4TwhMMAA7PsBcNrZOoFeciLu48yWVpS9Nu7RNzWA1RcLzCb/TgX
         hQQqHsGcxKZHTSro4BVgUONdPtOO1GA7p3MkhIDx2sG6Ibow+IqzrJUbXgMVaqEzrxSD
         aFbokiAXVcva4TzMPeKqqsbdPBlb7gPxNg63nXPbQ246AVR4z4Ktb+M94PQ7Y42IAYot
         FQWmCH9jRZwcdkE+dyRw1UFQzpPBCVoVtFvm6g5Bkhfik+xHllDMPR2ezWOeRSkXnLvM
         8Ayw==
X-Gm-Message-State: AOJu0YwS7HJ8zIVV66W+MOEwemgovT02s4893vqO8DaJ1DSBZNlxluDW
        ocRV2GIachDe8SE0D9Bk3W/Kdr2P3OMem17FIiPaUw==
X-Google-Smtp-Source: AGHT+IEECTHllrJmzv5sahl44qlCGaWHzkN+S8KPH5915KPk6hOjL1gjxgKo6qnIhYlrpIN54Jh1oJ+0er/1gULQ1H4=
X-Received: by 2002:a17:907:26c9:b0:9c7:6fa7:586e with SMTP id
 bp9-20020a17090726c900b009c76fa7586emr3499260ejc.1.1698436837160; Fri, 27 Oct
 2023 13:00:37 -0700 (PDT)
MIME-Version: 1.0
References: <20231026-strncpy-drivers-scsi-hpsa-c-v2-1-2fe2d05122fd@google.com>
 <202310270901.B49F63CD5@keescook>
In-Reply-To: <202310270901.B49F63CD5@keescook>
From:   Justin Stitt <justinstitt@google.com>
Date:   Fri, 27 Oct 2023 13:00:25 -0700
Message-ID: <CAFhGd8ooYaPBXyWLTKD94-jiR0Na4qnyRT602R1tzjdF9W3BWg@mail.gmail.com>
Subject: Re: [PATCH v2] scsi: hpsa: replace deprecated strncpy
To:     Kees Cook <keescook@chromium.org>
Cc:     Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        storagedev@microchip.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Oct 27, 2023 at 9:04=E2=80=AFAM Kees Cook <keescook@chromium.org> w=
rote:
>
> On Thu, Oct 26, 2023 at 11:13:41PM +0000, Justin Stitt wrote:
> > strncpy() is deprecated for use on NUL-terminated destination strings
> > [1] and as such we should prefer more robust and less ambiguous string
> > interfaces.
> >
> > Instances of strncpy()'ing a string into a buffer and manually
> > NUL-terminating followed by sccanf with just "%d" as the format
> > specifier can be accomplished by strscpy() and kstrtoint().
> >
> > strscpy() guarantees NUL-termination on the destination buffer and
> > kstrtoint is better way of getting strings turned into ints.
> >
> > For the last two strncpy() use cases in init_driver_version(), we can
> > actually drop this function entirely.
> >
> > Firstly, we are kmalloc()'ing driver_version. Then, we are calling
> > init_driver_version() which memset's it to 0 followed by a strncpy().
> > The pattern is 1) allocating memory for a string, 2) setting all bytes
> > to NUL, 3) copy bytes from another string + ensure NUL-padded.
> >
> > For these, we can just stack allocate driver_version and
> > old_driver_version. This simplifies the code greatly as we don't have
> > any malloc/free or strncpy's.
> >
> > Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#st=
rncpy-on-nul-terminated-strings [1]
> > Link: https://manpages.debian.org/testing/linux-manual-4.8/strscpy.9.en=
.html [2]
> > Link: https://github.com/KSPP/linux/issues/90
> > Cc: linux-hardening@vger.kernel.org
> > Cc: Kees Cook <keescook@chromium.org>
> > Signed-off-by: Justin Stitt <justinstitt@google.com>
> > ---
> > Changes in v2:
> > - use stack for buffers (thanks Kees)
> > - use kstrtoint (thanks Kees)
> > - Link to v1: https://lore.kernel.org/r/20231026-strncpy-drivers-scsi-h=
psa-c-v1-1-75519d7a191b@google.com
> > ---
> > Note: build-tested only.
> >
> > Found with: $ rg "strncpy\("
> > ---
> >  drivers/scsi/hpsa.c | 53 ++++++++++++++++++++-------------------------=
--------
> >  1 file changed, 20 insertions(+), 33 deletions(-)
> >
> > diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> > index af18d20f3079..4d42fbb071cf 100644
> > --- a/drivers/scsi/hpsa.c
> > +++ b/drivers/scsi/hpsa.c
> > @@ -452,18 +452,18 @@ static ssize_t host_store_hp_ssd_smart_path_statu=
s(struct device *dev,
> >                                        struct device_attribute *attr,
> >                                        const char *buf, size_t count)
> >  {
> > -     int status, len;
> > +     int status;
> >       struct ctlr_info *h;
> >       struct Scsi_Host *shost =3D class_to_shost(dev);
> >       char tmpbuf[10];
> >
> >       if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
> >               return -EACCES;
> > -     len =3D count > sizeof(tmpbuf) - 1 ? sizeof(tmpbuf) - 1 : count;
> > -     strncpy(tmpbuf, buf, len);
> > -     tmpbuf[len] =3D '\0';
> > -     if (sscanf(tmpbuf, "%d", &status) !=3D 1)
> > +
> > +     strscpy(tmpbuf, buf, sizeof(tmpbuf));
> > +     if (kstrtoint(tmpbuf, 0, &status))
>
> I actually meant:
>
>         if (kstrtoint(buf, 0, &status))

How do we know `buf` is NUL-terminated as kstrtoint() demands:

/**
 * kstrtoint - convert a string to an int
 * @s: The start of the string. The string must be null-terminated, and may=
 also
 *  include a single newline before its terminating null. The first charact=
er
 *  may also be a plus sign or a minus sign.
...

>
> I don't see any reason for "tmpbuf" at all.
>
> > @@ -7234,25 +7234,15 @@ static int hpsa_controller_hard_reset(struct pc=
i_dev *pdev,
> >       return 0;
> >  }
> >
> > -static void init_driver_version(char *driver_version, int len)
> > -{
> > -     memset(driver_version, 0, len);
> > -     strncpy(driver_version, HPSA " " HPSA_DRIVER_VERSION, len - 1);
> > -}
> > -
> >  static int write_driver_ver_to_cfgtable(struct CfgTable __iomem *cfgta=
ble)
> >  {
> > -     char *driver_version;
> >       int i, size =3D sizeof(cfgtable->driver_version);
> > +     char driver_version[sizeof(cfgtable->driver_version)] =3D
> > +                                             HPSA " " HPSA_DRIVER_VERS=
ION;
> >
> > -     driver_version =3D kmalloc(size, GFP_KERNEL);
> > -     if (!driver_version)
> > -             return -ENOMEM;
> > -
> > -     init_driver_version(driver_version, size);
> >       for (i =3D 0; i < size; i++)
> >               writeb(driver_version[i], &cfgtable->driver_version[i]);
> > -     kfree(driver_version);
> > +
> >       return 0;
> >  }
> >
> > @@ -7268,21 +7258,18 @@ static void read_driver_ver_from_cfgtable(struc=
t CfgTable __iomem *cfgtable,
> >  static int controller_reset_failed(struct CfgTable __iomem *cfgtable)
> >  {
> >
> > -     char *driver_ver, *old_driver_ver;
> > -     int rc, size =3D sizeof(cfgtable->driver_version);
> > -
> > -     old_driver_ver =3D kmalloc_array(2, size, GFP_KERNEL);
> > -     if (!old_driver_ver)
> > -             return -ENOMEM;
> > -     driver_ver =3D old_driver_ver + size;
> > +     char driver_ver[sizeof(cfgtable->driver_version)] =3D "";
> > +     char old_driver_ver[sizeof(cfgtable->driver_version)] =3D
> > +                                             HPSA " " HPSA_DRIVER_VERS=
ION;
> > +     int rc;
> >
> >       /* After a reset, the 32 bytes of "driver version" in the cfgtabl=
e
> >        * should have been changed, otherwise we know the reset failed.
> >        */
> > -     init_driver_version(old_driver_ver, size);
> >       read_driver_ver_from_cfgtable(cfgtable, driver_ver);
> > -     rc =3D !memcmp(driver_ver, old_driver_ver, size);
> > -     kfree(old_driver_ver);
> > +     rc =3D !memcmp(driver_ver, old_driver_ver,
> > +                  sizeof(cfgtable->driver_version));
> > +
> >       return rc;
> >  }
> >  /* This does a hard reset of the controller using PCI power management
>
> These two look good now; thanks!

Woot!

>
> -Kees
>
> --
> Kees Cook

Thanks
Justin
