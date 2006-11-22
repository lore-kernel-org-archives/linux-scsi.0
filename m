From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 2/3] SCSI: Missing check for no scanning
Date: Wed, 22 Nov 2006 13:24:53 -0700
Message-ID: <1164227094130-git-send-email-matthew@wil.cx>
References: <11642270942262-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:61357 "EHLO
	mail.parisc-linux.org") by vger.kernel.org with ESMTP
	id S1756915AbWKVUYz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Nov 2006 15:24:55 -0500
In-Reply-To: <11642270942262-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>

Drivers that called scsi_scan_target() instead of scsi_scan_host() were
still adding devices; this needs to be under the control of userspace,
not the driver.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/scsi_scan.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 6855472..a2ca2e9 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1539,6 +1539,9 @@ void scsi_scan_target(struct device *par
 {
 	struct Scsi_Host *shost = dev_to_shost(parent);
 
+	if (strncmp(scsi_scan_type, "none", 4) == 0)
+		return;
+
 	if (!shost->async_scan)
 		scsi_complete_async_scans();
 
-- 
1.4.3.3

