From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: [PATCH 3/12] scsi: megaraid_sas - Add poll mechanism to megaraid
 sas driver (part II)
Date: Sun, 20 Sep 2009 20:34:15 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C35C5123FD@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C35C51195F@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754402AbZIUCea@vger.kernel.org>
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C35C51195F@cosmail02.lsi.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akpm@osdl.org" <akpm@osdl.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Add poll support part II -- update the sysfs parameter to tell application driver support AEN poll

Signed-off-by Bo Yang<bo.yang@lsi.com>

---

drivers/scsi/megaraid/megaraid_sas.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c      2009-09-13 09:49:11.000000000 -0400
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c       2009-09-13 10:11:50.000000000 -0400
@@ -92,7 +92,7 @@ static DEFINE_MUTEX(megasas_async_queue_

 static int megasas_poll_wait_aen;
 static DECLARE_WAIT_QUEUE_HEAD(megasas_poll_wait);
-
+static u32 support_poll_for_event;
 static u32 megasas_dbg_lvl;

 /* define lock for aen poll */
@@ -3432,6 +3432,15 @@ static DRIVER_ATTR(release_date, S_IRUGO
                   NULL);

 static ssize_t
+megasas_sysfs_show_support_poll_for_event(struct device_driver *dd, char *buf)
+{
+       return sprintf(buf, "%u\n", support_poll_for_event);
+}
+
+static DRIVER_ATTR(support_poll_for_event, S_IRUGO,
+                       megasas_sysfs_show_support_poll_for_event, NULL);
+
+static ssize_t
 megasas_sysfs_show_dbg_lvl(struct device_driver *dd, char *buf)
 {
        return sprintf(buf, "%u\n", megasas_dbg_lvl);
@@ -3522,6 +3531,8 @@ static int __init megasas_init(void)
        printk(KERN_INFO "megasas: %s %s\n", MEGASAS_VERSION,
               MEGASAS_EXT_VERSION);

+       support_poll_for_event = 2;
+
        memset(&megasas_mgmt_info, 0, sizeof(megasas_mgmt_info));

        /*
@@ -3554,6 +3565,12 @@ static int __init megasas_init(void)
                                  &driver_attr_release_date);
        if (rval)
                goto err_dcf_rel_date;
+
+       rval = driver_create_file(&megasas_pci_driver.driver,
+                               &driver_attr_support_poll_for_event);
+       if (rval)
+               goto err_dcf_support_poll_for_event;
+
        rval = driver_create_file(&megasas_pci_driver.driver,
                                  &driver_attr_dbg_lvl);
        if (rval)
@@ -3570,7 +3587,12 @@ err_dcf_poll_mode_io:
                           &driver_attr_dbg_lvl);
err_dcf_dbg_lvl:
        driver_remove_file(&megasas_pci_driver.driver,
+                       &driver_attr_support_poll_for_event);
+
+err_dcf_support_poll_for_event:
+       driver_remove_file(&megasas_pci_driver.driver,
                           &driver_attr_release_date);
+
 err_dcf_rel_date:
        driver_remove_file(&megasas_pci_driver.driver, &driver_attr_version);
 err_dcf_attr_ver:
