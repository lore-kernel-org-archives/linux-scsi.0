From: David van Hoose <davidvh@cox.net>
Subject: [TRIVIAL PATCH] Fix compilation errors in ppa and imm modules
Date: Mon, 02 Jun 2003 11:18:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EDB6AE0.5080106@cox.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040905060101070909000404"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from garnet.acns.fsu.edu ([146.201.2.25]:52447 "EHLO
	garnet.acns.fsu.edu") by vger.kernel.org with ESMTP id S262422AbTFBPG0
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Jun 2003 11:06:26 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@steeleye.com

This is a multi-part message in MIME format.
--------------040905060101070909000404
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This patch is a resend from LKML since it has yet to be applied in 
either bk7. Patrick suggested I send it here. This patch fixes 
compilation failures in ppa.c and imm.c that were introduced in 2.5.70-bk1.

* Removes the 'int hostno' parameter from imm_proc_info().
Parameter isn't used and breaks the pointer matching for Scsi_Host.
* Added the prototype for imm_proc_info() in imm.h
* Modified line 280 of ppa.c to match concept on line 263 of imm.c.

If anyone has any questions, cc emails to me as I am not on the 
linux-scsi mailing list.

Thank you,
David


--------------040905060101070909000404
Content-Type: text/plain;
 name="patch-dvh.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch-dvh.diff"

diff -Nru a/drivers/scsi/imm.c b/drivers/scsi/imm.c
--- a/drivers/scsi/imm.c	2003-05-27 12:09:47.000000000 -0400
+++ b/drivers/scsi/imm.c	2003-05-27 12:05:29.000000000 -0400
@@ -254,7 +254,7 @@
 }
 
 int imm_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t offset,
-		  int length, int hostno, int inout)
+		  int length, int inout)
 {
     int i;
     int len = 0;
diff -Nru a/drivers/scsi/imm.h b/drivers/scsi/imm.h
--- a/drivers/scsi/imm.h	2003-05-27 12:09:47.000000000 -0400
+++ b/drivers/scsi/imm.h	2003-05-27 12:05:11.000000000 -0400
@@ -159,6 +159,7 @@
 int imm_queuecommand(Scsi_Cmnd *, void (*done) (Scsi_Cmnd *));
 int imm_abort(Scsi_Cmnd *);
 int imm_reset(Scsi_Cmnd *);
+int imm_proc_info(struct Scsi_Host *, char *, char **, off_t, int, int);
 int imm_biosparam(struct scsi_device *, struct block_device *,
 		sector_t, int *);
 
diff -Nru a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
--- a/drivers/scsi/ppa.c	2003-05-27 12:09:47.000000000 -0400
+++ b/drivers/scsi/ppa.c	2003-05-27 11:56:01.000000000 -0400
@@ -277,7 +277,7 @@
     int len = 0;
 
     for (i = 0; i < 4; i++)
-	if (ppa_hosts[i] == host)
+	if (ppa_hosts[i].host == host->host_no)
 	    break;
 
     if (inout)


--------------040905060101070909000404--

