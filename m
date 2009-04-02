From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 1/5] bfa: Brocade BFA FC SCSI driver (bfad)
Date: Thu, 2 Apr 2009 11:00:47 +0200
Message-ID: <200904021100.56528.eike-kernel@sf-tec.de>
References: <200904020333.n323XCq7003685@blc-10-2.brocade.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3071260.ukBvEIbirR";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:50740 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753426AbZDBJBM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Apr 2009 05:01:12 -0400
In-Reply-To: <200904020333.n323XCq7003685@blc-10-2.brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Krishna Gudipati <kgudipat@brocade.com>
Cc: James.Bottomley@hansenpartnership.com, huangj@brocade.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, nkattang@brocade.com, rvadivel@brocade.com, vravindr@brocade.com

--nextPart3071260.ukBvEIbirR
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Krishna Gudipati wrote:
> From: Krishna Chaitanya Gudipati <kgudipat@brocade.com>
>
> This patch contains Brocade linux driver specific code that interfaces to
> upper layer linux kernel for PCI, SCSI mid-layer, sysfs related stuff. The
> code handles things such as module load/unload, PCI probe/release, handli=
ng
> interrupts, interfacing with sysfs etc. It interacts with the
> firmware/hardware via the code under files with prefix bfa_*.
>
> This patch also fixes the code review comments of Eike from our previous
> submission, we are still considering the suggestion to use devres for our
> driver and this patch does not have those changes.

I think I can find something else in the mean time ;)


> +void
> +bfad_flags_set(struct bfad_s *bfad, u32 flags)
> +{
> +	if (bfad)
> +		bfad->bfad_flags |=3D flags;
> +}

This is so trivial I doubt it needs to be a function of it's own. Also at o=
ne=20
place it is already clear that bfad is valid (the other one maybe too).

> +/**
> + *  BFA callbacks
> + */
> +void
> +bfad_hcb_comp(void *arg, bfa_status_t status)
> +{
> +	struct bfad_hal_comp *fcomp =3D (struct bfad_hal_comp *)arg;

You don't need to cast from a void* in C.

> +	fcomp->status =3D status;
> +	complete(&fcomp->comp);
> +}
> +
> +/**
> + * bfa_init callback
> + */
> +void
> +bfa_cb_init(void *drv, bfa_status_t init_status)
> +{
> +	struct bfad_s         *bfad =3D drv;

One space, no tabs.

> +	if (init_status =3D=3D BFA_STATUS_OK)
> +		bfad->bfad_flags |=3D BFAD_HAL_INIT_DONE;
> +
> +	complete(&bfad->comp);
> +}
> +
> +/**
> + * bfa_stop callback
> + */
> +void
> +bfa_cb_stop(void *drv, bfa_status_t stop_status)
> +{
> +	struct bfad_s         *bfad =3D drv;
> +
> +	/* Signal the BFAD stop waiting thread */
> +	complete(&bfad->comp);
> +}
> +
> +/**
> + * bfa_ioc_diable() callback.
> + */
> +void
> +bfa_cb_ioc_disable(void *drv)
> +{
> +	struct bfad_s         *bfad =3D drv;
> +
> +	complete(&bfad->disable_comp);
> +}
> +
> +void
> +bfa_cb_exit(struct bfad_s *drv)
> +{
> +	complete(&drv->comp);
> +}
> +
> +void
> +bfa_cb_rport_qos_scn_flowid(void *rport,
> +			struct bfa_rport_qos_attr_s old_qos_attr,
> +			struct bfa_rport_qos_attr_s new_qos_attr)
> +{
> +}
> +void
> +bfa_cb_rport_online(void *rport)
> +{
> +}
> +void
> +bfa_cb_rport_offline(void *rport)
> +{
> +}
> +void
> +bfa_cb_rport_qos_scn_prio(void *rport,
> +			struct bfa_rport_qos_attr_s old_qos_attr,
> +			struct bfa_rport_qos_attr_s new_qos_attr)
> +{
> +}
> +
> +void
> +bfa_cb_itnim_sler(void *itnim)
> +{
> +}

