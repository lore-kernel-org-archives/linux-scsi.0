Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DEBF34FF45
	for <linux-scsi@vger.kernel.org>; Mon, 17 Aug 2026 22:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787005843; cv=none; b=UFRVPbR048+lSzKTBfR+FgP054vE51hluNKn7DPHi3nm5I0FhhSr2dEKh8QaKP2WkC007kdtgtgzypS/yTnYEe6KtWszep2dnYhHFdbyjRLUP2CpTHHqD6G7DARlpAx8pLCLteA6yjpzXfm7zAYiyMkcl5VUKbDp1wFv2QeVMeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787005843; c=relaxed/simple;
	bh=3FKdmJHwn35LiA3MlrCqPX25iIbtvnaCE2tzrHQABcc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Mte92LikhmAmNwvjcDaF4aCRVtPYHRB7b74vAmup4775WywUANVQrS67k6qZ/p+iosWGwcxERvIM+/sbjxIYzVtfM1gFhQLIvapqql7GlcqkKgSa2KIXwIkhXLOmpU7hKXifnMJX0EYpRpyivzZckJxmp8aFBQ5rWpYcEBJkTek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G8AjDu8I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G8AjDu8I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9AF91F000E9;
	Mon, 17 Aug 2026 22:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787005842;
	bh=nHbCDPcERLXAddJSGyQ3Q50U61evSvfVnNzO1GTeLoM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=G8AjDu8IQNz3LFixewB0oyXVB2hR6pkxwGhY75zySbJVzxzt2mxZOZ4MnA8ZavELo
	 mQtGJ02t/jy6I3XorQwrcU/IgnK5RTrz72euC8XLNwrWLCvjvx54RA9vClxbveAbUy
	 a6qcChzf9I1T2ept4Q+bTG9aHAI/N40LFY8Qt9B1qKLRfY1ey6y4y2ks+OPZIlW+mh
	 SJxD4Zq6qeq+bYaVLDZNATpg2zL+dKNDMWRqTz70J266451R9ypod5LBaAGI8QFD8Y
	 NReI69rsF4jqRTWTovSAp7zXW+lymbv5pCbLpvtJSXn3Sy8BQBe/CCLzudVWUHlObn
	 kISQ9tdVgdcMw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: mpt3sas: avoid out-of-bounds cpumask_of_node()
 call in _base_assign_reply_queues()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ivy Lopez" <skunkolee@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260817221300.43286-1-skunkolee@gmail.com>
References: <20260817221300.43286-1-skunkolee@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 17 Aug 2026 22:30:41 +0000
Message-Id: <20260817223041.D9AF91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Incorrect calculation of remaining MSI-X queues causes a Division =
by Zero kernel panic or severe IO imbalance.
--

--- Patch [1]: [PATCH] scsi: mpt3sas: avoid out-of-bounds cpumask_of_node()=
 call in _base_assign_reply_queues() ---
commit 2577a38cb04664cd3aa266df2234da5f8d4aff10
Author: Ivy Lopez <skunkolee@gmail.com>

scsi: mpt3sas: avoid out-of-bounds cpumask_of_node() call in _base_assign_r=
eply_queues()

Fixes an out-of-bounds array read in cpumask_of_node() by checking if
dev_to_node() returns NUMA_NO_NODE. If so, it falls back to cpu_online_mask
instead of using the invalid NUMA node index.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D221294

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/m=
pt3sas_base.c
> index fed7aeffec58d..b354cbcd12741 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -3238,7 +3238,9 @@ _base_assign_reply_queues(struct MPT3SAS_ADAPTER *i=
oc)
>  		 * corresponding to high iops queues.
>  		 */
>  		if (ioc->high_iops_queues) {
> -			mask =3D cpumask_of_node(dev_to_node(&ioc->pdev->dev));
> +			int node =3D (dev_to_node(&ioc->pdev->dev));
> +
> +			mask =3D (node =3D=3D NUMA_NO_NODE) ? cpu_online_mask : cpumask_of_no=
de(node);
>  			for (index =3D 0; index < ioc->high_iops_queues;
>  			    index++) {
>  				irq =3D pci_irq_vector(ioc->pdev, index);

[ ... ]

[Severity: High]
This is a pre-existing issue, but I noticed a potential division by zero
later in drivers/scsi/mpt3sas/mpt3sas_base.c:_base_assign_reply_queues():

fall_back:
	cpu =3D cpumask_first(cpu_online_mask);
	nr_msix -=3D (ioc->high_iops_queues - iopoll_q_count);
	index =3D 0;

	list_for_each_entry(reply_q, &ioc->reply_queue_list, list) {
		unsigned int i, group =3D nr_cpus / nr_msix;

Can this result in a division by zero panic?

If iopoll_q_count =3D=3D 0 and all available vectors are assigned to
high_iops_queues, nr_msix becomes 0. The list loop unconditionally computes
group =3D nr_cpus / nr_msix before checking if the queue is a default queue,
triggering a division by zero.

Additionally, does the fallback logic incorrectly add the poll queues inste=
ad
of subtracting them when iopoll_q_count > 0? This would shrink the CPU group
size and could cause unassigned CPUs to fall back to a single queue.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260817221300.4328=
6-1-skunkolee@gmail.com?part=3D1
