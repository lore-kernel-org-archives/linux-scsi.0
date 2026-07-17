Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 079952F7EE4
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 17:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784308114; cv=none; b=Co9JqKosaXi9DSuLSVy0hKL7k/TiS73pu7kTs5YxDJt4MPnZ8yfQT3Q/GPpVOoYdh/ILTqQwAyJ238UhAIHJLZocIfWDKRmi4TGOBbTmozg3XwuLLCka+yzQfIRl9lgzSoDao25JwbeiJSjiLmdltx/r5GUV+dtzqypVn4rCdkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784308114; c=relaxed/simple;
	bh=FJKU2x4z6Frqzp6l5+9Rj2BLcdbOlz4l5oSm/w5gccU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=o2vrwIYo7EL+4cQF6y5iO3B6v/8e7rvNRry6Rn+HKJINGl8wSFHbsLfVhDVvguyVDb449Wgk8spViDI46uJSiI6MUh7zW+8yg1IfBNK5QALgSFGzaaeoNMGxjNqkMlblwxW1ayorwSmCCBwAdQYxgEo4L6QGBlVm5+pT9hR9mPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DCas0aaz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DCas0aaz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84E1D1F000E9;
	Fri, 17 Jul 2026 17:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784308112;
	bh=GTRQFB8QJL4Nwv8MvmWsZBm5Pae+iuLlHqHWG9GLLgs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DCas0aazQt8fDOi8Xxi6slap5pqQ+PpcgxQQ8fIuCW4mNr/1utsomnbo68iEDmFuB
	 zaBUmjOyPFJrU7oLJkXZnM/toiIlxMGmN0Ood6Am9ZL5eX0aIA0txBMBHqWtWzEnl7
	 zS3uOjk2LfnlsHLw8bnHMTA+F50VgzdmxztilNEnK815HCQMEwiczE2wlw464QqrVw
	 74s/UnwJhQgNa0ZPgk7zaYoMhAazyJvdBEhTLfcLG2WgHHeUinX6dBtoERkgN4Iobp
	 uMInBXM5Zplr2jPObjc5868bji7zhi+B3YBnVhplutTC9Gkvpi+jbVGBO4+56atTRm
	 wykyY5ilySu+w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 50/56] scsi: qla2xxx: Hold vport reference in
 qla24xx_report_id_acquisition()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260717152904.3155730-51-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
 <20260717152904.3155730-51-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 17:08:32 +0000
Message-Id: <20260717170832.84E1D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Deferred Use-After-Free due to re-inserting a dying vport into the=
 global host_map B-tree.
- [High] Data race and potential B-tree corruption due to missing locks in =
qla_update_host_map.
- [High] Use-After-Free during list traversal due to dropping locks inside =
list_for_each_entry_safe.
- [High] Forced Use-After-Free due to hardcoded timeout in vref_count polli=
ng.
--

--- Patch [50]: [PATCH v5 50/56] scsi: qla2xxx: Hold vport reference in qla=
24xx_report_id_acquisition() ---
commit 888c874111e5c34314eddd622176ba0ffd527654
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Hold vport reference in qla24xx_report_id_acquisition()
   =20
This patch adds vport reference counting inside
qla24xx_report_id_acquisition() by incrementing vref_count when the matching
vp is found under vport_slock. The reference is held during the virtual port
updates to prevent a concurrent qla24xx_deallocate_vp_id() from tearing down
and freeing the vport prematurely.

> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -4267,6 +4267,7 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,=
 void *pkt)
>  			list_for_each_entry(vp, &ha->vp_list, list) {
>  				if (vp_idx =3D=3D vp->vp_idx) {
>  					found =3D 1;
> +					atomic_inc(&vp->vref_count);
>  					break;
>  				}
>  			}

[ ... ]

> @@ -4284,6 +4285,8 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,=
 void *pkt)
