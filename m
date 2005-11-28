From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 9/11]  lpfc 8.1.1 : Add polled-mode support
Date: Mon, 28 Nov 2005 19:33:37 +0000
Message-ID: <20051128193337.GA25722@infradead.org>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276C4D@xbl3.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:38543 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932183AbVK1Tdh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Nov 2005 14:33:37 -0500
Content-Disposition: inline
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276C4D@xbl3.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

On Mon, Nov 28, 2005 at 11:42:29AM -0500, James.Smart@Emulex.Com wrote:
> 
> Add polled-mode support to the driver:
> - Add functionality to run in polled mode only. Includes run time
>   attribute to enable mode.
> - Enable runtime writable hba settings for coallescing and delay parameters

This needs some documentation for where it is useful.  Do you want this
to avoid interrupts under high loads or for something else? 


> +static ssize_t
> +lpfc_poll_show(struct class_device *cdev, char *buf)
> +{
> +	struct Scsi_Host *host = class_to_shost(cdev);
> +	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata[0];
> +
> +	if (!phba) return 0;

please try to follow kernel coding style.  I also doubt that phba could
be 0 here at all.

> +	if (val & ENABLE_FCP_RING_POLLING) {
> +		if ((val & DISABLE_FCP_RING_INT)
> +		    && !(old_val & DISABLE_FCP_RING_INT))
> +		{
> +			creg_val = readl(phba->HCregaddr);
> +			creg_val &= ~(HC_R0INT_ENA << LPFC_FCP_RING);
> +			writel(creg_val, phba->HCregaddr);
> +			readl(phba->HCregaddr); /* flush */
> +
> +			lpfc_poll_start_timer(phba);
> +		}
> +	}
> +	else if (val != 0x0) {
> +		spin_unlock_irq(phba->host->host_lock);
> +		return -EINVAL;
> +	}

again, lots of style problems.

> +static int lpfc_poll = 0;
> +module_param(lpfc_poll, int, 0);
> +MODULE_PARM_DESC(lpfc_poll, "FCP ring polling mode control:"
> +		 " 0x0 - none,"
> +		 " 0x1 - poll with interrupts enabled"
> +		 " 0x3 - poll and disable FCP ring interrupts");

for values in the range of 0 to 9 (decimal) there's absolutely no need to
express them in hex :)

