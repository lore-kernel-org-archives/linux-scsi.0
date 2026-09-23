Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44BE853FD49
	for <linux-scsi@vger.kernel.org>; Wed, 23 Sep 2026 14:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175404; cv=pass; b=CO2uQGK4ChsL7gTiV7e01wjFstk0+QaULih58ln796D1a5GrRk8xwb0EG98FfyfdmJR9gIUcCG2I+NLFMRwi0OtMh3Rt/RP8CcWyOYWa16OBA845cTsMjZPBzYcEiYmSlByeipjLKE6KdPP2DwaJTF9UQCsIulFB5Reri5314xM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175404; c=relaxed/simple;
	bh=KWjxpkS56vBdoY1mfq+LJ82QCdfp9oGXt1PZy19JPY4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=otuRpcKDIiiXc+31bjGWfGsCF52KvknmrOX5K6QPydDX28GOB0uTbYAooFePIqBOB4MsZZo+xYKUqRX+C3L4exJLboSJvl3CYn8BokleJdOpltonY7Nz0KxYW5+wleq5rV2OvZGgatiJA9/kUt8SdoLiLI3UfZlIHBw7cQlHYCM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iejodJny; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=dyaw9YhE; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iejodJny";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="dyaw9YhE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790175401;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Mgl2fzrtLyoiFrBfNonxZVX3GZjaxX+KyLU7gYeHtiE=;
	b=iejodJnyID9u5TOT5LXICNL8o9nPiJ8LbMUyj41jD4U+qdRGIlqS5nZTZO4WOj0i6Agg6G
	hGoEDUpV2jJ653Nnsh8YkC/CMtk6X+2TCChMbL0aS2Eu6r77snzF2wcaiIN+UGdEuW3NKa
	MCmAF8V/wbSU3Vdkc1yfdu7pV75uu5U=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-17--Wu-4mtbNseoFjAUAVG8NA-1; Wed, 23 Sep 2026 10:56:40 -0400
X-MC-Unique: -Wu-4mtbNseoFjAUAVG8NA-1
X-Mimecast-MFC-AGG-ID: -Wu-4mtbNseoFjAUAVG8NA_1790175399
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-49e745d5dabso9821555e9.0
        for <linux-scsi@vger.kernel.org>; Wed, 23 Sep 2026 07:56:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790175398; cv=none;
        d=google.com; s=arc-20260327;
        b=daue7uLnSwJXbpI309MH06UGtS2x8oLEp7jZdkWrnF1/gEcMNVvzc+DYT4pjMezw7E
         fTSZorUWShiBriNRe8BrtDX7DYe1uMHh7AkmJGg/PRGm+iI4X8EZk1v3bhLtMTIVpshM
         Xg1xoCaeAKRAg2Ej6aT/gkWIiCeE4KrdXNQOe5DVXa0+5i+X4w1qGzmwHV1Ht/OfvVqW
         EMyhZOWsd4gr5B1NMVelm4GmMzCh/aFnnmjchVSoU690hdZczu9Oy6Q5HGUNpBFj2V00
         ULZnrYyAZ/6cD17dYiS7jtJYEeiJmIHCesMFLapMidIbTCd/6YfusnmV4r6BOBXotEGR
         cLcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Mgl2fzrtLyoiFrBfNonxZVX3GZjaxX+KyLU7gYeHtiE=;
        fh=oWB0TI/lvB8EoAsqrbf3QSBV+3WD+dIIzU2GG4NbZvE=;
        b=FPSjVN0TYu/wcqRhetmgtsnnaFcLDzVTi7Y+tSd8uafJ0C3GIANcCH/tHJKs1qzqxG
         R4qfk9LYcmge3vDMjvghQkUGEW2TURak5yEjq4Xq2ZHh9GYk7O7Xbla4mqCaEIOWCj7S
         crDptYKXbf2POpw4/75yfLQWgaE8SqTfQzAT1B7hW8o9qk17SvZdPLSslrf267fghbAG
         yEczLa8ezVGlNYc8u4FJ8SpUKEAC9FDQ0KB0HUvJUysTxUJ3kdRBn+gVHyhQHRQ/BcoL
         QcNBGsrfu3u9oKjXcq8mmnpblSSS/uZH8GqUF3apVrxTul9jLTgSm4USo3aJwIUeUErx
         bwWQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790175398; x=1790780198; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Mgl2fzrtLyoiFrBfNonxZVX3GZjaxX+KyLU7gYeHtiE=;
        b=dyaw9YhENt05h9pW/Q6M+sAqbYxPgldaMTjD8WUSm24b62Iy4kvuBPhDolyOhvBtmq
         o9MWhSL2Hi0eCVZ4aqKHacuZoIbINN/XY2CM30SLPKRc1NZOKYNaz4nKqbG9NyoCowz0
         WJfYoPtqiwVPEWmUhXKyj7p/huHrsH2gzzcvoInveruyaggmLDp702anEuMZsDgx37qo
         2nAA+RPSB4a3yhBCXPBWHUV2X7VaRELPT5ERs3ksJL1nHxALLtC3d60cQio34E+RhnPL
         A+CKjSh3SlbzhGXHEMXzXArzAqXpoobn3p3oO6Q+jvdmXbCXE7cJVsui8NrlCocr8Fka
         NaNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790175398; x=1790780198;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Mgl2fzrtLyoiFrBfNonxZVX3GZjaxX+KyLU7gYeHtiE=;
        b=yUDRLjgBVPw0VUBCvrELvoQYyJGbkwewNvJWu3hNHOJRKE151gsAMIfiSKE9qx2UxE
         nSVdCwgnfXS+UlK6PJjbiJjN4oHJKA5WBlNTj7JEnio6kO/WJ+sh5jieNK1Qp7U1L1tj
         5mGLonhD5QdodFtk5K9TZzG4YJXs+/GO+cvjXyY5BgMVGDiGmH4KcYxG6j9aQl2YbADO
         w92r3eGmlkFZ9wt/ZVfOSb5IuKZK0iOFVNOhz0UeFWMvBpbUN/rjVa1NrTOkm0u6AjIb
         Hb37JguNCJaTaLtRtFrOFfKazgsyWp770hnFWcz4rGhwzjAUv9B+SX2OmH59mwP/E864
         YBxA==
