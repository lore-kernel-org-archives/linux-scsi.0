Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A59308F2D
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 18:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755284018; cv=none; b=oXCPI1PlHStuhWoVNFiU9b32+OHLmevbM+2yLWgc8kfC09Ey1H7TMBzascP8jjXFyJXGwkP65ITVZ/vwG1+6MEi9iyzj2vPCFft0SpBDXLGBg831ONTj3liRBS5UOjN40XlMJwnJoPKeimk268WhPoGXf38klv9QplBisBLOHYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755284018; c=relaxed/simple;
	bh=kM6YhzCQlhSazav9/gIArDzOFjcfGFKXQd/Jcs17UCk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DjAg1VlfmtHP9mLCpzMknpjbF26Vt35UoN72IBXnhVA+G6RL3P9wdeDa0riiiE1a+pTxAO1c/GB8zmEC8F2A4mmRCp+1+85mVUpcsMX26D/y+RUdMaVQB6YTblmV996XGz4IKSWYJ4YBSjpR/K0ZMfMp3OlnlMDWj7ceoE2tr1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O8FpbZ4W; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O8FpbZ4W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755284015;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AcwM4LjMupp/Rcj8BvUpaPIi/jVP7jX3UapLQdfB+6M=;
	b=O8FpbZ4WSOCTyJek4m2q04gN+rpCaq9Dljx1IqLV7LZ57KzlowGv4xtVH8ucBLNlMFKaZb
	kB789Tq6EngTuDMJu1xGCJK1iipPxbHQPJ+2R95TG0QcZoD7HVO5vfyMdbAM+yGjO0QWgI
	Kml0No+0lath4BNNyQagiXhxZsskpsk=
