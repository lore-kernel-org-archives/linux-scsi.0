Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985BC302753
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 15:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784303147; cv=pass; b=s9LEe1c8MKojYBoGfcsKq6rziWftmfcXHWESsZmCXJ1kTbYKSyyCxgBsnftz9rL8DCFF1myjHIkTk02szTcjFlHoyyAx/N/j9ZE/t46fE2JiTyoKru+qLNvRp2Zh1ZFP9LiLtPu0xktY1pvZgLASqKHMAW+AzekgEVKizfnSzEc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784303147; c=relaxed/simple;
	bh=dZucJDqnxn2TBJC2ggZ3Ow2af1COy6hDtuR8z5sjvg8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Jfs7M+bTo1bzuYAI1xnyy10rqy7ZeUoRGZe5XQvwu4//q/5wr6H55+W6zCQLRAHrf/ofakLwU4YWtVyrs5ysksfjsuPxIiHe3Aof1sPEsAsGqUQD7RiAKT4Rk1TPF/QoszZ2cbL5ZBE90CvR7suUgxG8GtApZqU6GDUz8onvu5U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RlCW300c; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=JHRDvBE0; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RlCW300c";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="JHRDvBE0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784303144;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+15hMsYO07b/SOOuaYDJaqTE/uXukCXKD4WPh/0e1dA=;
	b=RlCW300cgewgK6mb4ywoM+O9bFYgdIBEQxix1X1CcxZukXAuytMGv0JNuWYFxt7i0QJojy
	A1/jo4p0BVvbm2EVDRIrujip5JsUderUP/WMoD7BtbxoXxr0JdejqOlsxiQgJ39+qRqZyx
	U+RRRfUmwgOOgIg8Ffwp5SwE23xbbZk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-694-j_QioqviPral323Pfn-7_w-1; Fri, 17 Jul 2026 11:45:43 -0400
X-MC-Unique: j_QioqviPral323Pfn-7_w-1
X-Mimecast-MFC-AGG-ID: j_QioqviPral323Pfn-7_w_1784303142
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-47162f83c75so1035176f8f.1
        for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 08:45:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784303142; cv=none;
        d=google.com; s=arc-20260327;
        b=OoHVdh4aeGW2ndR8xKU82Sq8il+TSVoD29eUe4PAntDHhWb83ZDLZkuGrf8FcSEmNF
         rU1if/h0zFVgsvovso//+CIRjE4LQw7vkgkISWK9/ibl/spwQ0/MqZh476y1nBrASVvO
         GV0ZtFRVFvvzt9n3l8L5Tefuv496RoITO1QbIk0Ex1+jiIEm+do8DfTN3JSfAFa8fRRI
         Qj/+b+IU4eY6SJOrXJvZl9IrzesLsyMU1MOcbl2wbuLJ5TpuZwDplvs1yqqS4CmvfrF/
         YVyaWV6HUXcvN3872TjoHY4aF9YyyyBFN3K7LEK1wEUHXH/mzlxL2+WIvGmkwFa+qNv7
         bIzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+15hMsYO07b/SOOuaYDJaqTE/uXukCXKD4WPh/0e1dA=;
        fh=gk1BdrnHoS7uNREHLM+/EVt1JbvdUnG1gwDIEzNJoVI=;
        b=ZDh5rPp7f6YZtwdqFz4xbpkaN/M+CaLnZYenjdmELsLwgd45PC2d/LiGtv66A4gP1M
         o/mptaqHZw2ePGzPu61U8bzFCE8vRX7NZyw9BTJa9H8ejlvcCNVocQJRquwZv+U7nvFh
         474VX75kDN1+HAtlWWX/myYt++S1lF7chcFWPrvuuEPf4XglcgE+fki+VpMhMOM/q2nm
         dXpRtlnxg241oeELeceeIfkK63nxNQYX+raDEAYDAyBZaxWDWDnDCPmT0e95CSa5zyDz
         J1Voadko7L7BgOemBek8LRHeLgqag05jx9nxBRiyTdJPLESG/glLcdjNwqEJlFXjOcoj
         4/OA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1784303142; x=1784907942; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+15hMsYO07b/SOOuaYDJaqTE/uXukCXKD4WPh/0e1dA=;
        b=JHRDvBE07RmkVg1J3zsPM/weR6LXGPN1PPpVQCSDqLQFwHzkmfohbBR7UEI3Lz1GFV
         sxCYK0oT4wgrjvPdig2jRkLpfHHJ1qjBa5Qh8J/KDvF43uTyA2AsKNiFpDWCxKtBESM7
         1VdJ54lAhO8Oj6GjhwkNJjRtxzdotNSmZUOjNNsDlEZhgvRP//Xt1dru37n1mW66Zk/b
         AVLS+SHksD6bKGNmROHHVTOQkFhdGDh0ZPw0t0ak0PQM42obys99PmlTIHA4oCTC9u7R
         nYdYM9VfJxkcKtltk2OmfcOybXwfqbSpeg2ccBqsWGgYEL89glVgKrkxQ3Uu61Y0iF4C
         oPPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784303142; x=1784907942;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+15hMsYO07b/SOOuaYDJaqTE/uXukCXKD4WPh/0e1dA=;
        b=gNE6eaQy1QaFUkgCEQVEvdjDQpcLjJfjm6mp0SiMdyHDT9/j4oNHmze/PzkxuSdgUu
         zn1sDnmHoRKoVoz6cJpQxv5C994ztk3yZnFJs9w9T9FClX9NURs79bSLo7i7wr4ixJSX
         H/vBhVp32jLWieGNKKZfwRatDhBG+xXPv4IwMdZm2vZI7JLGM8/naMw1uPfG5QisrSzy
         J+Jo7h1eeFGnc+v5GiFFmug1J2SpPwpX8OlGSj58a0dPzyJ9UznJ3XcktEGTLrsZ+63N
         2DYXiHA5Zc9zvgAuu+bPni7JYURNhP6kUG/EJHpya8hPbRCpRbKgGgDJPA6T5NbkH8u1
         cPBw==