X-Forwarded-Encrypted: i=1; AKwUvByqtA/IkyWVlbgxw3+viuss85dJM5IujWRNCEBx4bTiG6xs/6lR6wTLUFMMaRImcReGc35S4uhVNJcw@vger.kernel.org
X-Gm-Message-State: AFuF++mXRQWB4Fs5vQ+X08tbYSFHBQ7Z1nlUzTZVd31lvVnKADoi+16o
	cYbMwdgvaKBx1TVIYMViXTXRn1rPHoYwVx0rTKxIG05/oSm1jIP3oC+paj8ViK0kb54hXXNInmX
	xfggmu0dAqDPLrk/ePTi1avyn5LVFOkJ0RsAH54tSDfaAND2UfzEwoBkL3YO1xVh4+8Bqg37yrJ
	noRDe99f5gZy/aD5rpEA8LB1W0gGkMOkk4uaqX5A==
X-Gm-Gg: AYBFou1YCVj/ANi7EER5uc/iAc4/ChvmEGpoiI5TChitOoOn4Q8skxegbXIM//zRQDY
	orip53u6MWfExVs6bLtfG1AyOlmpd+3Nr2QwFKlf8MSu7Nou/XMFh/KK0aFu26XQCAxkci65EB2
	2U4BdBcs9dQcmI+0+diyZv+4AtrbUExiVCMAWXArop/0/OTCWWXoTr4Vy4yczEsz1FFRElDuJiO
	Z/kqyydABHDOeWf3w==
X-Received: by 2002:a05:600c:3b21:b0:49f:bd3c:bc25 with SMTP id 5b1f17b1804b1-49fdf25486bmr41518035e9.32.1790175398641;
        Wed, 23 Sep 2026 07:56:38 -0700 (PDT)
X-Received: by 2002:a05:600c:3b21:b0:49f:bd3c:bc25 with SMTP id
 5b1f17b1804b1-49fdf25486bmr41517685e9.32.1790175398258; Wed, 23 Sep 2026
 07:56:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260902200547.184734-1-jtaubepe@redhat.com> <20260902200547.184734-8-jtaubepe@redhat.com>
 <ab97f32b-31dd-4975-a8b2-b445110ae3a9@suse.de>
