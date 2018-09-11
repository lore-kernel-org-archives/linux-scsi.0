From: Laura Abbott <labbott@redhat.com>
Subject: [PATCH] scsi: ibmvscsis: Ensure partition name is properly NUL terminated
Date: Tue, 11 Sep 2018 11:15:34 -0700
Message-ID: <20180911181534.18553-1-labbott@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>, Michael Cyr <mikecyr@linux.vnet.ibm.com>, Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@redhat.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

While reviewing another part of the code, Kees noticed that the
strncpy of the partition name might not always be NUL terminated. Switch
to using strlcpy which does this safely.

Reported-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Laura Abbott <labbott@redhat.com>
---
I realized looking at this that I probably should have made
this and my previous patch a series given this has context depending on
the other patch. I can resend if the scsi maintainers want.
---
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index 9305440a00a1..1217bf2a28db 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -3477,7 +3477,7 @@ static int ibmvscsis_probe(struct vio_dev *vdev,
 	snprintf(vscsi->eye, sizeof(vscsi->eye), "VSCSI%s", vdev->name);
 
 	vscsi->dds.unit_id = vdev->unit_address;
-	strncpy(vscsi->dds.partition_name, partition_name,
+	strlcpy(vscsi->dds.partition_name, partition_name,
 		sizeof(vscsi->dds.partition_name));
 	vscsi->dds.partition_num = partition_number;
 
-- 
2.17.1
