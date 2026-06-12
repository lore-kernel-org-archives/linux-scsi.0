Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851ED23C4FA
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 18:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781289754; cv=none; b=mS7AN7/2Tr4wMOj1sRTm0/NVw1PBN071lWynJx4DA/2ZcafVys5KSIcrRwwE8U961oo5XEtyOqsglbFFQrEnE+XqKe+xrsG5KAq2ETP0GX1hVIXFE4SviG7XSAIjxBrWOR9j2KrQm3KiEAvFsOvkiq0t4+fP713M2YQTCWUQZak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781289754; c=relaxed/simple;
	bh=aUww+IGi+8aVWTblWiHnnPF0KqUSg1Wxjg+wlybzqkg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Z3RlpOASQT5jJu6sWYvO0t8mxflnApXJ8WGU6hDmHMlfA7yVHnJlsTXLLQmqoYWQ/BQ5uqqWq7bZKVmydznuzB/pHXArrECX97VFEPzPmnK10pPUPzCp3wIPT/u3C+n7EreuA2MjoyPEm6g5r+dpxGU/PeF5j3PCyFJNQTsMP0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RZ3t8/NX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RZ3t8/NX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FDAB1F000E9;
	Fri, 12 Jun 2026 18:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781289753;
	bh=88n5haN85b2ZdXdPiNRwBqLOUE18a6Ulk9vjuxmkJxI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RZ3t8/NXSgM+PlaGGjza3QT/56fQw5G++KOEKfmebSw7KjEh3sGuuOc/8Qh5XjVEC
	 5aS0BVGNud62JCLS86hwKnYOQpKwJmG9rsUvMwrb4rb0odytmlAYUrL/Q2QUIo/yRZ
	 oHZzjEsiKUEo+R/3edONLIgBMgjos2YiX5nINI8bipf2EKUGbKk5X3OO8oNLK2C9Ji
	 E4Xf3CV6vgGNF5dxeb85JgF6JG0eaNUbUs3ugd0Plg2KR3k7FdInpp6PhwJutuUZVe
	 Epoj5i1rL4vcKTM4WAPvNoW3Pvydi2K9choZShj5kbLypMtYfZ/9g+DNGz9T4ea5Zq
	 GptPABtHujfbA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 01/13] scsi: fnic: Make debug logging protocol
 independent
Reply-To: sashiko-reviews@lists.linux.dev
To: "Karan Tilak Kumar" <kartilak@cisco.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260612180918.8554-2-kartilak@cisco.com>
References: <20260612180918.8554-2-kartilak@cisco.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 18:42:32 +0000
Message-Id: <20260612184233.1FDAB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 10 potential issue=
(s) to consider:

Pre-existing issues:
- [High] Workqueue corruption due to dynamic INIT_WORK on a shared work_str=
uct in timer callbacks.
- [High] Infinite loop in FIP VLAN parsing caused by zero-length descriptor=
s.
- [High] Out-of-bounds read in fdls_process_gpn_ft_tgt_list due to unadjust=
ed payload length.
- [High] Memory leak of control frames when fnic_send_fcoe_frame() fails.
- [High] OXID allocation permanently halts due to missing wrap-around searc=
h in find_next_zero_bit.
- [High] Use-after-free (UAF) due to missing cancellation of delayed works =
and timers in fnic_remove.
- [High] Use-after-free caused by dropping a spinlock inside list_for_each_=
entry_safe.
- [High] Out-of-bounds memory read in FIP parsing because actual packet len=
gth is discarded.
- [High] Out-of-bounds memory read when processing spoofed RSCN payload len=
gths.
- [Medium] Memory leak of target port (tport) when event allocation fails i=
n fdls_delete_tport.
--

commit ef42b3354b5f1530ee27d88277ffc1381b470972
Author: Karan Tilak Kumar <kartilak@cisco.com>
Subject: scsi: fnic: Make debug logging protocol independent

This patch updates the fnic debug macros to take a fnic structure rather
than a Scsi_Host. This allows FCP and NVMe initiator roles to share the same
logging interface. It also adds role predicates and logging masks to proper=
ly
route output to the appropriate reporting mechanism.

> diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
> index 554dea7678854..5880ca28a0ad9 100644
> --- a/drivers/scsi/fnic/fdls_disc.c
> +++ b/drivers/scsi/fnic/fdls_disc.c
[ ... ]
> @@ -136,7 +136,7 @@ uint16_t fdls_alloc_oxid(struct fnic_iport_s *iport, =
int oxid_frame_type,
>  	 */
>  	idx =3D find_next_zero_bit(oxid_pool->bitmap, FNIC_OXID_POOL_SZ, oxid_p=
ool->next_idx);
>  	if (idx =3D=3D FNIC_OXID_POOL_SZ) {
> -		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
> +		FNIC_FCS_DBG(KERN_INFO, fnic,
>  			"Alloc oxid: all oxid slots are busy iport state:%d\n",
>  			iport->state);
>  		return FNIC_UNASSIGNED_OXID;

[Severity: High]
This is a pre-existing issue, but does this logic permanently halt allocati=
on=20
if it reaches the end of the pool? If find_next_zero_bit() starts at
oxid_pool->next_idx and reaches FNIC_OXID_POOL_SZ, it appears to return an
error rather than wrapping around to index 0 to search the rest of the
bitmap. Because next_idx is not advanced on failure, all subsequent
allocations might search the same empty tail and fail indefinitely.

[ ... ]
> @@ -1272,9 +1272,9 @@ bool fdls_delete_tport(struct fnic_iport_s *iport, =
struct fnic_tport_s *tport)
>  		tport_del_evt =3D
>  			kzalloc_obj(struct fnic_tport_event_s, GFP_ATOMIC);
>  		if (!tport_del_evt) {
> -			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
> -				 "Failed to allocate memory for tport fcid: 0x%0x\n",
> -				 tport->fcid);
> +			FNIC_FCS_DBG(KERN_INFO, fnic,
> +					"iport: 0x%x tport 0x%x: Failed to allocate memory\n",
> +					iport->fcid, tport->fcid);
>  			return false;
>  		}
>  		tport_del_evt->event =3D TGT_EV_RPORT_DEL;

[Severity: Medium]
This isn't a bug introduced by this patch, but does returning false here
leak the tport structure? If kzalloc_obj() fails, the target port remains
in the iport->tport_list despite being marked OFFLINING and TERMINATING.

[ ... ]
> @@ -1330,7 +1330,7 @@ fdls_send_tgt_plogi(struct fnic_iport_s *iport, str=
uct fnic_tport_s *tport)
>  	hton24(d_id, tport->fcid);
>  	FNIC_STD_SET_D_ID(pplogi->fchdr, d_id);
> =20
> -	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
> +	FNIC_FCS_DBG(KERN_INFO, fnic,
>  				 "0x%x: FDLS send tgt PLOGI to tgt: 0x%x with oxid: 0x%x",
>  				 iport->fcid, tport->fcid, oxid);
> =20

[Severity: High]
This is a pre-existing issue, but are we leaking control frames if the
transmission fails? In fdls_send_tgt_plogi(), fnic_send_fcoe_frame() is
called right after this debug statement, but its return value is ignored.
If the underlying DMA mapping or workqueue is full, does the allocated
mempool frame stay permanently leaked?

[ ... ]
> @@ -3232,7 +3244,7 @@ fdls_process_gpn_ft_tgt_list(struct fnic_iport_s *i=
port,
>  		rem_len -=3D sizeof(struct fc_gpn_ft_rsp_iu);
>  	}
>  	if (rem_len <=3D 0) {
> -		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
> +		FNIC_FCS_DBG(KERN_INFO, fnic,
>  			 "GPN_FT response: malformed/corrupt frame rxlen: %d remlen: %d",
>  			 len, rem_len);
>  }

[Severity: High]
This isn't a bug introduced by this patch, but does the payload parsing read
out of bounds here? Earlier in fdls_process_gpn_ft_tgt_list(), len is
adjusted by subtracting the FC and CT headers, but rem_len is initialized to
the original unadjusted len. Does the while (rem_len > 0) loop process extra
bytes past the end of the packet if the FC_NS_FID_LAST bit is missing?

> @@ -3242,7 +3254,7 @@ fdls_process_gpn_ft_tgt_list(struct fnic_iport_s *i=
port,
>  		list_for_each_entry_safe(tport, next, &iport->tport_list, links) {
> =20
>  			if (!(tport->flags & FNIC_FDLS_TPORT_IN_GPN_FT_LIST)) {
> -				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
> +				FNIC_FCS_DBG(KERN_INFO, fnic,
>  					 "Remove port: 0x%x not found in GPN_FT list",
>  					 tport->fcid);
>  				fdls_delete_tport(iport, tport);

[Severity: High]
This is a pre-existing issue, but could this loop trigger a use-after-free?
The list_for_each_entry_safe() loop caches the next pointer. However,
fdls_delete_tport() intentionally drops the fnic->fnic_lock internally.
While the lock is dropped, can a concurrent event delete the cached next
element from the list?

[ ... ]
> @@ -4527,7 +4539,7 @@ fdls_process_rscn(struct fnic_iport_s *iport, struc=
t fc_frame_header *fchdr)
>  		num_ports =3D (rscn_payload_len - 4) / rscn->els.rscn_page_len;
>  		rscn_port =3D (struct fc_els_rscn_page *)(rscn + 1);
>  	}
> -	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
> +	FNIC_FCS_DBG(KERN_INFO, fnic,
>  			 "RSCN received for num_ports: %d payload_len: %d page_len: %d ",
>  		     num_ports, rscn_payload_len, rscn->els.rscn_page_len);
> =20

[Severity: High]
This is a pre-existing issue, but does this code trust the RSCN payload
length blindly? The rscn_payload_len variable is read directly from the
network packet without validating it against the actual received buffer
length. If a spoofed frame specifies a large length, does this loop read
out-of-bounds?

> diff --git a/drivers/scsi/fnic/fip.c b/drivers/scsi/fnic/fip.c
> index 132f00512ee16..21d08a710f0df 100644
> --- a/drivers/scsi/fnic/fip.c
> +++ b/drivers/scsi/fnic/fip.c
[ ... ]
> @@ -155,14 +152,14 @@ void fnic_fcoe_process_vlan_resp(struct fnic *fnic,=
 struct fip_header *fiph)
>  			list_add_tail(&vlan->list, &fnic->vlan_list);
>  			break;
>  		}
> -		FNIC_FIP_DBG(KERN_INFO, fnic->host,
> -			     fnic->fnic_num,
> -			     "Invalid descriptor type(%x) in VLan response\n",
> -			     vlan_desc->fd_desc.fip_dtype);
>  		/*
> -		 * Note : received a type=3D2 descriptor here i.e. FIP
> -		 * MAC Address Descriptor
> +		 * Note : skip any type=3D2 descriptor here
> +		 * (i.e. FIP MAC Address Descriptor)
>  		 */
> +		if (vlan_desc->fd_desc.fip_dtype !=3D FIP_DT_MAC)
> +			FNIC_FIP_DBG(KERN_INFO, fnic,
> +				     "Invalid descriptor type(0x%x) in vlan response\n",
> +				     vlan_desc->fd_desc.fip_dtype);
>  		cur_desc +=3D vlan_desc->fd_desc.fip_dlen;
>  		desc_len -=3D vlan_desc->fd_desc.fip_dlen;
>  	}

[Severity: High]
This is a pre-existing issue, but can this loop run infinitely if
vlan_desc->fd_desc.fip_dlen is 0? The while (desc_len > 0) loop would
fail to advance cur_desc or decrement desc_len. Because this function runs
with interrupts disabled (spin_lock_irqsave), could a maliciously crafted
zero-length descriptor cause a hard lockup?

[ ... ]
> @@ -706,13 +706,13 @@ int fdls_fip_recv_frame(struct fnic *fnic, void *fr=
ame)
>  		return true;
>  	}
> =20
> -	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
> +	FNIC_FCS_DBG(KERN_INFO, fnic,
>  		"Not a FIP Frame");
>  	return false;
>  }

