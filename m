Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFB418871F
	for <linux-scsi@vger.kernel.org>; Mon,  9 Mar 2026 23:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773097689; cv=pass; b=QO2eKfJ9N9jaHj6xsdicSBwAZYzIZvNbjQlUNhigHtOmT2lLv2gOyXwr58j5ACEWskZ9WSCQ7ZVkazX78q3L94CozoSI94g0ey285cmszCJAkNo64r/xzrV/IrzefewC6MZuUjMLeJmqTNRSn8IwC8DoFRqgkRrORsk+mSzTSHA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773097689; c=relaxed/simple;
	bh=M4cduyEH0nzIyeAa2DWzTvD5pL+wmdKzftbWE4kTeiw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JxmahlUmrjNr7Hh97cJ8Fd3krV/dFGu7K+NilfYtLzmuTDA3XUfZKwOE/iyoi47Knzy4oPm9mqJLn0Pts90dpyedF0IoiV5OMX+/fJYg/m/NY3wEIe6hMfnyTXLCwP+BBEymA2Er+Xoa7KQmuJIQI7KU/xBfQDgW+wOemmw4mBA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cDfFzGOE; arc=pass smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cDfFzGOE"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b9423d62cbbso498478366b.1
        for <linux-scsi@vger.kernel.org>; Mon, 09 Mar 2026 16:08:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773097686; cv=none;
        d=google.com; s=arc-20240605;
        b=a8eK7Bm5nCjvho3JOYk2DhAW9S8/DqWeHWAWJegzYQnX2hYWefglcY4nuxW8pwe7Rz
         fByHMq2vYUEXwQV5HXfDMqEnymeHs5216Sn7D9cG+nL05tjCUVPhycB0D2WjEUwm088n
         WRAFaz+GfKm6+lXekSOAm2Ar3PQFlSEjbLEUjuyGVxzFSlsvSOLiOZ7ufrt1iefZnpjx
         kyp1PjyxLiAiOd3OhEyuLXNzU5c4hguTDbKV9W//KuZysEOb+Ng10Dte9bPGjVFzn8yb
         8iCoWfbAqnq7gCShO7DCGnbg5s0hJT622etNooXVLSeSYE9lEgioguWjH3Ydo+QoGmMs
         qMAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RBshlfHpx3Ec+CKDHPfm6S/XgqSY4C1OlvaszE0SqYs=;
        fh=nFTejMBR71qRYBElw+g5d+2Ic+y49NO/KGhNdaW+5D8=;
        b=AXUVtwV1EARzbrChiwzjMLKVkig8Lrg7xR+f0PgMNTHjdJu+MqJPXaOa12Kun0YiTj
         NsRNpfSUxUwqQ8zsi73zImYKKxfeGHWajq3sXmedDuVD2GeAqltanpSHeaC+m+qVkc9U
         yhOuYl/tESFNLCDjy/wbUNGN0ACmpQODD7+KrLqGf0TGtcAa5XaTOBWYEfatTUojWaSg
         DDtcoc/H0wEt14H2MLfGAuO2Bineo16Sc8vJ4Lz78DrlTXTxP8NEjrOokvVAKTcmknGa
         DL2K0xzBWl7ouU7SP2ce0kJThRXx1x1GQ6lxlXUjUlLsQCjRQUJZetaaVQZKL+exdPRP
         DF/A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773097686; x=1773702486; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RBshlfHpx3Ec+CKDHPfm6S/XgqSY4C1OlvaszE0SqYs=;
        b=cDfFzGOE5sK+f1LhppHF6qSbeS6nB/Hx16+gIJVR/GPS/DJAhBcFYliZVr87f4k0ro
         XQeYvDMxzLk2gJ7VzQPYk7VsfSvOedbLbM8uIco/h6i5ffHZARg6ruT2k9APKujElLrU
         d3us9wzpkorwvra0QhHw43ZMKx1SBjCDOONZEjKv5nmGfay6vgEAoFZ011xX8/YcH+FJ
         Pw9/3Gxoz0EaT8UQEcqfIuXcPcN9Kw4DNPzGhIRpzZyFkobkojxg6vMxY4AR9O9CrpIc
         wVsFDZi4EiKeaEpug/BeSLL42i5hBtXImYs1FasCx4nwoab5W0h+j9ogHcx//G4r69Da
         3/5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773097686; x=1773702486;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RBshlfHpx3Ec+CKDHPfm6S/XgqSY4C1OlvaszE0SqYs=;
        b=RwKffNbd7yG7TTPmUn1pifD5uHLricz9oggxcpww+GUkhxuExylvgELFislQDQrf6J
         LqmVKs/IywXKvJuhKYDmjCEQh0PUxOuewW4JS3Zj7ykOBF+tUvCf3mmQuEJfsru9tgPn
         6zlFceRoVThcI/tQwXjc7pmUmRDK4DTEop/iYqQUjvcBNOo+YexY/yt6MdQQ+ZlkgDj9
         PNH1MhRv2TRiR7f+7rWkGaZsEDAvfLve1fS4SRTn/1jygWVy1brQGd68ByZm2JCnpPSc
         tyeZxMbae7WU92gBhEQReD8rUb/RXbCaj+nAI+diwgappaH+FH+MMDzSzVchbDMV/0mA
         QCHw==
