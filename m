From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH] aic94xx: clean up PCI ID table per modern practice
Date: Fri, 31 Aug 2007 14:15:52 -0400
Message-ID: <46D85AD8.6000306@garzik.org>
References: <1188583189.6353.4.camel@linux.site>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030501060107080408070603"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:58962 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965626AbXHaSPy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Aug 2007 14:15:54 -0400
In-Reply-To: <1188583189.6353.4.camel@linux.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gilbert Wu <Gilbert_Wu@adaptec.com>
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------030501060107080408070603
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Gilbert Wu wrote:
> Subject:  [PATCH] scsi: Update Aic94xx SAS/SATA Linux open source device
> driver to add new PCI ID for HBA ASC58300.
> 
> Contribution:
>    Gilbert Wu <gilbert_wu@adaptec.com>
> 
> 
> Patch: apply to aic94xx-sas-2.6.git development tree
> 
> Signed-off-by: Gilbert Wu <gilbert_wu@adaptec.com>
> 
> Change Log:
> 
> 1. Add new HBA PCI ID for ASC58300 which has eight port SAS and
>    SATA PCI-X 133MHz low profile host bus adapter with two mini SAS
>         4x external connectors. 
> 
> 
> 
> diff -urN old/drivers/scsi/aic94xx/aic94xx_hwi.h
> new/drivers/scsi/aic94xx/aic94xx_hwi.h
> --- old/drivers/scsi/aic94xx/aic94xx_hwi.h	2007-08-30 16:34:21.000000000 -0700
> +++ new/drivers/scsi/aic94xx/aic94xx_hwi.h	2007-08-30 16:34:02.000000000 -0700
> @@ -45,6 +45,7 @@
>   */
>  #define PCI_DEVICE_ID_ADAPTEC2_RAZOR10 0x410
>  #define PCI_DEVICE_ID_ADAPTEC2_RAZOR12 0x412
> +#define PCI_DEVICE_ID_ADAPTEC2_RAZOR16 0x416
>  #define PCI_DEVICE_ID_ADAPTEC2_RAZOR1E 0x41E
>  #define PCI_DEVICE_ID_ADAPTEC2_RAZOR1F 0x41F
>  #define PCI_DEVICE_ID_ADAPTEC2_RAZOR30 0x430
> diff -urN old/drivers/scsi/aic94xx/aic94xx_init.c new/drivers/scsi/aic94xx/aic94xx_init.c
> --- old/drivers/scsi/aic94xx/aic94xx_init.c	2007-08-30 16:34:18.000000000 -0700
> +++ new/drivers/scsi/aic94xx/aic94xx_init.c	2007-08-30 16:33:59.000000000 -0700
> @@ -835,6 +835,8 @@
>  	 0, 0, 1},
>  	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_RAZOR12),
>  	 0, 0, 1},
> +	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_RAZOR16),
> +	 0, 0, 1},
>  	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_RAZOR1E),
>  	 0, 0, 1},
>  	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_RAZOR1F),

ACK, but, really we need to delete all of PCI_DEVICE_ID_ADAPTEC2_* and 
replace them with the numeric (hex) constants, since they are only used 
in a single location.

The PCI device table in aic94xx_init should really look like...  (see 
attached)

Much shorter, more maintainable, doesn't require patching the 
heavily-patched include/linux/pci_ids.h for single-use constants.

	Jeff




--------------030501060107080408070603
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

diff --git a/drivers/scsi/aic94xx/aic94xx_hwi.h b/drivers/scsi/aic94xx/aic94xx_hwi.h
index c6c3d18..491e5d8 100644
--- a/drivers/scsi/aic94xx/aic94xx_hwi.h
+++ b/drivers/scsi/aic94xx/aic94xx_hwi.h
@@ -40,18 +40,6 @@
 #define ASD_MAX_PHYS       8
 #define ASD_PCBA_SN_SIZE   12
 
-/* Those are to be further named properly, the "RAZORx" part, and
- * subsequently included in include/linux/pci_ids.h.
- */
-#define PCI_DEVICE_ID_ADAPTEC2_RAZOR10 0x410
-#define PCI_DEVICE_ID_ADAPTEC2_RAZOR12 0x412
-#define PCI_DEVICE_ID_ADAPTEC2_RAZOR1E 0x41E
-#define PCI_DEVICE_ID_ADAPTEC2_RAZOR1F 0x41F
-#define PCI_DEVICE_ID_ADAPTEC2_RAZOR30 0x430
-#define PCI_DEVICE_ID_ADAPTEC2_RAZOR32 0x432
-#define PCI_DEVICE_ID_ADAPTEC2_RAZOR3E 0x43E
-#define PCI_DEVICE_ID_ADAPTEC2_RAZOR3F 0x43F
-
 struct asd_ha_addrspace {
 	void __iomem  *addr;
 	unsigned long  start;       /* pci resource start */
diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index 63bcde2..56ed89c 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -829,23 +829,16 @@ static struct sas_domain_function_template aic94xx_transport_functions = {
 };
 
 static const struct pci_device_id aic94xx_pci_table[] __devinitdata = {
-	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_RAZOR10),
-	 0, 0, 1},
-	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_RAZOR12),
-	 0, 0, 1},
-	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_RAZOR1E),
-	 0, 0, 1},
-	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_RAZOR1F),
-	 0, 0, 1},
-	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_RAZOR30),
-	 0, 0, 2},
-	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_RAZOR32),
-	 0, 0, 2},
-	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_RAZOR3E),
-	 0, 0, 2},
-	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_RAZOR3F),
-	 0, 0, 2},
-	{}
+	{ PCI_VDEVICE(ADAPTEC2, 0x410), 1 },
+	{ PCI_VDEVICE(ADAPTEC2, 0x412), 1 },
+	{ PCI_VDEVICE(ADAPTEC2, 0x41E), 1 },
+	{ PCI_VDEVICE(ADAPTEC2, 0x41F), 1 },
+	{ PCI_VDEVICE(ADAPTEC2, 0x430), 2 },
+	{ PCI_VDEVICE(ADAPTEC2, 0x432), 2 },
+	{ PCI_VDEVICE(ADAPTEC2, 0x43E), 2 },
+	{ PCI_VDEVICE(ADAPTEC2, 0x43F), 2 },
+
+	{ }	/* terminate list */
 };
 
 MODULE_DEVICE_TABLE(pci, aic94xx_pci_table);

--------------030501060107080408070603--
