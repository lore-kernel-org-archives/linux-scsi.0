Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD4839281B
	for <linux-scsi@vger.kernel.org>; Wed, 25 Feb 2026 10:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772014528; cv=pass; b=Hhyhqw3/OoHUPmTHJ3KyTGBYqQA4I5nw2FvdJ+uLLwIvo5r/VSDZ1CDADUfBGM5zNTtdiGHdD2pv6k4xVM3z4mQbNlNLC3imSmYxATQXAHdRlJn1BJFtkB2d7nZuce5mBCAE5wWvqz6nzAEgGCFTk3F1SYxmbxpPW/JqTBIozyI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772014528; c=relaxed/simple;
	bh=cEhN1Iv+3+5AHAwjY+4bbx1KSfiXSQ19i96bxSRH5p0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jV5EzN8ioqqP0InfIYUO8PGWJFeNsYTiHl8vjAAdVPLG8PgUuaGs2P5GjHQd+SLntOhjUr1Eo9u7l6tg6sHhfGwQLiVGH/2vntU2wccUG8S+hTcalRz0xJ4M24A7s8mFiwxBh8/jZZbOiq2yuTs5Oy8do1LpQpXtPP4fFszC4Gc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=UwmxbtOV; arc=pass smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="UwmxbtOV"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-38706b63929so56563891fa.3
        for <linux-scsi@vger.kernel.org>; Wed, 25 Feb 2026 02:15:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772014522; cv=none;
        d=google.com; s=arc-20240605;
        b=KOF9VCdN5z8ich+Aewy4ft6KuNFaKKKUj+PS+T0rZlCSlj3YUQOLxtbLOAsVn80n//
         kdU5YbNTU9YkMANWtsF6lF+7TtFwG/cE6WcRyBdbhtqHCst0gZRJHghtvoclLnt3ytY0
         MOh68rQsxpGOfAurmvbDUfpqfNF7/TKkSIU13B9Reb0hNLAThySERrpPLqln3X5yiuro
         /zN7QHGmcWnrYxX5eV7uaKMkNzEW9WvRwf/Uj9bNb1Ff1SZkcXuWNHcRJkhxLrLosb4x
         gegOne8HyYWrmyO7yPHH/TdzqlqjAkD52UxZsuW/2uFIojmx4cpfp3t2ngBNTbJ8z68K
         en7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2wbI3HVGAdmJBOB+Q2PfG58Jqhmlw+640Tj7L991s1k=;
        fh=cu3q4RKoNWXG+nFGS9UbTce9OqJSBw4FMVSlGqJMlME=;
        b=KTRdBX35BU58h0H48fANP26Tmv61xJi+G+TkQ0sbmGWr3LHeNNP4kxGqJUKTaOy2N9
         VSoT3bfaOUHm9Bp341QobWvoJXNmfihjeyb0RFgbfztiqcXS9Y6frxuYPPu/qqqzc2BX
         gX4YRhG4xFbARI8P97fcyXoY+2ZJqwSJEPDfaPlNHKqNcE/AVp0bK19qMG7kQ3psp33/
         /1qYP+wwZ7zQcjggjWuY4eTE//ZF4hh66b2ZzkvQMK/1l0qWS48NxdnXsBwbryy2xxDN
         HF6TJHM64fMCSlbW2igJDmU0YJd7Zp7vT8B+pcTVqxM2Z+64/660MPQ0uHVmFEvy8GAF
         EWmw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1772014522; x=1772619322; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2wbI3HVGAdmJBOB+Q2PfG58Jqhmlw+640Tj7L991s1k=;
        b=UwmxbtOV/nmBYuGKi6UEDOpjEpvqRBEHYzg6GXhGFuCv6F2c0ln5jRhSEuGWXMEIas
         ZGbF66mk1OBxyZTgEzdiq9SqaR6dkIUffoTe3ofa+8HgaJFzpC/yLt32HJBx73UmMB9r
         RlGPIsC6Gt32pLnpp4Ek19kkYGsNPcGCZFrBt+WLj4sBWaioDuOe+1Vh7oBMuIAUmyLX
         2Ss/ANz3rtwZUZsvzXZjGAYkhtTJSKsvR62bhCpCJkMlOXGSPYAgCMgc/ooJRgfRkVTI
         Zp/Sm1X3mB4H/9EnvLBwsS8QH2ewFtV+LLo5BYzDGJiBRc+AyHg042erl0IVfydZyCM7
         1Ssg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772014522; x=1772619322;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2wbI3HVGAdmJBOB+Q2PfG58Jqhmlw+640Tj7L991s1k=;
        b=EO4Argl9iWi0EJSu6WPZ5u+Be6Bpjq2VVZfOSy46IKQax1j02Qyk8D3449hrejlG3B
         QbxqpD2dqIzqXtY/D7XrAk/zUKbatLb4kE7gdDOammmqV95GiMyNb0ExKAWP/FeEpdps
         tgzwAPTWLEzVIcpPX7n+kU6OeQk+1eIV8cD1+OHoqmQ8pb6sXObijNuRAqfrBICiFGka
         wWNPrheJXPwJURQswkZ9JaCw+4pLKluglFqoQ4pCmm+IPplbx9NyLtiqB7YZuc+sNkq2
         AIZkl+O7G70LpT6+0ABZnmnAwpKqP01LHQtGP/eOacTgX/0Q7kkDvS7dF5s3HGFhy9Vz
         ACIA==
