From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 15/17 v2] lpfc: Synchronize link speed with boot driver
Date: Thu, 13 Oct 2016 10:08:35 +0200
Message-ID: <20161013080835.om4rzpq6patkhwcf@linux-x5ow.site>
References: <57fe999a.MIc9tW13yxrn2R+1%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40663 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752376AbcJMIIh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Oct 2016 04:08:37 -0400
Content-Disposition: inline
In-Reply-To: <57fe999a.MIc9tW13yxrn2R+1%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Oct 12, 2016 at 01:14:18PM -0700, James Smart wrote:
> 
> Synchronize link speed with boot driver
> 
> Link speed settings set by the boot driver are reported by the hw.
> Driver will attempt to read them, and if set, will respect their
> values.
> The driver can override the settings with its own if instructed by
> user space (via bsg), with the new values being picked up by the
> boot driver.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc.h      |  4 ++++
>  drivers/scsi/lpfc/lpfc_attr.c |  7 +++++-
>  drivers/scsi/lpfc/lpfc_bsg.c  | 44 +++++++++++++++++++++++++++++++++++
>  drivers/scsi/lpfc/lpfc_bsg.h  | 10 ++++++++
>  drivers/scsi/lpfc/lpfc_hw4.h  |  3 +++
>  drivers/scsi/lpfc/lpfc_init.c | 54 +++++++++++++++++++++++++++++++++++++++++++
>  6 files changed, 121 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
> index debba5e..8a20b4e 100644
> --- a/drivers/scsi/lpfc/lpfc.h
> +++ b/drivers/scsi/lpfc/lpfc.h
> @@ -648,6 +648,10 @@ struct lpfc_hba {
>  #define HBA_FCP_IOQ_FLUSH	0x8000 /* FCP I/O queues being flushed */
>  #define HBA_FW_DUMP_OP		0x10000 /* Skips fn reset before FW dump */
>  #define HBA_RECOVERABLE_UE	0x20000 /* Firmware supports recoverable UE */
> +#define HBA_FORCED_LINK_SPEED	0x40000 /*
> +					 * Firmware supports Forced Link Speed
> +					 * capability
> +					 */
>  	uint32_t fcp_ring_in_use; /* When polling test if intr-hndlr active*/
>  	struct lpfc_dmabuf slim2p;
>  
> diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
> index 3740e5d..39ba01a 100644
> --- a/drivers/scsi/lpfc/lpfc_attr.c
> +++ b/drivers/scsi/lpfc/lpfc_attr.c
> @@ -3668,7 +3668,12 @@ lpfc_link_speed_store(struct device *dev, struct device_attribute *attr,
>  	int nolip = 0;
>  	const char *val_buf = buf;
>  	int err;
> -	uint32_t prev_val;
> +	uint32_t prev_val, if_type;
> +
> +	if_type = bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf);
> +	if ((if_type == LPFC_SLI_INTF_IF_TYPE_2) &&
> +	    (phba->hba_flag & HBA_FORCED_LINK_SPEED))

The parentheses aren't needed here.

> +		return -EPERM;
>  
>  	if (!strncmp(buf, "nolip ", strlen("nolip "))) {
>  		nolip = 1;
> diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
> index 05dcc2a..f9f5972 100644
> --- a/drivers/scsi/lpfc/lpfc_bsg.c
> +++ b/drivers/scsi/lpfc/lpfc_bsg.c
> @@ -5185,6 +5185,47 @@ no_dd_data:
>  	return rc;
>  }
>  
> +static int
> +lpfc_forced_link_speed(struct fc_bsg_job *job)

This has an unfortunate collision with my bsg rewrite series. Please remind me
of that fact when your patches are merged and mine aren't yet. But it's a
nice test case :-).

> +{
> +	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;

Please use shost_priv() here, or if you want to make my live easy 
	struct Scsi_Host *shost = job->shost;
	struct lpfc_vport *vport = shost_priv(shost);

Other than that,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
