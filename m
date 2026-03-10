Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651733A75B9
	for <linux-scsi@vger.kernel.org>; Tue, 10 Mar 2026 15:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773158222; cv=pass; b=dz3HeeEz9QZpvpPOeSoy+OXzH4Kw6Gr3aFXnqlrsWU/6suX5gmcePp1GiiRfXvDZY0JVOCrk84BCybR19MIpqAj74ig6jyIi64dxA2ddZSxVw3mC58dTNk7gj3QeSAXjqivcEqA0Xa0+OVGFlP8wSmcjxP5hnCZzAqhcVFN7iHg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773158222; c=relaxed/simple;
	bh=aZ3QAAiJWKfJPFdOqgfaghwjaxM2wYZxCugoj3b5jMM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HPkAb/94uLgk4gbGKSDaRZ+Rd+OMDdLEg4DaNPuurwEj1ZPeBJdMNvVb89TrYqHBKVxstHW8HFi/lABZvMpDWtsE8r583CUD2/8lkIAI1uawYSdZxmvkNUM3BKCc+RnvPR5695got8dJ9/1tXiMqful+cEUUaU89Y5bioScHhHw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=GDcXq3rA; arc=pass smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="GDcXq3rA"
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-40947c81b31so670367fac.1
        for <linux-scsi@vger.kernel.org>; Tue, 10 Mar 2026 08:57:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773158220; cv=none;
        d=google.com; s=arc-20240605;
        b=VNJDwcddBSUUehLxcZM13rvNbXmGuSkzKI+yiDznFPXqd4yt6r7X9//l9lipFj38c2
         F18JE9+IJUSIsPcVeIVC9fU8g2ECJkDDvsxrkaXr9VbNCS5zkxLliDuqdXGFm9dZXFmS
         55/7c5w7ydsEtM6N4xlT2XXqRzi1i4exrMaXNI2T7Z1KXQxQvO3PhgujKKlsw+N8aeJl
         a1LU8Wpt0axYIahX2j8fLMVne5Or0WZhTJqLnwSsYKiusxslW/sxZzO2zZJD9P1iQSSz
         TBrGChLrCKAd2rCWbFZEDPe05ywNEufM+ruRnQBGH+nBQSv5q8NRAsc/PL3tXnyQEK0I
         vDHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=k0ZfmdoKETAu32CUc6DaYZn/AQfT5ZtxxhfQJEgADr8=;
        fh=FTi4a78VYk5M+teFeJNUFbJIpG5qRl4PAww6W0xDhQ8=;
        b=ZespbTLOZqS+qbUBnboFNhDwRoGZ5ppJkMZweFzDSjQif/j91q/pZ/tW/akpaUG08J
         Bys0KxP9/grdXPKAezOp5947cZNHfT8A+T2mJOEIGAjWhC8drurFCkpAHPqconEHAx4L
         qTNIBxVUbLx+wxrxr3c7gGnvupnO4kTXh4cIYbb1IhkMpdp2yR2rMAvq3sO9jX2md1IE
         eVft4KgrAyQGyorGHY5jlnajwL6lwBlhVjW6f5dCWXIGZ0cnqVUF86LDwoM4kFJRCDN6
         Cf8v75YFLv2PdiQtc7bwaqhrQdNgeGnQvoFnvzYlAdh4y9xwAER2WUEqKXJ8vHxSvS+X
         xXyg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1773158220; x=1773763020; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k0ZfmdoKETAu32CUc6DaYZn/AQfT5ZtxxhfQJEgADr8=;
        b=GDcXq3rAFXxU75wmb/baSS7kiq0Izs5ejpXTDlbCCEsFiSK6DqqnEAU29+gk6XyvJN
         JBs7A9dqq5gzucsJqNvHNVQbGnfIIF+KocmycQSy0I5MZCKILwnemDU00m0Ar6BCqyuq
         tGmYt1NEgfI8jCXLIl/ba/3AtU9Xo4zxEg3L0gdRZcGbw3FvaoNK6pspAHnxopkco+bY
         qoCfG56sB2p8qkc2AWoSip5aFK7nSj6mNaktw3/6pC3HO36XgFyO0/3nMx5Phg76syp8
         HzXabqqwOoZ2HxVDyUFdPPzvKY4jImNKwXTh72ab6DjQbq/5uMW5P/gFN6OkVjWRNwQp
         Lvng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773158220; x=1773763020;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=k0ZfmdoKETAu32CUc6DaYZn/AQfT5ZtxxhfQJEgADr8=;
        b=VfeC5xXytpC4ddykvhrstqEo2Qlf45Aoa5kzP8V8ThEfyLPIt20r4JZ5BYc6tN5QJo
         1ZPpwdTG0WK8f1LRgfZ7eB+CBQ+EbbIMdC686yozqY8Bb1o5dmCD3oPad2EtZBSM/Kh+
         /8ucURkb5ST/+pJInaAn75w2VrsHYb9PoRYV91nVPJFIJF5y3nqiiaqti9f1D75ENyyW
         Aa4ALbmu0nVbwLcqbwJ2mKy6XcuLcYko+mnZrpnQ+iDOy08RIRS0DMuU1qmbZGwLAUdh
         DPPkvGUFqKlrXx7e7N/t7EYNfFdZcopmlIL0Uknd4p3nyaBX/Ii18Fuc/5UiCCIENhjx
         hj8g==
