Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6CCA442F;
	Sun,  2 Feb 2025 21:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738532052; cv=none; b=lw79JVcsN0NRfXRxBqE6rAK4fy/tClAxva1vdbbGY3JO0Gcrb9JplNgCRVXuwa7RACfKNE/Au40y7YUrPnLneOY74R24GFOsemafuJRCVqoTwkClukhD+LlogBaxJ2SDPX/r2HGbGFFjFgWZq9RPN4bA7ZigJd1FoaYYphIYyUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738532052; c=relaxed/simple;
	bh=1USPr2avyMMdCDj283unnbiI9OzA7BpY25epGIk6ioE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Fs4cnNvvPBy9IRvzhXpAZFM7PHGHXOblqiI00PJTfiCiqk59jt91NYo8B5H599wxdu8hrcpiVF0ppnHmr1u3Bne1+ZO6g8qeksw8iaqKX7ABDnz1xixXs9SJyzsU40/aRLG6X+hNQNFFt6KbsHxqR6cG80L08ziaFnRwbKkH5Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h3ZPNO2g; arc=none smtp.client-ip=209.85.219.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h3ZPNO2g"
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-e549b0f8d57so3710284276.3;
        Sun, 02 Feb 2025 13:34:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738532050; x=1739136850; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xervzuvTU5kRVA0g1hfaGyT+W5ZZlfisYRB4bWRY36U=;
        b=h3ZPNO2gM4+mIWpg9pJFvqq7+CplCJcjMmXlL2+mFD41sCpTWrWvU4+b5o6m6hL2ok
         6kQlb4/EJXW+jqrtr9n5UGBJnx6GeEs0H+uyfushz/aMjTp14Yt1TpXo7iPsmtTgAdZR
         74dIcObxNT9CwPdha0i/9JPyHGedl4XJ02aGEz4ArtgQNLyR/7gh/5Tzh9QXR4W79PQz
         wpzgGUB6iE3JSOrqmFmoUDZsSKQu5la5AbHX5sS5HWANRJ0KOeRXeR4+Ywo4y1H3u5FM
         HJoSrwHf81PQCu5pFJeS4lSYPj2JhRj9DbA1jj7Wp7IGtmtdo9f0uOnX7YxDxfxS3Kg2
         DH7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738532050; x=1739136850;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xervzuvTU5kRVA0g1hfaGyT+W5ZZlfisYRB4bWRY36U=;
        b=h6KahvGnIat4UZri8BtrPtrHT1tWLx/509oIwd6GglE9c89JfW3/1VGp6Km05RVY6L
         MCE0LO81AIM+SLitdU7mFamPR1UAq5mHZ55rL7rb1q88FhwMlXqIqN7Ra8GzCHy4uXXk
         wng2zNPj5rA/RTfDQid4FLlTE8gQynfIKV80vq7U60Oxd7MxaEHAQORei4BIGTX1AS4Q
         IjLu2NXUB8MG7lsedDJIzb0MgyriwAAOyCR1/2ceFP0P57pkl9dXf0FIMKychazwO8L0
         ATRNe6NuiDshF+X4bTDMMKmYHjQ5XXZQ/gfAJO2DKm3NqKfDVpglml5iYc1P+e85DmaK
         MSPw==
X-Forwarded-Encrypted: i=1; AJvYcCVTpOuNcB0axdKKOmDxwe91T/st/t/77H/DlWVTg+6Sdlf9qFBoqZhXzcH0EnnymaucR0q7eef/hfy5lyI=@vger.kernel.org
X-Gm-Message-State: AOJu0YysFRb7K5h/0crOtgdMICatL4RVBTBuvSL5UL9TTvOSviAU3TDm
	QFEufpCK5QUYLLuLPq/rRTh6YL27wOWMknQ3mssdfPsk+C6VgVg02zwKoHl4q85TpMz5RUNAVJj
	GVfBWxqbX6sp1hQP2gciEr/6fgNw=
X-Gm-Gg: ASbGnculK5mmo516bQ+9ZlAWqYI/pUfg1RfgQN5Ixvu6+WY0gA6dZdFPGGOt7GWchcX
	C8DQjZV0VvQ5R9thfs9vZCIzvQJuj6nb5ASiEsgt7xpYhAbdvGz3oxYSjs/tHD9KCW9md5MWD
X-Google-Smtp-Source: AGHT+IEe4JBZVv4bfu5Dn7GAeUOoZQCA616LTmNkftPzaq8bWXVuBy43mGYbFV+XBDV2poDHSirB9w7HfWLjuRac8fc=
X-Received: by 2002:a05:6902:707:b0:e58:33aa:3ac7 with SMTP id
 3f1490d57ef6-e58a4bf1c42mr14236413276.44.1738532049778; Sun, 02 Feb 2025
 13:34:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250131213516.7750-1-jiashengjiangcool@gmail.com> <d5d13945-da84-4886-bdc7-9a3ac182b2be@web.de>
In-Reply-To: <d5d13945-da84-4886-bdc7-9a3ac182b2be@web.de>
From: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Date: Sun, 2 Feb 2025 16:33:59 -0500
X-Gm-Features: AWEUYZmiZn7SRWoAC2Cpep40o4vb0ZBKrToz37hxHsKX5pwvRrQ2EcaUXmeoKXg
Message-ID: <CANeGvZXXrA4K4a+TDijxu9qCrh-j+ifb-xEkyZuFZPchECZK4g@mail.gmail.com>
Subject: Re: [PATCH v2] scsi: qedf: Use kcalloc() and add check for bdt_info
To: Markus Elfring <Markus.Elfring@web.de>
Cc: linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com, 
	James Bottomley <James.Bottomley@hansenpartnership.com>, Javed Hasan <jhasan@marvell.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Saurav Kashyap <skashyap@marvell.com>, 
	LKML <linux-kernel@vger.kernel.org>, Arun Easi <arun.easi@cavium.com>, 
	Bart Van Assche <bvanassche@acm.org>, Manish Rangankar <manish.rangankar@cavium.com>, 
	Nilesh Javali <nilesh.javali@cavium.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Markus,

On Sun, Feb 2, 2025 at 11:54=E2=80=AFAM Markus Elfring <Markus.Elfring@web.=
de> wrote:
>
> =E2=80=A6
> > +++ b/drivers/scsi/qedf/qedf_io.c
> =E2=80=A6
> @@ -254,9 +254,7 @@ struct qedf_cmd_mgr *qedf_cmd_mgr_alloc(struct qedf_c=
tx *qedf)
>         }
>
>         /* Allocate pool of io_bdts - one for each qedf_ioreq */
> =E2=80=A6
> +       cmgr->io_bdt_pool =3D kcalloc(num_ios, sizeof(struct io_bdt *), G=
FP_KERNEL);
> =E2=80=A6
>
> See also:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/D=
ocumentation/process/coding-style.rst?h=3Dv6.13#n941
>
> Regards,
> Markus

Thanks, I have split it into two new patches and fixed the error.

-Jiasheng
