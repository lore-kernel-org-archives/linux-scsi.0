Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594F038A71B
	for <linux-scsi@vger.kernel.org>; Wed, 13 May 2026 02:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778640712; cv=pass; b=IegSZuzCzIjaXRsFJMNEIrQvBPveAMlNFvf8RvFRQYBj7K0nN1yO7xosA2JCCPtMsgi4/j+G3lmlMmgrSjiAgSDr5wr6iiyCUb0AmveHnfO1k17JkAoMFh/SUIW5LVBMNhUKFVoLYErO2GA0wu9nEfJki9D+USqknz0X30ztvnI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778640712; c=relaxed/simple;
	bh=raam9DVb6nwGgVMeORu4BM/vz6+kYfQFafLG0g3ziek=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c6wAoI0XE/90m0Z+xmj22i+lX/JXkbLL+M162fW7ayS05aMzD6selux3Qn6mdLR1DcsrEaj62nTFNxNEiC/E2eypTJpBBRmZIYaJfNBi2Jj+xxofgYt62dnDndRtD24qN4ui0Ggwqs7NCbdUDoRr67NHWovQGnnJGswshm0cb1w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=fdJ3Un6D; arc=pass smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="fdJ3Un6D"
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7dcd54a8d17so630951a34.0
        for <linux-scsi@vger.kernel.org>; Tue, 12 May 2026 19:51:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778640710; cv=none;
        d=google.com; s=arc-20240605;
        b=NP1pTvVWRlPumIPipKmWe7UsvbjWxd0Sow7ykoFTV3EKqHLs20ryUxWHlFC/YjObPB
         v8dhxHu6vndNv9Fi2xv6l1kmy0lIpRvLEeZs0Chf8mswNS70qY3S5HV1ZutsVd607vUK
         CT0bBOPflqgt2I2S+m1IcHu/4RCToZBaQyNDO+Ici7WC0XdJn4+JzY+Ub87WJeQppulY
         /Pg9HdRCxgwd/gNkECvlWPWnEk7rfZ+ShYvFbKVDVK8OR8mb4K84W40rnDaiB3fiNSja
         dby5vRNRIm2bmXOD87cjfHkUzZBUqYrux4Csc0uEeMoHASVOv5CIqx82uwLsNOaG4FPk
         YyKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=raam9DVb6nwGgVMeORu4BM/vz6+kYfQFafLG0g3ziek=;
        fh=9ljPOkNtDyCjrrdSv5j1sKmAsCFelKhLAC3Zo2NHNrI=;
        b=cfhZEuwV+gea52jbsgHY/wzQBbkQYpR/d05/3HvAsCZ/jzG/l+tDX9EHeKVFh7jPrT
         UFDGiXWwpFALfN9XvqtfgYbcFKBdert1JqWLc9iZXmZP/IjBjJ2L1IcDfOOpFAOVLOhk
         7ppq/rQsZOGUhPcTkwThJUwpOl4Tbx7Wp8heM3Z6/yeivizbE/I8/1z2plq19aG8iA+o
         oVpFUGEjmSN7X4WaQMGfax9faGELdeVri2YsIKlb8XmhigRh/zDeepnLDMdGBchh1F1A
         xSUR4mki4JQrQd+f/kpASoZyd5JQe0ix23O6TaPoJMK9gjri8xNJ230tuJoZdGTeMvME
         wvJg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1778640710; x=1779245510; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=raam9DVb6nwGgVMeORu4BM/vz6+kYfQFafLG0g3ziek=;
        b=fdJ3Un6DAoxZo2/gGBlIAAeQDRz3DYXwiaMfealv5cotg4CdH7ts4CYCNrulYFTGiy
         5Y930QH7VOBLpXX9qnh3l9EpSWwgEsyCWTcNG6RL1TcmUgIyrDVYvju0UOKZoUjk+RSJ
         6amyW51TSk8TKLQs7c307lfDR3EsSTz5vyLGjerM6ip8BDQs+hFScvM8SUkk/y4hkLY9
         QLxYUy/8rYuaGRIjoMopOCnU5vnvsMQkUFnA9a1cTK6MmIdbAbQ4DR54sEkBkOQrnl/2
         mAZDQBOdEj8LltC7KRJBmf6cyOCSMPo02CS/XwATAtyO/FjwbqzuoHxrLFwfAEcCOPUf
         WudA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778640710; x=1779245510;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=raam9DVb6nwGgVMeORu4BM/vz6+kYfQFafLG0g3ziek=;
        b=qzm5DYu+u3KPd9tRrmB4bF8M9sjbPaNmEVJwzl5pKllqOeJ7V5U3FEb9FP74KpWmp+
         nuIlxulVpOUJNHTS6i2msdKeFnw8xe5cN4iiCBhouV0kax8ZKIzAi9SJGufScEEXf0N4
         BOpQ3oaSAtZj/sGEGAbvGA6dKLQdS1R97LebSdTSCNamhnq37NX8x6Ltd925b6NmZja1
         BHcdcN7O+fYPVGJXeer9jpPol0qbPtTbVQRuvCFf5uySWfSWeTKcsDPpv8mOdaQazNv5
         FE8UlJ5OaRvFpa9N380nK+iAhRoB33w+YYCzUxQIhfmZJ3HD+36huRZC9BNa3QoKRryj
         wUog==
