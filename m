From: Coly Li <bosong.ly@taobao.com>
Subject: [PATCH 4/4] scsi_lib.c: use BUG_ON correctly, v4
Date: Sun, 27 Mar 2011 01:26:55 +0800
Message-ID: <1301160415-24569-5-git-send-email-bosong.ly@taobao.com>
References: <1301160415-24569-1-git-send-email-bosong.ly@taobao.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1301160415-24569-1-git-send-email-bosong.ly@taobao.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Coly Li <bosong.ly@taobao.com>, James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch makes BUG_ON() usage correct in drivers/scsi/scsi_lib.c

Cc: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Coly Li <bosong.ly@taobao.com>
---
 drivers/scsi/scsi_lib.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_lib.c
+++ linux-2.6/drivers/scsi/scsi_lib.c
@@ -1033,8 +1033,8 @@ int scsi_init_io(struct scsi_cmnd *cmd,
 
 		count = blk_rq_map_integrity_sg(rq->q, rq->bio,
 						prot_sdb->table.sgl);
-		BUG_ON(unlikely(count > ivecs));
-		BUG_ON(unlikely(count > queue_max_integrity_segments(rq->q)));
+		BUG_ON(count > ivecs);
+		BUG_ON(count > queue_max_integrity_segments(rq->q));
 
 		cmd->prot_sdb = prot_sdb;
 		cmd->prot_sdb->table.nents = count;