In-Reply-To: <ab97f32b-31dd-4975-a8b2-b445110ae3a9@suse.de>
From: Jesse Taube <jtaubepe@redhat.com>
Date: Wed, 23 Sep 2026 10:56:27 -0400
X-Gm-Features: AclHuK-DXEgf8h50oy37YCFQPiuZykx03xaAenYlWJQtQSO7dJcvZ7KWpU5nfJA
Message-ID: <CADRr4bePoiDnWX_XrMWtQe=1g4Yrw1_dK86EV2k9XZR0HnL+UQ@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] nvme: fcloop: Add set_marginal_rport to sysfs
To: Hannes Reinecke <hare@suse.de>
Cc: linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, 
	Sagi Grimberg <sagi@grimberg.me>, Justin Tee <justin.tee@broadcom.com>, 
	Naresh Gottumukkala <nareshgottumukkala83@gmail.com>, Paul Ely <paul.ely@broadcom.com>, 
	Chaitanya Kulkarni <kch@nvidia.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Nilesh Javali <njavali@marvell.com>, 
	GR-QLogic-Storage-Upstream@marvell.com, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, John Meneghini <jmeneghi@redhat.com>, 
	Bryan Gurney <bgurney@redhat.com>, Chris Leech <cleech@redhat.com>, 
	"Ewan D . Milne" <emilne@redhat.com>, shinichiro.kawasaki@wdc.com, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 21, 2026 at 10:03=E2=80=AFAM Hannes Reinecke <hare@suse.de> wro=
