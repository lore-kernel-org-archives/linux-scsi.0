From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] tcm_fc: set and unset FCP_SPPF_TARG_FCN
Date: Tue, 19 Jul 2016 15:01:55 +0200
Message-ID: <1468933315-72922-1-git-send-email-hare@suse.de>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

When registering and unregistering as an target port we should
be setting the FC-4 service params correctly.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/target/tcm_fc/tfc_sess.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index f5186a7..6ffbb60 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -91,6 +91,7 @@ static void ft_tport_delete(struct ft_tport *tport)
 
 	ft_sess_delete_all(tport);
 	lport = tport->lport;
+	lport->service_params &= ~FCP_SPPF_TARG_FCN;
 	BUG_ON(tport != lport->prov[FC_TYPE_FCP]);
 	RCU_INIT_POINTER(lport->prov[FC_TYPE_FCP], NULL);
 
@@ -110,6 +111,7 @@ void ft_lport_add(struct fc_lport *lport, void *arg)
 {
 	mutex_lock(&ft_lport_lock);
 	ft_tport_get(lport);
+	lport->service_params |= FCP_SPPF_TARG_FCN;
 	mutex_unlock(&ft_lport_lock);
 }
 
-- 
1.8.5.6
