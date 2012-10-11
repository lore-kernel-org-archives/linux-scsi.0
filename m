From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] [SCSI] bfa: unlock on error in bfad_iocmd_cfg_trunk()
Date: Thu, 11 Oct 2012 09:57:59 +0300
Message-ID: <20121011065758.GF31607@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Krishna C Gudipati <kgudipat@brocade.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

We added a new return but forgot to drop the lock first.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Bug introduced in e353546e "[SCSI] bfa: Add diagnostic port (D-Port)
support".

diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index 555e7db..91465b2 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -2238,8 +2238,10 @@ bfad_iocmd_cfg_trunk(struct bfad_s *bfad, void *cmd, unsigned int v_cmd)
 
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
 
-	if (bfa_fcport_is_dport(&bfad->bfa))
+	if (bfa_fcport_is_dport(&bfad->bfa)) {
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 		return BFA_STATUS_DPORT_ERR;
+	}
 
 	if ((fcport->cfg.topology == BFA_PORT_TOPOLOGY_LOOP) ||
 		(fcport->topology == BFA_PORT_TOPOLOGY_LOOP))
