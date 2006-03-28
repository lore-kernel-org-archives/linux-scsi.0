From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 09/10] Enable clustering and large transfers
Date: Tue, 28 Mar 2006 11:03:44 -0500
Message-ID: <1143561824404-git-send-email-matthew@wil.cx>
Reply-To: Matthew Wilcox <matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.magma.ca ([206.191.0.250]:42678 "EHLO mx2.magma.ca")
	by vger.kernel.org with ESMTP id S1751232AbWC1QDc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Mar 2006 11:03:32 -0500
In-Reply-To: 20060328160156.GJ3486@parisc-linux.org
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Kai Makisara <kai.makisara@kolumbus.fi>

This patch enables clustering and sets max_sectors to 0xffff to enable
reading and writing of large blocks with tapes (and large transfers with
sg). This change is needed after the sg and st drivers started using
chained bios through scsi_request_async() in 2.6.16.

Signed-off-by: Kai Makisara <kai.makisara@kolumbus.fi>
Signed-off-by: Matthew Wilcox <matthew@wil.cx>

---

 drivers/scsi/sym53c8xx_2/sym_glue.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

1c573ec4648b4b4ddadcbd1945a9a608977df513
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index e48409e..2c4e5f1 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -1870,7 +1870,8 @@ static struct scsi_host_template sym2_te
 	.eh_bus_reset_handler	= sym53c8xx_eh_bus_reset_handler,
 	.eh_host_reset_handler	= sym53c8xx_eh_host_reset_handler,
 	.this_id		= 7,
-	.use_clustering		= DISABLE_CLUSTERING,
+	.use_clustering		= ENABLE_CLUSTERING,
+	.max_sectors		= 0xFFFF,
 #ifdef SYM_LINUX_PROC_INFO_SUPPORT
 	.proc_info		= sym53c8xx_proc_info,
 	.proc_name		= NAME53C8XX,
-- 
1.2.4.g375a5


