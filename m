From: akpm@linux-foundation.org
Subject: [patch 24/28] fix for bugzilla 8426: massive slowdown on SCSI CD/DVD drive connected to mptspi driver
Date: Thu, 10 May 2007 23:01:08 -0700
Message-ID: <200705110601.l4B6183j008187@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41579 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758157AbXEKGKd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 May 2007 02:10:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, doug.chapman@hp.com, Eric.Moore@lsil.com, stable@kernel.org

From: Doug Chapman <doug.chapman@hp.com>

Patch for: http://bugzilla.kernel.org/show_bug.cgi?id=8426

A recent code cleanup that moved code from mptscsih to mptspi inadvertently
change the order some code was called.  This caused a massive slowdown (of
150x to 300x) on the CD/DVD drive on the high-end HP Integrity servers.

Signed-off-by: Doug Chapman <doug.chapman@hp.com>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptspi.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/message/fusion/mptspi.c~fix-for-bugzilla-8426-massive-slowdown-on-scsi-cd-dvd-drive-connected-to-mptspi-driver drivers/message/fusion/mptspi.c
--- a/drivers/message/fusion/mptspi.c~fix-for-bugzilla-8426-massive-slowdown-on-scsi-cd-dvd-drive-connected-to-mptspi-driver
+++ a/drivers/message/fusion/mptspi.c
@@ -727,13 +727,15 @@ static int mptspi_slave_configure(struct
 	struct _MPT_SCSI_HOST *hd =
 		(struct _MPT_SCSI_HOST *)sdev->host->hostdata;
 	VirtTarget *vtarget = scsi_target(sdev)->hostdata;
-	int ret = mptscsih_slave_configure(sdev);
+	int ret;
+
+	mptspi_initTarget(hd, vtarget, sdev);
+
+	ret = mptscsih_slave_configure(sdev);
 
 	if (ret)
 		return ret;
 
-	mptspi_initTarget(hd, vtarget, sdev);
-
 	ddvprintk((MYIOC_s_INFO_FMT "id=%d min_period=0x%02x"
 		" max_offset=0x%02x max_width=%d\n", hd->ioc->name,
 		sdev->id, spi_min_period(scsi_target(sdev)),
_
