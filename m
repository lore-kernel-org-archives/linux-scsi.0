From: Joe Eykholt <jeykholt@cisco.com>
Subject: [PATCH] tgt: fix warning
Date: Thu, 05 Aug 2010 17:50:37 -0700
Message-ID: <20100806005037.12928.5358.stgit@savbu-bu.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-4.cisco.com ([171.68.10.86]:45274 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603Ab0HFAuh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2010 20:50:37 -0400
Received: from savbu-bu.cisco.com (savbu-bu.cisco.com [10.193.164.54])
	by sj-core-2.cisco.com (8.13.8/8.14.3) with ESMTP id o760ob4N006215
	for <linux-scsi@vger.kernel.org>; Fri, 6 Aug 2010 00:50:37 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Using scsi_tgt_lib in a new target module, we were getting
the following warning and a stack traceback on every I/O completion:

WARNING: at block/blk-core.c:1108

Which is claiming we may be leaking a bio.
We don't leak bios (blk_rq_unmap_user should free them).

Set rq->bio to NULL before calling scsi_host_put_command().
This was as advised by Fujita Tomonori.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/scsi_tgt_lib.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index 66241dd..c399be9 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -185,6 +185,7 @@ static void scsi_tgt_cmd_destroy(struct work_struct *work)
 	dprintk("cmd %p %d %u\n", cmd, cmd->sc_data_direction,
 		rq_data_dir(cmd->request));
 	scsi_unmap_user_pages(tcmd);
+	tcmd->rq->bio = NULL;
 	scsi_host_put_command(scsi_tgt_cmd_to_host(cmd), cmd);
 }
 


