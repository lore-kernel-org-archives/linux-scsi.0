Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A4D53C3AC
	for <linux-scsi@vger.kernel.org>; Wed, 23 Sep 2026 16:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790180189; cv=pass; b=H8dmc0N2oPAWZRuC7WN5lavB58+PVw9PEGRoyRww3uKlTB1CnA88+fn58yBuF3PSO/HyGbgGOpAokTd6v4IsIIUZn6aSqvGGzGZETGi1NOekflnSuZdz4jKnEl/NyJAN+8DuJIGLB92qiyf/pf4IG7jEFEfAZwnKYU+kaPK/8jQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790180189; c=relaxed/simple;
	bh=IgFBZ0ZgrljS0uGrRjUXNBEdLyByc1A6yRVAR2zjdZQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BVrpRjlmKCm/L8PGkArFIA+2E/XYhiLfZlmWioEvm/C8A56XRgspnb/s+aw2AY9SJjeifmjBgSWEa8gINJ9XlFg43cCdo8SHwtRUqZPbU1uvQ0c/QyvSuXaVXSnUOSGQ33xu65b+3oNauCxbWPEwTEh75TYETPMSfVVLfOvrCLI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O99ZLeHu; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=DcUAfx37; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O99ZLeHu";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="DcUAfx37"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790180186;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8lwL4K1D0LmNyg6j112+oM7NzQaxc/i6AC7mkZYZafE=;
	b=O99ZLeHurq41nmGtnCAcA/mRTkGpn63HhXPSZqyN/1a2eecz9syJHpkc5RMaur+44eo1Ef
	Z0jTcaBCgB4xmuLiVx4jLeJdQXa+1MvOff14Y5cAFi3X2Xn90w4S7aHCc4Fmv5PSQJELc6
	HL8zhmNNld+tn0xrrGomzwZQzbpz/Ac=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-7-vFKrMIXxPSa-NFhMOfgPRA-1; Wed, 23 Sep 2026 12:16:23 -0400
X-MC-Unique: vFKrMIXxPSa-NFhMOfgPRA-1
X-Mimecast-MFC-AGG-ID: vFKrMIXxPSa-NFhMOfgPRA_1790180182
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-49fcc575709so10608305e9.3
        for <linux-scsi@vger.kernel.org>; Wed, 23 Sep 2026 09:16:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790180182; cv=none;
        d=google.com; s=arc-20260327;
        b=djPtgxinQoyAqZDF72mk2fPB95OSORw6xBJG2FZlrCUZxr083Ix3AQgo4fa2sAxMot
         JzjlT1AymJSLKWPc35vOmo/y/zYxw46xA7tPk1qS/iXuvgubzhHPOtYNOEUK20u7kTl0
         GuCsLI5m/H56TZsW77QWLSw6Jg+D0DggDD9NAWGRsc2UYQKNstAt2wm4fi1ISNu9XJ4J
         2cqfMvhWhUisUGIxzyvRk6bdi5XdSAVc6XSweu1QrT63KuzhDR2hVpQnf7oq3trXohb9
         8+k9QyZajepRwHR/+lplb5kFBeg4TB/cW2bej1opDwyk7XixtdliTtFgcGaxBYwz6XZQ
         tg/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8lwL4K1D0LmNyg6j112+oM7NzQaxc/i6AC7mkZYZafE=;
        fh=+KxdraO+r2JjfmTlllt9mMiNdxDt571kdXk6666Cp2E=;
        b=BixetZ66CPoCRxwMSl44CIN0P78n7LhIFsKxZGHOKdtGq9g7friIsuIxzQMVbyOMb7
         qeFGrNkDULQYca8/hGDh/8lzt5amqC3vMxSAqGYhDE8ElN8fzi1yibIca4V/ul1CvB7s
         A5BgujdEti1ja8/xPtRIksFB/TVdKFeh1U9EiexyUcL1tX9ShQfE4j8lYkn6MTH/vvoY
         BvoPjyk46nlpOKKq6+ITNiASOr+VJnCZTOlXVAM+NXbOHdwNWIKrDZA8fCeFO0WXsCay
         KpWHE12nRhtq5dvJQRd0w61VY+1d84pcLINU2b2roENbJwp6EuqVcX8qFcLsShGYhdAf
         8r3w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790180182; x=1790784982; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8lwL4K1D0LmNyg6j112+oM7NzQaxc/i6AC7mkZYZafE=;
        b=DcUAfx37pclwncupI3fDIhT4GD0u9fKNkMcasbZabFwnp34BT1xzOfO5lZcnN4ezZS
         TgvuDmqxCiLwu35HFXtDQsqlZoAMIyU2ye4PmdtZSQc374lAJdhxBOVnUHw0SUHiRroW
         f8+/L7OLtttw4wJrTGN0vHejoD2gz1lIjQzsrVNbtbvBe7IKGFbu+IRWZGh8kKqvrZeI
         niHvHOLH2Ux2UlSmVNBT+nin8qTWjQ0ydUwxYW1VBR6Lzvs6sjGHoklRkiZN8q7z+3db
         qCY7B1Omqms7k2spLd1ZrGvOIPndnVgrYjUIsgiORvKOK6ihAl0PXgZKrUAd5V9l7oFG
         W1pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790180182; x=1790784982;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8lwL4K1D0LmNyg6j112+oM7NzQaxc/i6AC7mkZYZafE=;
        b=XnCYhIKZgnzqNt4GRkTXVDerhMXJWSJX45fUpXb+Otb2FENCU+U5sXyxXOo1fCFkLk
         yf4Uw89yXC6sFJH2OUVDH4x+g/FgDC3LOOMQKIbFcYHxc2CaH23PpVHFAoZqTHqxsbML
         f4UTiYAXAeuKx7cStGdn7tCMdceDiZE8ScxH5mNrD1SFubAziRt7ve7icd+Ar2XOlUT8
         p9KldNnNT5PATr+EY1XQUIDGjnEkyvfBtz5m9sggzw0dPalw1soep9EgZ9JCXlDo+Fp2
         aRHLKKIb0A4wijU88eUhJVr6wTOhOBGTY9Hi4FFFfLhsFlLmZO25byiTafKytu4LFW7c
         V/cQ==
