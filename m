From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: PATCH: Bogus disk geometry on large disks
Date: Fri, 26 May 2006 17:29:25 +0100
Message-ID: <1148660965.20856.35.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60878 "EHLO
	lxorguk.ukuu.org.uk") by vger.kernel.org with ESMTP
	id S1750721AbWEZQPR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 May 2006 12:15:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org, linux-scsi@vger.kernel.org

We currently stuff a truncated size into the geometry logic and return
the result which can produce bizarre reports for a 4Tb array. Since that
mapping logic isn't useful for disks that big don't try and map this way
at all.

Signed-off-by: Alan Cox <alan@redhat.com>

--- libata-ref/drivers/scsi/scsicam.c	2006-05-23 13:05:45.000000000 +0100
+++ libata-dev/drivers/scsi/scsicam.c	2006-05-24 01:07:57.541182984 +0100
@@ -68,7 +68,7 @@
 			       (unsigned int *)ip + 0, (unsigned int *)ip + 1);
 	kfree(p);
 
-	if (ret == -1) {
+	if (ret == -1 && capacity < (1ULL << 32)) {
 		/* pick some standard mapping with at most 1024 cylinders,
 		   and at most 62 sectors per track - this works up to
 		   7905 MB */

