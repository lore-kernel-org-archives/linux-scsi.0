From: <Patrick_Boyd@Dell.com>
Subject: [PATCH 001/001] AACRAID: patch for AFA management libraries
Date: Wed, 30 Aug 2006 13:22:08 -0500
Message-ID: <FCD01C3AA0ADFB498F9BB1A6173DFC5D93B21A@ausx3mpc120.aus.amer.dell.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:20876 "EHLO
	ausc60ps301.us.dell.com") by vger.kernel.org with ESMTP
	id S1751289AbWH3SWK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Aug 2006 14:22:10 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: markh@osdl.org, Bill_Edwards@Dell.com, Sumeet_Kukreja@Dell.com, Jonathan_L_Hall@Dell.com
Cc: linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com, mark_salyzyn@adaptec.com

From: Patrick Boyd <Patrick_Boyd@dell.com>, Bill Edwards
<Bill_Edwards@dell.com>

The problem that we are having is that on the current version of RedHat
Enterprise Linux 5 (2.6.16 kernel) the Adaptec raid management libraries
(AFALIB) no longer function. We were able to root cause this to the fact
that the /proc/scsi/aacraid directory was missing. 

This directory is created if two properties are set in the
scsi_host_template structure: proc_name and proc_info. However, previous
driver version were not setting proc_info and as far as we can tell this
was just being set to uninitialized memory which was allowing the
directory creation to succeed. Apparently compiler or runtime behavior
has changed so that uninitialized entries in this static struct are set
to 0. Our solution is to simply create a function and put the function
pointer into the struct to restore the original behavior under the new
compiler.

Signed-off-by: Patrick Boyd <Patrick_Boyd@dell.com>, Bill Edwards
<Bill_Edwards@dell.com>

---

--- linux-2.6.16/drivers/scsi/aacraid/linit.c.orig	2006-08-30
11:53:58.000000000 -0500
+++ linux-2.6.16/drivers/scsi/aacraid/linit.c	2006-08-30
11:55:27.000000000 -0500
@@ -782,10 +782,18 @@ static struct file_operations aac_cfg_fo
 	.open		= aac_cfg_open,
 };
 
+static int aacraid_proc_info(struct Scsi_Host *host, char *buffer, char
**start, off_t offset,
+                                int length, int inout)
+{
+        return 0;
+}
+
+
 static struct scsi_host_template aac_driver_template = {
 	.module				= THIS_MODULE,
 	.name           		= "AAC",
 	.proc_name			= AAC_DRIVERNAME,
+	.proc_info			= aacraid_proc_info,
 	.info           		= aac_info,
 	.ioctl          		= aac_ioctl,
 #ifdef CONFIG_COMPAT
