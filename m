From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH] 2.5 ips.c pci_module_init
Date: Thu, 16 Jan 2003 15:09:37 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030116230937.GA5561@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: David_Jeffery@adaptec.com

This patch is against 2.5.58 but also applies to scsi-misc-2.5 with a
offset 1 line warning.

This error started near 2.5.56 with badness warnings when the driver
loaded and has progressed to the driver probe routine not being called
at all as sysfs error propagation patches have been added. Since my
ServeRAID card is old it is the last pci_module_init to be called.

The patch just changes the name field in the ips pci_driver struct as
the three pci_driver names where not unique and cause EEXIST errors.

I have cc'd David Jeffery the driver maintainer.

-andmike
--
Michael Anderson
andmike@us.ibm.com

 ips.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)
------

--- 1.38/drivers/scsi/ips.c	Fri Jan 10 11:40:07 2003
+++ edited/drivers/scsi/ips.c	Thu Jan 16 11:42:00 2003
@@ -271,27 +271,25 @@
 
    MODULE_DEVICE_TABLE( pci, ips_pci_table );
 
-   static char ips_hot_plug_name[] = "ips";
-   
    static int __devinit  ips_insert_device(struct pci_dev *pci_dev, const struct pci_device_id *ent);
    static void __devexit ips_remove_device(struct pci_dev *pci_dev);
    
    struct pci_driver ips_pci_driver = {
-       .name		= ips_hot_plug_name,
+       .name		= "ips",
        .id_table	= ips_pci_table,
        .probe		= ips_insert_device,
        .remove		= __devexit_p(ips_remove_device),
    }; 
            
    struct pci_driver ips_pci_driver_5i = {
-       .name		= ips_hot_plug_name,
+       .name		= "ips_5i",
        .id_table	= ips_pci_table_5i,
        .probe		= ips_insert_device,
        .remove		= __devexit_p(ips_remove_device),
    };
 
    struct pci_driver ips_pci_driver_i960 = {
-       .name		= ips_hot_plug_name,
+       .name		= "ips_i960",
        .id_table	= ips_pci_table_i960,
        .probe		= ips_insert_device,
        .remove		= __devexit_p(ips_remove_device),