X-Forwarded-Encrypted: i=1; AKwUvBzjDa8RtZ5AWp08bnuV28l2QgvzwqXkD4gOh9PIEHd1mUGmh3qwt37DD/jAALpQkKZcMDzFKV5W8Wkj@vger.kernel.org
X-Gm-Message-State: AFuF++l+lV9qvdROjiadsygT22E9EC6RguJckQL3GPgKp6QUSfGBYJDj
	gYqh1O/IGRHJq0JR3PTP1f6YIsKRtRYnqm93/XjrLlUbN67gVc5WK+a9lZdc0GsZsGAdDL6Fvdz
	jzBbfZFrE59Ap6ER2aRLiXHxZNbbZLA7d02oSU+V7Y6CzC2lU//qcPDAdcusW0Tz/dKN6cmeFrN
	3SboOyh6I/shOtb6SJARYWIhEzxJndqKt7OtbjnBXWifGT4h2mmQA=
X-Gm-Gg: AYBFou1YKFGTGteMoIMheTqbHiElyTKzHoYHK1xo9Pv4zhoKCw4VgdBbFiJ1MsgobiR
	LNkDUTpJIw3BeyHCdPhA7VyjBc6WEMRijZO+QlG+b/JE6XJdcyIOh8CTE3S4OnbakeQPWp1jgDL
	AiN89DPbYMHTmtNr1XO2TUTu88PMLkcI5zasK5T27pgShekWVD6IO8bPV0tw+GZVX9PiPV7zOzc
	iL0ZlpentaH+UcVpQ==
X-Received: by 2002:a05:600c:8b11:b0:49f:ce72:e931 with SMTP id 5b1f17b1804b1-49fdf252adfmr50312605e9.35.1790180182289;
        Wed, 23 Sep 2026 09:16:22 -0700 (PDT)
X-Received: by 2002:a05:600c:8b11:b0:49f:ce72:e931 with SMTP id
 5b1f17b1804b1-49fdf252adfmr50311885e9.35.1790180181802; Wed, 23 Sep 2026
 09:16:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260902200547.184734-1-jtaubepe@redhat.com> <20260902200547.184734-8-jtaubepe@redhat.com>
 <ab97f32b-31dd-4975-a8b2-b445110ae3a9@suse.de> <CADRr4bePoiDnWX_XrMWtQe=1g4Yrw1_dK86EV2k9XZR0HnL+UQ@mail.gmail.com>
 <d4879e78-2735-4f86-beab-8aa319e9162c@suse.de>
In-Reply-To: <d4879e78-2735-4f86-beab-8aa319e9162c@suse.de>
From: Jesse Taube <jtaubepe@redhat.com>
Date: Wed, 23 Sep 2026 12:16:10 -0400
X-Gm-Features: AclHuK_OOO2Lx5nkFexAXjVTognXDMI5Nb3PQa0tcoQZ7jw26Edo1LYB-gBX5kg
Message-ID: <CADRr4bcSvLwzfSiV0LTxnhZR7oo3F1b2XEo+wwqi668Gr2BBQA@mail.gmail.com>
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

