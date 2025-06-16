Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292933C2F
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jun 2025 12:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750077674; cv=none; b=KeZaCmT3jgYZ2ewWW+I5VnYqYPzwOjDJnVWN/9LS/V8enJX5RiTSnZlJEIF6/8qC1c+3rdP6509VlqX0qFywfsLxGwV/QOQcQ/vKzAOpZqz5n1iWEv6naVNH9O5SUA50XIupvuGy0g5XgA0/GmPewVWujmSmdNCwUw2NlComqmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750077674; c=relaxed/simple;
	bh=4rewzbgyNQOEkaGM8AEuh8ngwaMICEOha/tISWILiIU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i/9vcIo/vZ5kz72RSu35NNqwpUD1N1NQul3ZpQoX8D4HGGBqEr5iT1BxpTsf+B2qmYO/874DZInEDOjZDDYEIYNf28Z7iMyQZ5zSvFLYgQiL1hfZUS+0PWIU0FeXETG+x8+wBsIaFTk8TeaoDZVY2W4wnQWf1gPH9aWJqD/Fk4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hHbo5CaC; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hHbo5CaC"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-6fad8b4c927so38490526d6.0
        for <linux-scsi@vger.kernel.org>; Mon, 16 Jun 2025 05:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750077672; x=1750682472; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qnCJFJyMCymZ0DnsCjUsw7EV9uEcUODlK/UGl049l+Q=;
        b=hHbo5CaCx2mV1or+hs4u2OwFjyE71O03emvWwhsYKAnkCDShphQfh8q9/biZAP7OXv
         YugeXOhPxBJ/atwmWoPtQ/VBFuHbtYwN/ysCvPAGwSrvg7ACR9tnTtLnIZKQaKo6Rchq
         S0CxanBdq/LQOJRMFOl3Y3moLXMjG6/AO06+4SU6vj+KtMzvxfT7gZmvgsJupr27s4yv
         NxHfm5I2eMD6Q/5dF+m+kUJVmCAbwhI9nTS4LfIQWPnufzfT667AoKI4MwU+2ZzO+JQi
         hIj1u3A/746Th6u8uFt0fEBmJNsMyTc4lG8IlNi0bIP3Yk0HAl3apJgrI+hw6DoB8ijZ
         5HeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750077672; x=1750682472;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qnCJFJyMCymZ0DnsCjUsw7EV9uEcUODlK/UGl049l+Q=;
        b=aleNuc7lvbmGTUR4Jpx9GD4KtH4uPwfdu//Bhbr1UylLn0+/2DRZL0J1AyYn+gNrBm
         jeBa+34elndLQ5d4IiK8cpbVQVtbGWz31peo5yc5lDQM46AbqnAaKkiwEnA16Lq2jrjc
         FSUBpitCPAORGLeCy+X4f08muiHwiTk13WBbKTvrqw5L/DmWUF+/rpRLUOLX70JHi7RI
         zwypq0eQytYQBwCBhmmt+ZTZUDRDRMfAXgoMmClPu5nnPX4qaWdJTpdoAcIfV81NKgjj
         UFwNfcnqLBfY8bt5OsQDNQ3BrIvNDMaVj8GigYQ6kaQEcYyz9gKqRqzIlKYr2J22ZIhH
         Mx2w==
X-Forwarded-Encrypted: i=1; AJvYcCUyXB/4LBj9fKpmGfv7q6ruoDVrU+ebxf1SEAOcGKnKezfYCPZrDqeh44rltkk5OOsOb9//uJBHgTTV@vger.kernel.org
X-Gm-Message-State: AOJu0YxZM9VhxXzhZFLLShIj2Wv0jWr7Z5GIW8IFQx2wYrw2ztT+J9b9
	jk+auQnfdVdNpubST7GusS0PwrayRiQrlB0hIocSJd1FHgrmrB51iCxVKBoYKjS7Zb+BfXTZZ+E
	SOYfHEZSWi5JsVpb942ek949DEwOigYY=
X-Gm-Gg: ASbGncsR0W6lMRJTOHO4MaLo8ulTMoN+edyZ1l+xpKoBpYaHmckW/EcO3LPdB/YOAq5
	4IbHGplTHLl0grUUUhZHdlcAQs2N4DWaYvyUkFizat4KTTgBDnQgoISlif88l735OqD1XUjx8tj
	iPPtxkHM+PEP950ujJelQUMqOgAt6CMW9Du7Duz12v+8xA
X-Google-Smtp-Source: AGHT+IHIQZVi6UoU1e/h8AsYwYgDwJXug89ercCFxCqAALZrFrQUnA94ivVi5m8WoRgef2e6WyEtysZY8/bJA89DAfM=
X-Received: by 2002:a05:6214:5884:b0:6fb:44a:3d36 with SMTP id
 6a1803df08f44-6fb4777845fmr140201046d6.20.1750077672003; Mon, 16 Jun 2025
 05:41:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250606052747.742998-1-dlemoal@kernel.org> <aEZ2C93sEiFRzGEE@infradead.org>
 <CALOAHbDmSjaBjG7-yTm4FOxwY-mhR0ea610ZyTb-TPzLZOu2Lw@mail.gmail.com>
 <CALOAHbBkdjz+ujYnAKYvxaQsyd_juDKg38-G8Sk+cKCN_0HftQ@mail.gmail.com> <e0ac9296-a688-4146-bb1b-e5ef7dc4b5e1@kernel.org>
