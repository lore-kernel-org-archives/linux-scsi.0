From: Dave Jones <davej@codemonkey.org.uk>
Subject: scsi: qla2xxx: Fix apparent cut-n-paste error.
Date: Tue, 27 Dec 2016 13:13:21 -0500
Message-ID: <20161227181321.35xf5hm4qz3uajmp@codemonkey.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from arcturus.aphlor.org ([188.246.204.175]:34504 "EHLO
        arcturus.aphlor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754324AbcL0SNl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Dec 2016 13:13:41 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Quinn Tran <quinn.tran@cavium.com>

commit 093df73771bac8a37d607c0e705d157a8cef4c5c introduces two bodies of
code that look similar but with s/req/rsp/ in the second instance.
But in one case, it looks like this conversion was missed.

Signed-off-by: Dave Jones <davej@codemonkey.org.uk>

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 8521cfe302e9..ad4edc13ebcf 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -466,7 +466,7 @@ static void qla2x00_free_queues(struct qla_hw_data *ha)
 			continue;
 
 		rsp = ha->rsp_q_map[cnt];
-		clear_bit(cnt, ha->req_qid_map);
+		clear_bit(cnt, ha->rsp_qid_map);
 		ha->rsp_q_map[cnt] =  NULL;
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 		qla2x00_free_rsp_que(ha, rsp);
