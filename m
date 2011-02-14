From: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
Subject: [PATCH] ipr: Fix a race on multiple configuration changes
Date: Mon, 14 Feb 2011 20:19:31 -0200
Message-ID: <1297721971.20599.9.camel@dream>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:57788 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab1BNWTr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Feb 2011 17:19:47 -0500
Received: from /spool/local
	by e24smtp04.br.ibm.com with XMail ESMTP
	for <linux-scsi@vger.kernel.org> from <klebers@linux.vnet.ibm.com>;
	Mon, 14 Feb 2011 20:19:44 -0200
Received: from d24av02.br.ibm.com (d24av02.br.ibm.com [9.8.31.93])
	by mailhub3.br.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p1EMRoXs3002476
	for <linux-scsi@vger.kernel.org>; Mon, 14 Feb 2011 20:27:54 -0200
Received: from d24av02.br.ibm.com (loopback [127.0.0.1])
	by d24av02.br.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p1EMJa8g026966
	for <linux-scsi@vger.kernel.org>; Mon, 14 Feb 2011 20:19:36 -0200
Received: from [9.12.224.39] ([9.12.224.39])
	by d24av02.br.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id p1EMJY6C026954
	for <linux-scsi@vger.kernel.org>; Mon, 14 Feb 2011 20:19:35 -0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

In a multiple configuration change scenario a remove notification can be
followed by an immediate add notification for the same device, which
will cause the device to be removed but never added back. This patch
fixes the problem by ensuring that in such situations the device will be
added back.

Signed-off-by: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
---
 drivers/scsi/ipr.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index a8e24f0..1485767 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -1301,7 +1301,7 @@ static void ipr_handle_config_change(struct ipr_ioa_cfg *ioa_cfg,
 			ipr_clear_res_target(res);
 			list_move_tail(&res->queue, &ioa_cfg->free_res_q);
 		}
-	} else if (!res->sdev) {
+	} else if (!res->sdev || res->del_from_ml) {
 		res->add_to_ml = 1;
 		if (ioa_cfg->allow_ml_add_del)
 			schedule_work(&ioa_cfg->work_q);
@@ -3104,7 +3104,10 @@ restart:
 				did_work = 1;
 				sdev = res->sdev;
 				if (!scsi_device_get(sdev)) {
-					list_move_tail(&res->queue, &ioa_cfg->free_res_q);
+					if (!res->add_to_ml)
+						list_move_tail(&res->queue, &ioa_cfg->free_res_q);
+					else
+						res->del_from_ml = 0;
 					spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 					scsi_remove_device(sdev);
 					scsi_device_put(sdev);
-- 
1.7.1


-- 
Kleber S. Souza
IBM Linux Technology Center