>  			set_bit(VP_IDX_ACQUIRED, &vp->vp_flags);
>  			set_bit(REGISTER_FC4_NEEDED, &vp->dpc_flags);
>  			set_bit(REGISTER_FDMI_NEEDED, &vp->dpc_flags);
> +
> +			atomic_dec(&vp->vref_count);

[Severity: High]
This isn't a bug introduced by this patch, but does dropping the lock before
calling qla_update_host_map() risk corrupting the host_map B-tree?

In qla24xx_report_id_acquisition(), vport_slock is unlocked right before
the unlocked modification to the global B-tree:

qla24xx_report_id_acquisition() {
    ...
    spin_unlock_irqrestore(&ha->vport_slock, flags);
    if (!found)
        return;
    qla_update_host_map(vp, id);
    ...
}

Inside qla_update_vp_map(), it calls btree_insert32():

qla_update_vp_map() {
    ...
    rc =3D btree_insert32(&vha->hw->host_map, key, vha, GFP_ATOMIC);
    ...
}

Since the Linux B-tree requires external synchronization and this path
appears to lack a common lock, could concurrent modifications to ha->host_m=
ap
from other queues or teardown paths collide here?


[Severity: High]
This is also a pre-existing issue, but could this unconditional call to
qla_update_host_map() re-insert a dying vport into the global B-tree?

If qla24xx_vport_delete() initiates teardown concurrently, it calls
qla24xx_disable_vp() which removes the vport from ha->host_map and clears
vp->d_id.b24.

When qla24xx_report_id_acquisition() pins the dying vport via vref_count
(stalling the teardown), drops vport_slock, and calls qla_update_host_map()
without verifying the teardown state, the vport is re-inserted back into
the B-tree. Once vref_count reaches 0, the teardown thread frees the vport,
but it would remain accessible in the B-tree, potentially causing a
use-after-free for incoming traffic.


[Severity: High]
This is another pre-existing issue, but does the reliance on vref_count
polling in qla24xx_deallocate_vp_id() still leave a use-after-free window?

The commit message notes that qla24xx_deallocate_vp_id() waits for vref_cou=
nt
to reach zero. However, qla24xx_deallocate_vp_id() loops for up to 10 secon=
ds
and then forcefully unlinks the vport if it times out:

qla_mid.c:qla24xx_deallocate_vp_id() {
    if (!bailout) {
        ql_log(ql_log_info, vha, 0xfffa,
            "vha->vref_count=3D%u timeout\n", vha->vref_count.counter);
        spin_lock_irqsave(&ha->vport_slock, flags);
        list_del(&vha->list);
        qla_update_vp_map(vha, RESET_VP_IDX);
        spin_unlock_irqrestore(&ha->vport_slock, flags);
    }
}

The caller, qla24xx_vport_delete(), then proceeds to unconditionally free t=
he
memory via scsi_host_put(vha->host). If a thread holding a reference was
stalled and resumes after the timeout, could it access freed memory?


[Severity: High]
Lastly, this isn't a bug introduced by this patch, but are the other
vp_list traversals safe when dropping the lock?

Several functions iterate over ha->vp_list using list_for_each_entry_safe()
while dropping the vport_slock inside the loop. For example:

qla_mid.c:qla2x00_do_dpc_all_vps() {
    list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
        if (vp->vp_idx) {
            atomic_inc(&vp->vref_count);
            spin_unlock_irqrestore(&ha->vport_slock, flags);
            ...
}

Since list_for_each_entry_safe() caches the tvp pointer before the loop body
executes, dropping the lock exposes the unreferenced tvp node to concurrent
deletion. Could qla24xx_deallocate_vp_id() unlink and free tvp while the
lock is dropped, leading to a use-after-free when advancing to the next
iteration?

>  		}
>  		set_bit(VP_DPC_NEEDED, &vha->dpc_flags);
>  		qla2xxx_wake_dpc(vha);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717152904.3155=
730-1-njavali@marvell.com?part=3D50