[Severity: High]
This isn't a bug introduced by this patch, but does the FIP parsing read
out of bounds here? At the start of fdls_fip_recv_frame(), the packet length
appears to be hardcoded to 2048 instead of using the actual received frame
size. If a packet declares large descriptors but the actual payload is smal=
l,
would parsing read past the end of the buffer?

> =20
>  void fnic_work_on_fip_timer(struct work_struct *work)
>  {
>  	struct fnic *fnic =3D container_of(work, struct fnic, fip_timer_work);
>  	struct fnic_iport_s *iport =3D &fnic->iport;
> =20
> -	FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
> +	FNIC_FIP_DBG(KERN_INFO, fnic,
>  		     "FIP timeout\n");

[Severity: High]
This is a pre-existing issue, but is the shared fip_timer_work susceptible
to workqueue corruption? It appears that fnic_handle_fip_timer() and
fnic_handle_fcs_ka_timer() unconditionally call INIT_WORK on=20
fnic->fip_timer_work before queuing it. If these fire concurrently or if one
queues the work while it is already pending/executing, does INIT_WORK
corrupt the active work_struct linked list pointers?

General Observations
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

[Severity: High]
This is a pre-existing issue, but does fnic_remove() tear down resources
safely? During driver teardown, fnic_remove() frees the fnic structure but
fails to cancel oxid_pool.oxid_reclaim_work,
oxid_pool.schedule_oxid_free_retry, and iport.fabric.retry_timer. If any of
these delayed works or timers fire after teardown, could they execute their
callbacks and access the freed fnic structure, causing a use-after-free
crash?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612180918.8554=
-1-kartilak@cisco.com?part=3D1
