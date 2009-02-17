From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: [PATCH 3/9] scsi: megaraid_sas - Add poll wait support to megaraid
 sas driver - II
Date: Tue, 17 Feb 2009 08:36:18 -0700
Message-ID: <4B6A08C587958942AA3002690DD4F8C33A07FB58@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C33A07FB3B@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og111.obsmtp.com ([64.18.2.175]:50170 "EHLO
	exprod7og111.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbZBQPgi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Feb 2009 10:36:38 -0500
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C33A07FB3B@cosmail02.lsi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akpm@osdl.org" <akpm@osdl.org>li
Cc: "Austria, Winston" <Winston.Austria@lsi.com>

Add poll wait support to megaraid sas driver - II, Add Poll_wait mechanism to Gen-2 Linux driver.  Avoid the depending upon storelib to continue events.

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
drivers/scsi/megaraid/megaraid_sas.c |   25 +++++++++++++++++++++++++
 drivers/scsi/megaraid/megaraid_sas.h |    1 +
 2 files changed, 26 insertions(+)

diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c      2009-02-12 15:44:26.000000000 -0500
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c       2009-02-12 15:47:21.000000000 -0500
@@ -95,6 +95,8 @@ static DECLARE_WAIT_QUEUE_HEAD (megasas_
 extern void
 poll_wait(struct file *filp, wait_queue_head_t *q, poll_table *token);

+static u32 support_poll_for_event;
+
 static u32 megasas_dbg_lvl;

 static void
@@ -3427,6 +3429,15 @@ static DRIVER_ATTR(release_date, S_IRUGO
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
@@ -3610,6 +3621,8 @@ static int __init megasas_init(void)
        printk(KERN_INFO "megasas: %s %s\n", MEGASAS_VERSION,
               MEGASAS_EXT_VERSION);

+       support_poll_for_event = 1;
+
        memset(&megasas_mgmt_info, 0, sizeof(megasas_mgmt_info));

        /*
@@ -3642,6 +3655,12 @@ static int __init megasas_init(void)
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
@@ -3659,6 +3678,10 @@ err_dcf_poll_mode_io:
 err_dcf_dbg_lvl:
        driver_remove_file(&megasas_pci_driver.driver,
                           &driver_attr_release_date);
+err_dcf_support_poll_for_event:
+       driver_remove_file(&megasas_pci_driver.driver,
+                       &driver_attr_support_poll_for_event);
+
 err_dcf_rel_date:
        driver_remove_file(&megasas_pci_driver.driver, &driver_attr_version);
 err_dcf_attr_ver:
@@ -3678,6 +3701,8 @@ static void __exit megasas_exit(void)
        driver_remove_file(&megasas_pci_driver.driver,
                           &driver_attr_dbg_lvl);
        driver_remove_file(&megasas_pci_driver.driver,
+                       &driver_attr_support_poll_for_event);
+       driver_remove_file(&megasas_pci_driver.driver,
                           &driver_attr_release_date);
        driver_remove_file(&megasas_pci_driver.driver, &driver_attr_version);

diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.h linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.h
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.h      2009-02-12 15:44:27.000000000 -0500
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.h       2009-02-12 15:24:58.000000000 -0500
@@ -1135,6 +1135,7 @@ struct megasas_instance {
        struct tasklet_struct isr_tasklet;

        u8 flag;
+       u8 unload;
        unsigned long last_time;

        struct timer_list io_completion_timer;
