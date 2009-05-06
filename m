From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: [PATCH 3/10] scsi: megaraid_sas - Add Poll Wait mechanism to
 MegaRAID SAS driver (PART-II)
Date: Tue, 5 May 2009 18:41:45 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C354F61C43@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C354F61C3E@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og108.obsmtp.com ([64.18.2.169]:38647 "EHLO
	exprod7og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075AbZEFAmd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 May 2009 20:42:33 -0400
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C354F61C3E@cosmail02.lsi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akpm@osdl.org" <akpm@osdl.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Austria, Winston" <Winston.Austria@lsi.com>

Add Poll Wait Mechanism PART-II: Add Poll_wait mechanism to MegaRAID SAS 2 Linux driver.  Add the sysfs entry for the application use.

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
drivers/scsi/megaraid/megaraid_sas.c |   27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c      2009-05-04 20:14:30.000000000 -0400
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c       2009-05-04 20:15:48.000000000 -0400
@@ -93,6 +93,8 @@ static DEFINE_MUTEX(megasas_async_queue_
 static int megasas_poll_wait_aen;
 static DECLARE_WAIT_QUEUE_HEAD(megasas_poll_wait);

+static u32 support_poll_for_event;
+
 static u32 megasas_dbg_lvl;

 static void
@@ -3429,6 +3431,15 @@ static DRIVER_ATTR(release_date, S_IRUGO
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
@@ -3595,7 +3606,6 @@ megasas_aen_polling(struct megasas_insta
                         __FUNCTION__, instance->host->host_no, error);
 }

-
 static DRIVER_ATTR(poll_mode_io, S_IRUGO|S_IWUGO,
                megasas_sysfs_show_poll_mode_io,
                megasas_sysfs_set_poll_mode_io);
@@ -3613,6 +3623,8 @@ static int __init megasas_init(void)
        printk(KERN_INFO "megasas: %s %s\n", MEGASAS_VERSION,
               MEGASAS_EXT_VERSION);

+       support_poll_for_event = 1;
+
        memset(&megasas_mgmt_info, 0, sizeof(megasas_mgmt_info));

        /*
@@ -3645,6 +3657,12 @@ static int __init megasas_init(void)
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
@@ -3662,6 +3680,11 @@ err_dcf_poll_mode_io:
 err_dcf_dbg_lvl:
        driver_remove_file(&megasas_pci_driver.driver,
                           &driver_attr_release_date);
+
+err_dcf_support_poll_for_event:
+       driver_remove_file(&megasas_pci_driver.driver,
+                       &driver_attr_support_poll_for_event);
+
 err_dcf_rel_date:
        driver_remove_file(&megasas_pci_driver.driver, &driver_attr_version);
 err_dcf_attr_ver:
@@ -3681,6 +3704,8 @@ static void __exit megasas_exit(void)
        driver_remove_file(&megasas_pci_driver.driver,
                           &driver_attr_dbg_lvl);
        driver_remove_file(&megasas_pci_driver.driver,
+                       &driver_attr_support_poll_for_event);
+       driver_remove_file(&megasas_pci_driver.driver,
                           &driver_attr_release_date);
        driver_remove_file(&megasas_pci_driver.driver, &driver_attr_version);

