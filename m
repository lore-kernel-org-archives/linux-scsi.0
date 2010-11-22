From: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Subject: Re: [PATCH 1/1] pmcraid driver disable msix and other changes
Date: Mon, 22 Nov 2010 09:25:31 -0800 (PST)
Message-ID: <alpine.LNX.1.10.1011220852170.4089@rslab235.pmc-sierra.bc.ca>
References: <alpine.LNX.1.10.1011161334560.1759@rslab235.pmc-sierra.bc.ca> <201011221528.52597.knikanth@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:59792 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751300Ab0KVTY5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Nov 2010 14:24:57 -0500
In-Reply-To: <201011221528.52597.knikanth@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, anil_ravindranath@pmc-sierra.com



On Mon, 22 Nov 2010, Nikanth Karthikesan wrote:

> On Wednesday 17 November 2010 03:13:41 Anil Ravindranath wrote:
> > The following are the fixes in this patch:
> 
> Fixes for what? Can you include the bugs caused by enabling msi-x inthe 
> changelog.
> 
> > 1. Disable msi-x for now
> > 2. Change device configuration entry size
> > 
> 
> Why?
> 
The reasons are very much controller and FW specific and not driver bugs. 
The product does not want to have MSI-X support for now. Maybe in future it will enabled.
Regarding device configuration entry size change again its FW 
requirement.


> So this patch kind of disables c20c426732a5a5d21e99b36286f79c2024115341?
> Would it be better to revert it?
> 

The commit you are referring is quite old and there are lot other changes 
after that. This patch just disables MSI-X.

> > Signed-off-by: Anil Ravindranath<anil_ravindranath@pmc-sierra.com>
> > 
> >  pmcraid.c |    4 +++-
> >  pmcraid.h |    6 ++----
> >  2 files changed, 5 insertions(+), 5 deletions(-)
> > 
> > --- scsi-misc-2.6.orig/drivers/scsi/pmcraid.h	2010-11-04 12:03:46.000000000
> >  -0700 +++ scsi-misc-2.6/drivers/scsi/pmcraid.h	2010-11-04
> >  11:15:06.000000000 -0700 @@ -42,7 +42,7 @@
> >   */
> >  #define PMCRAID_DRIVER_NAME		"PMC MaxRAID"
> >  #define PMCRAID_DEVFILE			"pmcsas"
> > -#define PMCRAID_DRIVER_VERSION		"2.0.3"
> > +#define PMCRAID_DRIVER_VERSION		"1.0.3"
> 
> hm.. version jump back!
> 
One of main reasons we bumped from 1.0. to 2.0 was support for MSI-X and 
since we have disabled for now, the version is back to 1.0.3.

> >  #define PMCRAID_DRIVER_DATE		__DATE__
> > 
> >  #define PMCRAID_FW_VERSION_1		0x002
> > @@ -333,11 +333,9 @@
> >  	__u8  lun[PMCRAID_LUN_LEN];
> >  } __attribute__((packed, aligned(4)));
> > 
> > -/* extended configuration table sizes are of 64 bytes in size */
> > -#define PMCRAID_CFGTE_EXT_SIZE	32
> > +/* extended configuration table sizes are also of 32 bytes in size */
> >  struct pmcraid_config_table_entry_ext {
> >  	struct pmcraid_config_table_entry cfgte;
> > -	__u8  cfgte_ext[PMCRAID_CFGTE_EXT_SIZE];
> >  };
> > 
> >  /* resource types (config_table_entry.resource_type values) */
> > --- scsi-misc-2.6.orig/drivers/scsi/pmcraid.c	2010-11-04 12:03:38.000000000
> >  -0700 +++ scsi-misc-2.6/drivers/scsi/pmcraid.c	2010-11-04
> >  12:11:21.000000000 -0700 @@ -62,6 +62,7 @@
> >  static unsigned int pmcraid_debug_log;
> >  static unsigned int pmcraid_disable_aen;
> >  static unsigned int pmcraid_log_level = IOASC_LOG_LEVEL_MUST;
> > +static unsigned int pmcraid_enable_msix;
> > 
> >  /*
> >   * Data structures to support multiple adapters by the LLD.
> > @@ -4689,7 +4690,8 @@
> >  	int rc;
> >  	struct pci_dev *pdev = pinstance->pdev;
> > 
> > -	if (pci_find_capability(pdev, PCI_CAP_ID_MSIX)) {
> > +	if ((pmcraid_enable_msix) &&
> > +		(pci_find_capability(pdev, PCI_CAP_ID_MSIX))) {
> 
> coding style nitpick: Unnecessary parenthesis.
> 
For readiblity sake the paranthesis are kept. If it was an coding 
style issue checkpatch would have picked, I guess, correct?.

> Thanks
> Nikanth
> 
> >  		int num_hrrq = PMCRAID_NUM_MSIX_VECTORS;
> >  		struct msix_entry entries[PMCRAID_NUM_MSIX_VECTORS];
> >  		int i;
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
