From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 3/5] target: Improve size determinations in two functions
Date: Sun, 9 Apr 2017 21:50:12 +0200
Message-ID: <166debca-20eb-9540-5fd3-e984cc1f8098@users.sourceforge.net>
References: <337dfdee-8a9f-9bb3-639a-ea47758966f1@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <337dfdee-8a9f-9bb3-639a-ea47758966f1@users.sourceforge.net>
Content-Language: en-GB
Sender: target-devel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 9 Apr 2017 20:15:12 +0200

Replace the specification of two data structures by pointer dereferences
as the parameter for the operator "sizeof" to make the corresponding size
determinations a bit safer according to the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/target/target_core_rd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 838dc128d494..20253d04103f 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -47,7 +47,7 @@ static int rd_attach_hba(struct se_hba *hba, u32 host_id)
 {
 	struct rd_host *rd_host;
 
-	rd_host = kzalloc(sizeof(struct rd_host), GFP_KERNEL);
+	rd_host = kzalloc(sizeof(*rd_host), GFP_KERNEL);
 	if (!rd_host)
 		return -ENOMEM;
 
@@ -285,7 +285,7 @@ static struct se_device *rd_alloc_device(struct se_hba *hba, const char *name)
 	struct rd_dev *rd_dev;
 	struct rd_host *rd_host = hba->hba_ptr;
 
-	rd_dev = kzalloc(sizeof(struct rd_dev), GFP_KERNEL);
+	rd_dev = kzalloc(sizeof(*rd_dev), GFP_KERNEL);
 	if (!rd_dev)
 		return NULL;
 
-- 
2.12.2
