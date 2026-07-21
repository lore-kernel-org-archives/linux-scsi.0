Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2FAD3BD64E
	for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2026 09:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784625033; cv=pass; b=NujWsztIdIpLBGF3/1kxq4gpWVV0hRcn6+rboYsnVpSxVLScm2KgFYedVN/aB0tumUCbIzIGY25M0DZnIj+YPLVpQgkM/PxM3YKMQnuJv7d8fqzowaJszDdeRNdS6F9lsuKeglEIuLxd4mt/bUVqOrfyaZqtVeJoKK7r+1y6eq0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784625033; c=relaxed/simple;
	bh=FO6kAcx02wAcP7yQ8pr7IPPuxHiVb6JN3TdWIN1pm7Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TSE17nIK8ypi+vaoZO+poA9FqYNHlai9m/EdEhDDx8CFh8dpjG581r0ODG0mnOKMvRhB9kj01eciASb9i1xyhe/PHeAEGRdIgswRo2Xsa8D8rtPZXNHimJpSejV5p0g2xjMuFPQlWf/uSoPDckn90fYJLXR55bhvKrjt9CdvE8c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YsEdYY8t; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=SghhmPfG; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YsEdYY8t";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="SghhmPfG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784625028;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=slsU2Ayz2bb8lrdP9X/oYxa3SWjpysmpRrrI6Ee/Hrg=;
	b=YsEdYY8tev/J9OV8jmVV3s+kLbBhYdBFM9hc7BP2sGpfjP4mB2qMVvxIeR4Fe9iOOR08ON
	sfdLJE8UZwQxNPUfrJtOu9QuJFMOLM+dWZWZp09lpDf9Pah2rmsbYgAFGbiYuQFdg0rR57
	PB8EbBTarF+E1T92fZPLDx6z+3PVGaU=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-245-JCrsgVJOMs26wyHSDb_KMQ-1; Tue, 21 Jul 2026 05:10:23 -0400
X-MC-Unique: JCrsgVJOMs26wyHSDb_KMQ-1
X-Mimecast-MFC-AGG-ID: JCrsgVJOMs26wyHSDb_KMQ_1784625023
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-81e8a76a273so101280947b3.1
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2026 02:10:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784625023; cv=none;
        d=google.com; s=arc-20260327;
        b=iC5sBwoOP7218wUsN6ArPS0lN8peif62hRZMpZK2IAS5oCDycij9OV4jdVXRt4NyL9
         ObHNlMVYeuo10f9Cqud6ct4tZ4ZTAAEAkwNSnW0innNmbn+W0wmL6jbqDJtRV3Ld1zoc
         TextVbfoVdTty+BGJEabF0zOCJjBbTb+FnvruhbBZMPZqY4vtxBaOMRVnoAxepSjCVsi
         Hp7+4Lk0+a9OQb0Td0Ojpk9vH2vKmkQCbWy6CsdSe4PcP5De55i/PUeaW7pKL9YrHU8n
         RlzBcVUipUPZbmlNhxm2fnJMZKa7feREj9vSF9ihygqQRaBaP/mWcSpdUR19SHabu4vy
         h20w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=slsU2Ayz2bb8lrdP9X/oYxa3SWjpysmpRrrI6Ee/Hrg=;
        fh=f8Osge2XQWMpqOfqddcvmVeGIngJVWFKVhiKCQiJrrs=;
        b=guMjv9u72jappe/QObUUWmen1NuGtUZ6zkZeUCxxlIwJV+UyB8UGcipK8xe2CFhsNB
         lSayGKiqQr72n0ybFQ/c3YZBSrPKGgw4yfFy93riHymosERnrzjby9m5pISFjSHfXk0R
         o7FleH8+cAC0SprfW8D7tCC+2fjZhgU0S/cAiBpC3OgLmcmknT2bn5M3/neVY2hfFZbx
         NmEau2OoxS07fA4+WNcFCMsKDSTDLl6AueKopPhi1JM4po/X8G9pVUSrF3K7CoVJjCJ8
         MEATSUW2tTNfMHF7TTWhywignXuIIWlChMeBtBrzndXuDoayM69ynJrjpNQB6lP1bshU
         OoJg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1784625023; x=1785229823; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=slsU2Ayz2bb8lrdP9X/oYxa3SWjpysmpRrrI6Ee/Hrg=;
        b=SghhmPfG8jAd8ULBgjcW72YVXVDOblM9/KjSrbIPVP5g+K5qh6UpZPQlm8jxLAkJLV
         wNYANAwrx1J8gieVuuy6GwuhTwwduobi+lYlltNakR2uMNku6NSBmQfp/UKAXQeaRfFm
         TZDsMSxixhIOh8kXNnTG7fq3XmUmZHsEjYCDQIt6xYn2Q0yJQMCTcBZon3ahV4aPRCwL
         F0gG8aXQnFPPwFCyV9xFqY7SNrGW49OAJ5BcqGUfCDWaWTst7wVLvy0oL0TwAA6yP4qX
         AmBTCG+VicWN+YYOg0ILQ2XThNOpF9+lKaQGfzWW1j4qI/uuZQ+BozwBB39SRS319q84
         EFkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784625023; x=1785229823;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=slsU2Ayz2bb8lrdP9X/oYxa3SWjpysmpRrrI6Ee/Hrg=;
        b=NyRU2MhybeI1jFRagNbATsTVH3tXuqcRd0wZhB7B4aauLhk6eixGMOYGZxhd3aI0RM
         A9IKt9+oPW8GdsiLZb6XjGbK9Fu3whJksffAjgtSVKR4OT4EfATw8eIJOeo+r2OReFqM
         I+mKdHOe/mvM347kdj0/QPBAjU+qBSim9Xh2gJsnPm3GSM1KA8rb2xQTKRedOBIXIcID
         8wQoybt0jLoXLeuBkkBHwLJUztQcaoce00hQtzumYhWgfbZhfZ+8E7aDIarMBdH+Fj8h
         d84YIVqxFgPYWLhWzeGeSegDKdi3RZJQUW+lN7/7YPe93t2DyU3z6uc7LwxhN7WNVqQl
         AkQg==
