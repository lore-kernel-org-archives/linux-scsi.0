From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/7] megaraid_sas: For SRIOV enabled firmware, ensure VF
 driver waits for 30secs before reset
Date: Mon, 17 Oct 2016 13:29:16 +0200
Message-ID: <43917368-d0af-a5fb-245a-5778b21e2b8c@suse.de>
References: <1476699850-25083-1-git-send-email-sumit.saxena@broadcom.com>
 <1476699850-25083-2-git-send-email-sumit.saxena@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33738 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933351AbcJQL3T (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 17 Oct 2016 07:29:19 -0400
In-Reply-To: <1476699850-25083-2-git-send-email-sumit.saxena@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, stable@vger.kernel.org, Kiran Kumar Kasturi <kiran-kumar.kasturi@broadcom.com>

On 10/17/2016 12:24 PM, Sumit Saxena wrote:
> For SRIOV enabled firmware, if there is a OCR(online controller reset)
> possibility driver set the convert flag to 1, which is not happening if
> there are outstanding commands even after 180 seconds.
> As driver does not set convert flag to 1 and still making the OCR to run,
> VF(Virtual function) driver is directly writing on to the register
> instead of waiting for 30 seconds. Setting convert flag to 1 will cause
> VF driver will wait for 30 secs before going for reset.
> 
> CC: stable@vger.kernel.org
> Signed-off-by: Kiran Kumar Kasturi <kiran-kumar.kasturi@broadcom.com>
> Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index 52d8bbf..61be7ed 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -2823,6 +2823,7 @@ int megasas_wait_for_outstanding_fusion(struct megasas_instance *instance,
>  		dev_err(&instance->pdev->dev, "pending commands remain after waiting, "
>  		       "will reset adapter scsi%d.\n",
>  		       instance->host->host_no);
> +		*convert = 1;
>  		retval = 1;
>  	}
>  out:
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
