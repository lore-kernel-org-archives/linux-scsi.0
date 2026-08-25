Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7317A1632E7
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 17:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787678137; cv=none; b=PkdRSPkIJBDNcVuCLT9o07Y92PF9HVaFsWZrfneQvSlRSREgtKyNC02Y+tSQJW/vtBQ0hz+WRKyZYtMYLmpQPDWQrtOleU/iWPySxAaW1GVsA3FXvA5NNFIaLAWln5LooBr5IarupBRJNyFacJKvrLOmqw25ug4ZXPSGP5s4nFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787678137; c=relaxed/simple;
	bh=R5L2QGs2oTC6/y38tuI0h5QiQ9b/01L2YxEhnphYo/s=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gmhRmrlGrv94EQPu7UbgkxtPmXBTlx+B2usk5I39rHLogVOrOPBU7QHaPeYyGcVcMnU5d3AnTUJVw203iDautC/pqGU68tKZmGkZgOJvKmtLHRRNQTY8f3J0vqh8QuK7ZHf76liFrjTMFKALmLh9VsFVl5YSy6ax4S1eVPtoEg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kV7Vtg6N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kV7Vtg6N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D86071F000E9;
	Tue, 25 Aug 2026 17:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787678136;
	bh=HSLbGE7MNcYQop8VMd6om1q+TaawrqmVCfjwuS1rsMY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kV7Vtg6NdtrUONO6VgTXGehuVbLMyZd9N3TpGtJiQEaei5zjFGuVeFAqa0KXseuNL
	 +WFCC9KG50IwZyPYh1K4OfTQoqtlmwNq8OCPoouQCALrgnJja5HgDvOYfZP9wJPGTC
	 iMZ4ur1gUdjt6oLXpy6MDmrKey5YjKpn4CXWK3chGHs8Sz/M+0pSZkXi7Ep6sNUxuu
	 8Ab/4foyqkKHVwik6tn9UTaAVtTWF03EWfg5/Xo0d0r159TKxAwjWy9Z5uI3cDjmyY
	 w397k3grphxzNC/bf/ow8JGGCJL354XjUiSigr4mh9u+P3Ebe3IBwgJdwyfEy7ic55
	 DryysYMLus/Mw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 10/17] mpi3mr: Fix out-of-bounds read in SAS topology
 change events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chandrakanth Patil" <chandrakanth.patil@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260825210411.301535-11-chandrakanth.patil@broadcom.com>
References: <20260825210411.301535-1-chandrakanth.patil@broadcom.com>
 <20260825210411.301535-11-chandrakanth.patil@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 25 Aug 2026 17:15:35 +0000
Message-Id: <20260825171535.D86071F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] Compiler-inserted bounds checks from __counted_by bypass the local=
 caching of num_entries, defeating the TOCTOU mitigation and risking spurio=
us kernel panics.

Pre-existing issues:
- [High] The bounds check aborts the top-half handler but fails to prevent =
the malformed event from reaching the bottom-half handler, resulting in a h=
eap out-of-bounds read.
- [High] Lockless access of tgtdev->starget in event handlers leads to Use-=
After-Free racing with mpi3mr_target_destroy().
--

commit 9d8265fdf635644a7462d4ecd8e229ec48572ac3
Author: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

mpi3mr: Fix out-of-bounds read in SAS topology change events

The number of entries in a SAS topology change event is used to walk
the entry array without being compared against the amount of event data
that was received, so the walk can run past the end of the buffer.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index 9aeec6146acbb..6a80b784200b3 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -2827,12 +2827,28 @@ static void mpi3mr_sastopochg_evt_th(struct mpi3m=
r_ioc *mrioc,
[ ... ]
> +	if (num_entries > max_entries) {
> +		ioc_err(mrioc, "SAS topology event: num_entries(%d) exceeds max(%d)\n",
> +			num_entries, max_entries);
> +		return;

[Severity: High]
This is a pre-existing issue, but returning early here aborts top-half
processing without clearing the caller's process_evt_bh flag.

In drivers/scsi/mpi3mr/mpi3mr_os.c:mpi3mr_os_handle_events(), process_evt_bh
is set to 1 before calling mpi3mr_sastopochg_evt_th(). If we return early,
the event is unconditionally scheduled for bottom-half processing.

Since the bottom-half blindly loops using the attacker-controlled num_entri=
es
on the fwevt buffer:

drivers/scsi/mpi3mr/mpi3mr_os.c:mpi3mr_sastopochg_evt_bh() {
    ...
    for (i =3D 0; i < event_data->num_entries; i++) {
    ...
}

Could this leave the bottom-half exposed to a heap out-of-bounds read when
processing a malformed event?

> +	}
> +
> +	for (i =3D 0; i < num_entries; i++) {
>  		handle =3D le16_to_cpu(topo_evt->phy_entry[i].attached_dev_handle);

[Severity: High]
Since phy_entry is annotated with __counted_by(num_entries), won't the
compiler-inserted bounds check for topo_evt->phy_entry[i] directly re-fetch
topo_evt->num_entries from DMA memory?

If the firmware alters topo_evt->num_entries to be less than the loop index=
 i
during the loop in mpi3mr_sastopochg_evt_th(), wouldn't this bypass the loc=
al
num_entries cache and trigger an array bounds sanitizer violation panic?

[Severity: High]
This isn't a bug introduced by this patch, but further down in
mpi3mr_sastopochg_evt_th() there is a lockless access to tgtdev->starget
that can race with device removal:

drivers/scsi/mpi3mr/mpi3mr_os.c:mpi3mr_sastopochg_evt_th() {
    ...
    if (tgtdev && tgtdev->starget && tgtdev->starget->hostdata)
        scsi_tgt_priv_data =3D (struct mpi3mr_stgt_priv_data *)
            tgtdev->starget->hostdata;
    ...
    case MPI3_EVENT_SAS_TOPO_PHY_RC_TARG_NOT_RESPONDING:
        if (scsi_tgt_priv_data) {
            scsi_tgt_priv_data->dev_removed =3D 1;
    ...
}

Is it possible that if this executes concurrently with mpi3mr_target_destro=
y(),
tgtdev->starget could be cleared under lock and the scsi_target freed by the
SCSI midlayer, causing a Use-After-Free when writing to
scsi_tgt_priv_data->dev_removed?

>  		if (!handle)
>  			continue;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260825210411.3015=
35-1-chandrakanth.patil@broadcom.com?part=3D10