X-Forwarded-Encrypted: i=1; AFNElJ8+otqzdsE5EGXc2Tj8EmxC1exoZFRLmhAvDrUh/UDfQxUiNX6CBto5TqzdneCXHdE225xCRTDnEkpj@vger.kernel.org
X-Gm-Message-State: AOJu0YzCYXExGXuW4kh6UVsDAN60GZfFdwmYDkxYiDHOrdUv1cJsKZap
	OlmOJX8v4g50jzY2K7a9JHweOa5qG5zaSIKGHaUg8hm4wMI+F1y7DTZHXNsPx1t73oTS12uGDCw
	DjLQqT7aSNTIdlQcGCq3nqWByr7m+70DXPCF8kGmpHA==
X-Gm-Gg: Acq92OFuIwxjgS6VfC3qsfJRCOLs2LfXJdcwHhN2U3GtVs01qyx53wRGWbuCymgZrAz
	0O/oxXJbwVZlLFHK9XnAljx+krxumqU/OY5eJ+fWuVmtTrI49/zQRmhECLkNq6Dl2n19haNUOrm
	l420CgH7ygjgg/I1s4os2N4oEx0hNz0p1wrZpJijeTuHHZu2l2eBk0VSh0K/JYXOQNKaojKwwBx
	czDlbIIZENuDMrDkBDBW3umgFypkL4WfJyEx4FocU/CaP/9dVSao2MSr+K8mpyGExAvphZhRtM9
	EJH/ZJlNT2xVh6V+Hi0=
X-Received: by 2002:a05:6808:640f:b0:479:ffcf:52e4 with SMTP id
 5614622812f47-482b2d823a2mr634406b6e.8.1778640710257; Tue, 12 May 2026
 19:51:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260417015732.2692434-1-csander@purestorage.com>
 <yq18qams3re.fsf@ca-mkp.ca.oracle.com> <CADUfDZrwzUTi2TOj6M-+FtBK6u5evMsWSBqRDwJsLb8yLbOGvw@mail.gmail.com>
 <yq15x5lqfdx.fsf@ca-mkp.ca.oracle.com> <CADUfDZqkT4g3T6uE=hxt9J6JDMXbJt49rM7_Vgs3EBPdFeuuLw@mail.gmail.com>
 <CADUfDZq+BZ4Xn19TXH53NndDwDwMKm3xS8wSMnMtRsF7dWSyGg@mail.gmail.com> <yq11pfgxf9s.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq11pfgxf9s.fsf@ca-mkp.ca.oracle.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 12 May 2026 19:51:39 -0700
