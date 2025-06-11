Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71AC1B0411
	for <linux-scsi@vger.kernel.org>; Wed, 11 Jun 2025 05:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749620569; cv=none; b=fjaruI2A4qOx/ZA155Y4Ubh6vZzCNgtRuTGuIJoScCyGy0OgvM+rtJL1gI7R3gOmcsZEa7ILQM6VY42k0CPdqsT6/E4N2AWJtIHZAwHHRZNFMXNRl13HsVBfsu2g95gBU9104/WdqNxxcqsCF/awqJW2OlAeo7N0CNzI4/tZplc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749620569; c=relaxed/simple;
	bh=iyNIx+6D+BSaJQ7RGPv4AYHm/cKpN9F9Hpzxv+nt5i4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=maDFCg5zBtCNYxlMncQzk08dDjZnV1HB9bpMFGGTytAjM+4FQ1J1s6g3yagP/y0L3MHSpiFpM4II6xlCh2cQoBqN6hqPJa9coWy/HY8TwOVzPM8KIeTBRBcZzHZpRHyYvlLpvfhmulty5IAB7sua1lQNJb455nxpfn4VYI5vY+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hBEcyOYI; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hBEcyOYI"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-6facf4d8ea8so65524336d6.0
        for <linux-scsi@vger.kernel.org>; Tue, 10 Jun 2025 22:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749620566; x=1750225366; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iyNIx+6D+BSaJQ7RGPv4AYHm/cKpN9F9Hpzxv+nt5i4=;
        b=hBEcyOYI1GEbazqWNfLHJat6CRAmcYB1rpcQxK1d2Fu6Zgbu55+Ojbo3Jk5X0AGeKo
         U5pyd0ZPQmKdPZqYV3iFNReS0mFiDALgQpHFjhTA9+W75N7k8lfKFi1Ari/+xGB9c+nU
         qP/csLn++DqMUm1l5BZoxC23kLaV3+2NOSRNU1nZq8Dux7d9wrXDRq/ppTgcokgacjR/
         RH4cuwdM4q9V8ZzQQazQGrvGAgelY4mtlXkliwWUpCziz2lwpRcbWoRB2x+31Sus2vK3
         ML0hor+BJ98ElY1HQ9UaH2p8uwpuLstdVjVwOSMEdSjSpKZW+0IAc0baNaNfuidcRfRz
         fCTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749620566; x=1750225366;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iyNIx+6D+BSaJQ7RGPv4AYHm/cKpN9F9Hpzxv+nt5i4=;
        b=FDpJcKrpUemBfSsI9pWSs3pjSwLhzxgeaT5ErXNKJA7cBaEbbccE7axtnwT3y2F6l+
         hT3AWjihwnzZ6wm2uOSTiD/VLco2AHcPRk+gEPpmMSnvo3yJALFBmTbSJpnVkqhuB9Gt
         8EHNUY0OlPGWkrFWUAntuPk6nV2yKWjeFm3XVlPCbG3AiqbuCWGHxuX4S1ggkuDTwnTK
         pAVtany/BCMD2H6uiOZpMRhhfauB/n6rwp1IIxi4AKL8yaA/tJpOdua/b+bg/Ojt65Ax
         daQx7l6Ow+5ctIc/VS3UqL4n7LW0w6qVtyiZkaen1rQz0Hjd6BPvfaBCE2ea/uP64UIJ
         OMBg==
X-Forwarded-Encrypted: i=1; AJvYcCWNaEWQ5Brsch+afO8bkUKVV8bpD30+Lpxntjr6ZljkfSzhXyC+1vKHZ4rbypc/RZX4u/iQb3NYQCRC@vger.kernel.org
X-Gm-Message-State: AOJu0YyOETbMCGJ7ZwyZH2rxaVcJMpD0qjfbQU6vbvzlrMngpfAMU6Lh
	ERK/aB+4QsIdRDfpeDsrfLKA3XMnPaLod3mmW8pcGUg6q3fRVh5ml4b/wDIP9GLe2RzvTyt0ZuE
	FcK3A0rLsdRW/PB14yjwgTTdcO26KkL4=
X-Gm-Gg: ASbGncuZYsioMaR47BEF+f4rcNO4S+ca9gTATQrjTP1VefwjpmrlU/AhnAKCUloL2dS
	KET2M23jr8yZytK2/T00KoVw/K8WBQMYAIXUGgfA3KYp4gLzx2EjHL9szk1SOdNCDwrgj7o5kzP
	1syzQTxVsHIO1t9ctBGMYI7OTrXtcVSdg0Cq5D8XFAUJ1R
