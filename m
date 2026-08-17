Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4033ABD99
	for <linux-scsi@vger.kernel.org>; Mon, 17 Aug 2026 14:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975453; cv=pass; b=J3/TuxYh3IF2XS+3EtmQdMMvX6Ts64prb4tjFcZMMm8MgSztSfSmXV2PkDP+Ns3Est4MrjG6OZJ1z0z2PUdSqRI6OUuMnaa8NTJmZckbqIQhYU74nIE+LqZefTnn1t6GJeTQY5EHMCrsCZndmSHS1f+9f0qIAEvVutvCdKwBXhI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975453; c=relaxed/simple;
	bh=2FVR51YYSzXBEz4cHV81SklxODFeut4QjmvjYChhQJg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N7Wsubu9zFx2KuYEwr5NgEa/ra2cJxGLcC6LfBpggeeaiYV1CtgswZEbUEetVwWle6qXs0ERLiNsc8DSA6GPCs4SiqtMSJ3l7LlBCBqLB+CNpTpwbzKf1KWLB3eoJ9X+1cdaI3J9V3manzx+RBMEv9HNWVOSwVYf81vFUjMayy8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OYYNHXP+; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=OvyQL4Vq; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OYYNHXP+";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="OvyQL4Vq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786975450;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pLzFhErDKqfPJHE0H6OtFPW+m0QP1y3pLi+ryPdDuiI=;
	b=OYYNHXP+JaOOrUw4N+JiVl+xx6qK8rhSKG2yFnbeb0dmGOjCUgsD+fqN09fwmZgeDqgYOa
	Fq46ynFDfRnw9EzduY+1KFM0hIMDp3jpEUHFpZFOmpzOVHSvn1xYFzvWi3FYgkV2oSXnh6
	4QXPiRQGv/W48MOkHUmR4s8+Zp4tUc4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-173-632AsQSUNjGNpCX186Dtig-1; Mon, 17 Aug 2026 10:04:08 -0400
