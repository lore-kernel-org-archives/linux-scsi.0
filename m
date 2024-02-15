Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751C612FB33
	for <linux-scsi@vger.kernel.org>; Thu, 15 Feb 2024 14:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708007122; cv=none; b=hw4VEwEUsc9sXkJKWGCzwbmjHtBwcT8ZGIQVGZPwecQAFjeU2Y+478oMpmtxT2PDH+uvmKZflz0kjiKAN3pd8EUwrkKkK15eqgovGwju4fmYd9QVebvAyW2L+7MnJZRCFSq4Pql2kDSMjsaYGguCOkZQgLlUVVlf4PyolmLg3e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708007122; c=relaxed/simple;
	bh=pPO+fdyqkZ/W75d4zmCJcJncKOqkQc/GAAvZtGJYjW0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f3F8cfddmimLM3SpiJEbh5/z7hcyCgi6k1XZz0pfUas+vOrjV1SjyTG+ZM9TjnbzL9ur23ZDmtV7E/Ji80HPHi4VKBHCPVjKxqvswLr+qv1YdzG1UrkeQgDyC5P5OzVyOAY2CgvRnVzoJ5y7K8mZuskbzZ+v8wJzOvbDHCBhnFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E6C/3ZLl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E6C/3ZLl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708007119;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f1sNIHlYWH5xzMyuc5tUzbvFfRXf0HUVow9yGWgcW8c=;
	b=E6C/3ZLllzILUyVlp1dLqK+mIQ/JVaY7jod1PrQHdz1fs1X10sKrSEmdu9RGJ0G+l6fmG/
	g/ObHbm10SAvkljwW1mKaoCHXG4hjp130iil1qqCleHzkAuA6t0tPKAY4jWDZ8nDAjMnmG
	OBbc9Lp/g6SfpvhQGOgut7duyNTCPjs=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-10-vuxxy3JsN6mcJNyL0UU0vw-1; Thu, 15 Feb 2024 09:25:18 -0500
X-MC-Unique: vuxxy3JsN6mcJNyL0UU0vw-1
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-5efe82b835fso19882797b3.0
        for <linux-scsi@vger.kernel.org>; Thu, 15 Feb 2024 06:25:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708007118; x=1708611918;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f1sNIHlYWH5xzMyuc5tUzbvFfRXf0HUVow9yGWgcW8c=;
        b=uOs0JZu/R1X+8pI5JzZ32NHzpIqSQhlIpWotjLfJIFa10w2p7xwbLThCTO1RdBfMJA
         psSC0c8NjR1GhCWBvG87uFGxL2XF08Uhr7ewSaIYl7WRCcKPSxnirls6PUoS1EFr6Xc1
         6F+f2bqvuxjGiKJ6QTY0XrmwWPoW6NZYnhDDM3CrNuOryQ5gfSltCa5gPswVs6iZXrt3
         yIBiP16HTQEqIw4Y5xzW0tr6VFjas8E70At4rSHbbFCWEcQwAxBFSIbjBtPG5oCvqnSS
         g1JGz6i74uXyW85iitLMjd2DFh6ZFX6SvUz9AP6bngWJmdLi11vNzdw911ufJVrpuKTy
         9X8Q==
X-Forwarded-Encrypted: i=1; AJvYcCUQJQ1KQpuTzMHf9umlzwMZHLFB6tEtRp96pS+ib2yPeVV7/Lf/j7+LnCtZRmEqO3g3cjqfYcIc5wZRrJPiwEgGJ6yyTZkcLFR3bg==
X-Gm-Message-State: AOJu0YzoBgJBUlRxTRoEtay5cIYxZUOvMrjFmJpYKgCqxTKuRnWP6pEX
	Lv+UnenjOtHgrb7Q9MW4o0qa6ZhBxRx/K526ANOX4OCnTM4qYJuoldQ7eRY6xB5DY8jHrAk1OOv
	dJCSQolOZCPdlZwTTYwAP9AnnH+vH1RMcy6PFDuOFi0l0Vl0MePck7pkQIl1JI7REtM8A6A8bHK
	JwRmj4/qWjouNIgpPt4Gp0N+WO2XImrGFQpQ==