X-Forwarded-Encrypted: i=1; AJvYcCX8k/2r2GeQY4EnfH8bqlaCGepKwjhV2+ZmG+aU6iF/WiMXU5XJisdS0jCawH2cf0UnWbJDu/5d4ix1@vger.kernel.org
X-Gm-Message-State: AOJu0Ywwi58s1LXQ6Xe9W5S9wuD2DdXSyY8zdmiipWjn7RmNZ7VEoL7y
	cvHgOTr2Rr48rniB8V7RJGU3CELjMgav7aSKkewxUTJBpT3teVWhZ5oHsYysGdZi0roaijOT4PN
	ZT+NcE+3EGG916rvSSxLp1Fu26YeDb57pmr9n8HlvXA==
X-Gm-Gg: ATEYQzzIS2WFmifn/QiR6zVwL//bJK+LYkRMKIu9vITt4BqNt96CG3y8+4dEsg8pRrj
	WYrR88xt20XM+YES7S0G4h926+84E/HzcAoXqnXCQdHPztaJingcjIrjCGWywzcaAdoIlFIEoN6
	getOdbp0FJfxzns3i/C7hHg+B9GfmhcqX2tNqBvFtQuYbWGI62dYoMIoLrykJ0XQxCRY2zizL/o
	Nboq5MVwf9APyXlcFjjUtLf/8f7HvDs2KF5m/jdGXe+7cvWjFFeeUAQoJfOYVPdtvRjhYzj74IZ
	446FHpDLdtLvoFyqSIXZILfxaMnqYfdouJY6cPCGy8hvE/5i0Uv9kicEEsxnZffYeyxQ
X-Received: by 2002:a05:651c:981:b0:385:9b50:91a8 with SMTP id
 38308e7fff4ca-389a5d4e691mr49137391fa.15.1772014521621; Wed, 25 Feb 2026
 02:15:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <31a2a4c2-8c33-429a-a2b1-e1f3a0e90d72@nvidia.com>
 <459953fa-5330-4eb1-a1b4-7683b04e3d45@flourine.local> <aY77ogf5nATlJUg_@shinmob>
 <CAJpMwyis1iZB2dQMC4VC8stVhRhOg0mfauCWQd_Nv8Ojb+X-Yw@mail.gmail.com> <ae47ef06-3f66-4aab-b4ab-f3ae2b634f87@wdc.com>
