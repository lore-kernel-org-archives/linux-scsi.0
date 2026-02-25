Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0538335BBB
	for <linux-scsi@vger.kernel.org>; Wed, 25 Feb 2026 10:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772014093; cv=pass; b=TVjc/+O44Vm2MpQ3IeUmbiF/qrDM31vuU/e1vwzy6QD5I+/Uwbc3VKMeNWr8EP1KyhtZQ0uxZOZObswyMQ2bEyY2oc7GV7RDt7p9VI09fyyg+4cyavVk8PEt+vmJUvYOtlg3qXKo2v5kdmPH5jI67ZI5iA48RpWKaMtx85MJaso=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772014093; c=relaxed/simple;
	bh=P+nn7GxNNTTR4z83VRm4nDPbYz8l5IDhZ9xoBNCdUfk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mWWL+r636/GQ7zdUdpDy5ed7fClkIUpt7H3808kmorXEkrM54PfRAAX3W84G04LMGFmY+DIFKqcGCBdt1OiBXs591n4PcvnU15JJU35j0SlxQSs2EW60S0RqQ16F2wlFUaj+jMtIsHTkIC5M2UaC7FTJZNH2V0Iu+S1+SzL1TNU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=EHUjEWbA; arc=pass smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="EHUjEWbA"
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-38707d4c8b9so75244211fa.2
        for <linux-scsi@vger.kernel.org>; Wed, 25 Feb 2026 02:08:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772014090; cv=none;
        d=google.com; s=arc-20240605;
        b=SkYtvihq53HXO49JQvDFcxxKJOffi+zFes5eR7AmFBom1XkwA4aoG8X0k+lGWnroLh
         qG1PgNA9C1f44tJGocBBwuENWBaofIq61DFQyHpDy7cvDKw/XAd7uigPgVGy+Cj2IGBm
         WPhdRcZ89AICLGU7+Ze48HLOh/IUJFk7jzzgwwpM6WNYqpIh2i3yuySVEKmwwvjssGHo
         Zny8/60Ms3zs1ilGKLTDF3sLu619KT+lQnzPTbN6z+yauoEi1qQ6z5+sIDtTt0Pu12Hy
         /JxqXeo8JJKreLJqYDr4HplbADcVA7GWEyzBvPbBB+7ulyP8MHsY0yukW2BkKtK2oOan
         MYCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=P+nn7GxNNTTR4z83VRm4nDPbYz8l5IDhZ9xoBNCdUfk=;
        fh=9Ab1KV54WsEAzp8jv+SfsdMPDqZwWhyEuEPbQ/uWm5Q=;
        b=Vy24/2/1nOk4jUATIWHI5lLLEndEghLsDud2jn0lOoNpze9HrUmoQpzm48zvr7RF1K
         rj4P/Qc8BhJi4gMVRvHi8s1eqlu6GLMNmH+5neL16eMnIZOH8lqi6bGFFG5LxYnD99la
         f0Fqa1EG4Z329h8HnV6OzFTDXuIoF02oP8JOPqCRxvxjm7sK2o87/xIpgSAhc8YiVnGB
         ACLBFC3vJbVaJYuWPMdPZn82urybPJyd3sZIMwxIgQB7uEOUbB01CFDcbSWtgCvSp41Z
         IW0wYAUE8qDDku+p0u/GGepB29bmrUdXW3bpJTNs7Jt0aZRb0dLHUTYj6fceDDC51upn
         2ClQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1772014090; x=1772618890; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P+nn7GxNNTTR4z83VRm4nDPbYz8l5IDhZ9xoBNCdUfk=;
        b=EHUjEWbAmES8Sf83245PgtIM8NbuFiFAiI2agIi42ooPvjuPeMZUkyJ6AL1iZlIuM9
         RxbLTm1ut57NfxMO9zTSXN9FCCWRkA2iprpqJrHj+T1WdSbxDVmZ4XfSBZnj2U/yT7TJ
         70SmgInM23E8fCP/TeHF0vozWxBM7MBDmTghms4xq3LLRV9kBG5cVy8eCeZHQM1Cz3EB
         LaMbglT25bSg/I9OZKB72d8o68aD/Zy/MxbNxHTXTCFS3Ltf191tavlga03a25E31ZKm
         vkIn+7uBgHpOEiNYN2ZRKMzWMdHJj1vtC3uUg/TtA/+Ik/urSZ7Wr1RVDn0C+0NqcAU2
         UcVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772014090; x=1772618890;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P+nn7GxNNTTR4z83VRm4nDPbYz8l5IDhZ9xoBNCdUfk=;
        b=Nj2gxrifdYEDAfk9df0+BjQcf71YRHLSWdoLnvKDpXytSRoBI8Z8SdlVUR0GE7iKn9
         rnYprHdAKg6/xYpVgTPBpn4wHIOks3byhKZ5+mXqrd5eS879xan7ToOmQs+WwyWBP+j+
         X8mpTpktSEhncBQsYS+k0LMQAA/hnHi/LX3CF8YAprY3PWanYEDvAXCfg6fTuev9RE5T
         6CWN7un5VrFVUwT0EAk+JR1RtEzGdoXLeYadvm/pf95FHJS/Gs8As+nGvYqVEiwgKBcW
         APePu9+7ovSu9ZhVoFWP0/II4th9Aako4SYbFSeV0INBg0aSLx329A/+wYCVS5gg0TgS
         yTzA==
