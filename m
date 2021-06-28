Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BA4EC49EA3
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Jun 2021 13:36:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25C5F61C6C
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Jun 2021 13:36:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232562AbhF1Ni1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Jun 2021 09:38:27 -0400
Received: from comms.puri.sm ([159.203.221.185]:47422 "EHLO comms.puri.sm"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231964AbhF1Nhd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 28 Jun 2021 09:37:33 -0400
Received: from localhost (localhost [127.0.0.1])
        by comms.puri.sm (Postfix) with ESMTP id E8513E016C;
        Mon, 28 Jun 2021 06:34:37 -0700 (PDT)
Received: from comms.puri.sm ([127.0.0.1])
        by localhost (comms.puri.sm [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 6FSE_RpLYeAJ; Mon, 28 Jun 2021 06:34:37 -0700 (PDT)
From:   Martin Kepplinger <martin.kepplinger@puri.sm>
To:     martin.kepplinger@puri.sm
Cc:     bvanassche@acm.org, jejb@linux.ibm.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        stern@rowland.harvard.edu
Subject: [PATCH v4 3/3] scsi: devinfo: add BLIST_MEDIA_CHANGE for Ultra HS-SD/MMC usb cardreaders
Date:   Mon, 28 Jun 2021 15:34:12 +0200
Message-Id: <20210628133412.1172068-4-martin.kepplinger@puri.sm>
In-Reply-To: <20210628133412.1172068-1-martin.kepplinger@puri.sm>
References: <20210628133412.1172068-1-martin.kepplinger@puri.sm>
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

These cardreader device issues a MEDIA CHANGE unit attention not only
when actually a medium changed but also simply when resuming from suspend.

Setting the BLIST_MEDIA_CHANGE flag enables using runtime pm for SD cardreaders.

Signed-off-by: Martin Kepplinger <martin.kepplinger@puri.sm>
---
 drivers/scsi/scsi_devinfo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index d33355ab6e14..8ac0a11ac541 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -171,6 +171,7 @@ static struct {
 	{"FUJITSU", "ETERNUS_DXM", "*", BLIST_RETRY_ASC_C1},
 	{"Generic", "USB SD Reader", "1.00", BLIST_FORCELUN | BLIST_INQUIRY_36},
 	{"Generic", "USB Storage-SMC", NULL, BLIST_FORCELUN | BLIST_INQUIRY_36}, /* FW: 0180 and 0207 */
+	{"Generic", "Ultra HS-SD/MMC", "2.09", BLIST_MEDIA_CHANGE | BLIST_INQUIRY_36},
 	{"HITACHI", "DF400", "*", BLIST_REPORTLUN2},
 	{"HITACHI", "DF500", "*", BLIST_REPORTLUN2},
 	{"HITACHI", "DISK-SUBSYSTEM", "*", BLIST_REPORTLUN2},
-- 
2.30.2

