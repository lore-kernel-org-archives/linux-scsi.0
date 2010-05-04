From: giridhar.malavali@qlogic.com
Subject: [PATCH 02/16] qla2xxx: Display proper link state for disconnected ports.
Date: Tue,  4 May 2010 15:01:22 -0700
Message-ID: <1273010496-43045-3-git-send-email-giridhar.malavali@qlogic.com>
References: <1273010496-43045-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:47139 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1754465Ab0EDWBi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 May 2010 18:01:38 -0400
In-Reply-To: <1273010496-43045-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

With qla2xxx using mid-layer async-scsi-scanning, the link state for
disconnected port is displayed wrong. Additional check for cable presence
is considered to display proper link state.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index d416c35..5c98b09 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -987,7 +987,8 @@ qla2x00_link_state_show(struct device *dev, struct device_attribute *attr,
 	int len = 0;
 
 	if (atomic_read(&vha->loop_state) == LOOP_DOWN ||
-	    atomic_read(&vha->loop_state) == LOOP_DEAD)
+	    atomic_read(&vha->loop_state) == LOOP_DEAD ||
+	    vha->device_flags & DFLG_NO_CABLE)
 		len = snprintf(buf, PAGE_SIZE, "Link Down\n");
 	else if (atomic_read(&vha->loop_state) != LOOP_READY ||
 	    test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags) ||
-- 
1.6.2.rc1.30.gd43c

