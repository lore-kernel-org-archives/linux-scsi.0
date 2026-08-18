Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D30375AB1
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 18:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787077391; cv=none; b=kXDzPcrNgYQCFrcCXg5f+6ybCCQXtyhXo7PL+VI963gL5WO03+5pkqDP/b9eiScJeIHl8hJhD6Hq7++1d0WeOTahfeU92sKO2mYqrx2Oj7nyYHcbRaWrPGfijb+O7WCdhJWMb6Bpno/EnHE3GsAN6biOJ5SFbMGy6lP6SD2W2mA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787077391; c=relaxed/simple;
	bh=FZmy681osTo3DDHECppFzH/z64eX+iYkKoLCs6eymU4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=srJJO30/HdJSU4GubltEccT7qGUZDtJl/dU7iZ6dhzo08BA8VA8Uw81R+1eJJaulidXmy4q9548jzl5fy+PAkqljzJ/DLXIThhWewx+tpk0tMYdHFwEexy8qskk2E7nuCqcoJmyNY0rMqwqptTU5uNUHHjtV4qnoEIELbpfaijY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RF15Licn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RF15Licn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BCE91F000E9;
	Tue, 18 Aug 2026 18:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787077389;
	bh=uYLM/qdcYSx9EJ6YNjQa7J9N4bANarqWoRYaKC9SqNQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RF15LicnmOktEu5P4fCFw4pO4TddA8jpeXmI1UNWO77zTZSCmwrLEEOdE69nLiydR
	 jpQ8O/Pl+NvvHl8VinKlTmnAKkpyPWAGuUBWaOtkHEvqGNHl8Q11cpk+toqpVELzPI
	 M9VU+fYRb3f5P1XrtaI9iFUtsnIvug/ax5X1AHNWUxf4Y6GQLMtYuI+Uf8yo4tS7sL
	 iI7TJxGPfasNryurAUC4hvmBPPsPk5r1/u9wnJgSuiAbbUYlqJt+SymfPVau9+v7Qj
	 8x8VZZi9yLP3xt10sAVZkzf7dzpcSZUJtDFyTAHnEB0338iM5gKftLe1Jq0Eg3M7dd
	 RHvVrVu4TFtdA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 14/17] mpi3mr: Fix out-of-bounds read in PCIe topology
 change events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chandrakanth Patil" <chandrakanth.patil@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260818231426.58105-15-chandrakanth.patil@broadcom.com>
References: <20260818231426.58105-1-chandrakanth.patil@broadcom.com>
 <20260818231426.58105-15-chandrakanth.patil@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 18 Aug 2026 18:23:09 +0000
Message-Id: <20260818182309.9BCE91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

New issues:
- [High] The newly added bounds check reads `topo_evt->num_entries` directl=
y from a DMA-mapped buffer, and the subsequent loop condition re-reads it, =
creating a Time-Of-Check to Time-Of-Use (TOCTOU) race condition.

Pre-existing issues:
- [High] The bounds check for PCIe and SAS topology change events fails to =
protect the bottom-half event handlers from out-of-bounds reads because ear=
ly returns in the top-half do not prevent the malformed event from being qu=
eued.
- [High] The bounds check uses an untrusted `event_data_length` without ver=
ifying it against the actual physical dimensions of the hardware reply buff=
er, allowing an out-of-bounds read in the top-half handler.
- [High] Missing `dma_rmb()` after polling the phase bit in DMA-mapped repl=
y descriptors, which can lead to processing stale descriptor data on weakly=
 ordered architectures.
--

--- Patch [14]: [PATCH 14/17] mpi3mr: Fix out-of-bounds read in PCIe topolo=
gy change events ---
commit 8553af34c1ff3c0cff0462ca66842979af8cb4d4
Author: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

mpi3mr: Fix out-of-bounds read in PCIe topology change events
   =20
