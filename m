Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36EF431771D
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 18:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755282738; cv=none; b=Si7ViNkdGGnjojZdZLno7Oru7FTdySkHWmdojLOJKXjpldH0yu1RI78C/EzGC5Yzip87BcTg7DOpiHOo6+OxDGORCbI1A24Sxh1rqj7vhYjnBDF1oXq4Lnok6Bz9q4qV6tonUXWGfjvh7sKc7TLx98G8Nnvn0YOlfni/hV1q4wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755282738; c=relaxed/simple;
	bh=hLJVS8VkzU78Ho2HAJVBvBBpVkRZdtahlY2zkbcyKX4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fsYpnx3EvcAPtnqRKRaYfLjuDKshOpU7sRhmjeDK/BxSIOCY+p9VbMCYYuM42c7ZKeb4R154XdSXOUh/GdXNwfhcKwWqnY8c+wvlA2FCVXg/AOm0TOeqTX+L2ejl8aflm0cy5eGfpTUFYGDFZiDFjM0kyX31uhMrBFMltqr2c1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Edox1tHU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Edox1tHU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755282733;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E82lGwAqbqrp+ZkmV201DAGc8O5VIlfSDJWWv94uZqQ=;
	b=Edox1tHUVXcONNDaBE26y4Ja3LZPJC7l7G/sRwGWiEezmHCMTpZu8RU0WHEzPxuegbSpiY
	VGZ/OuBKsmGQWfwHZn6jJ6gHdOQ/9InO/c8YHcGJ5UQjAe2gaIXEEiboeawwyKgJfUYwtm
	9DEwV3Lto0P3Pxbab+mznWp/hxIRCFE=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-436-B7watmEENwSqiCd4mGs1dQ-1; Fri, 15 Aug 2025 14:32:06 -0400
X-MC-Unique: B7watmEENwSqiCd4mGs1dQ-1
X-Mimecast-MFC-AGG-ID: B7watmEENwSqiCd4mGs1dQ_1755282726
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-71e71886fbeso9195707b3.0
        for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 11:32:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755282726; x=1755887526;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E82lGwAqbqrp+ZkmV201DAGc8O5VIlfSDJWWv94uZqQ=;
        b=CfWb1fW9+EJmnK5vYFd0bI4zXGwRLIjo4q8p4bMH8UUryfFu+HLTrf5NOPPPKDTTte
         Txnz5MrVkazV+W88PTc4MVAxYqxwZfYVrvNx6tE2USzsHd65ETOYRdZmuA/Re3/WDAXf
         UpMjpHfhl/fyo2Mw3ehaGneNcJPVSnCRc71SYQ/asuIPfqi0r/ZIVcTOxPOMr9Spyjom
         Y2cECJOLCzJ78vwVak33xeeST9oLbUp3rrG1i18jdKM4XDggxnnODOlQJOFzNDCQBnUQ
         4UMGkE14rq8Iq9KpG0UWx43A2TxjsAliuVeyt7dYlTsM87bboHhvCdaCfrqKvhgDgxcW
         uIGA==
X-Gm-Message-State: AOJu0Yw2Zk9lmXWjk/TXhi3a0NJMlcN1Mrry2EhMFwOdStp9wEyEHVsh
	m4C1hqi9A129q4G6YfjFetUhoo9VgnMaV6qmM+VDYh9ZXIXv9RRoH2Kxr3SFP0o4U8lG8skOgNV
	kCtKoPr6hfqHZfx/ZN3bnspQ13W/b/V48ijBxQDm4uYH4pNmhaeWsirZfL2V9IUQIZIkSz0v7Jn
	KwVV6exGVqUi4k9qQe/AxIdQTnOyC2PQy/J16msA==
X-Gm-Gg: ASbGnctjVcGAUVkg/xzT1jNcEOBtZsE4Wf7tsvsmmFxHFZai7DCt8F1W8I4fuwnGiTY
	9TkWY4AA/Uds0tJRjyle+qS9zJ6Cr5mFVzargT2/yEpihV9AXRntvYhuNfWye1PO7KE5FTJ6yxf
	xf20JS/MKHNJsvOHIjTW/YEg==
