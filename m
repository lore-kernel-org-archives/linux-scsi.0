From: Josh Hunt <johunt@akamai.com>
Subject: [PATCH 1/2] scsi: propery initialize atomic_t ioerr_cnt
Date: Sat,  9 Jun 2012 07:03:38 -0700
Message-ID: <1339250619-1561-1-git-send-email-johunt@akamai.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Josh Hunt <johunt@akamai.com>
List-Id: linux-scsi@vger.kernel.org

Initialize atomic_t ioerr_cnt as per the guidelines defined in Documentation/atomic_ops.txt

Reported-by: Debabrata Banerjee <dbanerje@akamai.com>
Signed-off-by: Josh Hunt <johunt@akamai.com>
---
 drivers/scsi/sd.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 6f0a4c6..8b85703 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2702,6 +2702,7 @@ static int sd_probe(struct device *dev)
 	sdkp->disk = gd;
 	sdkp->index = index;
 	atomic_set(&sdkp->openers, 0);
+	atomic_set(&sdkp->device->ioerr_cnt, 0);
 
 	if (!sdp->request_queue->rq_timeout) {
 		if (sdp->type != TYPE_MOD)
-- 
1.7.0.4
