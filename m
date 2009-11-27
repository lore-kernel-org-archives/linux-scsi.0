From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] ipr: fix EEH recovery
Date: Thu, 26 Nov 2009 19:46:47 -0600
Message-ID: <4B0F2F87.9070804@linux.vnet.ibm.com>
References: <1259187223.4938.45.camel@zeppelin>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:52404 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753010AbZK0Bqm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Nov 2009 20:46:42 -0500
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by e4.ny.us.ibm.com (8.14.3/8.13.1) with ESMTP id nAR1cDx5004115
	for <linux-scsi@vger.kernel.org>; Thu, 26 Nov 2009 20:38:13 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id nAR1kmx6062696
	for <linux-scsi@vger.kernel.org>; Thu, 26 Nov 2009 20:46:48 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id nAR1kmuX030538
	for <linux-scsi@vger.kernel.org>; Thu, 26 Nov 2009 20:46:48 -0500
In-Reply-To: <1259187223.4938.45.camel@zeppelin>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Wayne Boyer <wayneb@linux.vnet.ibm.com>

Acked-by: Brian King <brking@linux.vnet.ibm.com>

Kleber Sacilotto de Souza wrote:
> Hi,
> 
> After commits c82f63e411f1b58427c103bd95af2863b1c96dd1 (PCI: check saved
> state before restore) and 4b77b0a2ba27d64f58f16d8d4d48d8319dda36ff (PCI:
> Clear saved_state after the state has been restored) PCI drivers are
> prevented from restoring the device standard configuration registers
> twice in a row. These changes introduced a regression on ipr EEH
> recovery.
> 
> The ipr device driver saves the PCI state only during the device probe
> and restores it on ipr_reset_restore_cfg_space() during IOA resets. This
> behavior is causing the EEH recovery to fail after the second error
> detected, since the registers are not being restored.
> 
> One possible solution would be saving the registers after restoring
> them. The problem with this approach is that while recovering from an
> EEH error if pci_save_state() results in an EEH error, the adapter/slot
> will be reset, and end up back in ipr_reset_restore_cfg_space(), but it
> won't have a valid saved state to restore, so pci_restore_state() will
> fail.
> 
> The following patch introduces a workaround for this problem, hacking
> around the PCI API by setting pdev->state_saved = true before we do the
> restore. It fixes the EEH regression and prevents that we hit another
> EEH error during EEH recovery.
> 
> 
> Thanks,
> Kleber
> 
> 
> 
> Signed-off-by: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
> ---
>  drivers/scsi/ipr.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
> index 76d294f..c3ff9a6 100644
> --- a/drivers/scsi/ipr.c
> +++ b/drivers/scsi/ipr.c
> @@ -6516,6 +6516,7 @@ static int ipr_reset_restore_cfg_space(struct ipr_cmnd *ipr_cmd)
>  	int rc;
> 
>  	ENTER;
> +	ioa_cfg->pdev->state_saved = true;
>  	rc = pci_restore_state(ioa_cfg->pdev);
> 
>  	if (rc != PCIBIOS_SUCCESSFUL) {


-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