X-Forwarded-Encrypted: i=1; AHgh+RpzKGmXL3Jn6XakixGcmX/T+OdNJiMGGUL15CpO6yLrx+UJxeG31wd+1vCkzErfF3zX4afLc+KFAZ1a@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5OBrzFxEQrJLQeBXGKsQOcywf6A6JztwNfB43iE3OuCwwWu9a
	PRwHjktDcW5p+VarplHGw3vPsFy/s8m+V7erptLcyeuZx837/cvCecnPhOf4beW2+xd4n5mQ4WM
	0DPEbBW9xoBU+gUCD7FVPknUbKbzuqe2AG1GgGMc3GSfMQYpOBZKgg2l1/IH76/01i6Hw1khM7D
	84uYqzzEiUWDRlqMEWslJ7GtZ3Z9asn0iRdHFP/I2K6EeC/9ne
X-Gm-Gg: AR+sD13MLkktufB5KgMXPbfO6c4V2oZMwfY+8Qx2uHmFZkEO11+aSm7ZgSQlIuXl2uX
	3L/s173PsBkzFmZKkT0qwBYZsJ4dkvhlUdOVOr2CpGw1abCg8OXLfHjeGditb54ggdH9o8zGVSG
	KmwLndRbkATmjvZR2OQa/pNt1NzHquZy+d+vvLzyBl8rwTrc+qxisL9uvuN6+1JxLEX8coe+0W0
	XBaZp4BAxOiLpDquVBVZDUp8ohQ2nW+ZrCEyf3QcS8ZbjZCOusN6Ots6b8=
X-Received: by 2002:a05:690c:dd0:b0:80d:5ddd:1989 with SMTP id 00721157ae682-81ef256b495mr59430007b3.10.1784625022832;
        Tue, 21 Jul 2026 02:10:22 -0700 (PDT)
X-Received: by 2002:a05:690c:dd0:b0:80d:5ddd:1989 with SMTP id
 00721157ae682-81ef256b495mr59429897b3.10.1784625022303; Tue, 21 Jul 2026
 02:10:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260720141040.181946-1-r4o5m6e8o@163.com>
