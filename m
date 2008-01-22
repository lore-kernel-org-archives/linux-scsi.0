From: Tony Battersby <tonyb@cybernetics.com>
Subject: [PATCH] fix /proc/scsi/sg/devices when no SCSI devices
Date: Tue, 22 Jan 2008 15:25:49 -0500
Message-ID: <4796514D.6010908@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cybernetics.com ([70.169.137.4]:4458 "EHLO mail.cybernetics.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751602AbYAVUZs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jan 2008 15:25:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Douglas Gilbert <dougg@torque.net>, linux-scsi@vger.kernel.org

The patch "[SCSI] sg: use idr to replace static arrays" in 2.6.24-rc1
causes a bogus line to appear in /proc/scsi/sg/devices containing
"-1 -1 -1 -1 -1 -1 -1 -1 -1" when there are no SCSI devices in the
system.  In 2.6.23, /proc/scsi/sg/devices is empty when there are no
SCSI devices in the system.  A similar problem exists with
/proc/scsi/sg/device_strs.  The following patch restores the behavior
of 2.6.23.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---
--- linux-2.6.24-rc8-git5/drivers/scsi/sg.c.orig	2008-01-22 15:08:46.000000000 -0500
+++ linux-2.6.24-rc8-git5/drivers/scsi/sg.c	2008-01-22 15:09:05.000000000 -0500
@@ -2521,7 +2521,7 @@ sg_idr_max_id(int id, void *p, void *dat
 static int
 sg_last_dev(void)
 {
-	int k = 0;
+	int k = -1;
 	unsigned long iflags;
 
 	read_lock_irqsave(&sg_index_lock, iflags);