In-Reply-To: <e0ac9296-a688-4146-bb1b-e5ef7dc4b5e1@kernel.org>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Mon, 16 Jun 2025 20:40:34 +0800
X-Gm-Features: AX0GCFsMrjWjZxEiS04BAzSSqBgAwFizYqZMc4yj_2TNVrhgzHQM30vtp1lq8FY
Message-ID: <CALOAHbCFQkw3ZtkUngGD31_y4JY0OYSoxCuRjBr_=NMwmyBVLw@mail.gmail.com>
Subject: Re: [PATCH 0/2] Improve ATA NCQ command error in mpt3sas and mpi3mr
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, "Martin K . Petersen" <martin.petersen@oracle.com>, 
	linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, 
	Kashyap Desai <kashyap.desai@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, mpi3mr-linuxdrv.pdl@broadcom.com, 
	MPT-FusionLinux.pdl@broadcom.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 16, 2025 at 10:28=E2=80=AFAM Damien Le Moal <dlemoal@kernel.org=
> wrote:
>
> On 6/16/25 11:13, Yafang Shao wrote:
> > On Mon, Jun 9, 2025 at 3:09=E2=80=AFPM Yafang Shao <laoar.shao@gmail.co=
m> wrote:
> >>
> >> On Mon, Jun 9, 2025 at 1:50=E2=80=AFPM Christoph Hellwig <hch@infradea=
d.org> wrote:
> >>>
> >>> Adding Yafang Shao <laoar.shao@gmail.com>, who has a test case, which
> >>> I think promted this.
> >>
> >> Thank you for the information and for addressing this so quickly!
> >>
> >>>
> >>> Yafang, can you check if this makes the writeback errors you're seein=
g
> >>> go away?
> >>
> >> I=E2=80=99m happy to test the fix and will share the results as soon a=
s I have them.
> >
> > We=E2=80=99ve confirmed that the DID_SOFT_ERROR issue no longer occurs =
after
> > applying this patch series to our production servers. Since our
> > production servers only use mpt3sas drives, we can verify the fix
> > specifically for this driver:
> >
> > Tested-by: Yafang Shao <laoar.shao@gmail.com>
>
> Thansk. I tested with the mpi3mr driver.
>
>
> > We=E2=80=99ve encountered another instance of DID_SOFT_ERROR triggered =
by a
> > reset on an mpt3sas drive. Do you have any insights into what might be
> > causing this failure? Below are the error details:
> >
> > [Thu Jun 12 17:57:35 2025] mpt3sas_cm0: log_info(0x31110610):
> > originator(PL), code(0x11), sub_code(0x0610)
>
> This decodes to:
>
> Value           31110610h
> Type:           30000000h       SAS
> Origin:         01000000h       PL
> Code:           00110000h       PL_LOGINFO_CODE_RESET See Sub-Codes below=
 (PL_LOGINFO_SUB_CODE)
> Sub Code:       00000600h       PL_LOGINFO_SUB_CODE_SATA_NON_NCQ_RW_ERR_B=
IT_SET
>
> So it looks like a non-NCQ command failed. What were you doing when this =
happened ?

After reviewing the logs, we were unable to identify any relevant
information regarding the issue.
We appreciate your continued support in resolving this matter.

>
> > [Thu Jun 12 17:57:35 2025] mpt3sas_cm0: log_info(0x31110610):
> > originator(PL), code(0x11), sub_code(0x0610)
> > [Thu Jun 12 17:57:35 2025] sd 8:0:9:0: Power-on or device reset occurre=
d
>
> And this command failure is trigerring a device reset (the HBA may be doi=
ng
> that, or the drive did not like what you were doing and reset).
>
> > [Thu Jun 12 20:07:53 2025] mpt3sas_cm0: In func: _ctl_do_mpt_command
> > [Thu Jun 12 20:07:53 2025] mpt3sas_cm0: Command Timeout
>
> This looks like an ioctl() to the adapter diver, and it never got its rep=
ly
> apparently. This is 3 hours after the above power-on-reset, so these 2 ev=
ents
> are likely not related...
>
> > [Thu Jun 12 20:07:53 2025] mf:
>
> This is dumping the mpi_request bytes. Maybe you can try to decode that t=
o get
> hints as to what action triggered this.
>
> I would love to get feedback from the Broadcom folks on this kind of prob=
lems,
> but apparently, debugging issues with their HBA does not seem to be high =
on
> their to-do list.
>
> Broadcom folks,
>
> Could you please comment on these issues ? Not the first time I ask. A re=
ply
> would be welcome so that we all know that you at least care about issues =
with
> your drivers/HBAs. Thank you.

We have reached out to Broadcom's team directly and hope they will
respond both to our inquiry and to this email correspondence.

--=20
Regards
Yafang
