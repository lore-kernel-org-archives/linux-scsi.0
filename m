From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] ipr: add MMIO write to perform BIST for 64 bit adapters
Date: Thu, 17 Jun 2010 13:38:10 -0500
Message-ID: <4C1A6B92.9000604@linux.vnet.ibm.com>
References: <20100617180257.008451213@linux.vnet.ibm.com> <4C1A6708.4040408@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:57756 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757184Ab0FQSic (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jun 2010 14:38:32 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e39.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id o5HITH8B003448
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jun 2010 12:29:17 -0600
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o5HIcF6a075922
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jun 2010 12:38:16 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o5HIcBDP007379
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jun 2010 12:38:11 -0600
In-Reply-To: <4C1A6708.4040408@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>

On 06/17/2010 01:18 PM, Wayne Boyer wrote:
> @@ -7448,20 +7448,25 @@ static int ipr_reset_bist_done(struct ip
>  static int ipr_reset_start_bist(struct ipr_cmnd *ipr_cmd)
>  {
>  	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
> -	int rc;
> +	int rc = PCIBIOS_SUCCESSFUL;
> 
>  	ENTER;
>  	pci_block_user_cfg_access(ioa_cfg->pdev);
> -	rc = pci_write_config_byte(ioa_cfg->pdev, PCI_BIST, PCI_BIST_START);
> 
> -	if (rc != PCIBIOS_SUCCESSFUL) {
> -		pci_unblock_user_cfg_access(ipr_cmd->ioa_cfg->pdev);
> -		ipr_cmd->s.ioasa.hdr.ioasc = cpu_to_be32(IPR_IOASC_PCI_ACCESS_ERROR);
> -		rc = IPR_RC_JOB_CONTINUE;
> -	} else {
> +	if (ioa_cfg->ipr_chip->bist_method == IPR_MMIO)
> +		writel(IPR_UPROCI_SIS64_START_BIST,
> +		       ioa_cfg->regs.sense_uproc_interrupt_reg32);

This should be writing to ioa_cfg->regs.set_uproc_interrupt_reg32 instead.

> +	else
> +		rc = pci_write_config_byte(ioa_cfg->pdev, PCI_BIST, PCI_BIST_START);
> +
> +	if (rc == PCIBIOS_SUCCESSFUL) {
>  		ipr_cmd->job_step = ipr_reset_bist_done;
>  		ipr_reset_start_timer(ipr_cmd, IPR_WAIT_FOR_BIST_TIMEOUT);
>  		rc = IPR_RC_JOB_RETURN;
> +	} else {
> +		pci_unblock_user_cfg_access(ipr_cmd->ioa_cfg->pdev);
> +		ipr_cmd->s.ioasa.hdr.ioasc = cpu_to_be32(IPR_IOASC_PCI_ACCESS_ERROR);
> +		rc = IPR_RC_JOB_CONTINUE;
>  	}
> 


-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


