From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/10] megaraid_sas: swap whole register in megasas_register_aen
Date: Sat, 10 Jan 2015 18:11:22 +0100
Message-ID: <1420909883-19479-10-git-send-email-hch@lst.de>
References: <1420909883-19479-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:34200 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431AbbAJRMZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Jan 2015 12:12:25 -0500
In-Reply-To: <1420909883-19479-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit.Saxena@avagotech.com, kashyap.desai@avagotech.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org

Swap the whole 32 bits we read from the hardware instead of swapping
just the 16bits we care about in place later.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 5350e18..3d4a080 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4882,8 +4882,9 @@ megasas_register_aen(struct megasas_instance *instance, u32 seq_num,
 
 	if (instance->aen_cmd) {
 
-		prev_aen.word = instance->aen_cmd->frame->dcmd.mbox.w[1];
-		prev_aen.members.locale = le16_to_cpu(prev_aen.members.locale);
+		prev_aen.word =
+			le32_to_cpu(instance->aen_cmd->frame->dcmd.mbox.w[1]);
+		prev_aen.members.locale = prev_aen.members.locale;
 
 		/*
 		 * A class whose enum value is smaller is inclusive of all
-- 
1.9.1

