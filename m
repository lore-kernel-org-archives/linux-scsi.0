From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: [PATCH 9/12] scsi: megaraid_sas - support devices update flag
Date: Fri, 18 Jun 2010 15:05:04 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C3D09274A6@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C35C5123FA@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C35C6861A5@cosmail02.lsi.com>
 <3A916D859199814BBB666188F96EB165013979165E@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C3CDB80B82@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C3CDB80BFF@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C3D080455B@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C3D080455B@cosmail02.lsi.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>, "'James.Bottomley@HansenPartnership.com'" <James.Bottomley@HansenPartnership.com>, "'James.Bottomley@suse.de'" <James.Bottomley@suse.de>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'akpm@osdl.org'" <akpm@osdl.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "Daftardar, Jayant" <Jayant.Daftardar@lsi.com>
List-Id: linux-scsi@vger.kernel.org

RESUBMIT:
Driver added the Device update flag to tell LSI application driver will do the device
Update.  LSI MegaRAID SAS application will check this flag to decide if it is need to
update the Device or not. 

Signed-off-by Bo Yang<bo.yang@lsi.com>

--- 
drivers/scsi/megaraid/megaraid_sas.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff -rupN old/drivers/scsi/megaraid/megaraid_sas.c new/drivers/scsi/megaraid/megaraid_sas.c
--- old/drivers/scsi/megaraid/megaraid_sas.c	2010-05-03 03:50:44.000000000 -0400
+++ new/drivers/scsi/megaraid/megaraid_sas.c	2010-05-03 05:46:37.000000000 -0400
@@ -99,6 +99,7 @@ static int megasas_poll_wait_aen;
 static DECLARE_WAIT_QUEUE_HEAD(megasas_poll_wait);
 static u32 support_poll_for_event;
 static u32 megasas_dbg_lvl;
+static u32 support_device_change;
 
 /* define lock for aen poll */
 spinlock_t poll_aen_lock;
@@ -4660,6 +4661,15 @@ megasas_sysfs_show_support_poll_for_even
 static DRIVER_ATTR(support_poll_for_event, S_IRUGO,
 			megasas_sysfs_show_support_poll_for_event, NULL);
 
+ static ssize_t
+megasas_sysfs_show_support_device_change(struct device_driver *dd, char *buf)
+{
+	return sprintf(buf, "%u\n", support_device_change);
+}
+
+static DRIVER_ATTR(support_device_change, S_IRUGO,
+			megasas_sysfs_show_support_device_change, NULL);
+
 static ssize_t
 megasas_sysfs_show_dbg_lvl(struct device_driver *dd, char *buf)
 {
@@ -4980,6 +4990,7 @@ static int __init megasas_init(void)
 	       MEGASAS_EXT_VERSION);
 
 	support_poll_for_event = 2;
+	support_device_change = 1;
 
 	memset(&megasas_mgmt_info, 0, sizeof(megasas_mgmt_info));
 
@@ -5028,8 +5039,17 @@ static int __init megasas_init(void)
 	if (rval)
 		goto err_dcf_poll_mode_io;
 
+	rval = driver_create_file(&megasas_pci_driver.driver,
+				&driver_attr_support_device_change);
+	if (rval)
+		goto err_dcf_support_device_change;
+
 	return rval;
 
+err_dcf_support_device_change:
+	driver_remove_file(&megasas_pci_driver.driver,
+		  &driver_attr_poll_mode_io);
+
 err_dcf_poll_mode_io:
 	driver_remove_file(&megasas_pci_driver.driver,
 			   &driver_attr_dbg_lvl);
@@ -5060,6 +5080,10 @@ static void __exit megasas_exit(void)
 	driver_remove_file(&megasas_pci_driver.driver,
 			   &driver_attr_dbg_lvl);
 	driver_remove_file(&megasas_pci_driver.driver,
+			&driver_attr_support_poll_for_event);
+	driver_remove_file(&megasas_pci_driver.driver,
+			&driver_attr_support_device_change);
+	driver_remove_file(&megasas_pci_driver.driver,
 			   &driver_attr_release_date);
 	driver_remove_file(&megasas_pci_driver.driver, &driver_attr_version);
