Return-Path: <SRS0=iRB6=6A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A38DC2BB85
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 10:01:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 524052076A
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 10:01:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504241AbgDPKBo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Apr 2020 06:01:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:46822 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504147AbgDPKBk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Apr 2020 06:01:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6CCC6AD71;
        Thu, 16 Apr 2020 10:01:36 +0000 (UTC)
Subject: Re: [PATCH v3 28/31] elx: efct: Firmware update, async link
 processing
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     dwagner@suse.de, maier@linux.ibm.com, bvanassche@acm.org,
        herbszt@gmx.de, natechancellor@gmail.com, rdunlap@infradead.org,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-29-jsmart2021@gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <46b259de-8107-9de6-294a-a58a6d184fb4@suse.de>
Date:   Thu, 16 Apr 2020 12:01:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200412033303.29574-29-jsmart2021@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/12/20 5:33 AM, James Smart wrote:
> This patch continues the efct driver population.
> 
> This patch adds driver definitions for:
> Handling of async link event.
> Registrations for VFI, VPI and RPI.
> Add Firmware update helper routines.
> 
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> 
> ---
> v3:
>    Reworked efct_hw_port_attach_reg_vpi() and efct_hw_port_attach_reg_vfi()
>    Return defined values
> ---
>   drivers/scsi/elx/efct/efct_hw.c | 1509 +++++++++++++++++++++++++++++++++++++++
>   drivers/scsi/elx/efct/efct_hw.h |   58 ++
>   2 files changed, 1567 insertions(+)
> 
> diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
> index a007ca98895d..b3a1ec0f674b 100644
> --- a/drivers/scsi/elx/efct/efct_hw.c
> +++ b/drivers/scsi/elx/efct/efct_hw.c
> @@ -42,6 +42,12 @@ struct efct_hw_host_stat_cb_arg {
>   	void *arg;
>   };
>   
> +struct efct_hw_fw_wr_cb_arg {
> +	void (*cb)(int status, u32 bytes_written,
> +		   u32 change_status, void *arg);
> +	void *arg;
> +};
> +
>   static enum efct_hw_rtn
>   efct_hw_link_event_init(struct efct_hw *hw)
>   {
> @@ -3836,3 +3842,1506 @@ efct_hw_get_num_eq(struct efct_hw *hw)
>   {
>   	return hw->eq_count;
>   }
> +
> +/* HW async call context structure */
> +struct efct_hw_async_call_ctx {
> +	efct_hw_async_cb_t callback;
> +	void *arg;
> +	u8 cmd[SLI4_BMBX_SIZE];
> +};
> +
> +static void
> +efct_hw_async_cb(struct efct_hw *hw, int status, u8 *mqe, void *arg)
> +{
> +	struct efct_hw_async_call_ctx *ctx = arg;
> +
> +	if (ctx) {
> +		if (ctx->callback)
> +			(*ctx->callback)(hw, status, mqe, ctx->arg);
> +
> +		kfree(ctx);
> +	}
> +}
> +
> +/*
> + * Post a NOP mbox cmd; the callback with argument is invoked upon completion
> + * while in the event processing context.
> + */
> +int
> +efct_hw_async_call(struct efct_hw *hw,
> +		   efct_hw_async_cb_t callback, void *arg)
> +{
> +	int rc = 0;
> +	struct efct_hw_async_call_ctx *ctx;
> +
> +	/*
> +	 * Allocate a callback context (which includes the mbox cmd buffer),
> +	 * we need this to be persistent as the mbox cmd submission may be
> +	 * queued and executed later execution.
> +	 */
> +	ctx = kmalloc(sizeof(*ctx), GFP_ATOMIC);
> +	if (!ctx)
> +		return EFCT_HW_RTN_NO_MEMORY;
> +
> +	memset(ctx, 0, sizeof(*ctx));
> +	ctx->callback = callback;
> +	ctx->arg = arg;
> +

Please use memory pools.

> +	/* Build and send a NOP mailbox command */
> +	if (sli_cmd_common_nop(&hw->sli, ctx->cmd, sizeof(ctx->cmd), 0)) {
> +		efc_log_err(hw->os, "COMMON_NOP format failure\n");
> +		kfree(ctx);
> +		rc = -1;
> +	}
> +
> +	if (efct_hw_command(hw, ctx->cmd, EFCT_CMD_NOWAIT, efct_hw_async_cb,
> +			    ctx)) {
> +		efc_log_err(hw->os, "COMMON_NOP command failure\n");
> +		kfree(ctx);
> +		rc = -1;
> +	}
> +	return rc;
> +}
> +
> +static void
> +efct_hw_port_free_resources(struct efc_sli_port *sport, int evt, void *data)
> +{
> +	struct efct_hw *hw = sport->hw;
> +	struct efct *efct = hw->os;
> +
> +	/* Clear the sport attached flag */
> +	sport->attached = false;
> +
> +	/* Free the service parameters buffer */
> +	if (sport->dma.virt) {
> +		dma_free_coherent(&efct->pcidev->dev,
> +				  sport->dma.size, sport->dma.virt,
> +				  sport->dma.phys);
> +		memset(&sport->dma, 0, sizeof(struct efc_dma));
> +	}
> +
> +	/* Free the command buffer */
> +	kfree(data);
> +
> +	/* Free the SLI resources */
> +	sli_resource_free(&hw->sli, SLI_RSRC_VPI, sport->indicator);
> +
> +	efc_lport_cb(efct->efcport, evt, sport);
> +}
> +
> +static int
> +efct_hw_port_get_mbox_status(struct efc_sli_port *sport,
> +			     u8 *mqe, int status)
> +{
> +	struct efct_hw *hw = sport->hw;
> +	struct sli4_mbox_command_header *hdr =
> +			(struct sli4_mbox_command_header *)mqe;
> +	int rc = 0;
> +
> +	if (status || le16_to_cpu(hdr->status)) {
> +		efc_log_debug(hw->os, "bad status vpi=%#x st=%x hdr=%x\n",
> +			       sport->indicator, status,
> +			       le16_to_cpu(hdr->status));
> +		rc = -1;
> +	}
> +
> +	return rc;
> +}
> +
> +static int
> +efct_hw_port_free_unreg_vpi_cb(struct efct_hw *hw,
> +			       int status, u8 *mqe, void *arg)
> +{
> +	struct efc_sli_port *sport = arg;
> +	int evt = EFC_HW_PORT_FREE_OK;
> +	int rc = 0;
> +
> +	rc = efct_hw_port_get_mbox_status(sport, mqe, status);
> +	if (rc) {
> +		evt = EFC_HW_PORT_FREE_FAIL;
> +		rc = -1;
> +	}
> +
> +	efct_hw_port_free_resources(sport, evt, mqe);
> +	return rc;
> +}
> +
> +static void
> +efct_hw_port_free_unreg_vpi(struct efc_sli_port *sport, void *data)
> +{
> +	struct efct_hw *hw = sport->hw;
> +	int rc;
> +
> +	/* Allocate memory and send unreg_vpi */
> +	if (!data) {
> +		data = kmalloc(SLI4_BMBX_SIZE, GFP_ATOMIC);
> +		if (!data) {
> +			efct_hw_port_free_resources(sport,
> +						    EFC_HW_PORT_FREE_FAIL,
> +						    data);
> +			return;
> +		}
> +		memset(data, 0, SLI4_BMBX_SIZE);
> +	}
> +
> +	rc = sli_cmd_unreg_vpi(&hw->sli, data, SLI4_BMBX_SIZE,
> +			       sport->indicator, SLI4_UNREG_TYPE_PORT);
> +	if (rc) {
> +		efc_log_err(hw->os, "UNREG_VPI format failure\n");
> +		efct_hw_port_free_resources(sport,
> +					    EFC_HW_PORT_FREE_FAIL, data);
> +		return;
> +	}
> +
> +	rc = efct_hw_command(hw, data, EFCT_CMD_NOWAIT,
> +			     efct_hw_port_free_unreg_vpi_cb, sport);
> +	if (rc) {
> +		efc_log_err(hw->os, "UNREG_VPI command failure\n");
> +		efct_hw_port_free_resources(sport,
> +					    EFC_HW_PORT_FREE_FAIL, data);
> +	}
> +}
> +
> +static void
> +efct_hw_port_send_evt(struct efc_sli_port *sport, int evt, void *data)
> +{
> +	struct efct_hw *hw = sport->hw;
> +	struct efct *efct = hw->os;
> +
> +	/* Free the mbox buffer */
> +	kfree(data);
> +
> +	/* Now inform the registered callbacks */
> +	efc_lport_cb(efct->efcport, evt, sport);
> +
> +	/* Set the sport attached flag */
> +	if (evt == EFC_HW_PORT_ATTACH_OK)
> +		sport->attached = true;
> +
> +	/* If there is a pending free request, then handle it now */
> +	if (sport->free_req_pending)
> +		efct_hw_port_free_unreg_vpi(sport, NULL);
> +}
> +
> +static int
> +efct_hw_port_alloc_init_vpi_cb(struct efct_hw *hw,
> +			       int status, u8 *mqe, void *arg)
> +{
> +	struct efc_sli_port *sport = arg;
> +	int rc;
> +
> +	rc = efct_hw_port_get_mbox_status(sport, mqe, status);
> +	if (rc) {
> +		efct_hw_port_free_resources(sport,
> +					    EFC_HW_PORT_ALLOC_FAIL, mqe);
> +		return EFC_FAIL;
> +	}
> +
> +	efct_hw_port_send_evt(sport, EFC_HW_PORT_ALLOC_OK, mqe);
> +	return EFC_SUCCESS;
> +}
> +
> +static void
> +efct_hw_port_alloc_init_vpi(struct efc_sli_port *sport, void *data)
> +{
> +	struct efct_hw *hw = sport->hw;
> +	int rc;
> +
> +	/* If there is a pending free request, then handle it now */
> +	if (sport->free_req_pending) {
> +		efct_hw_port_free_resources(sport, EFC_HW_PORT_FREE_OK, data);
> +		return;
> +	}
> +
> +	rc = sli_cmd_init_vpi(&hw->sli, data, SLI4_BMBX_SIZE,
> +			      sport->indicator, sport->domain->indicator);
> +	if (rc) {
> +		efc_log_err(hw->os, "INIT_VPI format failure\n");
> +		efct_hw_port_free_resources(sport,
> +					    EFC_HW_PORT_ALLOC_FAIL, data);
> +		return;
> +	}
> +
> +	rc = efct_hw_command(hw, data, EFCT_CMD_NOWAIT,
> +			     efct_hw_port_alloc_init_vpi_cb, sport);
> +	if (rc) {
> +		efc_log_err(hw->os, "INIT_VPI command failure\n");
> +		efct_hw_port_free_resources(sport,
> +					    EFC_HW_PORT_ALLOC_FAIL, data);
> +	}
> +}
> +
> +static int
> +efct_hw_port_alloc_read_sparm64_cb(struct efct_hw *hw,
> +				   int status, u8 *mqe, void *arg)
> +{
> +	struct efc_sli_port *sport = arg;
> +	u8 *payload = NULL;
> +	struct efct *efct = hw->os;
> +	int rc;
> +
> +	rc = efct_hw_port_get_mbox_status(sport, mqe, status);
> +	if (rc) {
> +		efct_hw_port_free_resources(sport,
> +					    EFC_HW_PORT_ALLOC_FAIL, mqe);
> +		return EFC_FAIL;
> +	}
> +
> +	payload = sport->dma.virt;
> +
> +	memcpy(&sport->sli_wwpn,
> +	       payload + SLI4_READ_SPARM64_WWPN_OFFSET,
> +		sizeof(sport->sli_wwpn));
> +	memcpy(&sport->sli_wwnn,
> +	       payload + SLI4_READ_SPARM64_WWNN_OFFSET,
> +		sizeof(sport->sli_wwnn));
> +
> +	dma_free_coherent(&efct->pcidev->dev,
> +			  sport->dma.size, sport->dma.virt, sport->dma.phys);
> +	memset(&sport->dma, 0, sizeof(struct efc_dma));
> +	efct_hw_port_alloc_init_vpi(sport, mqe);
> +	return EFC_SUCCESS;
> +}
> +
> +static void
> +efct_hw_port_alloc_read_sparm64(struct efc_sli_port *sport, void *data)
> +{
> +	struct efct_hw *hw = sport->hw;
> +	struct efct *efct = hw->os;
> +	int rc;
> +
> +	/* Allocate memory for the service parameters */
> +	sport->dma.size = 112;
> +	sport->dma.virt = dma_alloc_coherent(&efct->pcidev->dev,
> +					     sport->dma.size, &sport->dma.phys,
> +					     GFP_DMA);
> +	if (!sport->dma.virt) {
> +		efc_log_err(hw->os, "Failed to allocate DMA memory\n");
> +		efct_hw_port_free_resources(sport,
> +					    EFC_HW_PORT_ALLOC_FAIL, data);
> +		return;
> +	}
> +
> +	rc = sli_cmd_read_sparm64(&hw->sli, data, SLI4_BMBX_SIZE,
> +				  &sport->dma, sport->indicator);
> +	if (rc) {
> +		efc_log_err(hw->os, "READ_SPARM64 format failure\n");
> +		efct_hw_port_free_resources(sport,
> +					    EFC_HW_PORT_ALLOC_FAIL, data);
> +		return;
> +	}
> +
> +	rc = efct_hw_command(hw, data, EFCT_CMD_NOWAIT,
> +			     efct_hw_port_alloc_read_sparm64_cb, sport);
> +	if (rc) {
> +		efc_log_err(hw->os, "READ_SPARM64 command failure\n");
> +		efct_hw_port_free_resources(sport,
> +					    EFC_HW_PORT_ALLOC_FAIL, data);
> +	}
> +}
> +
> +/*
> + * This function allocates a VPI object for the port and stores it in the
> + * indicator field of the port object.
> + */
> +enum efct_hw_rtn
> +efct_hw_port_alloc(struct efc *efc, struct efc_sli_port *sport,
> +		   struct efc_domain *domain, u8 *wwpn)
> +{
> +	struct efct *efct = efc->base;
> +	struct efct_hw *hw = &efct->hw;
> +
> +	u8	*cmd = NULL;
> +	enum efct_hw_rtn rc = EFCT_HW_RTN_SUCCESS;
> +	u32 index;
> +
> +	sport->indicator = U32_MAX;
> +	sport->hw = hw;
> +	sport->free_req_pending = false;
> +
> +	/*
> +	 * Check if the chip is in an error state (UE'd) before proceeding.
> +	 */
> +	if (sli_fw_error_status(&hw->sli) > 0) {
> +		efc_log_crit(hw->os,
> +			      "Chip is in an error state - reset needed\n");
> +		return EFCT_HW_RTN_ERROR;
> +	}
> +
> +	if (wwpn)
> +		memcpy(&sport->sli_wwpn, wwpn, sizeof(sport->sli_wwpn));
> +
> +	if (sli_resource_alloc(&hw->sli, SLI_RSRC_VPI,
> +			       &sport->indicator, &index)) {
> +		efc_log_err(hw->os, "VPI allocation failure\n");
> +		return EFCT_HW_RTN_ERROR;
> +	}
> +
> +	if (domain) {
> +		cmd = kmalloc(SLI4_BMBX_SIZE, GFP_ATOMIC);
> +		if (!cmd) {
> +			rc = EFCT_HW_RTN_NO_MEMORY;
> +			goto efct_hw_port_alloc_out;
> +		}
> +		memset(cmd, 0, SLI4_BMBX_SIZE);
> +
> +		/*
> +		 * If the WWPN is NULL, fetch the default
> +		 * WWPN and WWNN before initializing the VPI
> +		 */
> +		if (!wwpn)
> +			efct_hw_port_alloc_read_sparm64(sport, cmd);
> +		else
> +			efct_hw_port_alloc_init_vpi(sport, cmd);
> +	} else if (!wwpn) {
> +		/* This is the convention for the HW, not SLI */
> +		efc_log_test(hw->os, "need WWN for physical port\n");
> +		rc = EFCT_HW_RTN_ERROR;
> +	}
> +	/* domain NULL and wwpn non-NULL */
> +	// no-op;
> +

Please avoid C++ style coments.

> +efct_hw_port_alloc_out:
> +	if (rc != EFCT_HW_RTN_SUCCESS) {
> +		kfree(cmd);
> +
> +		sli_resource_free(&hw->sli, SLI_RSRC_VPI,
> +				  sport->indicator);
> +	}
> +
> +	return rc;
> +}
> +
> +static int
> +efct_hw_port_attach_reg_vpi_cb(struct efct_hw *hw,
> +			       int status, u8 *mqe, void *arg)
> +{
> +	struct efc_sli_port *sport = arg;
> +	int rc;
> +
> +	rc = efct_hw_port_get_mbox_status(sport, mqe, status);
> +	if (rc) {
> +		efct_hw_port_free_resources(sport,
> +					    EFC_HW_PORT_ATTACH_FAIL, mqe);
> +		return EFC_FAIL;
> +	}
> +
> +	efct_hw_port_send_evt(sport, EFC_HW_PORT_ATTACH_OK, mqe);
> +	return EFC_SUCCESS;
> +}
> +
> +/**
> + * This function registers a previously-allocated VPI with the
> + * device.
> + */
> +enum efct_hw_rtn
> +efct_hw_port_attach(struct efc *efc, struct efc_sli_port *sport,
> +		    u32 fc_id)
> +{
> +	struct efct *efct = efc->base;
> +	struct efct_hw *hw = &efct->hw;
> +
> +	u8	*buf = NULL;
> +	enum efct_hw_rtn rc = EFCT_HW_RTN_SUCCESS;
> +
> +	if (!sport) {
> +		efc_log_err(hw->os,
> +			     "bad parameter(s) hw=%p sport=%p\n", hw,
> +			sport);

Please fixup indentation.

> +		return EFCT_HW_RTN_ERROR;
> +	}
> +
> +	/*
> +	 * Check if the chip is in an error state (UE'd) before proceeding.
> +	 */
> +	if (sli_fw_error_status(&hw->sli) > 0) {
> +		efc_log_crit(hw->os,
> +			      "Chip is in an error state - reset needed\n");
> +		return EFCT_HW_RTN_ERROR;
> +	}
> +
> +	buf = kmalloc(SLI4_BMBX_SIZE, GFP_ATOMIC);
> +	if (!buf)
> +		return EFCT_HW_RTN_NO_MEMORY;
> +
> +	memset(buf, 0, SLI4_BMBX_SIZE);
> +	sport->fc_id = fc_id;
> +

Pre-allocated buffer or memory pools, please.

> +	rc = sli_cmd_reg_vpi(&hw->sli, buf, SLI4_BMBX_SIZE, sport->fc_id,
> +			    sport->sli_wwpn, sport->indicator,
> +			    sport->domain->indicator, false);
> +	if (rc) {
> +		efc_log_err(hw->os, "REG_VPI format failure\n");
> +		efct_hw_port_free_resources(sport,
> +					    EFC_HW_PORT_ATTACH_FAIL, buf);
> +		return rc;
> +	}
> +
> +	rc = efct_hw_command(hw, buf, EFCT_CMD_NOWAIT,
> +			     efct_hw_port_attach_reg_vpi_cb, sport);
> +	if (rc) {
> +		efc_log_err(hw->os, "REG_VPI command failure\n");
> +		efct_hw_port_free_resources(sport,
> +					    EFC_HW_PORT_ATTACH_FAIL, buf);
> +	}
> +
> +	return rc;
> +}
> +
> +/* Issue the UNREG_VPI command to free the assigned VPI context */
> +enum efct_hw_rtn
> +efct_hw_port_free(struct efc *efc, struct efc_sli_port *sport)
> +{
> +	struct efct *efct = efc->base;
> +	struct efct_hw *hw = &efct->hw;
> +
> +	enum efct_hw_rtn rc = EFCT_HW_RTN_SUCCESS;
> +
> +	if (!sport) {
> +		efc_log_err(hw->os,
> +			     "bad parameter(s) hw=%p sport=%p\n", hw,
> +			sport);
> +		return EFCT_HW_RTN_ERROR;
> +	}
> +
> +	/*
> +	 * Check if the chip is in an error state (UE'd) before proceeding.
> +	 */
> +	if (sli_fw_error_status(&hw->sli) > 0) {
> +		efc_log_crit(hw->os,
> +			      "Chip is in an error state - reset needed\n");
> +		return EFCT_HW_RTN_ERROR;
> +	}
> +
> +	if (sport->attached)
> +		efct_hw_port_free_unreg_vpi(sport, NULL);
> +	else
> +		sport->free_req_pending = true;
> +
> +	return rc;
> +}
> +
> +static int
> +efct_hw_domain_get_mbox_status(struct efc_domain *domain,
> +			       u8 *mqe, int status)
> +{
> +	struct efct_hw *hw = domain->hw;
> +	struct sli4_mbox_command_header *hdr =
> +			(struct sli4_mbox_command_header *)mqe;
> +	int rc = 0;
> +
> +	if (status || le16_to_cpu(hdr->status)) {
> +		efc_log_debug(hw->os, "bad status vfi=%#x st=%x hdr=%x\n",
> +			       domain->indicator, status,
> +			       le16_to_cpu(hdr->status));
> +		rc = -1;
> +	}
> +
> +	return rc;
> +}
> +
> +static void
> +efct_hw_domain_free_resources(struct efc_domain *domain,
> +			      int evt, void *data)
> +{
> +	struct efct_hw *hw = domain->hw;
> +	struct efct *efct = hw->os;
> +
> +	/* Free the service parameters buffer */
> +	if (domain->dma.virt) {
> +		dma_free_coherent(&efct->pcidev->dev,
> +				  domain->dma.size, domain->dma.virt,
> +				  domain->dma.phys);
> +		memset(&domain->dma, 0, sizeof(struct efc_dma));
> +	}
> +
> +	/* Free the command buffer */
> +	kfree(data);
> +
> +	/* Free the SLI resources */
> +	sli_resource_free(&hw->sli, SLI_RSRC_VFI, domain->indicator);
> +
> +	efc_domain_cb(efct->efcport, evt, domain);
> +}
> +
> +static void
> +efct_hw_domain_send_sport_evt(struct efc_domain *domain,
> +			      int port_evt, int domain_evt, void *data)
> +{
> +	struct efct_hw *hw = domain->hw;
> +	struct efct *efct = hw->os;
> +
> +	/* Free the mbox buffer */
> +	kfree(data);
> +
> +	/* Send alloc/attach ok to the physical sport */
> +	efct_hw_port_send_evt(domain->sport, port_evt, NULL);
> +
> +	/* Now inform the registered callbacks */
> +	efc_domain_cb(efct->efcport, domain_evt, domain);
> +}
> +
> +static int
> +efct_hw_domain_alloc_read_sparm64_cb(struct efct_hw *hw,
> +				     int status, u8 *mqe, void *arg)
> +{
> +	struct efc_domain *domain = arg;
> +	int rc;
> +
> +	rc = efct_hw_domain_get_mbox_status(domain, mqe, status);
> +	if (rc) {
> +		efct_hw_domain_free_resources(domain,
> +					      EFC_HW_DOMAIN_ALLOC_FAIL, mqe);
> +		return EFC_FAIL;
> +	}
> +
> +	hw->domain = domain;
> +	efct_hw_domain_send_sport_evt(domain, EFC_HW_PORT_ALLOC_OK,
> +				      EFC_HW_DOMAIN_ALLOC_OK, mqe);
> +	return EFC_SUCCESS;
> +}
> +
> +static void
> +efct_hw_domain_alloc_read_sparm64(struct efc_domain *domain, void *data)
> +{
> +	struct efct_hw *hw = domain->hw;
> +	int rc;
> +
> +	rc = sli_cmd_read_sparm64(&hw->sli, data, SLI4_BMBX_SIZE,
> +				  &domain->dma, 0);
> +	if (rc) {
> +		efc_log_err(hw->os, "READ_SPARM64 format failure\n");
> +		efct_hw_domain_free_resources(domain,
> +					      EFC_HW_DOMAIN_ALLOC_FAIL, data);
> +		return;
> +	}
> +
> +	rc = efct_hw_command(hw, data, EFCT_CMD_NOWAIT,
> +			     efct_hw_domain_alloc_read_sparm64_cb, domain);
> +	if (rc) {
> +		efc_log_err(hw->os, "READ_SPARM64 command failure\n");
> +		efct_hw_domain_free_resources(domain,
> +					      EFC_HW_DOMAIN_ALLOC_FAIL, data);
> +	}
> +}
> +
> +static int
> +efct_hw_domain_alloc_init_vfi_cb(struct efct_hw *hw,
> +				 int status, u8 *mqe, void *arg)
> +{
> +	struct efc_domain *domain = arg;
> +	int rc;
> +
> +	rc = efct_hw_domain_get_mbox_status(domain, mqe, status);
> +	if (rc) {
> +		efct_hw_domain_free_resources(domain,
> +					      EFC_HW_DOMAIN_ALLOC_FAIL, mqe);
> +		return EFC_FAIL;
> +	}
> +
> +	efct_hw_domain_alloc_read_sparm64(domain, mqe);
> +	return EFC_SUCCESS;
> +}
> +
> +static void
> +efct_hw_domain_alloc_init_vfi(struct efc_domain *domain, void *data)
> +{
> +	struct efct_hw *hw = domain->hw;
> +	struct efc_sli_port *sport = domain->sport;
> +	int rc;
> +
> +	/*
> +	 * For FC, the HW alread registered an FCFI.
> +	 * Copy FCF information into the domain and jump to INIT_VFI.
> +	 */
> +	domain->fcf_indicator = hw->fcf_indicator;
> +	rc = sli_cmd_init_vfi(&hw->sli, data, SLI4_BMBX_SIZE,
> +			      domain->indicator, domain->fcf_indicator,
> +			sport->indicator);
> +	if (rc) {
> +		efc_log_err(hw->os, "INIT_VFI format failure\n");
> +		efct_hw_domain_free_resources(domain,
> +					      EFC_HW_DOMAIN_ALLOC_FAIL, data);
> +		return;
> +	}
> +
> +	rc = efct_hw_command(hw, data, EFCT_CMD_NOWAIT,
> +			     efct_hw_domain_alloc_init_vfi_cb, domain);
> +	if (rc) {
> +		efc_log_err(hw->os, "INIT_VFI command failure\n");
> +		efct_hw_domain_free_resources(domain,
> +					      EFC_HW_DOMAIN_ALLOC_FAIL, data);
> +	}
> +}
> +
> +/**
> + * This function starts a series of commands needed to connect to the domain,
> + * including
> + *   - REG_FCFI
> + *   - INIT_VFI
> + *   - READ_SPARMS
> + */
> +enum efct_hw_rtn
> +efct_hw_domain_alloc(struct efc *efc, struct efc_domain *domain,
> +		     u32 fcf)
> +{
> +	struct efct *efct = efc->base;
> +	struct efct_hw *hw = &efct->hw;
> +	u8 *cmd = NULL;
> +	u32 index;
> +
> +	if (!domain || !domain->sport) {
> +		efc_log_err(efct,
> +			     "bad parameter(s) hw=%p domain=%p sport=%p\n",
> +			    hw, domain, domain ? domain->sport : NULL);
> +		return EFCT_HW_RTN_ERROR;
> +	}
> +
> +	/*
> +	 * Check if the chip is in an error state (UE'd) before proceeding.
> +	 */
> +	if (sli_fw_error_status(&hw->sli) > 0) {
> +		efc_log_crit(efct,
> +			     "Chip is in an error state - reset needed\n");
> +		return EFCT_HW_RTN_ERROR;
> +	}
> +
> +	cmd = kmalloc(SLI4_BMBX_SIZE, GFP_ATOMIC);
> +	if (!cmd)
> +		return EFCT_HW_RTN_NO_MEMORY;
> +
> +	memset(cmd, 0, SLI4_BMBX_SIZE);
> +

Same here.

> +	/* allocate memory for the service parameters */
> +	domain->dma.size = 112;
> +	domain->dma.virt = dma_alloc_coherent(&efct->pcidev->dev,
> +					      domain->dma.size,
> +					      &domain->dma.phys, GFP_DMA);
> +	if (!domain->dma.virt) {
> +		efc_log_err(hw->os, "Failed to allocate DMA memory\n");
> +		kfree(cmd);
> +		return EFCT_HW_RTN_NO_MEMORY;
> +	}
> +
> +	domain->hw = hw;
> +	domain->fcf = fcf;
> +	domain->fcf_indicator = U32_MAX;
> +	domain->indicator = U32_MAX;
> +
> +	if (sli_resource_alloc(&hw->sli,
> +			       SLI_RSRC_VFI, &domain->indicator,
> +				    &index)) {
> +		efc_log_err(hw->os, "VFI allocation failure\n");
> +
> +		kfree(cmd);
> +		dma_free_coherent(&efct->pcidev->dev,
> +				  domain->dma.size, domain->dma.virt,
> +				  domain->dma.phys);
> +		memset(&domain->dma, 0, sizeof(struct efc_dma));
> +
> +		return EFCT_HW_RTN_ERROR;
> +	}
> +
> +	efct_hw_domain_alloc_init_vfi(domain, cmd);
> +	return EFCT_HW_RTN_SUCCESS;
> +}
> +
> +static int
> +efct_hw_domain_attach_reg_vfi_cb(struct efct_hw *hw,
> +				 int status, u8 *mqe, void *arg)
> +{
> +	struct efc_domain *domain = arg;
> +	int rc;
> +
> +	rc = efct_hw_domain_get_mbox_status(domain, mqe, status);
> +	if (rc) {
> +		hw->domain = NULL;
> +		efct_hw_domain_free_resources(domain,
> +					      EFC_HW_DOMAIN_ATTACH_FAIL, mqe);
> +		return EFC_FAIL;
> +	}
> +
> +	efct_hw_domain_send_sport_evt(domain, EFC_HW_PORT_ATTACH_OK,
> +				      EFC_HW_DOMAIN_ATTACH_OK, mqe);
> +	return EFC_SUCCESS;
> +}
> +
> +enum efct_hw_rtn
> +efct_hw_domain_attach(struct efc *efc,
> +		      struct efc_domain *domain, u32 fc_id)
> +{
> +	struct efct *efct = efc->base;
> +	struct efct_hw *hw = &efct->hw;
> +

Unneccesary newline.

> +	u8	*buf = NULL;
> +	enum efct_hw_rtn rc = EFCT_HW_RTN_SUCCESS;
> +
> +	if (!domain) {
> +		efc_log_err(hw->os,
> +			     "bad parameter(s) hw=%p domain=%p\n",
> +			hw, domain);

Indentation.

> +		return EFCT_HW_RTN_ERROR;
> +	}
> +
> +	/*
> +	 * Check if the chip is in an error state (UE'd) before proceeding.
> +	 */
> +	if (sli_fw_error_status(&hw->sli) > 0) {
> +		efc_log_crit(hw->os,
> +			      "Chip is in an error state - reset needed\n");
> +		return EFCT_HW_RTN_ERROR;
> +	}
> +
> +	buf = kmalloc(SLI4_BMBX_SIZE, GFP_ATOMIC);
> +	if (!buf)
> +		return EFCT_HW_RTN_NO_MEMORY;
> +
> +	memset(buf, 0, SLI4_BMBX_SIZE);
> +	domain->sport->fc_id = fc_id;
> +
> +	rc = sli_cmd_reg_vfi(&hw->sli, buf, SLI4_BMBX_SIZE, domain->indicator,
> +			    domain->fcf_indicator, domain->dma,
> +			    domain->sport->indicator, domain->sport->sli_wwpn,
> +			    domain->sport->fc_id);

Why not pass 'domain' as parameter and reduce the number of arguments?

> +	if (rc) {
> +		efc_log_err(hw->os, "REG_VFI format failure\n");
> +		goto cleanup;
> +	}
> +
> +	rc = efct_hw_command(hw, buf, EFCT_CMD_NOWAIT,
> +			     efct_hw_domain_attach_reg_vfi_cb, domain);
> +	if (rc) {
> +		efc_log_err(hw->os, "REG_VFI command failure\n");
> +		goto cleanup;
> +	}
> +
> +	return rc;
> +
> +cleanup:
> +	hw->domain = NULL;
> +	efct_hw_domain_free_resources(domain, EFC_HW_DOMAIN_ATTACH_FAIL, buf);
> +
> +	return rc;
> +}
> +
> +static int
> +efct_hw_domain_free_unreg_vfi_cb(struct efct_hw *hw,
> +				 int status, u8 *mqe, void *arg)
> +{
> +	struct efc_domain *domain = arg;
> +	int evt = EFC_HW_DOMAIN_FREE_OK;
> +	int rc = 0;
> +
> +	rc = efct_hw_domain_get_mbox_status(domain, mqe, status);
> +	if (rc) {
> +		evt = EFC_HW_DOMAIN_FREE_FAIL;
> +		rc = -1;
> +	}
> +
> +	hw->domain = NULL;
> +	efct_hw_domain_free_resources(domain, evt, mqe);
> +	return rc;
> +}
> +
> +static void
> +efct_hw_domain_free_unreg_vfi(struct efc_domain *domain, void *data)
> +{
> +	struct efct_hw *hw = domain->hw;
> +	int rc;
> +
> +	if (!data) {
> +		data = kzalloc(SLI4_BMBX_SIZE, GFP_ATOMIC);
> +		if (!data)
> +			goto cleanup;
> +	}
> +

Mempool?

> +	rc = sli_cmd_unreg_vfi(&hw->sli, data, SLI4_BMBX_SIZE,
> +			       domain->indicator, SLI4_UNREG_TYPE_DOMAIN);
> +	if (rc) {
> +		efc_log_err(hw->os, "UNREG_VFI format failure\n");
> +		goto cleanup;
> +	}
> +
> +	rc = efct_hw_command(hw, data, EFCT_CMD_NOWAIT,
> +			     efct_hw_domain_free_unreg_vfi_cb, domain);
> +	if (rc) {
> +		efc_log_err(hw->os, "UNREG_VFI command failure\n");
> +		goto cleanup;
> +	}
> +
> +	return;
> +
> +cleanup:
> +	hw->domain = NULL;
> +	efct_hw_domain_free_resources(domain, EFC_HW_DOMAIN_FREE_FAIL, data);
> +}
> +
> +enum efct_hw_rtn
> +efct_hw_domain_free(struct efc *efc, struct efc_domain *domain)
> +{
> +	struct efct *efct = efc->base;
> +	struct efct_hw *hw = &efct->hw;
> +
> +	enum efct_hw_rtn	rc = EFCT_HW_RTN_SUCCESS;
> +
> +	if (!domain) {
> +		efc_log_err(hw->os,
> +			     "bad parameter(s) hw=%p domain=%p\n",
> +			hw, domain);
> +		return EFCT_HW_RTN_ERROR;
> +	}
> +
> +	/*
> +	 * Check if the chip is in an error state (UE'd) before proceeding.
> +	 */
> +	if (sli_fw_error_status(&hw->sli) > 0) {
> +		efc_log_crit(hw->os,
> +			      "Chip is in an error state - reset needed\n");
> +		return EFCT_HW_RTN_ERROR;
> +	}
> +
> +	efct_hw_domain_free_unreg_vfi(domain, NULL);
> +	return rc;
> +}
> +
> +enum efct_hw_rtn
> +efct_hw_domain_force_free(struct efc *efc, struct efc_domain *domain)
> +{
> +	struct efct *efct = efc->base;
> +	struct efct_hw *hw = &efct->hw;
> +
> +	if (!domain) {
> +		efc_log_err(efct,
> +			     "bad parameter(s) hw=%p domain=%p\n", hw, domain);
> +		return EFCT_HW_RTN_ERROR;
> +	}
> +
> +	dma_free_coherent(&efct->pcidev->dev,
> +			  domain->dma.size, domain->dma.virt, domain->dma.phys);
> +	memset(&domain->dma, 0, sizeof(struct efc_dma));
> +	sli_resource_free(&hw->sli, SLI_RSRC_VFI,
> +			  domain->indicator);
> +
> +	return EFCT_HW_RTN_SUCCESS;
> +}
> +
> +enum efct_hw_rtn
> +efct_hw_node_alloc(struct efc *efc, struct efc_remote_node *rnode,
> +		   u32 fc_addr, struct efc_sli_port *sport)
> +{
> +	struct efct *efct = efc->base;
> +	struct efct_hw *hw = &efct->hw;
> +
> +	/* Check for invalid indicator */
> +	if (rnode->indicator != U32_MAX) {
> +		efc_log_err(hw->os,
> +			     "RPI allocation failure addr=%#x rpi=%#x\n",
> +			    fc_addr, rnode->indicator);
> +		return EFCT_HW_RTN_ERROR;
> +	}
> +
> +	/*
> +	 * Check if the chip is in an error state (UE'd) before proceeding.
> +	 */
> +	if (sli_fw_error_status(&hw->sli) > 0) {
> +		efc_log_crit(hw->os,
> +			      "Chip is in an error state - reset needed\n");
> +		return EFCT_HW_RTN_ERROR;
> +	}
> +
> +	/* NULL SLI port indicates an unallocated remote node */
> +	rnode->sport = NULL;
> +
> +	if (sli_resource_alloc(&hw->sli, SLI_RSRC_RPI,
> +			       &rnode->indicator, &rnode->index)) {
> +		efc_log_err(hw->os, "RPI allocation failure addr=%#x\n",
> +			     fc_addr);
> +		return EFCT_HW_RTN_ERROR;
> +	}
> +
> +	rnode->fc_id = fc_addr;
> +	rnode->sport = sport;
> +
> +	return EFCT_HW_RTN_SUCCESS;
> +}
> +

Locking?
Please add a lockdep annotation so that one knows which locks should've 
been taken.

> +static int
> +efct_hw_cb_node_attach(struct efct_hw *hw, int status,
> +		       u8 *mqe, void *arg)
> +{
> +	struct efc_remote_node *rnode = arg;
> +	struct sli4_mbox_command_header *hdr =
> +				(struct sli4_mbox_command_header *)mqe;
> +	enum efc_hw_remote_node_event	evt = 0;
> +
Unnessasary newline.

> +	struct efct   *efct = hw->os;
> +
> +	if (status || le16_to_cpu(hdr->status)) {
> +		efc_log_debug(hw->os, "bad status cqe=%#x mqe=%#x\n", status,
> +			       le16_to_cpu(hdr->status));
> +		atomic_sub_return(1, &hw->rpi_ref[rnode->index].rpi_count);
> +		rnode->attached = false;
> +		atomic_set(&hw->rpi_ref[rnode->index].rpi_attached, 0);
> +		evt = EFC_HW_NODE_ATTACH_FAIL;
> +	} else {
> +		rnode->attached = true;
> +		atomic_set(&hw->rpi_ref[rnode->index].rpi_attached, 1);
> +		evt = EFC_HW_NODE_ATTACH_OK;
> +	}
> +
> +	efc_remote_node_cb(efct->efcport, evt, rnode);
> +
> +	kfree(mqe);

Personally, I find it bad style to call 'kfree' on a passed in 
parameter. One is never show what happens to the parameter if the 
function fails, _and_ the argument itself is actually immutable, so the 
caller has no way of checking if the argument actually has been freed.
Please move the kfree() call to the calling function.

> +
> +	return EFC_SUCCESS;
> +}
> +
> +/* Update a remote node object with the remote port's service parameters */
> +enum efct_hw_rtn
> +efct_hw_node_attach(struct efc *efc, struct efc_remote_node *rnode,
> +		    struct efc_dma *sparms)
> +{
> +	struct efct *efct = efc->base;
> +	struct efct_hw *hw = &efct->hw;
> +
> +	enum efct_hw_rtn	rc = EFCT_HW_RTN_ERROR;
> +	u8		*buf = NULL;
> +	u32	count = 0;
> +
> +	if (!hw || !rnode || !sparms) {
> +		efc_log_err(efct,
> +			     "bad parameter(s) hw=%p rnode=%p sparms=%p\n",
> +			    hw, rnode, sparms);
> +		return EFCT_HW_RTN_ERROR;
> +	}
> +
> +	/*
> +	 * Check if the chip is in an error state (UE'd) before proceeding.
> +	 */
> +	if (sli_fw_error_status(&hw->sli) > 0) {
> +		efc_log_crit(hw->os,
> +			      "Chip is in an error state - reset needed\n");
> +		return EFCT_HW_RTN_ERROR;
> +	}
> +
> +	buf = kmalloc(SLI4_BMBX_SIZE, GFP_ATOMIC);
> +	if (!buf)
> +		return EFCT_HW_RTN_NO_MEMORY;
> +
> +	memset(buf, 0, SLI4_BMBX_SIZE);

Mempool ...

> +	/*
> +	 * If the attach count is non-zero, this RPI has already been reg'd.
> +	 * Otherwise, register the RPI
> +	 */
> +	if (rnode->index == U32_MAX) {
> +		efc_log_err(efct, "bad parameter rnode->index invalid\n");
> +		kfree(buf);
> +		return EFCT_HW_RTN_ERROR;
> +	}
> +	count = atomic_add_return(1, &hw->rpi_ref[rnode->index].rpi_count);
> +	count--;
> +	if (count) {

What on earth ...
Care to explain what you are attempting here?
Increasing a value just to decrease it again?

> +		/*
> +		 * Can't attach multiple FC_ID's to a node unless High Login
> +		 * Mode is enabled
> +		 */
> +		if (!hw->sli.high_login_mode) {
> +			efc_log_test(hw->os,
> +				      "attach to attached node HLM=%d cnt=%d\n",
> +				     hw->sli.high_login_mode, count);
> +			rc = EFCT_HW_RTN_SUCCESS;
> +		} else {
> +			rnode->node_group = true;
> +			rnode->attached =
> +			 atomic_read(&hw->rpi_ref[rnode->index].rpi_attached);
> +			rc = rnode->attached  ? EFCT_HW_RTN_SUCCESS_SYNC :
> +							 EFCT_HW_RTN_SUCCESS;
> +		}
> +	} else {
> +		rnode->node_group = false;
> +
> +		if (!sli_cmd_reg_rpi(&hw->sli, buf, SLI4_BMBX_SIZE,
> +				    rnode->fc_id,
> +				    rnode->indicator, rnode->sport->indicator,
> +				    sparms, 0, 0))
> +			rc = efct_hw_command(hw, buf, EFCT_CMD_NOWAIT,
> +					     efct_hw_cb_node_attach, rnode);
> +	}
> +
> +	if (count || rc) {
> +		if (rc < EFCT_HW_RTN_SUCCESS) {
> +			atomic_sub_return(1,
> +					  &hw->rpi_ref[rnode->index].rpi_count);
> +			efc_log_err(hw->os,
> +				     "%s error\n", count ? "HLM" : "REG_RPI");
> +		}
> +		kfree(buf);
> +	}
> +
> +	return rc;
> +}
> +
> +enum efct_hw_rtn
> +efct_hw_node_free_resources(struct efc *efc,
> +			    struct efc_remote_node *rnode)
> +{
> +	struct efct *efct = efc->base;
> +	struct efct_hw *hw = &efct->hw;
> +	enum efct_hw_rtn	rc = EFCT_HW_RTN_SUCCESS;
> +
> +	if (!hw || !rnode) {
> +		efc_log_err(efct, "bad parameter(s) hw=%p rnode=%p\n",
> +			     hw, rnode);
> +		return EFCT_HW_RTN_ERROR;
> +	}
> +
> +	if (rnode->sport) {
> +		if (rnode->attached) {
> +			efc_log_err(hw->os, "Err: rnode is still attached\n");
> +			return EFCT_HW_RTN_ERROR;
> +		}
> +		if (rnode->indicator != U32_MAX) {
> +			if (sli_resource_free(&hw->sli, SLI_RSRC_RPI,
> +					      rnode->indicator)) {
> +				efc_log_err(hw->os,
> +					     "RPI free fail RPI %d addr=%#x\n",
> +					    rnode->indicator,
> +					    rnode->fc_id);
> +				rc = EFCT_HW_RTN_ERROR;
> +			} else {
> +				rnode->node_group = false;
> +				rnode->indicator = U32_MAX;
> +				rnode->index = U32_MAX;
> +				rnode->free_group = false;
> +			}
> +		}
> +	}
> +
> +	return rc;
> +}
> +

Locking?

> +static int
> +efct_hw_cb_node_free(struct efct_hw *hw,
> +		     int status, u8 *mqe, void *arg)
> +{
> +	struct efc_remote_node *rnode = arg;
> +	struct sli4_mbox_command_header *hdr =
> +				(struct sli4_mbox_command_header *)mqe;
> +	enum efc_hw_remote_node_event evt = EFC_HW_NODE_FREE_FAIL;
> +	int		rc = 0;
> +	struct efct   *efct = hw->os;
> +
> +	if (status || le16_to_cpu(hdr->status)) {
> +		efc_log_debug(hw->os, "bad status cqe=%#x mqe=%#x\n", status,
> +			       le16_to_cpu(hdr->status));
> +
> +		/*
> +		 * In certain cases, a non-zero MQE status is OK (all must be
> +		 * true):
> +		 *   - node is attached
> +		 *   - if High Login Mode is enabled, node is part of a node
> +		 * group
> +		 *   - status is 0x1400
> +		 */
> +		if (!rnode->attached ||
> +		    (hw->sli.high_login_mode && !rnode->node_group) ||
> +				(le16_to_cpu(hdr->status) !=
> +				 MBX_STATUS_RPI_NOT_REG))
> +			rc = -1;
> +	}
> +
> +	if (rc == 0) {
> +		rnode->node_group = false;
> +		rnode->attached = false;
> +
> +		if (atomic_read(&hw->rpi_ref[rnode->index].rpi_count) == 0)
> +			atomic_set(&hw->rpi_ref[rnode->index].rpi_attached,
> +				   0);
> +		 evt = EFC_HW_NODE_FREE_OK;
> +	}
> +
> +	efc_remote_node_cb(efct->efcport, evt, rnode);
> +
> +	kfree(mqe);
> +
> +	return rc;
> +}
> +
> +enum efct_hw_rtn
> +efct_hw_node_detach(struct efc *efc, struct efc_remote_node *rnode)
> +{
> +	struct efct *efct = efc->base;
> +	struct efct_hw *hw = &efct->hw;
> +	u8	*buf = NULL;
> +	enum efct_hw_rtn	rc = EFCT_HW_RTN_SUCCESS_SYNC;
> +	u32	index = U32_MAX;
> +
> +	if (!hw || !rnode) {
> +		efc_log_err(efct, "bad parameter(s) hw=%p rnode=%p\n",
> +			     hw, rnode);
> +		return EFCT_HW_RTN_ERROR;
> +	}
> +
> +	/*
> +	 * Check if the chip is in an error state (UE'd) before proceeding.
> +	 */
> +	if (sli_fw_error_status(&hw->sli) > 0) {
> +		efc_log_crit(hw->os,
> +			      "Chip is in an error state - reset needed\n");
> +		return EFCT_HW_RTN_ERROR;
> +	}
> +
> +	index = rnode->index;
> +
> +	if (rnode->sport) {
> +		u32	count = 0;
> +		u32	fc_id;
> +
> +		if (!rnode->attached)
> +			return EFCT_HW_RTN_SUCCESS_SYNC;
> +
> +		buf = kmalloc(SLI4_BMBX_SIZE, GFP_ATOMIC);
> +		if (!buf)
> +			return EFCT_HW_RTN_NO_MEMORY;
> +
> +		memset(buf, 0, SLI4_BMBX_SIZE);

Mempools..

> +		count = atomic_sub_return(1, &hw->rpi_ref[index].rpi_count);
> +		count++;
> +		if (count <= 1) {

Come now. This now doesn't make sense; check for 'count == 0' and drop 
the ++ ...

> +			/*
> +			 * There are no other references to this RPI so
> +			 * unregister it
> +			 */
> +			fc_id = U32_MAX;
> +			/* and free the resource */
> +			rnode->node_group = false;
> +			rnode->free_group = true;
> +		} else {
> +			if (!hw->sli.high_login_mode)
> +				efc_log_test(hw->os,
> +					      "Inval cnt with HLM off, cnt=%d\n",
> +					     count);
> +			fc_id = rnode->fc_id & 0x00ffffff;
> +		}
> +
> +		rc = EFCT_HW_RTN_ERROR;
> +
> +		if (!sli_cmd_unreg_rpi(&hw->sli, buf, SLI4_BMBX_SIZE,
> +				      rnode->indicator,
> +				      SLI_RSRC_RPI, fc_id))
> +			rc = efct_hw_command(hw, buf, EFCT_CMD_NOWAIT,
> +					     efct_hw_cb_node_free, rnode);
> +
> +		if (rc != EFCT_HW_RTN_SUCCESS) {
> +			efc_log_err(hw->os, "UNREG_RPI failed\n");
> +			kfree(buf);
> +			rc = EFCT_HW_RTN_ERROR;
> +		}
> +	}
> +
> +	return rc;
> +}
> +
> +static int
> +efct_hw_cb_node_free_all(struct efct_hw *hw, int status, u8 *mqe,
> +			 void *arg)
> +{
> +	struct sli4_mbox_command_header *hdr =
> +				(struct sli4_mbox_command_header *)mqe;
> +	enum efc_hw_remote_node_event evt = EFC_HW_NODE_FREE_FAIL;
> +	int		rc = 0;
> +	u32	i;
> +	struct efct   *efct = hw->os;
> +
> +	if (status || le16_to_cpu(hdr->status)) {
> +		efc_log_debug(hw->os, "bad status cqe=%#x mqe=%#x\n", status,
> +			       le16_to_cpu(hdr->status));
> +	} else {
> +		evt = EFC_HW_NODE_FREE_ALL_OK;
> +	}
> +
> +	if (evt == EFC_HW_NODE_FREE_ALL_OK) {
> +		for (i = 0; i < hw->sli.extent[SLI_RSRC_RPI].size;
> +		     i++)
> +			atomic_set(&hw->rpi_ref[i].rpi_count, 0);
> +
> +		if (sli_resource_reset(&hw->sli, SLI_RSRC_RPI)) {
> +			efc_log_test(hw->os, "RPI free all failure\n");
> +			rc = -1;
> +		}
> +	}
> +
> +	efc_remote_node_cb(efct->efcport, evt, NULL);
> +
> +	kfree(mqe);

Same argument for calling 'kfree' on a function parameter.

> +
> +	return rc;
> +}
> +
> +enum efct_hw_rtn
> +efct_hw_node_free_all(struct efct_hw *hw)
> +{
> +	u8	*buf = NULL;
> +	enum efct_hw_rtn	rc = EFCT_HW_RTN_ERROR;
> +
> +	/*
> +	 * Check if the chip is in an error state (UE'd) before proceeding.
> +	 */
> +	if (sli_fw_error_status(&hw->sli) > 0) {
> +		efc_log_crit(hw->os,
> +			      "Chip is in an error state - reset needed\n");
> +		return EFCT_HW_RTN_ERROR;
> +	}
> +
> +	buf = kmalloc(SLI4_BMBX_SIZE, GFP_ATOMIC);
> +	if (!buf)
> +		return EFCT_HW_RTN_NO_MEMORY;
> +
> +	memset(buf, 0, SLI4_BMBX_SIZE);
> +

Mempools...

... and some more functions following which should be modified for using 
mempools for mailbox commands and not calling kfree() on a function 
parameter.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
