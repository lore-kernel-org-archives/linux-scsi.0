From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH] hpsa: add some older controllers to the kdump blacklist
Date: Tue, 14 Feb 2012 18:07:59 +0100
Message-ID: <4F3A94EF.50300@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756719Ab2BNRIt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Feb 2012 12:08:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>, "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>

Some other older controllers also do have problems to perform a kdump.
Adding controllers to this list means that the driver will signal
this non-ability via a resettable flag correctly. 
The unsupported list was created after a consultation with HP.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index b96962c..faac5a9 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -296,11 +296,23 @@ static u32 unresettable_controller[] = {
 	0x40800E11, /* Smart Array 5i */
 	0x409C0E11, /* Smart Array 6400 */
 	0x409D0E11, /* Smart Array 6400 EM */
+	0x40700E11, /* Smart Array 5300 */
+	0x40820E11, /* Smart Array 532 */
+	0x40830E11, /* Smart Array 5312 */
+	0x409A0E11, /* Smart Array 641 */
+	0x409B0E11, /* Smart Array 642 */
+	0x40910E11, /* Smart Array 6i */
 };
 
 /* List of controllers which cannot even be soft reset */
 static u32 soft_unresettable_controller[] = {
 	0x40800E11, /* Smart Array 5i */
+	0x40700E11, /* Smart Array 5300 */
+	0x40820E11, /* Smart Array 532 */
+	0x40830E11, /* Smart Array 5312 */
+	0x409A0E11, /* Smart Array 641 */
+	0x409B0E11, /* Smart Array 642 */
+	0x40910E11, /* Smart Array 6i */
 	/* Exclude 640x boards.  These are two pci devices in one slot
 	 * which share a battery backed cache module.  One controls the
 	 * cache, the other accesses the cache through the one that controls


