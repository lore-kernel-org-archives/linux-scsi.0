Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB9513BC0C
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jun 2025 02:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750040034; cv=none; b=bBb3mgtOQMPvFoN8zplMKyEaMhxBdL/nrypVCk98r4uDrUGq2sgePsuyO/CspgoOZfE8QGQ8VTDPT2WjlvVj+5M4VMNeGmYo5dM/W1yFy+3W7Gy/z/l9OUpifb+srKIB4qHcPoxrg0Vng9cAEhvezW5PQdtjm+hoscGwqXc9Xg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750040034; c=relaxed/simple;
	bh=dGINKB/W6+1Xur1IrzAUOGEgNxHENqc5EyhMLe/22Bw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YQcQIgGGo66w92KfN7srpkAnZOsxToDbEXsq3uEr/PU0/JJWxMcf9T4gEPQACXas80iXK9RE/Lml5+U+OdS6SXMIbkfNOkbWwRTwYVcz7KbduOdaflnKSQyCUv13vutrEdCGtRLrijqS1nFEXYzhZlYRmVENuGRTj/eymeRTyhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VLV8AH2r; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VLV8AH2r"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-6fafdd322d3so43007276d6.3
        for <linux-scsi@vger.kernel.org>; Sun, 15 Jun 2025 19:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750040032; x=1750644832; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dGINKB/W6+1Xur1IrzAUOGEgNxHENqc5EyhMLe/22Bw=;
        b=VLV8AH2r/0/6EN2bz3GuNM64V/T7/W/gYW8zAa0tXeZqv8RPXAZA7pUl7mMfocBC/1
         YECbt4WaHFfwAIDhJ1cIdcX6KoF7J9Jb0Voq1LSNgusrcJ9tvfw0mUYQm16PnkxpVxDg
         m4yuaQ3hA/z1/1FgxZOZ2OPv8hjfAmMN7mo4INl8SKsNjcMIuiXgT/7umDw3oz72oPqr
         Su3EIsQrJDdhckq+uODz80ddVWY8+Vr2Abx9ZZD/cNTs0rCpURa/4BmLc7U4TXXbZiIx
         +zVx6OSp9De+2Pfk0orEbvX3vzc3hFOfYrze5ekg+Ejn4ocvS4q+kv4/1pbyQiPdj/dF
         cW6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750040032; x=1750644832;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dGINKB/W6+1Xur1IrzAUOGEgNxHENqc5EyhMLe/22Bw=;
        b=kzg5emeNGRfRkMR4igGaTNkoUdWznWH+RUonzopNcpYQlFUVydAAOT7s4M+on47TLY
         19n2P0VEwPvtwM7rosbFW/RH957qENgl0ku3ndR7enjN85m7lwcOmEMFzASuU+nDIs1y
         OeVueKTBxaOnx1mDjra8pv2efDd2267debftPHUxhaK/iCoGAxSJhIX8Cxn1aoQ2Ggnj
         tXwdz60VISHn8Upv/8M9fBVJUpxtKPXNczT88T4QX/VZrFRReCyfEMwQc5dNS0IANGyl
         URY8VGUZsBYGCHP/mCfXY8MICAmyRNo/DYfvczSEPEu0CG600gvrSaCj7bB4vDpgtfeC
         KOYA==
X-Forwarded-Encrypted: i=1; AJvYcCVbfZ6TfXsmlx4kcOU6TMgdS5FHoD86Ibr+ZVij/RuM4ISmkKDWIO4V7RXSb462WgN1/t46EjLnZOjz@vger.kernel.org
X-Gm-Message-State: AOJu0YytZZNDfeQTpesC8cLbezeehed1003PVakOzPRM62Lx6kS+E09Q
	FJpYJ4HZ6Bv8sGJt8tmMBkM5MCv6IYoeesbPw9ATvlHox+YT1NPLfD3V53lEo8iDD5wUqXiPQF/
	S1G7ls/eyjaI3ELYDvBoqCyxOVklAIoE=
