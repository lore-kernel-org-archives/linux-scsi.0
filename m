From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 09/10] qla2xxx: Correct regression in relogin code.
Date: Thu, 24 Apr 2008 15:21:30 -0700
Message-ID: <1209075691-6539-9-git-send-email-andrew.vasquez@qlogic.com>
References: <20080424221945.GC4359@n8027av35btxc1.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:20337 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541AbYDXWVj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Apr 2008 18:21:39 -0400
In-Reply-To: <20080424221945.GC4359@n8027av35btxc1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Commit 63a8651f2548c6bb5132c0b4e7dad4f57a9274db ([SCSI] qla2xxx:
Correct infinite-login-retry issue.) introduced a small
regression where a successful relogin would result in an fcport's
loop_id to be incorrectly reset to FC_NO_LOOP_ID.  Only clear-out
loopid, if retries have been 'truly' exhausted.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 878a37a..3223fd1 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2373,7 +2373,7 @@ qla2x00_do_dpc(void *data)
 					} else {
 						fcport->login_retry = 0;
 					}
-					if (fcport->login_retry == 0)
+					if (fcport->login_retry == 0 && status != QLA_SUCCESS)
 						fcport->loop_id = FC_NO_LOOP_ID;
 				}
 				if (test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags))
-- 
1.5.5.1.67.gbdb8