Received: from mail-yb1-f200.google.com (mail-yb1-f200.google.com
 [209.85.219.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554-1ZD7rk3MNXeVCXJpE8CmdA-1; Fri, 15 Aug 2025 14:53:34 -0400
X-MC-Unique: 1ZD7rk3MNXeVCXJpE8CmdA-1
X-Mimecast-MFC-AGG-ID: 1ZD7rk3MNXeVCXJpE8CmdA_1755284014
Received: by mail-yb1-f200.google.com with SMTP id 3f1490d57ef6-e933de3872eso10850276.0
        for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 11:53:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755284014; x=1755888814;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AcwM4LjMupp/Rcj8BvUpaPIi/jVP7jX3UapLQdfB+6M=;
        b=DhIdYJPssfFxCbf/aNatSXwQvuys4qDh2S6kFD/F4ztzZ7AWUq3T8AKgi0cDqKlKCW
         KOCW4nGAsQSSmqNCYOPwOZkkm3HnHyGxCmvP98QwCFOWfPi74RYi079ruvm0T4W7hYN4
         faeabRO5JYjzvY/JEfguzMNyFFDmrxSPNqS7IGiMzxGyhD8H10ChqQgJLnUnhm4DFpoS
         NL+QE9GprEl15BVx3vGZnJfN/VJBlvw4h+7P4Akvv5IrcKWNhf1ISqO4cWKjyQH3qlKo
         J+Vb2wIjxijm6NA8Z34cFyQzz/Ah2w74AKGs/rn5efJu1K65iyhlJA3v5YjBSwouf8Ep
         JwoQ==
X-Gm-Message-State: AOJu0Yw9V71T/zuuBwqzNjjtVTJiw5iRDSSSGzTt88WjjwELjNmSF8E8
	cmYVKgBbxx7Yb+FWWZaeiIeLQRjWzdmpw54E0frOCoNRIluaPHRhqfgm8o2M3/q9QM0uApKqAnf
	7MF6iJkBKfeqpS0vPcQeML+zGEzskXGzOKMj38NX2arHNBFSgoPbsAgGLoorQC4Xw8Y69ZiHTnI
	KCOtkS2f90mdgbZzte3oV5PO7ug6IYG7wWBFGJYA==
X-Gm-Gg: ASbGncvxYWkRIxCfvIXaN848/7wYWeTun/j6v9H7VUrCHkJJnyvoFQn8K6r+nWHyxJJ
	1HS8dB9YYyDvox2cGMQsbLsgByYfBp5fjxj5QLEIebcerH9Xx+Scehfcr6TYW+xgU8AIpwqqsE1
	W6VkVK6oHzJx3o6x8RO+OOuA==
X-Received: by 2002:a05:6902:154a:b0:e93:abb:8557 with SMTP id 3f1490d57ef6-e93324bb4cbmr3224429276.28.1755284013594;
        Fri, 15 Aug 2025 11:53:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHKwaYyj3CUCqu4c2O/EJO3/35z8UwnihpPizfiNnV+32A8nm/xUF6hIh92oL5npZOKm2FiZO1QiJWFf6/8Mco=
X-Received: by 2002:a05:6902:154a:b0:e93:abb:8557 with SMTP id
 3f1490d57ef6-e93324bb4cbmr3224400276.28.1755284013133; Fri, 15 Aug 2025
 11:53:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250814182907.1501213-1-emilne@redhat.com> <20250814182907.1501213-4-emilne@redhat.com>
 <1305ccb7-4e23-436e-bdb3-79ebb8681bfc@kernel.org>
In-Reply-To: <1305ccb7-4e23-436e-bdb3-79ebb8681bfc@kernel.org>
From: Ewan Milne <emilne@redhat.com>
Date: Fri, 15 Aug 2025 14:53:21 -0400
X-Gm-Features: Ac12FXwmnnlI7WI_QdA1ldRzmkC7ArnV9aa_iY2QE-dlJ_omFlvIGGWuhsdzYh4
Message-ID: <CAGtn9rmAxwQE57km=ERwOyByaoQ7ivvctDFGJsG1QGtAMrkiEg@mail.gmail.com>
Subject: Re: [PATCH v2 3/9] scsi: sd: Pass buffer length as argument to
 sd_read_capacity() et al.
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, michael.christie@oracle.com, 
	dgilbert@interlog.com, bvanassche@acm.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 14, 2025 at 10:47=E2=80=AFPM Damien Le Moal <dlemoal@kernel.org=
> wrote:
>
> On 8/15/25 03:29, Ewan D. Milne wrote:
> > That will make it easier to spot an inconsistent buffer size value.
>
> How ? the buffer size is actually not checked. You only memset the buffer=
.

Because Bart asked for this in an earlier review (he actually wanted the co=
de to
use ARRAY_SIZE(), but since the buffer is obtained from kmalloc() that
won't work.

I'll just remove this all in v3, it isn't actually required for what
the series fixes.

>
> > Also, memset() the entire buffer rather than the 8 or 32 bytes expected
> > back from READ CAPACITY(10) or READ CAPACITY(16).
>
> Why ? There is no explanation why that is needed. The command will not re=
turn
> more than the transfer length specified. So memsetting bytes that will ne=
ver be
> used seems useless.

It's not really needed, I guess, no other routines that use this
buffer do the memset().
I'll just leave it using RC10_LEN / RC16_LEN as you suggested.

-Ewan

>
> >
> > Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> > ---
> >  drivers/scsi/sd.c | 28 ++++++++++++++++++----------
> >  1 file changed, 18 insertions(+), 10 deletions(-)
> >
> > diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> > index e3b802b26f0e..ae8eac4b1cb2 100644
> > --- a/drivers/scsi/sd.c
> > +++ b/drivers/scsi/sd.c
> > @@ -2629,7 +2629,8 @@ static void read_capacity_error(struct scsi_disk =
*sdkp, struct scsi_device *sdp,
> >  #define READ_CAPACITY_RETRIES_ON_RESET       10
> >
> >  static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device=
 *sdp,
> > -             struct queue_limits *lim, unsigned char *buffer)
> > +                         struct queue_limits *lim, unsigned char *buff=
er,
> > +                         unsigned int buflen)
> >  {
> >       unsigned char cmd[16];
> >       struct scsi_sense_hdr sshdr;
> > @@ -2651,7 +2652,7 @@ static int read_capacity_16(struct scsi_disk *sdk=
p, struct scsi_device *sdp,
> >               cmd[0] =3D SERVICE_ACTION_IN_16;
> >               cmd[1] =3D SAI_READ_CAPACITY_16;
> >               cmd[13] =3D RC16_LEN;
> > -             memset(buffer, 0, RC16_LEN);
> > +             memset(buffer, 0, buflen);
>
> I would leave this as-is.

Sure.  See above.

>
> >  >            the_result =3D scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN,
> >                                             buffer, RC16_LEN, SD_TIMEOU=
T,
> > @@ -2719,8 +2720,13 @@ static int read_capacity_16(struct scsi_disk *sd=
kp, struct scsi_device *sdp,
> >       return sector_size;
> >  }
> >
> > +#define RC10_LEN 8
> > +#if RC10_LEN > SD_BUF_SIZE
> > +#error RC10_LEN must not be more than SD_BUF_SIZE
> > +#endif
> > +
> >  static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device=
 *sdp,
> > -                                             unsigned char *buffer)
> > +                         unsigned char *buffer, unsigned int buflen)
> >  {
> >       static const u8 cmd[10] =3D { READ_CAPACITY };
> >       struct scsi_sense_hdr sshdr;
> > @@ -2765,7 +2771,7 @@ static int read_capacity_10(struct scsi_disk *sdk=
p, struct scsi_device *sdp,
> >       sector_t lba;
> >       unsigned sector_size;
> >
> > -     memset(buffer, 0, 8);
> > +     memset(buffer, 0, buflen);
>
> Same here, but maybe define RC10_LEN instead of having the magic "8" valu=
e
> hardcoded ?

Right.  I'll put this in the other patch.

-Ewan
>
> --
> Damien Le Moal
> Western Digital Research
>