The number of entries in a PCIe topology change event is used to walk
the entry array without being compared against the amount of event
data that was received. Bound the entry count to the received event data
before use.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -2753,11 +2753,26 @@ static void mpi3mr_pcietopochg_evt_th(struct mpi3=
mr_ioc *mrioc,
>  	struct mpi3_event_data_pcie_topology_change_list *topo_evt =3D
>  	    (struct mpi3_event_data_pcie_topology_change_list *)event_reply->ev=
ent_data;
>  	int i;
> -	u16 handle;
> -	u8 reason_code;
> +	u16 handle, avail_len;
> +	u8 reason_code, max_entries;
>  	struct mpi3mr_tgt_dev *tgtdev =3D NULL;
>  	struct mpi3mr_stgt_priv_data *scsi_tgt_priv_data =3D NULL;
> =20
> +	avail_len =3D event_reply->event_data_length * 4;

[Severity: High]
This isn't a bug introduced by this patch, but could this calculation
exceed the actual physical dimensions of the hardware reply buffer?

Because avail_len is derived strictly from the untrusted event_data_length,
a compromised or malicious device could provide a value larger than the
allocated DMA reply buffer (mrioc->reply_sz).

Should we verify event_data_length against mrioc->reply_sz to prevent
the bounds check from being artificially inflated, which would lead to an
out-of-bounds read?=20

The SAS topology handler mpi3mr_sastopochg_evt_th() appears to share this
exact pattern.

> +	if (avail_len < offsetof(struct mpi3_event_data_pcie_topology_change_li=
st, port_entry)) {
> +		ioc_err(mrioc, "PCIe topology event: event data too small (%u bytes)\n=
",
> +			avail_len);
> +		return;
> +	}
> +	max_entries =3D (avail_len -
> +		      offsetof(struct mpi3_event_data_pcie_topology_change_list, port_=
entry)) /
> +		      sizeof(struct mpi3_event_pcie_topo_port_entry);
> +	if (topo_evt->num_entries > max_entries) {
> +		ioc_err(mrioc, "PCIe topology event: num_entries(%d) exceeds max(%d)\n=
",
> +			topo_evt->num_entries, max_entries);
> +		return;
> +	}

[Severity: High]
This is a pre-existing issue, but does this early return actually prevent
the malformed event from being processed by the bottom-half handler?

When mpi3mr_pcietopochg_evt_th() returns early here, the process_evt_bh flag
remains set in mpi3mr_os_handle_events():

drivers/scsi/mpi3mr/mpi3mr_os.c:mpi3mr_os_handle_events() {
    ...
	case MPI3_EVENT_PCIE_TOPOLOGY_CHANGE_LIST:
	{
		process_evt_bh =3D 1;
		mpi3mr_pcietopochg_evt_th(mrioc, event_reply);
		break;
	}
    ...
}

Since process_evt_bh remains 1, the event is queued to the worker thread.
The bottom-half handler mpi3mr_pcietopochg_evt_bh() will then blindly
iterate up to the unvalidated event_data->num_entries, causing an
out-of-bounds read past the end of the allocated fwevt heap buffer.

Would it be safer to clear process_evt_bh or return a status from the
top-half handler to prevent queuing malformed events? The SAS topology
handler mpi3mr_sastopochg_evt_bh() is likely vulnerable to the exact
same incomplete fix flaw.

> =20
>  	for (i =3D 0; i < topo_evt->num_entries; i++) {
>  		handle =3D le16_to_cpu(topo_evt->port_entry[i].attached_dev_handle);
>  		if (!handle)

[Severity: High]
Is this loop vulnerable to a Time-Of-Check to Time-Of-Use (TOCTOU) race
condition?

The newly added bounds check reads topo_evt->num_entries directly from a
DMA-mapped buffer, and this loop condition continually re-evaluates it.=20

Because the loop body contains functions that acquire spinlocks
(e.g., mpi3mr_get_tgtdev_by_handle()), which act as full compiler memory
barriers, the compiler is forced to re-fetch num_entries from DMA memory
on every iteration.

If a malicious device alters num_entries in DMA memory after the initial
max_entries check, could it extend the loop beyond bounds?=20

Should we cache num_entries in a local variable before the bounds check
and use the local variable for the loop condition? The SAS topology handler
mpi3mr_sastopochg_evt_th() appears to have the identical issue.

[Severity: High]
This isn't a bug introduced by this patch, but is a dma_rmb() barrier needed
after polling the phase bit in the DMA-mapped reply descriptors?

Looking at mpi3mr_process_op_reply_q() in drivers/scsi/mpi3mr/mpi3mr_fw.c:

drivers/scsi/mpi3mr/mpi3mr_fw.c:mpi3mr_process_op_reply_q() {
    ...
	if ((le16_to_cpu(reply_desc->reply_flags) &
	    MPI3_REPLY_DESCRIPT_FLAGS_PHASE_MASK) !=3D exp_phase) {
		atomic_dec(&op_reply_q->in_use);
		return 0;
	}

	do {
		if (mrioc->unrecoverable || mrioc->io_admin_reset_sync)
			break;

		req_q_idx =3D le16_to_cpu(reply_desc->request_queue_id) - 1;
    ...
}

The driver polls the hardware DMA ring by checking the reply_flags phase ma=
sk.
Without a subsequent dma_rmb(), weakly ordered CPU architectures (such as
ARM64) can speculatively execute out-of-order reads and fetch the rest of
the descriptor payload (like request_queue_id) before the hardware has
actually committed the updated descriptor.

Could this result in processing corrupted or stale descriptor payloads?
There appears to be a similar polling loop for the admin reply queue in
mpi3mr_process_admin_reply_q() lacking a dma_rmb() before accessing
request_queue_ci.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260818231426.5810=
5-1-chandrakanth.patil@broadcom.com?part=3D14
