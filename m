Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D8AFC76196
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Apr 2023 15:09:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239658AbjDFPJc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Apr 2023 11:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjDFPJ3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Apr 2023 11:09:29 -0400
X-Greylist: delayed 183 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 06 Apr 2023 08:09:04 PDT
Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [IPv6:2a02:6b8:c02:900:1:45:d181:df01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E89A49FF;
        Thu,  6 Apr 2023 08:09:04 -0700 (PDT)
Received: from mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net (mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net [IPv6:2a02:6b8:c14:5708:0:640:5704:0])
        by forwardcorp1b.mail.yandex.net (Yandex) with ESMTP id 523C360263;
        Thu,  6 Apr 2023 18:04:12 +0300 (MSK)
Received: from den-plotnikov-w.yandex-team.ru (unknown [2a02:6b8:b081:b509::1:20])
        by mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id 54SddM0OoiE0-BlJ8zXkE;
        Thu, 06 Apr 2023 18:04:11 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1680793451; bh=uT6P8O/ObGQAv1KfFPSPTzaiH0ko44WcONlGqu7lgcM=;
        h=Message-Id:Date:Cc:Subject:To:From;
        b=vVBmP036Ddx8dYBXXWchfwThvZXoPY/JdtPoqqu1z53chZD8mixRIBDEV51FdK1OB
         cki+wXjp7Sd10zuDF9Ys0vIxjRgEjoB/xYGkhQtT4m4qJlTJFt6YMMgY+Iv6sKYXbF
         43Z7c5r7SH5IS8tSfIop8fGwuzu1KhvyWjZ+cjas=
Authentication-Results: mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From:   Denis Plotnikov <den-plotnikov@yandex-team.ru>
To:     linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, den-plotnikov@yandex-team.ru,
        target-devel@vger.kernel.org, varun@chelsio.com,
        nab@linux-iscsi.org, martin.petersen@oracle.com
Subject: [PATCH] scsi: target: cxgbit: check skb dequeue result
Date:   Thu,  6 Apr 2023 18:04:05 +0300
Message-Id: <20230406150405.300909-1-den-plotnikov@yandex-team.ru>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On a couple of abort packet paths skb dequeuing may end up with
returning NULL, which, in turn, may end up with further null
pointer dereference.

Fix it by checking the return value of skb dequeuing.

Found by Linux Verification Center(linuxtesting.org) with SVACE.

Fixes: 9730ffcb8957 (cxgbit: add files for cxgbit.ko)
Signed-off-by: Denis Plotnikov <den-plotnikov@yandex-team.ru>
---
 drivers/target/iscsi/cxgbit/cxgbit_cm.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/target/iscsi/cxgbit/cxgbit_cm.c b/drivers/target/iscsi/cxgbit/cxgbit_cm.c
index 518ded214e74..d43fd761c20a 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_cm.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_cm.c
@@ -669,6 +669,9 @@ static int cxgbit_send_abort_req(struct cxgbit_sock *csk)
 		cxgbit_send_tx_flowc_wr(csk);
 
 	skb = __skb_dequeue(&csk->skbq);
+	if (!skb)
+		return 0;
+
 	cxgb_mk_abort_req(skb, len, csk->tid, csk->txq_idx,
 			  csk->com.cdev, cxgbit_abort_arp_failure);
 
@@ -1769,9 +1772,10 @@ static void cxgbit_abort_req_rss(struct cxgbit_sock *csk, struct sk_buff *skb)
 		cxgbit_send_tx_flowc_wr(csk);
 
 	rpl_skb = __skb_dequeue(&csk->skbq);
-
-	cxgb_mk_abort_rpl(rpl_skb, len, csk->tid, csk->txq_idx);
-	cxgbit_ofld_send(csk->com.cdev, rpl_skb);
+	if (!rpl_skb) {
+		cxgb_mk_abort_rpl(rpl_skb, len, csk->tid, csk->txq_idx);
+		cxgbit_ofld_send(csk->com.cdev, rpl_skb);
+	}
 
 	if (wakeup_thread) {
 		cxgbit_queue_rx_skb(csk, skb);
-- 
2.25.1