X-Received: by 2002:a81:9297:0:b0:607:a022:8103 with SMTP id j145-20020a819297000000b00607a0228103mr1995413ywg.29.1708007117532;
        Thu, 15 Feb 2024 06:25:17 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHFfT2UilwapZJLAZWC9yvBzDhDBh3xYPXZIj6Nzg7Ce4DrcXnJgs8bSj63pWBIfB99rI6+C+c3WfgSVLSYYNw=
X-Received: by 2002:a81:9297:0:b0:607:a022:8103 with SMTP id
 j145-20020a819297000000b00607a0228103mr1995377ywg.29.1708007117065; Thu, 15
 Feb 2024 06:25:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240213162200.1875970-1-don.brace@microchip.com>
 <20240213162200.1875970-2-don.brace@microchip.com> <ab1ac37c-0dd6-4c7b-9c09-832c2bbc6a36@redhat.com>
In-Reply-To: <ab1ac37c-0dd6-4c7b-9c09-832c2bbc6a36@redhat.com>
From: Ewan Milne <emilne@redhat.com>
Date: Thu, 15 Feb 2024 09:25:04 -0500
Message-ID: <CAGtn9rkAo=PCazkbLP_m15eDa2m-zA-dLkjpv0jhy4-8x=bJ7A@mail.gmail.com>
Subject: Re: [PATCH] smartpqi: fix disable_managed_interrupts
To: Tomas Henzl <thenzl@redhat.com>
Cc: Don Brace <don.brace@microchip.com>, Kevin.Barnett@microchip.com, 
	scott.teel@microchip.com, Justin.Lindley@microchip.com, 
	scott.benesh@microchip.com, gerry.morong@microchip.com, 
	mahesh.rajashekhara@microchip.com, mike.mcgowen@microchip.com, 
	murthy.bhat@microchip.com, kumar.meiyappan@microchip.com, 
	jeremy.reeves@microchip.com, david.strahan@microchip.com, hch@infradead.org, 
	jejb@linux.vnet.ibm.com, joseph.szczypek@hpe.com, POSWALD@suse.com, 
	linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 14, 2024 at 6:02=E2=80=AFAM Tomas Henzl <thenzl@redhat.com> wro=
te:
>
> On 2/13/24 17:22, Don Brace wrote:
> > Correct blk-mq registration issue with module parameter
> > disable_managed_interrupts enabled.
> >
> > When we turn off the default PCI_IRQ_AFFINITY flag, the driver needs to
> > register with blk-mq using blk_mq_map_queues(). The driver is currently
> > calling blk_mq_pci_map_queues() which results in a stack trace and
> > possibly undefined behavior.
> >
> > Stack Trace:
> > [    7.860089] scsi host2: smartpqi
> > [    7.871934] WARNING: CPU: 0 PID: 238 at block/blk-mq-pci.c:52 blk_mq=
_pci_map_queues+0xca/0xd0
> > [    7.889231] Modules linked in: sd_mod t10_pi sg uas smartpqi(+) crc3=
2c_intel scsi_transport_sas usb_storage dm_mirror dm_region_hash dm_log dm_=
mod ipmi_devintf ipmi_msghandler fuse
> > [    7.924755] CPU: 0 PID: 238 Comm: kworker/0:3 Not tainted 4.18.0-372=
.88.1.el8_6_smartpqi_test.x86_64 #1
> > [    7.944336] Hardware name: HPE ProLiant DL380 Gen10/ProLiant DL380 G=
en10, BIOS U30 03/08/2022
> > [    7.963026] Workqueue: events work_for_cpu_fn
> > [    7.978275] RIP: 0010:blk_mq_pci_map_queues+0xca/0xd0
> > [    7.978278] Code: 48 89 de 89 c7 e8 f6 0f 4f 00 3b 05 c4 b7 8e 01 72=
 e1 5b 31 c0 5d 41 5c 41 5d 41 5e 41 5f e9 7d df 73 00 31 c0 e9 76 df 73 00=
 <0f> 0b eb bc 90 90 0f 1f 44 00 00 41 57 49 89 ff 41 56 41 55 41 54
