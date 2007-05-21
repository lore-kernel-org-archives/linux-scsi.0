From: Chris Wright <chrisw@sous-sol.org>
Subject: [patch 42/69] fix for bugzilla 8426: massive slowdown on SCSI CD/DVD drive connected to mptspi driver
Date: Mon, 21 May 2007 12:16:54 -0700
Message-ID: <20070521191739.274076000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:46203 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764253AbXEUTVC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 May 2007 15:21:02 -0400
Content-Disposition: inline; filename=fix-for-bugzilla-8426-massive-slowdown-on-scsi-cd-dvd-drive-connected-to-mptspi-driver.patch
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@kernel.org, James.Bottomley@steeleye.com
Cc: Justin Forbes <jmforbes@linuxtx.org>, Zwane Mwaikambo <zwane@arm.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>, Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>, Chris Wedgwood <reviews@ml.cw.f00f.org>, Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>, torvalds@linux-foundation.org, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, Eric.Moore@lsil.com, linux-scsi@vger.kernel.org, doug.chapman@hp.com

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Doug Chapman <doug.chapman@hp.com>

Patch for: http://bugzilla.kernel.org/show_bug.cgi?id=8426

A recent code cleanup that moved code from mptscsih to mptspi inadvertently
change the order some code was called.  This caused a massive slowdown (of
150x to 300x) on the CD/DVD drive on the high-end HP Integrity servers.

Signed-off-by: Doug Chapman <doug.chapman@hp.com>
Cc: <Eric.Moore@lsil.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
[chrisw: Why is this not upstream yet?]

 drivers/message/fusion/mptspi.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- linux-2.6.21.1.orig/drivers/message/fusion/mptspi.c
+++ linux-2.6.21.1/drivers/message/fusion/mptspi.c
@@ -726,13 +726,15 @@ static int mptspi_slave_configure(struct
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

-- 
