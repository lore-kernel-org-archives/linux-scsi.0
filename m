Return-Path: <SRS0=1vUj=CL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E160EC433E2
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 15:54:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A51C207EA
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 15:54:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JJEh9io8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbgIBPyY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 11:54:24 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49720 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728101AbgIBPyR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2020 11:54:17 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 082FnfTq046844;
        Wed, 2 Sep 2020 15:54:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=AORm7AHIbvE8dEGscILm4SA9kytmmKv24ix2finptmk=;
 b=JJEh9io8eMNEi7PXamC/wzKI6bz7qUwTpwZ5EK5Su9bXFxVcSMHhtyiHOQFDKJEN2ICC
 QC06pY3jut/17vkSNhcjX5J7tAf8N2En926RG+9Cau8lSaG8T/QpxQWL+c2spQ6e+UYT
 Mpgt5ofUeJ/jVfTZLm+s9ZKM5ka08bpOHvwRLPj1N1h9RknyqbglLhAXCrjWSL7ZPA4Q
 rpKP4ltWuihMamqUkD7PQWlH3s2GuVqF0WUrIVYURBcQXCc7CLbqNDMTqsUb+mBBZ6nX
 fOtJIt4/a7ye7imp4LRBoNYyhkNKJBWv2Uu38YbVtw5stZK8v5KeRWpMIXDaYd5RlEwV 5g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 339dmn1x5a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Sep 2020 15:54:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 082FoeXj127915;
        Wed, 2 Sep 2020 15:54:12 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 3380x71q66-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Sep 2020 15:54:12 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 082FsBKF007891;
        Wed, 2 Sep 2020 15:54:11 GMT
Received: from dhcp-10-154-155-248.vpn.oracle.com (/10.154.155.248)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Sep 2020 08:54:11 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH v2 07/13] qla2xxx: performance tweak
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20200902072548.11491-8-njavali@marvell.com>
Date:   Wed, 2 Sep 2020 10:54:10 -0500
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <59A4D908-91F6-4162-B9BA-3F3CD740AC5E@oracle.com>
References: <20200902072548.11491-1-njavali@marvell.com>
 <20200902072548.11491-8-njavali@marvell.com>
