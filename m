From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2 05/11] qla2xxx: Add support for buffer to buffer
 credit value for ISP27XX.
Date: Thu, 28 Jan 2016 09:57:45 +0100
Message-ID: <20160128085745.GJ27565@c203.arch.suse.de>
References: <1453914218-380-1-git-send-email-himanshu.madhani@qlogic.com>
 <1453914218-380-6-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60693 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964967AbcA1I5r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Jan 2016 03:57:47 -0500
Content-Disposition: inline
In-Reply-To: <1453914218-380-6-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org

On Wed, Jan 27, 2016 at 12:03:32PM -0500, Himanshu Madhani wrote:
> From: Sawan Chandak <sawan.chandak@qlogic.com>
>=20
> Signed-off-by: Sawan Chandak <sawan.chandak@qlogic.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
> ---
>  drivers/scsi/qla2xxx/qla_bsg.c |   55 ++++++++++++++++++++++++++++++=
++++++++++
>  drivers/scsi/qla2xxx/qla_bsg.h |   24 +++++++++++++++++
>  drivers/scsi/qla2xxx/qla_def.h |    2 +
>  drivers/scsi/qla2xxx/qla_fw.h  |    4 ++-
>  drivers/scsi/qla2xxx/qla_mbx.c |    8 ++++++
>  5 files changed, 92 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/ql=
a_bsg.c
> index 64fe17a..d135d6a 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -2181,6 +2181,58 @@ qla27xx_set_flash_upd_cap(struct fc_bsg_job *b=
sg_job)
>  }
> =20
>  static int
> +qla27xx_get_bbcr_data(struct fc_bsg_job *bsg_job)
> +{
> +	struct Scsi_Host *host =3D bsg_job->shost;
> +	scsi_qla_host_t *vha =3D shost_priv(host);
> +	struct qla_hw_data *ha =3D vha->hw;
> +	struct qla_bbcr_data bbcr;
> +	uint16_t loop_id, topo, sw_cap;
> +	uint8_t domain, area, al_pa, state;
> +	int rval;
> +
> +	if (!(IS_QLA27XX(ha)))
> +		return -EPERM;
> +
> +	memset(&bbcr, 0, sizeof(bbcr));
> +
> +	if (vha->flags.bbcr_enable)
> +		bbcr.status =3D QLA_BBCR_STATUS_ENABLED;
> +	else
> +		bbcr.status =3D QLA_BBCR_STATUS_DISABLED;
> +
> +	if (bbcr.status =3D=3D QLA_BBCR_STATUS_ENABLED) {
> +		rval =3D qla2x00_get_adapter_id(vha, &loop_id, &al_pa,
> +			&area, &domain, &topo, &sw_cap);
> +		if (rval !=3D QLA_SUCCESS)
> +			return -EIO;
> +
> +		state =3D (vha->bbcr >> 12) & 0x1;
> +
> +		if (state) {
> +			bbcr.state =3D QLA_BBCR_STATE_OFFLINE;
> +			bbcr.offline_reason_code =3D QLA_BBCR_REASON_LOGIN_REJECT;
> +		} else {
> +			bbcr.state =3D QLA_BBCR_STATE_ONLINE;
> +			bbcr.negotiated_bbscn =3D (vha->bbcr >> 8) & 0xf;
> +		}
> +
> +		bbcr.configured_bbscn =3D vha->bbcr & 0xf;
> +	}
> +
> +	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
> +		bsg_job->reply_payload.sg_cnt, &bbcr, sizeof(bbcr));
> +	bsg_job->reply->reply_payload_rcv_len =3D sizeof(bbcr);
> +
> +	bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] =3D EXT_STATU=
S_OK;
> +
> +	bsg_job->reply_len =3D sizeof(struct fc_bsg_reply);
> +	bsg_job->reply->result =3D DID_OK << 16;
> +	bsg_job->job_done(bsg_job);
> +	return 0;
> +}
> +
> +static int
>  qla2x00_process_vendor_specific(struct fc_bsg_job *bsg_job)
>  {
>  	switch (bsg_job->request->rqst_data.h_vendor.vendor_cmd[0]) {
> @@ -2241,6 +2293,9 @@ qla2x00_process_vendor_specific(struct fc_bsg_j=
ob *bsg_job)
>  	case QL_VND_SET_FLASH_UPDATE_CAPS:
>  		return qla27xx_set_flash_upd_cap(bsg_job);
> =20
> +	case QL_VND_GET_BBCR_DATA:
> +		return qla27xx_get_bbcr_data(bsg_job);
> +
>  	default:
>  		return -ENOSYS;
>  	}
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.h b/drivers/scsi/qla2xxx/ql=
a_bsg.h
> index 6c45bf4..4275177 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.h
> +++ b/drivers/scsi/qla2xxx/qla_bsg.h
> @@ -27,6 +27,7 @@
>  #define	QL_VND_SERDES_OP_EX	0x14
>  #define QL_VND_GET_FLASH_UPDATE_CAPS    0x15
>  #define QL_VND_SET_FLASH_UPDATE_CAPS    0x16
> +#define QL_VND_GET_BBCR_DATA    0x17
> =20
>  /* BSG Vendor specific subcode returns */
>  #define EXT_STATUS_OK			0
> @@ -239,4 +240,27 @@ struct qla_flash_update_caps {
>  	uint32_t  outage_duration;
>  	uint8_t   reserved[20];
>  } __packed;
> +
> +/* BB_CR Status */
> +#define QLA_BBCR_STATUS_DISABLED       0
> +#define QLA_BBCR_STATUS_ENABLED        1
> +
> +/* BB_CR State */
> +#define QLA_BBCR_STATE_OFFLINE         0
> +#define QLA_BBCR_STATE_ONLINE          1
> +
> +/* BB_CR Offline Reason Code */
> +#define QLA_BBCR_REASON_PORT_SPEED     1
> +#define QLA_BBCR_REASON_PEER_PORT      2
> +#define QLA_BBCR_REASON_SWITCH         3
> +#define QLA_BBCR_REASON_LOGIN_REJECT   4
> +
> +struct  qla_bbcr_data {
> +	uint8_t   status;         /* 1 - enabled, 0 - Disabled */
> +	uint8_t   state;          /* 1 - online, 0 - offline */
> +	uint8_t   configured_bbscn;       /* 0-15 */
> +	uint8_t   negotiated_bbscn;       /* 0-15 */
> +	uint8_t   offline_reason_code;
> +	uint8_t   reserved[11];
> +} __packed;
>  #endif
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/ql=
a_def.h
> index 987480f..c4bd62a 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -3583,6 +3583,7 @@ typedef struct scsi_qla_host {
>  		uint32_t	delete_progress:1;
> =20
>  		uint32_t	fw_tgt_reported:1;
> +		uint32_t	bbcr_enable:1;
>  	} flags;
> =20
>  	atomic_t	loop_state;
> @@ -3715,6 +3716,7 @@ typedef struct scsi_qla_host {
>  	atomic_t	vref_count;
>  	struct qla8044_reset_template reset_tmplt;
>  	struct qla_tgt_counters tgt_counters;
> +	uint16_t	bbcr;
>  } scsi_qla_host_t;
> =20
>  struct qla27xx_image_status {
> diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla=
_fw.h
> index 7f095e3..4c0f3a7 100644
> --- a/drivers/scsi/qla2xxx/qla_fw.h
> +++ b/drivers/scsi/qla2xxx/qla_fw.h
> @@ -1288,7 +1288,9 @@ struct vp_rpt_id_entry_24xx {
> =20
>  	uint8_t vp_idx_map[16];
> =20
> -	uint8_t reserved_4[32];
> +	uint8_t reserved_4[28];
> +	uint16_t bbcr;
> +	uint8_t reserved_5[6];
>  };
> =20
>  #define VF_EVFP_IOCB_TYPE       0x26    /* Exchange Virtual Fabric P=
arameters entry. */
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/ql=
a_mbx.c
> index 87e6758..4433cfb 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -1349,6 +1349,8 @@ qla2x00_get_adapter_id(scsi_qla_host_t *vha, ui=
nt16_t *id, uint8_t *al_pa,
>  		mcp->in_mb |=3D MBX_13|MBX_12|MBX_11|MBX_10;
>  	if (IS_FWI2_CAPABLE(vha->hw))
>  		mcp->in_mb |=3D MBX_19|MBX_18|MBX_17|MBX_16;
> +	if (IS_QLA27XX(vha->hw))
> +		mcp->in_mb |=3D MBX_15;
>  	mcp->tov =3D MBX_TOV_SECONDS;
>  	mcp->flags =3D 0;
>  	rval =3D qla2x00_mailbox_command(vha, mcp);
> @@ -1400,6 +1402,9 @@ qla2x00_get_adapter_id(scsi_qla_host_t *vha, ui=
nt16_t *id, uint8_t *al_pa,
>  				    wwn_to_u64(vha->port_name));
>  			}
>  		}
> +
> +		if (IS_QLA27XX(vha->hw))
> +			vha->bbcr =3D mcp->mb[15];
>  	}
> =20
>  	return rval;
> @@ -3612,6 +3617,9 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *=
vha,
>  		    rptid_entry->port_id[2], rptid_entry->port_id[1],
>  		    rptid_entry->port_id[0]);
> =20
> +		/* buffer to buffer credit flag */
> +		vha->flags.bbcr_enable =3D (rptid_entry->bbcr & 0xf) !=3D 0;
> +
>  		/* FA-WWN is only for physical port */
>  		if (!vp_idx) {
>  			void *wwpn =3D ha->init_cb->port_name;
> --=20
> 1.7.7
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
