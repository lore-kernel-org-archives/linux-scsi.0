From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH 15/21] lpfc: Implement support for wire-only DIF devices
Date: Sun, 5 Apr 2015 13:12:42 +0200
Message-ID: <20150405131242.000015a8@localhost>
References: <1428095580.6933.44.camel@myfc17>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:53181 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714AbbDELOA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 5 Apr 2015 07:14:00 -0400
In-Reply-To: <1428095580.6933.44.camel@myfc17>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@emulex.com
Cc: linux-scsi@vger.kernel.org, Sebastian Herbszt <herbszt@gmx.de>

James Smart wrote:
> Implement support for wire-only DIF devices
> 
> This patch adds the ability to support auto-enablement of wire-only DIF
> (DIF is generated on TX to target, stripped on RX; OS unaware DIF in use)
> for a select set of devices. Currently, there is only 1 device vendor
> supported: 3PARdata. When the feature is enabled, Inquiry commands are
> trapped, the vendor matched, and DIF enablement checked. In 3Par's case,
> there's a vendor specific check to see if the LUN supports DIF.
> If supported, DIF will be enabled on a per-lun basis.  The driver will
> trap READS/WRITEs from the OS, check for LUN DIF enablement, and if set,
> turns on write-only DIF.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>
> Signed-off-by: James Smart <james.smart@emulex.com>
> ---
>  drivers/scsi/lpfc/lpfc.h         |  41 ++++
>  drivers/scsi/lpfc/lpfc_attr.c    |  65 ++++++-
>  drivers/scsi/lpfc/lpfc_crtn.h    |   3 +-
>  drivers/scsi/lpfc/lpfc_hbadisc.c |   3 +
>  drivers/scsi/lpfc/lpfc_init.c    |  24 ++-
>  drivers/scsi/lpfc/lpfc_mbox.c    |   4 +-
>  drivers/scsi/lpfc/lpfc_scsi.c    | 410 ++++++++++++++++++++++++++++++++++++---
>  drivers/scsi/lpfc/lpfc_scsi.h    |   7 +-
>  drivers/scsi/lpfc/lpfc_sli.c     |  36 ++--
>  9 files changed, 532 insertions(+), 61 deletions(-)

<snip>

> diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
> index faf0e8c..891e2d1 100644
> --- a/drivers/scsi/lpfc/lpfc_attr.c
> +++ b/drivers/scsi/lpfc/lpfc_attr.c
> @@ -135,16 +135,29 @@ lpfc_bg_info_show(struct device *dev, struct device_attribute *attr,
>  	struct Scsi_Host *shost = class_to_shost(dev);
>  	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
>  	struct lpfc_hba   *phba = vport->phba;
> +	int len = 0;
>  
> -	if (phba->cfg_enable_bg)
> +	if (phba->cfg_enable_bg) {
>  		if (phba->sli3_options & LPFC_SLI3_BG_ENABLED)
> -			return snprintf(buf, PAGE_SIZE, "BlockGuard Enabled\n");
> +			len +=  snprintf(buf, PAGE_SIZE,
> +					 "BlockGuard Enabled\n");
>  		else
> -			return snprintf(buf, PAGE_SIZE,
> +			len +=  snprintf(buf, PAGE_SIZE,
>  					"BlockGuard Not Supported\n");
> -	else
> -			return snprintf(buf, PAGE_SIZE,
> +	} else {
> +			len +=  snprintf(buf, PAGE_SIZE,
>  					"BlockGuard Disabled\n");
> +	}
> +
> +	if (phba->cfg_external_dif) {
> +		if (phba->sli3_options & LPFC_SLI3_BG_ENABLED)
> +			len += snprintf(buf + len, PAGE_SIZE,
> +					"External DIF Enabled\n");
> +		else
> +			len += snprintf(buf + len, PAGE_SIZE,
> +					"External DIF Not Supported\n");
> +	}
> +	return len;
>  }
>  
>  static ssize_t
> @@ -4681,6 +4694,30 @@ LPFC_ATTR_R(EnableXLane, 0, 0, 1, "Enable Express Lane Feature.");
>  */
>  LPFC_ATTR_RW(XLanePriority, 0, 0x0, 0x7f, "CS_CTL for Express Lane Feature.");
>  
> +
> +/*
> + * For T10 DIF / protection data support, the driver supports 4 modes
> + * of operation.
> + *
> + * Mode 1: (lpfc_enable_bg=1 lpfc_external_dif=1)
> + * All normal T10 DIF devices are supported.
> + * External DIF devices are supported.
> + *
> + * Mode 2: (lpfc_enable_bg=0 lpfc_external_dif=1)
> + * If you don't want to have the extra overhead of the upper SCSI Layer
> + * supporting T10-DIF, but you still want to support External DIF devices.
> + * Normal T10 DIF devices are NOT supported.
> + * External DIF devices are supported.
> + *
> + * Mode 3: (lpfc_enable_bg=1 lpfc_external_dif=0)
> + * All normal T10 DIF devices are supported.
> + * External DIF devices are NOT supported.
> + *
> + * Mode 4: (lpfc_enable_bg=0 lpfc_external_dif=1)
> + * No normal T10-DIF and no external DIF devices supported,
> + * This would be the driver default values for these module parameters.
> + */

Not lpfc_external_dif=0?

>  /*
>  # lpfc_enable_bg: Enable BlockGuard (Emulex's Implementation of T10-DIF)
>  #       0  = BlockGuard disabled (default)
> @@ -4690,6 +4727,15 @@ LPFC_ATTR_RW(XLanePriority, 0, 0x0, 0x7f, "CS_CTL for Express Lane Feature.");
>  LPFC_ATTR_R(enable_bg, 0, 0, 1, "Enable BlockGuard Support");
>  
>  /*
> +# lpfc_external_dif: Enable External DIF support on select devices
> +#       0  = External DIF disabled (default)
> +#       1  = External DIF enabled
> +# Value range is [0,1]. Default value is 0.
> +*/
> +LPFC_ATTR_R(external_dif, 0, 0, 1,
> +	    "External T10-DIF Support, on select devices");
> +
> +/*
>  # lpfc_fcp_look_ahead: Look ahead for completions in FCP start routine
>  #       0  = disabled (default)
>  #       1  = enabled

Sebastian