te:
>
> On 9/2/26 10:05 PM, Jesse Taube wrote:
> > To allow testing of multipath failover, add a sysfs attribute to set a
> > remote port as marginal. This will allow the fcloop LLDD to set the
> > marginal flag on a remote port, simulating a marginal link.
> >
> > Example:
> > Turn on marginal for a remote port matching wwnn and wwpn:
> > `echo 'wwnn=3D0x200000109b5f2956,wwpn=3D0x100000109b5f2956,marginal=3D1=
' >
> > /sys/class/fcloop/ctl/set_marginal_rport`
> >
> > Turn off marginal for a remote port matching wwnn and wwpn:
> > `echo 'wwnn=3D0x200000109b5f2956,wwpn=3D0x100000109b5f2956,marginal=3D0=
' >
> > /sys/class/fcloop/ctl/set_marginal_rport`
> >
> > Suggested-by: John Meneghini <jmeneghi@redhat.com>
> > Signed-off-by: Jesse Taube <jtaubepe@redhat.com>
> > V10 -> V1:
> >   - New patch
> > V1 -> V2:
> >   - Fix reference count leak in error path
> > ---
> >   drivers/nvme/target/fcloop.c | 50 +++++++++++++++++++++++++++++++++++=
+
> >   1 file changed, 50 insertions(+)
> >
> > diff --git a/drivers/nvme/target/fcloop.c b/drivers/nvme/target/fcloop.=
c
> > index b63af3b643a6..9977c2a71bd5 100644
> > --- a/drivers/nvme/target/fcloop.c
> > +++ b/drivers/nvme/target/fcloop.c
> > @@ -6,6 +6,7 @@
> >   #include <linux/module.h>
> >   #include <linux/parser.h>
> >   #include <uapi/scsi/fc/fc_fs.h>
> > +#include <uapi/scsi/fc/fc_els.h>
> >
> >   #include "../host/nvme.h"
> >   #include "../target/nvmet.h"
> > @@ -21,6 +22,7 @@ enum {
> >       NVMF_OPT_FCADDR         =3D 1 << 3,
> >       NVMF_OPT_LPWWNN         =3D 1 << 4,
> >       NVMF_OPT_LPWWPN         =3D 1 << 5,
> > +     NVMF_OPT_MARGINAL       =3D 1 << 6,
> >   };
> >
> >   struct fcloop_ctrl_options {
> > @@ -31,6 +33,7 @@ struct fcloop_ctrl_options {
> >       u32                     fcaddr;
> >       u64                     lpwwnn;
> >       u64                     lpwwpn;
> > +     u32                     marginal;
> >   };
> >
> >   static const match_table_t opt_tokens =3D {
> > @@ -40,6 +43,7 @@ static const match_table_t opt_tokens =3D {
> >       { NVMF_OPT_FCADDR,      "fcaddr=3D%x"     },
> >       { NVMF_OPT_LPWWNN,      "lpwwnn=3D%s"     },
> >       { NVMF_OPT_LPWWPN,      "lpwwpn=3D%s"     },
> > +     { NVMF_OPT_MARGINAL,    "marginal=3D%d"   },
> >       { NVMF_OPT_ERR,         NULL            }
> >   };
> >
> > @@ -120,6 +124,13 @@ fcloop_parse_options(struct fcloop_ctrl_options *o=
pts,
> >                       }
> >                       opts->lpwwpn =3D token64;
> >                       break;
> > +             case NVMF_OPT_MARGINAL:
> > +                     if (match_int(args, &token)) {
> > +                             ret =3D -EINVAL;
> > +                             goto out_free_options;
> > +                     }
> > +                     opts->marginal =3D token;
> > +                     break;
> >               default:
> >                       pr_warn("unknown parameter or missing value '%s'\=
n", p);
> >                       ret =3D -EINVAL;
> > @@ -199,6 +210,9 @@ fcloop_parse_nm_options(struct device *dev, u64 *nn=
ame, u64 *pname,
> >
> >   #define TGTPORT_OPTS        (NVMF_OPT_WWNN | NVMF_OPT_WWPN)
> >
> > +#define MARGINAL_OPTS        (NVMF_OPT_WWNN | NVMF_OPT_WWPN | \
> > +                      NVMF_OPT_MARGINAL)
> > +
> >
> >   static DEFINE_SPINLOCK(fcloop_lock);
> >   static LIST_HEAD(fcloop_lports);
> > @@ -1663,6 +1677,40 @@ fcloop_set_cmd_drop(struct device *dev, struct d=
evice_attribute *attr,
> >       return count;
> >   }
> >
> > +static ssize_t
> > +fcloop_set_marginal_rport(struct device *dev, struct device_attribute =
*attr,
> > +             const char *buf, size_t count)
> > +{
> > +     struct fcloop_nport *nport;
> > +     struct fcloop_ctrl_options opts =3D {};
> > +     unsigned long flags;
> > +     int ret;
> > +
> > +     ret =3D fcloop_parse_options(&opts, buf);
> > +     if (ret)
> > +             return ret;
> > +
> > +     /* everything there ? */
> > +     if ((opts.mask & MARGINAL_OPTS) !=3D MARGINAL_OPTS)
> > +             return -EINVAL;
> > +
> > +     nport =3D fcloop_nport_lookup(opts.wwnn, opts.wwpn);
> > +     if (!nport)
> > +             return -ENOENT;
> > +
> > +     spin_lock_irqsave(&fcloop_lock, flags);
> > +     if (!nport->rport || !nport->rport->remoteport) {
> > +             spin_unlock_irqrestore(&fcloop_lock, flags);
> > +             fcloop_nport_put(nport);
> > +             return -ENOENT;
> > +     }
> > +
> > +     nvme_fc_set_remoteport_fpin(nport->rport->remoteport, opts.margin=
al);
> > +     spin_unlock_irqrestore(&fcloop_lock, flags);
> > +     fcloop_nport_put(nport);
> > +
> > +     return count;
> > +}
> >
> >   static DEVICE_ATTR(add_local_port, 0200, NULL, fcloop_create_local_po=
rt);
> >   static DEVICE_ATTR(del_local_port, 0200, NULL, fcloop_delete_local_po=
rt);
> > @@ -1671,6 +1719,7 @@ static DEVICE_ATTR(del_remote_port, 0200, NULL, f=
cloop_delete_remote_port);
> >   static DEVICE_ATTR(add_target_port, 0200, NULL, fcloop_create_target_=
port);
> >   static DEVICE_ATTR(del_target_port, 0200, NULL, fcloop_delete_target_=
port);
> >   static DEVICE_ATTR(set_cmd_drop, 0200, NULL, fcloop_set_cmd_drop);
> > +static DEVICE_ATTR(set_marginal_rport, 0200, NULL, fcloop_set_marginal=
_rport);
> >
> >   static struct attribute *fcloop_dev_attrs[] =3D {
> >       &dev_attr_add_local_port.attr,
> > @@ -1680,6 +1729,7 @@ static struct attribute *fcloop_dev_attrs[] =3D {
> >       &dev_attr_add_target_port.attr,
> >       &dev_attr_del_target_port.attr,
> >       &dev_attr_set_cmd_drop.attr,
> > +     &dev_attr_set_marginal_rport.attr,
> >       NULL
> >   };
> >
> Please don't make it a fabrics option.

What do you mean by fabrics option? How should I fix this?

Thanks,
Jesse Taube

> Setting is via sysfs is
> sufficient seeing it's for testing only.
>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                  Kernel Storage Architect
> hare@suse.de                                +49 911 74053 688
> SUSE Software Solutions GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg
> HRB 36809 (AG N=C3=BCrnberg), GF: I. Totev, A. McDonald, W. Knoblich
>