X-Forwarded-Encrypted: i=1; AHgh+RrceDTGaLLMqCuVN4N351VxEu4hdGkUw8dolt9Bg0gK3TH5LAN1eAS9IQwJ1ls7Wd2Em1h2vmABLOXq@vger.kernel.org
X-Gm-Message-State: AOJu0YxxMskJYGxL8UHhS6iigPzKKTZ2NU7E1TERAj5gYEyWjRiZDLhY
	ohSkpBPsdF7absE7ve/cJVz2472W0HWSN6U2EfdhoxHbNNchxkqqg3K7/enZtlS8gnHmwkZLz0Q
	WJ8YbdLBRTo1/ttP0vo6GkSsu2XFu2Jpfevx6bO8Rv2y3PjeFniN5qQO2lqq+piPvjR1W7zmUXh
	4Yf6cZDp1Afppm5TYNkC6f82YP0klHSVBQtNDUuQ==
X-Gm-Gg: AfdE7cmVb2bvc5ph/zCRpl5NX2wB2AhgFvu9GZoazikCEMji4c9McIAOnaWOuUuYQsK
	gkowkinkxMCiN8NJYce29PNfl7xBeEQQZqjiHwR3+PeawXm1lbevaIfyysM3Y+R5O4QiGmsvn9d
	Hmq0Wtu17V3e065JD1wIJFIAiITcvu3HviUzBh8x9q7G6iVcgpTkiv1rMzMwBBy5ztBuNfBsHWv
	3uKZV92mctfv5A=
X-Received: by 2002:a05:6000:41f0:b0:460:d18:865c with SMTP id ffacd0b85a97d-47f5a4182c4mr10238053f8f.1.1784303141745;
        Fri, 17 Jul 2026 08:45:41 -0700 (PDT)
X-Received: by 2002:a05:6000:41f0:b0:460:d18:865c with SMTP id
 ffacd0b85a97d-47f5a4182c4mr10238028f8f.1.1784303141364; Fri, 17 Jul 2026
 08:45:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260714152238.541704-1-jtaubepe@redhat.com> <202607150914.6C4DD9DE03@keescook>
