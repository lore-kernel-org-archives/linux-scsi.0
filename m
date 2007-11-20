From: Jonathan McDowell <noodles@earth.li>
Subject: [PATCH] Unify sysfs filenames for firmware version
Date: Tue, 20 Nov 2007 05:38:24 -0800
Message-ID: <20071120133824.GD31112@earth.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756255AbXKTNih@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Looking around sysfs in an attempt to pull out SCSI card firmware
versions I found 5 different filenames used to store the information.
Only one, fw_version, was used more than once. The patch below changes
the other drivers to use this filename too.

I suspect the same applies to other subsystem drivers as well. I'll look
at them assuming this patch is well received.

Signed-Off-By: Jonathan McDowell <noodles@earth.li>

-----
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 626bb3c..ae80d04 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -3307,7 +3307,7 @@ mptscsih_version_fw_show(struct class_device *cdev, char *buf)
 	    (ioc->facts.FWVersion.Word & 0x0000FF00) >> 8,
 	    ioc->facts.FWVersion.Word & 0x000000FF);
 }
-static CLASS_DEVICE_ATTR(version_fw, S_IRUGO, mptscsih_version_fw_show, NULL);
+static CLASS_DEVICE_ATTR(fw_version, S_IRUGO, mptscsih_version_fw_show, NULL);
 
 static ssize_t
 mptscsih_version_bios_show(struct class_device *cdev, char *buf)
diff --git a/drivers/scsi/arcmsr/arcmsr_attr.c b/drivers/scsi/arcmsr/arcmsr_attr.c
index 7d7b0a5..646f24c 100644
--- a/drivers/scsi/arcmsr/arcmsr_attr.c
+++ b/drivers/scsi/arcmsr/arcmsr_attr.c
@@ -352,7 +352,7 @@ static CLASS_DEVICE_ATTR(host_driver_posted_cmd, S_IRUGO, arcmsr_attr_host_drive
 static CLASS_DEVICE_ATTR(host_driver_reset, S_IRUGO, arcmsr_attr_host_driver_reset, NULL);
 static CLASS_DEVICE_ATTR(host_driver_abort, S_IRUGO, arcmsr_attr_host_driver_abort, NULL);
 static CLASS_DEVICE_ATTR(host_fw_model, S_IRUGO, arcmsr_attr_host_fw_model, NULL);
-static CLASS_DEVICE_ATTR(host_fw_version, S_IRUGO, arcmsr_attr_host_fw_version, NULL);
+static CLASS_DEVICE_ATTR(fw_version, S_IRUGO, arcmsr_attr_host_fw_version, NULL);
 static CLASS_DEVICE_ATTR(host_fw_request_len, S_IRUGO, arcmsr_attr_host_fw_request_len, NULL);
 static CLASS_DEVICE_ATTR(host_fw_numbers_queue, S_IRUGO, arcmsr_attr_host_fw_numbers_queue, NULL);
 static CLASS_DEVICE_ATTR(host_fw_sdram_size, S_IRUGO, arcmsr_attr_host_fw_sdram_size, NULL);
diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index 0844331..ed130ec 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -634,7 +634,7 @@ static struct class_device_attribute hptiop_attr_version = {
 
 static struct class_device_attribute hptiop_attr_fw_version = {
 	.attr = {
-		.name = "firmware-version",
+		.name = "fw_version",
 		.mode = S_IRUGO,
 	},
 	.show = hptiop_show_fw_version,
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 80a1121..32b1d2f 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -888,7 +888,7 @@ static CLASS_DEVICE_ATTR(modeldesc, S_IRUGO, lpfc_modeldesc_show, NULL);
 static CLASS_DEVICE_ATTR(modelname, S_IRUGO, lpfc_modelname_show, NULL);
 static CLASS_DEVICE_ATTR(programtype, S_IRUGO, lpfc_programtype_show, NULL);
 static CLASS_DEVICE_ATTR(portnum, S_IRUGO, lpfc_vportnum_show, NULL);
-static CLASS_DEVICE_ATTR(fwrev, S_IRUGO, lpfc_fwrev_show, NULL);
+static CLASS_DEVICE_ATTR(fw_version, S_IRUGO, lpfc_fwrev_show, NULL);
 static CLASS_DEVICE_ATTR(hdw, S_IRUGO, lpfc_hdw_show, NULL);
 static CLASS_DEVICE_ATTR(state, S_IRUGO, lpfc_state_show, NULL);
 static CLASS_DEVICE_ATTR(option_rom_version, S_IRUGO,
-----

J.

-- 
Web [    The World's most affectionate creature is a muddy dog.    ]
site: http:// [                                          ]       Made by
www.earth.li/~noodles/  [                      ]         HuggieTag 0.0.23
