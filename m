From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.0 31/67] scsi: core: Also call destroy_rcu_head() for passthrough requests
Date: Fri, 29 Mar 2019 20:50:11 -0400
Message-ID: <20190330005047.25998-31-sashal@kernel.org>
References: <20190330005047.25998-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190330005047.25998-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, "Ewan D . Milne" <emilne@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit db983f6eef57a9d78af79bc32389b7e60eb3c47d ]

cmd->rcu is initialized by scsi_initialize_rq(). For passthrough
requests, blk_get_request() calls scsi_initialize_rq(). For filesystem
requests, scsi_init_command() calls scsi_initialize_rq(). Make sure
that destroy_rcu_head() is called for passthrough requests.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Ewan D. Milne <emilne@redhat.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Reported-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_lib.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 5a6e8e12701a..655ad26106e4 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -598,9 +598,16 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
 	if (!blk_rq_is_scsi(req)) {
 		WARN_ON_ONCE(!(cmd->flags & SCMD_INITIALIZED));
 		cmd->flags &= ~SCMD_INITIALIZED;
-		destroy_rcu_head(&cmd->rcu);
 	}
 
+	/*
+	 * Calling rcu_barrier() is not necessary here because the
+	 * SCSI error handler guarantees that the function called by
+	 * call_rcu() has been called before scsi_end_request() is
+	 * called.
+	 */
+	destroy_rcu_head(&cmd->rcu);
+
 	/*
 	 * In the MQ case the command gets freed by __blk_mq_end_request,
 	 * so we have to do all cleanup that depends on it earlier.
-- 
2.19.1