X-MC-Unique: 632AsQSUNjGNpCX186Dtig-1
X-Mimecast-MFC-AGG-ID: 632AsQSUNjGNpCX186Dtig_1786975447
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-47f2de3ba47so2262784f8f.1
        for <linux-scsi@vger.kernel.org>; Mon, 17 Aug 2026 07:04:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786975447; cv=none;
        d=google.com; s=arc-20260327;
        b=RGJ4b0vE0V7ZZeZYMM4HPXn/OBNVXNf6GpYhrlwNFGancOaGvAGMKGo7f7DF3RNACN
         4j+L9vdTrPMdwwMuWArtMTS7w7KLpKGBgA+GLT3lBMw8oOONZ7iKP1tHrhdIC/Jw7TXg
         /o6EN/6oysL2NOFIAQdIL+/Q6yNCif5kdujAELWT7HTHI7RUBDxJvxkCPW4bqEyun83h
         rOI+L6ADQrwgMagNny5JjMudx+u+jrh2y5XbUO/aw//n2r31Vj0eF4Tn6yOM+7mfwois
         xMFl+rGJwyuJqhKIpFMh5BxqY2JhJlMZTYVCGn8PNiwCdt97uD8gNGBBiyP0jgb+ZedA
         eAGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pLzFhErDKqfPJHE0H6OtFPW+m0QP1y3pLi+ryPdDuiI=;
        fh=gUfsL9ppqjROwdjOOpA7gVU01au1qshFQ+BhECdF0Kg=;
        b=O8/XIziLM+/T/Ee0wK07bvaIolAB/GYf3U3ND/r3Uj/9O/EmeqLkwKFIi/a2QJruaZ
         FSGxLEsEK/WQh4Yn3XzTQ6af7S81KAScqnWhrMqY43xv+Q2eV3yuAhWtOKE8KCPsNlaP
         ycZtzkflk/QD5tbfDvlEH/zj6cRoOYi32C1Km3BmMKDhLyBK0XhrsPVPyKAEOCfaHwMh
         joEZtfVryuyWhWBkbs82vuUuWPy34goYsFSbXuANvHxLf+L9i8955qHUZOwFd9pIRu5q
         51q5Tw2woPmktFasopGP0oiUOeriX++ip99IO4LOUGEGHRpul5lZW8lmWvkIVuur1K7b
         wPjw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786975447; x=1787580247; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pLzFhErDKqfPJHE0H6OtFPW+m0QP1y3pLi+ryPdDuiI=;
        b=OvyQL4VqtURwLXLHDvoewgEQ8QRjeFKGa/DgbNN/ofNvANcMUdiBxXQvG1NQNlQojk
         zM97do5MDnCHcngTvVrzz3ZvjGOPWK9KdT5tT4EGFuvkPW1d/6y0Vshy7QPHoLpPITOt
         FglUT6tJpHDavKDFu3lbstcyLAmPQXcwKsSmHZBAa/1gteZO2A5I62Tb4YlbWSublXIe
         zeks4wtLVw61igaqAP8QH7sLoIJzgIdoUzCILntghL/QbPpWK7PChajMSN29koxAF6vZ
         aEeors6JdYr9FN14P3gBo2zVXk2Dp+UFKkQ3DPMOlFGZm7qnVlN2Tjle7uSv++UzYT+4
         esNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786975447; x=1787580247;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pLzFhErDKqfPJHE0H6OtFPW+m0QP1y3pLi+ryPdDuiI=;
        b=raup5SaNtJgCzRBR/2McgPNYLGIkrgQUcHGLsTxEj+GQe03Gv/UpbD2m9xG+G5nhTX
         QrqKN8bqf3gf+OQulFb3BDWQPpfYHMmFd8oSGUqQh4UwvLM7dRk9P27VLywd/7y54lea
         nq8nHquIzSpFBNJX+GIbVdSJpTqxAbiXFqKKYW9bmGs6atT6wRj2eqgB9FNVMw6tsgX+
         zdKFA0vsKFuvC64JrvxSV1y9+mC0wfB6YEucy7KuJ7UD7bhJunA7ke2h7Rwjamk5/opE
         r9KrilFFzr5DHVHUrZ5y6oo45/5r5pQMYqPO3H4/qZV8xLGWYSoHqV4iUIAhog0bCnol
         Yexw==
X-Gm-Message-State: AOJu0YxLz1qp0XTkxJjAj1NrUTplTGzMxIO5fJER/8vIKgTogNuGvyVH
	7NjTI+0jPUCt+Sj8K5uRStVNDEsMMRtME+XQuj/9MURwzJ4KsTAR4FJUXJWgDCkYbA8ayTgEo0l
	1Mn7vt/SIU6jbo+pDYFNzXVelSKzkXNMKQL33Gg/kjN0heHzAAysgCcM54T6QmgUTG1DG8rFUFC
	lDzKYDPf0w5YC7WwdKTkiDhLur4A3QYu+c0csBTw==
X-Gm-Gg: AR+sD12UnKth/IHZRyU7Y7bIEFDjWzbgkCc8ae91GVDS4RfcSCCB1OxlnL9QJwyBx5d
	zcYGKoB3ZiyDFbqsJi3k4X9Y2R1r3/6EuEetKb2NNCUu2kKPxqAGlVdTvDFyXGeBYPU6brm69a8
	A65hlgEK/WphnhdcZHLpXJWwOe7FShLioLfgW2LwkMEJqdrFQalRJ6zjNoR3jRO4zCUhnGaqSLQ
	ptoDFCzNmyRkkFhVQ==
X-Received: by 2002:a5d:588b:0:b0:47f:9568:ebf0 with SMTP id ffacd0b85a97d-4816076e5d6mr38279482f8f.23.1786975447284;
        Mon, 17 Aug 2026 07:04:07 -0700 (PDT)
X-Received: by 2002:a5d:588b:0:b0:47f:9568:ebf0 with SMTP id
 ffacd0b85a97d-4816076e5d6mr38279370f8f.23.1786975446778; Mon, 17 Aug 2026
 07:04:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260812181300.3712426-1-jtaubepe@redhat.com> <20260812181300.3712426-8-jtaubepe@redhat.com>
 <20260812182803.EDCB01F000E9@smtp.kernel.org>
