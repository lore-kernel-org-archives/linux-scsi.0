From: Lee Duncan <lduncan@suse.com>
Subject: [PATCH] Allow EA reservation holders to read from device.
Date: Mon, 05 Jan 2015 10:49:44 -0800
Message-ID: <54AADCC8.2010403@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:34296 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489AbbAEStu (ORCPT
	<rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
	Mon, 5 Jan 2015 13:49:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

From: Lee Duncan <lduncan@suse.com>

For PGR reservation type Exclusive Access, allow all
registrants to read from the device.

Signed-off-by: Lee Duncan <lduncan@suse.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_pr.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 85564998500a..cb762b174c08 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -551,6 +551,18 @@ static int core_scsi3_pr_seq_non_holder(

                        return 0;
                }
+       } else if (we && registered_nexus) {
+               /*
+                * Reads are allowed for Write Exclusive locks
+                * from all registrants.
+                */
+               if (cmd->data_direction == DMA_FROM_DEVICE) {
+                       pr_debug("Allowing READ CDB: 0x%02x for %s"
+                               " reservation\n", cdb[0],
+                               core_scsi3_pr_dump_type(pr_reg_type));
+
+                       return 0;
+               }
        }
        pr_debug("%s Conflict for %sregistered nexus %s CDB: 0x%2x"
                " for %s reservation\n", transport_dump_cmd_direction(cmd),
-- 
1.8.5.2

