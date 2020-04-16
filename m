Return-Path: <SRS0=iRB6=6A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 741AFC2BB55
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 12:55:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FBD0208E4
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 12:55:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2894584AbgDPMzt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Apr 2020 08:55:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:59270 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2894377AbgDPMzo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Apr 2020 08:55:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0A72FAB64;
        Thu, 16 Apr 2020 12:55:41 +0000 (UTC)
Date:   Thu, 16 Apr 2020 14:55:40 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, maier@linux.ibm.com,
        bvanassche@acm.org, herbszt@gmx.de, natechancellor@gmail.com,
        rdunlap@infradead.org, hare@suse.de,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: Re: [PATCH v3 26/31] elx: efct: link statistics and SFP data
Message-ID: <20200416125540.wke4lyt4hdjbujip@carbon>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-27-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200412033303.29574-27-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Apr 11, 2020 at 08:32:58PM -0700, James Smart wrote:
> This patch continues the efct driver population.
> 
> This patch adds driver definitions for:
> Routines to retrieve link stats and SFP transceiver data.
> 
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/elx/efct/efct_hw.c | 468 ++++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/elx/efct/efct_hw.h |  39 ++++
>  2 files changed, 507 insertions(+)
> 
> diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
> index 26dd9bd1eeef..ca2fd237c7d6 100644
> --- a/drivers/scsi/elx/efct/efct_hw.c
> +++ b/drivers/scsi/elx/efct/efct_hw.c
> @@ -8,6 +8,40 @@
>  #include "efct_hw.h"
>  #include "efct_unsol.h"
>  
> +struct efct_hw_sfp_cb_arg {
> +	void (*cb)(int status, u32 bytes_written,
> +		   u8 *data, void *arg);
> +	void *arg;
> +	struct efc_dma payload;
> +};
> +
> +struct efct_hw_temp_cb_arg {
> +	void (*cb)(int status, u32 curr_temp,
> +		   u32 crit_temp_thrshld,
> +		   u32 warn_temp_thrshld,
> +		   u32 norm_temp_thrshld,
> +		   u32 fan_off_thrshld,
> +		   u32 fan_on_thrshld,
> +		   void *arg);
> +	void *arg;
> +};
> +
> +struct efct_hw_link_stat_cb_arg {
> +	void (*cb)(int status,
> +		   u32 num_counters,
> +		struct efct_hw_link_stat_counts *counters,
> +		void *arg);
> +	void *arg;
> +};
> +
> +struct efct_hw_host_stat_cb_arg {
> +	void (*cb)(int status,
> +		   u32 num_counters,
> +		struct efct_hw_host_stat_counts *counters,
> +		void *arg);

aligment

> +	void *arg;
> +};
> +
>  static enum efct_hw_rtn
>  efct_hw_link_event_init(struct efct_hw *hw)
>  {
> @@ -3035,3 +3069,437 @@ efct_hw_io_get_count(struct efct_hw *hw,
>  
>  	return count;
>  }
> +
> +static int
> +efct_hw_cb_sfp(struct efct_hw *hw, int status, u8 *mqe, void  *arg)
> +{
> +	struct efct_hw_sfp_cb_arg *cb_arg = arg;
> +	struct efc_dma *payload = &cb_arg->payload;
> +	struct sli4_rsp_cmn_read_transceiver_data *mbox_rsp;
> +	struct efct *efct = hw->os;
> +	u32 bytes_written;
> +
> +	mbox_rsp =
> +	(struct sli4_rsp_cmn_read_transceiver_data *)payload->virt;

Hmm maybe the type name is just too long. The first part already uses
abbriviations why not for the rest?

> +	bytes_written = le32_to_cpu(mbox_rsp->hdr.response_length);
> +	if (cb_arg) {
> +		if (cb_arg->cb) {
> +			if (!status && mbox_rsp->hdr.status)
> +				status = mbox_rsp->hdr.status;
> +			cb_arg->cb(status, bytes_written, mbox_rsp->page_data,
> +				   cb_arg->arg);
> +		}
> +
> +		dma_free_coherent(&efct->pcidev->dev,
> +				  cb_arg->payload.size, cb_arg->payload.virt,
> +				  cb_arg->payload.phys);
> +		memset(&cb_arg->payload, 0, sizeof(struct efc_dma));
> +		kfree(cb_arg);
> +	}
> +
> +	kfree(mqe);
> +	return EFC_SUCCESS;
> +}
> +
> +/* Function to retrieve the SFP information */
> +enum efct_hw_rtn
> +efct_hw_get_sfp(struct efct_hw *hw, u16 page,
> +		void (*cb)(int, u32, u8 *, void *), void *arg)
> +{
> +	enum efct_hw_rtn rc = EFCT_HW_RTN_ERROR;
> +	struct efct_hw_sfp_cb_arg *cb_arg;
> +	u8 *mbxdata;
> +	struct efct *efct = hw->os;
> +	struct efc_dma *dma;
> +
> +	/* mbxdata holds the header of the command */
> +	mbxdata = kmalloc(SLI4_BMBX_SIZE, GFP_KERNEL);
> +	if (!mbxdata)
> +		return EFCT_HW_RTN_NO_MEMORY;
> +
> +	memset(mbxdata, 0, SLI4_BMBX_SIZE);

kzalloc

> +	/*
> +	 * cb_arg holds the data that will be passed to the callback on
> +	 * completion
> +	 */
> +	cb_arg = kmalloc(sizeof(*cb_arg), GFP_KERNEL);
> +	if (!cb_arg) {
> +		kfree(mbxdata);
> +		return EFCT_HW_RTN_NO_MEMORY;
> +	}
> +	memset(cb_arg, 0, sizeof(struct efct_hw_sfp_cb_arg));

kzalloc

> +
> +	cb_arg->cb = cb;
> +	cb_arg->arg = arg;
> +
> +	/* payload holds the non-embedded portion */
> +	dma = &cb_arg->payload;
> +	dma->size = sizeof(struct sli4_rsp_cmn_read_transceiver_data);
> +	dma->virt = dma_alloc_coherent(&efct->pcidev->dev,
> +				       dma->size, &dma->phys, GFP_DMA);
> +	if (!dma->virt) {
> +		kfree(cb_arg);
> +		kfree(mbxdata);
> +		return EFCT_HW_RTN_NO_MEMORY;
> +	}
> +
> +	/* Send the HW command */
> +	if (!sli_cmd_common_read_transceiver_data(&hw->sli, mbxdata,
> +						 SLI4_BMBX_SIZE, page,
> +						 &cb_arg->payload))
> +		rc = efct_hw_command(hw, mbxdata, EFCT_CMD_NOWAIT,
> +				     efct_hw_cb_sfp, cb_arg);
> +
> +	if (rc != EFCT_HW_RTN_SUCCESS) {
> +		efc_log_test(hw->os,
> +			      "READ_TRANSCEIVER_DATA failed with status %d\n",
> +			     rc);
> +		dma_free_coherent(&efct->pcidev->dev,
> +				  cb_arg->payload.size, cb_arg->payload.virt,
> +				  cb_arg->payload.phys);
> +		memset(&cb_arg->payload, 0, sizeof(struct efc_dma));
> +		kfree(cb_arg);
> +		kfree(mbxdata);
> +	}
> +
> +	return rc;
> +}
> +
> +static int
> +efct_hw_cb_temp(struct efct_hw *hw, int status, u8 *mqe, void  *arg)
> +{
> +	struct sli4_cmd_dump4 *mbox_rsp = (struct sli4_cmd_dump4 *)mqe;
> +	struct efct_hw_temp_cb_arg *cb_arg = arg;
> +	u32 curr_temp = le32_to_cpu(mbox_rsp->resp_data[0]); /* word 5 */
> +	u32 crit_temp_thrshld =
> +			le32_to_cpu(mbox_rsp->resp_data[1]); /* word 6 */
> +	u32 warn_temp_thrshld =
> +			le32_to_cpu(mbox_rsp->resp_data[2]); /* word 7 */
> +	u32 norm_temp_thrshld =
> +			le32_to_cpu(mbox_rsp->resp_data[3]); /* word 8 */
> +	u32 fan_off_thrshld =
> +			le32_to_cpu(mbox_rsp->resp_data[4]);   /* word 9 */
> +	u32 fan_on_thrshld =
> +			le32_to_cpu(mbox_rsp->resp_data[5]);    /* word 10 */
                                                            ^^^
						two spaces too much

> +
> +	if (cb_arg) {
> +		if (cb_arg->cb) {
> +			if (status == 0 && le16_to_cpu(mbox_rsp->hdr.status))
> +				status = le16_to_cpu(mbox_rsp->hdr.status);
> +			cb_arg->cb(status,
> +				   curr_temp,
> +				   crit_temp_thrshld,
> +				   warn_temp_thrshld,
> +				   norm_temp_thrshld,
> +				   fan_off_thrshld,
> +				   fan_on_thrshld,

A helper struct instead of so many arguments?

> +				   cb_arg->arg);
> +		}
> +
> +		kfree(cb_arg);
> +	}
> +	kfree(mqe);
> +
> +	return EFC_SUCCESS;
> +}
> +
> +/* Function to retrieve the temperature information */
> +enum efct_hw_rtn
> +efct_hw_get_temperature(struct efct_hw *hw,
> +			void (*cb)(int status,
> +				   u32 curr_temp,
> +				u32 crit_temp_thrshld,
> +				u32 warn_temp_thrshld,
> +				u32 norm_temp_thrshld,
> +				u32 fan_off_thrshld,
> +				u32 fan_on_thrshld,
> +				void *arg),
> +			void *arg)
> +{
> +	enum efct_hw_rtn rc = EFCT_HW_RTN_ERROR;
> +	struct efct_hw_temp_cb_arg *cb_arg;
> +	u8 *mbxdata;
> +
> +	mbxdata = kmalloc(SLI4_BMBX_SIZE, GFP_KERNEL);
> +	if (!mbxdata)
> +		return EFCT_HW_RTN_NO_MEMORY;
> +
> +	memset(mbxdata, 0, SLI4_BMBX_SIZE);

kzalloc

> +
> +	cb_arg = kmalloc(sizeof(*cb_arg), GFP_KERNEL);
> +	if (!cb_arg) {
> +		kfree(mbxdata);
> +		return EFCT_HW_RTN_NO_MEMORY;
> +	}
> +
> +	cb_arg->cb = cb;
> +	cb_arg->arg = arg;
> +
> +	/* Send the HW command */
> +	if (!sli_cmd_dump_type4(&hw->sli, mbxdata, SLI4_BMBX_SIZE,
> +			       SLI4_WKI_TAG_SAT_TEM))
> +		rc = efct_hw_command(hw, mbxdata, EFCT_CMD_NOWAIT,
> +				     efct_hw_cb_temp, cb_arg);
> +
> +	if (rc != EFCT_HW_RTN_SUCCESS) {
> +		efc_log_test(hw->os, "DUMP_TYPE4 failed\n");
> +		kfree(mbxdata);
> +		kfree(cb_arg);
> +	}
> +
> +	return rc;
> +}
> +
> +static int
> +efct_hw_cb_link_stat(struct efct_hw *hw, int status,
> +		     u8 *mqe, void  *arg)
> +{
> +	struct sli4_cmd_read_link_stats *mbox_rsp;
> +	struct efct_hw_link_stat_cb_arg *cb_arg = arg;
> +	struct efct_hw_link_stat_counts counts[EFCT_HW_LINK_STAT_MAX];
> +	u32 num_counters;
> +	u32 mbox_rsp_flags = 0;
> +
> +	mbox_rsp = (struct sli4_cmd_read_link_stats *)mqe;
> +	mbox_rsp_flags = le32_to_cpu(mbox_rsp->dw1_flags);
> +	num_counters = (mbox_rsp_flags & SLI4_READ_LNKSTAT_GEC) ? 20 : 13;
> +	memset(counts, 0, sizeof(struct efct_hw_link_stat_counts) *
> +				 EFCT_HW_LINK_STAT_MAX);
> +
> +	counts[EFCT_HW_LINK_STAT_LINK_FAILURE_COUNT].overflow =
> +		(mbox_rsp_flags & SLI4_READ_LNKSTAT_W02OF);
> +	counts[EFCT_HW_LINK_STAT_LOSS_OF_SYNC_COUNT].overflow =
> +		(mbox_rsp_flags & SLI4_READ_LNKSTAT_W03OF);
> +	counts[EFCT_HW_LINK_STAT_LOSS_OF_SIGNAL_COUNT].overflow =
> +		(mbox_rsp_flags & SLI4_READ_LNKSTAT_W04OF);
> +	counts[EFCT_HW_LINK_STAT_PRIMITIVE_SEQ_COUNT].overflow =
> +		(mbox_rsp_flags & SLI4_READ_LNKSTAT_W05OF);
> +	counts[EFCT_HW_LINK_STAT_INVALID_XMIT_WORD_COUNT].overflow =
> +		(mbox_rsp_flags & SLI4_READ_LNKSTAT_W06OF);
> +	counts[EFCT_HW_LINK_STAT_CRC_COUNT].overflow =
> +		(mbox_rsp_flags & SLI4_READ_LNKSTAT_W07OF);
> +	counts[EFCT_HW_LINK_STAT_PRIMITIVE_SEQ_TIMEOUT_COUNT].overflow =
> +		(mbox_rsp_flags & SLI4_READ_LNKSTAT_W08OF);
> +	counts[EFCT_HW_LINK_STAT_ELASTIC_BUFFER_OVERRUN_COUNT].overflow =
> +		(mbox_rsp_flags & SLI4_READ_LNKSTAT_W09OF);
> +	counts[EFCT_HW_LINK_STAT_ARB_TIMEOUT_COUNT].overflow =
> +		(mbox_rsp_flags & SLI4_READ_LNKSTAT_W10OF);
> +	counts[EFCT_HW_LINK_STAT_ADVERTISED_RCV_B2B_CREDIT].overflow =
> +		(mbox_rsp_flags & SLI4_READ_LNKSTAT_W11OF);
> +	counts[EFCT_HW_LINK_STAT_CURR_RCV_B2B_CREDIT].overflow =
> +		(mbox_rsp_flags & SLI4_READ_LNKSTAT_W12OF);
> +	counts[EFCT_HW_LINK_STAT_ADVERTISED_XMIT_B2B_CREDIT].overflow =
> +		(mbox_rsp_flags & SLI4_READ_LNKSTAT_W13OF);
> +	counts[EFCT_HW_LINK_STAT_CURR_XMIT_B2B_CREDIT].overflow =
> +		(mbox_rsp_flags & SLI4_READ_LNKSTAT_W14OF);
> +	counts[EFCT_HW_LINK_STAT_RCV_EOFA_COUNT].overflow =
> +		(mbox_rsp_flags & SLI4_READ_LNKSTAT_W15OF);
> +	counts[EFCT_HW_LINK_STAT_RCV_EOFDTI_COUNT].overflow =
> +		(mbox_rsp_flags & SLI4_READ_LNKSTAT_W16OF);
> +	counts[EFCT_HW_LINK_STAT_RCV_EOFNI_COUNT].overflow =
> +		(mbox_rsp_flags & SLI4_READ_LNKSTAT_W17OF);
> +	counts[EFCT_HW_LINK_STAT_RCV_SOFF_COUNT].overflow =
> +		(mbox_rsp_flags & SLI4_READ_LNKSTAT_W18OF);
> +	counts[EFCT_HW_LINK_STAT_RCV_DROPPED_NO_AER_COUNT].overflow =
> +		(mbox_rsp_flags & SLI4_READ_LNKSTAT_W19OF);
> +	counts[EFCT_HW_LINK_STAT_RCV_DROPPED_NO_RPI_COUNT].overflow =
> +		(mbox_rsp_flags & SLI4_READ_LNKSTAT_W20OF);
> +	counts[EFCT_HW_LINK_STAT_RCV_DROPPED_NO_XRI_COUNT].overflow =
> +		(mbox_rsp_flags & SLI4_READ_LNKSTAT_W21OF);
> +	counts[EFCT_HW_LINK_STAT_LINK_FAILURE_COUNT].counter =
> +		 le32_to_cpu(mbox_rsp->linkfail_errcnt);
> +	counts[EFCT_HW_LINK_STAT_LOSS_OF_SYNC_COUNT].counter =
> +		 le32_to_cpu(mbox_rsp->losssync_errcnt);
> +	counts[EFCT_HW_LINK_STAT_LOSS_OF_SIGNAL_COUNT].counter =
> +		 le32_to_cpu(mbox_rsp->losssignal_errcnt);
> +	counts[EFCT_HW_LINK_STAT_PRIMITIVE_SEQ_COUNT].counter =
> +		 le32_to_cpu(mbox_rsp->primseq_errcnt);
> +	counts[EFCT_HW_LINK_STAT_INVALID_XMIT_WORD_COUNT].counter =
> +		 le32_to_cpu(mbox_rsp->inval_txword_errcnt);
> +	counts[EFCT_HW_LINK_STAT_CRC_COUNT].counter =
> +		le32_to_cpu(mbox_rsp->crc_errcnt);
> +	counts[EFCT_HW_LINK_STAT_PRIMITIVE_SEQ_TIMEOUT_COUNT].counter =
> +		le32_to_cpu(mbox_rsp->primseq_eventtimeout_cnt);
> +	counts[EFCT_HW_LINK_STAT_ELASTIC_BUFFER_OVERRUN_COUNT].counter =
> +		 le32_to_cpu(mbox_rsp->elastic_bufoverrun_errcnt);
> +	counts[EFCT_HW_LINK_STAT_ARB_TIMEOUT_COUNT].counter =
> +		 le32_to_cpu(mbox_rsp->arbit_fc_al_timeout_cnt);
> +	counts[EFCT_HW_LINK_STAT_ADVERTISED_RCV_B2B_CREDIT].counter =
> +		 le32_to_cpu(mbox_rsp->adv_rx_buftor_to_buf_credit);
> +	counts[EFCT_HW_LINK_STAT_CURR_RCV_B2B_CREDIT].counter =
> +		 le32_to_cpu(mbox_rsp->curr_rx_buf_to_buf_credit);
> +	counts[EFCT_HW_LINK_STAT_ADVERTISED_XMIT_B2B_CREDIT].counter =
> +		 le32_to_cpu(mbox_rsp->adv_tx_buf_to_buf_credit);
> +	counts[EFCT_HW_LINK_STAT_CURR_XMIT_B2B_CREDIT].counter =
> +		 le32_to_cpu(mbox_rsp->curr_tx_buf_to_buf_credit);
> +	counts[EFCT_HW_LINK_STAT_RCV_EOFA_COUNT].counter =
> +		 le32_to_cpu(mbox_rsp->rx_eofa_cnt);
> +	counts[EFCT_HW_LINK_STAT_RCV_EOFDTI_COUNT].counter =
> +		 le32_to_cpu(mbox_rsp->rx_eofdti_cnt);
> +	counts[EFCT_HW_LINK_STAT_RCV_EOFNI_COUNT].counter =
> +		 le32_to_cpu(mbox_rsp->rx_eofni_cnt);
> +	counts[EFCT_HW_LINK_STAT_RCV_SOFF_COUNT].counter =
> +		 le32_to_cpu(mbox_rsp->rx_soff_cnt);
> +	counts[EFCT_HW_LINK_STAT_RCV_DROPPED_NO_AER_COUNT].counter =
> +		 le32_to_cpu(mbox_rsp->rx_dropped_no_aer_cnt);
> +	counts[EFCT_HW_LINK_STAT_RCV_DROPPED_NO_RPI_COUNT].counter =
> +		 le32_to_cpu(mbox_rsp->rx_dropped_no_avail_rpi_rescnt);
> +	counts[EFCT_HW_LINK_STAT_RCV_DROPPED_NO_XRI_COUNT].counter =
> +		 le32_to_cpu(mbox_rsp->rx_dropped_no_avail_xri_rescnt);

Is there not a better way to do this? This is just a wall of characters.

> +
> +	if (cb_arg) {
> +		if (cb_arg->cb) {
> +			if (status == 0 && le16_to_cpu(mbox_rsp->hdr.status))
> +				status = le16_to_cpu(mbox_rsp->hdr.status);
> +			cb_arg->cb(status, num_counters, counts, cb_arg->arg);
> +		}
> +
> +		kfree(cb_arg);
> +	}
> +	kfree(mqe);
> +
> +	return EFC_SUCCESS;
> +}
> +
> +enum efct_hw_rtn
> +efct_hw_get_link_stats(struct efct_hw *hw,
> +		       u8 req_ext_counters,
> +		       u8 clear_overflow_flags,
> +		       u8 clear_all_counters,
> +		       void (*cb)(int status,
> +				  u32 num_counters,
> +			struct efct_hw_link_stat_counts *counters,
> +			void *arg),
> +		       void *arg)
> +{
> +	enum efct_hw_rtn rc = EFCT_HW_RTN_ERROR;
> +	struct efct_hw_link_stat_cb_arg *cb_arg;
> +	u8 *mbxdata;
> +
> +	mbxdata = kmalloc(SLI4_BMBX_SIZE, GFP_ATOMIC);
> +	if (!mbxdata)
> +		return EFCT_HW_RTN_NO_MEMORY;
> +
> +	memset(mbxdata, 0, SLI4_BMBX_SIZE);

kzalloc

> +
> +	cb_arg = kmalloc(sizeof(*cb_arg), GFP_ATOMIC);
> +	if (!cb_arg) {
> +		kfree(mbxdata);
> +		return EFCT_HW_RTN_NO_MEMORY;
> +	}
> +
> +	cb_arg->cb = cb;
> +	cb_arg->arg = arg;
> +
> +	/* Send the HW command */
> +	if (!sli_cmd_read_link_stats(&hw->sli, mbxdata, SLI4_BMBX_SIZE,
> +				    req_ext_counters,
> +				    clear_overflow_flags,
> +				    clear_all_counters))
> +		rc = efct_hw_command(hw, mbxdata, EFCT_CMD_NOWAIT,
> +				     efct_hw_cb_link_stat, cb_arg);
> +
> +	if (rc != EFCT_HW_RTN_SUCCESS) {
> +		kfree(mbxdata);
> +		kfree(cb_arg);
> +	}
> +
> +	return rc;
> +}
> +
> +static int
> +efct_hw_cb_host_stat(struct efct_hw *hw, int status,
> +		     u8 *mqe, void  *arg)
> +{
> +	struct sli4_cmd_read_status *mbox_rsp =
> +					(struct sli4_cmd_read_status *)mqe;
> +	struct efct_hw_host_stat_cb_arg *cb_arg = arg;
> +	struct efct_hw_host_stat_counts counts[EFCT_HW_HOST_STAT_MAX];
> +	u32 num_counters = EFCT_HW_HOST_STAT_MAX;
> +
> +	memset(counts, 0, sizeof(struct efct_hw_host_stat_counts) *
> +		   EFCT_HW_HOST_STAT_MAX);
> +
> +	counts[EFCT_HW_HOST_STAT_TX_KBYTE_COUNT].counter =
> +		 le32_to_cpu(mbox_rsp->trans_kbyte_cnt);
> +	counts[EFCT_HW_HOST_STAT_RX_KBYTE_COUNT].counter =
> +		 le32_to_cpu(mbox_rsp->recv_kbyte_cnt);
> +	counts[EFCT_HW_HOST_STAT_TX_FRAME_COUNT].counter =
> +		 le32_to_cpu(mbox_rsp->trans_frame_cnt);
> +	counts[EFCT_HW_HOST_STAT_RX_FRAME_COUNT].counter =
> +		 le32_to_cpu(mbox_rsp->recv_frame_cnt);
> +	counts[EFCT_HW_HOST_STAT_TX_SEQ_COUNT].counter =
> +		 le32_to_cpu(mbox_rsp->trans_seq_cnt);
> +	counts[EFCT_HW_HOST_STAT_RX_SEQ_COUNT].counter =
> +		 le32_to_cpu(mbox_rsp->recv_seq_cnt);
> +	counts[EFCT_HW_HOST_STAT_TOTAL_EXCH_ORIG].counter =
> +		 le32_to_cpu(mbox_rsp->tot_exchanges_orig);
> +	counts[EFCT_HW_HOST_STAT_TOTAL_EXCH_RESP].counter =
> +		 le32_to_cpu(mbox_rsp->tot_exchanges_resp);
> +	counts[EFCT_HW_HOSY_STAT_RX_P_BSY_COUNT].counter =
> +		 le32_to_cpu(mbox_rsp->recv_p_bsy_cnt);
> +	counts[EFCT_HW_HOST_STAT_RX_F_BSY_COUNT].counter =
> +		 le32_to_cpu(mbox_rsp->recv_f_bsy_cnt);
> +	counts[EFCT_HW_HOST_STAT_DROP_FRM_DUE_TO_NO_RQ_BUF_COUNT].counter =
> +		 le32_to_cpu(mbox_rsp->no_rq_buf_dropped_frames_cnt);
> +	counts[EFCT_HW_HOST_STAT_EMPTY_RQ_TIMEOUT_COUNT].counter =
> +		 le32_to_cpu(mbox_rsp->empty_rq_timeout_cnt);
> +	counts[EFCT_HW_HOST_STAT_DROP_FRM_DUE_TO_NO_XRI_COUNT].counter =
> +		 le32_to_cpu(mbox_rsp->no_xri_dropped_frames_cnt);
> +	counts[EFCT_HW_HOST_STAT_EMPTY_XRI_POOL_COUNT].counter =
> +		 le32_to_cpu(mbox_rsp->empty_xri_pool_cnt);
> +
> +	if (cb_arg) {
> +		if (cb_arg->cb) {
> +			if (status == 0 && le16_to_cpu(mbox_rsp->hdr.status))
> +				status = le16_to_cpu(mbox_rsp->hdr.status);
> +			cb_arg->cb(status, num_counters, counts, cb_arg->arg);
> +		}
> +
> +		kfree(cb_arg);
> +	}
> +	kfree(mqe);
> +
> +	return EFC_SUCCESS;
> +}
> +
> +enum efct_hw_rtn
> +efct_hw_get_host_stats(struct efct_hw *hw, u8 cc,
> +		       void (*cb)(int status,
> +				  u32 num_counters,
> +				  struct efct_hw_host_stat_counts *counters,
> +				  void *arg),
> +		       void *arg)
> +{
> +	enum efct_hw_rtn rc = EFCT_HW_RTN_ERROR;
> +	struct efct_hw_host_stat_cb_arg *cb_arg;
> +	u8 *mbxdata;
> +
> +	mbxdata = kmalloc(SLI4_BMBX_SIZE, GFP_ATOMIC);
> +	if (!mbxdata)
> +		return EFCT_HW_RTN_NO_MEMORY;
> +
> +	memset(mbxdata, 0, SLI4_BMBX_SIZE);
> +
> +	cb_arg = kmalloc(sizeof(*cb_arg), GFP_ATOMIC);
> +	if (!cb_arg) {
> +		kfree(mbxdata);
> +		return EFCT_HW_RTN_NO_MEMORY;
> +	}
> +
> +	 cb_arg->cb = cb;
> +	 cb_arg->arg = arg;
> +
> +	 /* Send the HW command to get the host stats */
> +	if (!sli_cmd_read_status(&hw->sli, mbxdata, SLI4_BMBX_SIZE, cc))
> +		rc = efct_hw_command(hw, mbxdata, EFCT_CMD_NOWAIT,
> +				     efct_hw_cb_host_stat, cb_arg);
> +
> +	if (rc != EFCT_HW_RTN_SUCCESS) {
> +		efc_log_test(hw->os, "READ_HOST_STATS failed\n");
> +		kfree(mbxdata);
> +		kfree(cb_arg);
> +	}
> +
> +	return rc;
> +}
> diff --git a/drivers/scsi/elx/efct/efct_hw.h b/drivers/scsi/elx/efct/efct_hw.h
> index 36a832f32616..0b6838c7f924 100644
> --- a/drivers/scsi/elx/efct/efct_hw.h
> +++ b/drivers/scsi/elx/efct/efct_hw.h
> @@ -733,4 +733,43 @@ efct_hw_srrs_send(struct efct_hw *hw, enum efct_hw_io_type type,
>  		  efct_hw_srrs_cb_t cb,
>  		  void *arg);
>  
> +/* Function for retrieving SFP data */
> +extern enum efct_hw_rtn
> +efct_hw_get_sfp(struct efct_hw *hw, u16 page,
> +		void (*cb)(int, u32, u8 *, void *), void *arg);
> +
> +/* Function for retrieving temperature data */
> +extern enum efct_hw_rtn
> +efct_hw_get_temperature(struct efct_hw *hw,
> +			void (*efct_hw_temp_cb_t)(int status,
> +						  u32 curr_temp,
> +				u32 crit_temp_thrshld,
> +				u32 warn_temp_thrshld,
> +				u32 norm_temp_thrshld,
> +				u32 fan_off_thrshld,
> +				u32 fan_on_thrshld,
> +				void *arg),
> +			void *arg);
> +
> +/* Function for retrieving link statistics */
> +extern enum efct_hw_rtn
> +efct_hw_get_link_stats(struct efct_hw *hw,
> +		       u8 req_ext_counters,
> +		u8 clear_overflow_flags,
> +		u8 clear_all_counters,
> +		void (*efct_hw_link_stat_cb_t)(int status,
> +					       u32 num_counters,
> +			struct efct_hw_link_stat_counts *counters,
> +			void *arg),
> +		void *arg);
> +/* Function for retrieving host statistics */
> +extern enum efct_hw_rtn
> +efct_hw_get_host_stats(struct efct_hw *hw,
> +		       u8 cc,
> +		void (*efct_hw_host_stat_cb_t)(int status,
> +					       u32 num_counters,
> +			struct efct_hw_host_stat_counts *counters,
> +			void *arg),
> +		void *arg);
> +
>  #endif /* __EFCT_H__ */
> -- 
> 2.16.4
> 

Thanks,
Daniel