X-Gm-Gg: ASbGnctwzMSPpsiWSnIY/tpXmyPXrF041gsXJfoyPkkOmYQsbb7UKDTedet/cg1yyFv
	5HQ7yPYfJjz1MZo+EZtngb+bx/VQDXcrbp0dl1hDEE/I+/SX8j9zsP3wccIzovjzEb+AvPbQkgr
	+B3rePUX0GVhaxQcszPIjFSck2br/PafBc5Ft5qIj6WfdM
X-Google-Smtp-Source: AGHT+IEyOlOVtHykZvQr9XjXWRogUDWlFWq81e1kH3CnEABhrcIDINQzSTCPpz++iyOfwIovjo8svtU2z9NukU3z3N4=
X-Received: by 2002:a05:6214:434a:b0:6fb:37:7405 with SMTP id
 6a1803df08f44-6fb4774af8bmr138581326d6.19.1750040031937; Sun, 15 Jun 2025
 19:13:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250606052747.742998-1-dlemoal@kernel.org> <aEZ2C93sEiFRzGEE@infradead.org>
 <CALOAHbDmSjaBjG7-yTm4FOxwY-mhR0ea610ZyTb-TPzLZOu2Lw@mail.gmail.com>
In-Reply-To: <CALOAHbDmSjaBjG7-yTm4FOxwY-mhR0ea610ZyTb-TPzLZOu2Lw@mail.gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Mon, 16 Jun 2025 10:13:15 +0800
X-Gm-Features: AX0GCFtNh6ps7IoknBID_B8yVA57Of083tvT_zK2RFL6oU5O8ZcNEYqJd9GPxJo
Message-ID: <CALOAHbBkdjz+ujYnAKYvxaQsyd_juDKg38-G8Sk+cKCN_0HftQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] Improve ATA NCQ command error in mpt3sas and mpi3mr
To: Christoph Hellwig <hch@infradead.org>, Damien Le Moal <dlemoal@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, 
	Sathya Prakash <sathya.prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, 
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, mpi3mr-linuxdrv.pdl@broadcom.com, 
	MPT-FusionLinux.pdl@broadcom.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 9, 2025 at 3:09=E2=80=AFPM Yafang Shao <laoar.shao@gmail.com> w=
rote:
>
> On Mon, Jun 9, 2025 at 1:50=E2=80=AFPM Christoph Hellwig <hch@infradead.o=
rg> wrote:
> >
> > Adding Yafang Shao <laoar.shao@gmail.com>, who has a test case, which
> > I think promted this.
>
> Thank you for the information and for addressing this so quickly!
>
> >
> > Yafang, can you check if this makes the writeback errors you're seeing
> > go away?
>
> I=E2=80=99m happy to test the fix and will share the results as soon as I=
 have them.

We=E2=80=99ve confirmed that the DID_SOFT_ERROR issue no longer occurs afte=
r
applying this patch series to our production servers. Since our
production servers only use mpt3sas drives, we can verify the fix
specifically for this driver:

Tested-by: Yafang Shao <laoar.shao@gmail.com>


Hello Damien,

We=E2=80=99ve encountered another instance of DID_SOFT_ERROR triggered by a
reset on an mpt3sas drive. Do you have any insights into what might be
causing this failure? Below are the error details:

[Thu Jun 12 17:57:35 2025] mpt3sas_cm0: log_info(0x31110610):
originator(PL), code(0x11), sub_code(0x0610)
[Thu Jun 12 17:57:35 2025] mpt3sas_cm0: log_info(0x31110610):
originator(PL), code(0x11), sub_code(0x0610)
[Thu Jun 12 17:57:35 2025] sd 8:0:9:0: Power-on or device reset occurred
[Thu Jun 12 20:07:53 2025] mpt3sas_cm0: In func: _ctl_do_mpt_command
[Thu Jun 12 20:07:53 2025] mpt3sas_cm0: Command Timeout
[Thu Jun 12 20:07:53 2025] mf:

