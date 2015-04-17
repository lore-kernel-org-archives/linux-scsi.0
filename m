From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4 06/43] hpsa: hpsa decode sense data for io and tmf
Date: Fri, 17 Apr 2015 15:03:35 +0200
Message-ID: <553104A7.6070609@suse.de>
References: <20150416134224.30238.66082.stgit@brunhilda> <20150416134714.30238.77926.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59346 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753260AbbDQNDh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Apr 2015 09:03:37 -0400
In-Reply-To: <20150416134714.30238.77926.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.combrace@pmcs.com
Cc: linux-scsi@vger.kernel.org

Hid Don,

some comments at the end.

On 04/16/2015 03:47 PM, Don Brace wrote:
> From: Stephen Cameron <stephenmcameron@gmail.com>
>=20
> In hba mode, we could get sense data in descriptor format so
> we need to handle that.
>=20
> It's possible for CommandStatus to have value 0x0D
> "TMF Function Status", which we should handle.  We will get
> this from a P1224 when aborting a non-existent tag, for
> example.  The "ScsiStatus" field of the errinfo field
> will contain the TMF function status value.
>=20
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>
> ---
>  drivers/scsi/hpsa.c     |  143 +++++++++++++++++++++++++++++++++++--=
----------
>  drivers/scsi/hpsa_cmd.h |    9 +++
>  2 files changed, 117 insertions(+), 35 deletions(-)
>=20
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 6ee92af..68238dd 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -43,6 +43,7 @@
>  #include <scsi/scsi_device.h>
>  #include <scsi/scsi_host.h>
>  #include <scsi/scsi_tcq.h>
> +#include <scsi/scsi_eh.h>
>  #include <linux/cciss_ioctl.h>
>  #include <linux/string.h>
>  #include <linux/bitmap.h>
> @@ -268,16 +269,49 @@ static inline struct ctlr_info *shost_to_hba(st=
ruct Scsi_Host *sh)
>  	return (struct ctlr_info *) *priv;
>  }
> =20
> +/* extract sense key, asc, and ascq from sense data.  -1 means inval=
id. */
> +static void decode_sense_data(const u8 *sense_data, int sense_data_l=
en,
> +			int *sense_key, int *asc, int *ascq)
> +{
> +	struct scsi_sense_hdr sshdr;
> +	bool rc;
> +
> +	*sense_key =3D -1;
> +	*asc =3D -1;
> +	*ascq =3D -1;
> +
> +	if (sense_data_len < 1)
> +		return;
> +
> +	rc =3D scsi_normalize_sense(sense_data, sense_data_len, &sshdr);
> +	if (rc) {
> +		*sense_key =3D sshdr.sense_key;
> +		*asc =3D sshdr.asc;
> +		*ascq =3D sshdr.ascq;
> +	}
> +}
> +
>  static int check_for_unit_attention(struct ctlr_info *h,
>  	struct CommandList *c)
>  {
> -	if (c->err_info->SenseInfo[2] !=3D UNIT_ATTENTION)
> +	int sense_key, asc, ascq;
> +	int sense_len;
> +
> +	if (c->err_info->SenseLen > sizeof(c->err_info->SenseInfo))
> +		sense_len =3D sizeof(c->err_info->SenseInfo);
> +	else
> +		sense_len =3D c->err_info->SenseLen;
> +
> +	decode_sense_data(c->err_info->SenseInfo, sense_len,
> +				&sense_key, &asc, &ascq);
> +	if (sense_key !=3D UNIT_ATTENTION || asc =3D=3D -1)
>  		return 0;
> =20
> -	switch (c->err_info->SenseInfo[12]) {
> +	switch (asc) {
>  	case STATE_CHANGED:
> -		dev_warn(&h->pdev->dev, HPSA "%d: a state change "
> -			"detected, command retried\n", h->ctlr);
> +		dev_warn(&h->pdev->dev,
> +			HPSA "%d: a state change detected, command retried\n",
> +			h->ctlr);
>  		break;
>  	case LUN_FAILED:
>  		dev_warn(&h->pdev->dev,
> @@ -1860,6 +1894,34 @@ retry_cmd:
>  	queue_work_on(raw_smp_processor_id(), h->resubmit_wq, &c->work);
>  }
> =20
> +/* Returns 0 on success, < 0 otherwise. */
> +static int hpsa_evaluate_tmf_status(struct ctlr_info *h,
> +					struct CommandList *cp)
> +{
> +	u8 tmf_status =3D cp->err_info->ScsiStatus;
> +
> +	switch (tmf_status) {
> +	case CISS_TMF_COMPLETE:
> +		/*
> +		 * CISS_TMF_COMPLETE never happens, instead,
> +		 * ei->CommandStatus =3D=3D 0 for this case.
> +		 */
> +	case CISS_TMF_SUCCESS:
> +		return 0;
> +	case CISS_TMF_INVALID_FRAME:
> +	case CISS_TMF_NOT_SUPPORTED:
> +	case CISS_TMF_FAILED:
> +	case CISS_TMF_WRONG_LUN:
> +	case CISS_TMF_OVERLAPPED_TAG:
> +		break;
> +	default:
> +		dev_warn(&h->pdev->dev, "Unknown TMF status: 0x%02x\n",
> +				tmf_status);
> +		break;
> +	}
> +	return -tmf_status;
> +}
> +
>  static void complete_scsi_command(struct CommandList *cp)
>  {
>  	struct scsi_cmnd *cmd;
> @@ -1867,9 +1929,9 @@ static void complete_scsi_command(struct Comman=
dList *cp)
>  	struct ErrorInfo *ei;
>  	struct hpsa_scsi_dev_t *dev;
> =20
> -	unsigned char sense_key;
> -	unsigned char asc;      /* additional sense code */
> -	unsigned char ascq;     /* additional sense code qualifier */
> +	int sense_key;
> +	int asc;      /* additional sense code */
> +	int ascq;     /* additional sense code qualifier */
>  	unsigned long sense_data_size;
> =20
>  	ei =3D cp->err_info;
> @@ -1904,8 +1966,6 @@ static void complete_scsi_command(struct Comman=
dList *cp)
>  	if (cp->cmd_type =3D=3D CMD_IOACCEL2)
>  		return process_ioaccel2_completion(h, cp, cmd, dev);
> =20
> -	cmd->result |=3D ei->ScsiStatus;
> -
>  	scsi_set_resid(cmd, ei->ResidualCnt);
>  	if (ei->CommandStatus =3D=3D 0) {
>  		if (cp->cmd_type =3D=3D CMD_IOACCEL1)
> @@ -1915,16 +1975,6 @@ static void complete_scsi_command(struct Comma=
ndList *cp)
>  		return;
>  	}
> =20
> -	/* copy the sense data */
> -	if (SCSI_SENSE_BUFFERSIZE < sizeof(ei->SenseInfo))
> -		sense_data_size =3D SCSI_SENSE_BUFFERSIZE;
> -	else
> -		sense_data_size =3D sizeof(ei->SenseInfo);
> -	if (ei->SenseLen < sense_data_size)
> -		sense_data_size =3D ei->SenseLen;
> -
> -	memcpy(cmd->sense_buffer, ei->SenseInfo, sense_data_size);
> -
>  	/* For I/O accelerator commands, copy over some fields to the norma=
l
>  	 * CISS header used below for error handling.
>  	 */
> @@ -1956,14 +2006,18 @@ static void complete_scsi_command(struct Comm=
andList *cp)
>  	switch (ei->CommandStatus) {
> =20
>  	case CMD_TARGET_STATUS:
> -		if (ei->ScsiStatus) {
> -			/* Get sense key */
> -			sense_key =3D 0xf & ei->SenseInfo[2];
> -			/* Get additional sense code */
> -			asc =3D ei->SenseInfo[12];
> -			/* Get addition sense code qualifier */
> -			ascq =3D ei->SenseInfo[13];
> -		}
> +		cmd->result |=3D ei->ScsiStatus;
> +		/* copy the sense data */
> +		if (SCSI_SENSE_BUFFERSIZE < sizeof(ei->SenseInfo))
> +			sense_data_size =3D SCSI_SENSE_BUFFERSIZE;
> +		else
> +			sense_data_size =3D sizeof(ei->SenseInfo);
> +		if (ei->SenseLen < sense_data_size)
> +			sense_data_size =3D ei->SenseLen;
> +		memcpy(cmd->sense_buffer, ei->SenseInfo, sense_data_size);
> +		if (ei->ScsiStatus)
> +			decode_sense_data(ei->SenseInfo, sense_data_size,
> +				&sense_key, &asc, &ascq);
>  		if (ei->ScsiStatus =3D=3D SAM_STAT_CHECK_CONDITION) {
>  			if (sense_key =3D=3D ABORTED_COMMAND) {
>  				cmd->result |=3D DID_SOFT_ERROR << 16;
> @@ -2058,6 +2112,10 @@ static void complete_scsi_command(struct Comma=
ndList *cp)
>  		cmd->result =3D DID_ERROR << 16;
>  		dev_warn(&h->pdev->dev, "Command unabortable\n");
>  		break;
> +	case CMD_TMF_STATUS:
> +		if (hpsa_evaluate_tmf_status(h, cp)) /* TMF failed? */
> +			cmd->result =3D DID_ERROR << 16;
> +		break;
>  	case CMD_IOACCEL_DISABLED:
>  		/* This only handles the direct pass-through case since RAID
>  		 * offload is handled above.  Just attempt a retry.
> @@ -2208,16 +2266,22 @@ static void hpsa_scsi_interpret_error(struct =
ctlr_info *h,
>  {
>  	const struct ErrorInfo *ei =3D cp->err_info;
>  	struct device *d =3D &cp->h->pdev->dev;
> -	const u8 *sd =3D ei->SenseInfo;
> +	int sense_key, asc, ascq, sense_len;
> =20
>  	switch (ei->CommandStatus) {
>  	case CMD_TARGET_STATUS:
> +		if (ei->SenseLen > sizeof(ei->SenseInfo))
> +			sense_len =3D sizeof(ei->SenseInfo);
> +		else
> +			sense_len =3D ei->SenseLen;
> +		decode_sense_data(ei->SenseInfo, sense_len,
> +					&sense_key, &asc, &ascq);
>  		hpsa_print_cmd(h, "SCSI status", cp);
>  		if (ei->ScsiStatus =3D=3D SAM_STAT_CHECK_CONDITION)
> -			dev_warn(d, "SCSI Status =3D 02, Sense key =3D %02x, ASC =3D %02x=
, ASCQ =3D %02x\n",
> -				sd[2] & 0x0f, sd[12], sd[13]);
> +			dev_warn(d, "SCSI Status =3D 02, Sense key =3D 0x%02x, ASC =3D 0x=
%02x, ASCQ =3D 0x%02x\n",
> +				sense_key, asc, ascq);
>  		else
> -			dev_warn(d, "SCSI Status =3D %02x\n", ei->ScsiStatus);
> +			dev_warn(d, "SCSI Status =3D 0x%02x\n", ei->ScsiStatus);
>  		if (ei->ScsiStatus =3D=3D 0)
>  			dev_warn(d, "SCSI status is abnormally zero.  "
>  			"(probably indicates selection timeout "
> @@ -2762,7 +2826,8 @@ static int hpsa_volume_offline(struct ctlr_info=
 *h,
>  					unsigned char scsi3addr[])
>  {
>  	struct CommandList *c;
> -	unsigned char *sense, sense_key, asc, ascq;
> +	unsigned char *sense;
> +	int sense_key, asc, ascq, sense_len;
>  	int rc, ldstat =3D 0;
>  	u16 cmd_status;
>  	u8 scsi_status;
> @@ -2780,9 +2845,11 @@ static int hpsa_volume_offline(struct ctlr_inf=
o *h,
>  		return 0;
>  	}
>  	sense =3D c->err_info->SenseInfo;
> -	sense_key =3D sense[2];
> -	asc =3D sense[12];
> -	ascq =3D sense[13];
> +	if (c->err_info->SenseLen > sizeof(c->err_info->SenseInfo))
> +		sense_len =3D sizeof(c->err_info->SenseInfo);
> +	else
> +		sense_len =3D c->err_info->SenseLen;
> +	decode_sense_data(sense, sense_len, &sense_key, &asc, &ascq);
>  	cmd_status =3D c->err_info->CommandStatus;
>  	scsi_status =3D c->err_info->ScsiStatus;
>  	cmd_free(h, c);
> @@ -2858,6 +2925,9 @@ static int hpsa_device_supports_aborts(struct c=
tlr_info *h,
>  	case CMD_ABORT_FAILED:
>  		rc =3D 1;
>  		break;
> +	case CMD_TMF_STATUS:
> +		rc =3D hpsa_evaluate_tmf_status(h, c);
> +		break;
>  	default:
>  		rc =3D 0;
>  		break;
> @@ -4665,6 +4735,9 @@ static int hpsa_send_abort(struct ctlr_info *h,=
 unsigned char *scsi3addr,
>  	switch (ei->CommandStatus) {
>  	case CMD_SUCCESS:
>  		break;
> +	case CMD_TMF_STATUS:
> +		rc =3D hpsa_evaluate_tmf_status(h, c);
> +		break;
>  	case CMD_UNABORTABLE: /* Very common, don't make noise. */
>  		rc =3D -1;
>  		break;

Hmm. It feels weird, to have ASC and ASCQ values as integers ...
any specifc reasons for this?
If not, why can't you keep them as unsigned char ?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
