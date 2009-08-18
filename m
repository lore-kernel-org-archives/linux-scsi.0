From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 3/4] [LIO-Target]: Add ALUA Active/NonOptimized state check
Date: Tue, 18 Aug 2009 16:15:55 -0700
Message-ID: <1250637355.27590.68.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp102.sbc.mail.gq1.yahoo.com ([67.195.15.61]:33956 "HELO
	smtp102.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751070AbZHRXWg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Aug 2009 19:22:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, "H. Peter Anvin" <hpa@zytor.com>, Alasdair G Kergon <agk@redhat.com>, Joel Becker <joel.becker@oracle.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Florian Haas <florian.haas@linbit.com>, Philipp Reisner <philipp.reisner@linbit.com>

Greetings,

This patch adds a call to target_core_mod symbol core_alua_check_nonop_delay()
in iscsi_handle_scsi_cmd(), which can optionally call msleep_interruptible() for
ALUA target port group members currently in the Active/NonOptimized primary access
state to allow schedule() to be run for real time iSCSI traffic shaping using
SPC-4 ALUA primitives.

The millisecond sleep interval is changed on a per ALUA target port group basis
in target_core_mod configfs at /sys/kernel/config/target/core/$HBA/$DEV/alua/$TG_PT_GP_NAME/nonop_delay_msecs
which will update the timeout for all members of the ALUA target port group using
generic target_core_mod infrastructure.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/iscsi_target.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/lio-core/iscsi_target.c b/drivers/lio-core/iscsi_target.c
index 3b1e3b7..5d00473 100644
--- a/drivers/lio-core/iscsi_target.c
+++ b/drivers/lio-core/iscsi_target.c
@@ -57,6 +57,7 @@
 #include <iscsi_debug_opcodes.h>
 #include <iscsi_target_core.h>
 #include <target/target_core_base.h>
+#include <target/target_core_alua.h>
 #include <iscsi_target_error.h>
 #include <iscsi_target_datain_values.h>
 #include <iscsi_target_discovery.h>
@@ -1571,7 +1572,11 @@ build_list:
 
 attach_cmd:
 	iscsi_attach_cmd_to_queue(conn, cmd);
-
+	/*
+	 * Check if we need to delay processing because of ALUA
+	 * Active/NonOptimized primary access state..
+	 */
+	core_alua_check_nonop_delay(SE_CMD(cmd));
 	/*
 	 * Check the CmdSN against ExpCmdSN/MaxCmdSN here if
 	 * the Immediate Bit is not set, and no Immediate
-- 
1.5.4.1