X-Forwarded-Encrypted: i=1; AJvYcCXwmLKG8P5cGvSE+wkSXGRI7axX9+8cckKXmQAXO1fGKPCgwinRf0pwTX0jBlRWGavcA5QC9lUPxnpz@vger.kernel.org
X-Gm-Message-State: AOJu0Ywt+isirMzzEfwK8Saj8Nm4uB8quo3FtZ1RzWVfvuXhCs9KPc5t
	A4hhZkW8Q6pxL2MqlF22x5fHVhbVE8kKwKB1r/L1eiPmuL7L38i5yioI36chRDNvs3h8qJu1zms
	9YM23NG+8FEuX+RWoES1AiEjxEiZDS4UC0nNtCgNasw==
X-Gm-Gg: ATEYQzzqXbexUj2ZcwuoS/uVjVXbYIv3g762L0i9trxXsQXVJ1oldWP2fE97waVaa0y
	8a8wUO3HAXgQ4JSjJrqB18yhpHZrvf9QeB/A4aOhvvC9gL82DSmCwkwU0tNbdzNsNcNXXs9zLua
	IkJBPznIqMq+vLwXgRwhbr0wUx13wRK7IY40MLX5sKWei6RjsGbBd/TELtunVTjFtIcqbSg+Z2V
	lVcNsj3GBVZgt577ShwyEqdflwOjlJ6MbOI6kIKezq+em3+zmbwj3IR9ceckJytNsxLbVGluIEH
	hfwpgNPo
X-Received: by 2002:a05:6870:854b:b0:416:3f50:ea2 with SMTP id
 586e51a60fabf-416e45c1dc6mr7199342fac.8.1773158220092; Tue, 10 Mar 2026
 08:57:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260309062840.2937858-2-iam@sung-woo.kim> <CADUfDZorSQCVtQyfjBuaziwG2Jo28yZiiqLKbp9PkFFw-9VgfQ@mail.gmail.com>
 <CAJNyHp+i3M_ko7rhgTz=nxP=MZYM3oQf3L-y=7YnhnRyeUxayA@mail.gmail.com>
