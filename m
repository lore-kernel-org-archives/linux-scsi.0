From: Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] scsi: qla2xxx: Simplify conditional check
Date: Thu, 20 Sep 2018 17:27:23 -0700
Message-ID: <20180921002723.16600-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: qla2xxx-upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Nathan Chancellor <natechancellor@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Clang generates a warning when it sees a logical not followed by a
conditional operator like ==, >, or < because it thinks that the logical
not should be applied to the whole statement:

drivers/scsi/qla2xxx/qla_nx.c:3702:7: warning: logical not is only
applied to the left hand side of this comparison
[-Wlogical-not-parentheses]
                if (!qla2x00_eh_wait_for_pending_commands(vha, 0, 0,
                    ^
drivers/scsi/qla2xxx/qla_nx.c:3702:7: note: add parentheses after the
'!' to evaluate the comparison first
                if (!qla2x00_eh_wait_for_pending_commands(vha, 0, 0,
                    ^
                     (
drivers/scsi/qla2xxx/qla_nx.c:3702:7: note: add parentheses around left
hand side expression to silence this warning
                if (!qla2x00_eh_wait_for_pending_commands(vha, 0, 0,
                    ^
                    (
1 warning generated.

It assumes the author might have made a mistake in their logic:

if (!a == b) -> if (!(a == b))

Sometimes that is the case; other times, it's just a super convoluted
way of saying 'if (a)' when b = 0:

if (!1 == 0) -> if (0 == 0) -> if (true)

Alternatively:

if (!1 == 0) -> if (!!1) -> if (1)

Simplify this comparison so that Clang doesn't complain.

Link: https://github.com/ClangBuiltLinux/linux/issues/80
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/scsi/qla2xxx/qla_nx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index de2bc78449e7..121e18b3b9f8 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -3699,8 +3699,8 @@ qla82xx_chip_reset_cleanup(scsi_qla_host_t *vha)
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 		/* Wait for pending cmds (physical and virtual) to complete */
-		if (!qla2x00_eh_wait_for_pending_commands(vha, 0, 0,
-		    WAIT_HOST) == QLA_SUCCESS) {
+		if (qla2x00_eh_wait_for_pending_commands(vha, 0, 0,
+		    WAIT_HOST)) {
 			ql_dbg(ql_dbg_init, vha, 0x00b3,
 			    "Done wait for "
 			    "pending commands.\n");
-- 
2.19.0
