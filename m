Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCC67C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Oct 2021 06:41:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 960406139F
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Oct 2021 06:41:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232755AbhJDGm4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Oct 2021 02:42:56 -0400
Received: from unicom146.biz-email.net ([210.51.26.146]:53472 "EHLO
        unicom146.biz-email.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232131AbhJDGmz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Oct 2021 02:42:55 -0400
Received: from ([60.208.111.195])
        by unicom146.biz-email.net ((LNX1044)) with ASMTP (SSL) id XGS00059;
        Mon, 04 Oct 2021 14:40:59 +0800
Received: from localhost.localdomain (10.200.104.119) by
 jtjnmail201605.home.langchao.com (10.100.2.5) with Microsoft SMTP Server id
 15.1.2308.14; Mon, 4 Oct 2021 14:40:59 +0800
From:   Kai Song <songkai01@inspur.com>
To:     <hare@suse.de>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Kai Song <songkai01@inspur.com>
Subject: [PATCH] scsi: fcoe:Use kmemdup() rather than kmalloc+memcpy
Date:   Mon, 4 Oct 2021 14:40:58 +0800
Message-ID: <20211004064058.251899-1-songkai01@inspur.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.200.104.119]
tUid:   20211004144059913402333242e805a6f878ef59c8fe95
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replace calls to kmalloc followed by a memcpy with a direct 
call to kmemdup.

Signed-off-by: Kai Song <songkai01@inspur.com>
---
 drivers/scsi/fcoe/fcoe_ctlr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index 1756a0ac6f08..37df848e7545 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -1045,11 +1045,10 @@ static void fcoe_ctlr_recv_adv(struct fcoe_ctlr *fip, struct sk_buff *skb)
 		if (fip->fcf_count >= FCOE_CTLR_FCF_LIMIT)
 			goto out;
 
-		fcf = kmalloc(sizeof(*fcf), GFP_ATOMIC);
+		fcf = kmemdup(&new, sizeof(*fcf), GFP_ATOMIC);
 		if (!fcf)
 			goto out;
 
-		memcpy(fcf, &new, sizeof(new));
 		fcf->fip = fip;
 		rc = fcoe_sysfs_fcf_add(fcf);
 		if (rc) {
-- 
2.27.0

