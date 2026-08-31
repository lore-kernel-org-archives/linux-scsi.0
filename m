Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D5D39EF01
	for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2026 12:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788180685; cv=none; b=DRvvCadmCQs/Xf85VL7dGaBi7XudpY70mIcjs0tTKho7lrvVBT037O3PnHK5TgmfH1M3V/bir/0H5NvcAvK8ao148sWR4XmIbjXDn4If3scc6iqr2rz8oMC9sIYfHypr+2QSzx4p67r1f2Ocfupli7Hm8ER18UVuwvnszFE/2WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788180685; c=relaxed/simple;
	bh=dzZIsimQc0tQPsRBHVfNr0NOSiqE+1b9cyl2SzpQVX4=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bqsTpunWyWsx1hEst3uvYIa/EDer+/yY5IX3eV8Tz2qaFuXvscQ5d2BzuEK7cJsSSKxMcF8Hkg5yC5ichDjLy62luCrhikizQVuTXLVZpU7dnCdllZmKtOKlzplB+oQlOi9CRlKIwuTRBNLwhYeVKnw3qmLKQMSoG+gAo8pwWpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J99m0Ec6; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ph9MQTxX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J99m0Ec6";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ph9MQTxX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788180681;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eOwGf99b9HdXOOQWIAYuhdwCXQQfHoTRhM08AMA1p9o=;
	b=J99m0Ec6S/qXNqYDP+7XAPikp9eblG1ut4ZRerOJJ9xDthbUWzoUSrhkbgU/tJMd+XvbAk
	qVhfbvQqhBYfnS4b8KcNyqBgEIkACIT1lozJsaaVVKFudhPQ5bSAObzMTu+TqTB3IFmKN9
	KlZXo1wr20OilLWyUcLKefsleINM8vY=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-694-BIRhmvuJMV6bwYe4RGFjSg-1; Mon, 31 Aug 2026 08:51:20 -0400
X-MC-Unique: BIRhmvuJMV6bwYe4RGFjSg-1
X-Mimecast-MFC-AGG-ID: BIRhmvuJMV6bwYe4RGFjSg_1788180679
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-39b1a8b8bb1so18110081fa.2
        for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2026 05:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1788180679; x=1788785479; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:to:from:subject:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=eOwGf99b9HdXOOQWIAYuhdwCXQQfHoTRhM08AMA1p9o=;
        b=Ph9MQTxXnt0S54m6mNVA+TY3/+0TLzpbVAbZPT58wiLdWoyNRXBUwFBe5VEU7hc8HT
         Dr21F93Ehx/Zg8GucHm23/Z/o0TTv5mCt8ousc1ZvaHSFIoOqQIUqhhjeLnJhFEBgklJ
         TTVvGk7sxUdi0l6ItvGcaKaVQQNTNGEfV9pa++GT08OD/TaC0VZ4KrQw8HzOBTS6la4c
         Oxvq2XCEGit9KlkPEd7addfJhaYTAF70rdDY3ElR1fdd5zqmlYV8EKa1CWn3vitxM9XD
         DljOBMtHOTJ8stv0WtIsx1j9GgVUHLAeV6ZSICc7Y7YmZ0WPap52c1MUjEOSF6FldQGC
         wuYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788180679; x=1788785479;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eOwGf99b9HdXOOQWIAYuhdwCXQQfHoTRhM08AMA1p9o=;
        b=FZsPcSanFgKEaKDPFEKVswpPrTbcm1gmxf4tB2sqtA2qYw1Zc06+ZEC5CS8OH5hHnu
         WrjXEuzd+zm+HR5FcK78T/MYvpTLdNt2OCnboErXJAghx2CfEBXeGs2GJiCNCxWWQV2f
         DAc6IYkQOPqwiUS2qcyqBKSUpXoLCH1M8dHoXRpWYWDrhMqXK4Q9jS7gOQ4rB1GQwoE6
         WxkvDeoncPbT7BFJRv4NndR9Kx5NTlz6KOfKZxc1qxhHVyE657mdaM5j06YYQxPJ9XrK
         w7icZPVMpglIWwuhZHJD3wmZZ7KBlDshj3NSpYK4D49CFYkzQFTlx+xG9Go/IkCANJdp
         ixaA==
