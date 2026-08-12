Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E059F33B97B
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 18:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786559675; cv=pass; b=RL2gL9syg3jLrp7FetyqZjNoFjg7jwEPoItfPeC1EKa+Iufm8HaYFI9Syh2pHEGXAj2W6e+yjZ4KWbd4RND9dYaQDlbA+Bwtor6GmQgIbPmGujeuCS2RR9eScvdONDisz9OAJlybTLuW4/zxRtmCFQ8CzcUbFKtKBgWozt0RcqI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786559675; c=relaxed/simple;
	bh=mRkp7nH+WFr3P+SbBSX3xPEKXd4InV7SXb1U2Tk+3l8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cSqRv7NZ9pcqX8YL9F3lVFmAsgB1E86X1z3ymcK95/4M2r99jyBvn3Y7+oS+3Uci9UWOCTDSU5TGWwU6DGWIynufy9dRUTK8Bs1HnNQPkYghpg/1OFK5eOCJO/kiMJIPA7TiUumONy+b6loogsAtZWhnEpwbvaQv1RPA7XAHeQU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f/WL461E; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=jPVgkAKW; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f/WL461E";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="jPVgkAKW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786559672;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d8ydX2OpIcKxMSr0OhxO7ClOo6XDEYK4Z+XCSqRZD7E=;
	b=f/WL461ExGh8Z9grR14ZUxr14QjhIeW8I0NPrXF8h9sE4TOrGFGamiY1SHoQsBsFhf+ojk
	/EVUeG8yBjGwXj9yvLs2JEdxPHIYII94V4uwAFHEgjpSZ+YcF3mkdQP7pt3BasDwXxtkLP
	Ah9jAvRGr7/7aEKtQidvRJmUs0Xjd7g=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-679-OgecVaO5OCyqdJ9HG8nezw-1; Wed, 12 Aug 2026 14:34:21 -0400
X-MC-Unique: OgecVaO5OCyqdJ9HG8nezw-1
X-Mimecast-MFC-AGG-ID: OgecVaO5OCyqdJ9HG8nezw_1786559661
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-47faa02f707so119338f8f.1
        for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 11:34:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786559661; cv=none;
        d=google.com; s=arc-20260327;
        b=kBQrztLK3STiR3csTVHr/gTSt5bLCuF097+XAdyo2tqfvbEhw8q9H+IhZOz9xipMm5
         9o6DRyba1gaZ/Vht50YweApYpYFe5L0CerAVQwpysgKDYrysyk/V+uv7/TQKrUFIJEal
         SCuVQ+twyExDazGgkFcJ0lg9+/WaJtA8+eXXfLwU0EkSdN047XgYpN/J8Z5y+F2df6Ts
         frcmlJBnivdZU22BIzzvVSXLC0sOtQ/ZkipWVq1MP0KR7pJKQF3+osN40LUv2xcccdAw
         6xY2czg+1cpei60yEMxbiWKOM9YBSs9igYAGufh6C5cTQEF8G5XqpEOXVlwjWylI94wl
         0myQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=d8ydX2OpIcKxMSr0OhxO7ClOo6XDEYK4Z+XCSqRZD7E=;
        fh=31r+tUQZiFurxavsCe+ZG1UD1QR/HV3ehGQxCkgoicU=;
        b=aG7oNpBH32uw7nRDdberMfSafXICqSfk65y+EoMS3m2Kk03MrmVPnlS7iC2zBvmUWo
         myp2gWsgoDFO7xIThMt0Rb3A3WcfuGbKxsqW3Z2XBfHbEiLHc9/hPDpibRo6MJs8K59F
         Sdtlno6JcxI+qmo982XWaJCDVUSSqXb5fr4pFihHWotMaPX3+VdyifarL1FEAo1mZNYr
         lkSlnegE4haG/EpCAzN2eWKN+T8oF3Pc+r7IUn4+Y1bUGoS1oa+2uCG0EsFzG4F2yXU8
         j3or1j9AnUJm4sRistxn6ebul5T50Lxltk1eKisgNY5h0uc4JXiTYQ7UZMjgJ5j6ePSr
         UEMw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786559661; x=1787164461; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=d8ydX2OpIcKxMSr0OhxO7ClOo6XDEYK4Z+XCSqRZD7E=;
        b=jPVgkAKWQsDB7J6PdoPdCg/bZfmzk7V9Cihg6wMLHGxSE3kqIy2nnwNbsThYiqbxp0
         bOMe1lJNtro+hvlMc6LNWkp3NmXI22xLbuYzJhpOm8ns0bKx4CJUJ6PpXMneWBB5kbTp
         ZV80WXGuRICCQ+MZ86+JgRkWSIp9yjlvWXtfklUkdd0FkbBuVQuns+diA1L0s7U0mCYZ
         Ww4begyN7pqlegGYPEuBvnIjok0frQb9d84h2ZuCTHmuVvF1b2xdTEw8JlHqE3Qfzaey
         hzAROlVPlPWcpvgOTXfQfSTVAferAfUPWHQVQAmKzQEZ8x7OZtxuMbRpyiKdwmNznJVz
         z/bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786559661; x=1787164461;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d8ydX2OpIcKxMSr0OhxO7ClOo6XDEYK4Z+XCSqRZD7E=;
        b=mwgLH5CaipgEBajMEgBVDULmKcGma/qdb4sC2BK8XEauOLd/DxDrTB9ZTnWmCe3DMx
         oFK/Ama8IUuKsQ5doUrpob8J2RB9b0NSa5s0jAQqFcXTGcspjt7bm/4MM5ui+U+2MQw4
         Kaa9xPeHaTFfU5roT3zrGDC6pIADkd1NKF90Sd7OoAJqLjGBDx8Do4NB5Nh5IQA83+Ha
         3Kk+Cgi8JBY7DJwNkExhlgQ3UMRoP1uV15pVTRTahztUAc6fM7QY8nbrRVyEh/3AC64D
         G3cRvY73IzI3EFvW3+5NUszWAxYFBBF51BzeDyfZkZVQqlt2mnAUIHMVb1J5Hpj4fxbr
         m3Tw==