X-Forwarded-Encrypted: i=1; AJvYcCXGT7eTaYUbn7m6V17OYdbXWXdis1jexIzAXsdgzsLR6hjcaIJPWfSmLyePpP/JgxGCOgjbgjLepJAz@vger.kernel.org
X-Gm-Message-State: AOJu0YyYzI70HfxojyUuYg+afyJKrFvCKLVTu83PYdaDmpjhMSlZyXKL
	HSxJ3+cpsET6s5eQEkN6WVpWyg2Hiz9LcxLsRPSLwnfUQ8n623gqD7xuCHAocGN98V2KXnsMnj9
	ahhwrtYrskyKTINIUVDexVvstXaRtxkE=
X-Gm-Gg: ATEYQzzWj7m4Py5k/pHZcKefrf3zrk4F12OV23S+H/Tve45JAGHt/BBdo3RrB+JapaU
	VC3Jjnmv+fQYX1qutkFcad67N+LrY1CRhHcj7rOFG/3zuXLHM6vzmAGQu59dvS3MY+14tHVlSNd
	lAO0SeFjCyV2O2WiCkgaSdTDnpZbNMOJ+P+c7Bqv3pTLojNj+by4/2DbLFqB6oIb4FKwiIf6Ny6
	9yjvu3DGLbSLHSKTPUYjI5snl1Ey5Qss190vDQ+FWU+Nl6iKIOUQyjMJaSveH/eoNAVfplovMWa
	qE4Ntj/95CvztnESn5/1B2QoGODxdHUa6Sy1HPpHrg==
X-Received: by 2002:a17:907:3e10:b0:b96:e1de:db04 with SMTP id
 a640c23a62f3a-b9711a1fe33mr88963666b.18.1773097685832; Mon, 09 Mar 2026
 16:08:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260226204345.1904786-1-jdaley@linux.ibm.com>
 <20260226204345.1904786-2-jdaley@linux.ibm.com> <20260309030617.GB8611@fedora>
 <55a1fe3d-617f-4ddc-8d71-a8b498eb186f@linux.ibm.com>
In-Reply-To: <55a1fe3d-617f-4ddc-8d71-a8b498eb186f@linux.ibm.com>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Tue, 10 Mar 2026 07:07:53 +0800
X-Gm-Features: AaiRm52a24UUlcx8zgmavlWcAXJUewlR7p2esuE-N9GRDWx7T5YMpj0PqhmkvEw
Message-ID: <CAJSP0QUmtShZ4ObnVM79h31Qi0VJ42+81wtEJZwYm6K1DG+NWw@mail.gmail.com>
Subject: Re: [PATCH 1/1] scsi: virtio_scsi: move INIT_WORK calls to virtscsi_init
To: Joshua Daley <jdaley@linux.ibm.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, mst@redhat.com, 
	jasowang@redhat.com, pbonzini@redhat.com, eperezma@redhat.com, 
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com, 
	mjrosato@linux.ibm.com, farman@linux.ibm.com, frankja@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 10, 2026 at 5:07=E2=80=AFAM Joshua Daley <jdaley@linux.ibm.com>=
 wrote:
