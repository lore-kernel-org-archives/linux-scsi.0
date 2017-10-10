From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v3] scsi: fc: check for rport presence in fc_block_scsi_eh
Date: Tue, 10 Oct 2017 17:31:38 +0200
Message-ID: <20171010153138.21542-1-jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

Coverity-scan recently found a possible NULL pointer dereference in
fc_block_scsi_eh() as starget_to_rport() either returns the rport for
the startget or NULL.

While it is rather unlikely to have fc_block_scsi_eh() called without
an rport associated it's a good idea to catch potential misuses of the
API gracefully.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
Martin, I'm not sure if I have already sent it out or not if I already did
send this v3 please ignore it.

Changes since v2:
- return FAST_IO_FAIL instead of 0 (Steffen)

Changes since v1:
- s/WARN_ON/WARN_ON_ONCE/ (Bart)
---
 drivers/scsi/scsi_transport_fc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index ba9d70f8a6a1..18f56a124b6c 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3328,6 +3328,9 @@ int fc_block_scsi_eh(struct scsi_cmnd *cmnd)
 {
 	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
 
+	if (WARN_ON_ONCE(!rport))
+		return FAST_IO_FAIL;
+
 	return fc_block_rport(rport);
 }
 EXPORT_SYMBOL(fc_block_scsi_eh);
-- 
2.13.5
