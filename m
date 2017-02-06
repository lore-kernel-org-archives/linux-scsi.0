From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 04/39] megaraid_sas: 32 bit descriptor fire cmd
 optimization
Date: Mon, 6 Feb 2017 11:23:41 +0100
Message-ID: <2469ec36-b690-dba5-effa-3dc9f6c45954@suse.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486375212-17329-5-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:46870 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750950AbdBFKXo (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Mon, 6 Feb 2017 05:23:44 -0500
In-Reply-To: <1486375212-17329-5-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com

On 02/06/2017 10:59 AM, Shivasharan S wrote:
> No functional change. Code refactor.
> megasas_fire_cmd_fusion can always use 32 bit descriptor write for ventura. No need to pass extra flag.
> Only IOC INIT required 64 bit Descriptor write.
> 
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 65 +++++++++++++++--------------
>  1 file changed, 33 insertions(+), 32 deletions(-)
> 
[ .. ]
> @@ -897,7 +893,14 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
>  			break;
>  	}
>  
> -	megasas_fire_cmd_fusion(instance, &req_desc, false);
> +	/* For Ventura also IOC INIT required 64 bit Descriptor write. */
> +	spin_lock_irqsave(&instance->hba_lock, flags);
> +	writel(le32_to_cpu(req_desc.u.low),
> +	       &instance->reg_set->inbound_low_queue_port);
> +	writel(le32_to_cpu(req_desc.u.high),
> +	       &instance->reg_set->inbound_high_queue_port);
> +	mmiowb();
> +	spin_unlock_irqrestore(&instance->hba_lock, flags);
>  
>  	wait_and_poll(instance, cmd, MFI_POLL_TIMEOUT_SECS);
>  
You are missing the 64 bit writeq improvements here.


Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
