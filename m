From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH 4/4] [SCSI]stex: minor cleanup and version update
Date: Mon, 02 Apr 2007 11:05:21 -0500
Message-ID: <461129C1.30507@us.ibm.com>
References: <NONAMEBj81EYtN3Isam000005d6@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:49214 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933104AbXDBQF2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Apr 2007 12:05:28 -0400
In-Reply-To: <NONAMEBj81EYtN3Isam000005d6@nonameb.ptu.promise.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ed Lin <ed.lin@promise.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "james.Bottomley" <james.Bottomley@SteelEye.com>, jeff <jeff@garzik.org>, promise_linux <promise_linux@promise.com>

Ed Lin wrote:
> @@ -1007,6 +1008,11 @@ static int stex_abort(struct scsi_cmnd *
>  	u32 data;
>  	int result = SUCCESS;
>  	unsigned long flags;
> +
> +	printk(KERN_INFO DRV_NAME
> +		"(%s): aborting command\n", pci_name(hba->pdev));
> +	scsi_print_command(cmd);
> +

scmd_printk is probably what you want here rather than just a printk.

scmd_printk(KERN_ERR, cmd, "aborting command\n");


> @@ -1092,6 +1098,10 @@ static int stex_reset(struct scsi_cmnd *
>  	unsigned long before;
>  	hba = (struct st_hba *) &cmd->device->host->hostdata[0];
> 
> +	printk(KERN_INFO DRV_NAME
> +		"(%s): resetting host\n", pci_name(hba->pdev));
> +	scsi_print_command(cmd);
> +

Same here.

Brian

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
