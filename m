From: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: [PATCH] drivers/scs/scsi_sysfs.c: local variables should not be exposed globally
Date: Mon, 16 Apr 2012 18:32:18 -0700
Message-ID: <201204161832.18848.hartleys@visionengravers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail127.messagelabs.com ([216.82.250.115]:42981 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab2DQBcX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Apr 2012 21:32:23 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: linux-scsi@vger.kernel.org, JBottomley@parallels.com

Variables not referenced outside of a source file should be marked
static to prevent it from being exposed globally.

This quiets the sparse warnings:

warning: symbol 'dev_attr_hstate' was not declared. Should it be static?
warning: symbol 'scsi_shost_attr_group' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>

---

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 04c2a27..fbff014 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -197,7 +197,7 @@ show_shost_state(struct device *dev, struct device_attribute *attr, char *buf)
 }
 
 /* DEVICE_ATTR(state) clashes with dev_attr_state for sdev */
-struct device_attribute dev_attr_hstate =
+static struct device_attribute dev_attr_hstate =
 	__ATTR(state, S_IRUGO | S_IWUSR, show_shost_state, store_shost_state);
 
 static ssize_t
@@ -313,7 +313,7 @@ static struct attribute *scsi_sysfs_shost_attrs[] = {
 	NULL
 };
 
-struct attribute_group scsi_shost_attr_group = {
+static struct attribute_group scsi_shost_attr_group = {
 	.attrs =	scsi_sysfs_shost_attrs,
 };
 