X-Gm-Message-State: AOJu0YxKq4ODhbqRvLKucaxsc1qeSIZaY52Phxx76nl3P1Wy/lCts6zu
	Z1peJWyQK0eTQBXnCCDVcdneiqT+/6ipFEoFqPN6sIQSDdH6nXgEOhGE8C1ucIWwM3beLtQZJu/
	20QDnmRJJHigsGBg4C/emUCuWJso2gQ4r9wPDM5mwoXmZa/Km2hTgy06xxI+ts6GGuZE1gAP8al
	viOx/21oW0u3DTeXuzejdevGjipFCQd0ytf7s8b8TEYkp9d5jy
X-Gm-Gg: AR+sD10yr+aha7GyQj64CkCNfBbmdSvqy3lc7+EnlVFIM+LWtqKkFwBnBqU0xQiEUNJ
	ajXpW8JuGnJE3GYnga8bF8DQ5+oSj9N8wIDWk9cJQRvm1ntjrfkiiyBnt/9NW+BP2DlVKfpv7M2
	Z1zMkshKxY5cLbzDsijw0KWPSVuVlFfXcODN4VR9ueAzuE5HQdcGHggzintH9AylQsmrFFO0CR6
	Cpzn/uvN0/6ES+X1g==
X-Received: by 2002:a05:6000:290a:b0:46b:70db:2113 with SMTP id ffacd0b85a97d-48158ad6652mr2148850f8f.0.1786559660613;
        Wed, 12 Aug 2026 11:34:20 -0700 (PDT)
X-Received: by 2002:a05:6000:290a:b0:46b:70db:2113 with SMTP id
 ffacd0b85a97d-48158ad6652mr2148799f8f.0.1786559660257; Wed, 12 Aug 2026
 11:34:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260812181300.3712426-1-jtaubepe@redhat.com> <20260812181300.3712426-13-jtaubepe@redhat.com>