X-Received: by 2002:a05:6902:1105:b0:e93:3a67:689e with SMTP id 3f1490d57ef6-e933a676a0fmr2401143276.11.1755282726087;
        Fri, 15 Aug 2025 11:32:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHGaig28EEk/9YrEsX0f8ys23FWxrSjaapsjxN9Y9rEC1H5Cj3uo7VkVWFlXtL99tJWluxBfPuC8RYTvOQWt0M=
X-Received: by 2002:a05:6902:1105:b0:e93:3a67:689e with SMTP id
 3f1490d57ef6-e933a676a0fmr2401086276.11.1755282725513; Fri, 15 Aug 2025
 11:32:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250814182907.1501213-1-emilne@redhat.com> <20250814182907.1501213-8-emilne@redhat.com>
 <7a503388-d466-491b-aa1e-e56515266eab@kernel.org>
In-Reply-To: <7a503388-d466-491b-aa1e-e56515266eab@kernel.org>
From: Ewan Milne <emilne@redhat.com>
Date: Fri, 15 Aug 2025 14:31:54 -0400
X-Gm-Features: Ac12FXyxeCBeiLyzkkwkTF62Nz6OQGPJSAuOGPOVtPhKIAoqIZkuDnrRh-nL-ns
Message-ID: <CAGtn9rncPyhO9u75X__5T8QiGQtBrO+Th7AousKkJsa7XG0tiA@mail.gmail.com>
Subject: Re: [PATCH v2 7/9] scsi: sd: Check for and retry in case of
 READ_CAPCITY(10)/(16) returning no data
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, michael.christie@oracle.com, 
	dgilbert@interlog.com, bvanassche@acm.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 14, 2025 at 10:50=E2=80=AFPM Damien Le Moal <dlemoal@kernel.org=
