Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0456C76196
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Mar 2023 01:57:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjCQB5e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Mar 2023 21:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjCQB5c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Mar 2023 21:57:32 -0400
Received: from m126.mail.126.com (m126.mail.126.com [220.181.12.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 814CA74A61
        for <linux-scsi@vger.kernel.org>; Thu, 16 Mar 2023 18:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=s7mSF
        XNHQwMLBHXaI2vH1RU5LoOZ6nqXxJo9y+F17Yc=; b=Z+iA9WjGjA1/OD22paVlr
        0gPvGiBbCtWJLzdluRnGRCP7rvDbkB4U3wSpCoyQI91pIyQCWUjjFxfyi4qPEWbj
        SzvNF6bo9SHTIdPtpnDekVdU/P0yrwpTsv8Th57iICtTqV+b1wEMHbDS32XSaubV
        BeJX40hwA0Ht5EtKTwQi/w=
Received: from localhost.localdomain (unknown [124.16.139.61])
        by zwqz-smtp-mta-g2-1 (Coremail) with SMTP id _____wAX6MHIyBNkN_7HAA--.52715S2;
        Fri, 17 Mar 2023 09:56:25 +0800 (CST)
From:   Liang He <windhl@126.com>
To:     james.smart@broadcom.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, windhl@126.com
Subject: [PATCH] scsi: lpfc: Fix potential memory leak
Date:   Fri, 17 Mar 2023 09:56:02 +0800
Message-Id: <20230317015602.1748372-1-windhl@126.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wAX6MHIyBNkN_7HAA--.52715S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7KFW3trWrCFW7GFyDKF15Jwb_yoW8GFy7pF
        W8GF1Yyr18ZF1IvrsxAa4rXrnaq3Z2gryjkFWvv3WYkry5W345JFyxJF97JFWDAF18Kryv
        qw1Yga4rGayDZaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zi4SotUUUUU=
X-Originating-IP: [124.16.139.61]
X-CM-SenderInfo: hzlqvxbo6rjloofrz/1tbi5QE0F1pD93ojGQACsr
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In lpfc_bsg_hba_get_event() and lpfc_bsg_hba_set_event(), we
should keep the refcount balance when there is some error or
the *evt* will be replaced.

Fixes: f1c3b0fcbb81 ("[SCSI] lpfc 8.3.4: Add bsg (SGIOv4) support for ELS/CT support")
Signed-off-by: Liang He <windhl@126.com>
---
 drivers/scsi/lpfc/lpfc_bsg.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 852b025e2fec..aa535bc14758 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -1200,6 +1200,11 @@ lpfc_bsg_hba_set_event(struct bsg_job *job)
 	spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
 
 	if (&evt->node == &phba->ct_ev_waiters) {
+
+		spin_lock_irqsave(&phba->ct_ev_lock, flags);
+		lpfc_bsg_event_unref(evt);
+		spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
+
 		/* no event waiting struct yet - first call */
 		dd_data = kmalloc(sizeof(struct bsg_job_data), GFP_KERNEL);
 		if (dd_data == NULL) {
@@ -1292,6 +1297,9 @@ lpfc_bsg_hba_get_event(struct bsg_job *job)
 	 * an error indicating that there isn't anymore
 	 */
 	if (evt_dat == NULL) {
+		spin_lock_irqsave(&phba->ct_ev_lock, flags);
+		lpfc_bsg_event_unref(evt);
+		spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
 		bsg_reply->reply_payload_rcv_len = 0;
 		rc = -ENOENT;
 		goto job_error;
-- 
2.25.1

