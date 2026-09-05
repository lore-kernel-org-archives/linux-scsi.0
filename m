Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36273546C8
	for <linux-scsi@vger.kernel.org>; Sat,  5 Sep 2026 16:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788626225; cv=none; b=nQzWHRgwFzXWO5ib9ZmyZhzR4dq5KvSZKGUgyqe6httFNq+U4MjLpZhM/DWQhr61s4mPLYePyLE/sxxGb+3eo5JSkjafkLZPMdIoYHnuozRvFzm3AoQ006YPrccMXqTHMfgajz1B5xzXttxnFs8CClAVpa+VcyOrd46yDSPbIdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788626225; c=relaxed/simple;
	bh=EUaolYSodTanHx7zVckv5qaUPcs3P1Dg9NWCJBUQFqk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Izlt7cWvYBzx0YXoscbfTiAeB/HCppACwc/xdLZQF1bXdGdClz8T5B8EcdNegm/Jphrsaf+GTG9CzQZLb8in5rmxDOumSmv88ahFJctHlSrPCdmrU77bRKZsnKIkSGOCF0kbmBlLwxeAan/34z2US0eELmixZ2zOsA1ZYDixtQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UaTFCnSq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UaTFCnSq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67DF01F00A3A;
	Sat,  5 Sep 2026 16:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788626221;
	bh=PNZSIrKptrmPjgeDRnZM6RROBDnwnBUT7/Ne7UBiaxM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UaTFCnSqSMASYTdARMmtHGYsy2TKh0YgGORa47oipE4EQAE/vyM+w5Ez54Cav8Y9H
	 6jZSI7KVdGNPJRBTaP7rw1hNVX6+LO+o+7LLAKJDtZVDdwQoCxUqn4LJFedECTYCEz
	 yGFA8SMBMdObWXsge+35HL3W5TuAcuGo3UVbAOS0l7LJv4I2FQOz3YavRUq0o9QjM7
	 fN0aPncFcUaD0IVjRoiRk1sV8T1/YmlM+lcogljWJTlnzB+ybGZ3VgBL6mu9XJZMrA
	 BWo1ASsFXffFkZKbsXcQZQV0lst7Z9bDmfDsvSVcfBmljY7d0VP+UB7FCRVX6fE8H/
	 qy+7ANPaX+yBQ==
From: sashiko-bot@kernel.org
Subject: Re: [GIT PULL] SCSI fixes for 7.3-rc1+
Reply-To: sashiko-reviews@lists.linux.dev
To: "James Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <d7c2465525ad601d8569fa7219a8add38bf4aa26.camel@HansenPartnership.com>
References: <d7c2465525ad601d8569fa7219a8add38bf4aa26.camel@HansenPartnership.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 05 Sep 2026 16:37:00 +0000
Message-Id: <20260905163701.67DF01F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Unprotected traversal of `tgtdev_list` in `mpi3mr_refresh_tgtdevs`=
 allows data races with concurrent list modifications.
--

commit 4a7c6ef4ce1e621008a2fb66b4611720ab5e8ceb
Author: James Bottomley <James.Bottomley@HansenPartnership.com>

SCSI fixes for 7.3-rc1+

This commit brings in several SCSI subsystem fixes, including enhancements =
for
Intel 4.0 controllers and a variety of driver fixes. Notable changes address
a target use-after-free in mpi3mr and a TOCTOU fix for io_uring passthrough
in bsg.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index f80a21ec161b6..0f73804487188 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -1094,10 +1094,13 @@ static void mpi3mr_refresh_tgtdevs(struct mpi3mr_=
ioc *mrioc)
>  {
>  	struct mpi3mr_tgt_dev *tgtdev, *tgtdev_next;
>  	struct mpi3mr_stgt_priv_data *tgt_priv;
> +	struct scsi_target *starget;
> +	unsigned long flags;
> =20
>  	dprint_reset(mrioc, "refresh target devices: check for removals\n");
>  	list_for_each_entry_safe(tgtdev, tgtdev_next, &mrioc->tgtdev_list,
>  	    list) {

[Severity: High]
This is a pre-existing issue, but is it safe to traverse mrioc->tgtdev_list
without holding the tgtdev_lock across the iteration steps?

Because this loop (and the subsequent loops in mpi3mr_refresh_tgtdevs())
iterates without holding mrioc->tgtdev_lock, could concurrent modifications
to the list result in data races?=20

For instance, mpi3mr_refresh_tgtdevs() runs in a workqueue thread, but a
top-half interrupt handler can process MPI3_EVENT_DEVICE_ADDED, subsequently
calling mpi3mr_create_tgtdev() -> mpi3mr_tgtdev_add_to_list() to add elemen=
ts.

Since standard linked list operations are not atomic, couldn't iterating
here without the lock cause torn reads or traversal of invalid pointers if
an interrupt modifies the list concurrently?

> +		spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
>  		if (((tgtdev->dev_handle =3D=3D MPI3MR_INVALID_DEV_HANDLE) ||
>  		     tgtdev->is_hidden) &&

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/d7c2465525ad601d856=
9fa7219a8add38bf4aa26.camel@HansenPartnership.com?part=3D1