In-Reply-To: <20260720141040.181946-1-r4o5m6e8o@163.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Tue, 21 Jul 2026 11:09:44 +0200
X-Gm-Features: AUfX_mypA7oTxSucKfqGCkqmjhFuRqPhh_bDH2dF50m_ZTQcNCE2RIvdENtQTlY
Message-ID: <CAJaqyWe_nhVOvfA03So_edVO_+1UeHCC6RGnHRQB9dq7CWS4LQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] virtio: SQ/CQ doorbell polling for vhost-scsi
To: "rom.wang" <r4o5m6e8o@163.com>
Cc: mst@redhat.com, jasowangio@gmail.com, stefanha@redhat.com, 
	virtualization@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-scsi@vger.kernel.org, kvm@vger.kernel.org, qemu-devel@nongnu.org, 
	Yufeng Wang <wangyufeng@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 20, 2026 at 4:19=E2=80=AFPM rom.wang <r4o5m6e8o@163.com> wrote:
>
> From: Yufeng Wang <wangyufeng@kylinos.cn>
>
> This RFC proposes a new virtio transport feature, VIRTIO_F_SQCQ_POLL,
> that eliminates VM exits on both submission and completion paths for
> vhost-scsi by using shared-memory doorbells and kernel polling
> threads, following the io_uring SQPOLL model.
>
> This is an early RFC to gather design feedback. The implementation is
> functional and has been tested on arm64 and x86_64. We are not
> requesting merge at this time.
>
>
> Problem
> -------
>
> vhost-scsi uses MMIO writes (Guest -> Host) and MSI-X interrupts
> (Host -> Guest) for notification. Each notification involves a VM exit,
> which becomes a bottleneck at high IOPS:
>
>   - 4K random read, QD32, 8 jobs: 341K IOPS baseline
>   - With ~340K VM exits/second, the exit overhead dominates
>
> Existing mitigations (vhost-net's tx polling, blk-mq iopoll) only
> address one direction or require the submitting task to poll. Neither
> eliminates VM exits on both paths simultaneously.
>
>
> Solution
> --------
>
> Introduce two cache-line-aligned doorbell structures, SQ (Submission
> Queue) and CQ (Completion Queue), placed alongside the standard split
> virtqueue:
>
>   - Guest writes sq->idx instead of MMIO kick; Host poll thread
>     detects the change and processes submissions.
>   - Host writes cq->idx instead of MSI-X interrupt; Guest poll
>     thread detects the change and invokes completion callbacks.
>
> A NEED_WAKEUP protocol (mirroring io_uring's SQ_NEED_WAKEUP) allows
> either side to sleep when idle, with the other side responsible for
> waking it via eventfd.
>
> Feature negotiation via VIRTIO_F_SQCQ_POLL (bit 42) ensures zero
> overhead when not negotiated =E2=80=94 the driver falls back to tradition=
al
> MMIO kick + MSI-X interrupt.
>
>
> Performance
> -----------
>
> Benchmark: fio, 4K random I/O
>
> Test configuration:
>
>   arm64:
>     CPU:   Kunpeng 920 (2.6GHz), 8 vCPUs
>     Disk:  NVMe INTEL SSDPED1K375GA (375GB)
>
>   x86_64:
>     CPU:   Intel Xeon E5-2680 v4 @ 2.40GHz, 8 vCPUs
>     Disk:  NVMe SAMSUNG MZ1LB960HAJQ-000MV (960GB)
>
>   Backend: vhost-scsi with TCM loopback to NVMe device
>   QEMU:    vhost-scsi-pci with VIRTIO_F_SQCQ_POLL negotiated
>
> arm64 results:
>
>   Test              Baseline     SQ/CQ Poll   Change
>   -----------       ----------   ----------   -------
>   randread QD1      22,427       28,289       +26%
>   randread QD32 NJ1 89,910       75,665       -16%
>   randread QD32 NJ4 186,763      379,549      +103%
>   randread QD32 NJ8 199,967      550,633      +175%
>   randwrite QD1     21,912       27,261       +24%
>   randwrite QD32 NJ1 85,349      81,389       -5%
>   randwrite QD32 NJ4 190,443     355,811      +87%
>   randwrite QD32 NJ8 196,552     566,640      +188%
>
> x86_64 results:
>
>   Test              Baseline     SQ/CQ Poll   Change
>   -----------       ----------   ----------   -------
>   randread QD1      8,263        9,552        +16%
>   randread QD32 NJ1 127,412      162,805      +28%
>   randread QD32 NJ4 303,208      375,056      +24%
>   randread QD32 NJ8 341,625      371,193      +9%
>   randwrite QD1     20,773       30,332       +46%
>   randwrite QD32 NJ1 133,316      159,207      +19%
>   randwrite QD32 NJ4 233,373      229,224      -2%
>   randwrite QD32 NJ8 231,442      231,676      +0%
>
> Multi-queue workloads (NJ4/NJ8) see significant improvement on arm64
> (87-188%) and moderate improvement on x86_64 (9-24%). Single-VQ
> high-queue-depth workloads show a minor regression on arm64 due to
> polling overhead vs. VM-exit savings trade-off, while x86_64 shows
> improvement across most configurations (16-46% for QD1, 19-28%
> for QD32-NJ1) due to lower per-VM-exit cost on x86.
>
>
> Why Not vDPA?
> -------------
>
> vhost-vDPA already provides doorbell mmap and polling. A reasonable
> reviewer would ask: why not extend vhost-vDPA instead?
>
> Three reasons:
>
> 1. No vdpa-scsi device exists. The vDPA framework
>    (drivers/vdpa/) currently has hardware devices for net (mlx5,
>    ifcvf, etc.) and software devices for net and blk (vdpa_sim).
>    There is no virtio-scsi vDPA device, hardware or software.
>    Building one means re-implementing vhost-scsi's TCM integration
>    (SCSI CDB processing, ALUA, persistent reservations) under the
>    vDPA device abstraction =E2=80=94 3-5x the work of extending vhost-scs=
i.
>

I don't have a lot of experience in vhost-scsi, but maybe using
generic vdpa device and ~passthrough all those calls to something
similar to vhost-scsi helps? Live migration is still a challenge that
way but you already mention that in Known Limitations, so maybe going
to generic saves a significant amount of work.

https://patchew.org/QEMU/20221215134944.2809-1-longpeng2@huawei.com/

Also, I'm failing to see the advantage of the Send / Completion queues
over a more agressive usage of event_idx, VIRTQ_USED_F_NO_NOTIFY /
VIRTQ_AVAIL_F_NO_INTERRUPT or VIRTIO_F_NOTIFICATION_DATA combined. Can
we explore what does these lacks compared with the send and completion
queues?

> 2. vhost-scsi is a deployed interface. libvirt, QEMU, and
>    OpenStack have vhost-scsi configuration APIs and operational
>    tooling. Switching to vhost-vdpa requires a new backend, user
>    migration, and toolchain updates. SQ/CQ poll as a vhost-scsi
>    feature is fully backward-compatible =E2=80=94 no existing deployments
>    break.
>
> 3. The protocol is transport-agnostic. The SQ/CQ doorbell design
>    (struct vring_sq, struct vring_cq, NEED_WAKEUP handshake) is
>    orthogonal to vhost vs. vDPA. The same UAPI can be consumed by
>    vhost-scsi today and a future vdpa-scsi device. Implementing in
>    vhost-scsi first does not block future vDPA integration.
>
> We acknowledge that vDPA is the long-term direction for virtio
> backends. If this SQ/CQ poll protocol is accepted, it can be ported
> to the vDPA framework; a vdpa-scsi device is independent work.
>
>
> Patch Structure
> ---------------
>
>   Patch 1: UAPI definitions (virtio_config.h, virtio_ring.h,
>            virtio_pci.h) =E2=80=94 shared interface for all components
>   Patch 2: vhost kernel support (vhost.c, vhost.h, scsi.c,
>            vhost.h UAPI, vhost_types.h UAPI) =E2=80=94 Host poll thread
>   Patch 3: virtio guest driver (virtio_ring.c, virtio_sqcq_poll.c,
>            virtio_pci_modern.c, virtio.c, virtio_scsi.c) =E2=80=94 Guest
>            poll thread and submission path
>   Patch 4: QEMU support (virtio-pci.c, vhost.c) =E2=80=94 PCI config
>            forwarding and vhost ioctl bridge
>
> Patches 1-3 apply to the Linux kernel tree. Patch 4 applies to
> the QEMU tree separately.
>
>
> Spec Status
> -----------
>
> A virtio-spec format document has been prepared and will be submitted
> to the OASIS virtio TC as a proposal. This RFC stage seeks design
> feedback before initiating the formal spec process.
>
>
> Known Limitations (Future Work)
> -------------------------------
>
>   - CPU hotplug: no notifier registered; poll thread may be
>     migrated when its CPU goes offline. Planned: kthread_park +
>     dynamic rebind.
>   - Live migration: no explicit stop/flush coordination during
>     migration. Planned: VHOST_BACKEND_F_SUSPEND/RESUME integration.
>   - SMAP overhead: Host uses get_user/put_user for doorbell access.
>     Future optimization: GUP + kmap to map pages into kernel space.
>   - Backpressure: no "slow down" signal from device to driver.
>     Future: CQ throttle flag or avail_event reuse.
>   - Packed ring: not supported; explicitly rejected at feature
>     negotiation. Future: add packed ring doorbell support.
>
>
> RFC Goals
> ---------
>
>   1. Validate the overall design direction (doorbell + polling
>      model, NEED_WAKEUP protocol)
>   2. Get feedback on the feature bit allocation (42) and UAPI
>      structure design
>   3. Understand whether vDPA concern is a blocker or can be
>      addressed with the transport-agnostic argument
>   4. Collect guidance on prioritizing future work items
>      (hotplug, migration, spec process)
>
> We welcome all feedback, especially on:
>   - Whether the NEED_WAKEUP protocol design is sound
>   - Whether the per-device Guest poll thread model (vs per-VQ)
>     is acceptable
>   - Whether feature bit 42 is appropriate or if a different
>     allocation is needed
>   - Any concerns about the SMAP overhead in the Host poll path
>
>
> How to Test
> -----------
>
> Patch usage:
>   Guest Kernel: apply patch 1 (UAPI) + patch 3 (guest driver)
>   Host Kernel:  apply patch 1 (UAPI) + patch 2 (vhost support)
>   QEMU:        apply patch 4 (vhost-scsi bridge)
>
> 1. Set up vhost-scsi target on the host (see:
>    https://wiki.libvirt.org/Vhost-scsi_target.html#Host_Setup)
>    using targetcli to create a TCM loopback device, e.g.:
>    targetcli /backstores/loopback create dev=3D/dev/sda
>    targetcli /vhost create naa.5001405376e34400
>    targetcli /vhost/naa.5001405376e34400/lun create \
>      /backstores/loopback/dev,/dev/sda
>
> 2. Boot VM with vhost-scsi using patched QEMU:
>    qemu-system-aarch64 ... \
>      -device vhost-scsi-pci,wwpn=3Dnaa.5001405376e34400
>
> 3. Verify SQ/CQ poll mode is active on the host:
>    dmesg | grep "vhost-sqcq"
>    # Expected: "vhost-sqcq: vq[N] poll thread bound to cpuN"
>    # and 10s stats: "vhost-sqcq: vq[N] cq=3D... ema_lat=3D... interval=3D=
..."
>
> 4. Verify feature negotiated in guest:
>    dmesg | grep "VIRTIO_F_SQCQ_POLL"
>    # Expected: "VIRTIO_F_SQCQ_POLL negotiated, starting poll thread"
>    # and 10s stats: "io_stats: cq=3D... avg_lat=3D... interval=3D..."
>
> 5. Run fio benchmark (compare with unpatched QEMU/kernel baseline):
>    fio --name=3Drandread --rw=3Drandread --bs=3D4k --iodepth=3D32 \
>        --numjobs=3D4 --runtime=3D60 --time_based --direct=3D1 \
>        --filename=3D/dev/sda
>
> Test scripts (run-sqcq-compare.sh, compare-sqcq-results.sh) are
> available and will be sent as a follow-up to this RFC.
>
>
> Thank you for your time.
>
> ---
> Yufeng Wang (4):
>   common: add UAPI for SQ/CQ doorbell polling
>   vhost: host kernel support for SQ/CQ polling
>   virtio: guest driver support for SQ/CQ polling
>   qemu: add SQ/CQ polling mode support for vhost-scsi
>
> Patch 1 (UAPI, 3 files): +41 -1
> Patch 2 (vhost, 5 files): +794 -20
> Patch 3 (virtio guest, 10 files): +840 -3
> Patch 4 (QEMU, 14 files): +179 -3
>
> Total: 32 files changed, 1854 insertions(+), 27 deletions(-)
>
> --
> 2.34.1
>