In-Reply-To: <20260812182803.EDCB01F000E9@smtp.kernel.org>
From: Jesse Taube <jtaubepe@redhat.com>
Date: Mon, 17 Aug 2026 10:03:55 -0400
X-Gm-Features: AcwNN1XQZilVxlWK6QmM5kDZ3ZoOiemcQZ3TtC2mKTfU85MQnKHO6knMpufOG2U
Message-ID: <CADRr4beHoGtJXW_RFuHCESiRB3gmeGuyahStXNVwFS+Z2e5gdQ@mail.gmail.com>
Subject: Re: [PATCH 07/13] scsi: scsi_transport_fc: Add set_rport_marginal to fc_function_template
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 12, 2026 at 2:28=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 5 potential issu=
e(s) to consider:
>
> New issues:
> - [High] The primary affected port (`attach_rport`) in a Link Integrity e=
vent is excluded from being marked as marginal.
> - [High] NVMe targets are erroneously placed into the 'marginal' state du=
ring Peer Congestion (PC) events.
> - [High] The `set_rport_marginal` callback is not invoked when the margin=
al state is manually cleared or set via sysfs.
>
> Pre-existing issues:
> - [Critical] The `fc_rport` pointer returned by `fc_find_rport_by_wwpn` i=
s used without a reference count, leading to a Use-After-Free.
> - [Critical] Integer underflow in `fc_host_fpin_rcv` when `fpin_len` is s=
mall, leading to massive OOB read.
> --
>
> --- Patch [7]: [PATCH 07/13] scsi: scsi_transport_fc: Add set_rport_margi=
nal to fc_function_template ---
> commit 978d2e847b2a738287194acf215a8cbbe297f65a
> Author: Jesse Taube <jtaubepe@redhat.com>
>
> scsi: scsi_transport_fc: Add set_rport_marginal to fc_function_template
>
> Add fc_fpin_set_marginal function to evaluate the FPIN LI TLV
> information and set the 'marginal' path status for all
> affected nvme rports. Then call set_rport_marginal() callback added
> to fc_function_template.
>
> The implementation of set_rport_marginal() is almost identical to
> set_rport_dev_loss_tmo implementation.
>
> > diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_trans=
port_fc.c
> > index 02c58f4591d83..df1edf3c23fa8 100644
> > --- a/drivers/scsi/scsi_transport_fc.c
> > +++ b/drivers/scsi/scsi_transport_fc.c
> > @@ -737,6 +737,25 @@ fc_cn_stats_update(u16 event_type, struct fc_fpin_=
stats *stats)
> >       }
> >  }
> >
> > +static void fc_fpin_set_marginal(struct Scsi_Host *shost, struct fc_rp=
ort *rport)
> > +{
> > +     struct fc_internal *i =3D to_fc_internal(shost->transportt);
> > +     unsigned long flags;
> > +
> > +     spin_lock_irqsave(shost->host_lock, flags);
> > +
> > +     if (rport->port_state =3D=3D FC_PORTSTATE_ONLINE &&
> > +         rport->roles & FC_PORT_ROLE_NVME_TARGET) {
> > +             rport->port_state =3D FC_PORTSTATE_MARGINAL;
> > +             spin_unlock_irqrestore(shost->host_lock, flags);
> > +             if (i->f->set_rport_marginal)
> > +                     i->f->set_rport_marginal(rport, true);
>
> [Severity: Critical]
> This is a pre-existing issue, but does passing this rport pointer out to =
the
> driver callback outside of the lock risk a use-after-free?

Yes, the solution would be to move the lock to after set_rport_marginal, bu=
t
this holds a lock over a driver callback is not ideal. fc_rport does not ha=
ve a
lock either, so this is also not possible. The solution is to let the
driver callback
check. There is also a Time of use time of check issue here with port_state
which can also be solved like this.

>
> The rport pointer passed into fc_fpin_set_marginal() is retrieved by
> fc_find_rport_by_wwpn(). Looking at fc_find_rport_by_wwpn(), it returns t=
he
> pointer without incrementing its reference count (e.g., via get_device())=
.
>
> If a concurrent fc_remote_port_delete() runs, the rport memory could be
> freed as soon as the internal list lock is dropped. When the host_lock is
> dropped here, the unreferenced rport pointer is then passed to
> set_rport_marginal(), potentially dereferencing freed memory.
>
> > +             return;
> > +     }
> > +
> > +     spin_unlock_irqrestore(shost->host_lock, flags);
> > +}
> > +
> >  static void
> >  fc_fpin_pname_stats_update(struct Scsi_Host *shost,
> >                          struct fc_rport *attach_rport, u16 event_type,
> > @@ -764,6 +783,7 @@ fc_fpin_pname_stats_update(struct Scsi_Host *shost,
> >                       if (rport =3D=3D attach_rport)
> >                               continue;
> >                       stats_update(event_type, &rport->fpin_stats);
> > +                     fc_fpin_set_marginal(shost, rport);
>
> [Severity: High]
> Does this continue statement unintentionally bypass the newly added
> fc_fpin_set_marginal() call for the primary attach_rport?

This is intentional; only pnames should be updated.

>
> When a Link Integrity FPIN is processed via fc_fpin_li_stats_update(), it
> locates the attach_rport and passes it to fc_fpin_pname_stats_update().
> Because of this continue, the primary port experiencing the Link Integrit=
y
> failure won't be transitioned to the marginal state.
>
> [Severity: High]
> Will this also place NVMe targets into the marginal state during Peer
> Congestion (PC) events?

Yes, will fix.

>
> fc_fpin_peer_congn_stats_update() processes Peer Congestion events by
> calling fc_fpin_pname_stats_update(). Since fc_fpin_set_marginal() is now
> called unconditionally here, it seems ports involved in transient congest=
ion
> events might be incorrectly marked as marginal, potentially causing
> unwarranted path failovers.
>
> >               }
> >       }
> >  }
> > diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_trans=
port_fc.h
> > index 9f30625aa0d30..bc7c3f8323992 100644
> > --- a/include/scsi/scsi_transport_fc.h
> > +++ b/include/scsi/scsi_transport_fc.h
> > @@ -684,6 +684,7 @@ struct fc_host_attrs {
> >  struct fc_function_template {
> >       void    (*get_rport_dev_loss_tmo)(struct fc_rport *);
> >       void    (*set_rport_dev_loss_tmo)(struct fc_rport *, u32);
> > +     void    (*set_rport_marginal)(struct fc_rport *rport, bool margin=
al);
>
> [Severity: High]
> Should this callback also be invoked when the marginal state is manually
> cleared or set via sysfs?

No, the AI clearly doesn't understand the code.

>
> When a user writes 'Online' to the port_state sysfs attribute, it calls
> fc_rport_set_marginal_state() which modifies rport->port_state, but it do=
es
> not call this new set_rport_marginal() callback.
>
> Will this leave the Low-Level Device Driver (LLDD) permanently out of syn=
c
> with the transport class state when a path is recovered manually?
>
> >
> >       void    (*get_starget_node_name)(struct scsi_target *);
> >       void    (*get_starget_port_name)(struct scsi_target *);
>
> [Severity: Critical]
> This is a pre-existing issue,

 pre-existing issue will not fix.

> but is there an integer underflow in
> fc_host_fpin_rcv() when fpin_len is small?
>
> In fc_host_fpin_rcv(), bytes_remain is calculated without validating that
> fpin_len is large enough:
>
>     bytes_remain =3D fpin_len - offsetof(struct fc_els_fpin, fpin_desc);
>     bytes_remain =3D min_t(u32, bytes_remain, be32_to_cpu(fpin->desc_len)=
);
>
> Since offsetof(struct fc_els_fpin, fpin_desc) is 8, if an FPIN payload is
> received with fpin_len < 8, the subtraction underflows to a massive u32
> value. The parsing loop will then read well past the end of fpin_buf,
> causing an out-of-bounds read.
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260812181300.37=
12426-1-jtaubepe@redhat.com?part=3D7
>

