Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4119735C1BC
	for <linux-scsi@vger.kernel.org>; Thu,  9 Apr 2026 15:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775746827; cv=pass; b=M7P2DoUHkbrqzjecmIlcCp0BSxdUkpXA52zokb8YlWo8XzDrv/yujfIypcPTglGGIwsGjYSjImBQDlWsLRiSGjI8KrRCb4A+h9uQRKKn9+mJTUorh/rvUufXc6rrhOPoRMDRR0hD3cYSW/KVAIVrKvJw2hHdrRxY9RavDmQ5+Mc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775746827; c=relaxed/simple;
	bh=A6WjcZkzB7y/uOYAw/eN9Tj+j1b6o0TUODV7Nvp2H68=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sYYYVPYkWTKyMhh9WSNZBJ/fSvLdkjJfI6kQu7JvRXklRPUPdz9qofIbV+UWxh0wolR7nUzXl3Jd8T0hk9KWciTs1d1RwhTyTYfbBkjgdSyyoNKOOv2mgG7hefjpLgNb3hjvz47KEyhkv/fTd0rrqr9iDIpxXlJG8jaaTt46j2Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hwedqR/p; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q+mbWEQo; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hwedqR/p";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q+mbWEQo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775746825;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cf9B6qVrP1bgRDKEPgwYFOrfy8peSUb1Uft91wqXmNg=;
	b=hwedqR/p0O6y1rp/HU8TxNQ9sgPH8BN/KEAnvhOVFj5L5Gmmni3nuLNiT8Dyi1XDhAThTX
	AvupUWhj4WPz5ZUmD1AjOTsj5ueqD854UxMDMM9fdtq+oQYrbsAR5lNvIEo3oL41zQAsrK
	cy66/CIeRnDjIOUmyaquAKSbLsTw+7s=
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com
 [209.85.217.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-163-6VbS9ziQNAyDQiP1ivrWpw-1; Thu, 09 Apr 2026 11:00:24 -0400
X-MC-Unique: 6VbS9ziQNAyDQiP1ivrWpw-1
X-Mimecast-MFC-AGG-ID: 6VbS9ziQNAyDQiP1ivrWpw_1775746823
Received: by mail-vs1-f71.google.com with SMTP id ada2fe7eead31-60521f54387so340374137.1
        for <linux-scsi@vger.kernel.org>; Thu, 09 Apr 2026 08:00:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775746823; cv=none;
        d=google.com; s=arc-20240605;
        b=Mru81sODy5IByzAEIJdmwdq/7H8JkQH6odpc4yYFtUf1ORbBcF+bFF18+0MteWe++E
         IoXf3LMIhNFMEfj8xUuRFMBw2cVFm4jHa96rT1V3DfZwe9uYoXANdh9Y/wjWJ90t7dW6
         qhBu1HRPvFnKFjWti/eHKLVRx4TGMFkX7NHbgB8abjmBqflAuRjxK9chzK02+MqZ6nEr
         FroFgWjPlOqoJ5pZIavUNwWdNmAAtT/fH8erPQ3ZKDDhR/NviLmSQoKMo8SjsSGgY0PJ
         YHKirQhDXZ2G4Pl266PYiAWkfe8MPIWSBI29PB+uvpibNurLGYboyP9tIrhJWzKHwx4m
         ow3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cf9B6qVrP1bgRDKEPgwYFOrfy8peSUb1Uft91wqXmNg=;
        fh=fRA9KLSONbQuIL+KRL13JSJD0YNmMPGX0FF34fpCd9Q=;
        b=GyNqyN+sRiBXSQMl1pxR025PojwVlnvsDaKCsq2f/eZHJNAj8/wUMC0+VNf9pEvuSJ
         yMyDASRT6vyo9v1cSJehrAP3hCbyOhyeWabfEn3CZp6ylyWOnSxHMWv799EUZYi8gHkz
         1JjlPhJPK2QD5+ikIHimfcjaYUpJDzonoV49uydbCbWSaw9lIsvUeJpDKBYneZJVfo6x
         ew52Z9qukpwenSKTfWCHmBfuxlxwaOUv8PiQfSxvLkoNCveotjsIt7m0EuNbdj6ok9g2
         JwiTmYtmbLLfkcyZ9aSjSadnyaL9fmFAr4zKQT0oq7J4L/7bkpSdydjJnTbkIwNLbC82
         qr6g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1775746823; x=1776351623; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cf9B6qVrP1bgRDKEPgwYFOrfy8peSUb1Uft91wqXmNg=;
        b=Q+mbWEQofehPMNn9Tn4fMyXnlZQo4SEJb6PdYCQxpwA2WQFX07aRMK17b9Cl7x8iBi
         5IDlZi7uCkzS+bhQW633HNjma4tmHfkB6829+x5X7A4gf7GhFLilIqTI47b1/vpnbjiC
         +e+o6gFSLo0DQhcF0+BSr1CihwErulFgs7odKi2tFKFO5aOnjMJ2T4a62iKtgjunArBT
         S15pKPOA3V6wKROCsPKQoGwyo6/g6oZoHHYpmZDz/rl4lBMqIhNTXr4vc4UIj5mqfriZ
         pmSV6edAtLmtucC8SLjZ0JgLfMpqTdsGxLFTjjIZ2BpM8rMCH6NvkCdryBRXsKfqdcZW
         yiGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775746823; x=1776351623;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cf9B6qVrP1bgRDKEPgwYFOrfy8peSUb1Uft91wqXmNg=;
        b=P1YeXp5aeJl/UBIWmkBpECoLCVkJlercVCH2TlUp0fmspN+Fr+FdE6w0hBqy+ShAB1
         M5spKPeqxFCEFW4XC4WFjSE8Y8Lze+SfGYVeB97VCTjjUedoP4rtNtfShDZ/LOkUjtef
         2+eXwo9ONoMBo8TH+bEEkmH7KWQL2rnBihJenzOocEGOI9gGenvpe+NtdS2zQeCewp5+
         7FgvRCbIgDZK73nn/U9BNy6bsvjXHebHkfro6KMOuweau8RGBCSHZ4agHagxwmBhjLSe
         Zh10tfn5+1bHrxon9LmAX9j83QvGyyTIDsew9IzqVrlLKsRsF/0/YlIdCBRHCcWhXMMj
         bK0g==
X-Forwarded-Encrypted: i=1; AJvYcCWVGAzf73KUhdlfnGX63RcjtHLae724F7a2jY8JWPCmK3s8P9hGRkyI0wtRQDS1/esPsRyK+3Ahvw3O@vger.kernel.org
X-Gm-Message-State: AOJu0YwIexeW4BuirGF+CawMmlmZnzqV3oAUb56xdF/j51gtoVnzNN1g
	XBcylEYA99NfYcLvGHGoYL2wCeEd4UJGBnP4609CiGZcY/DeYrT3lG7/pDxPYpjcRUOh8MANla6
	tKiyJQclgDZ7aANEb2K8oeJT8GibENuv/ubGZ7m/tPSMvacMoUEHPefmgnemCnrG6SEx56i8z+x
	cSJnJ/N0vIlQ//+P/bI2bJDdi4rpm0Q4Ug4w7/5A==
X-Gm-Gg: AeBDiesvii4tE2E46YNXGqquSD7ZtnTvXNwpi2w+X2Xxt+TR6T2jV9YTRQ2HJHgqLMz
	Q+hmaI9LtQ/rpay6aTFYQ/sd+ojlRvDO7em3tau8pa11VNqsDHf4xvd67NPwV6GI3GIks8jFJhE
	4O/9Z/ul/68Dn3D0s7ml2F4IFBrtGQBC8pTmBGK7yCZIuRHyT5TmnZ9s7BoaYacV2uz8pEJCW4q
	Q0HwNFa7ZAYf6LZyRJmk1b0+AfuGCs6sHqZ+Bo=
X-Received: by 2002:a67:e713:0:b0:608:1b6e:f4dc with SMTP id ada2fe7eead31-6081b6ef921mr2784469137.11.1775746823170;
        Thu, 09 Apr 2026 08:00:23 -0700 (PDT)
X-Received: by 2002:a67:e713:0:b0:608:1b6e:f4dc with SMTP id
 ada2fe7eead31-6081b6ef921mr2784399137.11.1775746822118; Thu, 09 Apr 2026
 08:00:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260401222312.772334-1-atomlin@atomlin.com> <20260401222312.772334-14-atomlin@atomlin.com>
 <ac8l-w8ERG1YN2Wm@fedora> <nxe24ixebb4lm2d5w4aubhtwr23df6mumqd663axj35oswdiyv@amtqhtsidyr4>
 <adMoon3Zf6gO-UbA@fedora> <zawhqvn53mcp4wf7axsmuq4cg73upxs5h2zgrfta5dpat3sfy4@zctfbz2ttz5m>
In-Reply-To: <zawhqvn53mcp4wf7axsmuq4cg73upxs5h2zgrfta5dpat3sfy4@zctfbz2ttz5m>
From: Ming Lei <ming.lei@redhat.com>
Date: Thu, 9 Apr 2026 23:00:09 +0800
X-Gm-Features: AQROBzBGMQxEgwdm4UZJAa6NOKwn3RLk5aSwu5C0sv3kx4PGZQZHIp5V15VSUxk
Message-ID: <CAFj5m9JE5e4DRGbzQFxDdZWU76ZPQ3G+C9JpLu0mhTB6aesZ9g@mail.gmail.com>
Subject: Re: [PATCH v10 13/13] docs: add io_queue flag to isolcpus
To: Aaron Tomlin <atomlin@atomlin.com>
Cc: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, 
	mst@redhat.com, aacraid@microsemi.com, James.Bottomley@hansenpartnership.com, 
	martin.petersen@oracle.com, liyihang9@h-partners.com, 
	kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, 
	shivasharan.srikanteshwara@broadcom.com, chandrakanth.patil@broadcom.com, 
	sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com, 
	suganath-prabu.subramani@broadcom.com, ranjan.kumar@broadcom.com, 
	jinpu.wang@cloud.ionos.com, tglx@kernel.org, mingo@redhat.com, 
	peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, 
	akpm@linux-foundation.org, maz@kernel.org, ruanjinjie@huawei.com, 
	bigeasy@linutronix.de, yphbchou0911@gmail.com, wagi@kernel.org, 
	frederic@kernel.org, longman@redhat.com, chenridong@huawei.com, hare@suse.de, 
	kch@nvidia.com, steve@abita.co, sean@ashe.io, chjohnst@gmail.com, 
	neelx@suse.com, mproche@gmail.com, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, 
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, 
	megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com, 
	MPT-FusionLinux.pdl@broadcom.com, "Lei, Ming" <tom.leiming@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 8, 2026 at 11:58=E2=80=AFPM Aaron Tomlin <atomlin@atomlin.com> =
wrote:
>
> On Mon, Apr 06, 2026 at 11:29:38AM +0800, Ming Lei wrote:
> > I don't think there is such breaking isolation thing. For iopoll, if
> > applications won't submit polled IO on isolated CPUs, everything is jus=
t
> > fine. If they do it, IO may be reaped from isolated CPUs, that is just =
their
> > choice, anything is wrong?
>
> Hi Ming,
>
> Thank you for your follow up. You make a fair point regarding polling
> queues and application choice; if an application explicitly binds to an
> isolated CPU and submits polled operations, it is indeed actively electin=
g
> to utilise that core and accept the resulting behaviour.
>
> However, the architectural challenge arises from how the kernel handles
> these queues structurally when the application does not explicitly make
> that choice. Because poll queues never utilise interrupts, they are
> completely invisible to the managed interrupt subsystem.
>
> If we were to rely exclusively on the managed irq flag, the block layer
> would blindly map these non interrupt driven polling queues to isolated
> CPUs. If a general background storage operation were then routed to
> that queue, the isolated core would be forced to spin actively in a tight

How can the isolated core be scheduled for running polling task?

Who triggered it?

> loop waiting for the hardware completion. This would completely monopolis=
e
> the core and destroy any real time isolation guarantees without the user
> space application ever having requested it.

No.

IOPOLL queue doesn't have interrupt, and the ->poll() is only run from
the submission context.  So if you don't submitted polled IO on isolated
CPU cores, everything is just fine.  This is simpler than irq IO actually.

>
> This illustrates precisely why the io queue flag is a mechanical necessit=
y.
> Its primary objective is to act as a comprehensive block layer isolation
> boundary. It structurally restricts both hardware queue placement and
> managed interrupt affinity strictly to housekeeping CPUs, ensuring that n=
o
> storage queue operations of any kind are mapped to an isolated CPU.
>
> To achieve this reliably, this series expands the struct irq affinity
> structure to incorporate a new CPU mask [1]. This mask is explicitly set =
to
> the result of blk mq online queue affinity. By passing this housekeeping
> mask directly through the interrupt affinity parameters, we ensure that t=
he
> native affinity calculation is strictly bounded to non isolated CPUs from
> the moment the device probes.
>
> This structural enhancement allows device drivers to seamlessly inherit t=
he
> isolation constraints without requiring bespoke, driver specific logic. A
> clear example of this application can be seen in the modifications to the
> Broadcom MPI3 Storage Controller [2]. By leveraging the expanded struct i=
rq
> affinity, the driver guarantees that its queues and corresponding managed
> interrupts are perfectly aligned with the system housekeeping
> configuration, completely avoiding the isolated CPUs during allocation.
>
> [1]: https://lore.kernel.org/lkml/20260401222312.772334-5-atomlin@atomlin=
.com/
> [2]: https://lore.kernel.org/lkml/20260401222312.772334-8-atomlin@atomlin=
.com/
>
> I hope this better illustrates the mechanical necessity of the io_queue
> flag and the corresponding changes to the interrupt affinity structures.

Can you share one example in which managed irq can't address?

>
> > > Every logical CPU, including the isolated ones, must logically map to=
 a
> > > hardware context in order to submit input and output requests, saying=
 they
> > > are completely restricted is indeed stale and technically inaccurate.=
 The
> > > isolation mechanism actually ensures that the hardware contexts thems=
elves
> > > are serviced by the housekeeping CPUs, while the isolated CPUs are si=
mply
> > > mapped onto these housekeeping queues for submission purposes. I will
> > > rewrite this paragraph to accurately reflect this topology, ensuring =
it
> > > aligns perfectly with the behaviour introduced in patch 10.
> >
> > I am not sure if the above words is helpful from administrator viewpoin=
t about
> > the two kernel parameters.
> >
> > IMO, only two differences from this viewpoint:
> >
> > 1) `io_queue` may reduce nr_hw_queues
> >
> > 2) when application submits IO from isolated CPUs, `io_queue` can compl=
ete
> > IO from housekeeping CPUs.
>
> Acknowledged.

Are there other major differences besides the two mentioned above?

Thanks,
Ming

