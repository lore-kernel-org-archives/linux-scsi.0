From: Eric Northup <digitaleric@google.com>
Subject: [PATCH] virtio_scsi: fix memory leak on full queue condition.
Date: Thu,  8 Nov 2012 01:55:50 -0800
Message-ID: <1352368550-6694-1-git-send-email-digitaleric@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, Eric Northup <digitaleric@google.com>
List-Id: linux-scsi@vger.kernel.org

virtscsi_queuecommand was leaking memory when the virtio queue was full.

Tested: Guest operates correctly even with very small queue sizes, validated
we're not leaking kmalloc-192 sized allocations anymore.

Signed-off-by: Eric Northup <digitaleric@google.com>
---
 drivers/scsi/virtio_scsi.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 595af1a..dd8dc27 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -469,6 +469,8 @@ static int virtscsi_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
 			      sizeof cmd->req.cmd, sizeof cmd->resp.cmd,
 			      GFP_ATOMIC) >= 0)
 		ret = 0;
+	else
+		mempool_free(cmd, virtscsi_cmd_pool);
 
 out:
 	return ret;
-- 
1.7.7.3