X-Forwarded-Encrypted: i=1; AJvYcCXM3rn9R5nWYpEwA3pFiUuffRqVC3SgYXXTG06+EzHgCttlJO0QIKZ18wfPeN0knIvLXiRu0J2UgZqE@vger.kernel.org
X-Gm-Message-State: AOJu0YwnP2pdtG++/Dw7/R58YL7yCBNLEwBe3lZ6P7MQ4sj1Pr0/LL3k
	RQrZrhSIn1kSHpgqbUxdryipkqleqL/8VRlBn0KxaE/sHauRz3l6aHOgfk7uKJt4aOX92491ed4
	a555bBJrZNVB/xBGz/auQtqLW9OlCPQed34AQ14A9LQ==
X-Gm-Gg: ATEYQzw3zJljxHG3qnDUElfVZTzVHnZtNSPZkUpy1cq51/J2HBpDq0UBYcOWyVeVq7d
	N8jSlXwtYj0WD+3C/lqGuFIDEl4Elvbi27IJI3Qh32k9llDh74h8f3eM2a2suQpPc5mvlQpIL6x
	aNVWPIInEMUrTveVz2u/MZuH+yK8f7mQYlSts8X5SJJc/zVdQGlemVtb76xDIsoQrAIRJAZeEC4
	b8pRthnt9iEBnSe8oz+Mbz6pR7mVziiqSRObPm4vG/n7fJszrBNeQeS0OjO8R/q+P/jNPYAr5/6
	1azmLrXWmYaxiqK4KJjuh9J8JzvGShcT/ef/qagu05u3K3UWySoUwecs7nY4aWOcv+T7
X-Received: by 2002:a05:651c:324e:b0:387:421c:3cc with SMTP id
 38308e7fff4ca-389e2bb0ca7mr6069021fa.16.1772014089948; Wed, 25 Feb 2026
 02:08:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <31a2a4c2-8c33-429a-a2b1-e1f3a0e90d72@nvidia.com>
 <459953fa-5330-4eb1-a1b4-7683b04e3d45@flourine.local> <aY77ogf5nATlJUg_@shinmob>
 <CAJpMwyis1iZB2dQMC4VC8stVhRhOg0mfauCWQd_Nv8Ojb+X-Yw@mail.gmail.com> <40edeeec-dbc3-4aef-ac86-691e1ed2ed06@acm.org>
In-Reply-To: <40edeeec-dbc3-4aef-ac86-691e1ed2ed06@acm.org>
From: Haris Iqbal <haris.iqbal@ionos.com>
Date: Wed, 25 Feb 2026 11:07:58 +0100
X-Gm-Features: AaiRm53Zv-ldie7aCzcsDbQaCCWr2F8I9cWxTChkMF5C5q2noC0qJ-esR5e6yic
Message-ID: <CAJpMwygzTcBnKVp=bJWZpW9X5JdcP9Lj4H1BRBu2bNV_kGyDQQ@mail.gmail.com>
Subject: Re: [LSF/MM/BPF ATTEND][LSF/MM/BPF TOPIC] : blktests: status,
 expansion plan for the storage stack test framework
To: Bart Van Assche <bvanassche@acm.org>
Cc: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Daniel Wagner <dwagner@suse.de>, 
	Chaitanya Kulkarni <chaitanyak@nvidia.com>, 
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, 
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, 
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, 
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, Hannes Reinecke <hare@suse.de>, hch <hch@lst.de>, 
	Jens Axboe <axboe@kernel.dk>, "sagi@grimberg.me" <sagi@grimberg.me>, "tytso@mit.edu" <tytso@mit.edu>, 
	Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, Christian Brauner <brauner@kernel.org>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, =?UTF-8?Q?Javier_Gonz=C3=A1lez?= <javier@javigon.com>, 
	"willy@infradead.org" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	"amir73il@gmail.com" <amir73il@gmail.com>, "vbabka@suse.cz" <vbabka@suse.cz>, Damien Le Moal <dlemoal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 23, 2026 at 6:08=E2=80=AFPM Bart Van Assche <bvanassche@acm.org=
> wrote:
>
> On 2/15/26 1:18 PM, Haris Iqbal wrote:
> > A possible feature for blktest could be integration with something
> > like virtme-ng.
> > Running on VM can be versatile and fast. The run can be made parallel
> > too, by spawning multiple VMs simultaneously.
> Hmm ... this probably would break tests that measure performance and
> also tests that modify data or reservations of a physical storage
> device.

Performance related tests can be skipped when running in a virtual environm=
ent.
Regarding data modification, if the tests do not involve any crash or
reboot, then the VMs can be started in "snapshot" mode. This gives a
number of advantages.
a) Data modifications will not persist once the VM is shut down. This
means the disk will be clean for the next test cycle.
b) Using just a single set of qcow files, one can bring up any number
of VMs in snapshot mode. The data written while the VM is running can
be safely read/modified, but it disappears after a reboot.

>
> Bart.
