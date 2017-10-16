From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH 1/2] qla2xxx: Use ql2xnvmeenable to enable Q-Pair for
 FC-NVMe
Date: Mon, 16 Oct 2017 13:24:26 -0400
Message-ID: <1508174666.24441.144.camel@localhost.localdomain>
References: <20171013224323.14863-1-himanshu.madhani@cavium.com>
         <20171013224323.14863-2-himanshu.madhani@cavium.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37760 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753043AbdJPRYd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Oct 2017 13:24:33 -0400
In-Reply-To: <20171013224323.14863-2-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Madhani, Madhani" <himanshu.madhani@cavium.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org

On Fri, 2017-10-13 at 15:43 -0700, Madhani, Madhani wrote:
> From: Himanshu Madhani <himanshu.madhani@cavium.com>
> 
> In some env, user can choose to not enable SCSI-MQ but wants
> to use FC-NVMe feature of the driver. Since driver relies on
> Q-Pairs to allocate FC-NVMe resources, use existing module
> parameter to create Q-Pairs when FC-NVMe is enabled.
> 
> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
> ---
>  drivers/scsi/qla2xxx/qla_init.c |  2 +-
>  drivers/scsi/qla2xxx/qla_isr.c  |  2 +-
>  drivers/scsi/qla2xxx/qla_mid.c  |  2 +-
>  drivers/scsi/qla2xxx/qla_os.c   | 27 ++++++++++++++++++---------
>  4 files changed, 21 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
> index b2a391f93775..9752ac4c1003 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -8036,7 +8036,7 @@ struct qla_qpair *qla2xxx_create_qpair(struct scsi_qla_host *vha, int qos,
>  		return NULL;
>  	}
>  
> -	if (ql2xmqsupport) {
> +	if (ql2xmqsupport || ql2xnvmeenable) {
>  		qpair = kzalloc(sizeof(struct qla_qpair), GFP_KERNEL);
>  		if (qpair == NULL) {
>  			ql_log(ql_log_warn, vha, 0x0182,
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index d06a1a809188..bdaa4d644424 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -3411,7 +3411,7 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
>  		    ha->msix_count, ret);
>  		ha->msix_count = ret;
>  		/* Recalculate queue values */
> -		if (ha->mqiobase && ql2xmqsupport) {
> +		if (ha->mqiobase && (ql2xmqsupport || ql2xnvmeenable)) {
>  			ha->max_req_queues = ha->msix_count - 1;
>  
>  			/* ATIOQ needs 1 vector. That's 1 less QPair */
> diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
> index c0f8f6c17b79..3630bb66a74c 100644
> --- a/drivers/scsi/qla2xxx/qla_mid.c
> +++ b/drivers/scsi/qla2xxx/qla_mid.c
> @@ -606,7 +606,7 @@ qla25xx_delete_queues(struct scsi_qla_host *vha)
>  	struct qla_hw_data *ha = vha->hw;
>  	struct qla_qpair *qpair, *tqpair;
>  
> -	if (ql2xmqsupport) {
> +	if (ql2xmqsupport || ql2xnvmeenable) {
>  		list_for_each_entry_safe(qpair, tqpair, &vha->qp_list,
>  		    qp_list_elem)
>  			qla2xxx_delete_qpair(vha, qpair);
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index cb719345aa0d..0cfce0486b70 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -433,7 +433,7 @@ static int qla2x00_alloc_queues(struct qla_hw_data *ha, struct req_que *req,
>  
>  	qla_init_base_qpair(vha, req, rsp);
>  
> -	if (ql2xmqsupport && ha->max_qpairs) {
> +	if ((ql2xmqsupport || ql2xnvmeenable) && ha->max_qpairs) {
>  		ha->queue_pair_map = kcalloc(ha->max_qpairs, sizeof(struct qla_qpair *),
>  			GFP_KERNEL);
>  		if (!ha->queue_pair_map) {
> @@ -1976,7 +1976,8 @@ qla2x00_iospace_config(struct qla_hw_data *ha)
>  	/* Determine queue resources */
>  	ha->max_req_queues = ha->max_rsp_queues = 1;
>  	ha->msix_count = QLA_BASE_VECTORS;
> -	if (!ql2xmqsupport || (!IS_QLA25XX(ha) && !IS_QLA81XX(ha)))
> +	if (!ql2xmqsupport || !ql2xnvmeenable ||
> +	    (!IS_QLA25XX(ha) && !IS_QLA81XX(ha)))
>  		goto mqiobase_exit;
>  
>  	ha->mqiobase = ioremap(pci_resource_start(ha->pdev, 3),
> @@ -2073,7 +2074,7 @@ qla83xx_iospace_config(struct qla_hw_data *ha)
>  		 * By default, driver uses at least two msix vectors
>  		 * (default & rspq)
>  		 */
> -		if (ql2xmqsupport) {
> +		if (ql2xmqsupport || ql2xnvmeenable) {
>  			/* MB interrupt uses 1 vector */
>  			ha->max_req_queues = ha->msix_count - 1;
>  
> @@ -3089,9 +3090,17 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
>  
>  		ql_dbg(ql_dbg_init, base_vha, 0x0192,
>  			"blk/scsi-mq enabled, HW queues = %d.\n", host->nr_hw_queues);
> -	} else
> -		ql_dbg(ql_dbg_init, base_vha, 0x0193,
> -			"blk/scsi-mq disabled.\n");
> +	} else {
> +		if (ql2xnvmeenable) {
> +			host->nr_hw_queues = ha->max_qpairs;
> +			ql_dbg(ql_dbg_init, base_vha, 0x0194,
> +			    "FC-NVMe support is enabled, HW queues=%d\n",
> +			    host->nr_hw_queues);
> +		} else {
> +			ql_dbg(ql_dbg_init, base_vha, 0x0193,
> +			    "blk/scsi-mq disabled.\n");
> +		}
> +	}
>  
>  	qlt_probe_one_stage1(base_vha, ha);
>  
> @@ -6301,7 +6310,7 @@ qla2xxx_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
>  	switch (state) {
>  	case pci_channel_io_normal:
>  		ha->flags.eeh_busy = 0;
> -		if (ql2xmqsupport) {
> +		if (ql2xmqsupport || ql2xnvmeenable) {
>  			set_bit(QPAIR_ONLINE_CHECK_NEEDED, &vha->dpc_flags);
>  			qla2xxx_wake_dpc(vha);
>  		}
> @@ -6318,7 +6327,7 @@ qla2xxx_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
>  		pci_disable_device(pdev);
>  		/* Return back all IOs */
>  		qla2x00_abort_all_cmds(vha, DID_RESET << 16);
> -		if (ql2xmqsupport) {
> +		if (ql2xmqsupport || ql2xnvmeenable) {
>  			set_bit(QPAIR_ONLINE_CHECK_NEEDED, &vha->dpc_flags);
>  			qla2xxx_wake_dpc(vha);
>  		}
> @@ -6326,7 +6335,7 @@ qla2xxx_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
>  	case pci_channel_io_perm_failure:
>  		ha->flags.pci_channel_io_perm_failure = 1;
>  		qla2x00_abort_all_cmds(vha, DID_NO_CONNECT << 16);
> -		if (ql2xmqsupport) {
> +		if (ql2xmqsupport || ql2xnvmeenable) {
>  			set_bit(QPAIR_ONLINE_CHECK_NEEDED, &vha->dpc_flags);
>  			qla2xxx_wake_dpc(vha);
>  		}

Reviewed-by: Ewan D. Milne <emilne@redhat.com>