To:     Nilesh Javali <njavali@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=11 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009020151
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 impostorscore=0 mlxscore=0 suspectscore=11
 spamscore=0 clxscore=1015 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009020151
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Sep 2, 2020, at 2:25 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> This patch move statistic fields from vha struct to qpair
> to reduce memory thrashing.
>=20
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_attr.c | 46 ++++++++++++++++++++++++++++-----
> drivers/scsi/qla2xxx/qla_def.h  | 32 +++++++++++++++++------
> drivers/scsi/qla2xxx/qla_init.c |  5 ++--
> drivers/scsi/qla2xxx/qla_iocb.c | 18 +++++++------
> drivers/scsi/qla2xxx/qla_isr.c  |  8 +++---
> drivers/scsi/qla2xxx/qla_mid.c  |  4 +--
> drivers/scsi/qla2xxx/qla_nvme.c |  8 +++---
> drivers/scsi/qla2xxx/qla_os.c   | 10 ++++---
> 8 files changed, 92 insertions(+), 39 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_attr.c =
b/drivers/scsi/qla2xxx/qla_attr.c
> index d006ae193677..1ee747ba4ecc 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -2726,6 +2726,9 @@ qla2x00_get_fc_host_stats(struct Scsi_Host =
*shost)
> 	struct link_statistics *stats;
> 	dma_addr_t stats_dma;
> 	struct fc_host_statistics *p =3D &vha->fc_host_stat;
> +	struct qla_qpair *qpair;
> +	int i;
> +	u64 ib =3D 0, ob =3D 0, ir =3D 0, or =3D 0;
>=20
> 	memset(p, -1, sizeof(*p));
>=20
> @@ -2762,6 +2765,27 @@ qla2x00_get_fc_host_stats(struct Scsi_Host =
*shost)
> 	if (rval !=3D QLA_SUCCESS)
> 		goto done_free;
>=20
> +	/* --- */
> +	for (i =3D 0; i < vha->hw->max_qpairs; i++) {
> +		qpair =3D vha->hw->queue_pair_map[i];
> +		if (!qpair)
> +			continue;
> +		ir +=3D qpair->counters.input_requests;
> +		or +=3D qpair->counters.output_requests;
> +		ib +=3D qpair->counters.input_bytes;
> +		ob +=3D qpair->counters.output_bytes;
> +	}
> +	ir +=3D ha->base_qpair->counters.input_requests;
> +	or +=3D ha->base_qpair->counters.output_requests;
> +	ib +=3D ha->base_qpair->counters.input_bytes;
> +	ob +=3D ha->base_qpair->counters.output_bytes;
> +
> +	ir +=3D vha->qla_stats.input_requests;
> +	or +=3D vha->qla_stats.output_requests;
> +	ib +=3D vha->qla_stats.input_bytes;
> +	ob +=3D vha->qla_stats.output_bytes;
> +	/* --- */
> +
> 	p->link_failure_count =3D le32_to_cpu(stats->link_fail_cnt);
> 	p->loss_of_sync_count =3D le32_to_cpu(stats->loss_sync_cnt);
> 	p->loss_of_signal_count =3D le32_to_cpu(stats->loss_sig_cnt);
> @@ -2781,15 +2805,16 @@ qla2x00_get_fc_host_stats(struct Scsi_Host =
*shost)
> 			p->rx_words =3D =
le64_to_cpu(stats->fpm_recv_word_cnt);
> 			p->tx_words =3D =
le64_to_cpu(stats->fpm_xmit_word_cnt);
> 		} else {
> -			p->rx_words =3D vha->qla_stats.input_bytes;
> -			p->tx_words =3D vha->qla_stats.output_bytes;
> +			p->rx_words =3D ib >> 2;
> +			p->tx_words =3D ob >> 2;
> 		}
> 	}
> +
> 	p->fcp_control_requests =3D vha->qla_stats.control_requests;
> -	p->fcp_input_requests =3D vha->qla_stats.input_requests;
> -	p->fcp_output_requests =3D vha->qla_stats.output_requests;
> -	p->fcp_input_megabytes =3D vha->qla_stats.input_bytes >> 20;
> -	p->fcp_output_megabytes =3D vha->qla_stats.output_bytes >> 20;
> +	p->fcp_input_requests =3D ir;
> +	p->fcp_output_requests =3D or;
> +	p->fcp_input_megabytes  =3D ib >> 20;
> +	p->fcp_output_megabytes =3D ob >> 20;
> 	p->seconds_since_last_reset =3D
> 	    get_jiffies_64() - vha->qla_stats.jiffies_at_last_reset;
> 	do_div(p->seconds_since_last_reset, HZ);
> @@ -2809,9 +2834,18 @@ qla2x00_reset_host_stats(struct Scsi_Host =
*shost)
> 	struct scsi_qla_host *base_vha =3D pci_get_drvdata(ha->pdev);
> 	struct link_statistics *stats;
> 	dma_addr_t stats_dma;
> +	int i;
> +	struct qla_qpair *qpair;
>=20
> 	memset(&vha->qla_stats, 0, sizeof(vha->qla_stats));
> 	memset(&vha->fc_host_stat, 0, sizeof(vha->fc_host_stat));
> +	for (i =3D 0; i < vha->hw->max_qpairs; i++) {
> +		qpair =3D vha->hw->queue_pair_map[i];
> +		if (!qpair)
> +			continue;
> +		memset(&qpair->counters, 0, sizeof(qpair->counters));
> +	}
> +	memset(&ha->base_qpair->counters, 0, sizeof(qpair->counters));
>=20
> 	vha->qla_stats.jiffies_at_last_reset =3D get_jiffies_64();
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_def.h =
b/drivers/scsi/qla2xxx/qla_def.h
> index ad4a0ba7203c..3ca8665638c4 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -2443,12 +2443,6 @@ typedef struct fc_port {
> 	struct list_head list;
> 	struct scsi_qla_host *vha;
>=20
> -	uint8_t node_name[WWN_SIZE];
> -	uint8_t port_name[WWN_SIZE];
> -	port_id_t d_id;
> -	uint16_t loop_id;
> -	uint16_t old_loop_id;
> -
> 	unsigned int conf_compl_supported:1;
> 	unsigned int deleted:2;
> 	unsigned int free_pending:1;
> @@ -2465,6 +2459,13 @@ typedef struct fc_port {
> 	unsigned int n2n_flag:1;
> 	unsigned int explicit_logout:1;
> 	unsigned int prli_pend_timer:1;
> +	uint8_t nvme_flag;
> +
> +	uint8_t node_name[WWN_SIZE];
> +	uint8_t port_name[WWN_SIZE];
> +	port_id_t d_id;
> +	uint16_t loop_id;
> +	uint16_t old_loop_id;
>=20
> 	struct completion nvme_del_done;
> 	uint32_t nvme_prli_service_param;
> @@ -2473,7 +2474,7 @@ typedef struct fc_port {
> #define NVME_PRLI_SP_TARGET     BIT_4
> #define NVME_PRLI_SP_DISCOVERY  BIT_3
> #define NVME_PRLI_SP_FIRST_BURST	BIT_0
> -	uint8_t nvme_flag;
> +
> 	uint32_t nvme_first_burst_size;
> #define NVME_FLAG_REGISTERED 4
> #define NVME_FLAG_DELETING 2
> @@ -3510,6 +3511,14 @@ struct qla_tgt_counters {
> 	uint64_t num_term_xchg_sent;
> };
>=20
> +struct qla_counters {
> +	uint64_t input_bytes;
> +	uint64_t input_requests;
> +	uint64_t output_bytes;
> +	uint64_t output_requests;
> +
> +};
> +
> struct qla_qpair;
>=20
> /* Response queue data structure */
> @@ -3594,6 +3603,7 @@ struct qla_qpair {
> 	uint32_t enable_class_2:1;
> 	uint32_t enable_explicit_conf:1;
> 	uint32_t use_shadow_reg:1;
> +	uint32_t rcv_intr:1;
>=20
> 	uint16_t id;			/* qp number used with FW */
> 	uint16_t vp_idx;		/* vport ID */
> @@ -3609,13 +3619,16 @@ struct qla_qpair {
> 	struct qla_msix_entry *msix; /* point to &ha->msix_entries[x] */
> 	struct qla_hw_data *hw;
> 	struct work_struct q_work;
> +	struct qla_counters counters;
> +
> 	struct list_head qp_list_elem; /* vha->qp_list */
> 	struct list_head hints_list;
> -	uint16_t cpuid;
> +
> 	uint16_t retry_term_cnt;
> 	__le32	retry_term_exchg_addr;
> 	uint64_t retry_term_jiff;
> 	struct qla_tgt_counters tgt_counters;
> +	uint16_t cpuid;
> };
>=20
> /* Place holder for FW buffer parameters */
> @@ -4129,6 +4142,9 @@ struct qla_hw_data {
> #define USE_ASYNC_SCAN(ha) (IS_QLA25XX(ha) || IS_QLA81XX(ha) ||\
> 	IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha))
>=20
> +#define IS_ZIO_THRESHOLD_CAPABLE(ha) \
> +	(IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha))
> +

Why not fold in "ha->zio_mode =3D=3D QLA_ZIO_MODE_6=E2=80=9D check as =
well in the above macro.=20

My understanding is that only time ZIO_THREASHOLD_CAPABLE will be used =
is when
zio_mode =3D=3D ZIO_MODE_6. Makes code easy to read.=20


> 	/* HBA serial number */
> 	uint8_t		serial0;
> 	uint8_t		serial1;
> diff --git a/drivers/scsi/qla2xxx/qla_init.c =
b/drivers/scsi/qla2xxx/qla_init.c
> index b4d53eb4e53e..99f322fb74ab 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -3690,9 +3690,8 @@ qla2x00_setup_chip(scsi_qla_host_t *vha)
> 					goto execute_fw_with_lr;
> 				}
>=20
> -				if ((IS_QLA83XX(ha) || IS_QLA27XX(ha) ||
> -				    IS_QLA28XX(ha)) &&
> -				    (ha->zio_mode =3D=3D =
QLA_ZIO_MODE_6))
> +				if (IS_ZIO_THRESHOLD_CAPABLE(ha) &&
> +				    ha->zio_mode =3D=3D QLA_ZIO_MODE_6)

See above comment. This line would change to IS_ZIO_THRESHOLD_CAPABLE()

> 					qla27xx_set_zio_threshold(vha,
> 					    ha->last_zio_threshold);
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c =
b/drivers/scsi/qla2xxx/qla_iocb.c
> index e3d2dea0b057..d69e16e844aa 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -594,6 +594,7 @@ qla24xx_build_scsi_type_6_iocbs(srb_t *sp, struct =
cmd_type_6 *cmd_pkt,
> 	uint32_t dsd_list_len;
> 	struct dsd_dma *dsd_ptr;
> 	struct ct6_dsd *ctx;
> +	struct qla_qpair *qpair =3D sp->qpair;
>=20
> 	cmd =3D GET_CMD_SP(sp);
>=20
> @@ -612,12 +613,12 @@ qla24xx_build_scsi_type_6_iocbs(srb_t *sp, =
struct cmd_type_6 *cmd_pkt,
> 	/* Set transfer direction */
> 	if (cmd->sc_data_direction =3D=3D DMA_TO_DEVICE) {
> 		cmd_pkt->control_flags =3D cpu_to_le16(CF_WRITE_DATA);
> -		vha->qla_stats.output_bytes +=3D scsi_bufflen(cmd);
> -		vha->qla_stats.output_requests++;
> +		qpair->counters.output_bytes +=3D scsi_bufflen(cmd);
> +		qpair->counters.output_requests++;
> 	} else if (cmd->sc_data_direction =3D=3D DMA_FROM_DEVICE) {
> 		cmd_pkt->control_flags =3D cpu_to_le16(CF_READ_DATA);
> -		vha->qla_stats.input_bytes +=3D scsi_bufflen(cmd);
> -		vha->qla_stats.input_requests++;
> +		qpair->counters.input_bytes +=3D scsi_bufflen(cmd);
> +		qpair->counters.input_requests++;
> 	}
>=20
> 	cur_seg =3D scsi_sglist(cmd);
> @@ -704,6 +705,7 @@ qla24xx_build_scsi_iocbs(srb_t *sp, struct =
cmd_type_7 *cmd_pkt,
> 	struct scsi_cmnd *cmd;
> 	struct scatterlist *sg;
> 	int i;
> +	struct qla_qpair *qpair =3D sp->qpair;
>=20
> 	cmd =3D GET_CMD_SP(sp);
>=20
> @@ -721,12 +723,12 @@ qla24xx_build_scsi_iocbs(srb_t *sp, struct =
cmd_type_7 *cmd_pkt,
> 	/* Set transfer direction */
> 	if (cmd->sc_data_direction =3D=3D DMA_TO_DEVICE) {
> 		cmd_pkt->task_mgmt_flags =3D =
cpu_to_le16(TMF_WRITE_DATA);
> -		vha->qla_stats.output_bytes +=3D scsi_bufflen(cmd);
> -		vha->qla_stats.output_requests++;
> +		qpair->counters.output_bytes +=3D scsi_bufflen(cmd);
> +		qpair->counters.output_requests++;
> 	} else if (cmd->sc_data_direction =3D=3D DMA_FROM_DEVICE) {
> 		cmd_pkt->task_mgmt_flags =3D cpu_to_le16(TMF_READ_DATA);
> -		vha->qla_stats.input_bytes +=3D scsi_bufflen(cmd);
> -		vha->qla_stats.input_requests++;
> +		qpair->counters.input_bytes +=3D scsi_bufflen(cmd);
> +		qpair->counters.input_requests++;
> 	}
>=20
> 	/* One DSD is available in the Command Type 3 IOCB */
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c =
b/drivers/scsi/qla2xxx/qla_isr.c
> index d38dd6520b53..a63f2000fadf 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -3414,8 +3414,10 @@ void qla24xx_process_response_queue(struct =
scsi_qla_host *vha,
> 	if (!ha->flags.fw_started)
> 		return;
>=20
> -	if (rsp->qpair->cpuid !=3D smp_processor_id())
> +	if (rsp->qpair->cpuid !=3D smp_processor_id() || =
!rsp->qpair->rcv_intr) {
> +		rsp->qpair->rcv_intr =3D 1;
> 		qla_cpu_update(rsp->qpair, smp_processor_id());
> +	}
>=20
> 	while (rsp->ring_ptr->signature !=3D RESPONSE_PROCESSED) {
> 		pkt =3D (struct sts_entry_24xx *)rsp->ring_ptr;
> @@ -3865,7 +3867,7 @@ qla2xxx_msix_rsp_q(int irq, void *dev_id)
> 	}
> 	ha =3D qpair->hw;
>=20
> -	queue_work(ha->wq, &qpair->q_work);
> +	queue_work_on(smp_processor_id(), ha->wq, &qpair->q_work);
>=20
> 	return IRQ_HANDLED;
> }
> @@ -3891,7 +3893,7 @@ qla2xxx_msix_rsp_q_hs(int irq, void *dev_id)
> 	wrt_reg_dword(&reg->hccr, HCCRX_CLR_RISC_INT);
> 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
>=20
> -	queue_work(ha->wq, &qpair->q_work);
> +	queue_work_on(smp_processor_id(), ha->wq, &qpair->q_work);
>=20
> 	return IRQ_HANDLED;
> }
> diff --git a/drivers/scsi/qla2xxx/qla_mid.c =
b/drivers/scsi/qla2xxx/qla_mid.c
> index 15efe2f04b86..08cfe043ac66 100644
> --- a/drivers/scsi/qla2xxx/qla_mid.c
> +++ b/drivers/scsi/qla2xxx/qla_mid.c
> @@ -808,11 +808,9 @@ static void qla_do_work(struct work_struct *work)
> {
> 	unsigned long flags;
> 	struct qla_qpair *qpair =3D container_of(work, struct qla_qpair, =
q_work);
> -	struct scsi_qla_host *vha;
> -	struct qla_hw_data *ha =3D qpair->hw;
> +	struct scsi_qla_host *vha =3D qpair->vha;
>=20
> 	spin_lock_irqsave(&qpair->qp_lock, flags);
> -	vha =3D pci_get_drvdata(ha->pdev);
> 	qla24xx_process_response_queue(vha, qpair->rsp);
> 	spin_unlock_irqrestore(&qpair->qp_lock, flags);
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c =
b/drivers/scsi/qla2xxx/qla_nvme.c
> index b05e4545ef5f..b0c13144c21a 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -428,8 +428,8 @@ static inline int qla2x00_start_nvme_mq(srb_t *sp)
> 	/* No data transfer how do we check buffer len =3D=3D 0?? */
> 	if (fd->io_dir =3D=3D NVMEFC_FCP_READ) {
> 		cmd_pkt->control_flags =3D cpu_to_le16(CF_READ_DATA);
> -		vha->qla_stats.input_bytes +=3D fd->payload_length;
> -		vha->qla_stats.input_requests++;
> +		qpair->counters.input_bytes +=3D fd->payload_length;
> +		qpair->counters.input_requests++;
> 	} else if (fd->io_dir =3D=3D NVMEFC_FCP_WRITE) {
> 		cmd_pkt->control_flags =3D cpu_to_le16(CF_WRITE_DATA);
> 		if ((vha->flags.nvme_first_burst) &&
> @@ -441,8 +441,8 @@ static inline int qla2x00_start_nvme_mq(srb_t *sp)
> 				cmd_pkt->control_flags |=3D
> 					=
cpu_to_le16(CF_NVME_FIRST_BURST_ENABLE);
> 		}
> -		vha->qla_stats.output_bytes +=3D fd->payload_length;
> -		vha->qla_stats.output_requests++;
> +		qpair->counters.output_bytes +=3D fd->payload_length;
> +		qpair->counters.output_requests++;
> 	} else if (fd->io_dir =3D=3D 0) {
> 		cmd_pkt->control_flags =3D 0;
> 	}
> diff --git a/drivers/scsi/qla2xxx/qla_os.c =
b/drivers/scsi/qla2xxx/qla_os.c
> index 31bfc0c088b7..c53cc31cd068 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -7198,8 +7198,10 @@ qla2x00_timer(struct timer_list *t)
> 	 * FC-NVME
> 	 * see if the active AEN count has changed from what was last =
reported.
> 	 */
> +	index =3D atomic_read(&ha->nvme_active_aen_cnt);
> 	if (!vha->vp_idx &&
> -	    (atomic_read(&ha->nvme_active_aen_cnt) !=3D =
ha->nvme_last_rptd_aen) &&
> +	    (index !=3D ha->nvme_last_rptd_aen) &&
> +	    (index >=3D DEFAULT_ZIO_THRESHOLD) &&
> 	    ha->zio_mode =3D=3D QLA_ZIO_MODE_6 &&
> 	    !ha->flags.host_shutting_down) {
> 		ql_log(ql_log_info, vha, 0x3002,
> @@ -7211,9 +7213,9 @@ qla2x00_timer(struct timer_list *t)
> 	}
>=20
> 	if (!vha->vp_idx &&
> -	    (atomic_read(&ha->zio_threshold) !=3D =
ha->last_zio_threshold) &&
> -	    (ha->zio_mode =3D=3D QLA_ZIO_MODE_6) &&
> -	    (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha))) {
> +	    atomic_read(&ha->zio_threshold) !=3D ha->last_zio_threshold =
&&
> +	    ha->zio_mode =3D=3D QLA_ZIO_MODE_6 &&
> +	    IS_ZIO_THRESHOLD_CAPABLE(ha)) {

Ditto. This would just use IS_ZIO_THRESHOLD_CAPABLE() macro.=20

> 		ql_log(ql_log_info, vha, 0x3002,
> 		    "Sched: Set ZIO exchange threshold to %d.\n",
> 		    ha->last_zio_threshold);
> --=20
> 2.19.0.rc0
>=20

--
Himanshu Madhani	 Oracle Linux Engineering

