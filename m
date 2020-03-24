Return-Path: <SRS0=zrch=5J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03739C4332B
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Mar 2020 07:59:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C66D920735
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Mar 2020 07:59:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727440AbgCXH7P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Mar 2020 03:59:15 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:37416 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725905AbgCXH7P (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 24 Mar 2020 03:59:15 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 6FFC32BC9E3E2CCB20DC;
        Tue, 24 Mar 2020 15:59:11 +0800 (CST)
Received: from [10.173.221.252] (10.173.221.252) by smtp.huawei.com
 (10.3.19.208) with Microsoft SMTP Server (TLS) id 14.3.487.0; Tue, 24 Mar
 2020 15:59:00 +0800
To:     Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <open-iscsi@googlegroups.com>, <linux-scsi@vger.kernel.org>,
        liuzhiqiang <liuzhiqiang26@huawei.com>, <linfeilong@huawei.com>
From:   Wu Bo <wubo40@huawei.com>
Subject: [PATCH] iscsi:report unbind session event when the target has been
 removed
Message-ID: <7cce97f2-4dab-5105-a477-8869d5a4f150@huawei.com>
Date:   Tue, 24 Mar 2020 15:58:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.173.221.252]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The daemon is restarted or crashed while logging out of a session.
The unbind session event sent by the kernel is not be processed or be lost.
When the daemon runs again, the session will never be able to logout.

After executing the logout again, the daemon is waiting for the unbind 
event message.
The kernel status has been logged out and the event will not be sent again.

#iscsiadm -m node iqn.xxx -p xx.xx.xx.xx -u &
#service iscsid restart

when iscsid restart done. logout session again report error:
#iscsiadm -m node iqn.xxxxx -p xx.xx.xx.xx -u
Logging out of session [sid: 6, target: iqn.xxxxx, portal: 
xx.xx.xx.xx,3260]
iscsiadm: Could not logout of [sid: 6, target: iscsiadm -m node 
iqn.xxxxx, portal: xx.xx.xx.xx,3260].
iscsiadm: initiator reported error (9 - internal error)
iscsiadm: Could not logout of all requested sessions

Signed-off-by: Wu Bo <wubo40@huawei.com>
---
  drivers/scsi/scsi_transport_iscsi.c | 4 +++-
  1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c 
b/drivers/scsi/scsi_transport_iscsi.c
index dfc726f..443ace0 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2012,7 +2012,7 @@ static void __iscsi_unbind_session(struct 
work_struct *work)
         if (session->target_id == ISCSI_MAX_TARGET) {
                 spin_unlock_irqrestore(&session->lock, flags);
                 mutex_unlock(&ihost->mutex);
-               return;
+               goto unbind_session_exit;
         }

         target_id = session->target_id;
@@ -2024,6 +2024,8 @@ static void __iscsi_unbind_session(struct 
work_struct *work)
                 ida_simple_remove(&iscsi_sess_ida, target_id);

         scsi_remove_target(&session->dev);
+
+unbind_session_exit:
         iscsi_session_event(session, ISCSI_KEVENT_UNBIND_SESSION);
         ISCSI_DBG_TRANS_SESSION(session, "Completed target removal\n");
  }
-- 
1.8.3.1