[Thu Jun 12 20:07:53 2025] 00000013
[Thu Jun 12 20:07:53 2025] 00000000
[Thu Jun 12 20:07:53 2025] 00000000
[Thu Jun 12 20:07:53 2025] 9fcda615
[Thu Jun 12 20:07:53 2025] 00fc0000
[Thu Jun 12 20:07:53 2025] 00000018
[Thu Jun 12 20:07:53 2025] 00000000
[Thu Jun 12 20:07:53 2025] 000000ff
[Thu Jun 12 20:07:53 2025]

[Thu Jun 12 20:07:53 2025] 00000000
[Thu Jun 12 20:07:53 2025] 00000006
[Thu Jun 12 20:07:53 2025] 00000000
[Thu Jun 12 20:07:53 2025] 00000000
[Thu Jun 12 20:07:53 2025] 00000000
[Thu Jun 12 20:07:53 2025] 00000000
[Thu Jun 12 20:07:53 2025] 00000000
[Thu Jun 12 20:07:53 2025] 02000000
[Thu Jun 12 20:07:53 2025]

[Thu Jun 12 20:07:53 2025] 00000012
[Thu Jun 12 20:07:53 2025] 000000ff
[Thu Jun 12 20:07:53 2025] 00000000
[Thu Jun 12 20:07:53 2025] 00000000
[Thu Jun 12 20:07:53 2025] 00000000
[Thu Jun 12 20:07:53 2025] 00000000
[Thu Jun 12 20:07:53 2025] 00000000
[Thu Jun 12 20:07:53 2025] 00000000

