Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53DCD35CBD6
	for <linux-scsi@vger.kernel.org>; Mon, 13 Apr 2026 15:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776093098; cv=none; b=APrN+00lyZOH6SrrEtJ04muqlGf79FdhuCbwEzt3UKe/BC5Ecsyl4laHMGhb2b3TsH9hSAuOpcA6fjrQxM6nEbQI7aXriJ3Ygykfinc/dbLB//+NSda1EV3ZTYWC+3FCdowbbE5mhnygEXOdtI17htCoEYTSdq/ra5rnrxV23UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776093098; c=relaxed/simple;
	bh=cXITDHpOA+aPnFuC2talfADf17JAw3BGVOnCqlBicqA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rJO6NFcLasugMk6KmbdMAyDv53DnXY9y/WKk3dlvBUVdUShVoAwp4czY1sFNSZmpxLm5zY9OIzDm1FwoXeH+NWdwHFn4HoQku73Xc52hRr+aw3V9oLtXz864yoDG5161d8ZpWYtNb5yAZZdjaCvEX5FQQSeXMVuPzFPCgw8X+10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m67mooBu; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m67mooBu"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-483487335c2so49967495e9.2
        for <linux-scsi@vger.kernel.org>; Mon, 13 Apr 2026 08:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776093096; x=1776697896; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GJAQ52iaRqlr3zBK7T2k8HaLTx9fGu9A3J3vlybMSyg=;
        b=m67mooBumkQMaEGzkY+e5DSGQP6KiW44gGEmcw2qNCTUH541vlFvfHRQCfeE/r3c2M
         7jS/03ZnS/OjjaDQBtBSXYyzpdga9U7usTpFRt5D8gTKvR5osaMew71IfyHW+wWuXRdb
         aYlRYfi34+kdJcaNC0lVuzL95XojXqhVV6wVc8YFynGV4ouvocnlNQoLPHfmcxaqEdG/
         W1pQzq5E3h9pCN9rhEduIoafHS3/OuPIsl9vZC1GtnJQaOENfMR+WV3yHVlVtag+aSdQ
         tl28N7ShNPs2fwxDWpteGcdTLPktapNqe71L7qYfaSQHZqUaHf8JixF8i+8SvPfNzv38
         pc5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776093096; x=1776697896;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GJAQ52iaRqlr3zBK7T2k8HaLTx9fGu9A3J3vlybMSyg=;
        b=VuBIx+zPdLyxy7+ybcO3r/gZXklP5C00ueNucFZqYj37vrPheKl4wFJ6fNZfni2DaK
         aifEBCFQPu+eDRekXoMZ/YHGzIu/fNKdn3w5hkpbLuQOqO0DGu6HIdh6c6KpT1kYzidp
         NLoKPoJVrwGc+3qXV0NL8tLKaoL9QmUBt7JH9zfiBeF9Yn9+M+ftaZB+od6+l4F2dc8i
         3WAsp4eUMb7Grd/YwdzjPXS/JJCjoE9wnJ95KeQQYglqPbRlDzGPzJKA8R8sMCu4oADJ
         9DeE5cjwdpCds/z9DvSWPy7sjIc9nxdZHxwzc2PtPmbCu2lftfOWvLkDPJuhu9U+sdGW
         D6kA==
X-Forwarded-Encrypted: i=1; AFNElJ+sa7eYUCDvWSsR2cCZg5wamjNb+4nH+oyun6XR67wxHSJwGb5G8/8YFdhCmPg3HO710JCJoct9NwLa@vger.kernel.org
X-Gm-Message-State: AOJu0YwQ3WgeBPEOJddKMy8SJts+hI/SlFSs9JnMpTSugaYrldjZM2se
	NHqxy2yBMprfS15tCsQ+wQSA3n9a+/aKjdrdSWJcWo5MKyz0YpscEQGv
X-Gm-Gg: AeBDieunf6nHmKQlTbUGQtFCAoTnqsiihJuPgnERtdDytpjicNP5ABFaHgYuEnyFl3I
	oWbMWU1Tv3dDtndtHSVe74Asm+NMea+J/+yyCyOobpDkvU35eqQZa7Z2kUCOoMDmfcrImBMTJbX
	mmX6C82ZgBm8coapI40VGqqtBQMs1r0uVL4ZxxKhIKRhf+4H/itCT7b6eqUMJL6LV6r41uBCrDK
	oY5VZmPz9K9v/BJwNGGom2J6TKUGZE8pDN39fBkjbs99F9RSNeCgyMdLvfK1P20GljYuDhZlFEx
	ag7ukouTjj4lMqtbhr9op54oswrWi3hRI27zcbh4vug/iQux6WHFYUa0/8jCLucE77N9AxVRTiG
	BRbYEZZGLnlVRdBtB+0xedDc042hnmVxmSBP0/pv7e7jsVSlaoDAwIzIc7ajNhiUnlRQbIbCl5T
	pdVWzt7U4nxgYMhREJNYB9Wh6PRkI9OcrGj9ykF1ns0nwuKdWP2XBdo0D8CoRw6nCW/lfOuGzSS
	3jZwvAA
