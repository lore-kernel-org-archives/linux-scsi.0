From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: [PATCH] dc395x: fix printk format warning
Date: Sun, 25 Jun 2006 22:28:20 -0700
Message-ID: <20060625222820.00239893.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:17886 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S964790AbWFZF3s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jun 2006 01:29:48 -0400
Received: from midway.site ([71.245.108.25]) by xenotime.net for <linux-scsi@vger.kernel.org>; Sun, 25 Jun 2006 22:29:46 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejb <james.bottomley@steeleye.com>, akpm <akpm@osdl.org>, oliver@neukum.name, aliakc@web.de, lenehan@twibble.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix printk format warning:
drivers/scsi/dc395x.c:1224: warning: format '%i' expects type 'int', but argument 5 has type 'size_t'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/scsi/dc395x.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

--- linux-2617-g9.orig/drivers/scsi/dc395x.c
+++ linux-2617-g9/drivers/scsi/dc395x.c
@@ -1219,7 +1219,7 @@ static void dump_register_info(struct Ad
 			    	srb, srb->cmd, srb->cmd->pid,
 				srb->cmd->cmnd[0], srb->cmd->device->id,
 			       	srb->cmd->device->lun);
-		printk("  sglist=%p cnt=%i idx=%i len=%i\n",
+		printk("  sglist=%p cnt=%i idx=%i len=%Zd\n",
 		       srb->segment_x, srb->sg_count, srb->sg_index,
 		       srb->total_xfer_length);
 		printk("  state=0x%04x status=0x%02x phase=0x%02x (%sconn.)\n",


---