In-Reply-To: <ae47ef06-3f66-4aab-b4ab-f3ae2b634f87@wdc.com>
From: Haris Iqbal <haris.iqbal@ionos.com>
Date: Wed, 25 Feb 2026 11:15:10 +0100
X-Gm-Features: AaiRm526FWUEGWm_hy7H18Kx_R9h0RTFeFOS6FCw0pCWHIRaUmeSA-DegrV6Fgs
Message-ID: <CAJpMwyiys85=WG-EQtsioo3OOiRDToUh1jE18Uj2Be2JdzNXDA@mail.gmail.com>
Subject: Re: [LSF/MM/BPF ATTEND][LSF/MM/BPF TOPIC] : blktests: status,
 expansion plan for the storage stack test framework
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Daniel Wagner <dwagner@suse.de>, 
	Chaitanya Kulkarni <chaitanyak@nvidia.com>, 
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, 
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, 
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, 
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, Bart Van Assche <bvanassche@acm.org>, 
	Hannes Reinecke <hare@suse.de>, hch <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, 
	"sagi@grimberg.me" <sagi@grimberg.me>, "tytso@mit.edu" <tytso@mit.edu>, Christian Brauner <brauner@kernel.org>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, =?UTF-8?Q?Javier_Gonz=C3=A1lez?= <javier@javigon.com>, 
	"willy@infradead.org" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	"amir73il@gmail.com" <amir73il@gmail.com>, "vbabka@suse.cz" <vbabka@suse.cz>, Damien Le Moal <dlemoal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 23, 2026 at 8:44=E2=80=AFAM Johannes Thumshirn
<Johannes.Thumshirn@wdc.com> wrote:
>
> On 2/15/26 10:18 PM, Haris Iqbal wrote:
> >>  From my view, blktests keep on finding kernel bugs. I think it demons=
trates the
> >> value of this community effort, and I'm happy about it. Said that, I f=
ind what
> >> blktests can improve more, of course. Here I share the list of improve=
ment
> >> opportunities from my view point (I already mentioned the first three =
items).
> > A possible feature for blktest could be integration with something
> > like virtme-ng.
> > Running on VM can be versatile and fast. The run can be made parallel
> > too, by spawning multiple VMs simultaneously.
>
> This is actually rather trivial to solve I have some pre-made things for
> fstests and that can be adopted for blktests as well:
>
> vng \
>      --user=3Droot -v --name vng-tcmu-runner \
>      -a loglevel=3D3 \
>      --run $KDIR \
>      --cpus=3D8 --memory=3D8G \
>      --exec "~johannes/src/ci/run-fstests.sh" \
>      --qemu-opts=3D"-device virtio-scsi,id=3Dscsi0 -drive
> file=3D/dev/sda,format=3Draw,if=3Dnone,id=3Dzbc0 -device
> scsi-block,bus=3Dscsi0.0,drive=3Dzbc0" \
>      --qemu-opts=3D"-device virtio-scsi,id=3Dscsi1 -drive
> file=3D/dev/sdb,format=3Draw,if=3Dnone,id=3Dzbc1 -device
> scsi-block,bus=3Dscsi1.0,drive=3Dzbc1"
>
> and run-fstests.sh is:
>
> #!/bin/sh
> # SPDX-License-Identifier: GPL-2.0
>
> DIR=3D"/tmp/"
> MKFS=3D"mkfs.btrfs -f"
> FSTESTS_DIR=3D"/home/johannes/src/fstests"
> HOSTCONF=3D"$FSTESTS_DIR/configs/$(hostname -s)"
> TESTDEV=3D"$(grep TEST_DEV $HOSTCONF | cut -d '=3D' -f 2)"
>
> mkdir -p $DIR/{test,scratch,results}
> $MKFS $TESTDEV
>
> cd $FSTESTS_DIR
> ./check -x raid
>
> I'm not sure it'll make sense to include this into blktests other than
> maybe providing an example in the README.

You're right. It is pretty trivial to run on VMs, but only after
everything is set up.
Adding it to blktests would allow this setup to be done (and run tests
after that) on any system by running just a couple of commands.

>
>
> Byte,
>
>      Johannes
>
