From: akpm@linux-foundation.org
Subject: [patch 04/28] osst: fix read buffer overflow
Date: Tue, 27 Apr 2010 14:22:50 -0700
Message-ID: <201004272122.o3RLMoxB020781@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51038 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756969Ab0D0VXL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Apr 2010 17:23:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, roel.kluin@gmail.com, osst@riede.org

From: Roel Kluin <roel.kluin@gmail.com>

Check whether index is within bounds before testing the element.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Willem Riede <osst@riede.org>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/osst.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/osst.c~osst-fix-read-buffer-overflow drivers/scsi/osst.c
--- a/drivers/scsi/osst.c~osst-fix-read-buffer-overflow
+++ a/drivers/scsi/osst.c
@@ -5861,7 +5861,8 @@ static int osst_probe(struct device *dev
 	}
 
 	/* find a free minor number */
-	for (i=0; os_scsi_tapes[i] && i<osst_max_dev; i++);
+	for (i = 0; i < osst_max_dev && os_scsi_tapes[i]; i++)
+		;
 	if(i >= osst_max_dev) panic ("Scsi_devices corrupt (osst)");
 	dev_num = i;
 
_
