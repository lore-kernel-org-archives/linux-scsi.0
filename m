From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 4/6] target: tcm_loop: Delete two unnecessary variable
 initialisations in tcm_loop_issue_tmr()
Date: Mon, 11 Dec 2017 11:45:22 +0100
Message-ID: <ccfd3979-8405-7c78-7b67-20f5f54b1f24@users.sourceforge.net>
References: <42f13f0c-ae1d-ec1e-fd9d-62dd15aeba8c@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <42f13f0c-ae1d-ec1e-fd9d-62dd15aeba8c@users.sourceforge.net>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 11 Dec 2017 10:56:42 +0100

The variables "se_cmd" and "tl_cmd" will eventually be set to appropriate
pointers a bit later.
Thus omit the explicit initialisation at the beginning.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/target/loopback/tcm_loop.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index d91109c1c4ae..08dbf5b4ff15 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -203,10 +203,10 @@ static int tcm_loop_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
 static int tcm_loop_issue_tmr(struct tcm_loop_tpg *tl_tpg,
 			      u64 lun, int task, enum tcm_tmreq_table tmr)
 {
-	struct se_cmd *se_cmd = NULL;
+	struct se_cmd *se_cmd;
 	struct se_session *se_sess;
 	struct tcm_loop_nexus *tl_nexus;
-	struct tcm_loop_cmd *tl_cmd = NULL;
+	struct tcm_loop_cmd *tl_cmd;
 	int ret = TMR_FUNCTION_FAILED, rc;
 
 	/*
-- 
2.15.1
