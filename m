From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 3.18 01/16] scsi: libiscsi: Fix NULL pointer dereference in iscsi_eh_session_reset
Date: Wed, 12 Dec 2018 23:33:28 -0500
Message-ID: <20181213043343.76896-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Fred Herard <fred.herard@oracle.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Sasha Levin <sashal@kernel.org>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Fred Herard <fred.herard@oracle.com>

[ Upstream commit 5db6dd14b31397e8cccaaddab2ff44ebec1acf25 ]

This commit addresses NULL pointer dereference in iscsi_eh_session_reset.
Reference should not be made to session->leadconn when session->state is
set to ISCSI_STATE_TERMINATE.

Signed-off-by: Fred Herard <fred.herard@oracle.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libiscsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 857bf9417817..56441a5ec3d7 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2433,8 +2433,8 @@ int iscsi_eh_session_reset(struct scsi_cmnd *sc)
 failed:
 		ISCSI_DBG_EH(session,
 			     "failing session reset: Could not log back into "
-			     "%s, %s [age %d]\n", session->targetname,
-			     conn->persistent_address, session->age);
+			     "%s [age %d]\n", session->targetname,
+			     session->age);
 		spin_unlock_bh(&session->frwd_lock);
 		mutex_unlock(&session->eh_mutex);
 		return FAILED;
-- 
2.19.1
