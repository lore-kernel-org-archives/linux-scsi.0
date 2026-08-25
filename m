Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884E1395ADE
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 19:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787685451; cv=none; b=FpLfH1mIj1OOjYUMJE/vBsSmvy0tXUynZKRuy17dsKW38Ceoy2lagiJJWNHsQtqT3b7VEs5gijNDMa0HHd1cdyKLnHlvs4UnPBDPux7kP3BliG/unaRBzSmiorEkZM+M13eTuh7N0P402gtF9vB5IoqlyXTPAwe9bR6jfw16crs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787685451; c=relaxed/simple;
	bh=w+IYL6I49d9ZVpgHUL4+2aCm+gTpB8oE5NucA6GDoMg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FqrJygPbrqvRTtsrh0J8IAh8Who1DmuLEAf35IeTmPzBvgjPVQth0sR2wHHRk4zpp1zOEP+tEj4eIOjAmj8AIGO0qOeemyIzw2nBOxJ3LeHDF3JrsGGiwe0rgmAla959GDQE7fML/c5efljf+FOFzzHatxTW/aX8tlFXhpyvEW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J0vRCgiu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J0vRCgiu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED3911F000E9;
	Tue, 25 Aug 2026 19:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787685450;
	bh=YVT1iqtVXZMrYbYAi0mesWuXliDAcSRlxv3k8bz/hDA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=J0vRCgiuM+fezGRHwWly9tABHZH283ENGtdgUDfWXj7py/o0JwRjLsMKeX//HJl+I
	 9hFnFZOabXR2YKcUP0AolxilhSjl+kO/fAWe5NKygd4OSnuhjDKGa58Sm4j6cJMM6h
	 7QEsRPCohofCSMLAJKWiVj7QyABmef3fpb92m4UDj9zAuzg/Gtl0S2AWpE6PysSgNQ
	 +W/AFwMt22sDKbvs2iWsJnqwbGo9Qtq9i/a/uVQN0lrQlQEaF1uktDVtSXAh6s13SR
	 CXhUDeP8MK9N2ICl2vAG++fwZh+jy+oLUjE4G0m7Oj19ohpHIT1kuJPEf4of7WFitx
	 k9FLv37NG5dvw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] scsi: mpt3sas: avoid out-of-bounds cpumask_of_node()
 call in _base_assign_reply_queues()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ivy Lopez" <skunkolee@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260825190313.24013-1-skunkolee@gmail.com>
References: <20260817221300.43286-1-skunkolee@gmail.com>
 <20260825190313.24013-1-skunkolee@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 25 Aug 2026 19:17:29 +0000
Message-Id: <20260825191729.ED3911F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but incorrect subtra=
ction in the fall_back path causes unassigned CPUs in the msix table and a =
potential divide by zero if nr_msix evaluates to zero.
--

commit 9e90c3b985462523aebc40d2af67de713d3be849
Author: Ivy Lopez <skunkolee@gmail.com>

scsi: mpt3sas: avoid out-of-bounds cpumask_of_node() call in _base_assign_r=
eply_queues()

dev_to_node() can return NUMA_NO_NODE (-1) on systems without NUMA
topology information for the PCI device, such as single-socket
boards that don't expose device-to-node affinity. Fall back to
cpu_online_mask when no NUMA node is available, rather than assuming
dev_to_node() always returns a valid node index.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D221294

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/m=
pt3sas_base.c
> index fed7aeffec58d..1af25a22611a1 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -3238,7 +3238,10 @@ _base_assign_reply_queues(struct MPT3SAS_ADAPTER *=
ioc)
>  		 * corresponding to high iops queues.
>  		 */
>  		if (ioc->high_iops_queues) {
> -			mask =3D cpumask_of_node(dev_to_node(&ioc->pdev->dev));
> +			int node =3D dev_to_node(&ioc->pdev->dev);
> +
> +			mask =3D (node =3D=3D NUMA_NO_NODE) ?
> +				cpu_online_mask : cpumask_of_node(node);
>  			for (index =3D 0; index < ioc->high_iops_queues;
>  			    index++) {
>  				irq =3D pci_irq_vector(ioc->pdev, index);

[Severity: High]
This isn't a bug introduced by this patch, but incorrect subtraction in the
fall_back path causes unassigned CPUs in the msix table and a potential
divide by zero.

In _base_assign_reply_queues(), the calculation evaluates incorrectly:

drivers/scsi/mpt3sas/mpt3sas_base.c:_base_assign_reply_queues() {
...
fall_back:
	cpu =3D cpumask_first(cpu_online_mask);
	nr_msix -=3D (ioc->high_iops_queues - iopoll_q_count);
	index =3D 0;

	list_for_each_entry(reply_q, &ioc->reply_queue_list, list) {
		unsigned int i, group =3D nr_cpus / nr_msix;
...
}

If iopoll_q_count > 0, the calculation nr_msix -=3D (ioc->high_iops_queues -
iopoll_q_count) evaluates to nr_msix - high_iops_queues + iopoll_q_count.

This mathematically adds iopoll_q_count instead of subtracting it, inflating
nr_msix. This causes group =3D nr_cpus / nr_msix to calculate a smaller gro=
up
size, leaving trailing CPUs mapped to vector 0.

Furthermore, if PCI MSI-X allocation limits nr_msix to exactly
high_iops_queues (e.g. system interrupt limits), nr_msix evaluates to 0.

This would trigger a hardware divide-by-zero exception when evaluating
nr_cpus / nr_msix.

Is it possible to rewrite this subtraction to avoid inflating nr_msix and
prevent a potential divide-by-zero?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260825190313.2401=
3-1-skunkolee@gmail.com?part=3D1
