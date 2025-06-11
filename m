Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1DE66BFCE
	for <linux-scsi@vger.kernel.org>; Wed, 11 Jun 2025 03:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749612493; cv=none; b=VfveGmw9KHWDVCJEEtiJYwaS+pLNBL1/l9UlwZtgH4ENuRuHelRjaOGLAqrO2WZVQPlSu4cn6BO3YBdfhQX8LNnhu7cAzroBWv/B7jkCOc8wBomFUkWd8ggUrFBnQ7nQX35JJlVcD2snB42fAKejjldQIy9qo94bkc8Dqtlqs0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749612493; c=relaxed/simple;
	bh=LmP9wJzym8B8fNMRJaHSGhwISbvrFtShOtYZr1gmrqk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RJzP6IPYT+sHmZoP6erGrKZO+RhU/Jca3nEerYcZSnIxbGBqaL2lPqvfOzkcB7YKDtsVLeoEnhsL2PXQcegmNgZaxiJdVVBpqOqlcLb+ds5uM2M+ZBeFA9aT6WaC3KEGOLoIjQjkA20CL+pN6OLSt4QJOEI22Zdp4LSRZkSEQ5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AREBu7++; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AREBu7++"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4a5903bceffso79860911cf.3
        for <linux-scsi@vger.kernel.org>; Tue, 10 Jun 2025 20:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749612490; x=1750217290; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LmP9wJzym8B8fNMRJaHSGhwISbvrFtShOtYZr1gmrqk=;
        b=AREBu7++7NgaV6HSGOok8Rp76/+HhnG/WCFvQj9dCSHwtpbQHEIcGn+Hgly6BZxnI2
         DcavEFaTQ1Gx3BiP8VjDKrrWBn93DltKaANqXS6tSa2/uEw+RZ4enEXYhpcGhIWOJgJL
         ST5O3vLgKTr0JYZotyb2hIlbEKJ12JI4XROWK9Tp0jHysOkbk/4JbTgK3UBom188Npgg
         bzmTRYK4wLLz8ijvXk6ASINn0DKWWnDHPdejiTS2o3iJUoTW9PkjPcLF3takzqrJmgy6
         kpW6lMWyBR2qBM/3xYHJtD1OFBhIQ9nG2reqdNTd0F76WmjGJ3ULFHStgMudkKN3Jjig
         xlLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749612490; x=1750217290;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LmP9wJzym8B8fNMRJaHSGhwISbvrFtShOtYZr1gmrqk=;
        b=ICg9cyJ1xX7NDqbThFzo0V0USCcfHAgz1JmRQQZBMof/8J4SdxlUJ/+lnCgw00zLLB
         FRGzkSO85R8H/iE8Ogm/cqEwx6K7eRMncniOpLfWJWBZTTfr1x+bmsJ0Hqgk6XzRkazN
         jrYK4MLKD0853WaI9yspmIck4Tadl7nBCx/5tuE221U5WG9dLhA2a6R+HhcHS05BIbza
         vjMeLAtNwu000Ogi8uTyw+3ZQUzDF9nZPo8FS+4OwA0bsbSIcau0jdXEa4ayVSQWEYj2
         N3TrrTz5z8iHf8sqDfHqoch8WmZ7XlmxdV8/pkg4h8UtYwGOv61ShxQCy4FxGrHlNDfw
         +GLQ==
X-Forwarded-Encrypted: i=1; AJvYcCVHGKVhTwGfEHvnHi2PwKFfV5BWx7gaKNTgKMe+InucMMkajf54gjaNEVCWNPjwRlQQSDUYKk/5RzdN@vger.kernel.org
X-Gm-Message-State: AOJu0YyG6YIqYzuDrg71ujZe4qxDa8QXLnSMqzxKDvBnbhLlxDJeg4rb
	gFr19dVi2u2BOXFSh+SwP1WtvHKiulFjmvKTBrdCYZvFo/4+a2Dkxpb4xLpyd+gerIConlhcIjH
	TxVYAgGE7VICdXONoI6er6iqUPSszo/g=
X-Gm-Gg: ASbGnctqE9f4PwTZ1v8sIaMENaSo5OjeZJw4thItPLDBmEXyOgWPZpnegcqv0SlpJrv
	lhpKllHwm6dh9qZtt6QrvI6WFRAe0tL5v9RmjYY7rZFIB/6QED1h8jUfkafcSCS3zzfPu5+PiRb
	QMlAWtRPLC5yCesOFGRnMtQvYHWKt5AEL59c19SumSX50s
