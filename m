From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/2] target: Fix MAINTENANCE_IN service action CDB checks to use lower 5 bits
Date: Thu, 17 May 2012 05:49:04 +0000
Message-ID: <1337233745-8145-2-git-send-email-nab@linux-iscsi.org>
References: <1337233745-8145-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:53979 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874Ab2EQFuQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 May 2012 01:50:16 -0400
In-Reply-To: <1337233745-8145-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Hannes Reinecke <hare@suse.de>, Rob Evers <revers@redhat.com>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@purestorage.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes the MAINTENANCE_IN service action type checks to only
look at the proper lower 5 bits of cdb byte 1.  This addresses the case
where MI_REPORT_TARGET_PGS w/ extended header using the upper three bits of
cdb byte 1 was not processed correctly in transport_generic_cmd_sequencer,
as well as the three cases for standby, unavailable, and transition ALUA
primary access state checks.

Also add MAINTENANCE_IN to the excluded list in transport_generic_prepare_cdb()
to prevent the PARAMETER DATA FORMAT bits from being cleared.

Cc: Hannes Reinecke <hare@suse.de>
Cc: Rob Evers <revers@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_alua.c      |    6 +++---
 drivers/target/target_core_transport.c |    3 ++-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index c39ae7c..be7251e 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -387,7 +387,7 @@ static inline int core_alua_state_standby(
 	case RECEIVE_DIAGNOSTIC:
 	case SEND_DIAGNOSTIC:
 	case MAINTENANCE_IN:
-		switch (cdb[1]) {
+		switch (cdb[1] & 0x1f) {
 		case MI_REPORT_TARGET_PGS:
 			return 0;
 		default:
@@ -429,7 +429,7 @@ static inline int core_alua_state_unavailable(
 	case INQUIRY:
 	case REPORT_LUNS:
 	case MAINTENANCE_IN:
-		switch (cdb[1]) {
+		switch (cdb[1] & 0x1f) {
 		case MI_REPORT_TARGET_PGS:
 			return 0;
 		default:
@@ -469,7 +469,7 @@ static inline int core_alua_state_transition(
 	case INQUIRY:
 	case REPORT_LUNS:
 	case MAINTENANCE_IN:
-		switch (cdb[1]) {
+		switch (cdb[1] & 0x1f) {
 		case MI_REPORT_TARGET_PGS:
 			return 0;
 		default:
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 2d75c29..0590dc6 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1329,6 +1329,7 @@ static inline void transport_generic_prepare_cdb(
 	case VERIFY_16: /* SBC - VRProtect */
 	case WRITE_VERIFY: /* SBC - VRProtect */
 	case WRITE_VERIFY_12: /* SBC - VRProtect */
+	case MAINTENANCE_IN: /* SPC - Parameter Data Format for SA RTPG */
 		break;
 	default:
 		cdb[1] &= 0x1f; /* clear logical unit number */
@@ -2597,7 +2598,7 @@ static int transport_generic_cmd_sequencer(
 			/*
 			 * Check for emulated MI_REPORT_TARGET_PGS.
 			 */
-			if (cdb[1] == MI_REPORT_TARGET_PGS &&
+			if ((cdb[1] & 0x1f) == MI_REPORT_TARGET_PGS &&
 			    su_dev->t10_alua.alua_type == SPC3_ALUA_EMULATED) {
 				cmd->execute_cmd =
 					target_emulate_report_target_port_groups;
-- 
1.7.2.5

