From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 5/7] lpfc 8.3.13: BSG management fixes
Date: Wed, 12 May 2010 12:38:33 -0500
Message-ID: <4BEAE799.9010502@cs.wisc.edu>
References: <1273671164.24670.21.camel@wookie>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:45565 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753961Ab0ELRh2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 May 2010 13:37:28 -0400
In-Reply-To: <1273671164.24670.21.camel@wookie>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@emulex.com
Cc: linux-scsi@vger.kernel.org

On 05/12/2010 08:32 AM, James Smart wrote:
> + * lpfc_bsg_get_kboject - gets a reference on the drivers module kobject


I think you wanted to name this lpfc_bsg_get_kobject and name the put 
function lpfc_bsg_put_kobject?



> + * @phba: Pointer to HBA context object
> + *
> + * This function bumps the reference on the drivers module kobject preventing
> + * the driver from being removed. Prevents the sysfs tree from being
> + * corrupted because the driver was removed while bsg jobs are unfinished,
> + * this would be the case for registered events or any command sent to hardware
> + * and the driver needs to wait for the command to complete.
> + **/
> +static void
> +lpfc_bsg_get_kboject(struct lpfc_hba *phba)
> +{
> +	struct lpfc_vport *vport = phba->pport;
> +	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(shost->host_lock, flags);
> +	__module_get(shost->dma_dev->driver->owner);
> +	spin_unlock_irqrestore(shost->host_lock, flags);
> +}

> +

What is the host_lock use for?

With this patch is is still possible for the module to unload right 
before lpfc_bsg_request is called? Should this use a try_module_get and 
if that fails fail the request?

Why not just add the module get() and put() calls to the fc class (would 
it just push the problem up?)?

Or what about in bsg.c, have bsg_open do a module_get? Could we add a 
module pointer to the bsg's devices request_queue and have bsg do the 
get when the device is opened?
