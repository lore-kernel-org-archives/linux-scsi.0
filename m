From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: libcxgbi: remove uninitialized variable len
Date: Sat, 16 Mar 2019 22:57:09 +0000
Message-ID: <20190316225709.8630-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, David Ahern <dsahern@gmail.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable len is not being inintialized and the uninitialized
value is being returned. However, this return path is never reached
because the default case in the switch statement returns -ENOSYS.
Clean up the code by replacing the return -ENOSYS with a break
for the default case and returning -ENOSYS at the end of the
function.  This allows len to be removed.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/cxgbi/libcxgbi.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index 006372b3fba2..1d9115484503 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -2310,7 +2310,6 @@ int cxgbi_get_ep_param(struct iscsi_endpoint *ep, enum iscsi_param param,
 {
 	struct cxgbi_endpoint *cep = ep->dd_data;
 	struct cxgbi_sock *csk;
-	int len;
 
 	log_debug(1 << CXGBI_DBG_ISCSI,
 		"cls_conn 0x%p, param %d.\n", ep, param);
@@ -2328,9 +2327,9 @@ int cxgbi_get_ep_param(struct iscsi_endpoint *ep, enum iscsi_param param,
 		return iscsi_conn_get_addr_param((struct sockaddr_storage *)
 						 &csk->daddr, param, buf);
 	default:
-		return -ENOSYS;
+		break;
 	}
-	return len;
+	return -ENOSYS;
 }
 EXPORT_SYMBOL_GPL(cxgbi_get_ep_param);
 
-- 
2.20.1
