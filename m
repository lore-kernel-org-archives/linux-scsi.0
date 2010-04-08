From: Harish Zunjarrao <harish.zunjarrao@qlogic.com>
Subject: [RFC PATCH] qla2xxx: Add char device to incease driver use count
Date: Thu, 8 Apr 2010 06:03:27 -0700
Message-ID: <6FC9A11471FF8C4CBCD15DEEF96752AB4059172F84@AVEXMB2.qlogic.org>
References: <98C07924B96E784CA9FF0C461C73BAFE24ED170E@AVEXMB2.qlogic.org>,<6FC9A11471FF8C4CBCD15DEEF96752AB4059172F83@AVEXMB2.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:20160 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758636Ab0DHNFs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Apr 2010 09:05:48 -0400
In-Reply-To: <6FC9A11471FF8C4CBCD15DEEF96752AB4059172F83@AVEXMB2.qlogic.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>

Hi,

We are facing an issue where application is unable to increase qla2xx driver use count.
As the driver use count is not incremented, driver can be unloaded causing application to fail.
The qla2xxx driver uses sysfs and BSG interface to interact with applications and accessing
these interfaces do not increase driver use count.

We do not see this issue on RHEL5.x driver as these drivers have Netlink socket present
which increases driver use count when application opens Netlink socket.

The upstream qla2xxx driver do not have Netlink socket present which RHEL5.x has.

To overcome this issue, the simplest solution can be registering a character device in qla2xxx
driver and let application use this character device as handle to increase driver use count.


Here is the patch for this:

The driver should not be unloaded if any application is using it.
To disallow driver unload, driver use count must be incremented.
Application uses this char device as handle and increases driver
use count to avoid possible driver unload.

Signed-off-by: Harish Zunjarrao <harish.zunjarrao@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h |    3 ++-
 drivers/scsi/qla2xxx/qla_os.c  |   14 ++++++++++++++
 2 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index c51bd4e..3a00e6a 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -34,7 +34,8 @@
 #include <scsi/scsi_bsg_fc.h>

 #include "qla_bsg.h"
-#define QLA2XXX_DRIVER_NAME  "qla2xxx"
+#define QLA2XXX_DRIVER_NAME    "qla2xxx"
+#define QLA2XXX_APIDEV         "ql2xapidev"

 /*
  * We have MAILBOX_REGISTER_COUNT sized arrays in a few places,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index f4ffa30..0b453b6 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -23,6 +23,8 @@
  */
 char qla2x00_version_str[40];

+static int apidev_major;
+
 /*
  * SRB allocation cache
  */
@@ -3467,6 +3469,10 @@ static struct pci_driver qla2xxx_pci_driver = {
        .err_handler    = &qla2xxx_err_handler,
 };

+static struct file_operations apidev_fops = {
+       .owner = THIS_MODULE,
+};
+
 /**
  * qla2x00_module_init - Module initialization.
  **/
@@ -3495,6 +3501,13 @@ qla2x00_module_init(void)
                kmem_cache_destroy(srb_cachep);
                return -ENODEV;
        }
+
+       apidev_major = register_chrdev(0, QLA2XXX_APIDEV, &apidev_fops);
+       if (apidev_major < 0) {
+               printk(KERN_WARNING "qla2xxx: Unable to register char device "
+                   "%s\n", QLA2XXX_APIDEV);
+       }
+
        qla2xxx_transport_vport_template =
            fc_attach_transport(&qla2xxx_transport_vport_functions);
        if (!qla2xxx_transport_vport_template) {
@@ -3520,6 +3533,7 @@ qla2x00_module_init(void)
 static void __exit
 qla2x00_module_exit(void)
 {
+       unregister_chrdev(apidev_major, QLA2XXX_APIDEV);
        pci_unregister_driver(&qla2xxx_pci_driver);
        qla2x00_release_firmware();
        kmem_cache_destroy(srb_cachep);
--

Any other solutions are highly appreciated.

Thanks,
Harish
