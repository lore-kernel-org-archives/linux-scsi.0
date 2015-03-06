From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] IB/srp: Add 64-bit LUN support
Date: Fri, 06 Mar 2015 15:28:09 +0100
Message-ID: <1425652089.3991.1.camel@opteya.com>
References: <54F72BA6.1060300@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54F72BA6.1060300-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: James Bottomley <jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Brian King <brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Nathan Fontenot <nfont-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Tyrel Datwyler <tyreld-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

Le mercredi 04 mars 2015 =C3=A0 16:58 +0100, Bart Van Assche a =C3=A9cr=
it :
> The SCSI standard defines 64-bit values for LUNs. Large arrays
> employing large or hierarchical LUN numbers become more and more
> common. So update the SRP initiator to use 64-bit LUN numbers.
> See also Hannes Reinecke, commit 9cb78c16f5da ("scsi: use 64-bit LUNs=
"),
> June 2014.
>=20
> The largest LUN number that has been tested is 0xd2003fff00000000.
>=20
> The following structure sizes have been verified with gdb:
> * sizeof(struct srp_cmd) =3D 48
> * sizeof(struct srp_tsk_mgmt) =3D 48
> * sizeof(struct srp_aer_req) =3D 36
>=20
> The ibmvscsi changes have been compile tested only (on a PPC system).
>=20
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Reviewed-by: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
> Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> Cc: Brian King <brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> Cc: Nathan Fontenot <nfont-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> Cc: Tyrel Datwyler <tyreld-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> ---
>=20
> Changes compared to v1:
> - Removed SRP_MAX_LUN definition from ib_srp.h
>=20

Thanks.

>  drivers/infiniband/ulp/srp/ib_srp.c | 12 ++++++------
>  drivers/infiniband/ulp/srp/ib_srp.h |  1 -
>  drivers/scsi/ibmvscsi/ibmvscsi.c    |  6 +++---
>  include/scsi/srp.h                  |  7 ++++---
>  4 files changed, 13 insertions(+), 13 deletions(-)
>=20
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband=
/ulp/srp/ib_srp.c
> index a0e24a8..e427454 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -1842,7 +1842,7 @@ static void srp_process_aer_req(struct srp_rdma=
_ch *ch,
>  	s32 delta =3D be32_to_cpu(req->req_lim_delta);
> =20
>  	shost_printk(KERN_ERR, target->scsi_host, PFX
> -		     "ignoring AER for LUN %llu\n", be64_to_cpu(req->lun));
> +		     "ignoring AER for LUN %llu\n", scsilun_to_int(&req->lun));
> =20
>  	if (srp_response_common(ch, delta, &rsp, sizeof(rsp)))
>  		shost_printk(KERN_ERR, target->scsi_host, PFX
> @@ -2034,7 +2034,7 @@ static int srp_queuecommand(struct Scsi_Host *s=
host, struct scsi_cmnd *scmnd)
>  	memset(cmd, 0, sizeof *cmd);
> =20
>  	cmd->opcode =3D SRP_CMD;
> -	cmd->lun    =3D cpu_to_be64((u64) scmnd->device->lun << 48);
> +	int_to_scsilun(scmnd->device->lun, &cmd->lun);
>  	cmd->tag    =3D tag;
>  	memcpy(cmd->cdb, scmnd->cmnd, scmnd->cmd_len);
> =20
> @@ -2414,8 +2414,8 @@ srp_change_queue_depth(struct scsi_device *sdev=
, int qdepth)
>  	return scsi_change_queue_depth(sdev, qdepth);
>  }
> =20
> -static int srp_send_tsk_mgmt(struct srp_rdma_ch *ch, u64 req_tag,
> -			     unsigned int lun, u8 func)
> +static int srp_send_tsk_mgmt(struct srp_rdma_ch *ch, u64 req_tag, u6=
4 lun,
> +			     u8 func)
>  {
>  	struct srp_target_port *target =3D ch->target;
>  	struct srp_rport *rport =3D target->rport;
> @@ -2449,7 +2449,7 @@ static int srp_send_tsk_mgmt(struct srp_rdma_ch=
 *ch, u64 req_tag,
>  	memset(tsk_mgmt, 0, sizeof *tsk_mgmt);
> =20
>  	tsk_mgmt->opcode 	=3D SRP_TSK_MGMT;
> -	tsk_mgmt->lun		=3D cpu_to_be64((u64) lun << 48);
> +	int_to_scsilun(lun, &tsk_mgmt->lun);
>  	tsk_mgmt->tag		=3D req_tag | SRP_TAG_TSK_MGMT;
>  	tsk_mgmt->tsk_mgmt_func =3D func;
>  	tsk_mgmt->task_tag	=3D req_tag;
> @@ -3146,7 +3146,7 @@ static ssize_t srp_create_target(struct device =
*dev,
>  	target_host->transportt  =3D ib_srp_transport_template;
>  	target_host->max_channel =3D 0;
>  	target_host->max_id      =3D 1;
> -	target_host->max_lun     =3D SRP_MAX_LUN;
> +	target_host->max_lun     =3D -1LL;
>  	target_host->max_cmd_len =3D sizeof ((struct srp_cmd *) (void *) 0L=
)->cdb;
> =20
>  	target =3D host_to_target(target_host);
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband=
/ulp/srp/ib_srp.h
> index a611556..ce6dcf8 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.h
> +++ b/drivers/infiniband/ulp/srp/ib_srp.h
> @@ -54,7 +54,6 @@ enum {
>  	SRP_DLID_REDIRECT	=3D 2,
>  	SRP_STALE_CONN		=3D 3,
> =20
> -	SRP_MAX_LUN		=3D 512,
>  	SRP_DEF_SG_TABLESIZE	=3D 12,
> =20
>  	SRP_DEFAULT_QUEUE_SIZE	=3D 1 << 6,
> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi=
/ibmvscsi.c
> index acea5d6..6a41c36 100644
> --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
> @@ -1053,7 +1053,7 @@ static int ibmvscsi_queuecommand_lck(struct scs=
i_cmnd *cmnd,
>  	memset(srp_cmd, 0x00, SRP_MAX_IU_LEN);
>  	srp_cmd->opcode =3D SRP_CMD;
>  	memcpy(srp_cmd->cdb, cmnd->cmnd, sizeof(srp_cmd->cdb));
> -	srp_cmd->lun =3D cpu_to_be64(((u64)lun) << 48);
> +	int_to_scsilun(lun, &srp_cmd->lun);
> =20
>  	if (!map_data_for_srp_cmd(cmnd, evt_struct, srp_cmd, hostdata->dev)=
) {
>  		if (!firmware_has_feature(FW_FEATURE_CMO))
> @@ -1529,7 +1529,7 @@ static int ibmvscsi_eh_abort_handler(struct scs=
i_cmnd *cmd)
>  		/* Set up an abort SRP command */
>  		memset(tsk_mgmt, 0x00, sizeof(*tsk_mgmt));
>  		tsk_mgmt->opcode =3D SRP_TSK_MGMT;
> -		tsk_mgmt->lun =3D cpu_to_be64(((u64) lun) << 48);
> +		int_to_scsilun(lun, &tsk_mgmt->lun);
>  		tsk_mgmt->tsk_mgmt_func =3D SRP_TSK_ABORT_TASK;
>  		tsk_mgmt->task_tag =3D (u64) found_evt;
> =20
> @@ -1652,7 +1652,7 @@ static int ibmvscsi_eh_device_reset_handler(str=
uct scsi_cmnd *cmd)
>  		/* Set up a lun reset SRP command */
>  		memset(tsk_mgmt, 0x00, sizeof(*tsk_mgmt));
>  		tsk_mgmt->opcode =3D SRP_TSK_MGMT;
> -		tsk_mgmt->lun =3D cpu_to_be64(((u64) lun) << 48);
> +		int_to_scsilun(lun, &tsk_mgmt->lun);
>  		tsk_mgmt->tsk_mgmt_func =3D SRP_TSK_LUN_RESET;
> =20
>  		evt->sync_srp =3D &srp_rsp;
> diff --git a/include/scsi/srp.h b/include/scsi/srp.h
> index 1ae84db..5be834d 100644
> --- a/include/scsi/srp.h
> +++ b/include/scsi/srp.h
> @@ -42,6 +42,7 @@
>   */
> =20
>  #include <linux/types.h>
> +#include <scsi/scsi.h>
> =20
>  enum {
>  	SRP_LOGIN_REQ	=3D 0x00,
> @@ -179,7 +180,7 @@ struct srp_tsk_mgmt {
>  	u8	reserved1[6];
>  	u64	tag;
>  	u8	reserved2[4];
> -	__be64	lun __attribute__((packed));
> +	struct scsi_lun	lun;
>  	u8	reserved3[2];
>  	u8	tsk_mgmt_func;
>  	u8	reserved4;
> @@ -200,7 +201,7 @@ struct srp_cmd {
>  	u8	data_in_desc_cnt;
>  	u64	tag;
>  	u8	reserved2[4];
> -	__be64	lun __attribute__((packed));
> +	struct scsi_lun	lun;
>  	u8	reserved3;
>  	u8	task_attr;
>  	u8	reserved4;
> @@ -265,7 +266,7 @@ struct srp_aer_req {
>  	__be32	req_lim_delta;
>  	u64	tag;
>  	u32	reserved2;
> -	__be64	lun;
> +	struct scsi_lun	lun;
>  	__be32	sense_data_len;
>  	u32	reserved3;
>  	u8	sense_data[0];

Reviewed-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