Kill those. They are unused anyway (at least the first two that I checked).

> +
> +/**
> + *  bfa callbacks
> + */
> +static struct bfad_port_s *
> +bfad_get_drv_port(struct bfad_s *bfad, struct bfad_vf_s *vf_drv,
> +			struct bfad_vport_s *vp_drv)
> +{
> +	return ((vp_drv) ? (&(vp_drv)->drv_port)
> +		: ((vf_drv) ? (&(vf_drv)->base_port) : (&(bfad)->pport)));
> +}

Some of the braces are superfluous. IMHO it would also be more readable if=
=20
written with if-else if-else.

> +struct bfad_port_s *
> +bfa_cb_port_new(struct bfad_s *bfad, struct bfa_lport_s *port,
> +			enum bfa_port_role roles, struct bfad_vf_s *vf_drv,
> +			struct bfad_vport_s *vp_drv)
> +{
> +	bfa_status_t    rc;
> +	struct bfad_port_s    *port_drv;
> +
> +	if (!vp_drv && !vf_drv) {
> +		port_drv =3D &bfad->pport;
> +		port_drv->pvb_type =3D BFAD_PORT_PHYS_BASE;
> +	} else if (!vp_drv && vf_drv) {
> +		port_drv =3D &vf_drv->base_port;
> +		port_drv->pvb_type =3D BFAD_PORT_VF_BASE;
> +	} else if (vp_drv && !vf_drv) {
> +		port_drv =3D &vp_drv->drv_port;
> +		port_drv->pvb_type =3D BFAD_PORT_PHYS_VPORT;
> +	} else {
> +		port_drv =3D &vp_drv->drv_port;
> +		port_drv->pvb_type =3D BFAD_PORT_VF_VPORT;
> +	}
> +	port_drv->bfa_lport =3D port;
> +	port_drv->roles =3D roles;
> +	rc =3D bfad_fc4_port_new(bfad, port_drv, roles);
> +	if (rc !=3D BFA_STATUS_OK) {
> +		bfad_fc4_port_delete(bfad, port_drv, roles);
> +		port_drv =3D NULL;
> +	}
> +
> +	return port_drv;
> +}
> +
> +void
> +bfa_cb_lport_delete(struct bfad_s *bfad, enum bfa_port_role roles,
> +			struct bfad_vf_s *vf_drv, struct bfad_vport_s *vp_drv)
> +{
> +	struct bfad_port_s    *port_drv;
> +
> +	/* this will be only called from rmmod context */
> +	if (vp_drv && !vp_drv->comp_del) {
> +		port_drv =3D bfad_get_drv_port(bfad, vf_drv, vp_drv);
> +		bfa_trc(bfad, roles);
> +		bfad_fc4_port_delete(bfad, port_drv, roles);
> +	}
> +}
> +
> +void
> +bfa_cb_lport_online(struct bfad_s *bfad, enum bfa_port_role roles,
> +			struct bfad_vf_s *vf_drv, struct bfad_vport_s *vp_drv)
> +{
> +	struct bfad_port_s *port_drv =3D bfad_get_drv_port(bfad, vf_drv, vp_drv=
);
> +
> +	if (roles & BFA_PORT_ROLE_FCP_IM)
> +		bfad_im_port_online(bfad, port_drv);
> +
> +	if (roles & BFA_PORT_ROLE_FCP_TM)
> +		bfad_tm_port_online(bfad, port_drv);
> +
> +	if ((roles & BFA_PORT_ROLE_FCP_IPFC) && ipfc_enable)
> +		bfad_ipfc_port_online(bfad, port_drv);
> +
> +	bfad_flags_set(bfad, BFAD_PORT_ONLINE);
> +}
> +
> +void
> +bfa_cb_lport_offline(struct bfad_s *bfad, enum bfa_port_role roles,
> +			struct bfad_vf_s *vf_drv, struct bfad_vport_s *vp_drv)
> +{
> +	struct bfad_port_s *port_drv =3D bfad_get_drv_port(bfad, vf_drv, vp_drv=
);
> +
> +	if (roles & BFA_PORT_ROLE_FCP_IM)
> +		bfad_im_port_offline(bfad, port_drv);
> +
> +	if (roles & BFA_PORT_ROLE_FCP_TM)
> +		bfad_tm_port_offline(bfad, port_drv);
> +
> +	if ((roles & BFA_PORT_ROLE_FCP_IPFC) && ipfc_enable)
> +		bfad_ipfc_port_offline(bfad, port_drv);
> +}
> +
> +void
> +bfa_cb_vf_stop(struct bfad_vf_s *vf_drv)
> +{
> +}
> +
> +void
> +bfa_cb_vport_delete(struct bfad_vport_s *vport_drv)
> +{
> +	bfa_trc(vport_drv->drv_port.bfad, (int)vport_drv->comp_del);
> +	if (vport_drv->comp_del) {
> +		complete(vport_drv->comp_del);
> +		return;
> +	}
> +
> +	kfree(vport_drv);
> +}
> +
> +/**
> + * FCS RPORT alloc callback, after successful PLOGI by FCS
> + */
> +bfa_status_t
> +bfa_cb_rport_alloc(struct bfad_s *bfad, struct bfa_rport_s *rport,
> +		    struct bfad_rport_s **rport_drv)
> +{
> +	bfa_status_t    rc =3D BFA_STATUS_OK;
> +
> +	*rport_drv =3D kzalloc(sizeof(struct bfad_rport_s), GFP_ATOMIC);

sizeof(**rport_drv): this will get you the correct size of whatever type th=
is=20
variable is.

> +	if (*rport_drv =3D=3D NULL) {
> +		rc =3D BFA_STATUS_ENOMEM;
> +		goto ext;
> +	}
> +	(*rport_drv)->rport =3D rport;
> +ext:
> +	return rc;
> +}

