From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH] [SCSI] libfcoe: use list_move instead of list_del/list_add
Date: Thu, 6 Sep 2012 12:36:21 +0800
Message-ID: <CAPgLHd_m2J1W8Su4NJuShHTzwdb94t=-8=oFv6=r1OL5735uyQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:40019 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab2IFEgV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Sep 2012 00:36:21 -0400
Received: by mail-qc0-f174.google.com with SMTP id o28so585005qcr.19
        for <linux-scsi@vger.kernel.org>; Wed, 05 Sep 2012 21:36:21 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: robert.w.love@intel.com, JBottomley@parallels.com
Cc: yongjun_wei@trendmicro.com.cn, devel@open-fcoe.org, linux-scsi@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using list_move() instead of list_del() + list_add().

spatch with a semantic match is used to found this problem.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/scsi/fcoe/fcoe_ctlr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index 2ebe03a..44b4d99 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -817,8 +817,7 @@ static unsigned long fcoe_ctlr_age_fcfs(struct fcoe_ctlr *fip)
 			 * fcoe_sysfs_fcf_del (which can sleep)
 			 * after the put_cpu().
 			 */
-			list_del(&fcf->list);
-			list_add(&fcf->list, &del_list);
+			list_move(&fcf->list, &del_list);
 			stats->VLinkFailureCount++;
 		} else {
 			if (time_after(next_timer, deadline))

