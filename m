Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC5E6318EC9
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 18:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787076964; cv=none; b=I6JwKJuQfNL1NDu6yzb08WNeJhKb7MU/Tar9ra3P23EBzAqovFsCVj8XfZToDt8+8zxhPyvA8zk2amfcpPGJfFhsgJ6pDvJq0Nnx1zcQcWHUpcvNRDfedkUEiePicvLSKEcMjAAcsO2F0BT1j5KdUpHT2bLhWwyw/FuMXt9Ipgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787076964; c=relaxed/simple;
	bh=vH8hJmq8LmsplWs98XmziUKyGeU51DiPvX/UOSzXOuk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=n/dEzDs5VZ7wV0mLz+RZznVu9CnOK9B3Exgy3RZ0j/xBKypAIKut+rKpICmooMOuBX1OfwVYRxOmdUU5PbdXqsBOsUomAgNoiqlqtYalJypkIYh5R/dGyg1U5M702kYP9u1XK1+fjy3RO4YZsXvq77YNHcNZ40GJbT5+jjRi0KE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JTe4RsK5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JTe4RsK5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2719A1F000E9;
	Tue, 18 Aug 2026 18:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787076962;
	bh=SZDr14gBmTi0Q5yMuqfpRqtgmNgdCoITYtcTpe11PKA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JTe4RsK5JOEJCKay4I0YcHOd6VS9zKmKR+xpjw9qDbZGbloYY9V3/Lo+v8UHIO26f
	 F95SvWtZtFgo7LuYAsj7+CqCpXmGL3vBDUdxc1WHTdeML5vlPovDLdy5YKLH7tFjGI
	 X2px90yRKFp9qxOS1xnZQZ+3WYWY/f4wowKQix7R4KnSCJqrK7Ug+bjVAqQ4mRZgZL
	 nu7rooSJmSsBtH+sVY0V/032/3FMRXiPtOotu5Yh5yG7S1f30cL/oZ5YElRnKBEbsT
	 G/HkefWg0mH0h140Uk5+Pkvzuk/1fn7icuz6zp07j7GW0xZcQtClqqXhK56e2QgkVe
	 pz4OdKbDSYVPw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 11/17] mpi3mr: Fix out-of-bounds read of event data
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chandrakanth Patil" <chandrakanth.patil@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260818231426.58105-12-chandrakanth.patil@broadcom.com>
References: <20260818231426.58105-1-chandrakanth.patil@broadcom.com>
 <20260818231426.58105-12-chandrakanth.patil@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 18 Aug 2026 18:16:01 +0000
Message-Id: <20260818181602.2719A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

New issues:
- [High] Bottom-half event handlers perform out-of-bounds heap reads on the=
 `fwevt` buffer because they trust unvalidated loop bounds against the newl=
y clamped allocation size.

Pre-existing issues:
- [High] Top-half event handlers perform out-of-bounds DMA reads on the rep=
ly buffer due to missing or flawed bounds checking for variable-length arra=
ys.
- [High] `MPI3_EVENT_DEVICE_INFO_CHANGED` incorrectly falls through to `MPI=
3_EVENT_LOG_DATA`, silently dropping events and bypassing its required bott=
om-half processing.
- [High] Accessing a potentially freed work item during event cleanup via `=
cancel_work_sync`.
--

--- Patch [11]: [PATCH 11/17] mpi3mr: Fix out-of-bounds read of event data =
---
commit 4872e2f7b284da8f062de528f26e6b6482b6a169
Author: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: mpi3mr: Fix out-of-bounds read of event data

The commit clamps the event data length read from the reply to what the
frame can hold. This prevents out-of-bounds reads when caching log data
and when sizing the buffer allocated for the bottom-half event handlers.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index 1291c60b4d98c..68b13c2ad2244 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -3170,7 +3170,12 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mr=
ioc,
>  	case MPI3_EVENT_DEVICE_INFO_CHANGED:
>  	case MPI3_EVENT_LOG_DATA:

[Severity: High]
This is a pre-existing issue, but does MPI3_EVENT_DEVICE_INFO_CHANGED
intentionally fall through to MPI3_EVENT_LOG_DATA without setting
process_evt_bh =3D 1?

Because process_evt_bh is not set, the bottom-half handler is completely
bypassed, leaving mpi3mr_devinfochg_evt_bh() as effectively dead code:

