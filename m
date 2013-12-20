From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH] [SCSI] bfa: fix missing unlock on error in bfad_iocmd_cfg_trunk()
Date: Fri, 20 Dec 2013 10:51:23 +0800
Message-ID: <CAPgLHd9prpLF_sjwoj_QmiAZtwQG=Yig2FsYgd2OE5HXHpb04A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46703 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368Ab3LTCvZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Dec 2013 21:51:25 -0500
Received: by mail-bk0-f46.google.com with SMTP id u15so994585bkz.19
        for <linux-scsi@vger.kernel.org>; Thu, 19 Dec 2013 18:51:23 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: agurumur@brocade.com, vmohan@brocade.com, JBottomley@parallels.com
Cc: yongjun_wei@trendmicro.com.cn, linux-scsi@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add the missing unlock before return from function bfad_iocmd_cfg_trunk()
in the error handling case.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/scsi/bfa/bfad_bsg.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index 157f604..8994fb8 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -2304,8 +2304,10 @@ bfad_iocmd_cfg_trunk(struct bfad_s *bfad, void *cmd, unsigned int v_cmd)
 
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
 
-	if (bfa_fcport_is_dport(&bfad->bfa))
+	if (bfa_fcport_is_dport(&bfad->bfa)) {
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 		return BFA_STATUS_DPORT_ERR;
+	}
 
 	if ((fcport->cfg.topology == BFA_PORT_TOPOLOGY_LOOP) ||
 		(fcport->topology == BFA_PORT_TOPOLOGY_LOOP))

