From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2 06/11] qla2xxx: Add support for Private link
 statistics counters.
Date: Thu, 28 Jan 2016 09:59:21 +0100
Message-ID: <20160128085921.GK27565@c203.arch.suse.de>
References: <1453914218-380-1-git-send-email-himanshu.madhani@qlogic.com>
 <1453914218-380-7-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32969 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755158AbcA1I7X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Jan 2016 03:59:23 -0500
Content-Disposition: inline
In-Reply-To: <1453914218-380-7-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org

On Wed, Jan 27, 2016 at 12:03:33PM -0500, Himanshu Madhani wrote:
> From: Harish Zunjarrao <harish.zunjarrao@qlogic.com>
>=20
> Signed-off-by: Harish Zunjarrao <harish.zunjarrao@qlogic.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
> ---
>  drivers/scsi/qla2xxx/qla_attr.c |    6 ++-
>  drivers/scsi/qla2xxx/qla_bsg.c  |   61 +++++++++++++++++++++++++++++=
++++++++++
>  drivers/scsi/qla2xxx/qla_bsg.h  |    1 +
>  drivers/scsi/qla2xxx/qla_dbg.c  |    2 +-
>  drivers/scsi/qla2xxx/qla_def.h  |   32 +++++++++++++++++++-
>  drivers/scsi/qla2xxx/qla_mbx.c  |    3 +-
>  6 files changed, 99 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/q=
la_attr.c
> index fef659a..fadce04 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -1917,7 +1917,8 @@ qla2x00_get_fc_host_stats(struct Scsi_Host *sho=
st)
>  	if (qla2x00_reset_active(vha))
>  		goto done;
> =20
> -	stats =3D dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &stats_dma);
> +	stats =3D dma_alloc_coherent(&ha->pdev->dev,
> +	    sizeof(struct link_statistics), &stats_dma, GFP_KERNEL);
>  	if (stats =3D=3D NULL) {
>  		ql_log(ql_log_warn, vha, 0x707d,
>  		    "Failed to allocate memory for stats.\n");
> @@ -1965,7 +1966,8 @@ qla2x00_get_fc_host_stats(struct Scsi_Host *sho=
st)
>  	do_div(pfc_host_stat->seconds_since_last_reset, HZ);
> =20
>  done_free:
> -        dma_pool_free(ha->s_dma_pool, stats, stats_dma);
> +	dma_free_coherent(&ha->pdev->dev, sizeof(struct link_statistics),
> +	    stats, stats_dma);
>  done:
>  	return pfc_host_stat;
>  }
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/ql=
a_bsg.c
> index d135d6a..913fef2 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -2233,6 +2233,64 @@ qla27xx_get_bbcr_data(struct fc_bsg_job *bsg_j=
ob)
>  }
> =20
>  static int
> +qla2x00_get_priv_stats(struct fc_bsg_job *bsg_job)
> +{
> +	struct Scsi_Host *host =3D bsg_job->shost;
> +	scsi_qla_host_t *vha =3D shost_priv(host);
> +	struct qla_hw_data *ha =3D vha->hw;
> +	struct scsi_qla_host *base_vha =3D pci_get_drvdata(ha->pdev);
> +	struct link_statistics *stats =3D NULL;
> +	dma_addr_t stats_dma;
> +	int rval =3D QLA_FUNCTION_FAILED;
> +
> +	if (test_bit(UNLOADING, &vha->dpc_flags))
> +		goto done;
> +
> +	if (unlikely(pci_channel_offline(ha->pdev)))
> +		goto done;
> +
> +	if (qla2x00_reset_active(vha))
> +		goto done;
> +
> +	if (!IS_FWI2_CAPABLE(ha))
> +		goto done;
> +
> +	stats =3D dma_alloc_coherent(&ha->pdev->dev,
> +		sizeof(struct link_statistics), &stats_dma, GFP_KERNEL);
> +	if (!stats) {
> +		ql_log(ql_log_warn, vha, 0x70e2,
> +		"Failed to allocate memory for stats.\n");
> +		goto done;
> +	}
> +
> +	memset(stats, 0, sizeof(struct link_statistics));
> +
> +	rval =3D qla24xx_get_isp_stats(base_vha, stats, stats_dma);
> +
> +	if (rval !=3D QLA_SUCCESS)
> +		goto done_free;
> +
> +	ql_dump_buffer(ql_dbg_user + ql_dbg_verbose, vha, 0x70e3,
> +	    (uint8_t *)stats, sizeof(struct link_statistics));
> +
> +	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
> +	bsg_job->reply_payload.sg_cnt, stats, sizeof(struct link_statistics=
));
> +	bsg_job->reply->reply_payload_rcv_len =3D sizeof(struct link_statis=
tics);
> +
> +	bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] =3D EXT_STATU=
S_OK;
> +
> +	bsg_job->reply_len =3D sizeof(struct fc_bsg_reply);
> +	bsg_job->reply->result =3D DID_OK << 16;
> +	bsg_job->job_done(bsg_job);
> +
> +done_free:
> +	dma_free_coherent(&ha->pdev->dev, sizeof(struct link_statistics),
> +		stats, stats_dma);
> +done:
> +	return rval;
> +}
> +
> +static int
>  qla2x00_process_vendor_specific(struct fc_bsg_job *bsg_job)
>  {
>  	switch (bsg_job->request->rqst_data.h_vendor.vendor_cmd[0]) {
> @@ -2296,6 +2354,9 @@ qla2x00_process_vendor_specific(struct fc_bsg_j=
ob *bsg_job)
>  	case QL_VND_GET_BBCR_DATA:
>  		return qla27xx_get_bbcr_data(bsg_job);
> =20
> +	case QL_VND_GET_PRIV_STATS:
> +		return qla2x00_get_priv_stats(bsg_job);
> +
>  	default:
>  		return -ENOSYS;
>  	}
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.h b/drivers/scsi/qla2xxx/ql=
a_bsg.h
> index 4275177..c40dd8b 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.h
> +++ b/drivers/scsi/qla2xxx/qla_bsg.h
> @@ -28,6 +28,7 @@
>  #define QL_VND_GET_FLASH_UPDATE_CAPS    0x15
>  #define QL_VND_SET_FLASH_UPDATE_CAPS    0x16
>  #define QL_VND_GET_BBCR_DATA    0x17
> +#define QL_VND_GET_PRIV_STATS	0x18
> =20
>  /* BSG Vendor specific subcode returns */
>  #define EXT_STATUS_OK			0
> diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/ql=
a_dbg.c
> index 493a3ea81..aa6694b 100644
> --- a/drivers/scsi/qla2xxx/qla_dbg.c
> +++ b/drivers/scsi/qla2xxx/qla_dbg.c
> @@ -32,7 +32,7 @@
>   * |                              |                    | 0x503d,0x50=
44  |
>   * |                              |                    | 0x507b,0x50=
5f	|
>   * | Timer Routines               |       0x6012       |            =
    |
> - * | User Space Interactions      |       0x70e65      | 0x7018,0x70=
2e  |
> + * | User Space Interactions      |       0x70e3       | 0x7018,0x70=
2e  |
>   * |				  |		       | 0x7020,0x7024  |
>   * |                              |                    | 0x7039,0x70=
45  |
>   * |                              |                    | 0x7073-0x70=
75  |
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/ql=
a_def.h
> index c4bd62a..ceb452d 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -1254,13 +1254,41 @@ struct link_statistics {
>  	uint32_t inval_xmit_word_cnt;
>  	uint32_t inval_crc_cnt;
>  	uint32_t lip_cnt;
> -	uint32_t unused1[0x1a];
> +	uint32_t link_up_cnt;
> +	uint32_t link_down_loop_init_tmo;
> +	uint32_t link_down_los;
> +	uint32_t link_down_loss_rcv_clk;
> +	uint32_t reserved0[5];
> +	uint32_t port_cfg_chg;
> +	uint32_t reserved1[11];
> +	uint32_t rsp_q_full;
> +	uint32_t atio_q_full;
> +	uint32_t drop_ae;
> +	uint32_t els_proto_err;
> +	uint32_t reserved2;
>  	uint32_t tx_frames;
>  	uint32_t rx_frames;
>  	uint32_t discarded_frames;
>  	uint32_t dropped_frames;
> -	uint32_t unused2[1];
> +	uint32_t reserved3;
>  	uint32_t nos_rcvd;
> +	uint32_t reserved4[4];
> +	uint32_t tx_prjt;
> +	uint32_t rcv_exfail;
> +	uint32_t rcv_abts;
> +	uint32_t seq_frm_miss;
> +	uint32_t corr_err;
> +	uint32_t mb_rqst;
> +	uint32_t nport_full;
> +	uint32_t eofa;
> +	uint32_t reserved5;
> +	uint32_t fpm_recv_word_cnt_lo;
> +	uint32_t fpm_recv_word_cnt_hi;
> +	uint32_t fpm_disc_word_cnt_lo;
> +	uint32_t fpm_disc_word_cnt_hi;
> +	uint32_t fpm_xmit_word_cnt_lo;
> +	uint32_t fpm_xmit_word_cnt_hi;
> +	uint32_t reserved6[70];
>  };
> =20
>  /*
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/ql=
a_mbx.c
> index 4433cfb..3dd3398 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -2799,7 +2799,8 @@ qla2x00_get_link_status(scsi_qla_host_t *vha, u=
int16_t loop_id,
>  			/* Copy over data -- firmware data is LE. */
>  			ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1086,
>  			    "Done %s.\n", __func__);
> -			dwords =3D offsetof(struct link_statistics, unused1) / 4;
> +			dwords =3D offsetof(struct link_statistics,
> +					link_up_cnt) / 4;
>  			siter =3D diter =3D &stats->link_fail_cnt;
>  			while (dwords--)
>  				*diter++ =3D le32_to_cpu(*siter++);
> --=20
> 1.7.7
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Seriously, be more verbose on commit messages.

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
