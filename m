From: Dan Carpenter <error27@gmail.com>
Subject: [patch 2/4] SCSI: target: change lock to unlock
Date: Mon, 13 Jun 2011 23:08:46 +0300
Message-ID: <20110613200846.GI3583@shale.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51643 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab1FMUJk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jun 2011 16:09:40 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: James Bottomley <jbottomley@parallels.com>, Kiran Patil <kiran.patil@intel.com>, Yi Zou <yi.zou@intel.com>, Joe Eykholt <jeykholt@cisco.com>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, kernel-janitors@vger.kernel.org

There is a typo here, it should be an unlock instead of a lock.  The
original code will deadlock.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index 03744c2..7491e21 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -332,7 +332,7 @@ void ft_sess_close(struct se_session *se_sess)
 	lport = sess->tport->lport;
 	port_id = sess->port_id;
 	if (port_id == -1) {
-		mutex_lock(&ft_lport_lock);
+		mutex_unlock(&ft_lport_lock);
 		return;
 	}
 	FT_SESS_DBG("port_id %x\n", port_id);
