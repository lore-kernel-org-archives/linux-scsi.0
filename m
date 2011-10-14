From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 23/37] target: Make pscsi_create_virtdevice use ERR_CAST
Date: Fri, 14 Oct 2011 00:41:55 +0000
Message-ID: <1318552929-13341-24-git-send-email-nab@linux-iscsi.org>
References: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Dan Carpenter <dan.carpenter@oracle.com>
List-Id: linux-scsi@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

This patch changes pscsi_create_virtdevice() to properly return ERR_CAST
instead of a raw pointer upon scsi_host_lookup() failure.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_pscsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index b6d6093..3898fb7 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -566,7 +566,7 @@ static struct se_device *pscsi_create_virtdevice(
 			if (IS_ERR(sh)) {
 				pr_err("pSCSI: Unable to locate"
 					" pdv_host_id: %d\n", pdv->pdv_host_id);
-				return (struct se_device *) sh;
+				return ERR_CAST(sh);
 			}
 		}
 	} else {
-- 
1.5.6.5
