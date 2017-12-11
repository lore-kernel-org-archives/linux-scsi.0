From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 1/6] target: tcm_loop: Delete an error message for a failed
 memory allocation in four functions
Date: Mon, 11 Dec 2017 11:42:12 +0100
Message-ID: <a4645e99-0518-8b1b-2b1a-748087a7ac23@users.sourceforge.net>
References: <42f13f0c-ae1d-ec1e-fd9d-62dd15aeba8c@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:62353 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751956AbdLKKmS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Dec 2017 05:42:18 -0500
In-Reply-To: <42f13f0c-ae1d-ec1e-fd9d-62dd15aeba8c@users.sourceforge.net>
Content-Language: en-GB
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 10 Dec 2017 21:18:15 +0100

Omit an extra message for a memory allocation failure in these functions.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/target/loopback/tcm_loop.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index b6a913e38b30..6bd58a064924 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -184,7 +184,6 @@ static int tcm_loop_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
 
 	tl_cmd = kmem_cache_zalloc(tcm_loop_cmd_cache, GFP_ATOMIC);
 	if (!tl_cmd) {
-		pr_err("Unable to allocate struct tcm_loop_cmd\n");
 		set_host_byte(sc, DID_ERROR);
 		sc->scsi_done(sc);
 		return 0;
@@ -221,10 +220,8 @@ static int tcm_loop_issue_tmr(struct tcm_loop_tpg *tl_tpg,
 	}
 
 	tl_cmd = kmem_cache_zalloc(tcm_loop_cmd_cache, GFP_KERNEL);
-	if (!tl_cmd) {
-		pr_err("Unable to allocate memory for tl_cmd\n");
+	if (!tl_cmd)
 		return ret;
-	}
 
 	init_completion(&tl_cmd->tmr_done);
 
@@ -773,10 +770,8 @@ static int tcm_loop_make_nexus(
 	}
 
 	tl_nexus = kzalloc(sizeof(struct tcm_loop_nexus), GFP_KERNEL);
-	if (!tl_nexus) {
-		pr_err("Unable to allocate struct tcm_loop_nexus\n");
+	if (!tl_nexus)
 		return -ENOMEM;
-	}
 
 	tl_nexus->se_sess = target_alloc_session(&tl_tpg->tl_se_tpg, 0, 0,
 					TARGET_PROT_DIN_PASS | TARGET_PROT_DOUT_PASS,
@@ -1082,10 +1077,9 @@ static struct se_wwn *tcm_loop_make_scsi_hba(
 	int ret, off = 0;
 
 	tl_hba = kzalloc(sizeof(struct tcm_loop_hba), GFP_KERNEL);
-	if (!tl_hba) {
-		pr_err("Unable to allocate struct tcm_loop_hba\n");
+	if (!tl_hba)
 		return ERR_PTR(-ENOMEM);
-	}
+
 	/*
 	 * Determine the emulated Protocol Identifier and Target Port Name
 	 * based on the incoming configfs directory name.
-- 
2.15.1
