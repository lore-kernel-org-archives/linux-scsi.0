From: Paul Wagland <paul@kungfoocoder.org>
Subject: [PATCH][BUGFIX] : Megaraid patch for 2.6 1/5
Date: Fri, 20 Feb 2004 03:05:39 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1077242738.12567.76.camel@morsel.kungfoocoder.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-7vivzGSTw9kyRdJL/Fax"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out1.xs4all.nl ([194.109.24.11]:3080 "EHLO
	smtp-out1.xs4all.nl") by vger.kernel.org with ESMTP id S267479AbUBTCF5
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Feb 2004 21:05:57 -0500
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI mailing list <linux-scsi@vger.kernel.org>, Linux kernel mailing list <linux-kernel@vger.kernel.org>
Cc: akpm@osdl.org, torvalds@osdl.org, James.Bottomley@HansenPartnership.com, atulm@lsil.com


--=-7vivzGSTw9kyRdJL/Fax
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi all,

On Linux-SCSI over the last few days I have been discussing a couple of
problems with the 2.6.2 megaraid driver. This patch, originally
submitted by Christoph Hellwig, fixes the problem where the megaraid
driver could be removed, even though it was in use.

patch is attached and below.

diff --recursive --ignore-all-space --unified linux-2.6.2.o/drivers/scsi/megaraid.c linux-2.6.2.megaraid/drivers/scsi/megaraid.c
--- linux-2.6.2.o/drivers/scsi/megaraid.c	2004-02-09 22:56:09.000000000 +0100
+++ linux-2.6.2.megaraid/drivers/scsi/megaraid.c	2004-02-20 01:32:21.000000000 +0100
@@ -4614,6 +4614,7 @@
 }
 
 static struct scsi_host_template megaraid_template = {
+	.module				= THIS_MODULE,
 	.name				= "MegaRAID",
 	.proc_name			= "megaraid",
 	.info				= megaraid_info,


--=-7vivzGSTw9kyRdJL/Fax
Content-Disposition: attachment; filename=1-megaraid.mod_owner.patch
Content-Type: text/x-patch; name=1-megaraid.mod_owner.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

diff --recursive --ignore-all-space --unified linux-2.6.2.o/drivers/scsi/megaraid.c linux-2.6.2.megaraid/drivers/scsi/megaraid.c
--- linux-2.6.2.o/drivers/scsi/megaraid.c	2004-02-09 22:56:09.000000000 +0100
+++ linux-2.6.2.megaraid/drivers/scsi/megaraid.c	2004-02-20 01:32:21.000000000 +0100
@@ -4614,6 +4614,7 @@
 }
 
 static struct scsi_host_template megaraid_template = {
+	.module				= THIS_MODULE,
 	.name				= "MegaRAID",
 	.proc_name			= "megaraid",
 	.info				= megaraid_info,

--=-7vivzGSTw9kyRdJL/Fax--