In-Reply-To: <CAJNyHp+i3M_ko7rhgTz=nxP=MZYM3oQf3L-y=7YnhnRyeUxayA@mail.gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 10 Mar 2026 08:56:48 -0700
X-Gm-Features: AaiRm52sHfM1lLReXhJ6K_-eQeuNMsoWbyv4AHit6rY5_ursGYcV9eDpU-ihUic
Message-ID: <CADUfDZppWyOOPME0eJbmO1q+qvehxGiCk8Zz_nVxaQk08aukFw@mail.gmail.com>
Subject: Re: [PATCH] blk-mq: nvme: Fix general protection fault in nvme_setup_descriptor_pools()
To: Sungwoo Kim <iam@sung-woo.kim>
Cc: Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>, 
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev, 
	Ulf Hansson <ulf.hansson@linaro.org>, Richard Weinberger <richard@nod.at>, 
	Miquel Raynal <miquel.raynal@bootlin.com>, Vignesh Raghavendra <vigneshr@ti.com>, 
	Hector Martin <marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>, 
	Alyssa Rosenzweig <alyssa@rosenzweig.io>, Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, 
	Sagi Grimberg <sagi@grimberg.me>, James Smart <james.smart@broadcom.com>, 
	Chaitanya Kulkarni <kch@nvidia.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Chao Shi <cshi008@fiu.edu>, 
	Weidong Zhu <weizhu@fiu.edu>, Dave Tian <daveti@purdue.edu>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, nbd@other.debian.org, linux-mmc@vger.kernel.org, 
	linux-mtd@lists.infradead.org, asahi@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-nvme@lists.infradead.org, 
	linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 9, 2026 at 4:55=E2=80=AFPM Sungwoo Kim <iam@sung-woo.kim> wrote=
:
>
> On Mon, Mar 9, 2026 at 11:31=E2=80=AFAM Caleb Sander Mateos
> <csander@purestorage.com> wrote:
> >
> > On Sun, Mar 8, 2026 at 11:30=E2=80=AFPM Sungwoo Kim <iam@sung-woo.kim> =
wrote:
> > >
> > > The numa_node can be < 0 since NUMA_NO_NODE =3D -1. However,
> > > struct blk_mq_hw_ctx{} defines numa_node as unsigned int. As a result=
,
> > > numa_node is set to UINT_MAX for NUMA_NO_NODE in blk_mq_alloc_hctx().
> >
> > The node argument to blk_mq_alloc_hctx() comes from
> > blk_mq_alloc_and_init_hctx(), which is called by
> > blk_mq_alloc_and_init_hctx() with int node =3D blk_mq_get_hctx_node(set=
,
> > i). node =3D NUMA_NO_NODE would suggest that blk_mq_hw_queue_to_node()
> > doesn't find any CPU affinitized to the queue. Is that even possible?
>
> Thanks for your review, Celeb.

While I'm flattered you consider me a celebrity, my name is Caleb :)

>
> blk_mq_hw_queue_to_node() can return NUMA_NO_NODE if the device queues
> exceed the
> number of CPUs. Afterward, it is adjusted on the caller side to
> numa_node =3D set->numa_node.

I thought the NVMe driver capped the number of queues so every queue
is affinitized to some CPU (see nvme_max_io_queues()). What am I
missing?

Best,
Caleb

>
> set->numa_node can still be NUMA_NO_NODE if CONFIG_NUMA=3Dn (trivial) or
> pcibus_to_node() returns NUMA_NO_NODE if ACPI doesn't provide
> proximity information.
> But I'm not sure if this is usual in the real machines. We found the
> crash in QEMU.
>
> > >  static struct nvme_descriptor_pools *
> > > -nvme_setup_descriptor_pools(struct nvme_dev *dev, unsigned numa_node=
)
> > > +nvme_setup_descriptor_pools(struct nvme_dev *dev, int numa_node)
> > >  {
> > > -       struct nvme_descriptor_pools *pools =3D &dev->descriptor_pool=
s[numa_node];
> > > +       struct nvme_descriptor_pools *pools;
> > >         size_t small_align =3D NVME_SMALL_POOL_SIZE;
> > >
> > > +       if (numa_node =3D=3D NUMA_NO_NODE)
> > > +               pools =3D &dev->descriptor_pools[numa_node_id()];
> > > +       else
> > > +               pools =3D &dev->descriptor_pools[numa_node];
> >
> > Simpler: if (numa_node =3D=3D NUMA_NO_NODE) numa_node =3D numa_node_id(=
);
> >
>
> Thanks, I will modify it in V2.
>
> Sungwoo.