X-Google-Smtp-Source: AGHT+IFgB26M6d2fr8I+lxBkk1br2CBMJMNpROGavfxwyHl6GvfCkEj8Ztx0AcA0gktJGxDpfFVZ5CoALD4RsUIIS7E=
X-Received: by 2002:a05:6214:2263:b0:6fa:f94e:6e82 with SMTP id
 6a1803df08f44-6fb2c31b3a3mr34291526d6.7.1749612490577; Tue, 10 Jun 2025
 20:28:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250606052747.742998-1-dlemoal@kernel.org> <aEZ2C93sEiFRzGEE@infradead.org>
 <CALOAHbDmSjaBjG7-yTm4FOxwY-mhR0ea610ZyTb-TPzLZOu2Lw@mail.gmail.com> <a177a03c-5545-4211-a401-da15722c2e65@kernel.org>
In-Reply-To: <a177a03c-5545-4211-a401-da15722c2e65@kernel.org>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 11 Jun 2025 11:27:34 +0800
X-Gm-Features: AX0GCFuJ2DCsC6JiGnT4G8ZnVvFiALrGad9zKt4UjI1_2D0hpOzJ1O8g4tpDLQo
Message-ID: <CALOAHbC2nhFN7FR5k+9V6=Bx+b4wpT_XZ8R6U-TPKHFn6tss-A@mail.gmail.com>
Subject: Re: [PATCH 0/2] Improve ATA NCQ command error in mpt3sas and mpi3mr
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, "Martin K . Petersen" <martin.petersen@oracle.com>, 
	linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, 
	Kashyap Desai <kashyap.desai@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, mpi3mr-linuxdrv.pdl@broadcom.com, 
	MPT-FusionLinux.pdl@broadcom.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 9, 2025 at 3:18=E2=80=AFPM Damien Le Moal <dlemoal@kernel.org> =
wrote:
>
> On 6/9/25 16:09, Yafang Shao wrote:
> > On Mon, Jun 9, 2025 at 1:50=E2=80=AFPM Christoph Hellwig <hch@infradead=
.org> wrote:
> >>
> >> Adding Yafang Shao <laoar.shao@gmail.com>, who has a test case, which
> >> I think promted this.
>
> Note that cdl-tools test suite has many test cases that do not pass witho=
ut the
> mpi3mr patch. CDL makes it easy to trigger the issue.
>
> >
> > Thank you for the information and for addressing this so quickly!
> >
> >>
> >> Yafang, can you check if this makes the writeback errors you're seeing
> >> go away?
> >
> > I=E2=80=99m happy to test the fix and will share the results as soon as=
 I have them.
>
> Thanks. And my apologies for forgetting to CC you on these patches.

We have developed and deployed a hotfix to hundreds of our production
servers equipped with this drive, and it has been functioning as
expected so far. We are currently rolling it out to the remaining
production servers, though the process may take some time to complete.

Additionally, we encountered a writeback error in the libata driver,
which appears to be related to DID_TIME_OUT. Do you have any insights
into this issue?

