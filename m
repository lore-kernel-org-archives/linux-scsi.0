Return-Path: <SRS0=iRB6=6A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BAE0C2BB85
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 09:45:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F8E421D79
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 09:45:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441114AbgDPJph (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Apr 2020 05:45:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:41182 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503878AbgDPJpf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Apr 2020 05:45:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CD914AD49;
        Thu, 16 Apr 2020 09:45:32 +0000 (UTC)
Subject: Re: [PATCH v3 27/31] elx: efct: xport and hardware teardown routines
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     dwagner@suse.de, maier@linux.ibm.com, bvanassche@acm.org,
        herbszt@gmx.de, natechancellor@gmail.com, rdunlap@infradead.org,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-28-jsmart2021@gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <ed6af3fe-7848-7e3b-466d-3b59cef55829@suse.de>
Date:   Thu, 16 Apr 2020 11:45:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200412033303.29574-28-jsmart2021@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/12/20 5:32 AM, James Smart wrote:
> This patch continues the efct driver population.
> 
> This patch adds driver definitions for:
> Routines to detach xport and hardware objects.
> 
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> 
> ---
> v3:
>     Removed old patch 28 and merged with 27
> ---
>   drivers/scsi/elx/efct/efct_hw.c    | 333 +++++++++++++++++++++++++++++++++++++
>   drivers/scsi/elx/efct/efct_hw.h    |  31 ++++
>   drivers/scsi/elx/efct/efct_xport.c | 291 ++++++++++++++++++++++++++++++++
>   3 files changed, 655 insertions(+)
> 
> diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
> index ca2fd237c7d6..a007ca98895d 100644
> --- a/drivers/scsi/elx/efct/efct_hw.c
> +++ b/drivers/scsi/elx/efct/efct_hw.c
> @@ -3503,3 +3503,336 @@ efct_hw_get_host_stats(struct efct_hw *hw, u8 cc,
>   
>   	return rc;
>   }
> +
> +static int
> +efct_hw_cb_port_control(struct efct_hw *hw, int status, u8 *mqe,
> +			void  *arg)
> +{
> +	kfree(mqe);
> +	return EFC_SUCCESS;
> +}
> +
> +/* Control a port (initialize, shutdown, or set link configuration) */
> +enum efct_hw_rtn
> +efct_hw_port_control(struct efct_hw *hw, enum efct_hw_port ctrl,
> +		     uintptr_t value,
> +		void (*cb)(int status, uintptr_t value, void *arg),
> +		void *arg)
> +{
> +	enum efct_hw_rtn rc = EFCT_HW_RTN_ERROR;
> +
> +	switch (ctrl) {
> +	case EFCT_HW_PORT_INIT:
> +	{
> +		u8	*init_link;
> +		u32 speed = 0;
> +		u8 reset_alpa = 0;
> +
> +		u8	*cfg_link;
> +
> +		cfg_link = kmalloc(SLI4_BMBX_SIZE, GFP_ATOMIC);
> +		if (!cfg_link)
> +			return EFCT_HW_RTN_NO_MEMORY;
> +

Use the predefined mailbox buffer?
Or a memory pool?

> +		if (!sli_cmd_config_link(&hw->sli, cfg_link,
> +					SLI4_BMBX_SIZE))
> +			rc = efct_hw_command(hw, cfg_link,
> +					     EFCT_CMD_NOWAIT,
> +					     efct_hw_cb_port_control,
> +					     NULL);
> +
> +		if (rc != EFCT_HW_RTN_SUCCESS) {
> +			kfree(cfg_link);
> +			efc_log_err(hw->os, "CONFIG_LINK failed\n");
> +			break;
> +		}
> +		speed = hw->config.speed;
> +		reset_alpa = (u8)(value & 0xff);
> +
> +		/* Allocate a new buffer for the init_link command */
> +		init_link = kmalloc(SLI4_BMBX_SIZE, GFP_ATOMIC);
> +		if (!init_link)
> +			return EFCT_HW_RTN_NO_MEMORY;
> +
> +		rc = EFCT_HW_RTN_ERROR;
> +		if (!sli_cmd_init_link(&hw->sli, init_link, SLI4_BMBX_SIZE,
> +				      speed, reset_alpa))
> +			rc = efct_hw_command(hw, init_link, EFCT_CMD_NOWAIT,
> +					     efct_hw_cb_port_control, NULL);
> +		/* Free buffer on error, since no callback is coming */
> +		if (rc != EFCT_HW_RTN_SUCCESS) {
> +			kfree(init_link);
> +			efc_log_err(hw->os, "INIT_LINK failed\n");
> +		}
> +		break;
> +	}
> +	case EFCT_HW_PORT_SHUTDOWN:
> +	{
> +		u8	*down_link;
> +
> +		down_link = kmalloc(SLI4_BMBX_SIZE, GFP_ATOMIC);
> +		if (!down_link)
> +			return EFCT_HW_RTN_NO_MEMORY;
> +

Same here.

> +		if (!sli_cmd_down_link(&hw->sli, down_link, SLI4_BMBX_SIZE))
> +			rc = efct_hw_command(hw, down_link, EFCT_CMD_NOWAIT,
> +					     efct_hw_cb_port_control, NULL);
> +		/* Free buffer on error, since no callback is coming */
> +		if (rc != EFCT_HW_RTN_SUCCESS) {
> +			kfree(down_link);
> +			efc_log_err(hw->os, "DOWN_LINK failed\n");
> +		}
> +		break;
> +	}
> +	default:
> +		efc_log_test(hw->os, "unhandled control %#x\n", ctrl);
> +		break;
> +	}
> +
> +	return rc;
> +}
> +
> +enum efct_hw_rtn
> +efct_hw_teardown(struct efct_hw *hw)
> +{
> +	u32	i = 0;
> +	u32	iters = 10;
> +	u32	max_rpi;
> +	u32 destroy_queues;
> +	u32 free_memory;
> +	struct efc_dma *dma;
> +	struct efct *efct = hw->os;
> +
> +	destroy_queues = (hw->state == EFCT_HW_STATE_ACTIVE);
> +	free_memory = (hw->state != EFCT_HW_STATE_UNINITIALIZED);
> +
> +	/* Cancel Sliport Healthcheck */
> +	if (hw->sliport_healthcheck) {
> +		hw->sliport_healthcheck = 0;
> +		efct_hw_config_sli_port_health_check(hw, 0, 0);
> +	}
> +
> +	if (hw->state != EFCT_HW_STATE_QUEUES_ALLOCATED) {
> +		hw->state = EFCT_HW_STATE_TEARDOWN_IN_PROGRESS;
> +
> +		efct_hw_flush(hw);
> +
> +		/*
> +		 * If there are outstanding commands, wait for them to complete
> +		 */
> +		while (!list_empty(&hw->cmd_head) && iters) {
> +			mdelay(10);
> +			efct_hw_flush(hw);
> +			iters--;
> +		}
> +
> +		if (list_empty(&hw->cmd_head))
> +			efc_log_debug(hw->os,
> +				       "All commands completed on MQ queue\n");
> +		else
> +			efc_log_debug(hw->os,
> +				       "Some cmds still pending on MQ queue\n");
> +
> +		/* Cancel any remaining commands */
> +		efct_hw_command_cancel(hw);
> +	} else {
> +		hw->state = EFCT_HW_STATE_TEARDOWN_IN_PROGRESS;
> +	}
> +
> +	max_rpi = hw->sli.qinfo.max_qcount[SLI_RSRC_RPI];
> +	if (hw->rpi_ref) {
> +		for (i = 0; i < max_rpi; i++) {
> +			u32 count;
> +
> +			count = atomic_read(&hw->rpi_ref[i].rpi_count);
> +			if (count)
> +				efc_log_debug(hw->os,
> +					       "non-zero ref [%d]=%d\n",
> +					       i, count);

Ho-hum. So you have a non-zero refcount and _still_ free the structure?
That smells fishy ...

> +		}
> +		kfree(hw->rpi_ref);
> +		hw->rpi_ref = NULL;
> +	}
> +

Please use proper refcounting here.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