X-Google-Smtp-Source: AGHT+IFdPncwf8HYvQgAgbwdAzmdbos3BBs5eb6zahZ6mqn3dw5EG3Ncs0qdH4PaLVukO1+g7mT/CqsqsqO0iUCNpDA=
X-Received: by 2002:a05:6214:3015:b0:6e8:fe16:4d44 with SMTP id
 6a1803df08f44-6fb2c372776mr37292066d6.31.1749620566509; Tue, 10 Jun 2025
 22:42:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250606052747.742998-1-dlemoal@kernel.org> <aEZ2C93sEiFRzGEE@infradead.org>
 <CALOAHbDmSjaBjG7-yTm4FOxwY-mhR0ea610ZyTb-TPzLZOu2Lw@mail.gmail.com>
 <a177a03c-5545-4211-a401-da15722c2e65@kernel.org> <CALOAHbC2nhFN7FR5k+9V6=Bx+b4wpT_XZ8R6U-TPKHFn6tss-A@mail.gmail.com>
 <b46403b6-3eaf-4152-ad2a-c6c5402dfcac@kernel.org>
In-Reply-To: <b46403b6-3eaf-4152-ad2a-c6c5402dfcac@kernel.org>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 11 Jun 2025 13:42:10 +0800
X-Gm-Features: AX0GCFsxlr8wi21jTJUYANgTE4TzU53pzsK3BDAV_bW1q_U1Qhn4vzjVVfgE5eY
Message-ID: <CALOAHbAgOP-+=QfwXT8kSB=NXivJmw65shmAt69z5mH8QYXzxw@mail.gmail.com>
Subject: Re: [PATCH 0/2] Improve ATA NCQ command error in mpt3sas and mpi3mr
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, "Martin K . Petersen" <martin.petersen@oracle.com>, 
	linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, 
	Kashyap Desai <kashyap.desai@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, mpi3mr-linuxdrv.pdl@broadcom.com, 
	MPT-FusionLinux.pdl@broadcom.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 11, 2025 at 11:59=E2=80=AFAM Damien Le Moal <dlemoal@kernel.org=
> wrote:
>
> On 6/11/25 12:27 PM, Yafang Shao wrote:
> > On Mon, Jun 9, 2025 at 3:18=E2=80=AFPM Damien Le Moal <dlemoal@kernel.o=
rg> wrote:
> >>
> >> On 6/9/25 16:09, Yafang Shao wrote:
> >>> On Mon, Jun 9, 2025 at 1:50=E2=80=AFPM Christoph Hellwig <hch@infrade=
ad.org> wrote:
> >>>>
> >>>> Adding Yafang Shao <laoar.shao@gmail.com>, who has a test case, whic=
h
> >>>> I think promted this.
> >>
> >> Note that cdl-tools test suite has many test cases that do not pass wi=
thout the
> >> mpi3mr patch. CDL makes it easy to trigger the issue.
> >>
> >>>
> >>> Thank you for the information and for addressing this so quickly!
> >>>
> >>>>
> >>>> Yafang, can you check if this makes the writeback errors you're seei=
ng
> >>>> go away?
> >>>
> >>> I=E2=80=99m happy to test the fix and will share the results as soon =
as I have them.
> >>
> >> Thanks. And my apologies for forgetting to CC you on these patches.
> >
> > We have developed and deployed a hotfix to hundreds of our production
> > servers equipped with this drive, and it has been functioning as
> > expected so far. We are currently rolling it out to the remaining
> > production servers, though the process may take some time to complete.
> >
> > Additionally, we encountered a writeback error in the libata driver,
> > which appears to be related to DID_TIME_OUT. Do you have any insights
> > into this issue?
> >
> > [Tue Jun 10 13:27:47 2025] sd 14:0:0:0: [sdl] tag#30 FAILED Result:
> > hostbyte=3DDID_TIME_OUT driverbyte=3DDRIVER_OK cmd_age=3D31s
>
> No idea. Timeout is hard to debug... A bus trace would help. It could be =
that
> the drives are really bad and taking too long per command, thus causing t=
ime
> out for commands that are at the end of the queue. E.g., if you hit many =
bad
> sectors with read commands, the drive internal retry mechanism may cause =
such
> read command to take several seconds. So if you are running the drives at=
 high
> queue depth, this can easily cause timeouts for the commands that are at =
the
> end of the queue.

Thank you for the detailed explanation. We will investigate this further.

--=20
Regards
Yafang
