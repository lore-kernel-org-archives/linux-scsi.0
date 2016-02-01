From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 10/12] be2iscsi: Fix ExpStatSn in management tasks
Date: Mon, 1 Feb 2016 13:24:56 +0100
Message-ID: <20160201122456.GJ27969@c203.arch.suse.de>
References: <1454321571-16167-1-git-send-email-jitendra.bhivare@avagotech.com>
 <1454321571-16167-11-git-send-email-jitendra.bhivare@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54983 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753265AbcBAMY7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Feb 2016 07:24:59 -0500
Content-Disposition: inline
In-Reply-To: <1454321571-16167-11-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

On Mon, Feb 01, 2016 at 03:42:49PM +0530, Jitendra Bhivare wrote:
> Connection resets observed from some targets when NOP-Out with wrong
> ExpStatSn is sent.
>=20
> FW keeps track of StatSn and fills up ExpStatSn accordingly.
> The header filled up by the stack needs to be modified by driver to c=
lear
> ExpStatSn. If the field is not cleared, FW recalculates ExpStatSn and
> wrong offset'ed ExpStatSn is seen in the wire trace.
>=20
> Signed-off-by: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
> ---
>  drivers/scsi/be2iscsi/be_main.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/=
be_main.c
> index 3f08a11..03265b6 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -4926,7 +4926,6 @@ int beiscsi_iotask_v2(struct iscsi_task *task, =
struct scatterlist *sg,
> =20
>  	pwrb =3D io_task->pwrb_handle->pwrb;
> =20
> -	io_task->cmd_bhs->iscsi_hdr.exp_statsn =3D 0;
>  	io_task->bhs_len =3D sizeof(struct be_cmd_bhs);
> =20
>  	if (writedir) {
> @@ -4987,7 +4986,6 @@ static int beiscsi_iotask(struct iscsi_task *ta=
sk, struct scatterlist *sg,
>  	unsigned int doorbell =3D 0;
> =20
>  	pwrb =3D io_task->pwrb_handle->pwrb;
> -	io_task->cmd_bhs->iscsi_hdr.exp_statsn =3D 0;
>  	io_task->bhs_len =3D sizeof(struct be_cmd_bhs);
> =20
>  	if (writedir) {
> @@ -5159,23 +5157,21 @@ static int beiscsi_task_xmit(struct iscsi_tas=
k *task)
>  {
>  	struct beiscsi_io_task *io_task =3D task->dd_data;
>  	struct scsi_cmnd *sc =3D task->sc;
> -	struct beiscsi_hba *phba =3D NULL;
> +	struct beiscsi_hba *phba;
>  	struct scatterlist *sg;
>  	int num_sg;
>  	unsigned int  writedir =3D 0, xferlen =3D 0;
> =20
> -	phba =3D ((struct beiscsi_conn *)task->conn->dd_data)->phba;
> +	if (!io_task->conn->login_in_progress)
> +		task->hdr->exp_statsn =3D 0;
> =20
>  	if (!sc)
>  		return beiscsi_mtask(task);
> =20
>  	io_task->scsi_cmnd =3D sc;
>  	num_sg =3D scsi_dma_map(sc);
> +	phba =3D io_task->conn->phba;
>  	if (num_sg < 0) {
> -		struct iscsi_conn *conn =3D task->conn;
> -		struct beiscsi_hba *phba =3D NULL;
> -
> -		phba =3D ((struct beiscsi_conn *)conn->dd_data)->phba;
>  		beiscsi_log(phba, KERN_ERR,
>  			    BEISCSI_LOG_IO | BEISCSI_LOG_ISCSI,
>  			    "BM_%d : scsi_dma_map Failed "
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
