From: Jack Hammer <jack_hammer@adaptec.com>
Subject: Re: ips init / kdump
Date: Mon, 31 Oct 2005 13:17:57 -0500
Message-ID: <43665FD5.7070409@adaptec.com>
References: <43131F52.2040307@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:17608 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932287AbVJaSSD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Oct 2005 13:18:03 -0500
In-Reply-To: <43131F52.2040307@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ipslinux@adaptec.com
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

I don't see this in any tree.
Please apply this patch if you have not already done so.
Thanks.


On 8/29/2005 10:44 AM, Jack Hammer wrote:
> This patch, applied to ips version 7.12.02 in the 2.6.13 kernel, fixes an
> initialization bug found with kdump.
> 
> If I/O is active on the adapter, and an unexpected interrupt is pending 
> during initialization, the driver blows it's brains out. Since the driver
> didn't initiate the I/O, the data in it's internal tables will contain NULL
> pointers.
> 
> When this condition is detected, a "flush cache and reset" is performed. 
> The flush cache allows any pending "lazy writes" that the adapter is 
> processing to complete ( a "must have" for a RAID adapter ) and the reset
> puts the adapter back into a known, good state.
> 
> 
> Signed-off-by: Jack Hammer <jack_hammer@adaptec.com>
> 
> 
> 
> --- a/drivers/scsi/ips.c	Mon Aug  8 12:22:19 2005
> +++ b/drivers/scsi/ips.c	Mon Aug  8 12:22:08 2005
> @@ -358,6 +358,9 @@
>  static int ips_init_phase1(struct pci_dev *pci_dev, int *indexPtr);
>  static int ips_register_scsi(int index);
>  
> +static int  ips_poll_for_flush_complete(ips_ha_t * ha);
> +static void ips_flush_and_reset(ips_ha_t *ha);
> +
>  /*
>   * global variables
>   */
> @@ -4807,6 +4810,9 @@
>  	uint32_t bits;
>  
>  	METHOD_TRACE("ips_is_init_morpheus", 1);
> +   
> +	if (ips_isintr_morpheus(ha)) 
> +	    ips_flush_and_reset(ha);
>  
>  	post = readl(ha->mem_ptr + IPS_REG_I960_MSG0);
>  	bits = readl(ha->mem_ptr + IPS_REG_I2O_HIR);
> @@ -4818,6 +4824,93 @@
>  	else
>  		return (1);
>  }
> +
> +/****************************************************************************/
> +/*                                                                          */
> +/* Routine Name: ips_flush_and_reset                                        */
> +/*                                                                          */
> +/* Routine Description:                                                     */
> +/*                                                                          */
> +/*   Perform cleanup ( FLUSH and RESET ) when the adapter is in an unknown  */
> +/*   state ( was trying to INIT and an interrupt was already pending ) ...  */
> +/*                                                                          */
> +/****************************************************************************/
> +static void 
> +ips_flush_and_reset(ips_ha_t *ha)
> +{
> +	ips_scb_t *scb;
> +	int  ret;
> + 	int  time;
> +	int  done;
> +	dma_addr_t command_dma;
> +
> +	/* Create a usuable SCB */
> +	scb = pci_alloc_consistent(ha->pcidev, sizeof(ips_scb_t), &command_dma);
> +	if (scb) {
> +	    memset(scb, 0, sizeof(ips_scb_t));
> +	    ips_init_scb(ha, scb);
> +	    scb->scb_busaddr = command_dma;
> +
> +	    scb->timeout = ips_cmd_timeout;
> +	    scb->cdb[0] = IPS_CMD_FLUSH;
> +
> +	    scb->cmd.flush_cache.op_code = IPS_CMD_FLUSH;
> +	    scb->cmd.flush_cache.command_id = IPS_MAX_CMDS;   /* Use an ID that would otherwise not exist */
> +	    scb->cmd.flush_cache.state = IPS_NORM_STATE;
> +	    scb->cmd.flush_cache.reserved = 0;
> +	    scb->cmd.flush_cache.reserved2 = 0;
> +	    scb->cmd.flush_cache.reserved3 = 0;
> +	    scb->cmd.flush_cache.reserved4 = 0;
> +
> +	    ret = ips_send_cmd(ha, scb);                      /* Send the Flush Command */
> +
> +	    if (ret == IPS_SUCCESS) {
> +	        time = 60 * IPS_ONE_SEC;	              /* Max Wait time is 60 seconds */
> +	        done = 0;
> +	            
> +	        while ((time > 0) && (!done)) {
> +	           done = ips_poll_for_flush_complete(ha); 	   
> +	           /* This may look evil, but it's only done during extremely rare start-up conditions ! */
> +	           udelay(1000);
> +	           time--;
> +	        }
> +        }
> +	}
> +
> +	/* Now RESET and INIT the adapter */
> +	(*ha->func.reset) (ha);
> +
> +	pci_free_consistent(ha->pcidev, sizeof(ips_scb_t), scb, command_dma);
> +	return;
> +}
> +
> +/****************************************************************************/
> +/*                                                                          */
> +/* Routine Name: ips_poll_for_flush_complete                                */
> +/*                                                                          */
> +/* Routine Description:                                                     */
> +/*                                                                          */
> +/*   Poll for the Flush Command issued by ips_flush_and_reset() to complete */
> +/*   All other responses are just taken off the queue and ignored           */
> +/*                                                                          */
> +/****************************************************************************/
> +static int
> +ips_poll_for_flush_complete(ips_ha_t * ha)
> +{
> +	IPS_STATUS cstatus;
> +    
> +	while (TRUE) {
> +	    cstatus.value = (*ha->func.statupd) (ha);
> +
> +	    if (cstatus.value == 0xffffffff)      /* If No Interrupt to process */
> +			break;
> +            
> +	    /* Success is when we see the Flush Command ID */
> +	    if (cstatus.fields.command_id == IPS_MAX_CMDS ) 
> +	        return 1;
> +	 }	
> +
> +	return 0;
>  
>  /****************************************************************************/
>  /*                                                                          */
> 

