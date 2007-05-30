From: michaelc@cs.wisc.edu
Subject: [PATCH 16/19] qla4xxx: add iscsi_transport capps for fw capacilities
Date: Wed, 30 May 2007 12:57:22 -0500
Message-ID: <11805478623287-git-send-email-michaelc@cs.wisc.edu>
References: <11805478452886-git-send-email-michaelc@cs.wisc.edu> <11805478461587-git-send-email-michaelc@cs.wisc.edu> <11805478472375-git-send-email-michaelc@cs.wisc.edu> <11805478483268-git-send-email-michaelc@cs.wisc.edu> <1180547849438-git-send-email-michaelc@cs.wisc.edu> <11805478511328-git-send-email-michaelc@cs.wisc.edu> <11805478523188-git-send-email-michaelc@cs.wisc.edu> <11805478531743-git-send-email-michaelc@cs.wisc.edu> <11805478543860-git-send-email-michaelc@cs.wisc.edu> <11805478564182-git-send-email-michaelc@cs.wisc.edu> <1180547857548-git-send-email-michaelc@cs.wisc.edu> <118054785852-git-send-email-michaelc@cs.wisc.edu> <11805478592848-git-send-email-michaelc@cs.wisc.edu> <11805478601019-git-send-email-michaelc@cs.wisc.edu> <11805478611832-git-send-email-michaelc@cs.wisc.edu> <11805478623536-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754542AbXE3R5t (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 May 2007 13:57:49 -0400
In-Reply-To: <11805478623536-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Userspace will want to know what the driver/FW/HW capabilites
when it comes to some operations like if the hardware can
do discovery or if it can store iscsi info like what target
was used for boot. This patch adds some new caps so userspace
can tell if the driver supports hardware/fw based sendtargets
discovery and if the hardware has some flash which may be
holding or can contain some iscsi target info.
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/qla4xxx/ql4_os.c |    1 +
 include/scsi/iscsi_if.h       |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 7502bb4..315ab69 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -102,6 +102,7 @@ static struct scsi_host_template qla4xxx
 static struct iscsi_transport qla4xxx_iscsi_transport = {
 	.owner			= THIS_MODULE,
 	.name			= DRIVER_NAME,
+	.caps			= CAP_FW_DB | CAP_SENDTARGETS_OFFLOAD,
 	.param_mask		= ISCSI_CONN_PORT | ISCSI_CONN_ADDRESS |
 				  ISCSI_TARGET_NAME | ISCSI_TPGT,
 	.host_param_mask	= ISCSI_HOST_HWADDRESS |
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index a046a32..81a5425 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -299,6 +299,8 @@ #define CAP_DATADGST		0x20
 #define CAP_MULTI_CONN		0x40
 #define CAP_TEXT_NEGO		0x80
 #define CAP_MARKERS		0x100
+#define CAP_FW_DB		0x200
+#define CAP_SENDTARGETS_OFFLOAD	0x400
 
 /*
  * These flags describes reason of stop_conn() call
-- 
1.4.1.1

