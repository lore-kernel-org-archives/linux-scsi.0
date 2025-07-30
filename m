Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0321DFD96
	for <linux-scsi@vger.kernel.org>; Wed, 30 Jul 2025 16:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753892716; cv=none; b=R0+4VFYFsqgwQ09uMxxvmVh41D2tL3UdsJOAdjTHigmXzqKlTt66JU5LNxjd2OBjmmg0sTwg6H4odGfKwOyU73LKakYG9qI0kmpIRH/K+28N6mQCsj3E7733H3Rjbj/CX9/CYb+pkI0sT0nri4/KwKTVinaeJC69tJiyO6QGA4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753892716; c=relaxed/simple;
	bh=EI0bMvYv5hSpvnTUf2HMOBA5DoaU+c0LboV5ElVAY00=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 Cc:Content-Type; b=DKpfqAAP8fYnDBwWgHlwxrfh13K9J1j5iuLxF6QemvNAnf8++PMO3Dh4BR3wVwt87uh79jCqBUwwAG/ihsqpxK9NuluZ8kiYPgAPFCbTOhc73euO48f1HAHjquniWu0ulQwhRIqYtyWwTxRbw3HO9S5iJXsYE6RcasEpclQqaLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nBbnRBXd; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nBbnRBXd"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-24099fade34so769595ad.0
        for <linux-scsi@vger.kernel.org>; Wed, 30 Jul 2025 09:25:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753892714; x=1754497514; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E9XySPgRxGKmddhBeo4PW8+eY+WMXaAjgeL+q5qCHG4=;
        b=nBbnRBXdoZHjwYvmM+loUeIjj5Ln4jufldqxQg8o9YARYGKU9VN5kYRQtVrFy9Yyum
         LsUTVisxfAgrM3Ty4lfXqS8venvoPVYsncw8JBbQrvuVXyUX0MxTQ56CA0DWWf9unqcb
         BXT0Co58FVIMCbUrYoDoxkLgaxIIU2sLJq5O4fjInLhkJw+DKmVTz0z/QK4Oc5iYUdaA
         bdU8viCqX6yiH5AXngtU29uRa7Oom+FtqfMv35sUgAp5fOXymVcVksDSjQqzwDax8/zE
         WADO0F4Os9bTddILA8yaEp9TSLSXuU5gB8J24sKI0arufhfQvhhaVMYuzD0HJu1eeFcc
         GKfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753892714; x=1754497514;
        h=content-transfer-encoding:cc:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E9XySPgRxGKmddhBeo4PW8+eY+WMXaAjgeL+q5qCHG4=;
        b=MtZ4GoWvR6h+XWPFCTib0RuAEaeOl931a6EcXt5arYWitIk+XRkxtgJHs0yLlrfIws
         M4NwXrYDnmAo0x1jnKxMeqEOoSKTSfObIRZOB0K3bE9iEtXkrxRsiUc0gVw/tacJTxAl
         vuJkd3fu0f8heYUYIwSEPGmb3D9nSO79BCe/qz6WNuHuDkyHXegGUqgfopKdQuxtUrj8
         1JcyMD2MMfbj/JmjUuRKQfW+qmwgn7M5q8LdcLLmkyZdnzn0M3PL4pCBvlh17TulAsT3
         g0HdJmbCFREPAVB8iLcRztICDbPoUakcflEzDwKjSo9GR8gjLqtwiNw2ixJDsrFjjgOI
         8Hpg==
X-Gm-Message-State: AOJu0Yxjo4vk+TNiACWt8jeBd/oTctjCsja6EPxrIPwniIG1mZ8bW8FY
	Lvn43rkTSimpEhnInC3V9ZIPvWRn9FBYs9Jk3h7szTfDFLEjB+JjWpFd4Y/njMXpy5EummNF6+x
	zHLBysC8fKVKPlwN+BpVEpN6xJD03G0TFa3fpuBgsMQ==
X-Gm-Gg: ASbGncuhKjTaLJPnZIVCRQk7k6DTc36FFOiH+SsYb7h3jB7tJbNxbkca/huC09b2bg1
	dOIv4MLmohM9yQwzpO/S7w+8LoHp3fSJjvTGvYdu50+VDNx8DnoAYP7Ggb6IxaN/phedOt86/Jg
	9pFhBmRG5FYK6w4gkmALF1KRwmLYf5tdRn2+aGBLk+a7Entq28lTbZyNUY9vJ1TjoZkippDIFsk
	/Pg80QCN6bSSevKpa1T5ocCunPsGi9nP4bPFtrDpA==
X-Received: by 2002:a17:903:b4f:b0:240:92cc:8fcf with SMTP id
 d9443c01a7336-24096b34743mt53106115ad.49.1753892713686; Wed, 30 Jul 2025
 09:25:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250722203213.8762-1-andrewlbernal@gmail.com> <ccac04ec-fe14-46bd-a482-b9cbb65fadf5@acm.org>