X-Received: by 2002:a05:600c:3149:b0:488:ae4e:519c with SMTP id 5b1f17b1804b1-488d683d505mr185844325e9.18.1776093095333;
        Mon, 13 Apr 2026 08:11:35 -0700 (PDT)
Received: from fedora (185-147-214-8.mad.as62651.net. [185.147.214.8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488d5347ea5sm343257025e9.8.2026.04.13.08.11.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 08:11:34 -0700 (PDT)
Date: Mon, 13 Apr 2026 23:11:15 +0800
From: Ming Lei <tom.leiming@gmail.com>
To: Aaron Tomlin <atomlin@atomlin.com>
Cc: Ming Lei <ming.lei@redhat.com>, axboe@kernel.dk, kbusch@kernel.org,
	hch@lst.de, sagi@grimberg.me, mst@redhat.com, aacraid@microsemi.com,
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	liyihang9@h-partners.com, kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
	chandrakanth.patil@broadcom.com, sathya.prakash@broadcom.com,
	sreekanth.reddy@broadcom.com, suganath-prabu.subramani@broadcom.com,
	ranjan.kumar@broadcom.com, jinpu.wang@cloud.ionos.com,
	tglx@kernel.org, mingo@redhat.com, peterz@infradead.org,
	juri.lelli@redhat.com, vincent.guittot@linaro.org,
	akpm@linux-foundation.org, maz@kernel.org, ruanjinjie@huawei.com,
	bigeasy@linutronix.de, yphbchou0911@gmail.com, wagi@kernel.org,
	frederic@kernel.org, longman@redhat.com, chenridong@huawei.com,
	hare@suse.de, kch@nvidia.com, steve@abita.co, sean@ashe.io,
	chjohnst@gmail.com, neelx@suse.com, mproche@gmail.com,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH v10 13/13] docs: add io_queue flag to isolcpus
Message-ID: <ad0Hk48y5JEeMlFk@fedora>
References: <ac8l-w8ERG1YN2Wm@fedora>
 <nxe24ixebb4lm2d5w4aubhtwr23df6mumqd663axj35oswdiyv@amtqhtsidyr4>
 <adMoon3Zf6gO-UbA@fedora>
 <zawhqvn53mcp4wf7axsmuq4cg73upxs5h2zgrfta5dpat3sfy4@zctfbz2ttz5m>
 <CAFj5m9JE5e4DRGbzQFxDdZWU76ZPQ3G+C9JpLu0mhTB6aesZ9g@mail.gmail.com>
 <a566smu6morqeefqal23eek4ibezfuiwhs774xtxhyyclpbtsx@uzzwgbzmwdjd>
 <adhj_w11cpMfeEgN@fedora>
 <dzpxscrhibmi5okkozf5jfull4dcajgpctldvdyfcjgmpeetk5@tkeyqouyabzy>
 <adpD8M8cNu3IZzEL@fedora>
 <6glgsbk2djsz4cqtbp2ht4274dw4rveq6fojlnpnuvx6zmpjxw@i43jo2l4qlz4>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6glgsbk2djsz4cqtbp2ht4274dw4rveq6fojlnpnuvx6zmpjxw@i43jo2l4qlz4>

On Sun, Apr 12, 2026 at 06:50:33PM -0400, Aaron Tomlin wrote:
> On Sat, Apr 11, 2026 at 08:52:00PM +0800, Ming Lei wrote:
> > > The critical issue lies at the invocation of group_cpus_evenly(). Without
> > > this patchset, the core logic lacks the necessary constraints to respect
> > > CPU isolation. It is entirely possible, and indeed happens in practice, for
> > > an isolated CPU to be assigned to a CPU mask group.
> > 
> > It is one bug report? No, because it doesn't show any trouble from user
> > viewpoint.
> 
> Hi Ming,
> 
> The lack of a formal bug report does not negate the fact that the current
> behaviour silently breaks the fundamental contract of CPU isolation from
> the administrator's perspective.
> 
> To illustrate the user-visible impact, the following demonstrates the
> difference between relying on isolcpus=managed_irq and isolcpus=io_queue
> under 7.0.0-rc3-00065-gd80965e205a5, which includes this series.
> 
> The Broadcom MPI3 Storage Controller driver allocates a full complement of
> 48 operational queue pairs. Consequently, a number of MSI-X vectors are
> generated and mapped directly onto the isolated cores thereby breaching
> isolation.
> 
>     # uname -r
>     7.0.0-rc3-00065-gd80965e205a5
> 
>     # tr ' ' '\n' < /proc/cmdline | grep isolcpus=
>     isolcpus=managed_irq,domain,2-47
> 
>     # cat /sys/devices/system/cpu/isolated
>     2-47
> 
>     # dmesg | grep -A 6 'MSI-X vectors supported:'
>     [   2.981705] mpi3mr0: MSI-X vectors supported: 128, no of cores: 48,
>     [   2.981705] mpi3mr0: MSI-X vectors requested: 49 poll_queues 0
>     [   3.001915] mpi3mr0: trying to create 48 operational queue pairs
>     [   3.011214] mpi3mr0: allocating operational queues through segmented queues 
>     [   3.101903] mpi3mr0: successfully created 48 operational queue pairs(default/polled) queue = (2/0)
>     [   3.111468] mpi3mr0: controller initialization completed successfully
> 
>     # awk '/mpi3mr0/ { print $1" "$NF }' /proc/interrupts
>     78: mpi3mr0-msix0
>     79: mpi3mr0-msix1
>     80: mpi3mr0-msix2
>     81: mpi3mr0-msix3
>     82: mpi3mr0-msix4
>     83: mpi3mr0-msix5
>     84: mpi3mr0-msix6
>     85: mpi3mr0-msix7
>     86: mpi3mr0-msix8
>     87: mpi3mr0-msix9
>     88: mpi3mr0-msix10
>     89: mpi3mr0-msix11
>     90: mpi3mr0-msix12
>     ...
>     122: mpi3mr0-msix44
>     123: mpi3mr0-msix45
>     124: mpi3mr0-msix46
>     125: mpi3mr0-msix47
>     126: mpi3mr0-msix48
> 
>     # grep -H '' /proc/irq/{119,120,121,122}/{effective,smp}_affinity_list
>     /proc/irq/119/effective_affinity_list:42
>     /proc/irq/119/smp_affinity_list:42
>     /proc/irq/120/effective_affinity_list:43
>     /proc/irq/120/smp_affinity_list:43
>     /proc/irq/121/effective_affinity_list:44
>     /proc/irq/121/smp_affinity_list:44
>     /proc/irq/122/effective_affinity_list:45
>     /proc/irq/122/smp_affinity_list:45

But typical applications aren't supposed to submit IOs from these isolated CPUs, so
in reality, it isn't a big deal.

> 
> 
> Now with isolcpus=io_queue,2-47 the allocation is structurally restricted
> at the source. The driver creates only two operational queues, confining
> all resulting interrupts exclusively to housekeeping CPUs (0 and 1):
> 
>     # uname -r
>     7.0.0-rc3-00065-gd80965e205a5
> 
>     # tr ' ' '\n' < /proc/cmdline | grep isolcpus=
>     isolcpus=io_queue,domain,2-47
> 
>     # cat /sys/devices/system/cpu/isolated
>     2-47
> 
>     # dmesg | grep -A 6 'MSI-X vectors supported:'
>     [   3.284850] mpi3mr0: MSI-X vectors supported: 128, no of cores: 48,
>     [   3.284851] mpi3mr0: MSI-X vectors requested: 49 poll_queues 0
>     [   3.305492] mpi3mr0: allocated vectors (3) are less than configured (49)
>     [   3.316528] mpi3mr0: trying to create 2 operational queue pairs
>     [   3.328013] mpi3mr0: allocating operational queues through segmented queues
>     [   3.340697] mpi3mr0: successfully created 2 operational queue pairs(default/polled) queue = (2/0)
>     [   3.350664] mpi3mr0: controller initialization completed successfully
> 
>     # awk '/mpi3mr0/ { print $1" "$NF }' /proc/interrupts
>     79: mpi3mr0-msix0
>     80: mpi3mr0-msix1
>     81: mpi3mr0-msix2
> 
>     # grep -H '' /proc/irq/{79,80,81}/{effective,smp}_affinity_list
>     /proc/irq/79/effective_affinity_list:1
>     /proc/irq/79/smp_affinity_list:1
>     /proc/irq/80/effective_affinity_list:1
>     /proc/irq/80/smp_affinity_list:1
>     /proc/irq/81/effective_affinity_list:0
>     /proc/irq/81/smp_affinity_list:0
> 
> > Sebastian explains/shows how "isolcpus=managed_irq" works perfectly in the
> > following link:
> > 
> > https://lore.kernel.org/all/20260401110232.ET5RxZfl@linutronix.de/
> > 
> > You have reviewed it...
> > 
> > What matters is that IO won't interrupt isolated CPU.
> 
> The isolcpus=managed_irq acts as a "best effort" avoidance algorithm rather
> than a strict, unbreakable constraint. This is indicated in the proposed
> changes to Documentation/core-api/irq/managed_irq.rst [1].

Yes, it is "best effort", but isolated cpu is only take as effective CPU
for the hw queue's irq iff all others are offline. Which is just fine for typical
use cases, in which IO isn't submitted from isolated CPU.



Thanks, 
Ming
