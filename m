Return-Path: <SRS0=VRpU=44=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E325DC10F29
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 09:16:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7B0121655
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 09:16:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728704AbgCKJQi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Mar 2020 05:16:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:47704 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726160AbgCKJQg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Mar 2020 05:16:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E138EAE85;
        Wed, 11 Mar 2020 09:16:34 +0000 (UTC)
From:   Takashi Iwai <tiwai@suse.de>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Subbu Seetharaman <subbu.seetharaman@broadcom.com>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH 2/8] scsi: be2iscsi: Use scnprintf() for avoiding potential buffer overflow
Date:   Wed, 11 Mar 2020 10:16:24 +0100
Message-Id: <20200311091630.22565-3-tiwai@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200311091630.22565-1-tiwai@suse.de>
References: <20200311091630.22565-1-tiwai@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since snprintf() returns the would-be-output size instead of the
actual output size, the succeeding calls may go beyond the given
buffer limit.  Fix it by replacing with scnprintf().

Cc: Subbu Seetharaman <subbu.seetharaman@broadcom.com>
Cc: Ketan Mukadam <ketan.mukadam@broadcom.com>
Cc: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/scsi/be2iscsi/be_mgmt.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index d4febaadfaa3..3ae8d2b4ea31 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -1178,11 +1178,11 @@ beiscsi_active_session_disp(struct device *dev, struct device_attribute *attr,
 		if (test_bit(ulp_num, (void *)&phba->fw_config.ulp_supported)) {
 			avlbl_cids = BEISCSI_ULP_AVLBL_CID(phba, ulp_num);
 			total_cids = BEISCSI_GET_CID_COUNT(phba, ulp_num);
-			len += snprintf(buf+len, PAGE_SIZE - len,
+			len += scnprintf(buf+len, PAGE_SIZE - len,
 					"ULP%d : %d\n", ulp_num,
 					(total_cids - avlbl_cids));
 		} else
-			len += snprintf(buf+len, PAGE_SIZE - len,
+			len += scnprintf(buf+len, PAGE_SIZE - len,
 					"ULP%d : %d\n", ulp_num, 0);
 	}
 
@@ -1208,11 +1208,11 @@ beiscsi_free_session_disp(struct device *dev, struct device_attribute *attr,
 
 	for (ulp_num = 0; ulp_num < BEISCSI_ULP_COUNT; ulp_num++) {
 		if (test_bit(ulp_num, (void *)&phba->fw_config.ulp_supported))
-			len += snprintf(buf+len, PAGE_SIZE - len,
+			len += scnprintf(buf+len, PAGE_SIZE - len,
 					"ULP%d : %d\n", ulp_num,
 					BEISCSI_ULP_AVLBL_CID(phba, ulp_num));
 		else
-			len += snprintf(buf+len, PAGE_SIZE - len,
+			len += scnprintf(buf+len, PAGE_SIZE - len,
 					"ULP%d : %d\n", ulp_num, 0);
 	}
 
-- 
2.16.4

