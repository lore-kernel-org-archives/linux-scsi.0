Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075A431F9A6
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 16:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787674214; cv=none; b=il/gDo5XWdVRSyCXOoLEntyJ5jcumpI95xtXt1gZX70/RmxcZhn+WEQ8tGA152OW3TzIWX7Tovf6WH6lfvRsez0lTblTSzM+fLhz2hI2ABOD4EtMktppmyNg9onitKAew1gSx4UeqhDJVplUysAmVmnhhE7zl1nbvro7NZw/its=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787674214; c=relaxed/simple;
	bh=WENoviPKuC3Wur87IrTgfSr14gH9/ylTgPQ1qO/m4hE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=M/WcJ3Atu3V8mxsVXxlI4nxdQyouWtOJPfQgPxfEovcILYVBx2tJqEhei1ajNUbNjCUhVKujnx5Wie3DXR+tXpptvMORPjUBEtQ3tTu7pgx0YhRya+sk06WnZLkQAbCn9M77r2lJeNcaV0S2CzA8KYcZXTh0bOuGr39X4BT5f9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GWrFRdLj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GWrFRdLj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EEE11F000E9;
	Tue, 25 Aug 2026 16:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787674212;
	bh=B2ksJubMoyCg2yUMtYg31KvbX/i1cn+Qo/zK1kTcwhw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GWrFRdLjFeGc+n+zzHCZxYH2E2n3Qy4mK/YRkU7gb5zXUja1b9TZ5eV+D6Do22+nZ
	 nzE6aW2O+dPzI253mTFWxqZesKBULsqTlKuY0ujTN/WKwKrbGMb4n+xHf0OBlfUOwo
	 Q60+/gaZIWElUDbfs5XwYykaNXDmOoO2y1JL3x6UHk0NJIlZeMyztRiNdMzMENSp1f
	 6Q1kcwz30ruyZ1M1raUsV/dFS5MPR+TjVD61Qpei63bZ5HkGhEJneQ7k26BpUci9kB
	 UqEdAdFm9YkRTPGvHOx8Ao2475CTE1bf6gT1UQHi21i5A8RDQ2/WGGOFQLZd+ZlC0k
	 9H0ndR1MztNAQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 14/17] mpi3mr: Fix out-of-bounds read in PCIe
 topology change events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chandrakanth Patil" <chandrakanth.patil@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260825210411.301535-15-chandrakanth.patil@broadcom.com>
References: <20260825210411.301535-1-chandrakanth.patil@broadcom.com>
 <20260825210411.301535-15-chandrakanth.patil@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 25 Aug 2026 16:10:11 +0000
Message-Id: <20260825161012.5EEE11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The bounds check blindly trusts `event_data_length` provided by th=
e hardware without clamping it to the physical size of the DMA reply buffer=
, failing to prevent out-of-bounds reads in the top-half handlers.
- [High] The patch adds bounds checking to the top-half handler, but fails =
to prevent the bottom-half handler from being scheduled and iterating out-o=
f-bounds over the same malformed event data.
- [High] The compiler-inserted bounds checks from the `__counted_by` attrib=
ute bypass the local variable cache, re-introducing a TOCTOU vulnerability.
- [High] Lockless access to `tgtdev->starget` and `starget->hostdata` leads=
 to a Use-After-Free vulnerability.
--

commit 63bdf6fdca71d0debbf3d9facb074c2cc5e861c5
Author: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

mpi3mr: Fix out-of-bounds read in PCIe topology change events

This commit bounds the entry count to the received event data before use to
prevent out-of-bounds reads when processing PCIe topology change events.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index 65a6192cf3960..543e9b8e3fc37 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -2761,12 +2761,28 @@ static void mpi3mr_pcietopochg_evt_th(struct mpi3=
mr_ioc *mrioc,
>  	struct mpi3_event_data_pcie_topology_change_list *topo_evt =3D
>  	    (struct mpi3_event_data_pcie_topology_change_list *)event_reply->ev=
ent_data;
>  	int i;
> -	u16 handle;
> -	u8 reason_code;
> +	u16 handle, avail_len;
> +	u8 reason_code, max_entries, num_entries;
>  	struct mpi3mr_tgt_dev *tgtdev =3D NULL;
>  	struct mpi3mr_stgt_priv_data *scsi_tgt_priv_data =3D NULL;
> =20
> -	for (i =3D 0; i < topo_evt->num_entries; i++) {
> +	avail_len =3D event_reply->event_data_length * 4;

[Severity: High]
This is a pre-existing issue, but the patch provides an incomplete fix. Does
this code blindly trust event_data_length provided by the hardware without
clamping it to the physical size of the DMA reply buffer?

If a malicious or buggy hardware controller sends a PCIe topology change
event with a large event_data_length (e.g., 255) and a large num_entries,
avail_len could become up to 1020, exceeding the actual physical buffer size
(mrioc->reply_sz, typically 128 bytes).

Since avail_len is not clamped, max_entries would become artificially large,
bypassing the loop bounds check. Could this result in an out-of-bounds read
of kernel memory adjacent to the DMA reply buffer?

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
> +	num_entries =3D topo_evt->num_entries;
> +	if (num_entries > max_entries) {
> +		ioc_err(mrioc, "PCIe topology event: num_entries(%d) exceeds max(%d)\n=
",
> +			num_entries, max_entries);
> +		return;

[Severity: High]
This isn't a bug introduced by this patch, but the patch's attempt to fix t=
he
bounds check might be bypassed in the bottom half. If the top-half handler
returns early here, what happens to process_evt_bh which was set to 1 prior
to this call by mpi3mr_os_handle_events()?

If process_evt_bh is not cleared, wouldn't the bottom-half handler
mpi3mr_pcietopochg_evt_bh() still be scheduled and iterate out-of-bounds ov=
er
the same malformed event data?

mpi3mr_pcietopochg_evt_bh():
	for (i =3D 0; i < event_data->num_entries; i++) {

> +	}
> +
> +	for (i =3D 0; i < num_entries; i++) {
>  		handle =3D le16_to_cpu(topo_evt->port_entry[i].attached_dev_handle);

[Severity: High]
This isn't a bug introduced by this patch, but the patch's attempt to fix t=
he
TOCTOU vulnerability might be nullified. Even though num_entries is cached =
in
a local variable, doesn't accessing topo_evt->port_entry[i] trigger a
compiler-inserted bounds check because of the __counted_by(num_entries)
attribute in the structure definition?

Under CONFIG_UBSAN_BOUNDS, this would force the compiler to re-read
topo_evt->num_entries directly from DMA memory to perform the bounds check.

If a malicious device modifies this value post-validation, could it trigger
a bounds check failure and panic the kernel?

>  		if (!handle)
>  			continue;
>  		reason_code =3D topo_evt->port_entry[i].port_status;
>  		scsi_tgt_priv_data =3D  NULL;
>  		tgtdev =3D mpi3mr_get_tgtdev_by_handle(mrioc, handle);
>  		if (tgtdev && tgtdev->starget && tgtdev->starget->hostdata)

[Severity: High]
This is a pre-existing issue that was not addressed, but is it safe to acce=
ss
tgtdev->starget and starget->hostdata locklessly here?

If mpi3mr_target_destroy() executes concurrently, it can take the lock, set
tgtdev->starget =3D NULL, release the lock, and call kfree(starget->hostdat=
a).

Could the top-half handler race with this destruction and lead to a
Use-After-Free when dereferencing scsi_tgt_priv_data immediately afterwards?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260825210411.3015=
35-1-chandrakanth.patil@broadcom.com?part=3D14
