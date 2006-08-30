From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH] aic94xx: Increase can_queue and cmds_per_lun
Date: Wed, 30 Aug 2006 12:03:08 -0700
Message-ID: <44F5E0EC.8070602@us.ibm.com>
References: <44F3CF6E.1070000@us.ibm.com> <1156958383.7701.2.camel@mulgrave.il.steeleye.com>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:63405 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751318AbWH3TDO
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Aug 2006 15:03:14 -0400
In-Reply-To: <1156958383.7701.2.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Alexis Bruemmer <alexisb@us.ibm.com>, Mike Anderson <andmike@us.ibm.com>, Konrad Rzeszutek <konrad@darnok.org>

James Bottomley wrote:

> This is unnecessary unless you alter it before host alloc (which is
> where it takes the shost values from the template).
> 
> Also, I think if you look at the rest of the driver, it's careful to
> account for the need for required scbs in its internal queueing
> algorithms, so the ASD_FREE_SCBS should be unnecessary.
> 
>> +	shost->can_queue = aic94xx_sht.can_queue;

Ok then, I think it collapses to this short patch:

--D

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index 3e25e31..861d67b 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -623,6 +623,8 @@ static int __devinit asd_pci_probe(struc
                   asd_ha->hw_prof.bios.present ? "build " : "not present",
                   asd_ha->hw_prof.bios.bld);

+       shost->can_queue = asd_ha->hw_prof.max_scbs;
+
        if (use_msi)
                pci_enable_msi(asd_ha->pcidev);