In-Reply-To: <20260812181300.3712426-13-jtaubepe@redhat.com>
From: Jesse Taube <jtaubepe@redhat.com>
Date: Wed, 12 Aug 2026 14:34:08 -0400
X-Gm-Features: AUfX_myZY21EEprqaxNYcSxFP1Y9sT2Pt-FYKifeAT1wL4eNerhDK3vKjui8tng
Message-ID: <CADRr4bf4orxm9=jCAj7EYXKVK7Nm3bgGCfjaDLztRiR2pXnJFw@mail.gmail.com>
Subject: Re: [PATCH 12/13] nvme: fcloop: Add set_rport_marginal to sysfs
To: linux-scsi@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, 
	Sagi Grimberg <sagi@grimberg.me>, Naresh Gottumukkala <nareshgottumukkala83@gmail.com>, 
	Paul Ely <paul.ely@broadcom.com>, Chaitanya Kulkarni <kch@nvidia.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Nilesh Javali <njavali@marvell.com>, 
	GR-QLogic-Storage-Upstream@marvell.com, Hannes Reinecke <hare@suse.de>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, John Meneghini <jmeneghi@redhat.com>, 
	Bryan Gurney <bgurney@redhat.com>, Chris Leech <cleech@redhat.com>, 
	"Ewan D . Milne" <emilne@redhat.com>, shinichiro.kawasaki@wdc.com, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-block@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 12, 2026 at 2:14=E2=80=AFPM Jesse Taube <jtaubepe@redhat.com> w=
