From: Yann Droneaud <ydroneaud@opteya.com>
Subject: Re: [PATCH] IB/srp: Add 64-bit LUN support
Date: Tue, 10 Feb 2015 09:23:53 +0100
Message-ID: <1423556633.32606.7.camel@opteya.com>
References: <54CFB228.4070208@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ou.quest-ce.net ([195.154.187.82]:48054 "EHLO ou.quest-ce.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754664AbbBJKNM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Feb 2015 05:13:12 -0500
In-Reply-To: <54CFB228.4070208@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Brian King <brking@linux.vnet.ibm.com>, Nathan Fontenot <nfont@linux.vnet.ibm.com>, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>

Hi,

Le lundi 02 f=C3=A9vrier 2015 =C3=A0 18:21 +0100, Bart Van Assche a =C3=
=A9crit :
> The largest LUN number that has been tested is 0xd2003fff00000000.
>=20
> Checked the following structure sizes with gdb:
> * sizeof(struct srp_cmd) =3D 48
> * sizeof(struct srp_tsk_mgmt) =3D 48
> * sizeof(struct srp_aer_req) =3D 36
>=20

You can use 'pahole' tool to retrieve the size (and layout) of any
data structure from a .o object file.

> The ibmvscsi changes have been compile tested only (on a PPC system).
>=20

The changelog lack of any information about the purpose of 64bit LUNs.
Please detail a bit why and how.

> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Sagi Grimberg <sagig@mellanox.com>
> Cc: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
> Cc: Brian King <brking@linux.vnet.ibm.com>
> Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>
> Cc: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
> ---
>  drivers/infiniband/ulp/srp/ib_srp.c | 8 ++++----
>  drivers/scsi/ibmvscsi/ibmvscsi.c    | 6 +++---
>  include/scsi/srp.h                  | 7 ++++---
>  3 files changed, 11 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband=
/ulp/srp/ib_srp.c
> index 0747c05..e43cb86 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -1841,7 +1841,7 @@ static void srp_process_aer_req(struct srp_rdma=
_ch *ch,
>  	s32 delta =3D be32_to_cpu(req->req_lim_delta);
> =20
>  	shost_printk(KERN_ERR, target->scsi_host, PFX
> -		     "ignoring AER for LUN %llu\n", be64_to_cpu(req->lun));
> +		     "ignoring AER for LUN %llu\n", scsilun_to_int(&req->lun));
> =20
>  	if (srp_response_common(ch, delta, &rsp, sizeof(rsp)))
>  		shost_printk(KERN_ERR, target->scsi_host, PFX
> @@ -2033,7 +2033,7 @@ static int srp_queuecommand(struct Scsi_Host *s=
host, struct scsi_cmnd *scmnd)
>  	memset(cmd, 0, sizeof *cmd);
> =20
>  	cmd->opcode =3D SRP_CMD;
> -	cmd->lun    =3D cpu_to_be64((u64) scmnd->device->lun << 48);
> +	int_to_scsilun(scmnd->device->lun, &cmd->lun);
>  	cmd->tag    =3D tag;
>  	memcpy(cmd->cdb, scmnd->cmnd, scmnd->cmd_len);
> =20
> @@ -2448,7 +2448,7 @@ static int srp_send_tsk_mgmt(struct srp_rdma_ch=
 *ch, u64 req_tag,
>  	memset(tsk_mgmt, 0, sizeof *tsk_mgmt);
> =20
>  	tsk_mgmt->opcode 	=3D SRP_TSK_MGMT;
> -	tsk_mgmt->lun		=3D cpu_to_be64((u64) lun << 48);
> +	int_to_scsilun(lun, &tsk_mgmt->lun);
>  	tsk_mgmt->tag		=3D req_tag | SRP_TAG_TSK_MGMT;
>  	tsk_mgmt->tsk_mgmt_func =3D func;
>  	tsk_mgmt->task_tag	=3D req_tag;
> @@ -3145,7 +3145,7 @@ static ssize_t srp_create_target(struct device =
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

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
