From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH 4/4] mpt2sas: annotate ioc->reply_post_host_index as __iomem
Date: Mon, 2 Jun 2014 10:38:32 -0400
Message-ID: <1401719912-18532-1-git-send-email-joe.lawrence@stratus.com>
References: <1401719672-18352-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p02c11o149.mxlogic.net ([208.65.144.82]:36698 "EHLO
	p02c11o149.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472AbaFBOin (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 10:38:43 -0400
In-Reply-To: <1401719672-18352-1-git-send-email-joe.lawrence@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, Joe Lawrence <joe.lawrence@stratus.com>

The MPT2SAS_ADAPTER reply_post_host_index[] holds calculated addresses
in memory mapped register space.  Add an "__iomem" annotation to silence
the following sparse warnings:

  drivers/scsi/mpt2sas/mpt2sas_base.c:1006:43:
    warning: incorrect type in argument 2 (different address spaces)
       expected void volatile [noderef] <asn:2>*addr
       got unsigned long long [usertype] *<noident>

  drivers/scsi/mpt2sas/mpt2sas_base.c:4299:22:
    warning: cast removes address space of expression
  drivers/scsi/mpt2sas/mpt2sas_base.c:4303:27:
    warning: cast removes address space of expression

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c |    9 +++++----
 drivers/scsi/mpt2sas/mpt2sas_base.h |    2 +-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index bde63f7..a6e477e 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -4295,12 +4295,13 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
 		goto out_free_resources;
 
 	if (ioc->is_warpdrive) {
-		ioc->reply_post_host_index[0] =
-		    (resource_size_t *)&ioc->chip->ReplyPostHostIndex;
+		ioc->reply_post_host_index[0] = (resource_size_t __iomem *)
+		    &ioc->chip->ReplyPostHostIndex;
 
 		for (i = 1; i < ioc->cpu_msix_table_sz; i++)
-			ioc->reply_post_host_index[i] = (resource_size_t *)
-			((u8 *)&ioc->chip->Doorbell + (0x4000 + ((i - 1)
+			ioc->reply_post_host_index[i] =
+			(resource_size_t __iomem *)
+			((u8 __iomem *)&ioc->chip->Doorbell + (0x4000 + ((i - 1)
 			* 4)));
 	}
 
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 1f2ac3a..23d0c85 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -837,7 +837,7 @@ struct MPT2SAS_ADAPTER {
 	u8		msix_enable;
 	u16		msix_vector_count;
 	u8		*cpu_msix_table;
-	resource_size_t	**reply_post_host_index;
+	resource_size_t	__iomem **reply_post_host_index;
 	u16		cpu_msix_table_sz;
 	u32		ioc_reset_count;
 	MPT2SAS_FLUSH_RUNNING_CMDS schedule_dead_ioc_flush_running_cmds;
-- 
1.7.10.4

