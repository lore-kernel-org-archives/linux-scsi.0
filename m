From: Al Viro <viro@ftp.linux.org.uk>
Subject: fix reentrancy bug in arcmsr_get_iop_{r,w}qbuffer()
Date: Mon, 29 Oct 2007 05:08:58 +0000
Message-ID: <E1ImMry-0003TZ-Pw@ZenIV.linux.org.uk>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:35944 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756372AbXJ2FI7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Oct 2007 01:08:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: nick.cheng@areca.com.tw, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


doh...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/scsi/arcmsr/arcmsr_hba.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index acbc50f..d466a2d 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -1095,7 +1095,7 @@ static void arcmsr_iop_message_wrote(struct AdapterControlBlock *acb)
 
 struct QBUFFER __iomem *arcmsr_get_iop_rqbuffer(struct AdapterControlBlock *acb)
 {
-	static struct QBUFFER __iomem *qbuffer;
+	struct QBUFFER __iomem *qbuffer = NULL;
 
 	switch (acb->adapter_type) {
 
@@ -1116,7 +1116,7 @@ struct QBUFFER __iomem *arcmsr_get_iop_rqbuffer(struct AdapterControlBlock *acb)
 
 static struct QBUFFER __iomem *arcmsr_get_iop_wqbuffer(struct AdapterControlBlock *acb)
 {
-	static struct QBUFFER __iomem *pqbuffer;
+	struct QBUFFER __iomem *pqbuffer = NULL;
 
 	switch (acb->adapter_type) {
 
-- 
1.5.3.GIT

