From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] csiostor: Use list_for_each_safe instead of re-implementing it
Date: Thu, 16 Jul 2015 08:50:11 +0200
Message-ID: <mqd1tg8y4t8.fsf@c203.arch.suse.de>
References: <69b8506362a7564f7ec5cf8acb40197b634239e9.1436993298.git.christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <69b8506362a7564f7ec5cf8acb40197b634239e9.1436993298.git.christophe.jaillet@wanadoo.fr>
	(Christophe JAILLET's message of "Wed, 15 Jul 2015 22:53:26 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: JBottomley@odin.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Christophe JAILLET <christophe.jaillet@wanadoo.fr> writes:

> Use 'list_for_each_safe' instead of 'list_for_each' + own logic to ke=
ep
> safe when a list entry is deleted.
> Delete the now useless 'csio_list_prev' macro.
>
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/scsi/csiostor/csio_defs.h |  1 -
>  drivers/scsi/csiostor/csio_hw.c   | 10 ++++------
>  drivers/scsi/csiostor/csio_scsi.c | 10 ++++------
>  3 files changed, 8 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/scsi/csiostor/csio_defs.h b/drivers/scsi/csiosto=
r/csio_defs.h
> index c38017b..4b3557c 100644
> --- a/drivers/scsi/csiostor/csio_defs.h
> +++ b/drivers/scsi/csiostor/csio_defs.h
> @@ -70,7 +70,6 @@ csio_list_deleted(struct list_head *list)
>  }
> =20
>  #define csio_list_next(elem)	(((struct list_head *)(elem))->next)
> -#define csio_list_prev(elem)	(((struct list_head *)(elem))->prev)
> =20
>  /* State machine */
>  typedef void (*csio_sm_state_t)(void *, uint32_t);
> diff --git a/drivers/scsi/csiostor/csio_hw.c b/drivers/scsi/csiostor/=
csio_hw.c
> index 622bdab..61ee6cb 100644
> --- a/drivers/scsi/csiostor/csio_hw.c
> +++ b/drivers/scsi/csiostor/csio_hw.c
> @@ -3643,20 +3643,19 @@ static void
>  csio_mgmt_tmo_handler(uintptr_t data)
>  {
>  	struct csio_mgmtm *mgmtm =3D (struct csio_mgmtm *) data;
> -	struct list_head *tmp;
> +	struct list_head *tmp, *next;
>  	struct csio_ioreq *io_req;
> =20
>  	csio_dbg(mgmtm->hw, "Mgmt timer invoked!\n");
> =20
>  	spin_lock_irq(&mgmtm->hw->lock);
> =20
> -	list_for_each(tmp, &mgmtm->active_q) {
> +	list_for_each_safe(tmp, next, &mgmtm->active_q) {
>  		io_req =3D (struct csio_ioreq *) tmp;
>  		io_req->tmo -=3D min_t(uint32_t, io_req->tmo, ECM_MIN_TMO);
> =20
>  		if (!io_req->tmo) {
>  			/* Dequeue the request from retry Q. */
> -			tmp =3D csio_list_prev(tmp);
>  			list_del_init(&io_req->sm.sm_list);
>  			if (io_req->io_cbfn) {
>  				/* io_req will be freed by completion handler */
> @@ -3680,7 +3679,7 @@ csio_mgmtm_cleanup(struct csio_mgmtm *mgmtm)
>  {
>  	struct csio_hw *hw =3D mgmtm->hw;
>  	struct csio_ioreq *io_req;
> -	struct list_head *tmp;
> +	struct list_head *tmp, *next;
>  	uint32_t count;
> =20
>  	count =3D 30;
> @@ -3692,9 +3691,8 @@ csio_mgmtm_cleanup(struct csio_mgmtm *mgmtm)
>  	}
> =20
>  	/* release outstanding req from ACTIVEQ */
> -	list_for_each(tmp, &mgmtm->active_q) {
> +	list_for_each_safe(tmp, next, &mgmtm->active_q) {
>  		io_req =3D (struct csio_ioreq *) tmp;
> -		tmp =3D csio_list_prev(tmp);
>  		list_del_init(&io_req->sm.sm_list);
>  		mgmtm->stats.n_active--;
>  		if (io_req->io_cbfn) {
> diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiosto=
r/csio_scsi.c
> index 2c4562d..2bfb401 100644
> --- a/drivers/scsi/csiostor/csio_scsi.c
> +++ b/drivers/scsi/csiostor/csio_scsi.c
> @@ -2322,7 +2322,7 @@ csio_scsi_alloc_ddp_bufs(struct csio_scsim *scm=
, struct csio_hw *hw,
>  			 int buf_size, int num_buf)
>  {
>  	int n =3D 0;
> -	struct list_head *tmp;
> +	struct list_head *tmp, *next;
>  	struct csio_dma_buf *ddp_desc =3D NULL;
>  	uint32_t unit_size =3D 0;
> =20
> @@ -2370,9 +2370,8 @@ csio_scsi_alloc_ddp_bufs(struct csio_scsim *scm=
, struct csio_hw *hw,
>  	return 0;
>  no_mem:
>  	/* release dma descs back to freelist and free dma memory */
> -	list_for_each(tmp, &scm->ddp_freelist) {
> +	list_for_each_safe(tmp, next, &scm->ddp_freelist) {
>  		ddp_desc =3D (struct csio_dma_buf *) tmp;
> -		tmp =3D csio_list_prev(tmp);
>  		pci_free_consistent(hw->pdev, ddp_desc->len, ddp_desc->vaddr,
>  				    ddp_desc->paddr);
>  		list_del_init(&ddp_desc->list);
> @@ -2393,13 +2392,12 @@ no_mem:
>  static void
>  csio_scsi_free_ddp_bufs(struct csio_scsim *scm, struct csio_hw *hw)
>  {
> -	struct list_head *tmp;
> +	struct list_head *tmp, *next;
>  	struct csio_dma_buf *ddp_desc;
> =20
>  	/* release dma descs back to freelist and free dma memory */
> -	list_for_each(tmp, &scm->ddp_freelist) {
> +	list_for_each_safe(tmp, next, &scm->ddp_freelist) {
>  		ddp_desc =3D (struct csio_dma_buf *) tmp;
> -		tmp =3D csio_list_prev(tmp);
>  		pci_free_consistent(hw->pdev, ddp_desc->len, ddp_desc->vaddr,
>  				    ddp_desc->paddr);
>  		list_del_init(&ddp_desc->list);

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                       Storage
jthumshirn@suse.de                             +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