In-Reply-To: <ccac04ec-fe14-46bd-a482-b9cbb65fadf5@acm.org>
From: Andrew Bernal <andrewlbernal@gmail.com>
Date: Wed, 30 Jul 2025 12:25:02 -0400
X-Gm-Features: Ac12FXz0zlijZdaLwoj5plPalzSt0irQiMMJ3O6QVUPamPWsNCHOxHvejkCXcOM
Message-ID: <CAPj058cx390W=GE9fFXKY101GL7S=XNn=0YSTfojkvhybKEBvA@mail.gmail.com>
Subject: Re: [PATCH] scsi_debug: add implicit zones in max_open check
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Bart,
Yes, I've read the real standard now, and I see how it clearly defines
the OPEN ZONE function.
Thank you for your reply, I really appreciate the explanation. Sorry
for the patch, I'll be more careful in the future.

(my previous reply was sent to the email addresses, but didn't send to
the mailing lists because it wasn't plaintext)

Sincerely,
Andrew Bernal


On Tue, Jul 29, 2025 at 12:19=E2=80=AFPM Bart Van Assche <bvanassche@acm.or=
g> wrote:
>
> On 7/22/25 1:32 PM, Andrew Bernal wrote:
> > https://zonedstorage.io/docs/introduction/zoned-storage Open Zones limi=
t
> > is defined as a "limit on the total number of zones that can simultaneo=
usly
> > be in an implicit open or explicit open state"
>
> That's not an official standard and hence should not be used to motivate
> this patch. Additionally, I don't see how a zone could be simultaneously
> in the implicit open and the explicit open state. According to the ZBC-2
> standard, these states are mutually exclusive.
>
> devip->max_open is reported to the initiator in VPD page B6
> as the MAXIMUM NUMBER OF OPEN SEQUENTIAL WRITE REQUIRED ZONES. From
> ZBC-2 section 4.5.3.4.2: "If the value in the MAXIMUM NUMBER OF OPEN
> SEQUENTIAL WRITE REQUIRED ZONES field (see 6.5.2) is non-zero and
> the number of zones with a Zone Condition of EXPLICITLY OPENED is equal
> to the value in the MAXIMUM NUMBER OF OPEN SEQUENTIAL WRITE REQUIRED
> ZONES field, then a command that writes to or attempts to open a
> sequential write required zone with a zone condition of EMPTY or CLOSED
> is terminated with CHECK CONDITION status with sense key set to DATA
> PROTECT and the additional sense code set to INSUFFICIENT ZONE RESOURCES
> (see 4.5.3.2.8)."
>
> > diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> > index aef33d1e346a..0edb9a4698ca 100644
> > --- a/drivers/scsi/scsi_debug.c
> > +++ b/drivers/scsi/scsi_debug.c
> > @@ -3943,7 +3943,7 @@ static int check_zbc_access_params(struct scsi_cm=
nd *scp,
> >       /* Handle implicit open of closed and empty zones */
> >       if (zsp->z_cond =3D=3D ZC1_EMPTY || zsp->z_cond =3D=3D ZC4_CLOSED=
) {
> >               if (devip->max_open &&
> > -                 devip->nr_exp_open >=3D devip->max_open) {
> > +                 devip->nr_imp_open + devip->nr_exp_open >=3D devip->m=
ax_open) {
> >                       mk_sense_buffer(scp, DATA_PROTECT,
> >                                       INSUFF_RES_ASC,
> >                                       INSUFF_ZONE_ASCQ);
> > @@ -6101,7 +6101,7 @@ static int resp_open_zone(struct scsi_cmnd *scp, =
struct sdebug_dev_info *devip)
> >       if (all) {
> >               /* Check if all closed zones can be open */
> >               if (devip->max_open &&
> > -                 devip->nr_exp_open + devip->nr_closed > devip->max_op=
en) {
> > +                 devip->nr_imp_open + devip->nr_exp_open + devip->nr_c=
losed > devip->max_open) {
> >                       mk_sense_buffer(scp, DATA_PROTECT, INSUFF_RES_ASC=
,
> >                                       INSUFF_ZONE_ASCQ);
> >                       res =3D check_condition_result;
> > @@ -6136,7 +6136,7 @@ static int resp_open_zone(struct scsi_cmnd *scp, =
struct sdebug_dev_info *devip)
> >       if (zc =3D=3D ZC3_EXPLICIT_OPEN || zc =3D=3D ZC5_FULL)
> >               goto fini;
> >
> > -     if (devip->max_open && devip->nr_exp_open >=3D devip->max_open) {
> > +     if (devip->max_open && devip->nr_imp_open + devip->nr_exp_open >=
=3D devip->max_open) {
> >               mk_sense_buffer(scp, DATA_PROTECT, INSUFF_RES_ASC,
> >                               INSUFF_ZONE_ASCQ);
> >               res =3D check_condition_result;
>
> Do you agree that the current code in the scsi_debug driver follows the
> ZBC standard and also that the above changes would break compatibility
> with the ZBC standard?
>
> Thanks,
>
> Bart.
