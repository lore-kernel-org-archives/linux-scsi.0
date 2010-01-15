From: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: [PATCH] scsi_sysfs.c: make local symbols static
Date: Thu, 14 Jan 2010 18:39:52 -0700
Message-ID: <201001141839.52462.hartleys@visionengravers.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [206.15.93.42] ([206.15.93.42]:15476 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750743Ab0AOBjs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Jan 2010 20:39:48 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de

scsi_sysfs.c: make local symbols static

The symbols dev_attr_hstate and scsi_shost_attr_group
are only used locally in this file. Make them static to prevent
the following sparse warnings:

warning: symbol 'dev_attr_hstate' was not declared. Should it be static?
warning: symbol 'scsi_shost_attr_group' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>

---

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 5a06505..5016ab6 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -195,7 +195,7 @@ show_shost_state(struct device *dev, struct device_attribute *attr, char *buf)
 }
 
 /* DEVICE_ATTR(state) clashes with dev_attr_state for sdev */
-struct device_attribute dev_attr_hstate =
+static struct device_attribute dev_attr_hstate =
 	__ATTR(state, S_IRUGO | S_IWUSR, show_shost_state, store_shost_state);
 
 static ssize_t
@@ -271,7 +271,7 @@ static struct attribute *scsi_sysfs_shost_attrs[] = {
 	NULL
 };
 
-struct attribute_group scsi_shost_attr_group = {
+static struct attribute_group scsi_shost_attr_group = {
 	.attrs =	scsi_sysfs_shost_attrs,
 };
 