On Wed, Sep 23, 2026 at 11:34=E2=80=AFAM Hannes Reinecke <hare@suse.de> wro=
te:
>
> On 9/23/26 4:56 PM, Jesse Taube wrote:
> > On Mon, Sep 21, 2026 at 10:03=E2=80=AFAM Hannes Reinecke <hare@suse.de>=
 wrote:
> >>
> >> On 9/2/26 10:05 PM, Jesse Taube wrote:
> >>> To allow testing of multipath failover, add a sysfs attribute to set =
a
> >>> remote port as marginal. This will allow the fcloop LLDD to set the
> >>> marginal flag on a remote port, simulating a marginal link.
> >>>
> >>> Example:
> >>> Turn on marginal for a remote port matching wwnn and wwpn:
> >>> `echo 'wwnn=3D0x200000109b5f2956,wwpn=3D0x100000109b5f2956,marginal=
=3D1' >
> >>> /sys/class/fcloop/ctl/set_marginal_rport`
> >>>
> >>> Turn off marginal for a remote port matching wwnn and wwpn:
> >>> `echo 'wwnn=3D0x200000109b5f2956,wwpn=3D0x100000109b5f2956,marginal=
=3D0' >
> >>> /sys/class/fcloop/ctl/set_marginal_rport`
> >>>
> >>> Suggested-by: John Meneghini <jmeneghi@redhat.com>
> >>> Signed-off-by: Jesse Taube <jtaubepe@redhat.com>
> >>> V10 -> V1:
> >>>    - New patch
> >>> V1 -> V2:
> >>>    - Fix reference count leak in error path
> >>> ---
> >>>    drivers/nvme/target/fcloop.c | 50 ++++++++++++++++++++++++++++++++=
++++
> >>>    1 file changed, 50 insertions(+)
> >>>
> >>> diff --git a/drivers/nvme/target/fcloop.c b/drivers/nvme/target/fcloo=
p.c
> >>> index b63af3b643a6..9977c2a71bd5 100644
> >>> --- a/drivers/nvme/target/fcloop.c
> >>> +++ b/drivers/nvme/target/fcloop.c
> >>> @@ -6,6 +6,7 @@
> >>>    #include <linux/module.h>
> >>>    #include <linux/parser.h>
> >>>    #include <uapi/scsi/fc/fc_fs.h>
> >>> +#include <uapi/scsi/fc/fc_els.h>
> >>>
> >>>    #include "../host/nvme.h"
> >>>    #include "../target/nvmet.h"
> >>> @@ -21,6 +22,7 @@ enum {
> >>>        NVMF_OPT_FCADDR         =3D 1 << 3,
> >>>        NVMF_OPT_LPWWNN         =3D 1 << 4,
> >>>        NVMF_OPT_LPWWPN         =3D 1 << 5,
> >>> +     NVMF_OPT_MARGINAL       =3D 1 << 6,
> >>>    };
> >>>
> >>>    struct fcloop_ctrl_options {
> >>> @@ -31,6 +33,7 @@ struct fcloop_ctrl_options {
> >>>        u32                     fcaddr;
> >>>        u64                     lpwwnn;
> >>>        u64                     lpwwpn;
> >>> +     u32                     marginal;
> >>>    };
> >>>
> >>>    static const match_table_t opt_tokens =3D {
> >>> @@ -40,6 +43,7 @@ static const match_table_t opt_tokens =3D {
> >>>        { NVMF_OPT_FCADDR,      "fcaddr=3D%x"     },
> >>>        { NVMF_OPT_LPWWNN,      "lpwwnn=3D%s"     },
> >>>        { NVMF_OPT_LPWWPN,      "lpwwpn=3D%s"     },
> >>> +     { NVMF_OPT_MARGINAL,    "marginal=3D%d"   },
> >>>        { NVMF_OPT_ERR,         NULL            }
> >>>    };
> >>>
> >>> @@ -120,6 +124,13 @@ fcloop_parse_options(struct fcloop_ctrl_options =
*opts,
> >>>                        }
> >>>                        opts->lpwwpn =3D token64;
> >>>                        break;
> >>> +             case NVMF_OPT_MARGINAL:
> >>> +                     if (match_int(args, &token)) {
> >>> +                             ret =3D -EINVAL;
> >>> +                             goto out_free_options;
> >>> +                     }
> >>> +                     opts->marginal =3D token;
> >>> +                     break;
> >>>                default:
> >>>                        pr_warn("unknown parameter or missing value '%=
s'\n", p);
> >>>                        ret =3D -EINVAL;
> >>> @@ -199,6 +210,9 @@ fcloop_parse_nm_options(struct device *dev, u64 *=
nname, u64 *pname,
> >>>
> >>>    #define TGTPORT_OPTS        (NVMF_OPT_WWNN | NVMF_OPT_WWPN)
> >>>
> >>> +#define MARGINAL_OPTS        (NVMF_OPT_WWNN | NVMF_OPT_WWPN | \
> >>> +                      NVMF_OPT_MARGINAL)
> >>> +
> >>>
> >>>    static DEFINE_SPINLOCK(fcloop_lock);
> >>>    static LIST_HEAD(fcloop_lports);
> >>> @@ -1663,6 +1677,40 @@ fcloop_set_cmd_drop(struct device *dev, struct=
 device_attribute *attr,
> >>>        return count;
> >>>    }
> >>>
> >>> +static ssize_t
> >>> +fcloop_set_marginal_rport(struct device *dev, struct device_attribut=
e *attr,
> >>> +             const char *buf, size_t count)
> >>> +{
> >>> +     struct fcloop_nport *nport;
> >>> +     struct fcloop_ctrl_options opts =3D {};
> >>> +     unsigned long flags;
> >>> +     int ret;
> >>> +
> >>> +     ret =3D fcloop_parse_options(&opts, buf);
> >>> +     if (ret)
> >>> +             return ret;
> >>> +
> >>> +     /* everything there ? */
> >>> +     if ((opts.mask & MARGINAL_OPTS) !=3D MARGINAL_OPTS)
> >>> +             return -EINVAL;
> >>> +
> >>> +     nport =3D fcloop_nport_lookup(opts.wwnn, opts.wwpn);
> >>> +     if (!nport)
> >>> +             return -ENOENT;
> >>> +
> >>> +     spin_lock_irqsave(&fcloop_lock, flags);
> >>> +     if (!nport->rport || !nport->rport->remoteport) {
> >>> +             spin_unlock_irqrestore(&fcloop_lock, flags);
> >>> +             fcloop_nport_put(nport);
> >>> +             return -ENOENT;
> >>> +     }
> >>> +
> >>> +     nvme_fc_set_remoteport_fpin(nport->rport->remoteport, opts.marg=
inal);
> >>> +     spin_unlock_irqrestore(&fcloop_lock, flags);
> >>> +     fcloop_nport_put(nport);
> >>> +
> >>> +     return count;
> >>> +}
> >>>
> >>>    static DEVICE_ATTR(add_local_port, 0200, NULL, fcloop_create_local=
_port);
> >>>    static DEVICE_ATTR(del_local_port, 0200, NULL, fcloop_delete_local=
_port);
> >>> @@ -1671,6 +1719,7 @@ static DEVICE_ATTR(del_remote_port, 0200, NULL,=
 fcloop_delete_remote_port);
> >>>    static DEVICE_ATTR(add_target_port, 0200, NULL, fcloop_create_targ=
et_port);
> >>>    static DEVICE_ATTR(del_target_port, 0200, NULL, fcloop_delete_targ=
et_port);
> >>>    static DEVICE_ATTR(set_cmd_drop, 0200, NULL, fcloop_set_cmd_drop);
> >>> +static DEVICE_ATTR(set_marginal_rport, 0200, NULL, fcloop_set_margin=
al_rport);
> >>>
> >>>    static struct attribute *fcloop_dev_attrs[] =3D {
> >>>        &dev_attr_add_local_port.attr,
> >>> @@ -1680,6 +1729,7 @@ static struct attribute *fcloop_dev_attrs[] =3D=
 {
> >>>        &dev_attr_add_target_port.attr,
> >>>        &dev_attr_del_target_port.attr,
> >>>        &dev_attr_set_cmd_drop.attr,
> >>> +     &dev_attr_set_marginal_rport.attr,
> >>>        NULL
> >>>    };
> >>>
> >> Please don't make it a fabrics option.
> >
> > What do you mean by fabrics option? How should I fix this?
> >
> Your patch does two things; one is to modify the parser in
> fcloop_parse_options, and the other is to implement a new
> sysfs rport attribute 'set_marginal_rport()'.
> My suggestion is to drop the first part;

You want to drop the parser?

> we really should not start off
> with a marginal port, rather only set ports to marginal during runtime.

Yes it starts as not marginal and will only be set or unset
with a write to `set_marginal_rport` during runtime.

Thanks,
Jesse Taube

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

