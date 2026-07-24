Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF92361656
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 18:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784916980; cv=none; b=rCoaawKyqdJKhJ3P6z6bpD2r0ebd5sOsf8Pd6AF1qeX7PDroeBb2Dr0TJecYM2zjXz3L814jcbPRVbF70+iT71TC6NQZ0pIsn80kH6SnF6P/cOjmo4k+HySpccrLx+iJcxLzbz7ViAvsnCZT6XztLuLQTeIdjrN/BTPYWjkZh5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784916980; c=relaxed/simple;
	bh=52Oer+X/m3vuGs9MzZ44nrSjX1iELNDDNF4SoIlyE3Y=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GQwjxQIERsuMxVfE6/wPAlKn/19rnC8J11qF3+y4z8v2x8RlWlveyIe5Vr/LGjkmCWsn7RwVr7E8PL7eiPVBveL2lDsfppoZYOKOvXfNe6xB7hxSAh/HCuT8g3uHRVLdNc9GqEgDwWDWg6Izg+pL7RzYGokWidpYw46PY4/MWDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iuO9xu21; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iuO9xu21"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 376901F000E9;
	Fri, 24 Jul 2026 18:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784916978;
	bh=+sZGGm34tGUzV3RB/UbgecuiniBPwUX6PESGbIqOe2I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iuO9xu21uNAGYVjLGczS4gFiyFDkwzPM3ow97UnyIyMAQ0Ynv9SdnZXKEJE/yiqz9
	 wy8QvSNj3FVYSqnlGEcUNGwUoNqwSyck6DoXrFmOcx9a+u1IlYnZfQFkOH4v89Qg9U
	 FD/5DwEKrjjEttNC12TTN5CW9DYJhij4aMzReE8C1MMqDIkJZzz54TaEKFzXTgzz+R
	 I8jHo2M0wN0GxQcxV73WUmxgaYBMOLm60EtsPlJthKvNTpr7aKOIU8Il0oKfAZ7MtU
	 oyiCyHDfCGvaB9FJib24TbGfruNywgP3pW6SUoRrzFZh+6Xhfujbuhh/Sz6oB6fpB5
	 LeR+SwFV6ymcw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 01/13] scsi: fnic: Make debug logging protocol
 independent
Reply-To: sashiko-reviews@lists.linux.dev
To: "Karan Tilak Kumar" <kartilak@cisco.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260724174811.5118-2-kartilak@cisco.com>
References: <20260724174811.5118-1-kartilak@cisco.com>
 <20260724174811.5118-2-kartilak@cisco.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 18:16:17 +0000
Message-Id: <20260724181618.376901F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 12 potential issue=
(s) to consider:

New issues:
- [Critical] Shared FCP/NVMe completion paths dereference `fnic->host` unco=
nditionally, causing a panic in NVMe mode where the SCSI host is not instan=
tiated.
- [Low] Type mismatch in the `fnic_printk` macro's conditional expression c=
auses a hard compiler error.

Pre-existing issues:
- [High] Calling `timer_delete_sync()` on `fdmi_timer` while holding `fnic-=
>fnic_lock` causes an AB-BA deadlock with the timer callback.
- [High] Dropping `fnic->fnic_lock` inside `fnic_del_tport_timer_sync()` ex=
poses `tport` to concurrent deletion and freeing, leading to Use-After-Free.
- [High] Processing a crafted FIP VLAN response with a 0-length descriptor =
triggers an infinite loop.
- [High] Missing packet size validation allows a malicious `fip_dl_len` to =
cause out-of-bounds heap reads.
- [High] Concurrent modification of `fnic->tx_queue` causes linked list cor=
ruption.
- [High] If frame allocation fails in ABTS or FDMI send paths, the retry ti=
mer is not armed, causing discovery state machines to stall permanently.
- [High] Use-After-Free during `tport_list` iteration due to dropping list-=
protecting lock inside `list_for_each_entry_safe()`.
- [High] Data race on shared struct member `fnic->lock_flags` during `spin_=
lock_irqsave()`, leading to incorrect IRQ restoration.
- [High] Buffer over-read in `fdls_process_gpn_ft_tgt_list` due to an unadj=
usted loop boundary.
- [High] Missing bounds check on `rscn_plen` in `fdls_process_rscn` allows =
reading past the end of the packet buffer.
--

--- Patch [1]: [PATCH v6 01/13] scsi: fnic: Make debug logging protocol ind=
ependent ---
commit 6ab638cfc2207fddc47d1f2bf78b1c2631f3d96a
Author: Karan Tilak Kumar <kartilak@cisco.com>

