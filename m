From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH] PCI Error Recovery: IPR SCSI device driver]
Date: Wed, 18 Jan 2006 11:14:34 -0600
Message-ID: <43CE777A.8090308@us.ibm.com>
References: <20060118165110.GR26221@austin.ibm.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:7575 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751386AbWARROp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Jan 2006 12:14:45 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id k0IHEfHa011185
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jan 2006 12:14:41 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id k0IHEgM9099374
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jan 2006 12:14:42 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k0IHEf8T024423
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jan 2006 12:14:41 -0500
In-Reply-To: <20060118165110.GR26221@austin.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linas <linas@austin.ibm.com>
Cc: James.Bottomley@steeleye.com, gregkh@suse.de, linux-scsi@vger.kernel.org

linas wrote:
> Hi James,
> Please review the patch below, and forward upstream.  I've been
> bouncing it to various mailing lists for the last half-year,
> it has been living in an -mm tree for a while, and was a part of
> GregKH's patchset for a while. I'd like to get it propely upstream.

Sorry I didn't notice this before.. Couple minor nits below


>  
> +/* --------------- PCI Error Recovery infrastructure ----------- */

Kill this comment line.

> +/** If the PCI slot is frozen, hold off all i/o
> + *  activity; then, as soon as the slot is available again,
> + *  initiate an adapter reset.
> + */

Fix to be proper kerneldoc format. The same applies for all the added
functions.

> +static int ipr_reset_freeze(struct ipr_cmnd *ipr_cmd)
> +{
> +	/* Disallow new interrupts, avoid loop */
> +	ipr_cmd->ioa_cfg->allow_interrupts = 0;
> +	list_add_tail(&ipr_cmd->queue, &ipr_cmd->ioa_cfg->pending_q);
> +	ipr_cmd->done = ipr_reset_ioa_job;
> +	return IPR_RC_JOB_RETURN;
> +}
> +
> +/** ipr_eeh_frozen -- called when slot has experience PCI bus error.
> + *  This routine is called to tell us that the PCI bus is down.
> + *  Can't do anything here, except put the device driver into a
> + *  holding pattern, waiting for the PCI bus to come back.
> + */



> +static pci_ers_result_t ipr_eeh_error_detected(struct pci_dev *pdev,
> +                                pci_channel_state_t state)
> +{
> +	switch (state) {
> +		case pci_channel_io_frozen:
> +			ipr_eeh_frozen (pdev);
> +			return PCI_ERS_RESULT_NEED_RESET;
> +
> +		case pci_channel_io_perm_failure:
> +			ipr_eeh_perm_failure (pdev);
> +			return PCI_ERS_RESULT_DISCONNECT;
> +			break;
> +		default:
> +			break;
> +	}
> +	return PCI_ERS_RESULT_NEED_RESET;
> +}
> +


> +/* ------------- end of PCI Error Recovery suport ----------- */

Kill this line as well.

Thanks,

Brian


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