X-Gm-Features: AVHnY4I5-V51JtkIh-Ssp6M4Sux20aXJQq6-7lAFZgFvHPFmHKstgGsa0VGqDxM
Message-ID: <CADUfDZoYNjMCnBwoHmH0pbdiacmQ+aJd=p0KYxad2UB-UJ9-MQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/6] block: fix integrity offset/length conversions
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	Chaitanya Kulkarni <kch@nvidia.com>, Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 12, 2026 at 7:16=E2=80=AFPM Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
>
> Hi Caleb!
>
> Sorry about the delay. Been away for a few weeks...
>
> >> So seems like patch 1 ("block: use integrity interval instead of
> >> sector as seed") doesn't need a Fixes tag. Still, I'm confused why
> >> the auto-integrity code bothers setting the seed to the sector number
> >> in the first place if it's going to be remapped later. Why not just
> >> leave the seed zeroed?
>
> It adds a bit of extra protection in the sense that it there is one more
> parameter that can be validated. The premise of the integrity
> infrastructure is that things in the two supplied buffers (data + PI) as
> well as the control path (bip in the block layer case plus the SCSI or
> NVMe command fields) all need to agree for the I/O to go through.
>
> It is valid to generate the PI starting with 0. But that is
> indistinguishable from "the seed value was not initialized".
>
> > I would appreciate a response here. Would you be okay with patch 1 if
> > the Fixes tags were dropped?
>
> I am afraid I still don't completely understand why things are broken.

Nothing is broken, I just mean that the seed value stored in
bip_iter.bi_sector is strange in that it's initialized in units of
512-byte sectors but incremented in units of integrity intervals. As
you point out, the remapping step makes the initial seed value
irrelevant, but I was certainly confused by it when I printed it
during some debugging. I can update the commit message to clarify the
rationale for the change.

>
> For writes, the meaning of the bip seed is: "This is the value you
> should expect in the ref tag for the first integrity interval in the PI
> buffer I prepared". With block layer autoprotect, the seed is set before
> generating the PI and thus implicitly affects the generation.
>
> When the write operation subsequently reaches the bottom of the stack,
> we will check that the first ref tag in the PI buffer matches the
> supplied seed value. And then proceed to remap the ref tags for each
> protection interval to the target LBA + n since that is what the storage
> requires (ignoring the odd Type 2 interval mismatch for now).
>
> For reads, the meaning of the bip seed is: "This is what I expect to
> receive in the ref tag for the first integrity interval in the PI
> buffer". At the bottom of the stack we will receive PI from the storage
> and that will contain ref tags matching the lower 32 bits of the LBA
> since that is what the hardware returns. And we will then remap all
> those ref tags starting with whichever bip seed value was requested by
> the caller. It doesn't matter whether the requested seed value was 0,
> 10, or 42. The ref tags are remapped to whatever the caller wants them
> to be.
>
> I tend to think of the seed as a register you program with the value you
> want. And then hardware or software remaps between what the storage
> device's protection envelope requires and what the application (or in
> this case the block layer) requested. With SCSI + DIX 1.1, the seed
> literally controls a remapping register in the HBA ASIC. In NVMe we have
> ILBRT/EILBRT.

What I find confusing is that the seed value stored in
bip_iter.bi_sector isn't what's actually passed to the SCSI/NVMe
device. It's only used in blk_integrity_iterate() and
__blk_reftag_remap() to generate/verify/remap the reftags in the
integrity/PI buffer. However, (E)ILBRT field (taking NVMe as an
example) comes from the physical block device offset rather than the
reftag seed. See t10_pi_ref_tag(), which returns blk_rq_pos()
converted to integrity intervals. It looks like this works because the
remap step ensures the reftags passed in the integrity buffer match
the physical integrity interval numbers, but this means the device is
comparing physical integrity interval numbers rather than reftag
seeds. My point is that if the remap step undoes the effect of the
seed by setting all the reftags in the integrity buffer to their
physical integrity interval, I don't see why the block integrity code
bothers setting a seed in the first place.

But it sounds like this may be a longer discussion, so I will split
out the two fixes for 7.1 into a separate series.

Thanks,
Caleb