[Thu Jun 12 20:07:53 2025] mpt3sas_cm0: issue target reset: handle =3D (0x0=
013)
[Thu Jun 12 20:07:56 2025] scsi_io_completion_action: 22 callbacks suppress=
ed
[Thu Jun 12 20:07:56 2025] blk_print_req_error: 22 callbacks suppressed
[Thu Jun 12 20:07:56 2025] I/O error, dev sdi, sector 190811280 op
0x0:(READ) flags 0x80700 phys_seg 28 prio class 2
[Thu Jun 12 20:07:56 2025] sd 8:0:9:0: [sdi] tag#2305 FAILED Result:
hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK cmd_age=3D17s
[Thu Jun 12 20:07:56 2025] sd 8:0:9:0: [sdi] tag#2336 FAILED Result:
hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK cmd_age=3D16s
[Thu Jun 12 20:07:56 2025] sd 8:0:9:0: [sdi] tag#2305 CDB: Read(16) 88
00 00 00 00 05 26 e3 68 40 00 00 04 00 00 00
[Thu Jun 12 20:07:56 2025] sd 8:0:9:0: [sdi] tag#2158 FAILED Result:
hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK cmd_age=3D17s
[Thu Jun 12 20:07:56 2025] I/O error, dev sdi, sector 22127274048 op
0x0:(READ) flags 0x80700 phys_seg 128 prio class 2
[Thu Jun 12 20:07:56 2025] sd 8:0:9:0: [sdi] tag#2158 CDB: Read(16) 88
00 00 00 00 03 0d 08 dc 38 00 00 04 00 00 00
[Thu Jun 12 20:07:56 2025] I/O error, dev sdi, sector 13103586360 op
0x0:(READ) flags 0x84700 phys_seg 128 prio class 2
[Thu Jun 12 20:07:56 2025] sd 8:0:9:0: [sdi] tag#2369 FAILED Result:
hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK cmd_age=3D17s
[Thu Jun 12 20:07:56 2025] sd 8:0:9:0: [sdi] tag#2369 CDB: Read(16) 88
00 00 00 00 01 50 ee 50 48 00 00 04 00 00 00
[Thu Jun 12 20:07:56 2025] I/O error, dev sdi, sector 5652762696 op
0x0:(READ) flags 0x80700 phys_seg 128 prio class 2
[Thu Jun 12 20:07:56 2025] sd 8:0:9:0: [sdi] tag#2368 FAILED Result:
hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK cmd_age=3D17s
[Thu Jun 12 20:07:56 2025] sd 8:0:9:0: [sdi] tag#2368 CDB: Read(16) 88
00 00 00 00 05 26 e3 64 10 00 00 00 20 00 00
[Thu Jun 12 20:07:56 2025] I/O error, dev sdi, sector 22127272976 op
0x0:(READ) flags 0x80700 phys_seg 4 prio class 2
[Thu Jun 12 20:07:56 2025] sd 8:0:9:0: [sdi] tag#2304 FAILED Result:
hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK cmd_age=3D17s
[Thu Jun 12 20:07:56 2025] sd 8:0:9:0: [sdi] tag#2157 FAILED Result:
hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK cmd_age=3D17s
[Thu Jun 12 20:07:56 2025] sd 8:0:9:0: [sdi] tag#2304 CDB: Read(16) 88
00 00 00 00 05 26 e3 64 30 00 00 04 10 00 00
[Thu Jun 12 20:07:56 2025] sd 8:0:9:0: [sdi] tag#2157 CDB: Read(16) 88
00 00 00 00 03 0d 08 d8 38 00 00 04 00 00 00
[Thu Jun 12 20:07:56 2025] I/O error, dev sdi, sector 22127273008 op
0x0:(READ) flags 0x84700 phys_seg 128 prio class 2
[Thu Jun 12 20:07:56 2025] I/O error, dev sdi, sector 13103585336 op
0x0:(READ) flags 0x80700 phys_seg 128 prio class 2
[Thu Jun 12 20:07:56 2025] sd 8:0:9:0: [sdi] tag#2400 FAILED Result:
hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK cmd_age=3D17s
[Thu Jun 12 20:07:56 2025] sd 8:0:9:0: [sdi] tag#2400 CDB: Read(16) 88
00 00 00 00 01 50 ee 58 48 00 00 04 00 00 00
[Thu Jun 12 20:07:56 2025] I/O error, dev sdi, sector 5652764744 op
0x0:(READ) flags 0x80700 phys_seg 128 prio class 2
[Thu Jun 12 20:07:56 2025] sd 8:0:9:0: [sdi] tag#2309 FAILED Result:
hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK cmd_age=3D17s
[Thu Jun 12 20:07:56 2025] sd 8:0:9:0: [sdi] tag#2309 CDB: Read(16) 88
00 00 00 00 05 26 e3 78 10 00 00 02 c0 00 00
[Thu Jun 12 20:07:56 2025] I/O error, dev sdi, sector 22127278096 op
0x0:(READ) flags 0x80700 phys_seg 88 prio class 2
[Thu Jun 12 20:07:56 2025] sd 8:0:9:0: [sdi] tag#2376 FAILED Result:
hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK cmd_age=3D17s
[Thu Jun 12 20:07:56 2025] sd 8:0:9:0: [sdi] tag#2376 CDB: Read(16) 88
00 00 00 00 03 80 11 3e c8 00 00 00 20 00 00
[Thu Jun 12 20:07:56 2025] I/O error, dev sdi, sector 15033515720 op
0x0:(READ) flags 0x80700 phys_seg 3 prio class 2
[Thu Jun 12 20:07:56 2025] mpt3sas_cm0: log_info(0x31140000):
originator(PL), code(0x14), sub_code(0x0000)
[Thu Jun 12 20:07:56 2025] mpt3sas_cm0: log_info(0x31140000):
originator(PL), code(0x14), sub_code(0x0000)
[Thu Jun 12 20:07:56 2025] sd 8:0:9:0: [sdi] tag#2336 CDB: Read(16) 88
00 00 00 00 01 50 ee 96 50 00 00 05 18 00 00
[Thu Jun 12 20:07:56 2025] mpt3sas_cm0: log_info(0x31140000):
originator(PL), code(0x14), sub_code(0x0000)
[Thu Jun 12 20:07:57 2025] XFS (sdi): metadata I/O error in
"xfs_da_read_buf+0xd9/0x130 [xfs]" at daddr 0x484022c68 len 8 error 5
[Thu Jun 12 20:07:59 2025] sd 8:0:9:0: Power-on or device reset occurred
[Thu Jun 12 20:07:59 2025] sdi: writeback error on inode 12885147175,
offset 1285156864, sector 13979483112


--=20
Regards
Yafang
