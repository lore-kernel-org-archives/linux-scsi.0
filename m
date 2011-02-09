From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: RE: [PATCH 2/2] cciss: Disable ASPM
Date: Wed, 9 Feb 2011 20:35:02 +0000
Message-ID: <0F5B06BAB751E047AB5C87D1F77A77887D479C5C9C@GVW0547EXC.americas.hpqcorp.net>
References: <1297274831-10405-1-git-send-email-mjg@redhat.com>
 <1297274831-10405-2-git-send-email-mjg@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0027.austin.hp.com ([15.216.28.34]:28745 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007Ab1BIUgK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2011 15:36:10 -0500
In-Reply-To: <1297274831-10405-2-git-send-email-mjg@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Garrett <mjg@redhat.com>
Cc: ISS StorageDev <iss_storagedev@hp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: Matthew Garrett [mailto:mjg@redhat.com]
> Sent: Wednesday, February 09, 2011 12:07 PM
> To: mjg@redhat.com
> Cc: Miller, Mike (OS Dev); ISS StorageDev; linux-scsi@vger.kernel.org
> Subject: [PATCH 2/2] cciss: Disable ASPM
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=618612 indicates that
> current
> hpsa hardware has problems if ASPM is enabled. Disable it to avoid
> crashes.

ASPM is supposed to be fixed on both Proliant and Smart Array by the next generation of hardware. If that comes to fruition I suppose we could make this patch conditional based on whether the underlying hw really supports ASPM. Other than that this looks good.

Matthew, if Proliant BIOS tells the OS that ASPM is not supported does the OS honor that and not attempt to use ASPM? I know there was a time (maybe still is) when that bit in the ACPI table was not being set so rhel6 tried to use ASPM and hence the BZ you mention. Sorry, but I can't recall the proper terminology for the ACPI table related stuff.

-- mikem

> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> Cc: Mike Miller <mike.miller@hp.com>
> Cc: iss_storagedev@hp.com
> Cc: linux-scsi@vger.kernel.org
> ---
>  drivers/block/cciss.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> index 516d5bb..bb77666 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -24,6 +24,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/types.h>
>  #include <linux/pci.h>
> +#include <linux/pci-aspm.h>
>  #include <linux/kernel.h>
>  #include <linux/slab.h>
>  #include <linux/delay.h>
> @@ -4561,6 +4562,9 @@ static int __devinit cciss_init_one(struct pci_dev
> *pdev,
>  	InquiryData_struct *inq_buff;
>  	ctlr_info_t *h;
> 
> +	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S |
> PCIE_LINK_STATE_L1 |
> +			       PCIE_LINK_STATE_CLKPM);
> +
>  	rc = cciss_init_reset_devices(pdev);
>  	if (rc)
>  		return rc;
> --
> 1.7.4

