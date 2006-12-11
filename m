From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH v2] libata: Simulate REPORT LUNS for ATAPI devices
Date: Mon, 11 Dec 2006 10:44:49 -0600
Message-ID: <1165855489.2791.7.camel@mulgrave.il.steeleye.com>
References: <4574A90E.5010801@us.ibm.com> <4574AB78.40102@garzik.org>
	 <4574B004.6030606@us.ibm.com>  <457D8637.5070707@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <457D8637.5070707@garzik.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Douglas Gilbert <dougg@torque.net>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2006-12-11 at 11:24 -0500, Jeff Garzik wrote:
> Darrick J. Wong wrote:
> > The Quantum GoVault SATAPI removable disk device returns ATA_ERR in
> > response to a REPORT LUNS packet.  If this happens to an ATAPI device
> > that is attached to a SAS controller (this is the case with sas_ata),
> > the device does not load because SCSI won't touch a "SCSI device"
> > that won't report its LUNs.  Since most ATAPI devices don't support
> > multiple LUNs anyway, we might as well fake a response like we do for
> > ATA devices.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> 
> I'm leaning towards applying this, perhaps with a module option that 
> allows experimenters to revert back to the older behavior.
> 
> Any chance you could be talked into tackling some of the SAT 
> translation-related items Doug G mentioned?  I'm almost certain there 
> are some info pages we should be returning, but are not, at the very least.

I thought we were closing in on agreeing that the SPC/MMC
inconsistencies made this the correct candidate fix.

James

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index ce63044..9d5e75b 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -7,6 +7,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 
+#include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_devinfo.h>
 
@@ -439,6 +440,11 @@ int scsi_get_device_flags(struct scsi_de
 				return devinfo->flags;
 		}
 	}
+	/* MMC devices can return SCSI-3 compliance and yet still not
+	 * support REPORT LUNS, so make them act as BLIST_NOREPORTLUN
+	 * unless BLIST_REPORTLUN2 is specifically set */
+	if (sdev->type == TYPE_ROM && (bflags & BLIST_REPORTLUN2) == 0)
+		bflags |= BLIST_NOREPORTLUN;
 	return bflags;
 }
 
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c


