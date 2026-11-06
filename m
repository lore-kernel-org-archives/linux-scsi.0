Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793928347;
	b=tbqLVPIASJOnozJl6GU/kPWOsZ+iLgWDbHsX5L0/RtrjVMkS+416aYACETo1bwIc2drE
	 kXekPzlQw5ckZ4R3yZedo1jX8n2uRDCo+gyIUlB/FHh7MLKlRTSut5reakD9KkI7kVIsz
	 D/ozQYNH1rgQOU0Oj0b3zQ6Caz0WpZ8qpAmXlv2m7h07UX2JTaQ3EW5aqWyz1dzQOKLMa
	 SXrcPiARTXzGHDJ8TFs4GO+qGigFdFS2N1CaTiApkyv5hBzl11p3314P6mHYHtV/+pGKv
	 j9Nzu0jH9FmYNXzg5cGPLbWAZLxgyiPIZ+i3D9w90/Z+6HnIC5YgJqjGc17yOl/GcUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793928347;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=kwBYRx4ESGf2HI6w8eM3SpQHO7+okGsmweyzgVaadno=;
	b=OIW4b6/X6+/SCFfeb/HZdAoilYYtMY6QnOXLIHmMt5bY4eW/FYWOssp+LrrP5n79CpL+
	 MEXziEP4s72qROH/D6rTxEU6/dYVQVqcnXKpHnPvw2Cz8Pv7eLD5OOC0ATYz037B1RgDE
	 7rz2NE4K0cc1uzoqYtugoKHmchpkSrdEGB48eg7GF4fWytd39N3olQ/9AcZ8GoBdMXxsq
	 04O1/OX2pnYhhfpNTFEecXXcVTkB5NL4uZtWIQkHTIifi9u6HylGDpn678whlVAQzuk7u
	 0Apv5WjwYbjYipxmINv38zoBrAHjFOHXca0zuLpzEN/6Dvv1lON9K7Ux9FHtf690Yog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FVotNU14;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F4A606A31B
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 01:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FVotNU14
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19C821F0089F;
	Fri,  6 Nov 2026 01:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793928346;
	bh=kwBYRx4ESGf2HI6w8eM3SpQHO7+okGsmweyzgVaadno=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=FVotNU14eCdwRuIhWWQrCPO1eYkcLjmkQTVHNq5cgP0xs5z6nJEvRSUc9QNR3ZYai
	 S6n2nSu28apLNMFIiV4Z2m+LfX5stlyp6hUP7UlXTYD55KddwqySon5V7Jl16+W2Wk
	 /t0FZHe5+/NoVki+spYJ5sKYFVdSERjDQrOoJHFDazkrVxnac8ziwVjVUpmPv0ZPQD
	 iwMJjA6sqF7JHPJPESf8MlSYW3m5RlWKLLGm7kqKkfP7bgwUsntbezmmlyaYPCWfcX
	 8Zcm7g4dB74OjDnMuYwqA/P7YzIJuh+wRXhuUH97kSKU+fT7h8u9RkTFuSMD53ZQQA
	 BJW5KgGubLiHg==
Message-ID: <sashiko-outbox-200513@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 04/37] scsi: mpt3sas: Fix locking and bounds checks on
 host_trace_buffer sysfs files
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shivasharan S" <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
In-Reply-To: <1793925772-1303-5-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1793925772-1303-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1793925772-1303-5-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 01:25:45 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] scsi: mpt3sas: deadlock acquiring ctl_cmds.mutex in mpt3sas_proces=
s_trigger_data()
- [Medium] scsi: mpt3sas: unlocked ioc->htb_rel update in mpt3sas_process_t=
rigger_data()
- [Medium] scsi: mpt3sas: stale ring_buffer_offset on buffer reuse in _ctl_=
diag_register_2()
- [Medium] scsi: mpt3sas: missing ctl_cmds.mutex lock in host_trace_buffer_=
enable_show()
--

commit 020572df8e7bd5fcadc7efc81cf505f0aa5bf7b5
Author: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

scsi: mpt3sas: Fix locking and bounds checks on host_trace_buffer sysfs fil=
es

