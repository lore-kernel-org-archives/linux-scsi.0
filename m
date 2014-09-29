From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 06/38] acornscsi: use scsi_print_command()
Date: Mon, 29 Sep 2014 13:58:35 +0200
Message-ID: <1411991947-130166-7-git-send-email-hare@suse.de>
References: <1411991947-130166-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59336 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753620AbaI2L7O (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Sep 2014 07:59:14 -0400
In-Reply-To: <1411991947-130166-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>

Update acornscsi to use scsi_print_command() instead of the
underscore version. This will add correct device annotations
in the resulting message.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/arm/acornscsi.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index d89b9b4..deaaf84 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -850,13 +850,13 @@ static void acornscsi_done(AS_Host *host, struct scsi_cmnd **SCpntp,
 			break;
 
 		    default:
-			printk(KERN_ERR "scsi%d.H: incomplete data transfer detected: result=%08X command=",
-				host->host->host_no, SCpnt->result);
-			__scsi_print_command(SCpnt->cmnd);
+			scmd_printk(KERN_ERR, SCpnt,
+				    "incomplete data transfer detected: "
+				    "result=%08X", SCpnt->result);
+			scsi_print_command(SCpnt);
 			acornscsi_dumpdma(host, "done");
-		 	acornscsi_dumplog(host, SCpnt->device->id);
-			SCpnt->result &= 0xffff;
-			SCpnt->result |= DID_ERROR << 16;
+			acornscsi_dumplog(host, SCpnt->device->id);
+			set_host_byte(SCpnt, DID_ERROR);
 		    }
 		}
 	}
-- 
1.8.5.2

