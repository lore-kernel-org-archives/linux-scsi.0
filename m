From: Jeremy Higdon <jeremy@sgi.com>
Subject: [PATCH] minor changes to qla1280 driver
Date: Thu, 22 Apr 2004 19:39:36 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040423023935.GA880193@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtvcafw.sgi.com ([192.48.171.6]:62489 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S264696AbUDWCky (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Apr 2004 22:40:54 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jes@wildopensource.com, linux-scsi@vger.kernel.org

On one of our big machines we found a problem with posted writes while
running AIM.

Two writes of the Request Queue In pointer went out of order, making
the chip think that it had a queue wrap.

I took advantage of this opportunity to add relaxed reads, which helps
the Altix.  It should not affect other arches.  All reads are relaxed
except for the read of the Semaphore register.

Thanks

jeremy

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1784  -> 1.1785 
#	drivers/scsi/qla1280.h	1.24    -> 1.25   
#	drivers/scsi/qla1280.c	1.55    -> 1.56   
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 04/04/22	jeremy@tomahawk.engr.sgi.com	1.1785
# Add missing posted write flush and relaxed PIO reads.
# --------------------------------------------
#
diff -Nru a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
--- a/drivers/scsi/qla1280.c	Thu Apr 22 19:26:22 2004
+++ b/drivers/scsi/qla1280.c	Thu Apr 22 19:26:22 2004
@@ -3371,6 +3371,7 @@
 	sp->flags |= SRB_SENT;
 	ha->actthreads++;
 	WRT_REG_WORD(&reg->mailbox4, ha->req_ring_index);
+	(void) RD_REG_WORD(&reg->mailbox4); /* PCI posted write flush */
 
  out:
 	if (status)
@@ -3639,6 +3640,7 @@
 	sp->flags |= SRB_SENT;
 	ha->actthreads++;
 	WRT_REG_WORD(&reg->mailbox4, ha->req_ring_index);
+	(void) RD_REG_WORD(&reg->mailbox4); /* PCI posted write flush */
 
 out:
 	if (status)
@@ -3750,6 +3752,7 @@
 
 	/* Set chip new ring index. */
 	WRT_REG_WORD(&reg->mailbox4, ha->req_ring_index);
+	(void) RD_REG_WORD(&reg->mailbox4); /* PCI posted write flush */
 
 	LEAVE("qla1280_isp_cmd");
 }
@@ -3788,7 +3791,7 @@
 
 	/* Check for mailbox interrupt. */
 
-	mailbox[0] = RD_REG_WORD(&reg->semaphore);
+	mailbox[0] = RD_REG_WORD_dmasync(&reg->semaphore);
 
 	if (mailbox[0] & BIT_0) {
 		/* Get mailbox data. */
diff -Nru a/drivers/scsi/qla1280.h b/drivers/scsi/qla1280.h
--- a/drivers/scsi/qla1280.h	Thu Apr 22 19:26:22 2004
+++ b/drivers/scsi/qla1280.h	Thu Apr 22 19:26:22 2004
@@ -57,7 +57,8 @@
 #define BIT_31	0x80000000
 
 #if MEMORY_MAPPED_IO
-#define RD_REG_WORD(addr)		readw(addr)
+#define RD_REG_WORD(addr)		readw_relaxed(addr)
+#define RD_REG_WORD_dmasync(addr)	readw(addr)
 #define WRT_REG_WORD(addr, data)	writew(data, addr)
 #else				/* MEMORY_MAPPED_IO */
 #define RD_REG_WORD(addr)		inw((unsigned long)addr)
