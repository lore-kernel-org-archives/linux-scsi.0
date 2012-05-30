From: Aaron Lu <aaron.lu@amd.com>
Subject: Re: [PATCH v4 0/13] SATA ZPODD support
Date: Wed, 30 May 2012 13:43:10 +0800
Message-ID: <20120530054310.GA11672@ladygaga>
References: <1338181720-4149-1-git-send-email-ming.m.lin@intel.com>
 <20120528104438.044ae385@pyramind.ukuu.org.uk>
 <20120528105428.689d0102@pyramind.ukuu.org.uk>
 <CAF1ivSaYo8bcYAJ0i1b44HTarz11gndUU_pG109sGPOaupDi3w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAF1ivSaYo8bcYAJ0i1b44HTarz11gndUU_pG109sGPOaupDi3w@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>, Fuzhou Chen <fuzhouch@microsoft.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jgarzik@pobox.com>, David Woodhouse <David.Woodhouse@intel.com>, Holger Macht <holger@homac.de>, Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, May 29, 2012 at 08:32:49PM +0800, Lin Ming wrote:
> On Mon, May 28, 2012 at 5:54 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> >> Have you fixed the fact that Matthews patches broke things like pata_acpi
> >> last time ? Until that is fixed properly I don't see that these patches
> >> can make any progress.
> >
> > https://lkml.org/lkml/2012/2/24/2
> 
> Aaron has a fix.
> We'll do more test.

Here is the patch, apply on top of the ZPODD patch set.

Hi Fuzhou,
Can you please give it a test? Thanks.
I tested on my system with a ATI IDE controller and it could work with
pata_acpi module.

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 6de8f32..c53266a 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -59,7 +59,18 @@ acpi_handle ata_ap_acpi_handle(struct ata_port *ap)
 {
 	if (ap->flags & ATA_FLAG_ACPI_SATA)
 		return NULL;
-	return DEVICE_ACPI_HANDLE(&ap->scsi_host->shost_gendev);
+
+	/*
+	 * If acpi bind operation has already happened, we can get the handle
+	 * for the port by checking the corresponding scsi_host device's
+	 * firmware node, otherwise we will need to find out the handle from
+	 * its parent's acpi node.
+	 */
+	if (ap->scsi_host)
+		return DEVICE_ACPI_HANDLE(&ap->scsi_host->shost_gendev);
+	else
+		return acpi_get_child(DEVICE_ACPI_HANDLE(ap->host->dev),
+				ap->port_no);
 }
 EXPORT_SYMBOL(ata_ap_acpi_handle);

-Aaron

> 
> Thanks for the info.
> Lin Ming
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

