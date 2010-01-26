From: krike@sci.fi
Subject: include/scsi/scsi.h: type mismatch in userspace
Date: Tue, 26 Jan 2010 12:09:06 +0200
Message-ID: <20100126100905.GA3600@sci.fi>
References: <20100121090042.GA2083@satellite>
 <20100121170158.GB13617@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="7JfCtLOvnd9MIVvH"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw02.mail.saunalahti.fi ([195.197.172.116]:40453 "EHLO
	gw02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948Ab0AZKJK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2010 05:09:10 -0500
Content-Disposition: inline
In-Reply-To: <20100121170158.GB13617@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello.

I think that there is mistake in linux/2.6.32.4/include/scsi/scsi.h:

the type defination of u8 should be type of __u8 on userspace 
(struct scsi_varlen_cdb_hdr).
I founded this problem when I try compile the util-linux-ng-2.17.
This should cause problems many other packages also that includes scsi.h

> 
> Please let the Linux SCSI developers know about this, they are the ones
> responsible for fixing it.  Once they have done so in the upstream tree,
> can I add it to the -stable tree.
> 
> thanks,
> 
> greg k-h

Best regards: Kristian Rainio <krike@sci.fi>

--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="linux-2.6.32.5-scsi_h.patch"

Patch by Kristian Rainio
Little fix.

--- linux-2.6.32/include/scsi/scsi.h.orig	2010-01-23 12:39:06.970791908 +0200
+++ linux-2.6.32/include/scsi/scsi.h	2010-01-23 12:39:25.427462244 +0200
@@ -145,10 +145,10 @@
 
 /* defined in T10 SCSI Primary Commands-2 (SPC2) */
 struct scsi_varlen_cdb_hdr {
-	u8 opcode;        /* opcode always == VARIABLE_LENGTH_CMD */
-	u8 control;
-	u8 misc[5];
-	u8 additional_cdb_length;         /* total cdb length - 8 */
+	__u8 opcode;        /* opcode always == VARIABLE_LENGTH_CMD */
+	__u8 control;
+	__u8 misc[5];
+	__u8 additional_cdb_length;         /* total cdb length - 8 */
 	__be16 service_action;
 	/* service specific data follows */
 };

--7JfCtLOvnd9MIVvH--
