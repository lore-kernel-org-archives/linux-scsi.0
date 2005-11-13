From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 1/4] scsi: add further comments to struct
 scsi_host_template
Date: Sun, 13 Nov 2005 17:15:21 +0100 (CET)
Message-ID: <200511131617.jADGHZwQ031929@einhorn.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:49367 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S964925AbVKMQR7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Nov 2005 11:17:59 -0500
Received: from s5r6.in-berlin.de ([83.221.230.151])
	by einhorn.in-berlin.de (8.12.10/8.12.10/Debian-4) with ESMTP id jADGHZwQ031929
	for <linux-scsi@vger.kernel.org>; Sun, 13 Nov 2005 17:17:49 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

scsi_host.h: add some comments to struct scsi_host_template

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 include/scsi/scsi_host.h |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

--- linux-2.6.14-git3/include/scsi/scsi_host.h.orig	2005-10-28 02:02:08.000000000 +0200
+++ linux-2.6.14-git3/include/scsi/scsi_host.h	2005-11-13 16:24:58.000000000 +0100
@@ -40,7 +40,19 @@ enum scsi_eh_timer_return {
 
 
 struct scsi_host_template {
+	/*
+	 * The low-level driver should set this to THIS_MODULE to prevent
+	 * itself being unloaded while higher levels use devices at this host.
+	 *
+	 * Status: OPTIONAL	(strongly recommended)
+	 */
 	struct module *module;
+
+	/*
+	 * A short human-readable identification of the host.
+	 *
+	 * Status: REQUIRED
+	 */
 	const char *name;
 
 	/*
@@ -295,13 +307,16 @@ struct scsi_host_template {
 	int (*proc_info)(struct Scsi_Host *, char *, char **, off_t, int, int);
 
 	/*
-	 * Name of proc directory
+	 * Name of proc directory. Also content of proc_name attribute of
+	 * the host's sysfs class device.
+	 *
+	 * Status: REQUIRED
 	 */
 	char *proc_name;
 
 	/*
 	 * Used to store the procfs directory if a driver implements the
-	 * proc_info method.
+	 * proc_info method. Created and destroyed by SCSI core.
 	 */
 	struct proc_dir_entry *proc_dir;
 


