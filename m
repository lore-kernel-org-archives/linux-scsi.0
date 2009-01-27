From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/4] [Target_Core_Mod]: Change RECEIVE_CREDENTIAL ->
	VARIABLE_LENGTH_CMD
Date: Tue, 27 Jan 2009 14:07:27 -0800
Message-ID: <1233094047.6442.103.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:40134 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751846AbZA0WIg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jan 2009 17:08:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>

>From f55bb2d93bc8bd37d18e99b19929c635016df537 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Tue, 27 Jan 2009 13:32:12 -0800
Subject: [PATCH 2/4] [Target_Core_Mod]: Change RECEIVE_CREDENTIAL -> VARIABLE_LENGTH_CMD

This patch changes transport_generic_cmd_sequencer() logic to use VARIABLE_LENGTH_CMD
instead of RECEIVE_CREDENTIAL, which is now defined as a VARIABLE_LENGTH_CMD
service action (VLC_SA_RECEIVE_CREDENTIAL) in linux/include/scsi/scsi.h

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_transport.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/lio-core/target_core_transport.c b/drivers/lio-core/target_core_transport.c
index ad2dd75..a0a7710 100644
--- a/drivers/lio-core/target_core_transport.c
+++ b/drivers/lio-core/target_core_transport.c
@@ -4612,7 +4612,7 @@ static int transport_generic_cmd_sequencer (
 		transport_get_maps(cmd);
 		ret = 2;
 		break;
-	case RECEIVE_CREDENTIAL:
+	case VARIABLE_LENGTH_CMD:
 		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		size = (cdb[10] << 8) | cdb[11];
 		CMD_ORIG_OBJ_API(cmd)->get_mem_buf(cmd->se_orig_obj_ptr, cmd);
-- 
1.5.4.1



