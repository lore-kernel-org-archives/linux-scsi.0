From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 3/4] scsi: sd_zbc: add zone open, close, and finish
 support
Date: Sat, 22 Jun 2019 01:12:43 +0000
Message-ID: <BYAPR04MB58164B645ED9BE7FA861BE33E7E60@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20190621130711.21986-1-mb@lightnvm.io>
 <20190621130711.21986-4-mb@lightnvm.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: =?iso-8859-1?Q?Matias_Bj=F8rling?= <mb@lightnvm.io>, "axboe@fb.com" <axboe@fb.com>, "hch@lst.de" <hch@lst.de>, Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Ajay Joshi <Ajay.Joshi@wdc.com>, Aravind Ramesh <Aravind.Ramesh@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "agk@redhat.com" <agk@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 2019/06/21 22:07, Matias Bj=F8rling wrote:=0A=
> From: Ajay Joshi <ajay.joshi@wdc.com>=0A=
> =0A=
> Implement REQ_OP_ZONE_OPEN, REQ_OP_ZONE_CLOSE and REQ_OP_ZONE_FINISH=0A=
> support to allow explicit control of zone states.=0A=
> =0A=
> Signed-off-by: Ajay Joshi <ajay.joshi@wdc.com>=0A=
> ---=0A=
>  drivers/scsi/sd.c     | 15 ++++++++++++++-=0A=
>  drivers/scsi/sd.h     |  6 ++++--=0A=
>  drivers/scsi/sd_zbc.c | 18 +++++++++++++-----=0A=
>  3 files changed, 31 insertions(+), 8 deletions(-)=0A=
> =0A=
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c=0A=
> index a3406bd62391..89f955a01d44 100644=0A=
> --- a/drivers/scsi/sd.c=0A=
> +++ b/drivers/scsi/sd.c=0A=
> @@ -1292,7 +1292,17 @@ static blk_status_t sd_init_command(struct scsi_cm=
nd *cmd)=0A=
>  	case REQ_OP_WRITE:=0A=
>  		return sd_setup_read_write_cmnd(cmd);=0A=
>  	case REQ_OP_ZONE_RESET:=0A=
> -		return sd_zbc_setup_reset_cmnd(cmd);=0A=
> +		return sd_zbc_setup_zone_mgmt_op_cmnd(cmd,=0A=
> +					ZO_RESET_WRITE_POINTER);=0A=
> +	case REQ_OP_ZONE_OPEN:=0A=
> +		return sd_zbc_setup_zone_mgmt_op_cmnd(cmd,=0A=
> +					ZO_OPEN_ZONE);=0A=
> +	case REQ_OP_ZONE_CLOSE:=0A=
> +		return sd_zbc_setup_zone_mgmt_op_cmnd(cmd,=0A=
> +					ZO_CLOSE_ZONE);=0A=
> +	case REQ_OP_ZONE_FINISH:=0A=
> +		return sd_zbc_setup_zone_mgmt_op_cmnd(cmd,=0A=
> +					ZO_FINISH_ZONE);=0A=
>  	default:=0A=
>  		WARN_ON_ONCE(1);=0A=
>  		return BLK_STS_NOTSUPP;=0A=
> @@ -1958,6 +1968,9 @@ static int sd_done(struct scsi_cmnd *SCpnt)=0A=
>  	case REQ_OP_WRITE_ZEROES:=0A=
>  	case REQ_OP_WRITE_SAME:=0A=
>  	case REQ_OP_ZONE_RESET:=0A=
> +	case REQ_OP_ZONE_OPEN:=0A=
> +	case REQ_OP_ZONE_CLOSE:=0A=
> +	case REQ_OP_ZONE_FINISH:=0A=
>  		if (!result) {=0A=
>  			good_bytes =3D blk_rq_bytes(req);=0A=
>  			scsi_set_resid(SCpnt, 0);=0A=
> diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h=0A=
> index 5796ace76225..9a20633caefa 100644=0A=
> --- a/drivers/scsi/sd.h=0A=
> +++ b/drivers/scsi/sd.h=0A=
> @@ -209,7 +209,8 @@ static inline int sd_is_zoned(struct scsi_disk *sdkp)=
=0A=
>  =0A=
>  extern int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buff=
er);=0A=
>  extern void sd_zbc_print_zones(struct scsi_disk *sdkp);=0A=
> -extern blk_status_t sd_zbc_setup_reset_cmnd(struct scsi_cmnd *cmd);=0A=
> +extern blk_status_t sd_zbc_setup_zone_mgmt_op_cmnd(struct scsi_cmnd *cmd=
,=0A=
> +						   unsigned char op);=0A=
=0A=
In ZBC specs, open, close, finish and reset command are all ZBC_OUT (94h)=
=0A=
commands with a different servie action. So may be renaming this function t=
o=0A=
sd_zbc_setup_zbc_out_cmnd() is better.=0A=
=0A=
>  extern void sd_zbc_complete(struct scsi_cmnd *cmd, unsigned int good_byt=
es,=0A=
>  			    struct scsi_sense_hdr *sshdr);=0A=
>  extern int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,=0A=
> @@ -226,7 +227,8 @@ static inline int sd_zbc_read_zones(struct scsi_disk =
*sdkp,=0A=
>  =0A=
>  static inline void sd_zbc_print_zones(struct scsi_disk *sdkp) {}=0A=
>  =0A=
> -static inline blk_status_t sd_zbc_setup_reset_cmnd(struct scsi_cmnd *cmd=
)=0A=
> +static inline blk_status_t sd_zbc_setup_zone_mgmt_op_cmnd(struct scsi_cm=
nd *cmd,=0A=
> +							  unsigned char op)=0A=
>  {=0A=
>  	return BLK_STS_TARGET;=0A=
>  }=0A=
> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c=0A=
> index 7334024b64f1..41020db5353a 100644=0A=
> --- a/drivers/scsi/sd_zbc.c=0A=
> +++ b/drivers/scsi/sd_zbc.c=0A=
> @@ -168,12 +168,17 @@ static inline sector_t sd_zbc_zone_sectors(struct s=
csi_disk *sdkp)=0A=
>  }=0A=
>  =0A=
>  /**=0A=
> - * sd_zbc_setup_reset_cmnd - Prepare a RESET WRITE POINTER scsi command.=
=0A=
> - * @cmd: the command to setup=0A=
> + * sd_zbc_setup_zone_mgmt_op_cmnd - Prepare a zone ZBC_OUT command. The=
=0A=
> + *                                  operations can be RESET WRITE POINTE=
R,=0A=
> + *                                  OPEN, CLOSE or FINISH.=0A=
> + * @cmd: The command to setup=0A=
> + * @op: Operation to be performed=0A=
>   *=0A=
> - * Called from sd_init_command() for a REQ_OP_ZONE_RESET request.=0A=
> + * Called from sd_init_command() for REQ_OP_ZONE_RESET, REQ_OP_ZONE_OPEN=
,=0A=
> + * REQ_OP_ZONE_CLOSE or REQ_OP_ZONE_FINISH requests.=0A=
>   */=0A=
> -blk_status_t sd_zbc_setup_reset_cmnd(struct scsi_cmnd *cmd)=0A=
> +blk_status_t sd_zbc_setup_zone_mgmt_op_cmnd(struct scsi_cmnd *cmd,=0A=
> +					    unsigned char op)=0A=
>  {=0A=
>  	struct request *rq =3D cmd->request;=0A=
>  	struct scsi_disk *sdkp =3D scsi_disk(rq->rq_disk);=0A=
> @@ -194,7 +199,7 @@ blk_status_t sd_zbc_setup_reset_cmnd(struct scsi_cmnd=
 *cmd)=0A=
>  	cmd->cmd_len =3D 16;=0A=
>  	memset(cmd->cmnd, 0, cmd->cmd_len);=0A=
>  	cmd->cmnd[0] =3D ZBC_OUT;=0A=
> -	cmd->cmnd[1] =3D ZO_RESET_WRITE_POINTER;=0A=
> +	cmd->cmnd[1] =3D op;=0A=
>  	put_unaligned_be64(block, &cmd->cmnd[2]);=0A=
>  =0A=
>  	rq->timeout =3D SD_TIMEOUT;=0A=
> @@ -222,6 +227,9 @@ void sd_zbc_complete(struct scsi_cmnd *cmd, unsigned =
int good_bytes,=0A=
>  =0A=
>  	switch (req_op(rq)) {=0A=
>  	case REQ_OP_ZONE_RESET:=0A=
> +	case REQ_OP_ZONE_OPEN:=0A=
> +	case REQ_OP_ZONE_CLOSE:=0A=
> +	case REQ_OP_ZONE_FINISH:=0A=
>  =0A=
>  		if (result &&=0A=
>  		    sshdr->sense_key =3D=3D ILLEGAL_REQUEST &&=0A=
=0A=
The comment after this code references only the reset operation. So it need=
s to=0A=
be updated. The same comment applies to all operations as they all have the=
 same=0A=
error return behavior.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
