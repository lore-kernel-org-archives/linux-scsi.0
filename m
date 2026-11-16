Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794798063;
	b=ZKf0UhM7qJ1n1eRl0xmpnzCYqHNTgb+d+9WXdshff0OsgLMgXQFu96YxItIab3V0PsPJ
	 QIKJquv1711+vAKzZ+/PoJipApWoVCFBYcWA9hOTbOkPFWW2XHTZqBBhb36Q4ZykvnSUV
	 quYEPLdjJK+gPv8JoHvVxXZxIFYFdRcQ6FPgswKqpDdTMw3H+b2p2GIpotfVT5awImt5A
	 9+/hSgDYq0eMyt71LurBJc6DSfJN1csg1a036w0A2TzhvK2Vj+IFeGZbWXpQDi/sVyPzZ
	 TGdEhVZXgzDRu1Q+JFLzFOM4WMtvX+lLF9pVHEcZ2I5T+gBJzJWIYy9UYFgbBqarTXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794798063;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=LT9+4IVJzI9aYc2CCdo5yiCxwJH+nqys1isCTGx8c5Q=;
	b=bFSES8j/HmMZzMzXlS9zWmiWRjVWE7iutHQzHCr2R7vOBrYZ3h2J0fQS7uzj/YBkNhS9
	 5cqP3Zg9hdFZJ/0JotmeFWbtmmWjOLFlXsfMDV5cN9Wr0OTH723/5BpbpsGbazm9X+2HF
	 Ueaf2DWW8btvonR2gBcZAX2/zdpw4c7HWx17sBMANs/OSBRi/Q28/pU3ZnkSB/AOvTFGq
	 w+rqZ/wzZGW7g0BsLOPiwfoeLosTHufBwm4yLhiwOln1jxAaLHOUJ49KUb+tQkFQywmcC
	 AbkeZfVGTaTlZJ/Dj95Qevg/V+I0As8sWnDY4Pr/3ta4M131Y3Jrkore2fminZ4x3Jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fwrysz7V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A72F606A323
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 03:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fwrysz7V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB1AC1F000C4;
	Mon, 16 Nov 2026 03:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794798063;
	bh=LT9+4IVJzI9aYc2CCdo5yiCxwJH+nqys1isCTGx8c5Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fwrysz7V92WNw6as0wqfP/9lkzSwpq6XvaXlFQ726aPrwOEMA3VEd0PqKjY970FEY
	 8/VaP/IeKqcnmMSOv+CMy2ibtDu5FSs/306/3xjbMND7tiwd5NR8y1ud0IeY5vB70j
	 8L3FsJVfnQkn7vIS46t8Od821LFfhFDfMM6ueSE2hRPySchfUSFexI9z/xuf7/BakV
	 HW0dvEgGGMoRXTWRP1Hkhazn48aa/PIQaYGEvG44TEtmxkm+RlvkT5yLpKXRN5THsW
	 OtyRd4bbg8UkyNDL4Vq4PuoZO6qBFN4+5jGLHFWEcK8Pcwwd0AwiQTPSdRe7uL9xU2
	 Ki1T1EwtKKXQg==
Message-ID: <sashiko-outbox-216096@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: lpfc: Look up the VMID entry under vmid_lock
Reply-To: sashiko-reviews@lists.linux.dev
To: "Changyul Lee" <lcy8047@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261116023939.588838-1-lcy8047@gmail.com>
References: <20261116023939.588838-1-lcy8047@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 03:01:02 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] scsi: lpfc: inaccurate Fixes trailer for lpfc_cmpl_ct_cmd_vmid()
  lock fix
It also noticed 1 related pre-existing issue this patch does not
introduce:
- [High] scsi: lpfc: data race and list corruption in
  lpfc_cmpl_ct_cmd_vmid() [1]
--

commit ace8e21fd4e560f69d845916087ba204329824c3
Author: Changyul Lee <lcy8047@gmail.com>

> scsi: lpfc: Look up the VMID entry under vmid_lock
>
> lpfc_cmpl_ct_cmd_vmid() looks up the VMID entry for an RAPP_IDENT
> response without vport->vmid_lock and takes the lock only after the
> lookup. lpfc_vmid_get_appid() can meanwhile hash_del() another entry
> from the same bucket under the lock. hash_del() clears the next pointer
> of the removed node, so the walk stops early and misses the entry that
> waits for the response. That entry keeps LPFC_VMID_REQ_REGISTER, and
> the I/O of that VM is sent without a VMID tag from then on.
>
> Take vmid_lock before the lookup, as lpfc_vmid_get_appid() does.
>
> Fixes: 33c79741deaf ("scsi: lpfc: vmid: Introduce VMID in I/O path")
> Signed-off-by: Changyul Lee <lcy8047@gmail.com>

