Received: from mx-lax3-1.ucr.edu (mx-lax3-1.ucr.edu [169.235.156.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB031BA26F
	for <linux-scsi@vger.kernel.org>; Thu, 29 Aug 2024 19:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=169.235.156.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724959868; cv=none; b=mQuzGDWyy2CePYp+vo4fOJVNzqQ2paZ81iUXGq8pZwQ2ZWgB+RQCMvlrn/6bUWj6f9xhXlv1WHIwLw1HAYG7de2FWGQHzPXXJ3diM7cTfGUKq0W3g7SlHzJ+UG7m5VHzHpkr4DLcbv1ydc0MylG+tVnpLBrQvZ1Zx2YKdMvrkOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724959868; c=relaxed/simple;
	bh=wl3uXxjsX6/WbbEdlvPAhMe7ckD5aMLXMMBdqeG2kXw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VEvgo+vW8J+vsznK26oTzO9Kv8k22ZK9X0W32GjxLBqDdVhVY28d3TfAyqowj0z1BnpLBT8a7kj94lPxXEXuPNTYgu4JYFVRw+XGJvdwikyNy09E/GJiMrUkpLXQgLOv1JdBnVPte1YvMWXVgGX+hUc3mvzo7fs5/paD0BIWSks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=email.ucr.edu; spf=pass smtp.mailfrom=ucr.edu; dkim=pass (2048-bit key) header.d=ucr.edu header.i=@ucr.edu header.b=WRdXX1qm; dkim=pass (1024-bit key) header.d=ucr.edu header.i=@ucr.edu header.b=LSojUUH4; arc=none smtp.client-ip=169.235.156.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=email.ucr.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ucr.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ucr.edu header.i=@ucr.edu header.b="WRdXX1qm";
	dkim=pass (1024-bit key) header.d=ucr.edu header.i=@ucr.edu header.b="LSojUUH4"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=ucr.edu; i=@ucr.edu; q=dns/txt; s=selector3;
  t=1724959866; x=1756495866;
  h=dkim-signature:x-google-dkim-signature:
   x-forwarded-encrypted:x-gm-message-state:
   x-google-smtp-source:mime-version:references:in-reply-to:
   from:date:message-id:subject:to:cc:content-type:
   content-transfer-encoding:x-cse-connectionguid:
   x-cse-msgguid;
  bh=wl3uXxjsX6/WbbEdlvPAhMe7ckD5aMLXMMBdqeG2kXw=;
  b=WRdXX1qmNEAHEMP0zERZJvheNWtULxLZKUILKefzQdmfPU+ZQ+5r2n0+
   oTYP64bKy2KiDZ0njNtB03V10CN7WzNgs50/AdvvG7Guj/Rwi9eROQYOp
   rULiwymOv5h+Qw+W55jF9jNeb5Jlb6YvKJL4MTES4++4/Hf+MsHKkUqUK
   OoIQro6SaTCdEhPqejEObdLnp7kwa0W110w0GEtTCTtN5X7ZjynPC6dpf
   RMGSslLajaVjRL5RKIfCkBPXOnN8MUX+Lm/nrW5UvU0vcEMAUMbIvHDZL
   mXBy1h6SJLxwhutcvO8bA7VaiP3ekNvZhQogf1QNdTOIhoke9FdvjgOZ9
   w==;
X-CSE-ConnectionGUID: QLngcpyFTfetHUXOkQg6SA==
X-CSE-MsgGUID: I5htIAhhSXm6TT8IjmI/kA==
Received: from mail-io1-f72.google.com ([209.85.166.72])
  by smtp-lax3-1.ucr.edu with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 29 Aug 2024 12:31:05 -0700
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-8278114d3a5so123533639f.1
        for <linux-scsi@vger.kernel.org>; Thu, 29 Aug 2024 12:31:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ucr.edu; s=rmail; t=1724959865; x=1725564665; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/B6eAyB0rutS0OFlsLM/NeX9TyquXOcwfRJFU97SaWQ=;
        b=LSojUUH4aMH99HlVYVJ0LYg55CUfN2xfpC+DdR1K1pkKpBCXrA3cc1iEceYOkyXDs9
         d7JbORCG9YL7SLbPDFBKE1n3AR7dhzcAqv1+XGG1l0O/8OgDDQoRWInlIDUYMIvNBtKI
         EY3+NHC5iN76kkrKo4k9vVcLnyaBWt+8Th+Ys=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724959865; x=1725564665;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/B6eAyB0rutS0OFlsLM/NeX9TyquXOcwfRJFU97SaWQ=;
        b=QBQrH8KaS73LVNbn2uBr78Gj70C/JcBD9L4irdgGVcFGwt0OVBWDF9V4vP7zx/8o14
         N0hKm19z4hjIQ1LNqlCJ0pFUCkz1AoV0adLqFkFT48sDXGlM2g1xdUmSFA9M62dqEbXE
         W9CRu1KQCDnE3TNB1eHep4KYwfAO5mktq/YGQZqo/RgcaEb43lrhuzf88IxtgNul9saI
         BvieZ3dm97S+whrARjtMsgRjr7othuVVyvVfrzoyN5E6kecxWl6qtBd6jToa+mpJEuoP
         usuDHY6bVe2rMJmbDJmvUpFkxcl7MNZIxrvDoSEZNeme5uTNvJalDdTzU1zO5UkGI9A6
         AR/Q==
X-Forwarded-Encrypted: i=1; AJvYcCUEj/2b8RcER/oXQmhj+ftZdBDGrQ6Y/HpbdjRHvnwm6rmeMzpJnBiZFU6bHSP6zDg0au2IOlKiKyoo@vger.kernel.org
X-Gm-Message-State: AOJu0YwCxmBPrBs75eKIqls9BWOYS2ESKlByEsW8MAu+STheXBHzVjxH
	Oregd1Hi3kiS2vIkT67OxMN3/T9lOoSZvTqn9Zltcjmi6ewr/hV1Zzdi3500tqTU0O3jEed3cah
	ztOBKTldNivS1qRG15QW5TaJ6EwSSdGoPtsmH35UOYvvIgHNFKTfHl2HlLSVefWYgA7UFj91tbn
	sGohFS8YGK8dSipYDcnYkDXzeabk0FtDXPQfA=
X-Received: by 2002:a05:6602:619a:b0:804:1579:182c with SMTP id ca18e2360f4ac-82a11011423mr475823439f.5.1724959864559;
        Thu, 29 Aug 2024 12:31:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFh3of6TBdUpZgFiAW8GS9N51uJ2RTZjk6GymkzanvNxcr0pHxLoC/LHxVq76fJThCvbRBXC6sCzPzKIo7e+gI=
X-Received: by 2002:a05:6602:619a:b0:804:1579:182c with SMTP id
 ca18e2360f4ac-82a11011423mr475821539f.5.1724959864181; Thu, 29 Aug 2024
 12:31:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANikGpfDVGGA+gpRqik5NATXsXUqDa2JAFiVRGCLkPthtq4=Qw@mail.gmail.com>
 <f1bab04f-6e7c-4213-a1ac-ecba95f26b23@acm.org> <CANikGperkKz4=rGrmU4748z8JCTLvURarhmVFN3g-vDzBkZ2Ng@mail.gmail.com>
In-Reply-To: <CANikGperkKz4=rGrmU4748z8JCTLvURarhmVFN3g-vDzBkZ2Ng@mail.gmail.com>
From: Juefei Pu <juefei.pu@email.ucr.edu>
Date: Thu, 29 Aug 2024 12:30:52 -0700
Message-ID: <CANikGpcm2ytALYjKG9n05Pe2LJJvoYNuMr-bCPFSB7V4twgYdg@mail.gmail.com>
Subject: Re: BUG: corrupted list in dst_init
To: Juefei Pu <juefei.pu@email.ucr.edu>
Cc: Bart Van Assche <bvanassche@acm.org>, James.Bottomley@hansenpartnership.com, 
	Yu Hao <yhao016@ucr.edu>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
	martin.petersen@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Syzkaller uses `syz-executor` to fuzz, but inside the call trace , the
program that went wrong is  `swapper`.  After checking the reproducer,
the `/dev/sg0` seems the most suspicious one since it provides users
with direct access to hardware.

My hypothesis is such access can somehow tamper the memory without
being caught by KASAN, and it just so happen in this particular case,
the victim is ` ip6_dst_alloc`.

So I feel that maybe sending the mail to SCSI maintainers is the right choi=
ce.

On Thu, Aug 29, 2024 at 11:44=E2=80=AFAM Juefei Pu <juefei.pu@email.ucr.edu=
> wrote:
>
> Syzkaller uses `syz-executor` to fuzz, but inside the call trace , the pr=
ogram that went wrong is  `swapper`.  After checking the reproducer, the `/=
dev/sg0` seems the most suspicious one since it provides user with direct a=
ccess to hardware.
>
> My hypothesis is such access can somehow tamper the memory without being =
caught by KASAN, and it just so happen in this particular case, the victim =
is ` ip6_dst_alloc`.
>
> So I feel that maybe sending the mail to SCSI maintainers is the right ch=
oice.
>
>
> On Thu, Aug 29, 2024 at 4:07=E2=80=AFAM Bart Van Assche <bvanassche@acm.o=
rg> wrote:
> >
> > On 8/29/24 2:31 AM, Juefei Pu wrote:
> > > Call Trace:
> > >   <IRQ>
> > >   __list_add_valid include/linux/list.h:88 [inline]
> > >   __list_add include/linux/list.h:150 [inline]
> > >   list_add include/linux/list.h:169 [inline]
> > >   ref_tracker_alloc+0x1ef/0x480 lib/ref_tracker.c:213
> > >   __netdev_tracker_alloc include/linux/netdevice.h:4038 [inline]
> > >   netdev_hold include/linux/netdevice.h:4067 [inline]
> > >   dst_init+0xea/0x480 net/core/dst.c:52
> > >   dst_alloc+0x157/0x190 net/core/dst.c:93
> > >   ip6_dst_alloc net/ipv6/route.c:344 [inline]
> > >   icmp6_dst_alloc+0x73/0x410 net/ipv6/route.c:3277
> > >   ndisc_send_skb+0x31b/0x11e0 net/ipv6/ndisc.c:489
> > >   addrconf_rs_timer+0x3a3/0x650 net/ipv6/addrconf.c:4039
> > >   call_timer_fn+0xff/0x240 kernel/time/timer.c:1792
> > >   expire_timers kernel/time/timer.c:1843 [inline]
> > >   __run_timers kernel/time/timer.c:2417 [inline]
> > >   __run_timer_base+0x734/0x9a0 kernel/time/timer.c:2428
> > >   run_timer_base kernel/time/timer.c:2437 [inline]
> > >   run_timer_softirq+0xb3/0x160 kernel/time/timer.c:2447
> > >   handle_softirqs+0x272/0x750 kernel/softirq.c:554
> > >   __do_softirq kernel/softirq.c:588 [inline]
> > >   invoke_softirq kernel/softirq.c:428 [inline]
> > >   __irq_exit_rcu+0xf0/0x1b0 kernel/softirq.c:637
> > >   irq_exit_rcu+0x5/0x20 kernel/softirq.c:649
> > >   instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1043 =
[inline]
> > >   sysvec_apic_timer_interrupt+0xa0/0xc0 arch/x86/kernel/apic/apic.c:1=
043
> > >   </IRQ>
> >
> > I see networking functions in the above call stack. Why has this report
> > been sent to the SCSI maintainers?
> >
> > Thanks,
> >
> > Bart.
> >
