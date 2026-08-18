Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B343547044A
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 18:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787076646; cv=none; b=SCJMA9AGtjXOgHkSsAeZNrXOxDo7GPVlFBzx62swP/AKFkfgeoPb1OQPTzxtc5HO51Xij9/Tbi+fMhIwMFLKTlFIeTfGB+qaBjStbUGoHGcutKWGB2oFdc/ueEhNs3wEJCGzEjNkPA9ItCdzf5esG1jUIBVM74uDxCyxOmOoXV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787076646; c=relaxed/simple;
	bh=QkvXCEnM0ZPH79lneOedL5qMa2KMA/j/3RF63P5nE1o=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=o1QFcbRQw2FB9FMlkg+n2HZGEYAfoG9npwttxZr5VUK35gDQa1iiHoRLqSBbyCup8jBjxciy7cLhxH6LOc6TPHMX0vScsVvaCm5u3VUwggu3/597V6nRIUin5xjDYWLsRiuFKNORFneegOV2VqQduXqSE8YPWH/HsxJzS7mKDPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jVOejucc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jVOejucc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CBF71F000E9;
	Tue, 18 Aug 2026 18:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787076645;
	bh=L1J1el93WSWC+N8qfabXMvlgQznI1PYAU1WpF4eHQbo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jVOejuccg4SjK5CKJ1kiBZX9p9lIk9/58zWhRFjNjZKQJU1JL83v8CaSUNErjjRxn
	 0uziXJfF0Tx34vz2yY0XJbCOL8O7PdBvhOrKVNXanzsDQY2MK+nnANNFGNr3fX/ADL
	 SCml7a4/q4WutZWw26bsyM2AfsT96ID2x8Bd4Jw7xTDBNkARTlgBEuZz04pqpZB5hj
	 +oK475nyjrrQ0Sz1waYd+mqoEAqdCAFamYTkKuwWFOzyCCY7Y0XXbIjt1ce8V/R2TR
	 a0PKb9JfkThaDMHgD/8saXSfQwrN+zMNToy3K1pfscyRfFlTnfKMi9MH9KMLG73Cea
	 DNOPNNn6UYx4Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 10/17] mpi3mr: Fix out-of-bounds read in SAS topology
 change events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chandrakanth Patil" <chandrakanth.patil@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260818231426.58105-11-chandrakanth.patil@broadcom.com>
References: <20260818231426.58105-1-chandrakanth.patil@broadcom.com>
 <20260818231426.58105-11-chandrakanth.patil@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 18 Aug 2026 18:10:45 +0000
Message-Id: <20260818181045.7CBF71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing bounds checking in PCIe topology change event handlers.
- [High] Incomplete fix: early return in SAS top-half bypasses bottom-half =
cancellation.
- [High] Event data length is unbounded by host DMA buffer size.
--

--- Patch [10]: [PATCH 10/17] mpi3mr: Fix out-of-bounds read in SAS topolog=
y change events ---
commit bab975c5553e402733c8341f728b4c3f336df543
Author: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

mpi3mr: Fix out-of-bounds read in SAS topology change events

The number of entries in a SAS topology change event is used to walk
the entry array without being compared against the amount of event data
that was received, so the walk can run past the end of the buffer.

Work out how many entries the payload can hold and skip the event if it
claims more.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index b18e7ea873030..1291c60b4d98c 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c

[ ... ]

> @@ -2819,11 +2819,26 @@ static void mpi3mr_sastopochg_evt_th(struct mpi3m=
r_ioc *mrioc,
>  	struct mpi3_event_data_sas_topology_change_list *topo_evt =3D
>  	    (struct mpi3_event_data_sas_topology_change_list *)event_reply->eve=
nt_data;
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
This is a pre-existing issue, but does event_reply->event_data_length
need to be validated against the host DMA buffer size before being used?

Since event_data_length is provided by the firmware, if it exceeds the
hardware DMA reply frame size (mrioc->reply_sz), could this calculation
artificially inflate avail_len and defeat the bounds check?

Also, looking at mpi3mr_os_handle_events(), this unvalidated length
appears to be used for a memory copy:

mpi3mr_os_handle_events() {
    ...
    sz =3D event_reply->event_data_length * 4;
    fwevt =3D mpi3mr_alloc_fwevt(sz);
    ...
    memcpy(fwevt->event_data, event_reply->event_data, sz);
}

Could this result in an out-of-bounds read from the DMA reply frame pool?

> +	if (avail_len < offsetof(struct mpi3_event_data_sas_topology_change_lis=
t, phy_entry)) {
> +		ioc_err(mrioc, "SAS topology event: event data too small (%u bytes)\n",
> +			avail_len);
> +		return;

[Severity: High]
This isn't a bug introduced by this patch, but does returning early here
leave the bottom-half handler scheduled with unvalidated data?

In mpi3mr_os_handle_events(), the bottom-half scheduling flag is set
before the top-half runs:

mpi3mr_os_handle_events() {
    ...
    process_evt_bh =3D 1;
    mpi3mr_sastopochg_evt_th(mrioc, event_reply);
}

If we hit this early return (or the one below), process_evt_bh remains 1.
When mpi3mr_sastopochg_evt_bh() subsequently runs, it will iterate over the
unvalidated event_data->num_entries, potentially reading out-of-bounds.

Should this function clear the bottom-half scheduling flag or return an err=
or
code when validation fails?

> +	}
> +	max_entries =3D (avail_len -
> +		      offsetof(struct mpi3_event_data_sas_topology_change_list, phy_en=
try)) /
> +		      sizeof(struct mpi3_event_sas_topo_phy_entry);
> +	if (topo_evt->num_entries > max_entries) {
> +		ioc_err(mrioc, "SAS topology event: num_entries(%d) exceeds max(%d)\n",
> +			topo_evt->num_entries, max_entries);
> +		return;
> +	}
> +
>  	for (i =3D 0; i < topo_evt->num_entries; i++) {
>  		handle =3D le16_to_cpu(topo_evt->phy_entry[i].attached_dev_handle);
>  		if (!handle)

[Severity: High]
This is a pre-existing issue, but should a similar bounds check be applied
to the PCIe topology change events?

Looking at mpi3mr_pcietopochg_evt_th() and mpi3mr_pcietopochg_evt_bh(),
both handlers blindly iterate over the variable-length port_entry array
using the unvalidated num_entries provided by firmware:

mpi3mr_pcietopochg_evt_th() {
    ...
    for (i =3D 0; i < topo_evt->num_entries; i++) {
        handle =3D le16_to_cpu(topo_evt->port_entry[i].attached_dev_handle);
    ...
}

Could a maliciously large num_entries provided by a device cause an
out-of-bounds memory read here as well?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260818231426.5810=
5-1-chandrakanth.patil@broadcom.com?part=3D10
