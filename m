From: Nick Warne <nick@ukfsn.org>
Subject: [PATCH] Fixup KERN_INFO in tmscsim.c
Date: Fri, 15 Aug 2008 12:10:45 +0100
Message-ID: <20080815121045.48ca37e4@sauron.linicks.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/uefwVYMAj+4xtWZJbMG4sXN"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.ukfsn.org ([77.75.108.10]:53285 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941AbYHOLKs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Aug 2008 07:10:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

--MP_/uefwVYMAj+4xtWZJbMG4sXN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi all,

Setting up my new AMD64 I noticed a curious one liner in syslogs:

^Iwith "disable_clustering=1" and report to maintainers

The attached patch fixes this up so he goes back to his wife
in /var/log/messages (or wherever KERN_INFO logs on the system):


DC390: clustering now enabled by default. If you get problems load
with "disable_clustering=1" and report to maintainers


The patch was created on stable 2.6.26.2 git tree.

Nick

Signed off by: "Nick Warne" <nick@ukfsn.org>
-- 
Free Software Foundation Associate Member 5508
--MP_/uefwVYMAj+4xtWZJbMG4sXN
Content-Type: text/x-patch; name=tmscsim_warn.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=tmscsim_warn.patch

--- drivers/scsi/tmscsim.cORIG	2008-08-15 10:30:47.000000000 +0100
+++ drivers/scsi/tmscsim.c	2008-08-15 11:45:01.000000000 +0100
@@ -2573,8 +2573,8 @@
 static int __init dc390_module_init(void)
 {
 	if (!disable_clustering)
-		printk(KERN_INFO "DC390: clustering now enabled by default. If you get problems load\n"
-		       "\twith \"disable_clustering=1\" and report to maintainers\n");
+		printk(KERN_INFO "DC390: clustering now enabled by default. If you get problems load\n");
+		printk(KERN_INFO "with \"disable_clustering=1\" and report to maintainers\n");
 
 	if (tmscsim[0] == -1 || tmscsim[0] > 15) {
 		tmscsim[0] = 7;

--MP_/uefwVYMAj+4xtWZJbMG4sXN--
