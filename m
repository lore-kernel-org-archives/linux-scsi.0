Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E8F2D061C
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 18:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787077986; cv=none; b=ZY92Qhx1Qs+DW7OKO5XOYAP3LJjVcrk57zb29ilXrCZIl9i/2lFN0GgD3/P8gGrsxoycqADcD+sqzFHn1aY7LGWIrMxC6XoP1uwlWGVtIxEH8rkOtgiPqfrKJ9qXeahybuz+sZjnf6nqgOoo1iTpypLAf0HPvwu94eg8hcUVXWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787077986; c=relaxed/simple;
	bh=AMrPixSdcd9fTuHRWcvBJ8NLG2p9f3IB7wJ9lU2bGOM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=e9gGYNGbiGlwycbXyLc3MDYEX1OM1jU8xFajlELRSuxlZ+qhpKXIkTAZMfyuTq+/W6RtoTUjcFhqoDtgmwOh+tq3knhU02FgFPJV1g3FSdB4v8KAibbvwtNludf9HfnaRHKM6egXkAHg8j/4TJcDsmwzIg25me0N8NAO+4fCBzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RophIqcq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RophIqcq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2176B1F000E9;
	Tue, 18 Aug 2026 18:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787077985;
	bh=EkcgyrfeiY9zt1ttlQmNLjypYy5nlxr3DOqbFI5XFSo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RophIqcqUcVYgbCmc1ChpX80zQTaLgmqSeEO4LpjAURVj/45MyteAmd2dOO7JfeAg
	 yARyMQgoWGFpLMf/5KMS4LRf2jHZ/hL/o+SZerW4vTit12bzBbq/OJAIvAmx0cQMoo
	 6Bhrk8dP9e2cnqiBPosWejeDvDlYrY1YYoc6cncjIt/csXPJwzjL7QAww+KSqUOtg+
	 W2FzgVpAB7cDwEd9fnOBUtngyCTdZPf5Q+gubTIpvk7vw/DHKHCI+pdaAX+OM8+RCt
	 Ejamzn12gsN243IBGE1y7m9IoH9r/SglscB3p8ZYBIjgKSixP+xTqE7/LcNEE70HHU
	 oJi4m48TtXlUw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 12/17] mpi3mr: Fix out-of-bounds phy array access on
 link change
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chandrakanth Patil" <chandrakanth.patil@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260818231426.58105-13-chandrakanth.patil@broadcom.com>
References: <20260818231426.58105-1-chandrakanth.patil@broadcom.com>
 <20260818231426.58105-13-chandrakanth.patil@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 18 Aug 2026 18:33:04 +0000
Message-Id: <20260818183305.2176B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The firmware event handlers for SAS and PCIe topology changes iter=
ate up to `num_entries` without ensuring it is strictly bounded by the even=
t data length, leading to out-of-bounds reads.
- [High] This problem wasn't introduced by this patch, but the entirety of =
`mpi3mr_update_links` continues to access `mr_sas_node` and performs lockle=
ss list traversals on its structures after releasing `mrioc->sas_node_lock`=
 on the happy path.
- [High] This problem wasn't introduced by this patch, but a shift-sign-ext=
ension bug exists when updating 64-bit `phy_mask` bitmasks using `1 << i`, =
leading to out-of-bounds array accesses when `i >=3D 31`.
--

--- Patch [12]: [PATCH 12/17] mpi3mr: Fix out-of-bounds phy array access on=
 link change ---
commit 5a98eebaf3b1e059c60e29aa1529199221440703
Author: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

mpi3mr: Fix out-of-bounds phy array access on link change

This commit adds a bounds check to ensure the phy number associated with a
link change does not exceed the allocated number of phys for the node. If it
does, the event is logged and ignored.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr=
/mpi3mr_transport.c
> index 240f67a8e2e3b..2afff1a002ed9 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
> @@ -1090,6 +1090,13 @@ void mpi3mr_update_links(struct mpi3mr_ioc *mrioc,
>  		return;
>  	}
> =20
> +	if (phy_number >=3D mr_sas_node->num_phys) {
> +		spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
> +		ioc_err(mrioc, "%s: phy_number(%d) >=3D num_phys(%d)\n",
> +			__func__, phy_number, mr_sas_node->num_phys);
> +		return;
> +	}
> +
>  	mr_sas_phy =3D &mr_sas_node->phy[phy_number];
>  	mr_sas_phy->attached_handle =3D handle;
>  	spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);

[Severity: High]
This is a pre-existing issue, but does dropping the sas_node_lock here leave
mr_sas_node vulnerable to concurrent modification or use-after-free?

Looking at the remainder of mpi3mr_update_links(), mr_sas_node and its memb=
ers
continue to be used after the lock is released:

    spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
    if (handle && (link_rate >=3D MPI3_SAS_NEG_LINK_RATE_1_5)) {
        mpi3mr_set_identify(mrioc, handle, &mr_sas_phy->remote_identify);
        mpi3mr_add_phy_to_an_existing_port(mrioc, mr_sas_node, mr_sas_phy, =
...);

When mpi3mr_add_phy_to_an_existing_port() is called, it iterates over the
sas_port_list locklessly:

    list_for_each_entry(mr_sas_port, &mr_sas_node->sas_port_list, port_list=
) {

Since mrioc->sas_node_lock is no longer held, can other events concurrently=
 add
or remove ports, corrupting the traversal? Additionally, mr_sas_node is fet=
ched
without acquiring a reference, potentially allowing it to be concurrently f=
reed.

[Severity: High]
This isn't a bug introduced by this patch, but could the firmware event
handlers for SAS and PCIe topology changes iterate up to num_entries without
bounds checking against the event data length?

In mpi3mr_sastopochg_evt_bh() and mpi3mr_pcietopochg_evt_bh() in mpi3mr_os.=
c,
the loop blindly iterates up to num_entries:

    for (i =3D 0; i < event_data->num_entries; i++) {
        handle =3D le16_to_cpu(event_data->phy_entry[i].attached_dev_handle=
);

If the hardware or an attacker controlling the controller issues an event w=
ith
a num_entries field larger than what fits in the reply buffer, could this
lead to an out-of-bounds read? Even if the top-half handler attempts to bou=
nd
num_entries, returning early without dropping the event still allows the
bottom-half to iterate over the truncated buffer.

Additionally, mpi3mr_pcietopochg_evt_th() appears to completely lack any
bounds checking before iterating over topo_evt->port_entry.

[Severity: High]
This isn't a bug introduced by this patch, but is there a sign-extension
regression when updating the 64-bit phy_mask bitmask in
mpi3mr_add_phy_to_an_existing_port()?

    mr_sas_port->phy_mask |=3D (1 << i);

When i evaluates to 31, the expression 1 << 31 evaluates as a negative 32-b=
it
integer (0x80000000). When this is bitwise OR'd into the 64-bit phy_mask, it
sign-extends to 0xFFFFFFFF80000000ULL, erroneously setting bits 31 through =
63.

Later, in mpi3mr_update_mr_sas_port(), this corrupted mask seems to be used
in a loop:

    for_each_set_bit(i, (ulong *) &phys_to_be_added, BITS_PER_TYPE(u64)) {
        mr_sas_phy =3D &mrioc->sas_hba.phy[i];

If phys_to_be_added inherits the sign-extended mask, won't this loop exceed
the allocated bounds of mrioc->sas_hba.phy (which may only have 32 elements)
and corrupt memory?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260818231426.5810=
5-1-chandrakanth.patil@broadcom.com?part=3D12
