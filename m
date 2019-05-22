From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 036/244] scsi: qla2xxx: Fix abort handling in tcm_qla2xxx_write_pending()
Date: Wed, 22 May 2019 15:23:02 -0400
Message-ID: <20190522192630.24917-36-sashal@kernel.org>
References: <20190522192630.24917-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190522192630.24917-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>, Himanshu Madhani <hmadhani@marvell.com>, Giridhar Malavali <gmalavali@marvell.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit e209783d66bca04b5fce4429e59338517ffc1a0b ]

Implementations of the .write_pending() callback functions must guarantee
that an appropriate LIO core callback function will be called immediately or
at a later time.  Make sure that this guarantee is met for aborted SCSI
commands.

[mkp: typo]

Cc: Himanshu Madhani <hmadhani@marvell.com>
Cc: Giridhar Malavali <gmalavali@marvell.com>
Fixes: 694833ee00c4 ("scsi: tcm_qla2xxx: Do not allow aborted cmd to advance.") # v4.13.
Fixes: a07100e00ac4 ("qla2xxx: Fix TMR ABORT interaction issue between qla2xxx and TCM") # v4.5.
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 64e2d859f6332..7ef549903124d 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -390,6 +390,8 @@ static int tcm_qla2xxx_write_pending(struct se_cmd *se_cmd)
 			cmd->se_cmd.transport_state,
 			cmd->se_cmd.t_state,
 			cmd->se_cmd.se_cmd_flags);
+		transport_generic_request_failure(&cmd->se_cmd,
+			TCM_CHECK_CONDITION_ABORT_CMD);
 		return 0;
 	}
 	cmd->trc_flags |= TRC_XFR_RDY;
-- 
2.20.1
