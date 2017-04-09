From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 1/3] iscsi-target: Use kcalloc() in iscsit_allocate_iovecs()
Date: Sun, 9 Apr 2017 16:23:41 +0200
Message-ID: <ba9505d9-9c00-9534-c16b-4fab5403a57e@users.sourceforge.net>
References: <f573fbbe-aef2-7b68-1540-ceb2f30a6aa6@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <f573fbbe-aef2-7b68-1540-ceb2f30a6aa6@users.sourceforge.net>
Content-Language: en-GB
Sender: kernel-janitors-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Varun Prakash <varun@chelsio.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 9 Apr 2017 15:06:00 +0200

* A multiplication for the size determination of a memory allocation
  indicated that an array data structure should be processed.
  Thus use the corresponding function "kcalloc".

  This issue was detected by using the Coccinelle software.

* Replace the specification of a data structure by a pointer dereference
  to make the corresponding size determination a bit safer according to
  the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/target/iscsi/iscsi_target.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index a91802432f2f..536b939afe9d 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -985,8 +985,7 @@ static int iscsit_allocate_iovecs(struct iscsi_cmd *cmd)
 	u32 iov_count = max(1UL, DIV_ROUND_UP(cmd->se_cmd.data_length, PAGE_SIZE));
 
 	iov_count += ISCSI_IOV_DATA_BUFFER;
-
-	cmd->iov_data = kzalloc(iov_count * sizeof(struct kvec), GFP_KERNEL);
+	cmd->iov_data = kcalloc(iov_count, sizeof(*cmd->iov_data), GFP_KERNEL);
 	if (!cmd->iov_data) {
 		pr_err("Unable to allocate cmd->iov_data\n");
 		return -ENOMEM;
-- 
2.12.2

