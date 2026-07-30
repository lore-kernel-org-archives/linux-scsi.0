Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592A84766B8
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 23:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785453492; cv=none; b=kYZDN3KlUqUfy/PoqVRLbZVgoEDLxb6oIEBVoxHjQZFy2cywJ3vSBVEmtmAUgG7uNFhmIVx0vGxX+/xgxBTtQtaWcblbj7G93MbhfGU832t/8xaNvtamszHCBSmsa4OGXtJhruWd5kVN7TDTxl1nzwf95ajp3YtXbGlSUEADRNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785453492; c=relaxed/simple;
	bh=1SrNqXwHXmpY+vIdjG6t5GLiTnk/LuExmOW0yPZOev4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=VJtdMCo8WHglTM+MTkEkiO3u82vUdNRVFWSkzwwQKb/eIA/XsoRgpJXgctROP5aBlExZzECamBHFH1Az0M57xlcuFA1K4v5k5s3ABu6cQviW4cQQ5eErupnlVYXtCz4zXnKCR5KRuhYaIQoAP+oTxLYJmxuXo0f4xiaB5JQ1GQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M13bI/oS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M13bI/oS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A9191F000E9;
	Thu, 30 Jul 2026 23:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785453487;
	bh=vs0tVYryvWjPq2v+F1G2yW7oR6+dSk2s4HJW9WHCLsI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=M13bI/oSujx3mcCA66BbYCOAOJGS8ZGILXqduXKlDJwN5EtOyOUao2VsxWsMg3wue
	 jd6NYt9xtHEy3jFbF31Za1fDDVbmIQhdb8p0erw7RipgG8WdP0h4GBLSX3MHaBfSc+
	 61b4m5P7bwTmOjRaBElEY1zORHzvS3QLsgiCWUb1T5CK3wgZoUzJmgjhfPPsUa1iuX
	 7eYeiFOCezwjF1nfGhXXQRrey3MIdpd9zEYLW9WW8QbH9vfC2ZhNy1Wo0dXu3SXO2F
	 kctRFDQN5D7OrN0Q7XwqEXzxmiaE73ZJ0YOCFaMNPctu8EOjTRKRiVokrRd6aa1eJ6
	 6LSzxDdRtPIVw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 42/57] scsi: mvsas: Enable lock context analysis
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <5e65b2732191612e2dc82258c1b3c25831ec958f.1785451174.git.bvanassche@acm.org>
References: <cover.1785451174.git.bvanassche@acm.org>
 <5e65b2732191612e2dc82258c1b3c25831ec958f.1785451174.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 23:18:07 +0000
Message-Id: <20260730231807.8A9191F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Dropping the spinlock inside a `list_for_each_entry_safe` loop=
 in `mvs_do_release_task` allows list modification, causing an infinite loo=
p.
- [Critical] Dropping the spinlock inside `mvs_int_rx` allows concurrent ex=
ecution, causing double-completion of tasks and potential Use-After-Free.
- [High] The function `mvs_port_notify_deformed` fails to acquire `mvi->loc=
k` and was missed by the new locking annotations, causing a lock imbalance.
- [High] Using a global PHY index instead of a local PHY index to write to =
hardware registers in `mvs_port_notify_formed`.
--

--- Patch [42]: [PATCH v3 42/57] scsi: mvsas: Enable lock context analysis =
---
commit c111f35a79c7e4e1741700306a7a9dfd2b59f919
Author: Bart Van Assche <bvanassche@acm.org>

scsi: mvsas: Enable lock context analysis

Document locking requirements with __must_hold(). Annotate functions
that perform conditional locking with __no_context_analysis.

> diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
> index 359226e80eae8..f63e0dc1abd23 100644
> --- a/drivers/scsi/mvsas/mv_sas.c
> +++ b/drivers/scsi/mvsas/mv_sas.c
> @@ -1055,6 +1055,7 @@ void mvs_update_phyinfo(struct mvs_info *mvi, int i=
, int get_st)
>  }
> =20
>  static void mvs_port_notify_formed(struct asd_sas_phy *sas_phy, int lock)
> +	__context_unsafe(conditional locking)
>  {
>  	struct sas_ha_struct *sas_ha =3D sas_phy->ha;
>  	struct mvs_info *mvi =3D NULL; int i =3D 0, hi;

[Severity: High]
This is a pre-existing issue, but does mvs_port_notify_formed() write to the
wrong hardware offset when multiple HBAs are present?

It uses the global index i instead of the local PHY index sas_phy->id:

drivers/scsi/mvsas/mv_sas.c:mvs_port_notify_formed() {
    ...
    if (phy->att_dev_info & PORT_SSP_TRGT_MASK) {
        MVS_CHIP_DISP->write_port_cfg_addr(mvi, i, PHYR_PHY_STAT);
        MVS_CHIP_DISP->write_port_cfg_data(mvi, i, 0x04);
    }
    ...
}

When the global index is greater than or equal to mvi->chip->n_phy, could
passing it to write_port_cfg_addr() cause out-of-bounds memory-mapped IO
writes?

[ ... ]

> @@ -1644,6 +1647,7 @@ int mvs_slot_complete(struct mvs_info *mvi, u32 rx_=
desc, u32 flags)
> =20
>  void mvs_do_release_task(struct mvs_info *mvi,
>  		int phy_no, struct domain_device *dev)
> +	__must_hold(&mvi->lock)
>  {
>  	u32 slot_idx;
>  	struct mvs_phy *phy;

[Severity: Critical]
This is a pre-existing issue, but is it safe to use list_for_each_entry_saf=
e()
here if the lock is dropped inside mvs_slot_complete()?

mvs_do_release_task() loops over the port list:

drivers/scsi/mvsas/mv_sas.c:mvs_do_release_task() {
    ...
    list_for_each_entry_safe(slot, slot2, &port->list, entry) {
        ...
        mvs_slot_complete(mvi, slot_idx, 1);
    }
    ...
}

When mvs_slot_complete() temporarily releases mvi->lock, a concurrent
interrupt could complete the cached next element (slot2) and remove it from
the list.=20

Would this leave slot2->entry.next pointing to itself, causing
mvs_do_release_task() to spin forever in an infinite loop when it resumes?

[Severity: High]
Also a pre-existing issue, but with the new __must_hold annotation here, wh=
at
happens when this is called from mvs_port_notify_deformed()?

mvs_port_notify_deformed() ignores its lock parameter and directly calls
mvs_do_release_task() without holding mvi->lock:

drivers/scsi/mvsas/mv_sas.c:mvs_port_notify_deformed() {
    ...
    list_for_each_entry(dev, &port->dev_list, dev_list_node)
        mvs_do_release_task(phy->mvi, phy_no, dev);
    ...
}

Will this cause a lock imbalance when the downstream mvs_slot_complete()
call unconditionally executes spin_unlock(&mvi->lock)?

[ ... ]

> @@ -1862,6 +1868,7 @@ void mvs_int_port(struct mvs_info *mvi, int phy_no,=
 u32 events)
>  }
> =20
>  int mvs_int_rx(struct mvs_info *mvi, bool self_clear)
> +	__must_hold(&mvi->lock)
>  {
>  	u32 rx_prod_idx, rx_desc;
>  	bool attn =3D false;

[Severity: Critical]
This is a pre-existing issue, but does dropping the lock inside mvs_int_rx()
expose mvi->rx_cons to concurrent modification?

mvs_int_rx() loops while evaluating the shared mvi->rx_cons:

drivers/scsi/mvsas/mv_sas.c:mvs_int_rx() {
    ...
    while (mvi->rx_cons !=3D rx_prod_idx) {
        ...
        if (likely(rx_desc & RXQ_DONE))
            mvs_slot_complete(mvi, rx_desc, 0);
        ...
    }
    ...
}

Inside the loop, mvs_slot_complete() drops mvi->lock. If a concurrent
interrupt on another CPU acquires the lock, processes the ring, and frees
the tasks, could the first CPU wake up, read old descriptors based on the
updated mvi->rx_cons, and erroneously complete new reused tasks?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785451174.gi=
t.bvanassche@acm.org?part=3D42