[Tue Jun 10 13:27:47 2025] sd 14:0:0:0: [sdl] tag#30 FAILED Result:
hostbyte=3DDID_TIME_OUT driverbyte=3DDRIVER_OK cmd_age=3D31s
[Tue Jun 10 13:27:47 2025] sd 14:0:0:0: [sdl] tag#30 CDB: Write(16) 8a
00 00 00 00 08 2c eb 4a 58 00 00 02 c0 00 00
[Tue Jun 10 13:27:47 2025] I/O error, dev sdl, sector 35113355864 op
0x1:(WRITE) flags 0x100000 phys_seg 88 prio class 2
[Tue Jun 10 13:27:47 2025] sd 14:0:0:0: [sdl] tag#29 FAILED Result:
hostbyte=3DDID_TIME_OUT driverbyte=3DDRIVER_OK cmd_age=3D31s
[Tue Jun 10 13:27:47 2025] sd 14:0:0:0: [sdl] tag#29 CDB: Write(16) 8a
00 00 00 00 08 2c eb 45 18 00 00 05 40 00 00
[Tue Jun 10 13:27:47 2025] I/O error, dev sdl, sector 35113354520 op
0x1:(WRITE) flags 0x104000 phys_seg 168 prio class 2
[Tue Jun 10 13:27:47 2025] sd 14:0:0:0: [sdl] tag#28 FAILED Result:
hostbyte=3DDID_TIME_OUT driverbyte=3DDRIVER_OK cmd_age=3D31s
[Tue Jun 10 13:27:47 2025] sd 14:0:0:0: [sdl] tag#28 CDB: Write(16) 8a
00 00 00 00 08 2c eb 42 58 00 00 02 c0 00 00
[Tue Jun 10 13:27:47 2025] I/O error, dev sdl, sector 35113353816 op
0x1:(WRITE) flags 0x100000 phys_seg 88 prio class 2
[Tue Jun 10 13:27:47 2025] sd 14:0:0:0: [sdl] tag#22 FAILED Result:
hostbyte=3DDID_TIME_OUT driverbyte=3DDRIVER_OK cmd_age=3D31s
[Tue Jun 10 13:27:47 2025] sd 14:0:0:0: [sdl] tag#22 CDB: Read(16) 88
00 00 00 00 03 d8 33 44 18 00 00 02 c0 00 00
[Tue Jun 10 13:27:47 2025] I/O error, dev sdl, sector 16512140312 op
0x0:(READ) flags 0x80700 phys_seg 88 prio class 2
[Tue Jun 10 13:27:47 2025] sd 14:0:0:0: [sdl] tag#21 FAILED Result:
hostbyte=3DDID_TIME_OUT driverbyte=3DDRIVER_OK cmd_age=3D31s
[Tue Jun 10 13:27:47 2025] sd 14:0:0:0: [sdl] tag#21 CDB: Read(16) 88
00 00 00 00 03 d8 33 3e d8 00 00 05 40 00 00
[Tue Jun 10 13:27:47 2025] I/O error, dev sdl, sector 16512138968 op
0x0:(READ) flags 0x84700 phys_seg 168 prio class 2
[Tue Jun 10 13:27:47 2025] sd 14:0:0:0: [sdl] tag#20 FAILED Result:
hostbyte=3DDID_TIME_OUT driverbyte=3DDRIVER_OK cmd_age=3D31s
[Tue Jun 10 13:27:47 2025] sd 14:0:0:0: [sdl] tag#20 CDB: Read(16) 88
00 00 00 00 03 d8 33 3c 18 00 00 02 c0 00 00
[Tue Jun 10 13:27:47 2025] I/O error, dev sdl, sector 16512138264 op
0x0:(READ) flags 0x80700 phys_seg 88 prio class 2
[Tue Jun 10 13:27:47 2025] sd 14:0:0:0: [sdl] tag#19 FAILED Result:
hostbyte=3DDID_TIME_OUT driverbyte=3DDRIVER_OK cmd_age=3D31s
[Tue Jun 10 13:27:47 2025] sd 14:0:0:0: [sdl] tag#19 CDB: Write(16) 8a
00 00 00 00 08 2c eb 3d 18 00 00 05 40 00 00
[Tue Jun 10 13:27:47 2025] I/O error, dev sdl, sector 35113352472 op
0x1:(WRITE) flags 0x104000 phys_seg 168 prio class 2
[Tue Jun 10 13:27:47 2025] sd 14:0:0:0: [sdl] tag#15 FAILED Result:
hostbyte=3DDID_TIME_OUT driverbyte=3DDRIVER_OK cmd_age=3D31s
[Tue Jun 10 13:27:47 2025] sd 14:0:0:0: [sdl] tag#15 CDB: Read(16) 88
00 00 00 00 03 2c e9 4e b8 00 00 00 98 00 00
[Tue Jun 10 13:27:47 2025] I/O error, dev sdl, sector 13638389432 op
0x0:(READ) flags 0x80700 phys_seg 19 prio class 2
[Tue Jun 10 13:27:47 2025] sd 14:0:0:0: [sdl] tag#14 FAILED Result:
hostbyte=3DDID_TIME_OUT driverbyte=3DDRIVER_OK cmd_age=3D31s
[Tue Jun 10 13:27:47 2025] sd 14:0:0:0: [sdl] tag#14 CDB: Read(16) 88
00 00 00 00 03 2c e9 4c b8 00 00 02 00 00 00
[Tue Jun 10 13:27:47 2025] I/O error, dev sdl, sector 13638388920 op
0x0:(READ) flags 0x80700 phys_seg 64 prio class 2
[Tue Jun 10 13:27:47 2025] sd 14:0:0:0: [sdl] tag#13 FAILED Result:
hostbyte=3DDID_TIME_OUT driverbyte=3DDRIVER_OK cmd_age=3D31s
[Tue Jun 10 13:27:47 2025] sd 14:0:0:0: [sdl] tag#13 CDB: Read(16) 88
00 00 00 00 03 d8 33 36 d8 00 00 05 40 00 00
[Tue Jun 10 13:27:47 2025] I/O error, dev sdl, sector 16512136920 op
0x0:(READ) flags 0x84700 phys_seg 168 prio class 2
[Tue Jun 10 13:27:47 2025] XFS (sdl): metadata I/O error in
"xfs_imap_to_bp+0x4f/0x70 [xfs]" at daddr 0x4804c4398 len 32 error 5
[Tue Jun 10 13:27:48 2025] sdl: writeback error on inode 32213499599,
offset 0, sector 35113332208

--=20
Regards
Yafang