>
> On 3/8/2026 11:06 PM, Stefan Hajnoczi wrote:
> > On Thu, Feb 26, 2026 at 09:43:45PM +0100, Joshua Daley wrote:
> >> The last step of virtscsi_handle_event is to call virtscsi_kick_event,
> >> which calls INIT_WORK on it's own work item. INIT_WORK resets the
> >> work item's data bits to 0.
> >>
> >> If this occurs while the work item is being flushed by
> >> cancel_work_sync, then kernel/workqueue.c/work_offqd_enable triggers a
> >> kernel warning, as it expects the "disable" bit to be 1:
> >>
> >> [   21.450115] workqueue: work disable count underflowed
> >> [   21.450117] WARNING: CPU: 1 PID: 56 at kernel/workqueue.c:4328 enab=
le_work+0x10a/0x120
> >> ...
> >> [   21.450171] Call Trace:
> >> [   21.450173]  [<000003db2e5bdc3e>] enable_work+0x10e/0x120
> >> [   21.450176] ([<000003db2e5bdc3a>] enable_work+0x10a/0x120)
> >> [   21.450178]  [<000003db2e5bdd86>] cancel_work_sync+0x86/0xa0
> >> [   21.450181]  [<000003daae97d9e4>] virtscsi_remove+0xb4/0xd0 [virtio=
_scsi]
> >> [   21.450184]  [<000003db2ef3b5ca>] virtio_dev_remove+0x6a/0xd0
> >> [   21.450186]  [<000003db2ef9106c>] device_release_driver_internal+0x=
1ac/0x260
> >> [   21.450190]  [<000003db2ef8edc8>] bus_remove_device+0xf8/0x190
> >> [   21.450192]  [<000003db2ef88d72>] device_del+0x142/0x340
> >> [   21.450194]  [<000003db2ef88fa0>] device_unregister+0x30/0xa0
> >> [   21.450196]  [<000003db2ef3b2fa>] unregister_virtio_device+0x2a/0x4=
0
> >>
> >> This warning may occur if a controller is detached immediately
> >> following a disk detach.
> >>
> >> Move the INIT_WORK call to prevent this. Don't re-init event list
> >> work items in virtscsi_kick_event, init them only once in
> >> virtscsi_init instead.
> >>
> >> Signed-off-by: Joshua Daley <jdaley@linux.ibm.com>
> >> ---
> >>   drivers/scsi/virtio_scsi.c | 6 +++++-
> >>   1 file changed, 5 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> >> index 0ed8558dad72..173092931df6 100644
> >> --- a/drivers/scsi/virtio_scsi.c
> >> +++ b/drivers/scsi/virtio_scsi.c
> >> @@ -242,7 +242,6 @@ static int virtscsi_kick_event(struct virtio_scsi =
*vscsi,
> >>      struct scatterlist sg;
> >>      unsigned long flags;
> >>
> >> -    INIT_WORK(&event_node->work, virtscsi_handle_event);
> >>      sg_init_one(&sg, event_node->event, sizeof(struct virtio_scsi_eve=
nt));
> >>
> >>      spin_lock_irqsave(&vscsi->event_vq.vq_lock, flags);
> >> @@ -898,6 +897,11 @@ static int virtscsi_init(struct virtio_device *vd=
ev,
> >>      virtscsi_config_set(vdev, cdb_size, VIRTIO_SCSI_CDB_SIZE);
> >>      virtscsi_config_set(vdev, sense_size, VIRTIO_SCSI_SENSE_SIZE);
> >>
> >> +    if (virtio_has_feature(vdev, VIRTIO_SCSI_F_HOTPLUG)) {
> >> +            for (i =3D 0; i < VIRTIO_SCSI_EVENT_LEN; i++)
> >> +                    INIT_WORK(&vscsi->event_list[i].work, virtscsi_ha=
ndle_event);
> >> +    }
> >
> > The eventq should be populated unconditionally so that non-hotplug
> > events are processed even when F_HOTPLUG is not negotiated. For example=
,
> > LUN capacity changes are reported via the VIRTIO_SCSI_T_PARAM_CHANGE
> > event. LUN capacity changes depend on F_CHANGE, not F_HOTPLUG.
> >
> > There is a related bug here: the other if (virtio_has_feature(vdev,
> > VIRTIO_SCSI_F_HOTPLUG)) conditionals in this file need to be revisited
> > so that LUN capacity changes are reported even when F_HOTPLUG is not
> > negotiated. You can test this bug with QEMU's -device
> > virtio-scsi-pci,hotplug=3Doff parameter and the 'block_resize' QEMU
> > monitor command.
> >
> > Do you want to write a patch or do you want me to send a follow-up?
> >
> > Thanks,
> > Stefan
>
> I can write a patch. Thanks for your review.
>
> There are 3 other if (virtio_has_feature(vdev, VIRTIO_SCSI_F_HOTPLUG)) co=
nditionals in this file, for:
>
> 1. virtscsi_kick_event_all() called in virtscsi_probe()
> 2. virtscsi_cancel_event_work() called in virtscsi_remove()
> 3. virtscsi_kick_event_all() called in virtscsi_restore()
>
> Should the eventq be populated truly unconditionally? Then I would just r=
emove the conditions from
> these calls. Or would it be better to just change the conditions to also =
check the other feature:
> if (... || virtio_has_feature(vdev, VIRTIO_SCSI_F_CHANGE))

Yes. The eventq is always present and the memory backing it is already
allocated. I think dropping the conditionals simplifies the driver and
avoids bugs like the F_CHANGE one without introducing downsides.

Stefan
