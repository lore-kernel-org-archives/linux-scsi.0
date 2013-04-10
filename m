From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] target: Fix incorrect fallthrough of ALUA Standby/Offline/Transition CDBs
Date: Wed, 10 Apr 2013 21:59:25 +0000
Message-ID: <1365631165-15237-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a bug where a handful of informational / control CDBs
that should be allowed during ALUA access state Standby/Offline/Transition
where incorrectly returning CHECK_CONDITION + ASCQ_04H_ALUA_TG_PT_*.

This includes INQUIRY + REPORT_LUNS, which would end up preventing LUN
registration when LUN scanning occured during these ALUA access states.

Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_alua.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index ff1c5ee..cbe48ab 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -409,6 +409,7 @@ static inline int core_alua_state_standby(
 	case REPORT_LUNS:
 	case RECEIVE_DIAGNOSTIC:
 	case SEND_DIAGNOSTIC:
+		return 0;
 	case MAINTENANCE_IN:
 		switch (cdb[1] & 0x1f) {
 		case MI_REPORT_TARGET_PGS:
@@ -451,6 +452,7 @@ static inline int core_alua_state_unavailable(
 	switch (cdb[0]) {
 	case INQUIRY:
 	case REPORT_LUNS:
+		return 0;
 	case MAINTENANCE_IN:
 		switch (cdb[1] & 0x1f) {
 		case MI_REPORT_TARGET_PGS:
@@ -491,6 +493,7 @@ static inline int core_alua_state_transition(
 	switch (cdb[0]) {
 	case INQUIRY:
 	case REPORT_LUNS:
+		return 0;
 	case MAINTENANCE_IN:
 		switch (cdb[1] & 0x1f) {
 		case MI_REPORT_TARGET_PGS:
-- 
1.7.2.5