X-Gm-Message-State: AFuF++lnb0kS1Me9xnjqRE9s8Z2vV0q+fa5fSSiFZ3XLkMITZcG4hon1
	PDjpsy0/h9LjTDPK8IvwxY5jgHl22W5ShwKRnt6SrxK3obSzYOVPWP2iLWuxQshsoOWI0hrnokq
	Rqv1rB1LXUtGMTx3Z+wejqbNUx2VI5JnrzeJubXLMlBKlNUOQ9Z5ksC7WqPMejvv84eE68B/t69
	oRm3VNfr393Rfn3uxRmpB6z45+zlEpzGwwYNbZVzNA6LQuWUo=
X-Gm-Gg: AYBFou0O0kRFMfA3M/gjPApCi35SsnTmwL+36DrFBnAmfOInZoNmDgvIgfUlYsZGBUq
	ueveyNBi8SynzrUA2EDNpLnLlp5M+HxWcaAchSDZNZS4I4AgzgvBLPQLbWvizY/lpCXBG2Ra85z
	UwRCo2oNkTU6jMPk1tjGGT5LcVW2SEGbfh/E/XJEE2WbdyPphw9SeNJERr9n/E2AvIddfynft0d
	lqovdzXxfDY2+Vj9yAvaEuh+52AHBiruruZOdouU+wzOYsxdf+ITZirlAHtWFPbtOmNQL+RAkPP
	+vVRLXPVEW8VXb6N2VMds58fo3wOtBCOYkU0YOZVaiRlcdjXfRvUhXZJfbnD0dgCRtmCSpL45rC
	5myPxM7rj99ix0mDyZaJ0N2wuC6AFQYCN0X2Q
X-Received: by 2002:a05:6512:244f:b0:5b4:9d34:eb7a with SMTP id 2adb3069b0e04-5b5e68ec8ddmr6913284e87.12.1788180678542;
        Mon, 31 Aug 2026 05:51:18 -0700 (PDT)
X-Received: by 2002:a05:6512:244f:b0:5b4:9d34:eb7a with SMTP id 2adb3069b0e04-5b5e68ec8ddmr6913264e87.12.1788180678021;
        Mon, 31 Aug 2026 05:51:18 -0700 (PDT)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c65:2440:d8c:dbb1:97f1:a6e6:766b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b5e89c5c82sm2245264e87.4.2026.08.31.05.51.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 05:51:13 -0700 (PDT)
Message-ID: <13b7b8a4c0d7a3a80df295f312519d3a5cce87e6.camel@redhat.com>
Subject: Re: [PATCH] scsi: mpi3mr: fix use-after-free on tgt_dev->starget
 during target device refresh/update
From: Laurence Oberman <loberman@redhat.com>
To: linux-scsi@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com, 
	martin.petersen@oracle.com, chandrakanth.patil@broadcom.com