mpi3mr_fwevt_bh() {
    ...
    case MPI3_EVENT_DEVICE_INFO_CHANGED:
    {
        dev_pg0 =3D (struct mpi3_device_page0 *)fwevt->event_data;
        perst_id =3D le16_to_cpu(dev_pg0->persistent_id);
        if (perst_id !=3D MPI3_DEVICE0_PERSISTENTID_INVALID)
            mpi3mr_devinfochg_evt_bh(mrioc, dev_pg0);
    ...
}

Will this cause the driver to fail to process queue depth changes for target
devices?

> -		sz =3D event_reply->event_data_length * 4;
> +		if (mrioc->reply_sz > offsetof(struct mpi3_event_notification_reply, e=
vent_data))
> +			avail_reply_room =3D mrioc->reply_sz -
> +			    offsetof(struct mpi3_event_notification_reply, event_data);
> +		else
> +			avail_reply_room =3D 0;
> +		sz =3D min_t(u16, event_reply->event_data_length * 4, avail_reply_room=
);
>  		mpi3mr_app_save_logdata_th(mrioc,
>  			(char *)event_reply->event_data, sz);
>  		break;

[ ... ]

> @@ -3204,7 +3209,12 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mr=
ioc,
>  		dprint_event_th(mrioc,
>  		    "scheduling bottom half handler for event(0x%02x) - (0x%08x), ack_=
required=3D%d\n",
>  		    evt_type, le32_to_cpu(event_reply->event_context), ack_req);
> -		sz =3D event_reply->event_data_length * 4;
> +		if (mrioc->reply_sz > offsetof(struct mpi3_event_notification_reply, e=
vent_data))
> +			avail_reply_room =3D mrioc->reply_sz -
> +			    offsetof(struct mpi3_event_notification_reply, event_data);
> +		else
> +			avail_reply_room =3D 0;
> +		sz =3D min_t(u16, event_reply->event_data_length * 4, avail_reply_room=
);
>  		fwevt =3D mpi3mr_alloc_fwevt(sz);

[Severity: High]
Does clamping the allocation size here introduce an out-of-bounds heap read=
 in
the bottom-half handlers?

The patch correctly limits the allocation of fwevt to sz, but the payload
copied into it can still contain an unmodified, untrusted num_entries from
the firmware.

When the bottom-half worker executes, won't it iterate up to num_entries,
reading past the end of the strictly clamped fwevt allocation?

mpi3mr_sastopochg_evt_bh() {
    ...
    for (i =3D 0; i < event_data->num_entries; i++) {
        handle =3D le16_to_cpu(event_data->phy_entry[i].attached_dev_handle=
);
    ...
}

Can this lead to an out-of-bounds read on the kernel heap?

[Severity: High]
This is a pre-existing issue, but does mpi3mr_pcietopochg_evt_th() also
lack proper bounds checking before looping over num_entries?

It iterates directly based on the untrusted num_entries:

mpi3mr_pcietopochg_evt_th() {
    ...
    for (i =3D 0; i < topo_evt->num_entries; i++) {
        handle =3D le16_to_cpu(topo_evt->port_entry[i].attached_dev_handle);
    ...
}

Similarly, in mpi3mr_sastopochg_evt_th(), the bounds check relies on
the unclamped event_data_length instead of mrioc->reply_sz:

mpi3mr_sastopochg_evt_th() {
    avail_len =3D event_reply->event_data_length * 4;
    ...
    max_entries =3D (avail_len - offsetof(...)) / sizeof(...);
    if (topo_evt->num_entries > max_entries) return;
}

Will this result in out-of-bounds DMA reads during top-half event processin=
g if
the firmware sends an erroneously large event_data_length?

[Severity: High]
This is a pre-existing issue, but is there a use-after-free risk during
driver cleanup?

In mpi3mr_cleanup_fwevt_list(), current_event is read locklessly and passed=
 to
mpi3mr_cancel_work():

mpi3mr_cleanup_fwevt_list() {
    ...
    if (mrioc->current_event) {
        fwevt =3D mrioc->current_event;
        ...
        mpi3mr_cancel_work(fwevt);
    ...
}

Concurrently, the worker thread can drop the reference count and free fwevt
before clearing mrioc->current_event:

mpi3mr_fwevt_bh() {
    ...
out:
    mpi3mr_fwevt_put(fwevt);
    mrioc->current_event =3D NULL;
}

Could mpi3mr_cleanup_fwevt_list() pass a freed fwevt pointer to
cancel_work_sync(&fwevt->work)?

>  		if (!fwevt) {
>  			dprint_event_th(mrioc,

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260818231426.5810=
5-1-chandrakanth.patil@broadcom.com?part=3D11
