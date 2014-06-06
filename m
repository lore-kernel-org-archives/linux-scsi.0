From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH] be2iscsi: add an missing goto in error path
Date: Fri, 06 Jun 2014 14:06:30 +0200
Message-ID: <5391AEC6.1040207@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbaFFMGe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Jun 2014 08:06:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: jayamohank@gmail.com, sony.john-n@emulex.com

a jump to 'free_memory' is apparently missing

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index ac54cf5..442982d 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -4209,6 +4209,8 @@ static int hba_setup_cid_tbls(struct beiscsi_hba *phba)
 		kfree(phba->ep_array);
 		phba->ep_array = NULL;
 		ret = -ENOMEM;
+
+		goto free_memory;
 	}
 
 	for (i = 0; i < phba->params.cxns_per_ctrl; i++) {
-- 
1.8.3.1


