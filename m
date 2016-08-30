From: Colin King <colin.king@canonical.com>
Subject: [PATCH] bfa: do not dereference port before it is null checked
Date: Tue, 30 Aug 2016 17:36:16 +0100
Message-ID: <20160830163616.11410-1-colin.king@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

port is deferenced before it is null sanity checked, hence
we potentially have a null pointer dereference bug. Instead,
initialise trl_enabled from port->fcs->bfa after we are sure
port is not null.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/bfa/bfa_fcs_lport.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index 7733ad5..bdf39e7 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -5827,13 +5827,13 @@ bfa_fcs_lport_get_rport_max_speed(bfa_fcs_lport_t *port)
 	bfa_port_speed_t max_speed = 0;
 	struct bfa_port_attr_s port_attr;
 	bfa_port_speed_t port_speed, rport_speed;
-	bfa_boolean_t trl_enabled = bfa_fcport_is_ratelim(port->fcs->bfa);
-
+	bfa_boolean_t trl_enabled;
 
 	if (port == NULL)
 		return 0;
 
 	fcs = port->fcs;
+	trl_enabled = bfa_fcport_is_ratelim(port->fcs->bfa);
 
 	/* Get Physical port's current speed */
 	bfa_fcport_get_attr(port->fcs->bfa, &port_attr);
-- 
2.9.3
