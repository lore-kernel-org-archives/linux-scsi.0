From: "Anand Kumar Santhanam" <AnandKumar.Santhanam@pmcs.com>
Subject: RE: [PATCH V3 01/12] pm80xx: fix for memory region free
Date: Wed, 10 Apr 2013 23:35:08 -0700
Message-ID: <E5DEE6F468524847995699AD11E8088501700990@BBY1EXM11.pmc_nt.nt.pmc-sierra.bc.ca>
References: <5149EFF9.6070604@pmc-sierra.com> <1365624794.1942.17.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:53109 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750887Ab3DKGfQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Apr 2013 02:35:16 -0400
Content-class: urn:content-classes:message
In-Reply-To: <1365624794.1942.17.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Harry Yang <Harry.Yang@pmcs.com>, Rich Bono <Rich.Bono@pmcs.com>, sakthivel.sk@hcl.com, Sangeetha Gnanasekaran <Sangeetha.Gnanasekaran@pmcs.com>, xjtuwjp@gmail.com, Vishwanath Maram <Vishwanath.Maram@pmcs.com>

Hi James,

Thanks for the feedback.

We have resubmitted all the patches starting from 1st patch in this V3
patchset. The first patch (given below) does not contain
pm8001_80xx_dispatch reference.
Maybe you have already applied patch 1 and 2 from earlier patchset and
trying to apply patch 1 from this V3 patchset?

diff --git a/drivers/scsi/pm8001/pm8001_init.c
b/drivers/scsi/pm8001/pm8001_init.c
index 4c9fe73..3d5e522 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -140,7 +140,8 @@ static void pm8001_free(struct pm8001_hba_info
*pm8001_ha)
        for (i = 0; i < USI_MAX_MEMCNT; i++) {
                if (pm8001_ha->memoryMap.region[i].virt_ptr != NULL) {
                        pci_free_consistent(pm8001_ha->pdev,
-
pm8001_ha->memoryMap.region[i].element_size,
+
(pm8001_ha->memoryMap.region[i].total_len +
+
pm8001_ha->memoryMap.region[i].alignment),
                                pm8001_ha->memoryMap.region[i].virt_ptr,
 
pm8001_ha->memoryMap.region[i].phys_addr);
                        }
--
1.7.1

We have applied the patches one by one and compiled each one of them in
sequence to check for any errors as you had suggested and we did not
encounter 
compilation errors after applying each patch.

Regards
Anand

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com] 
Sent: Thursday, April 11, 2013 1:43 AM
To: Anand Kumar Santhanam
Cc: linux-scsi@vger.kernel.org; Harry Yang; Rich Bono;
sakthivel.sk@hcl.com; Sangeetha Gnanasekaran; xjtuwjp@gmail.com;
Vishwanath Maram
Subject: Re: [PATCH V3 01/12] pm80xx: fix for memory region free

On Wed, 2013-03-20 at 10:20 -0700, Anand wrote:
> >From 700bfe79294e9f9e1a5def178af52b13928902a9 Mon Sep 17 00:00:00 
> >2001
> From: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
> Date: Mon, 4 Feb 2013 12:10:02 +0530
> Subject: [PATCH V3 01/12] pm80xx: fix for memory region free
> 
> All memory regions are allocated based on variables total_len and 
> alignment but free was based on element_size.

This patch doesn't compile.  It's giving

ERROR: "pm8001_80xx_dispatch" [drivers/scsi/pm8001/pm8001.ko] undefined!
make[1]: *** [__modpost] Error 1


This is because of this hunk:


> @@ -44,8 +44,16 @@
>  
>  static struct scsi_transport_template *pm8001_stt;
>  
> +/**
> + * chip info structure to identify chip key functionality as
> + * encryption available/not, no of ports, hw specific function ref  
> +*/
>  static const struct pm8001_chip_info pm8001_chips[] = {
> -	[chip_8001] = {  8, &pm8001_8001_dispatch,},
> +	[chip_8001] = {0,  8, &pm8001_8001_dispatch,},
> +	[chip_8008] = {0,  8, &pm8001_80xx_dispatch,},
> +	[chip_8009] = {1,  8, &pm8001_80xx_dispatch,},
> +	[chip_8018] = {0,  16, &pm8001_80xx_dispatch,},
> +	[chip_8019] = {1,  16, &pm8001_80xx_dispatch,},

But the structure isn't defined until patch 06/12.  This patch series
has to be bisectable and buildable.  That means each individual patch
must apply, compile and run in sequence.  Please fix this.

Thanks,

James


