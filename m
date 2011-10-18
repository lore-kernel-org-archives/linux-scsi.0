From: michaelc@cs.wisc.edu
Subject: [PATCH 1/1] qla4xxx: export address/port of connection (fix udev disk names)
Date: Mon, 17 Oct 2011 22:42:13 -0500
Message-ID: <1318909333-25262-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757289Ab1JRDgr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Oct 2011 23:36:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Udev uses the connection's persistent address/port in the
/dev/disk/by-path name. qla4xxx is not exporting this value
so its iscsi disk names have been lacking the iscsi info.
In the old driver we did not have this information but
we do now and can fix this by just setting the flags to tell
libiscsi/scsi_transport_iscsi to export this info in sysfs.

This patch was made over scsi-misc and this patchset
http://www.spinics.net/lists/linux-scsi/msg54863.html
.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/qla4xxx/ql4_os.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index ba6a8f3..30f31b1 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -203,6 +203,8 @@ static mode_t ql4_attr_is_visible(int param_type, int param)
 		}
 	case ISCSI_PARAM:
 		switch (param) {
+		case ISCSI_PARAM_PERSISTENT_ADDRESS:
+		case ISCSI_PARAM_PERSISTENT_PORT:
 		case ISCSI_PARAM_CONN_ADDRESS:
 		case ISCSI_PARAM_CONN_PORT:
 		case ISCSI_PARAM_TARGET_NAME:
-- 
1.7.6

