From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 22/97] Revert "scsi: qla2xxx: Fix NVMe Target discovery"
Date: Wed, 26 Dec 2018 17:34:42 -0500
Message-ID: <20181226223557.149329-22-sashal@kernel.org>
References: <20181226223557.149329-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181226223557.149329-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Himanshu Madhani <hmadhani@marvell.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Himanshu Madhani <hmadhani@marvell.com>

[ Upstream commit c64a87f9518409d0a439895f09f6149ffdd427b8 ]

This reverts commit db186382af21e926e90df19499475f2552192b77.

This commit introduced regression with FCP discovery so revert it to fix
discovery for FCP luns.

Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index ae9fd2d01004..42b8f0d3e580 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4808,10 +4808,10 @@ void qla24xx_create_new_sess(struct scsi_qla_host *vha, struct qla_work_evt *e)
 			fcport->d_id = e->u.new_sess.id;
 			fcport->flags |= FCF_FABRIC_DEVICE;
 			fcport->fw_login_state = DSC_LS_PLOGI_PEND;
-			if (e->u.new_sess.fc4_type & FS_FC4TYPE_FCP)
+			if (e->u.new_sess.fc4_type == FS_FC4TYPE_FCP)
 				fcport->fc4_type = FC4_TYPE_FCP_SCSI;
 
-			if (e->u.new_sess.fc4_type & FS_FC4TYPE_NVME) {
+			if (e->u.new_sess.fc4_type == FS_FC4TYPE_NVME) {
 				fcport->fc4_type = FC4_TYPE_OTHER;
 				fcport->fc4f_nvme = FC4_TYPE_NVME;
 			}
-- 
2.19.1
