From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 1/2] [SCSI] Use spi_print_msg in ncr53c8xx driver
Date: Fri, 16 Dec 2005 12:50:53 -0500
Message-ID: <11347554533046-git-send-email-matthew@wil.cx>
Reply-To: Matthew Wilcox <matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2-old.magma.ca ([206.191.0.250]:21689 "EHLO mx2.magma.ca")
	by vger.kernel.org with ESMTP id S1751322AbVLPRu6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Dec 2005 12:50:58 -0500
In-Reply-To: 
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

The ncr53c8xx driver had its own loop to print scsi messages.  Use the
SPI one instead.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

---

 drivers/scsi/ncr53c8xx.c |   15 ++-------------
 1 files changed, 2 insertions(+), 13 deletions(-)

329a333aefca0a6fda7199e6150a525c4c618832
diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index 2434709..8e1c77c 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -2971,21 +2971,10 @@ struct host_data {
 
 static void ncr_print_msg(struct ccb *cp, char *label, u_char *msg)
 {
-	int i;
 	PRINT_ADDR(cp->cmd, "%s: ", label);
 
-	printk ("%x",*msg);
-	if (*msg == M_EXTENDED) {
-		for (i = 1; i < 8; i++) {
-			if (i - 1 > msg[1])
-				break;
-			printk ("-%x",msg[i]);
-		}
-	} else if ((*msg & 0xf0) == 0x20) {
-		printk ("-%x",msg[1]);
-	}
-
-	printk(".\n");
+	spi_print_msg(msg);
+	printk("\n");
 }
 
 /*==========================================================
-- 
0.99.9.GIT