> wrote:
>
> On 8/15/25 03:29, Ewan D. Milne wrote:
> > sd_read_capacity_10() and sd_read_capacity_16() do not check for underf=
low
> > and can extract invalid (e.g. zero) data when a malfunctioning device d=
oes
> > not actually transfer any data, but returnes a good status otherwise.
> > Check for this and retry, and log a message and return -EINVAL if we ca=
n't
> > get the capacity information.
> >
> > We encountered a device that did this once but returned good data after=
wards.
> >
> > See similar commit 5cd3bbfad088 ("[SCSI] retry with missing data for IN=
QUIRY")
> >
> > Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> > ---
> >  drivers/scsi/sd.c | 56 ++++++++++++++++++++++++++++++++++++++++-------
> >  1 file changed, 48 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> > index f1ab2409ea3e..20b5eebba968 100644
> > --- a/drivers/scsi/sd.c
> > +++ b/drivers/scsi/sd.c
> > @@ -2639,6 +2639,7 @@ static int read_capacity_16(struct scsi_disk *sdk=
p, struct scsi_device *sdp,
> >
> > -     the_result =3D scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, buffer,
> > -                                   RC16_LEN, SD_TIMEOUT, sdkp->max_ret=
ries,
> > -                                   &exec_args);
> > +             the_result =3D scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN,
> > +                                           buffer, RC16_LEN, SD_TIMEOU=
T,
> > +                                           sdkp->max_retries, &exec_ar=
gs);
> > +
> > +             if ((the_result =3D=3D 0) && (resid =3D=3D RC16_LEN)) {
>
> You do not need the inner parenthesis. Also, it seems to me that this che=
ck
> should simply be:
>
>                 if (resid)
>
> Because any incomplete read capacity buffer is bound to be invalid.

No.  Because if the result is nonzero we want to exit the retry
(break: vs. continue;).
The retry is only intended to handle the case where the status was
good but there
was no data transferred (there will be no data transferred if the result !=
=3D 0).

Parenthesis, sure.

>
> > +                     /*
> > +                      * if nothing was transferred, we try
> > +                      * again. It's a workaround for a broken
> > +                      * device.
> > +                      */
> > +                     continue;
> > +             }
> > +             break;
> > +     }
> >
> >       if (the_result > 0) {
> >               if (media_not_present(sdkp, &sshdr))
> > @@ -2728,6 +2742,12 @@ static int read_capacity_16(struct scsi_disk *sd=
kp, struct scsi_device *sdp,
> >               return -EINVAL;
> >       }
> >
> > +     if (resid =3D=3D RC16_LEN) {
> > +             sd_printk(KERN_ERR, sdkp,
> > +                       "Read Capacity(16) returned good status but no =
data");
>
> Shouldn't this be a warning instead of error ? After all, there was no er=
ror...
> And I would prefer seeing a warning for a bad device. The message would a=
lso be
> better mentioning that this is the device fault.

KERN_ERR was on purpose, some people have dmesg -n set to suppress warnings=
.
I mean, it is an error, although the language in SBC is I think
unclear, it is definitely
implied that a certain amount of data is supposed to be returned.
(SBC-3 5.10 / 5.11
don't actually say "shall").

Although the case I looked at was caused by a F/W bug on a hard drive, you =
could
imagine that a similar problem might be e.g. USB bridge or something
(see the code
in scsi_probe_lun()).  So I prefer to just explain just what the
kernel actually sees.


>
> > +             return -EINVAL;
> > +     }
> > +
> >       sector_size =3D get_unaligned_be32(&buffer[8]);
> >       lba =3D get_unaligned_be64(&buffer[0]);
> >
> > @@ -2770,6 +2790,7 @@ static int read_capacity_10(struct scsi_disk *sdk=
p, struct scsi_device *sdp,
> >  {
> >       static const u8 cmd[10] =3D { READ_CAPACITY };
> >       struct scsi_sense_hdr sshdr;
> > +     int count, resid;
> >       struct scsi_failure failure_defs[] =3D {
> >               /* Do not retry Medium Not Present */
> >               {
> > @@ -2804,17 +2825,30 @@ static int read_capacity_10(struct scsi_disk *s=
dkp, struct scsi_device *sdp,
> >       };
> >       const struct scsi_exec_args exec_args =3D {
> >               .sshdr =3D &sshdr,
> > +             .resid =3D &resid,
> >               .failures =3D &failures,
> >       };
> >       int the_result;
> >       sector_t lba;
> >       unsigned sector_size;
> >
> > -     memset(buffer, 0, buflen);
> > +     for (count =3D 0; count < 3; ++count) {
> > +             memset(buffer, 0, buflen);
> >
> > -     the_result =3D scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, buffer,
> > -                                   8, SD_TIMEOUT, sdkp->max_retries,
> > -                                   &exec_args);
> > +             the_result =3D scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN,
> > +                                           buffer, RC10_LEN, SD_TIMEOU=
T,
> > +                                           sdkp->max_retries, &exec_ar=
gs);
> > +
> > +             if ((the_result =3D=3D 0) && (resid =3D=3D RC16_LEN)) {
>
> Same comment here: if (resid) ?

See above.

-Ewan

>
> > +                     /*
> > +                      * if nothing was transferred, we try
> > +                      * again. It's a workaround for a broken
> > +                      * device.
> > +                      */
> > +                     continue;
> > +             }
> > +             break;
> > +     }
> >
> >       if (the_result > 0) {
> >               if (media_not_present(sdkp, &sshdr))
> > @@ -2827,6 +2861,12 @@ static int read_capacity_10(struct scsi_disk *sd=
kp, struct scsi_device *sdp,
> >               return -EINVAL;
> >       }
> >
> > +     if (resid =3D=3D RC10_LEN) {
> > +             sd_printk(KERN_ERR, sdkp,
> > +                       "Read Capacity(10) returned good status but no =
data");
> > +             return -EINVAL;
> > +     }
> > +
> >       sector_size =3D get_unaligned_be32(&buffer[4]);
> >       lba =3D get_unaligned_be32(&buffer[0]);
> >
>
>
> --
> Damien Le Moal
> Western Digital Research
>

