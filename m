From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH] [SCSI] lpfc 8.3.32: use list_move_tail instead of list_del/list_add_tail
Date: Wed, 5 Sep 2012 14:49:52 +0800
Message-ID: <CAPgLHd_fG+Qa0Zds-1pWfzCOPN5LWxQ_MkzjAoqx8eDUyuwOtw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:46332 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab2IEGtx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Sep 2012 02:49:53 -0400
Received: by qaas11 with SMTP id s11so4203217qaa.19
        for <linux-scsi@vger.kernel.org>; Tue, 04 Sep 2012 23:49:52 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@emulex.com, JBottomley@parallels.com
Cc: yongjun_wei@trendmicro.com.cn, linux-scsi@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using list_move_tail() instead of list_del() + list_add_tail().

spatch with a semantic match is used to found this problem.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/scsi/lpfc/lpfc_sli.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 9cbd20b..0ada66b 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -15833,8 +15833,7 @@ lpfc_cleanup_pending_mbox(struct lpfc_vport *vport)
 			(mb->u.mb.mbxCommand != MBX_REG_VPI))
 			continue;
 
-		list_del(&mb->list);
-		list_add_tail(&mb->list, &mbox_cmd_list);
+		list_move_tail(&mb->list, &mbox_cmd_list);
 	}
 	/* Clean up active mailbox command with the vport */
 	mb = phba->sli.mbox_active;


