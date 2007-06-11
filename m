From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] scsi disk help file is not complete
Date: Mon, 11 Jun 2007 11:59:34 -0700
Message-ID: <20070611115934.9097fb04.randy.dunlap@oracle.com>
References: <466D9440.3080005@kpnplanet.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:43128 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbXFKS7o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jun 2007 14:59:44 -0400
In-Reply-To: <466D9440.3080005@kpnplanet.nl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: api <linuxgent@kpnplanet.nl>
Cc: linux-kernel@vger.kernel.org, scsi <linux-scsi@vger.kernel.org>, jejb <james.bottomley@steeleye.com>, jgarzik <jgarzik@pobox.com>

On Mon, 11 Jun 2007 20:28:16 +0200 api wrote:

> Good day,
> When doing make menuconfig one comes across CONFIG_BLK_DEV_SD.
> The help file states that this is for scsi disks.NO MENTION IS MADE THAT
> IT IS NEEDE FOR SATA DISKS AS WELL!
> Would have saved me a lot of time if the help was up to date.
> I hope this can be changed so others can make a kernel for sata systems
> quicker.


From: Randy Dunlap <randy.dunlap@oracle.com>

Add help info for BLK_DEV_SD referring to its use in
SATA or PATA driver configurations.

Add help text for "ATA" indicating that it probably needs
some SCSI config symbols enabled in order to be useful.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/ata/Kconfig  |    5 +++++
 drivers/scsi/Kconfig |    1 +
 2 files changed, 6 insertions(+)

--- linux-2622-rc4.orig/drivers/scsi/Kconfig
+++ linux-2622-rc4/drivers/scsi/Kconfig
@@ -60,6 +60,7 @@ config BLK_DEV_SD
 	depends on SCSI
 	---help---
 	  If you want to use SCSI hard disks, Fibre Channel disks,
+	  Serial ATA (SATA) or Parallel ATA (PATA) hard disks,
 	  USB storage or the SCSI or parallel port version of
 	  the IOMEGA ZIP drive, say Y and read the SCSI-HOWTO,
 	  the Disk-HOWTO and the Multi-Disk-HOWTO, available from
--- linux-2622-rc4.orig/drivers/ata/Kconfig
+++ linux-2622-rc4/drivers/ata/Kconfig
@@ -17,6 +17,11 @@ menuconfig ATA
 	  that "speaks" the ATA protocol, also called ATA controller),
 	  because you will be asked for it.
 
+	  NOTE: ATA enables basic SCSI support; *however*,
+	  'SCSI disk support', 'SCSI tape support', or
+	  'SCSI CDROM support' may also be needed,
+	  depending on your hardware configuration.
+
 if ATA
 
 config ATA_NONSTANDARD
