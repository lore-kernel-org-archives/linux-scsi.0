From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH] fix module_init functions of transport classes
Date: Tue, 11 Jan 2005 09:30:44 +0100
Message-ID: <20050111083044.GA3239@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:953 "EHLO
	mtagate3.de.ibm.com") by vger.kernel.org with ESMTP id S262557AbVAKIbr
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jan 2005 03:31:47 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate3.de.ibm.com (8.12.10/8.12.10) with ESMTP id j0B8Vjdt165940
	for <linux-scsi@vger.kernel.org>; Tue, 11 Jan 2005 08:31:45 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j0B8WdmZ143814
	for <linux-scsi@vger.kernel.org>; Tue, 11 Jan 2005 09:32:39 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.12.11) with ESMTP id j0B8VjeK013288
	for <linux-scsi@vger.kernel.org>; Tue, 11 Jan 2005 09:31:45 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi James,

thanks for explaining the object lifetimes rules in the SCSI stack to
me. Unfortunately I don't think I could exploit that to solve the zfcp
problem.

While looking at the FC transport class code I think there is a minor
bug if class_register fails in the module_init code. The
class_unregister call of the succeeded class_register call seems to be
missing. Patch below is untested.

Heiko

===== scsi_transport_fc.c 1.11 vs edited =====
--- 1.11/drivers/scsi/scsi_transport_fc.c	2004-12-27 17:04:13 +01:00
+++ edited/scsi_transport_fc.c	2005-01-11 09:14:03 +01:00
@@ -222,7 +222,10 @@
 	int error = class_register(&fc_host_class);
 	if (error)
 		return error;
-	return class_register(&fc_transport_class);
+	error = class_register(&fc_transport_class);
+	if (error)
+		class_unregister(&fc_host_class);
+	return error;
 }
 
 static void __exit fc_transport_exit(void)
===== scsi_transport_spi.c 1.21 vs edited =====
--- 1.21/drivers/scsi/scsi_transport_spi.c	2004-12-06 21:51:40 +01:00
+++ edited/scsi_transport_spi.c	2005-01-11 09:14:58 +01:00
@@ -134,7 +134,10 @@
 	int error = class_register(&spi_host_class);
 	if (error)
 		return error;
-	return class_register(&spi_transport_class);
+	error = class_register(&spi_transport_class);
+	if (error)
+		class_unregister(&spi_host_class);
+	return error;
 }
 
 static void __exit spi_transport_exit(void)
===== scsi_transport_iscsi.c 1.1 vs edited =====
--- 1.1/drivers/scsi/scsi_transport_iscsi.c	2004-10-29 13:30:20 +02:00
+++ edited/scsi_transport_iscsi.c	2005-01-11 09:28:10 +01:00
@@ -338,7 +338,10 @@
 
 	if (err)
 		return err;
-	return class_register(&iscsi_host_class);
+	err = class_register(&iscsi_host_class);
+	if (err)
+		class_unregister(&iscsi_transport_class);
+	return err;
 }
 
 static void __exit iscsi_transport_exit(void)