In-Reply-To: <202607150914.6C4DD9DE03@keescook>
From: Jesse Taube <jtaubepe@redhat.com>
Date: Fri, 17 Jul 2026 11:45:29 -0400
X-Gm-Features: AUfX_mxczdveYEkQ2F7ZGQimhXBeV77ore2QZAWldEN6Jbr11pwlMVAev648dps
Message-ID: <CADRr4beNdQL86RokX9O4+2Ar-C7fL=9m6ALiCnXcR=Ht1PU+pg@mail.gmail.com>
Subject: Re: [PATCH] scsi: qla2xxx: Fix flex array member not at end
To: Kees Cook <kees@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
	Nilesh Javali <njavali@marvell.com>, GR-QLogic-Storage-Upstream@marvell.com, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
	Christoph Hellwig <hch@infradead.org>, John Meneghini <jmeneghi@redhat.com>, Chris Leech <cleech@redhat.com>, 
	Jesse Taube <mr.bossman075@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 15, 2026 at 12:16=E2=80=AFPM Kees Cook <kees@kernel.org> wrote:
>
> On Tue, Jul 14, 2026 at 11:22:38AM -0400, Jesse Taube wrote:
> > In qla_edif_bsg.h: `struct fc_bsg_reply` and `struct fc_bsg_request`
> > have flexible array members, thus they must be the last member of
> > the parent structure. Contininging in the effort to add
> > `-Wflex-array-member-not-at-end`, move the structs to the end of
> > the parent structures, `struct qla_bsg_auth_els_reply` and
> > `struct qla_bsg_auth_els_request `.
> >
> > Suggested-by: John Meneghini <jmeneghi@redhat.com>
> > Signed-off-by: Jesse Taube <jtaubepe@redhat.com>
>
> It feels like this structure is part of the hardware spec? (and therefore
> cannot be re-ordered.) I'm not sure at all, though, but it looks like
> it's part of request serialization:

I looked at the code closer and i relized this structure is passed to users=
pace.
I sent a patch V2 after i relized that though i accidentally kept the
commit description the same.

In the lpfc driver here you can see how `bsg_job->reply` is supossed to be =
used.
https://elixir.bootlin.com/linux/v7.0.10/source/drivers/scsi/lpfc/lpfc_bsg.=
c#L662
the layout of `bsg_job->reply` is defined in `struct fc_bsg_reply`,
the `struct qla_bsg_auth_els_request`
data should have been put in the flex-array called `vendor_rsp` so
`(struct qla_bsg_auth_els_request *)bsg_job->request->vendor_reply->vendor_=
rsp;
unfortunatly because of `vendor_reply` and `ctels_reply` being in a
union the actuall vendor data from
`struct qla_bsg_auth_els_request` is offset by the size of
`ctels_reply`, this can be seen in V2 of this patch
AFAIK this isn't leaking data.

V2: https://lore.kernel.org/all/20260714185621.610105-1-jtaubepe@redhat.com=
/

Thanks,
Jesse Taube

> $ git grep 'qla_bsg_auth_els_request' | grep '>request'
> drivers/scsi/qla2xxx/qla_edif.c:            (struct qla_bsg_auth_els_requ=
est *)bsg_job->request;
> drivers/scsi/qla2xxx/qla_edif.c:            (struct qla_bsg_auth_els_requ=
est *)bsg_job->request;
> drivers/scsi/qla2xxx/qla_edif.c:            (struct qla_bsg_auth_els_requ=
est *)bsg_job->request;
> drivers/scsi/qla2xxx/qla_isr.c:                         (struct qla_bsg_a=
uth_els_request *)bsg_job->request;
>
> -Kees
>
> > ---
> >  drivers/scsi/qla2xxx/qla_edif_bsg.h | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/scsi/qla2xxx/qla_edif_bsg.h b/drivers/scsi/qla2xxx=
/qla_edif_bsg.h
> > index 514c265ba86e..bcc35d149c1f 100644
> > --- a/drivers/scsi/qla2xxx/qla_edif_bsg.h
> > +++ b/drivers/scsi/qla2xxx/qla_edif_bsg.h
> > @@ -36,16 +36,16 @@ struct extra_auth_els {
> >  } __packed;
> >
> >  struct qla_bsg_auth_els_request {
> > -     struct fc_bsg_request r;
> >       struct extra_auth_els e;
> > +     struct fc_bsg_request r;
> >  };
> >
> >  struct qla_bsg_auth_els_reply {
> > -     struct fc_bsg_reply r;
> >       uint32_t rx_xchg_address;
> >       uint8_t version;
> >       uint8_t pad[VND_CMD_PAD_SIZE];
> >       uint8_t reserved[VND_CMD_APP_RESERVED_SIZE];
> > +     struct fc_bsg_reply r;
> >  };
> >
> >  struct app_id {
> > --
> > 2.54.0
> >
>
> --
> Kees Cook
>