This is a bit few code for that goto style exit.

> +/**
> + * FCS RPORT free callback.
> + */
> +void
> +bfa_cb_rport_free(struct bfad_s *bfad, struct bfad_rport_s **rport_drv)
> +{
> +	kfree(*rport_drv);
> +}

Looks unused.

> +
> +
> +

Too much whitespace.

> +void
> +bfad_hal_mem_release(struct bfad_s *bfad)
> +{
> +	int             i;
> +	struct bfa_meminfo_s *hal_meminfo =3D &bfad->meminfo;
> +	struct bfa_mem_elem_s *meminfo_elem;
> +
> +	for (i =3D 0; i < BFA_MEM_TYPE_MAX; i++) {

i < ARRAY_SIZE(hal_meminfo->meminfo)

> +		meminfo_elem =3D &hal_meminfo->meminfo[i];
> +		if (meminfo_elem->kva !=3D NULL) {
> +			switch (meminfo_elem->mem_type) {
> +			case BFA_MEM_TYPE_KVA:
> +				vfree(meminfo_elem->kva);
> +				break;
> +			case BFA_MEM_TYPE_DMA:
> +				bfad_os_dma_free(bfad, meminfo_elem);
> +				break;
> +			default:
> +				bfa_assert(0);
> +				break;
> +			}
> +		}
> +	}
> +
> +	memset(hal_meminfo, 0, sizeof(struct bfa_meminfo_s));

sizeof(*hal_meminfo)

> +}
> +
> +void
> +bfad_update_hal_cfg(struct bfa_iocfc_cfg_s *bfa_cfg)
> +{
> +	if (num_rports > 0)
> +		bfa_cfg->fwcfg.num_rports =3D num_rports;
> +	if (num_ios > 0)
> +		bfa_cfg->fwcfg.num_ioim_reqs =3D num_ios;
> +	if (num_tms > 0)
> +		bfa_cfg->fwcfg.num_tskim_reqs =3D num_tms;
> +	if (num_fcxps > 0)
> +		bfa_cfg->fwcfg.num_fcxp_reqs =3D num_fcxps;
> +	if (num_ufbufs > 0)
> +		bfa_cfg->fwcfg.num_uf_bufs =3D num_ufbufs;
> +	if (reqq_size > 0)
> +		bfa_cfg->drvcfg.num_reqq_elems =3D reqq_size;
> +	if (rspq_size > 0)
> +		bfa_cfg->drvcfg.num_rspq_elems =3D rspq_size;
> +	if (num_sgpgs > 0)
> +		bfa_cfg->drvcfg.num_sgpgs =3D num_sgpgs;

What happens if num_* is 0? No need to update that value then? I mean, if=20
there were more ports and then the next scan gives 0, shouldn't they be res=
et=20
to 0? I must confess I have not checked when this is called ...

> +	/* TODO read role from config file FCS_BRINGUP*/
> +	bfa_cfg->drvcfg.bport_role =3D BFA_PORT_ROLE_FCP_IM;
> +
> +}
> +
> +bfa_status_t
> +bfad_hal_mem_alloc(struct bfad_s *bfad)
> +{
> +	int             i;
> +	struct bfa_meminfo_s *hal_meminfo =3D &bfad->meminfo;
> +	struct bfa_mem_elem_s *meminfo_elem;
> +	dma_addr_t      phys_addr;
> +	void           *kva;
> +	bfa_status_t    rc =3D BFA_STATUS_OK;
> +
> +	bfa_cfg_get_default(&bfad->ioc_cfg);
> +	bfad_update_hal_cfg(&bfad->ioc_cfg);
> +	bfad->cfg_data.ioc_queue_depth =3D bfad->ioc_cfg.fwcfg.num_ioim_reqs ;
> +	bfa_cfg_get_meminfo(&bfad->ioc_cfg, hal_meminfo);
> +
> +	for (i =3D 0; i < BFA_MEM_TYPE_MAX; i++) {
> +		meminfo_elem =3D &hal_meminfo->meminfo[i];
> +		switch (meminfo_elem->mem_type) {
> +		case BFA_MEM_TYPE_KVA:
> +			kva =3D vmalloc(meminfo_elem->mem_len);
> +			if (kva =3D=3D NULL) {
> +				bfad_hal_mem_release(bfad);
> +				rc =3D BFA_STATUS_ENOMEM;
> +				goto ext;

If you goto ext here instead of just "return BFA_STATUS_ENOMEM" then you=20
should add an error goto target to share with the next case. And why not us=
e=20
ENOMEM anyway?

I'm stopping here because of lacking time. What I found hard is that you sp=
lit=20
the headers into a different patch. In fact you need not to split that into=
=20
pieces at all as all patches touch different code areas but are only usable=
=20
together, noone will ever have a chance to end up in the middle of this=20
patches searching for a problem in this driver. Ok, could be to reduce the=
=20
size of the mail itself, which is ok but for the final submission.

I see people doing this all the time but I think it does harm: these commit=
s=20
add extra noise when doing git-bisect to find something and one commit by=20
itself can not work as the other parts are essential to make them work at=20
all.

One other thing that I find personally disturbing: you do not send your "PA=
TCH=20
n/5" mails as replies to the "PATCH 0/5" mail. This would keep the=20
discussions together in peoples mailers so they are easier to follow (or=20
ignore, YMMV *g*).

Anyway, thanks for your work ;) No pun intended.

Eike

--nextPart3071260.ukBvEIbirR
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAknUfsgACgkQXKSJPmm5/E6DwACggMWskMgT/9PmoUUGVdsVuKNt
+h4An0RBY7g67IngsRb08O/MGJoabYAz
=HFCd
-----END PGP SIGNATURE-----

--nextPart3071260.ukBvEIbirR--
