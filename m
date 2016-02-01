From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 11/12] be2iscsi: _bh for io_sgl_lock and mgmt_sgl_lock
Date: Mon, 1 Feb 2016 13:26:28 +0100
Message-ID: <20160201122628.GK27969@c203.arch.suse.de>
References: <1454321571-16167-1-git-send-email-jitendra.bhivare@avagotech.com>
 <1454321571-16167-12-git-send-email-jitendra.bhivare@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56622 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754010AbcBAM0b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Feb 2016 07:26:31 -0500
Content-Disposition: inline
In-Reply-To: <1454321571-16167-12-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

On Mon, Feb 01, 2016 at 03:42:50PM +0530, Jitendra Bhivare wrote:
> Processing of mgmt and IO tasks are done in process context and sofit=
rqs.
>=20
> Allocation and freeing of sgl_handles needs to be done under
> spin_lock_bh/spin_unlock_bh and move the locks to the routines.
>=20
> Signed-off-by: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
> ---
>  drivers/scsi/be2iscsi/be_main.c | 25 ++++++++++---------------
>  1 file changed, 10 insertions(+), 15 deletions(-)
>=20
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/=
be_main.c
> index 03265b6..fa2b589 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -1132,6 +1132,7 @@ static struct sgl_handle *alloc_io_sgl_handle(s=
truct beiscsi_hba *phba)
>  {
>  	struct sgl_handle *psgl_handle;
> =20
> +	spin_lock_bh(&phba->io_sgl_lock);
>  	if (phba->io_sgl_hndl_avbl) {
>  		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_IO,
>  			    "BM_%d : In alloc_io_sgl_handle,"
> @@ -1149,12 +1150,14 @@ static struct sgl_handle *alloc_io_sgl_handle=
(struct beiscsi_hba *phba)
>  			phba->io_sgl_alloc_index++;
>  	} else
>  		psgl_handle =3D NULL;
> +	spin_unlock_bh(&phba->io_sgl_lock);
>  	return psgl_handle;
>  }
> =20
>  static void
>  free_io_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl=
_handle)
>  {
> +	spin_lock_bh(&phba->io_sgl_lock);
>  	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_IO,
>  		    "BM_%d : In free_,io_sgl_free_index=3D%d\n",
>  		    phba->io_sgl_free_index);
> @@ -1169,6 +1172,7 @@ free_io_sgl_handle(struct beiscsi_hba *phba, st=
ruct sgl_handle *psgl_handle)
>  			     "value there=3D%p\n", phba->io_sgl_free_index,
>  			     phba->io_sgl_hndl_base
>  			     [phba->io_sgl_free_index]);
> +		 spin_unlock_bh(&phba->io_sgl_lock);
>  		return;
>  	}
>  	phba->io_sgl_hndl_base[phba->io_sgl_free_index] =3D psgl_handle;
> @@ -1177,6 +1181,7 @@ free_io_sgl_handle(struct beiscsi_hba *phba, st=
ruct sgl_handle *psgl_handle)
>  		phba->io_sgl_free_index =3D 0;
>  	else
>  		phba->io_sgl_free_index++;
> +	spin_unlock_bh(&phba->io_sgl_lock);
>  }
> =20
>  static inline struct wrb_handle *
> @@ -1257,6 +1262,7 @@ static struct sgl_handle *alloc_mgmt_sgl_handle=
(struct beiscsi_hba *phba)
>  {
>  	struct sgl_handle *psgl_handle;
> =20
> +	spin_lock_bh(&phba->mgmt_sgl_lock);
>  	if (phba->eh_sgl_hndl_avbl) {
>  		psgl_handle =3D phba->eh_sgl_hndl_base[phba->eh_sgl_alloc_index];
>  		phba->eh_sgl_hndl_base[phba->eh_sgl_alloc_index] =3D NULL;
> @@ -1274,13 +1280,14 @@ static struct sgl_handle *alloc_mgmt_sgl_hand=
le(struct beiscsi_hba *phba)
>  			phba->eh_sgl_alloc_index++;
>  	} else
>  		psgl_handle =3D NULL;
> +	spin_unlock_bh(&phba->mgmt_sgl_lock);
>  	return psgl_handle;
>  }
> =20
>  void
>  free_mgmt_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *ps=
gl_handle)
>  {
> -
> +	spin_lock_bh(&phba->mgmt_sgl_lock);
>  	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
>  		    "BM_%d : In  free_mgmt_sgl_handle,"
>  		    "eh_sgl_free_index=3D%d\n",
> @@ -1295,6 +1302,7 @@ free_mgmt_sgl_handle(struct beiscsi_hba *phba, =
struct sgl_handle *psgl_handle)
>  			    "BM_%d : Double Free in eh SGL ,"
>  			    "eh_sgl_free_index=3D%d\n",
>  			    phba->eh_sgl_free_index);
> +		spin_unlock_bh(&phba->mgmt_sgl_lock);
>  		return;
>  	}
>  	phba->eh_sgl_hndl_base[phba->eh_sgl_free_index] =3D psgl_handle;
> @@ -1304,6 +1312,7 @@ free_mgmt_sgl_handle(struct beiscsi_hba *phba, =
struct sgl_handle *psgl_handle)
>  		phba->eh_sgl_free_index =3D 0;
>  	else
>  		phba->eh_sgl_free_index++;
> +	spin_unlock_bh(&phba->mgmt_sgl_lock);
>  }
> =20
>  static void
> @@ -4616,11 +4625,9 @@ beiscsi_free_mgmt_task_handles(struct beiscsi_=
conn *beiscsi_conn,
>  	}
> =20
>  	if (io_task->psgl_handle) {
> -		spin_lock_bh(&phba->mgmt_sgl_lock);
>  		free_mgmt_sgl_handle(phba,
>  				     io_task->psgl_handle);
>  		io_task->psgl_handle =3D NULL;
> -		spin_unlock_bh(&phba->mgmt_sgl_lock);
>  	}
> =20
>  	if (io_task->mtask_addr) {
> @@ -4666,9 +4673,7 @@ static void beiscsi_cleanup_task(struct iscsi_t=
ask *task)
>  		}
> =20
>  		if (io_task->psgl_handle) {
> -			spin_lock(&phba->io_sgl_lock);
>  			free_io_sgl_handle(phba, io_task->psgl_handle);
> -			spin_unlock(&phba->io_sgl_lock);
>  			io_task->psgl_handle =3D NULL;
>  		}
> =20
> @@ -4784,9 +4789,7 @@ static int beiscsi_alloc_pdu(struct iscsi_task =
*task, uint8_t opcode)
>  	io_task->pwrb_handle =3D NULL;
> =20
>  	if (task->sc) {
> -		spin_lock(&phba->io_sgl_lock);
>  		io_task->psgl_handle =3D alloc_io_sgl_handle(phba);
> -		spin_unlock(&phba->io_sgl_lock);
>  		if (!io_task->psgl_handle) {
>  			beiscsi_log(phba, KERN_ERR,
>  				    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
> @@ -4811,10 +4814,8 @@ static int beiscsi_alloc_pdu(struct iscsi_task=
 *task, uint8_t opcode)
>  		if ((opcode & ISCSI_OPCODE_MASK) =3D=3D ISCSI_OP_LOGIN) {
>  			beiscsi_conn->task =3D task;
>  			if (!beiscsi_conn->login_in_progress) {
> -				spin_lock(&phba->mgmt_sgl_lock);
>  				io_task->psgl_handle =3D (struct sgl_handle *)
>  						alloc_mgmt_sgl_handle(phba);
> -				spin_unlock(&phba->mgmt_sgl_lock);
>  				if (!io_task->psgl_handle) {
>  					beiscsi_log(phba, KERN_ERR,
>  						    BEISCSI_LOG_IO |
> @@ -4853,9 +4854,7 @@ static int beiscsi_alloc_pdu(struct iscsi_task =
*task, uint8_t opcode)
>  						beiscsi_conn->plogin_wrb_handle;
>  			}
>  		} else {
> -			spin_lock(&phba->mgmt_sgl_lock);
>  			io_task->psgl_handle =3D alloc_mgmt_sgl_handle(phba);
> -			spin_unlock(&phba->mgmt_sgl_lock);
>  			if (!io_task->psgl_handle) {
>  				beiscsi_log(phba, KERN_ERR,
>  					    BEISCSI_LOG_IO |
> @@ -4890,15 +4889,11 @@ static int beiscsi_alloc_pdu(struct iscsi_tas=
k *task, uint8_t opcode)
>  	return 0;
> =20
>  free_io_hndls:
> -	spin_lock(&phba->io_sgl_lock);
>  	free_io_sgl_handle(phba, io_task->psgl_handle);
> -	spin_unlock(&phba->io_sgl_lock);
>  	goto free_hndls;
>  free_mgmt_hndls:
> -	spin_lock(&phba->mgmt_sgl_lock);
>  	free_mgmt_sgl_handle(phba, io_task->psgl_handle);
>  	io_task->psgl_handle =3D NULL;
> -	spin_unlock(&phba->mgmt_sgl_lock);
>  free_hndls:
>  	phwi_ctrlr =3D phba->phwi_ctrlr;
>  	cri_index =3D BE_GET_CRI_FROM_CID(
> --=20
> 2.5.0
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
