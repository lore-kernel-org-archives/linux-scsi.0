From: Nikanth Karthikesan <knikanth@suse.de>
Subject: Re: [PATCH 1/1] pmcraid driver disable msix and other changes
Date: Mon, 22 Nov 2010 15:28:52 +0530
Message-ID: <201011221528.52597.knikanth@suse.de>
References: <alpine.LNX.1.10.1011161334560.1759@rslab235.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57122 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750Ab0KVJzZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Nov 2010 04:55:25 -0500
In-Reply-To: <alpine.LNX.1.10.1011161334560.1759@rslab235.pmc-sierra.bc.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com

On Wednesday 17 November 2010 03:13:41 Anil Ravindranath wrote:
> The following are the fixes in this patch:

Fixes for what? Can you include the bugs caused by enabling msi-x inthe 
changelog.

> 1. Disable msi-x for now
> 2. Change device configuration entry size
> 

Why?

So this patch kind of disables c20c426732a5a5d21e99b36286f79c2024115341?
Would it be better to revert it?

> Signed-off-by: Anil Ravindranath<anil_ravindranath@pmc-sierra.com>
> 
>  pmcraid.c |    4 +++-
>  pmcraid.h |    6 ++----
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> --- scsi-misc-2.6.orig/drivers/scsi/pmcraid.h	2010-11-04 12:03:46.000000000
>  -0700 +++ scsi-misc-2.6/drivers/scsi/pmcraid.h	2010-11-04
>  11:15:06.000000000 -0700 @@ -42,7 +42,7 @@
>   */
>  #define PMCRAID_DRIVER_NAME		"PMC MaxRAID"
>  #define PMCRAID_DEVFILE			"pmcsas"
> -#define PMCRAID_DRIVER_VERSION		"2.0.3"
> +#define PMCRAID_DRIVER_VERSION		"1.0.3"

hm.. version jump back!

>  #define PMCRAID_DRIVER_DATE		__DATE__
> 
>  #define PMCRAID_FW_VERSION_1		0x002
> @@ -333,11 +333,9 @@
>  	__u8  lun[PMCRAID_LUN_LEN];
>  } __attribute__((packed, aligned(4)));
> 
> -/* extended configuration table sizes are of 64 bytes in size */
> -#define PMCRAID_CFGTE_EXT_SIZE	32
> +/* extended configuration table sizes are also of 32 bytes in size */
>  struct pmcraid_config_table_entry_ext {
>  	struct pmcraid_config_table_entry cfgte;
> -	__u8  cfgte_ext[PMCRAID_CFGTE_EXT_SIZE];
>  };
> 
>  /* resource types (config_table_entry.resource_type values) */
> --- scsi-misc-2.6.orig/drivers/scsi/pmcraid.c	2010-11-04 12:03:38.000000000
>  -0700 +++ scsi-misc-2.6/drivers/scsi/pmcraid.c	2010-11-04
>  12:11:21.000000000 -0700 @@ -62,6 +62,7 @@
>  static unsigned int pmcraid_debug_log;
>  static unsigned int pmcraid_disable_aen;
>  static unsigned int pmcraid_log_level = IOASC_LOG_LEVEL_MUST;
> +static unsigned int pmcraid_enable_msix;
> 
>  /*
>   * Data structures to support multiple adapters by the LLD.
> @@ -4689,7 +4690,8 @@
>  	int rc;
>  	struct pci_dev *pdev = pinstance->pdev;
> 
> -	if (pci_find_capability(pdev, PCI_CAP_ID_MSIX)) {
> +	if ((pmcraid_enable_msix) &&
> +		(pci_find_capability(pdev, PCI_CAP_ID_MSIX))) {

coding style nitpick: Unnecessary parenthesis.

Thanks
Nikanth

>  		int num_hrrq = PMCRAID_NUM_MSIX_VECTORS;
>  		struct msix_entry entries[PMCRAID_NUM_MSIX_VECTORS];
>  		int i;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