> > [    7.978280] RSP: 0018:ffffa95fc3707d50 EFLAGS: 00010216
> > [    7.978283] RAX: 00000000ffffffff RBX: 0000000000000000 RCX: 0000000=
000000010
> > [    7.978284] RDX: 0000000000000004 RSI: 0000000000000000 RDI: ffff919=
0c32d4310
> > [    7.978286] RBP: 0000000000000000 R08: ffffa95fc3707d38 R09: ffff919=
29b81ac00
> > [    7.978287] R10: 0000000000000001 R11: ffffa95fc3707ac0 R12: 0000000=
000000000
> > [    7.978288] R13: ffff9190c32d4000 R14: 00000000ffffffff R15: ffff919=
0c4c950a8
> > [    7.978290] FS:  0000000000000000(0000) GS:ffff9193efc00000(0000) kn=
lGS:0000000000000000
> > [    7.978292] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [    8.172814] CR2: 000055d11166c000 CR3: 00000002dae10002 CR4: 0000000=
0007706f0
> > [    8.172816] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
> > [    8.172817] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000=
000000400
> > [    8.172818] PKRU: 55555554
> > [    8.172819] Call Trace:
> > [    8.172823]  blk_mq_alloc_tag_set+0x12e/0x310
> > [    8.264339]  scsi_add_host_with_dma.cold.9+0x30/0x245
> > [    8.279302]  pqi_ctrl_init+0xacf/0xc8e [smartpqi]
> > [    8.294085]  ? pqi_pci_probe+0x480/0x4c8 [smartpqi]
> > [    8.309015]  pqi_pci_probe+0x480/0x4c8 [smartpqi]
> > [    8.323286]  local_pci_probe+0x42/0x80
> > [    8.337855]  work_for_cpu_fn+0x16/0x20
> > [    8.351193]  process_one_work+0x1a7/0x360
> > [    8.364462]  ? create_worker+0x1a0/0x1a0
> > [    8.379252]  worker_thread+0x1ce/0x390
> > [    8.392623]  ? create_worker+0x1a0/0x1a0
> > [    8.406295]  kthread+0x10a/0x120
> > [    8.418428]  ? set_kthread_struct+0x50/0x50
> > [    8.431532]  ret_from_fork+0x1f/0x40
> > [    8.444137] ---[ end trace 1bf0173d39354506 ]---
>
> This patch fixes the issue on my machine.
>
> Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Reviewed-by: Ewan D. Milne <emilne@redhat.com>

>
> >
> > Fixes: ("cf15c3e734e8 scsi: smartpqi: Add module param to disable manag=
ed ints")
> >
> > Tested-by: Yogesh Chandra Pandey <YogeshChandra.Pandey@microchip.com>
> > Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
> > Reviewed-by: Scott Teel <scott.teel@microchip.com>
> > Reviewed-by: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>
> > Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
> > Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
> > Signed-off-by: Don Brace <don.brace@microchip.com>
> > ---
> >  drivers/scsi/smartpqi/smartpqi_init.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smart=
pqi/smartpqi_init.c
> > index ceff1ec13f9e..385180c98be4 100644
> > --- a/drivers/scsi/smartpqi/smartpqi_init.c
> > +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> > @@ -6533,8 +6533,11 @@ static void pqi_map_queues(struct Scsi_Host *sho=
st)
> >  {
> >       struct pqi_ctrl_info *ctrl_info =3D shost_to_hba(shost);
> >
> > -     blk_mq_pci_map_queues(&shost->tag_set.map[HCTX_TYPE_DEFAULT],
> > +     if (!ctrl_info->disable_managed_interrupts)
> > +             return blk_mq_pci_map_queues(&shost->tag_set.map[HCTX_TYP=
E_DEFAULT],
> >                             ctrl_info->pci_dev, 0);
> > +     else
> > +             return blk_mq_map_queues(&shost->tag_set.map[HCTX_TYPE_DE=
FAULT]);
> >  }
> >
> >  static inline bool pqi_is_tape_changer_device(struct pqi_scsi_dev *dev=
ice)
>
>

