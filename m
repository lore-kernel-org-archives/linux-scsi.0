Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000AC26D4DD
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 00:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783990275; cv=none; b=XY0I74H84wmfPg4kpWxbuyvS3LlzwU4NZKGJ4jqWA0zj02lUcYQyxPfjM1PmTXfZbdpXiNx7c8ivFq5zaVvy+LRPEljnByKb/GLXhlm8LlxacpXNEocwqVznbS35lroOi+r4ect674LdCC9Z8bEt0Amr6pd1aSQvmoyVyCLERpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783990275; c=relaxed/simple;
	bh=aALfgiy3xVlUA2k6yCJOuu6G8zM37tonh0MUDe6X87E=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kx982BsSX9RLe44ItrX4+GCrTjInIFDv34gOh4z/Hi0NqOEX3givAFXC7tfWfnGSFpMiuAD80l9R31lmUSJRLAavX9XRCg3+kJ9t4uJk/NibHNTieOjUoKcq0HsItEaMciacTw0H1hbAgzve6iBlWjf4LMZpOP5eiF+jPZ2Vis4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AKmIbPaJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AKmIbPaJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C6A11F00A3A;
	Tue, 14 Jul 2026 00:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783990273;
	bh=nnSu8/wPwi+UeXE9XeQFzFsY9DqRfgZU1etKDuO1+1s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AKmIbPaJz+QwOaKSDgKh0UKRgGI9I1us3CVQmwgut7zwXL7PTzjzCQR50kVh2jRGU
	 FFXCL8G0SJsuVPAeyHDiHBq9/6Ogv78drh0HyLAJSXMImSXKk3CsSD3uLVDE7Fy1HB
	 kxufkOQ59YIMXDpQ4c1pHFRuaWpiK3KdTjvUQ9HVAddLkLUd7ZDi0fOAj85nWb4rHr
	 Tk27YC0R4OkvmRDK8wiT6Rgw88MRhz51qPwKIV0jxKKYuPeNgOZ7bSCUAX7qn8Lrc5
	 Al3wXWmOwz5O7wTHDYRenmpxIeMX5kZDiKpSGlIm7ZZu0ykVvdCjs4F3/wOc6yt6o/
	 0v1JQpPYnHuBg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 01/14] lpfc: Fix use-after-free in
 lpfc_cmpl_ct_cmd_vmid
Reply-To: sashiko-reviews@lists.linux.dev
To: "Justin Tee" <justintee8345@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260714011812.106753-2-justintee8345@gmail.com>
References: <20260714011812.106753-1-justintee8345@gmail.com>
 <20260714011812.106753-2-justintee8345@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 00:51:12 +0000
Message-Id: <20260714005113.5C6A11F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Zeroing hash table elements before their removal causes a guar=
anteed kernel panic, and unsafe hash table iteration breaks list cleanup.
- [High] Multiple severe locking violations in the VMID hash table and arra=
y accesses, including using a read lock for destructive writes and lockless=
 modifications.
- [High] The SLI_CTAS_DALLAPP_ID handler leaks per-cpu memory by memsetting=
 the lpfc_vmid structure to zero without freeing `last_io_time`.
- [High] In `lpfc_vmid_vport_cleanup`, `vport->vmid` is freed via `kfree` b=
efore the code iterates over `vport->hash_table` to remove entries, resulti=
ng in a Use-After-Free.
--

--- Patch [1]: [PATCH v3 01/14] lpfc: Fix use-after-free in lpfc_cmpl_ct_cm=
d_vmid ---
commit ade52a05f937db7fd95e3ae568536fda43aeccdf
Author: Justin Tee <justintee8345@gmail.com>

lpfc: Fix use-after-free in lpfc_cmpl_ct_cmd_vmid

This commit removes an early call to lpfc_ct_free_iocb() in
lpfc_cmpl_ct_cmd_vmid() for SLI_CTAS_DALLAPP_ID commands. This prevents a
use-after-free of cmdiocb->rsp_dmabuf during CT LS_RJT response handling,
relying instead on the existing free_res label for cleanup.

> diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
> index c7853e7fe0719..e14170550e697 100644
> --- a/drivers/scsi/lpfc/lpfc_ct.c
> +++ b/drivers/scsi/lpfc/lpfc_ct.c
> @@ -3595,8 +3595,6 @@ lpfc_cmpl_ct_cmd_vmid(struct lpfc_hba *phba, struct=
 lpfc_iocbq *cmdiocb,
>  	int i;
> =20
>  	cmd =3D be16_to_cpu(ctcmd->CommandResponse.bits.CmdRsp);
> -	if (cmd =3D=3D SLI_CTAS_DALLAPP_ID)
> -		lpfc_ct_free_iocb(phba, cmdiocb);
> =20
>  	if (lpfc_els_chk_latt(vport) || get_job_ulpstatus(phba, rspiocb)) {
>  		if (cmd !=3D SLI_CTAS_DALLAPP_ID)

[Severity: Critical]
This is a pre-existing issue, but looking further down in
lpfc_cmpl_ct_cmd_vmid() under the SLI_CTAS_DALLAPP_ID case:

    memset(vmp, 0, sizeof(struct lpfc_vmid));

This zeroes the embedded hlist_node, including its pprev and next pointers.
Right after this, the code attempts to remove these items:

    if (!hash_empty(vport->hash_table))
        hash_for_each(vport->hash_table, bucket, cur, hnode)
            hash_del(&cur->hnode);

Does calling hash_del() on these zeroed elements cause a NULL pointer
dereference panic when it tries to write to *n->pprev?

Also, since this iteration modifies the list, shouldn't it use
hash_for_each_safe() to prevent breaking the iteration chain?

[Severity: High]
This isn't a bug introduced by this patch, but there appear to be multiple
locking violations in lpfc_cmpl_ct_cmd_vmid() that could lead to data races
and corruption.

First, under the SLI_CTAS_DALLAPP_ID case, the memset() is performed under a
read lock:

    read_lock(&vport->vmid_lock);
    for (i =3D 0; i < phba->cfg_max_vmid; i++) {
        vmp =3D &vport->vmid[i];
        if (vmp->flag !=3D LPFC_VMID_SLOT_FREE)
            memset(vmp, 0, sizeof(struct lpfc_vmid));
    }
    read_unlock(&vport->vmid_lock);

Since read_lock() doesn't provide mutual exclusion against concurrent reade=
rs,
does this destructive write race with other readers?

Additionally, the hash table iteration and deletion:

    if (!hash_empty(vport->hash_table))
        hash_for_each(vport->hash_table, bucket, cur, hnode)
            hash_del(&cur->hnode);

is performed entirely locklessly.

Furthermore, earlier in the SLI_CTAS_RAPP_IDENT case:

    vmp =3D lpfc_get_vmid_from_hashtable(vport, hash,
                                       app->obj.entity_id);

This lookup is also performed without holding any lock.

Can these lockless operations and the write-under-read-lock cause list
corruption?

[Severity: High]
This is a pre-existing issue, but the same memset() in lpfc_cmpl_ct_cmd_vmi=
d()
that zeroes the hlist_node:

    memset(vmp, 0, sizeof(struct lpfc_vmid));

also overwrites the entire lpfc_vmid struct. This struct contains a dynamic=
ally
allocated per-cpu pointer:

    u64 __percpu *last_io_time;

Does this zeroing cause an unrecoverable leak of the per-cpu memory allocat=
ed
for last_io_time?

[Severity: High]
This is also a pre-existing issue, but related to the VMID hash table clean=
up
seen above. In drivers/scsi/lpfc/lpfc_scsi.c:lpfc_vmid_vport_cleanup():

    kfree(vport->vmid);

    if (!hash_empty(vport->hash_table))
        hash_for_each(vport->hash_table, bucket, cur, hnode)
            hash_del(&cur->hnode);

The hash table nodes (hnode) are embedded within the lpfc_vmid structures in
the vport->vmid array.

Since kfree(vport->vmid) is called before iterating the hash table, doesn't
the subsequent hash_for_each() loop read from freed memory?

Furthermore, shouldn't hash_for_each_safe() be used here as well since
hash_del() modifies the list?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714011812.1067=
53-1-justintee8345@gmail.com?part=3D1