scsi: fnic: Make debug logging protocol independent

This commit makes fnic debug macros take struct fnic instead of struct Scsi=
_Host
so that FCP and NVMe initiator roles can share the logging interface. It ad=
ds
fnic_printk() to handle routing the messages correctly depending on the rol=
e.

> diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
> index 8724d64f25253..ad152fb4c15fa 100644
> --- a/drivers/scsi/fnic/fnic.h
> +++ b/drivers/scsi/fnic/fnic.h
[ ... ]
> @@ -249,38 +255,39 @@ do {								\
>  		} while (0);					\
>  } while (0)
> =20
> -#define FNIC_MAIN_DBG(kern_level, host, fnic_num, fmt, args...)		\
> -	FNIC_CHECK_LOGGING(FNIC_MAIN_LOGGING,			\
> -			 shost_printk(kern_level, host,			\
> -				"fnic<%d>: %s: %d: " fmt, fnic_num,\
> -				__func__, __LINE__, ##args);)
> -
[ ... ]
> +#define fnic_printk(kern_level, fnic, fmt, ...)                      \
> +	(IS_FNIC_FCP_INITIATOR(fnic) ?                                   \
> +	shost_printk(kern_level, fnic->host, "fnic<%d>: %s: %d: " fmt,   \
> +				fnic->fnic_num, __func__, __LINE__, ##__VA_ARGS__) : \
> +	printk(kern_level "fnic<%d>: %s: %d: " fmt, fnic->fnic_num,      \
> +				__func__, __LINE__, ##__VA_ARGS__))

[Severity: Low]
Does this ternary operator in fnic_printk cause a compiler error?

The true branch evaluates to shost_printk() which returns void (via dev_pri=
ntk),
while the false branch evaluates to printk() which returns int. C standards
require both branches of a conditional operator to have compatible types.
Could the printk branch be cast to (void) to fix this?

[ ... ]
> @@ -325,6 +332,7 @@ enum fnic_state {
> =20
>  enum fnic_role_e {
>  	FNIC_ROLE_FCP_INITIATOR =3D 0,
> +	FNIC_ROLE_NVME_INITIATOR,
>  };

[Severity: Critical]
With the introduction of the NVMe initiator role, fnic->host can be NULL.
However, shared completion paths like fnic_fcpio_fw_reset_cmpl_handler()
unconditionally call fnic_cleanup_io(), which then calls
scsi_host_busy_iter(fnic->host, ...) and fnic_count_all_ioreqs().

Could this unconditionally dereference the NULL fnic->host pointer when
running in NVMe mode, leading to a kernel panic?

> diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
> index 554dea7678854..5880ca28a0ad9 100644
> --- a/drivers/scsi/fnic/fdls_disc.c
> +++ b/drivers/scsi/fnic/fdls_disc.c
> @@ -194,7 +194,7 @@ void fdls_reclaim_oxid_handler(struct work_struct *wo=
rk)
>  	struct reclaim_entry_s *reclaim_entry, *next;
>  	unsigned long delay_j, cur_jiffies;
> =20
> -	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
> +	FNIC_FCS_DBG(KERN_INFO, fnic,
>  		"Reclaim oxid callback\n");
> =20
>  	spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);

[Severity: High]
This isn't a bug introduced by this patch, but using the shared struct memb=
er
fnic->lock_flags for spin_lock_irqsave() could result in a data race.

If two CPUs execute this concurrently, they will overwrite each other's
saved interrupt state. Could this cause spin_unlock_irqrestore() to restore
incorrect interrupt states, potentially leaving IRQs disabled incorrectly?
It might be safer to use a local stack variable for the flags instead.

[ ... ]
> @@ -687,7 +687,7 @@ static void fdls_send_fabric_abts(struct fnic_iport_s=
 *iport)
> =20
>  	frame =3D fdls_alloc_frame(iport);
>  	if (frame =3D=3D NULL) {
> -		FNIC_FCS_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
> +		FNIC_FCS_DBG(KERN_ERR, fnic,
>  				"Failed to allocate frame to send fabric ABTS");
>  		return;
>  	}

[Severity: High]
This is a pre-existing issue, but if fdls_alloc_frame() fails here and
returns immediately, it skips arming the retry timer for the ABTS.

Will this cause the discovery state machine to stall permanently since no
further events will drive it forward?

[ ... ]
> @@ -2555,7 +2567,7 @@ fdls_process_tgt_adisc_rsp(struct fnic_iport_s *ipo=
rt,
>  	case ELS_LS_ACC:
>  		atomic64_inc(&iport->iport_stats.tport_adisc_ls_accepts);
>  		if (tport->timer_pending) {
> -			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
> +			FNIC_FCS_DBG(KERN_INFO, fnic,
>  						 "tport 0x%p Canceling fabric disc timer\n",
>  						 tport);
>  			fnic_del_tport_timer_sync(fnic, tport);
>  		}
>  		tport->timer_pending =3D 0;

[Severity: High]
This isn't a bug introduced by this patch, but dropping the fnic->fnic_lock
inside fnic_del_tport_timer_sync() seems to expose tport to concurrent free=
ing.

If another thread (e.g. handling a link down) invokes fdls_delete_tport(),
the tport could be freed before fnic_del_tport_timer_sync() returns.
When the caller accesses tport->timer_pending =3D 0 upon return, could this
lead to a use-after-free crash?

[ ... ]
> @@ -3185,7 +3197,7 @@ fdls_process_gpn_ft_tgt_list(struct fnic_iport_s *i=
port,
>  		fcid =3D ntoh24(gpn_ft_tgt->fcid);
>  		wwpn =3D be64_to_cpu(gpn_ft_tgt->wwpn);
> =20
> -		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
> +		FNIC_FCS_DBG(KERN_INFO, fnic,
>  				 "tport: 0x%x: ctrl:0x%x", fcid, gpn_ft_tgt->ctrl);
> =20
>  		if (fcid =3D=3D iport->fcid) {
> @@ -3232,7 +3244,7 @@ fdls_process_gpn_ft_tgt_list(struct fnic_iport_s *i=
port,
>  		rem_len -=3D sizeof(struct fc_gpn_ft_rsp_iu);
>  	}

[Severity: High]
This is a pre-existing issue, but is the bounds check for rem_len correct?

In fdls_process_gpn_ft_tgt_list(), rem_len is initialized to the total leng=
th
but is not reduced by the size of the FC and CT headers (40 bytes) when the
pointer is advanced past them. Could the while (rem_len > 0) loop process
memory past the physical buffer, leading to an out-of-bounds read if the li=
st
is not naturally terminated by the FC_NS_FID_LAST bit?

[ ... ]
> @@ -3368,7 +3380,7 @@ fdls_process_gpn_ft_rsp(struct fnic_iport_s *iport,
>  			count =3D 0;
>  			list_for_each_entry_safe(tport, next, &iport->tport_list,
>  									 links) {
> -				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
> +				FNIC_FCS_DBG(KERN_INFO, fnic,
>  							 "GPN_FT_REJECT: Remove port: 0x%x",
>  							 tport->fcid);
>  				fdls_delete_tport(iport, tport);

[Severity: High]
This is a pre-existing issue, but is there a use-after-free risk during this
list iteration?

The loop uses list_for_each_entry_safe() and calls fdls_delete_tport().
Inside fdls_delete_tport(), fnic_lock is temporarily dropped to execute
fnic_rport_exch_reset(). Since the lock is dropped, concurrent threads could
remove and free the 'next' element. When the lock is reacquired and the loop
continues, dereferencing 'next' might trigger a use-after-free.

[ ... ]
> @@ -3738,13 +3750,13 @@ static void fdls_process_fdmi_reg_ack(struct fnic=
_iport_s *iport,
>  		fdls_free_oxid(iport, oxid, &iport->active_oxid_fdmi_rpa);
>  	}
> =20
> -	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
> +	FNIC_FCS_DBG(KERN_INFO, fnic,
>  		"iport fcid: 0x%x: Received FDMI registration ack\n",
>  		 iport->fcid);
> =20
>  	if (!iport->fabric.fdmi_pending) {
>  		timer_delete_sync(&iport->fabric.fdmi_timer);
> -		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
> +		FNIC_FCS_DBG(KERN_INFO, fnic,
>  					 "iport fcid: 0x%x: Canceling FDMI timer\n",
>  					 iport->fcid);
>  	}

[Severity: High]
This is a pre-existing issue, but can calling timer_delete_sync() while
holding the fnic->fnic_lock cause a deadlock here?

If the fdmi_timer expires concurrently, its callback fdls_fdmi_timer_callba=
ck()
will spin waiting for fnic->fnic_lock, while timer_delete_sync() spins
waiting for the callback to finish.

[ ... ]
> @@ -4508,18 +4520,18 @@ fdls_process_rscn(struct fnic_iport_s *iport, str=
uct fc_frame_header *fchdr)
>  		if ((rscn_payload_len =3D=3D 0xFFFF)
>  		    && (sid =3D=3D FC_FID_FCTRL)) {
>  			rscn_type =3D PC_RSCN;
> -			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
> +			FNIC_FCS_DBG(KERN_INFO, fnic,
>  				     "pcrscn: PCRSCN received. sid: 0x%x payload len: 0x%x",
>  				     sid, rscn_payload_len);

[Severity: High]
This is a pre-existing issue, but could an artificially large rscn_plen
cause out-of-bounds memory reads?

The rscn_payload_len is trusted to calculate num_ports, but it doesn't appe=
ar
to be cross-referenced against the actual length of the received Ethernet
frame. Could a maliciously crafted short frame with a large rscn_plen
trigger an out-of-bounds read?

> diff --git a/drivers/scsi/fnic/fip.c b/drivers/scsi/fnic/fip.c
> index 132f00512ee16..21d08a710f0df 100644
> --- a/drivers/scsi/fnic/fip.c
> +++ b/drivers/scsi/fnic/fip.c
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
This isn't a bug introduced by this patch, but does the parser handle
0-length descriptors safely?

If a malicious FIP packet contains a descriptor where fip_dlen is 0,
cur_desc and desc_len will remain unchanged when advancing. Could this lead
to an infinite loop while holding the fnic->vlans_lock spinlock?

[ ... ]
> @@ -617,7 +609,7 @@ void fnic_fcoe_process_cvl(struct fnic *fnic, struct =
fip_header *fiph)
>  	    || !((cvl_msg->name_desc.fd_desc.fip_dtype =3D=3D 4)
>  		 && (cvl_msg->name_desc.fd_desc.fip_dlen =3D=3D 3))) {
> =20
> -		FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
> +		FNIC_FIP_DBG(KERN_INFO, fnic,
>  			     "invalid mix: ft %x fl %x ndt %x ndl %x",
>  			     cvl_msg->fcf_mac_desc.fd_desc.fip_dtype,
>  			     cvl_msg->fcf_mac_desc.fd_desc.fip_dlen,
> @@ -640,8 +632,7 @@ void fnic_fcoe_process_cvl(struct fnic *fnic, struct =
fip_header *fiph)
>  			if (!((cvl_msg->vn_ports_desc[i].fd_desc.fip_dtype =3D=3D 11)
>  			      && (cvl_msg->vn_ports_desc[i].fd_desc.fip_dlen =3D=3D 5))) {
> =20
> -				FNIC_FIP_DBG(KERN_INFO, fnic->host,
> -					     fnic->fnic_num,
> +				FNIC_FIP_DBG(KERN_INFO, fnic,
>  					     "Invalid type and len mix type: %d len: %d\n",
>  					     cvl_msg->vn_ports_desc[i].fd_desc.fip_dtype,
>  					     cvl_msg->vn_ports_desc[i].fd_desc.fip_dlen);

[Severity: High]
This is a pre-existing issue, but could the unvalidated fip_dl_len allow
out-of-bounds heap reads?

The loop iterates based on the fip_dl_len field from the untrusted remote
packet header, without verifying it against the actual received buffer size.
An inflated length could cause the loop to read past the end of the packet
buffer when accessing cvl_msg->vn_ports_desc[i].fd_mac.

> diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
> index 063eb864a5cd0..ca592bc3f6182 100644
> --- a/drivers/scsi/fnic/fnic_fcs.c
> +++ b/drivers/scsi/fnic/fnic_fcs.c
> @@ -778,7 +778,7 @@ void fnic_flush_tx(struct work_struct *work)
>  	struct fc_frame *fp;
>  	struct fnic_frame_list *cur_frame, *next;
> =20
> -	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
> +	FNIC_FCS_DBG(KERN_INFO, fnic,
>  				 "Flush queued frames");
> =20
>  	list_for_each_entry_safe(cur_frame, next, &fnic->tx_queue, links) {

[Severity: High]
This is a pre-existing issue, but is it safe to iterate and modify
fnic->tx_queue without acquiring any locks here?

Concurrently, fdls_send_fcoe_frame() adds new frames to tx_queue. If
these run at the same time, could it corrupt the linked list?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724174811.5118=
-1-kartilak@cisco.com?part=3D1