This commit serializes the host_trace_buffer sysfs handlers and diagnostic
trigger release path on ctl_cmds.mutex, and clamps the trace buffer size and
read bounds to the allocated DMA buffer size.

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mp=
t3sas_ctl.c
> index f254e9984da80..d696cb12047ce 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> @@ -1791,6 +1791,10 @@ _ctl_diag_register_2(struct MPT3SAS_ADAPTER *ioc,
>  	if (request_data =3D=3D NULL) {
>  		ioc->diag_buffer_sz[buffer_type] =3D 0;
>  		ioc->diag_buffer_dma[buffer_type] =3D 0;
> +		if (buffer_type =3D=3D MPI2_DIAG_BUF_TYPE_TRACE) {
> +			ioc->ring_buffer_sz =3D 0;
> +			ioc->ring_buffer_offset =3D 0;
> +		}
>  		request_data =3D dma_alloc_coherent(&ioc->pdev->dev,
>  				request_data_sz, &request_data_dma, GFP_KERNEL);
>  		if (request_data =3D=3D NULL) {

[Severity: Medium]
What happens when a previously allocated trace buffer is released and then
re-posted with the same size, such as through host_trace_buffer_enable_stor=
e()
or the MPT3DIAGREGISTER ioctl?

In _ctl_diag_register_2(), when ioc->diag_buffer[MPI2_DIAG_BUF_TYPE_TRACE] =
is
already allocated and request_data_sz matches
ioc->diag_buffer_sz[MPI2_DIAG_BUF_TYPE_TRACE]:

	request_data =3D ioc->diag_buffer[buffer_type];
	request_data_sz =3D diag_register->requested_buffer_size;
	...
	if (request_data) {
		request_data_dma =3D ioc->diag_buffer_dma[buffer_type];
		if (request_data_sz !=3D ioc->diag_buffer_sz[buffer_type]) {
			dma_free_coherent(&ioc->pdev->dev,
					ioc->diag_buffer_sz[buffer_type],
					request_data, request_data_dma);
			request_data =3D NULL;
		}
	}

request_data remains non-NULL and the existing DMA buffer is reused without
entering the request_data =3D=3D NULL block. Would that leave ioc->ring_buf=
fer_sz
and ioc->ring_buffer_offset with stale values from the previous trace captu=
re
when reading host_trace_buffer?

[ ... ]

> @@ -3755,13 +3782,17 @@ host_trace_buffer_enable_store(struct device *cde=
v,
>  	struct mpt3_diag_register diag_register;
>  	u8 issue_reset =3D 0;
> =20
> +	if (sscanf(buf, "%9s", str) !=3D 1)
> +		return -EINVAL;
> +
> +	mutex_lock(&ioc->ctl_cmds.mutex);

[Severity: Medium]
The commit message notes that this change serializes the host_trace_buffer*
sysfs handlers on ctl_cmds.mutex, and host_trace_buffer_enable_store() now
acquires ioc->ctl_cmds.mutex before modifying
ioc->diag_buffer[MPI2_DIAG_BUF_TYPE_TRACE] and
ioc->diag_buffer_status[MPI2_DIAG_BUF_TYPE_TRACE].

However, host_trace_buffer_enable_show() in drivers/scsi/mpt3sas/mpt3sas_ct=
l.c
still reads those fields without holding ioc->ctl_cmds.mutex:

	if ((!ioc->diag_buffer[MPI2_DIAG_BUF_TYPE_TRACE]) ||
	   ((ioc->diag_buffer_status[MPI2_DIAG_BUF_TYPE_TRACE] &
	    MPT3_DIAG_BUFFER_IS_REGISTERED) =3D=3D 0))
		return snprintf(buf, PAGE_SIZE, "off\n");

Since host_trace_buffer_enable_store() clears
ioc->diag_buffer_status[MPI2_DIAG_BUF_TYPE_TRACE] =3D 0 and then sleeps in
_ctl_diag_register_2() waiting for firmware command completion before setti=
ng
MPT3_DIAG_BUFFER_IS_REGISTERED, can a concurrent read of
host_trace_buffer_enable race with post/release operations and observe
transient state? Should host_trace_buffer_enable_show() also acquire
ioc->ctl_cmds.mutex?

[ ... ]

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c b/drivers/scsi/m=
pt3sas/mpt3sas_trigger_diag.c
> index d9b7d0ee25b0f..bda404a3ff3db 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c
> @@ -118,6 +118,7 @@ mpt3sas_process_trigger_data(struct MPT3SAS_ADAPTER *=
ioc,
>  	dTriggerDiagPrintk(ioc, ioc_info(ioc, "%s: enter\n", __func__));
> =20
>  	/* release the diag buffer trace */
> +	mutex_lock(&ioc->ctl_cmds.mutex);
>  	if ((ioc->diag_buffer_status[MPI2_DIAG_BUF_TYPE_TRACE] &
>  	    MPT3_DIAG_BUFFER_IS_RELEASED) =3D=3D 0) {
>  		/*

[Severity: High]
Can acquiring ioc->ctl_cmds.mutex in mpt3sas_process_trigger_data() cause an
ABBA deadlock with controller reset paths?

mpt3sas_process_trigger_data() runs on the ioc->firmware_event_thread
workqueue via:

  _firmware_event_work() -> _mpt3sas_fw_work() -> mpt3sas_process_trigger_d=
ata()

Taking ioc->ctl_cmds.mutex here establishes the lock order:

  (&fw_event->work) -> (&ioc->ctl_cmds.mutex)

Conversely, several paths in drivers/scsi/mpt3sas/mpt3sas_ctl.c hold
ioc->ctl_cmds.mutex while calling mpt3sas_base_hard_reset_handler(), includ=
ing
_ctl_do_reset(), _ctl_do_mpt_command(), _ctl_diag_register_2() (called from
_ctl_diag_register() and host_trace_buffer_enable_store()),
_ctl_diag_release(), _ctl_diag_read_buffer(), and
mpt3sas_send_mctp_passthru_req(). In particular, _ctl_do_mpt_command() queu=
es
a MPT3SAS_PROCESS_TRIGGER_DIAG work item via mpt3sas_trigger_master() and c=
an
immediately jump to issue_host_reset while still holding ioc->ctl_cmds.mute=
x:

	mpt3sas_trigger_master(ioc, MASTER_TRIGGER_TASK_MANAGMENT);
	...
	if (!(ioc->ctl_cmds.status & MPT3_CMD_COMPLETE)) {
		mpt3sas_check_cmd_timeout(ioc,
		    ioc->ctl_cmds.status, mpi_request,
		    karg.data_sge_offset, issue_reset);
		goto issue_host_reset;
	}

Inside mpt3sas_base_hard_reset_handler(), the reset path flushes the firmwa=
re
event queue while ioc->ctl_cmds.mutex is held:

  mpt3sas_base_hard_reset_handler()
    -> _base_clear_outstanding_commands()
      -> mpt3sas_scsih_clear_outstanding_scsi_tm_commands()
        -> _scsih_fw_event_cleanup_queue()
          -> cancel_work_sync(&fw_event->work)

This establishes the reverse lock order:

  (&ioc->ctl_cmds.mutex) -> (&fw_event->work)

If a MPT3SAS_PROCESS_TRIGGER_DIAG work item has started executing
_firmware_event_work() when _scsih_fw_event_cleanup_queue() dequeues it and
calls cancel_work_sync(&fw_event->work), won't _scsih_fw_event_cleanup_queu=
e()
block waiting for fw_event->work to finish while
mpt3sas_process_trigger_data() blocks waiting for ioc->ctl_cmds.mutex?

> @@ -131,6 +132,7 @@ mpt3sas_process_trigger_data(struct MPT3SAS_ADAPTER *=
ioc,
>  		mpt3sas_send_diag_release(ioc, MPI2_DIAG_BUF_TYPE_TRACE,
>  		    &issue_reset);
>  	}
> +	mutex_unlock(&ioc->ctl_cmds.mutex);
> =20
>  	ioc->htb_rel.buffer_rel_condition =3D MPT3_DIAG_BUFFER_REL_TRIGGER;
>  	if (event_data) {

[Severity: Medium]
Should the update to ioc->htb_rel also be protected by ioc->ctl_cmds.mutex?

Here in mpt3sas_process_trigger_data(), ioc->ctl_cmds.mutex is unlocked rig=
ht
after mpt3sas_send_diag_release() sets MPT3_DIAG_BUFFER_IS_RELEASED, before
ioc->htb_rel.buffer_rel_condition, ioc->htb_rel.trigger_type, and
ioc->htb_rel.trigger_info_dwords are populated.

Other readers and writers of ioc->htb_rel in drivers/scsi/mpt3sas/mpt3sas_c=
tl.c
access it under ioc->ctl_cmds.mutex: _ctl_addnl_diag_query() checks
MPT3_DIAG_BUFFER_IS_RELEASED and copies ioc->htb_rel to userspace,
_ctl_diag_register_2() zeroes ioc->htb_rel with memset(), and
host_trace_buffer_enable_store() sets
ioc->htb_rel.buffer_rel_condition =3D MPT3_DIAG_BUFFER_REL_SYSFS.

Because the lock is dropped before ioc->htb_rel is populated, could a
concurrent _ctl_addnl_diag_query() ioctl observe MPT3_DIAG_BUFFER_IS_RELEAS=
ED
and copy incomplete or stale ioc->htb_rel data, or could a concurrent buffer
re-registration in _ctl_diag_register_2() zero ioc->htb_rel only for
mpt3sas_process_trigger_data() to overwrite it immediately afterward?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1793925772-1303-1-g=
it-send-email-shivasharan.srikanteshwara@broadcom.com?part=3D4
