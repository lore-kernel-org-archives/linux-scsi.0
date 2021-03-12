Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9497C433E9
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 02:18:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9707C64ED7
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 02:18:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbhCLCS0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 21:18:26 -0500
Received: from mail-m17635.qiye.163.com ([59.111.176.35]:40956 "EHLO
        mail-m17635.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbhCLCS0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Mar 2021 21:18:26 -0500
Received: from vivo-HP-ProDesk-680-G4-PCI-MT.vivo.xyz (unknown [58.251.74.231])
        by mail-m17635.qiye.163.com (Hmail) with ESMTPA id 1A1614000E4;
        Fri, 12 Mar 2021 10:18:24 +0800 (CST)
From:   Wang Qing <wangqing@vivo.com>
To:     Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Wang Qing <wangqing@vivo.com>
Subject: [PATCH] scsi: fnic: delete the useless casting value returned
Date:   Fri, 12 Mar 2021 10:18:19 +0800
Message-Id: <1615515500-946-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZThhDH0NITUwdSk9KVkpNSk5OSk5OS09PTk5VEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NTY6Fgw5Az8KFwIUHzAwHAwU
        FEIaChlVSlVKTUpOTkpOTktPTElMVTMWGhIXVQwaFRwKEhUcOw0SDRRVGBQWRVlXWRILWUFZTkNV
        SU5KVUxPVUlISllXWQgBWUFKQ05INwY+
X-HM-Tid: 0a78243a4ef3d991kuws1a1614000e4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following coccicheck warning:
WARNING: casting value returned by memory allocation function is useless.

Signed-off-by: Wang Qing <wangqing@vivo.com>
---
 drivers/scsi/fnic/fnic_debugfs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_debugfs.c b/drivers/scsi/fnic/fnic_debugfs.c
index 6c04936..e732650
--- a/drivers/scsi/fnic/fnic_debugfs.c
+++ b/drivers/scsi/fnic/fnic_debugfs.c
@@ -58,8 +58,7 @@ int fnic_debugfs_init(void)
 						fnic_trace_debugfs_root);
 
 	/* Allocate memory to structure */
-	fc_trc_flag = (struct fc_trace_flag_type *)
-		vmalloc(sizeof(struct fc_trace_flag_type));
+	fc_trc_flag = vmalloc(sizeof(struct fc_trace_flag_type));
 
 	if (fc_trc_flag) {
 		fc_trc_flag->fc_row_file = 0;
-- 
2.7.4

