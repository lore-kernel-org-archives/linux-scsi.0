Return-Path: <SRS0=Vgdy=EE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 178AEC2D0A3
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 17:09:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABB8C20790
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 17:09:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="iSheoy11"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725957AbgJ2RJf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Oct 2020 13:09:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:38062 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725948AbgJ2RJe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Oct 2020 13:09:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1603991345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kJJ41tA+YMSDKv0ru3nXr9yN/Md6CzArBNikfPPSS2k=;
        b=iSheoy11gCUQRzMYTVbPRHrdWmyvn4V+p6V2Jvsg1IW/GF5YEte4ambjWa/ndRFGQu4A+D
        Ca8ls5LwTQBJdjTZC8o1BWs964qwdMEXTkfon9MwTa2sWPyIcszLo7HxyJE1it8beMZkc2
        XE0OqP15QJtAEqQ2eL2Zi9DD2oR4izo=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 759ADAD1A;
        Thu, 29 Oct 2020 17:09:05 +0000 (UTC)
From:   mwilck@suse.com
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>
Cc:     linux-scsi@vger.kernel.org,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        Martin Wilck <mwilck@suse.com>
Subject: [PATCH 2/2] scsi: scsi_vpd_lun_id: replace while-loop by for-loop
Date:   Thu, 29 Oct 2020 18:08:46 +0100
Message-Id: <20201029170846.14786-2-mwilck@suse.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20201029170846.14786-1-mwilck@suse.com>
References: <20201029170846.14786-1-mwilck@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

This makes the code slightly more readable.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/scsi_lib.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 293ee1af62c3..a20f3e4b3e9b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -3057,12 +3057,13 @@ int scsi_vpd_lun_id(struct scsi_device *sdev, char *id, size_t id_len)
 	}
 
 	memset(id, 0, id_len);
-	d = vpd_pg83->data + 4;
-	while (d < vpd_pg83->data + vpd_pg83->len) {
+	for (d = vpd_pg83->data + 4;
+	     d < vpd_pg83->data + vpd_pg83->len;
+	     d += d[3] + 4) {
 		u8 prio = designator_prio(d);
 
 		if (prio == 0 || cur_id_prio > prio)
-			goto next_desig;
+			continue;
 
 		switch (d[1] & 0xf) {
 		case 0x1:
@@ -3142,8 +3143,6 @@ int scsi_vpd_lun_id(struct scsi_device *sdev, char *id, size_t id_len)
 		default:
 			break;
 		}
-next_desig:
-		d += d[3] + 4;
 	}
 	rcu_read_unlock();
 
-- 
2.29.0

