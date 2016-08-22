From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/6] target/tcm_fc: return detailed error in ft_sess_create()
Date: Mon, 22 Aug 2016 10:54:09 +0200
Message-ID: <1471856051-87398-5-git-send-email-hare@suse.de>
References: <1471856051-87398-1-git-send-email-hare@suse.de>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1471856051-87398-1-git-send-email-hare@suse.de>
Sender: target-devel-owner@vger.kernel.org
To: Nic Bellinger <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Martin Wilck <martin.wilck@suse.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

Not every failure is due to out-of-memory; the ACLs might not be
set, too. So return a detailed error code in ft_sess_create()
instead of just a NULL pointer.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/target/tcm_fc/tfc_sess.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index 6ffbb60..cc8c261 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -223,7 +223,7 @@ static struct ft_sess *ft_sess_create(struct ft_tport *tport, u32 port_id,
 
 	sess = kzalloc(sizeof(*sess), GFP_KERNEL);
 	if (!sess)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	kref_init(&sess->kref); /* ref for table entry */
 	sess->tport = tport;
@@ -234,8 +234,9 @@ static struct ft_sess *ft_sess_create(struct ft_tport *tport, u32 port_id,
 					     TARGET_PROT_NORMAL, &initiatorname[0],
 					     sess, ft_sess_alloc_cb);
 	if (IS_ERR(sess->se_sess)) {
+		int rc = PTR_ERR(sess->se_sess);
 		kfree(sess);
-		return NULL;
+		sess = ERR_PTR(rc);
 	}
 	return sess;
 }
-- 
1.8.5.6
