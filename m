From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 53/83] scsi: qedi: Add ep_state for login completion on un-reachable targets
Date: Tue, 12 Feb 2019 21:36:31 -0500
Message-ID: <20190213023701.20286-53-sashal@kernel.org>
References: <20190213023701.20286-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190213023701.20286-1-sashal@kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Manish Rangankar <mrangankar@marvell.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Manish Rangankar <mrangankar@marvell.com>

[ Upstream commit 34a2ce887668db9dda4b56e6f155c49ac13f3e54 ]

When the driver finds invalid destination MAC for the first un-reachable
target, and before completes the PATH_REQ operation, set new ep_state to
OFFLDCONN_NONE so that as part of driver ep_poll mechanism, the upper
open-iscsi layer is notified to complete the login process on the first
un-reachable target and thus proceed login to other reachable targets.

Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedi/qedi_iscsi.c | 3 +++
 drivers/scsi/qedi/qedi_iscsi.h | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 2f0a4f2c5ff8..d4821b9dea45 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -954,6 +954,7 @@ static int qedi_ep_poll(struct iscsi_endpoint *ep, int timeout_ms)
 
 	qedi_ep = ep->dd_data;
 	if (qedi_ep->state == EP_STATE_IDLE ||
+	    qedi_ep->state == EP_STATE_OFLDCONN_NONE ||
 	    qedi_ep->state == EP_STATE_OFLDCONN_FAILED)
 		return -1;
 
@@ -1036,6 +1037,7 @@ static void qedi_ep_disconnect(struct iscsi_endpoint *ep)
 
 	switch (qedi_ep->state) {
 	case EP_STATE_OFLDCONN_START:
+	case EP_STATE_OFLDCONN_NONE:
 		goto ep_release_conn;
 	case EP_STATE_OFLDCONN_FAILED:
 			break;
@@ -1226,6 +1228,7 @@ static int qedi_set_path(struct Scsi_Host *shost, struct iscsi_path *path_data)
 
 	if (!is_valid_ether_addr(&path_data->mac_addr[0])) {
 		QEDI_NOTICE(&qedi->dbg_ctx, "dst mac NOT VALID\n");
+		qedi_ep->state = EP_STATE_OFLDCONN_NONE;
 		ret = -EIO;
 		goto set_path_exit;
 	}
diff --git a/drivers/scsi/qedi/qedi_iscsi.h b/drivers/scsi/qedi/qedi_iscsi.h
index 11260776212f..892d70d54553 100644
--- a/drivers/scsi/qedi/qedi_iscsi.h
+++ b/drivers/scsi/qedi/qedi_iscsi.h
@@ -59,6 +59,7 @@ enum {
 	EP_STATE_OFLDCONN_FAILED        = 0x2000,
 	EP_STATE_CONNECT_FAILED         = 0x4000,
 	EP_STATE_DISCONN_TIMEDOUT       = 0x8000,
+	EP_STATE_OFLDCONN_NONE          = 0x10000,
 };
 
 struct qedi_conn;
-- 
2.19.1