Date: Mon, 31 Aug 2026 08:51:11 -0400
In-Reply-To: <20260831120047.14690-1-loberman@redhat.com>
References: <20260831120047.14690-1-loberman@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2026-08-31 at 07:59 -0400, Laurence Oberman wrote:
> mpi3mr_refresh_tgtdevs() and mpi3mr_devinfochg_evt_bh() read
> tgt_dev->starget and immediately pass it to starget_for_each_device()
> without holding mrioc->tgtdev_lock. Every writer of this field --
> mpi3mr_target_alloc(), mpi3mr_target_destroy(),
> mpi3mr_slave_destroy()
> and mpi3mr_sdev_init() -- correctly serializes access under
> tgtdev_lock, but these two read sites do not, which leaves a
> check-then-use window against the SCSI core's target teardown path
> (scsi_remove_target(), invoked e.g. via a concurrent host reset,
> sysfs "delete", or SCSI EH device offlining running independently of
> the fwevt workqueue).
>=20
> Sequence observed on production hardware, triggered on the
> mpi3mr0_fwevt_wrkr workqueue during a SAS topology change shortly
> after a controller reset:
>=20
> =C2=A0 BUG: kernel NULL pointer dereference, address: 0000000000000058
> =C2=A0 RIP: scsi_is_host_device+0x7/0x20
> =C2=A0 Call Trace:
> =C2=A0=C2=A0 starget_for_each_device+0x34/0x100
> =C2=A0=C2=A0 mpi3mr_refresh_tgtdevs+0x152/0x1d0 [mpi3mr]
> =C2=A0=C2=A0 mpi3mr_fwevt_bh+0x514/0x6c0 [mpi3mr]
> =C2=A0=C2=A0 mpi3mr_fwevt_worker+0x1a/0x50 [mpi3mr]
> =C2=A0=C2=A0 process_one_work+0x194/0x380
> =C2=A0=C2=A0 worker_thread+0x2fe/0x410
>=20
> mpi3mr_refresh_tgtdevs() reads tgt_dev->starget as non-NULL, but by
> the time starget_for_each_device() dereferences it, a concurrent
> mpi3mr_target_destroy() has already cleared tgt_dev->starget under
> tgtdev_lock and the SCSI/device core has freed the underlying
> scsi_target (and its embedded struct device). The stale pointer is
> then walked by dev_to_shost() -> scsi_is_host_device(), producing the
> NULL/garbage dereference above.
>=20
> Fix this by taking mrioc->tgtdev_lock around every read of
> tgt_dev->starget, matching the existing writer-side discipline. Since
> starget_for_each_device() and mpi3mr_update_sdev() can end up doing
> non-atomic work (e.g. queue_limits_commit_update()), the lock cannot
> be held across the whole call, so instead pin the target's device
> with get_device() while holding the lock, drop the lock, then run
> starget_for_each_device() against the pinned reference and
> put_device() afterwards. This closes the TOCTOU window instead of
> merely narrowing it.
>=20
> The same unlocked read-and-dereference pattern also exists earlier in
> mpi3mr_refresh_tgtdevs()'s first removal-scan loop
> (tgt_dev->starget->hostdata); fix it the same way by holding
> tgtdev_lock across that check, which is cheap since it only touches
> plain struct fields.
>=20
> Assisted-by: Claude:Sonnet5 [Claude Code]
> Signed-off-by: Laurence Oberman <loberman@redhat.com>
> ---
> =C2=A0drivers/scsi/mpi3mr/mpi3mr_os.c | 45 +++++++++++++++++++++++++-----=
-
> --
> =C2=A01 file changed, 35 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c
> b/drivers/scsi/mpi3mr/mpi3mr_os.c
> index 402d1f35d214..922b28c3fe12 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -1094,10 +1094,13 @@ static void mpi3mr_refresh_tgtdevs(struct
> mpi3mr_ioc *mrioc)
> =C2=A0{
> =C2=A0	struct mpi3mr_tgt_dev *tgtdev, *tgtdev_next;
> =C2=A0	struct mpi3mr_stgt_priv_data *tgt_priv;
> +	struct scsi_target *starget;
> +	unsigned long flags;
> =C2=A0
> =C2=A0	dprint_reset(mrioc, "refresh target devices: check for
> removals\n");
> =C2=A0	list_for_each_entry_safe(tgtdev, tgtdev_next, &mrioc-
> >tgtdev_list,
> =C2=A0	=C2=A0=C2=A0=C2=A0 list) {
> +		spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
> =C2=A0		if (((tgtdev->dev_handle =3D=3D
> MPI3MR_INVALID_DEV_HANDLE) ||
> =C2=A0		=C2=A0=C2=A0=C2=A0=C2=A0 tgtdev->is_hidden) &&
> =C2=A0		=C2=A0=C2=A0=C2=A0=C2=A0 tgtdev->host_exposed && tgtdev->starget =
&&
> @@ -1106,6 +1109,7 @@ static void mpi3mr_refresh_tgtdevs(struct
> mpi3mr_ioc *mrioc)
> =C2=A0			tgt_priv->dev_removed =3D 1;
> =C2=A0			atomic_set(&tgt_priv->block_io, 0);
> =C2=A0		}
> +		spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
> =C2=A0	}
> =C2=A0
> =C2=A0	list_for_each_entry_safe(tgtdev, tgtdev_next, &mrioc-
> >tgtdev_list,
> @@ -1127,15 +1131,25 @@ static void mpi3mr_refresh_tgtdevs(struct
> mpi3mr_ioc *mrioc)
> =C2=A0	tgtdev =3D NULL;
> =C2=A0	list_for_each_entry(tgtdev, &mrioc->tgtdev_list, list) {
> =C2=A0		if ((tgtdev->dev_handle !=3D
> MPI3MR_INVALID_DEV_HANDLE) &&
> -		=C2=A0=C2=A0=C2=A0 !tgtdev->is_hidden) {
> -			if (!tgtdev->host_exposed)
> +				!tgtdev->is_hidden) {
> +			if (!tgtdev->host_exposed) {
> =C2=A0				mpi3mr_report_tgtdev_to_host(mrioc,
> -							=C2=A0=C2=A0=C2=A0=C2=A0 tgtdev-
> >perst_id);
> -			else if (tgtdev->starget)
> -				starget_for_each_device(tgtdev-
> >starget,
> -							(void
> *)tgtdev, mpi3mr_update_sdev);
> -	}
> +				=C2=A0=C2=A0=C2=A0=C2=A0 tgtdev->perst_id);
> +				continue;
> +			}
> +			spin_lock_irqsave(&mrioc->tgtdev_lock,
> flags);
> +			starget =3D tgtdev->starget;
> +			if (starget)
> +				get_device(&starget->dev);
> +			spin_unlock_irqrestore(&mrioc->tgtdev_lock,
> flags);
> +			if (starget) {
> +				starget_for_each_device(starget,
> (void *)tgtdev,
> +							mpi3mr_updat
> e_sdev);
> +				put_device(&starget->dev);
> +			}
> +		}
> =C2=A0	}
> +	dprint_reset(mrioc, "refresh target devices: done\n");
> =C2=A0}
> =C2=A0
> =C2=A0/**
> @@ -1515,6 +1529,8 @@ static void mpi3mr_devinfochg_evt_bh(struct
> mpi3mr_ioc *mrioc,
> =C2=A0	struct mpi3_device_page0 *dev_pg0)
> =C2=A0{
> =C2=A0	struct mpi3mr_tgt_dev *tgtdev =3D NULL;
> +	struct scsi_target *starget;
> +	unsigned long flags;
> =C2=A0	u16 dev_handle =3D 0, perst_id =3D 0;
> =C2=A0
> =C2=A0	perst_id =3D le16_to_cpu(dev_pg0->persistent_id);
> @@ -1535,9 +1551,18 @@ static void mpi3mr_devinfochg_evt_bh(struct
> mpi3mr_ioc *mrioc,
> =C2=A0		mpi3mr_report_tgtdev_to_host(mrioc, perst_id);
> =C2=A0	if (tgtdev->is_hidden && tgtdev->host_exposed)
> =C2=A0		mpi3mr_remove_tgtdev_from_host(mrioc, tgtdev);
> -	if (!tgtdev->is_hidden && tgtdev->host_exposed && tgtdev-
> >starget)
> -		starget_for_each_device(tgtdev->starget, (void
> *)tgtdev,
> -		=C2=A0=C2=A0=C2=A0 mpi3mr_update_sdev);
> +	if (!tgtdev->is_hidden && tgtdev->host_exposed) {
> +		spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
> +		starget =3D tgtdev->starget;
> +		if (starget)
> +			get_device(&starget->dev);
> +		spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
> +		if (starget) {
> +			starget_for_each_device(starget, (void
> *)tgtdev,
> +						mpi3mr_update_sdev);
> +			put_device(&starget->dev);
> +		}
> +	}
> =C2=A0out:
> =C2=A0	if (tgtdev)
> =C2=A0		mpi3mr_tgtdev_put(tgtdev);
>=20
>=20
> Re:

sashiko found Pre-existing issues:
- [High] The patch fixes the unprotected check-then-use window for
`tgtdev->starget` in `mpi3mr_refresh_tgtdevs()` and
`mpi3mr_devinfochg_evt_bh()`, but identical vulnerable patterns remain
in other functions like `mpi3mr_remove_tgtdev_from_host()`,
`mpi3mr_update_tgtdev()`, and various event/BSG handlers.
- [High] Unprotected traversal of `mrioc->tgtdev_list` without holding
`tgtdev_lock` can lead to list corruption and crashes due to concurrent
insertions.
- [High] An AB-BA lock inversion exists between `mrioc->tgtdev_lock`
and the SCSI host lock (`shost->host_lock`).

The sashiko reviews were all for pre-existing issues and won't be fixed
in the specific patch submission here.

I will make an attempt to deal with those in a seperate submission as
already agreed with Chandrekanth=20

Thanks
Laurence

