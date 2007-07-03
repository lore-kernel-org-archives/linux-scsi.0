From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/4] scsi: megaraid_sas -- add hibernation support
Date: Tue, 3 Jul 2007 15:16:04 -0700
Message-ID: <20070703151604.dbd0c9a8.akpm@linux-foundation.org>
References: <1183307483.4723.2.camel@dhcp-75-197.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49740 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753739AbXGCWQo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jul 2007 18:16:44 -0400
In-Reply-To: <1183307483.4723.2.camel@dhcp-75-197.se.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bo yang <bo.yang@lsi.com>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, neela.kolli@lsi.com, sumant.patro@lsi.com

On Sun, 01 Jul 2007 12:31:23 -0400
bo yang <bo.yang@lsi.com> wrote:

> The megaraid_sas driver doesn't support the hibernation, the
> suspend/resume routine implemented to support the hibernation.
> 
> Signed-off-by: Bo Yang <bo.yang@lsi.com>
> 
> ---
> 
> drivers/scsi/megaraid/megaraid_sas.c |  308 +++++++++++++++++++------
> drivers/scsi/megaraid/megaraid_sas.h |    1
> 2 files changed, 239 insertions(+), 70 deletions(-)
> 
> diff -rupN linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.c
> linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.c
> --- linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.c 2007-06-20
> 02:18:24.000000000 -0400
> +++ linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.c 2007-06-30
> 03:21:27.000000000 -0400

wordwrapped.

> @@ -1804,6 +1804,81 @@ static void megasas_complete_cmd_dpc(uns
>  }
>  
>  /**
> + * megasas_issue_init_mfi - Initializes the FW
> + * @instance:  Adapter soft state
> + *
> + * Issues the INIT MFI cmd
> + */
> +static int
> +megasas_issue_init_mfi(struct megasas_instance *instance)
> +{
> + u32 context;
> +
> + struct megasas_cmd *cmd;
> +
> + struct megasas_init_frame *init_frame;
> + struct megasas_init_queue_info *initq_info;
> + dma_addr_t init_frame_h;
> + dma_addr_t initq_info_h;

Please use tabs, not spaces.

> +	/*
> +	 * Prepare a init frame. Note the init frame points to queue info
> +	 * structure. Each frame has SGL allocated after first 64 bytes. For
> +	 * this frame - since we don't need any SGL - we use SGL's space as
> +	 * queue info structure
> +	 *
> +	 * We will not get a NULL command below. We just created the pool.
> +	 */
> +	cmd = megasas_get_cmd(instance);
> +
> +	init_frame = (struct megasas_init_frame *)cmd->frame;
> +	initq_info = (struct megasas_init_queue_info *)
> +	    ((unsigned long)init_frame + 64);
> +
> +	init_frame_h = cmd->frame_phys_addr;
> +	initq_info_h = init_frame_h + 64;
> +
> +	context = init_frame->context;
> +	memset(init_frame, 0, MEGAMFI_FRAME_SIZE);
> +	memset(initq_info, 0, sizeof(struct megasas_init_queue_info));
> +	init_frame->context = context;
> +
> +	initq_info->reply_queue_entries = instance->max_fw_cmds + 1;
> +	initq_info->reply_queue_start_phys_addr_lo = instance->reply_queue_h;
> +
> +	initq_info->producer_index_phys_addr_lo = instance->producer_h;
> +	initq_info->consumer_index_phys_addr_lo = instance->consumer_h;
> +
> +	init_frame->cmd = MFI_CMD_INIT;
> +	init_frame->cmd_status = 0xFF;
> +	init_frame->queue_info_new_phys_addr_lo = initq_info_h;
> +
> +	init_frame->data_xfer_len = sizeof(struct megasas_init_queue_info);
> +
> +	/*
> +	 * disable the intr before firing the init frame to FW
> +	 */
> +	instance->instancet->disable_intr(instance->reg_set);
> +
> +	/*
> +	 * Issue the init frame in polled mode
> +	 */
> +
> +	if (megasas_issue_polled(instance, cmd)) {
> +		printk(KERN_DEBUG "megasas: Failed to init firmware\n");

I'd have though KERN_ERR was appropriate here?

> +		megasas_return_cmd(instance, cmd);
> +		goto fail_fw_init;
> +	}
> +
> +	megasas_return_cmd(instance, cmd);
> +
> +	return 0;
> +
> +	fail_fw_init:
> +		return -EINVAL;
> +}
>
> ..
>
> -	if (megasas_issue_polled(instance, cmd)) {
> -		printk(KERN_DEBUG "megasas: Failed to init firmware\n");

hm, it was KERN_DEBUG before.  Perhaps that was wrong.

> +static int
> +megasas_set_dma_mask(struct pci_dev *pdev)
> +{
> +	/*
> +	 * All our contollers are capable of performing 64-bit DMA
> +	 */
> +	if (IS_DMA64) {

Bah.

#define IS_DMA64 (sizeof(dma_addr_t) == 8)

that should not be in a driver-private header file.

> +
> +      fail_irq:
> +      fail_init_mfi:

Opinions vary, but we usually indent labels by zero or one spaces.


