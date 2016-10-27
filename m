From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/4] hpsa: add generate controller NMI on lockup
Date: Thu, 27 Oct 2016 11:02:56 +0200
Message-ID: <4b6cf4a2-a9af-dcd2-4412-f292d51513ca@suse.de>
References: <147752001094.813.10247306839794156732.stgit@brunhilda>
 <147752051230.813.13699218798744038354.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59319 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934551AbcJ0JNy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 Oct 2016 05:13:54 -0400
In-Reply-To: <147752051230.813.13699218798744038354.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>, jejb@linux.vnet.ibm.com, john.hall@microsemi.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

On 10/27/2016 12:21 AM, Don Brace wrote:
> Tell the controller to NMI when the controller deadlocks.
> 
> Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
> Reviewed-by: Scott Teel <scott.teel@microsemi.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
> Signed-off-by: Don Brace <don.brace@microsemi.com>
> ---
>  drivers/scsi/hpsa.c     |    6 ++++++
>  drivers/scsi/hpsa_cmd.h |    1 +
>  2 files changed, 7 insertions(+)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 798fb20..9fb739c 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -8451,6 +8451,12 @@ static void controller_lockup_detected(struct ctlr_info *h)
>  			"lockup detected after %d but scratchpad register is zero\n",
>  			h->heartbeat_sample_interval / HZ);
>  		lockup_detected = 0xffffffff;
> +	} else if (lockup_detected == 0xffff0000) {
> +		/*
> +		 * Ring controller NMI doorbell
> +		 */
> +		dev_warn(&h->pdev->dev, "Telling controller to do an NMI\n");
> +		writel(DOORBELL_GENERATE_NMI, h->vaddr + SA5_DOORBELL);
>  	}
>  	set_lockup_detected_for_all_cpus(h, lockup_detected);
>  	spin_unlock_irqrestore(&h->lock, flags);
> diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
> index a584cdf..d186f80 100644
> --- a/drivers/scsi/hpsa_cmd.h
> +++ b/drivers/scsi/hpsa_cmd.h
> @@ -142,6 +142,7 @@
>  #define DOORBELL_CTLR_RESET	0x00000004l
>  #define DOORBELL_CTLR_RESET2	0x00000020l
>  #define DOORBELL_CLEAR_EVENTS	0x00000040l
> +#define DOORBELL_GENERATE_NMI	0x00000080l
>  
>  #define CFGTBL_Trans_Simple     0x00000002l
>  #define CFGTBL_Trans_Performant 0x00000004l
> 
Care to elaborate a bit more here?
'Generating NMI' tends to ring some alarm bells, so I'd rather know
where the NMI is actually generated, and if is could reflect back to the
system ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
