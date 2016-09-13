From: Daniel Wagner <wagi@monom.org>
Subject: [PATCH 3/3] virtio_scsi: use complete() instead complete_all()
Date: Tue, 13 Sep 2016 10:58:50 +0200
Message-ID: <1473757130-14751-4-git-send-email-wagi@monom.org>
References: <1473757130-14751-1-git-send-email-wagi@monom.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1473757130-14751-1-git-send-email-wagi@monom.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-kernel@vger.kernel.org, Daniel Wagner <daniel.wagner@bmw-carit.de>
List-Id: linux-scsi@vger.kernel.org

From: Daniel Wagner <daniel.wagner@bmw-carit.de>

There is only one waiter for the completion, therefore there is no need
to use complete_all(). Let's make that clear by using complete() instead
of complete_all().

The usage pattern of the completion is:

waiter context                          waker context

virtscsi_tmf()
  DECLARE_COMPLETION_ONSTACK()
  virtscsi_kick_cmd()
  wait_for_completion()

                                        virtscsi_complete_free()
                                          complete()

Signed-off-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
---
 drivers/scsi/virtio_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 7dbbb29..86924ff 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -258,7 +258,7 @@ static void virtscsi_complete_free(struct virtio_scsi *vscsi, void *buf)
 	struct virtio_scsi_cmd *cmd = buf;
 
 	if (cmd->comp)
-		complete_all(cmd->comp);
+		complete(cmd->comp);
 }
 
 static void virtscsi_ctrl_done(struct virtqueue *vq)
-- 
2.7.4
