From: madhu.iyengar@qlogic.com
Subject: [PATCH 05/18] qla2xxx: Include request queue ID in the upper 16-bits of the I/O handle for Abort I/O IOCBs.
Date: Wed, 30 Mar 2011 11:46:20 -0700
Message-ID: <1301510793-2492-6-git-send-email-madhu.iyengar@qlogic.com>
References: <1301510793-2492-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:45792 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755619Ab1C3SvO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Mar 2011 14:51:14 -0400
In-Reply-To: <1301510793-2492-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Mike Hernandez <michael.hernandez@qlogic.com>

From: Mike Hernandez <michael.hernandez@qlogic.com>

The upper 16-bits of the handle for all I/O in multi-queue supported
drivers carries the ID of the request queue it was submitted on. When
using Abort I/O IOCB, the driver needs to also populate the upper
16-bits in the handle_to_abort field so the fw can correlate with the
actual I/O.

Signed-off-by: Mike Hernandez <michael.hernandez@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 7a7c0ec..fae75ca 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2362,7 +2362,7 @@ qla24xx_abort_command(srb_t *sp)
 	abt->entry_count = 1;
 	abt->handle = MAKE_HANDLE(req->id, abt->handle);
 	abt->nport_handle = cpu_to_le16(fcport->loop_id);
-	abt->handle_to_abort = handle;
+	abt->handle_to_abort = MAKE_HANDLE(req->id, handle);
 	abt->port_id[0] = fcport->d_id.b.al_pa;
 	abt->port_id[1] = fcport->d_id.b.area;
 	abt->port_id[2] = fcport->d_id.b.domain;
-- 
1.6.0.2