rote:
>
> To allow testing of multipath failover, add a sysfs attribute to set a
> remote port as marginal. This will allow the fcloop LLDD to set the
> marginal flag on a remote port, simulating a marginal link.
>
> Example:
> Turn on marginal for a remote port matching wwnn and wwpn:
> `echo 'wwnn=3D0x200000109b5f2956,wwpn=3D0x100000109b5f2956,marginal=3D1' =
>
> /sys/class/fcloop/ctl/set_rport_marginal`
>
> Turn off marginal for a remote port matching wwnn and wwpn:
> `echo 'wwnn=3D0x200000109b5f2956,wwpn=3D0x100000109b5f2956,marginal=3D0' =
>
> /sys/class/fcloop/ctl/set_rport_marginal`
>
> Suggested-by: John Meneghini <jmeneghi@redhat.com>
> Signed-off-by: Jesse Taube <jtaubepe@redhat.com>
> V10 -> V11
>  - New patch
> ---
>  drivers/nvme/target/fcloop.c | 41 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 41 insertions(+)
>
> diff --git a/drivers/nvme/target/fcloop.c b/drivers/nvme/target/fcloop.c
> index b63af3b643a6..51a50743128d 100644
> --- a/drivers/nvme/target/fcloop.c
> +++ b/drivers/nvme/target/fcloop.c
> @@ -6,6 +6,7 @@
>  #include <linux/module.h>
>  #include <linux/parser.h>
>  #include <uapi/scsi/fc/fc_fs.h>
> +#include <uapi/scsi/fc/fc_els.h>
>
>  #include "../host/nvme.h"
>  #include "../target/nvmet.h"
> @@ -21,6 +22,7 @@ enum {
>         NVMF_OPT_FCADDR         =3D 1 << 3,
>         NVMF_OPT_LPWWNN         =3D 1 << 4,
>         NVMF_OPT_LPWWPN         =3D 1 << 5,
> +       NVMF_OPT_MARGINAL       =3D 1 << 6,
>  };
>
>  struct fcloop_ctrl_options {
> @@ -31,6 +33,7 @@ struct fcloop_ctrl_options {
>         u32                     fcaddr;
>         u64                     lpwwnn;
>         u64                     lpwwpn;
> +       u32                     marginal;
>  };
>
>  static const match_table_t opt_tokens =3D {
> @@ -40,6 +43,7 @@ static const match_table_t opt_tokens =3D {
>         { NVMF_OPT_FCADDR,      "fcaddr=3D%x"     },
>         { NVMF_OPT_LPWWNN,      "lpwwnn=3D%s"     },
>         { NVMF_OPT_LPWWPN,      "lpwwpn=3D%s"     },
> +       { NVMF_OPT_MARGINAL,    "marginal=3D%d"   },
>         { NVMF_OPT_ERR,         NULL            }
>  };
>
> @@ -120,6 +124,13 @@ fcloop_parse_options(struct fcloop_ctrl_options *opt=
s,
>                         }
>                         opts->lpwwpn =3D token64;
>                         break;
> +               case NVMF_OPT_MARGINAL:
> +                       if (match_int(args, &token)) {
> +                               ret =3D -EINVAL;
> +                               goto out_free_options;
> +                       }
> +                       opts->marginal =3D token;
> +                       break;
>                 default:
>                         pr_warn("unknown parameter or missing value '%s'\=
n", p);
>                         ret =3D -EINVAL;
> @@ -199,6 +210,9 @@ fcloop_parse_nm_options(struct device *dev, u64 *nnam=
e, u64 *pname,
>
>  #define TGTPORT_OPTS   (NVMF_OPT_WWNN | NVMF_OPT_WWPN)
>
> +#define MARGINAL_OPTS  (NVMF_OPT_WWNN | NVMF_OPT_WWPN | \
> +                        NVMF_OPT_MARGINAL)
> +
>
>  static DEFINE_SPINLOCK(fcloop_lock);
>  static LIST_HEAD(fcloop_lports);
> @@ -1663,6 +1677,31 @@ fcloop_set_cmd_drop(struct device *dev, struct dev=
ice_attribute *attr,
>         return count;
>  }
>
> +static ssize_t
> +fcloop_set_marginal_rport(struct device *dev, struct device_attribute *a=
ttr,
> +               const char *buf, size_t count)
> +{
> +       struct fcloop_nport *nport;
> +       struct fcloop_ctrl_options opts;
> +       int ret;
> +
> +       ret =3D fcloop_parse_options(&opts, buf);
> +       if (ret)
> +               return ret;
> +
> +       /* everything there ? */
> +       if ((opts.mask & MARGINAL_OPTS) !=3D MARGINAL_OPTS)
> +               return -EINVAL;
> +
> +       nport =3D fcloop_nport_lookup(opts.wwnn, opts.wwpn);
> +       if (!nport || !nport->tport || !nport->tport->remoteport)
> +               return -ENOENT;
> +
> +       nvme_fc_set_remoteport_fpin(nport->tport->remoteport, opts.margin=
al);
> +       fcloop_nport_put(nport);
> +
> +       return count;
> +}
>
>  static DEVICE_ATTR(add_local_port, 0200, NULL, fcloop_create_local_port)=
;
>  static DEVICE_ATTR(del_local_port, 0200, NULL, fcloop_delete_local_port)=
;
> @@ -1671,6 +1710,7 @@ static DEVICE_ATTR(del_remote_port, 0200, NULL, fcl=
oop_delete_remote_port);
>  static DEVICE_ATTR(add_target_port, 0200, NULL, fcloop_create_target_por=
t);
>  static DEVICE_ATTR(del_target_port, 0200, NULL, fcloop_delete_target_por=
t);
>  static DEVICE_ATTR(set_cmd_drop, 0200, NULL, fcloop_set_cmd_drop);
> +static DEVICE_ATTR(set_marginal_rport, 0200, NULL, fcloop_set_marginal_r=
port);

Checkpatch is complaining about:
Consider renaming function(s) 'fcloop_set_marginal_rport' to
'set_marginal_rport_store'
I dont think deviating from the existing naming scheme to appease
checkpatch is a good idea though.

Thanks,
Jesse Taube

>
>  static struct attribute *fcloop_dev_attrs[] =3D {
>         &dev_attr_add_local_port.attr,
> @@ -1680,6 +1720,7 @@ static struct attribute *fcloop_dev_attrs[] =3D {
>         &dev_attr_add_target_port.attr,
>         &dev_attr_del_target_port.attr,
>         &dev_attr_set_cmd_drop.attr,
> +       &dev_attr_set_marginal_rport.attr,
>         NULL
>  };
>
> --
> 2.54.0
>