[Severity: Low]
33c79741deaf ("scsi: lpfc: vmid: Introduce VMID in I/O path") only touched
drivers/scsi/lpfc/lpfc_scsi.c.  The unlocked lpfc_get_vmid_from_hashtable()
call in lpfc_cmpl_ct_cmd_vmid() was added by 742b0cf87a8f ("scsi: lpfc:
vmid: Implement CT commands for appid"), so should the Fixes tag be:

  Fixes: 742b0cf87a8f ("scsi: lpfc: vmid: Implement CT commands for appid")

> diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
> index f709e50875770..af720ccdf1b6f 100644
> --- a/drivers/scsi/lpfc/lpfc_ct.c
> +++ b/drivers/scsi/lpfc/lpfc_ct.c
> @@ -3613,14 +3613,13 @@ lpfc_cmpl_ct_cmd_vmid(struct lpfc_hba *phba, stru=
ct lpfc_iocbq *cmdiocb,
> =20
>  		hash =3D lpfc_vmid_hash_fn(app->obj.entity_id,
>  					 app->obj.entity_id_len);
> +		write_lock(&vport->vmid_lock);
>  		vmp =3D lpfc_get_vmid_from_hashtable(vport, hash,
>  						  app->obj.entity_id);
>  		if (vmp) {
> -			write_lock(&vport->vmid_lock);
>  			vmp->un.app_id =3D be32_to_cpu(app->app_id);
>  			vmp->flag |=3D LPFC_VMID_REGISTERED;
>  			vmp->flag &=3D ~LPFC_VMID_REQ_REGISTER;
> -			write_unlock(&vport->vmid_lock);
>  			/* Set IN USE flag */
>  			vport->vmid_flag |=3D LPFC_VMID_IN_USE;
>  		} else {
> @@ -3628,6 +3627,7 @@ lpfc_cmpl_ct_cmd_vmid(struct lpfc_hba *phba, struct=
 lpfc_iocbq *cmdiocb,
>  					 "6901 No entry found %s hash %d\n",
>  					 app->obj.entity_id, hash);
>  		}
> +		write_unlock(&vport->vmid_lock);
>  		break;
>  	case SLI_CTAS_DAPP_IDENT:
>  		app =3D (struct app_id_object *)(DAPP_IDENT_OFFSET + data);

[Severity: High]
This problem wasn't introduced by this patch, but the SLI_CTAS_DALLAPP_ID
branch right below in lpfc_cmpl_ct_cmd_vmid() causes a NULL pointer
dereference, list corruption, and a memory leak [1]:

drivers/scsi/lpfc/lpfc_ct.c:lpfc_cmpl_ct_cmd_vmid() {
	...
	case SLI_CTAS_DALLAPP_ID:
		...
		read_lock(&vport->vmid_lock);
		for (i =3D 0; i < phba->cfg_max_vmid; i++) {
			vmp =3D &vport->vmid[i];
			if (vmp->flag !=3D LPFC_VMID_SLOT_FREE)
				memset(vmp, 0, sizeof(struct lpfc_vmid));
		}
		read_unlock(&vport->vmid_lock);
		/* for all elements in the hash table */
		if (!hash_empty(vport->hash_table))
			hash_for_each(vport->hash_table, bucket, cur, hnode)
				hash_del(&cur->hnode);
	...
}

Can this crash when deregistering all app IDs?  Zeroing vmp with memset()
while its hnode is still linked in vport->hash_table clears hnode.next and
hnode.pprev, so the subsequent hash_del(&cur->hnode) dereferences a NULL
pprev pointer.  In addition, the loop mutates vport->vmid under read_lock()
instead of write_lock(), overwrites vmp->last_io_time without calling
free_percpu(), and walks vport->hash_table without holding vport->vmid_lock
or using hash_for_each_safe().

[1] https://sashiko.dev/#/bug/linux-b856b4ae-5c8f-4fb3-812c-1d152bd8d42f

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116023939.5888=
38-1-lcy8047@gmail.com?part=3D1
