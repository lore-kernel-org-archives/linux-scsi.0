Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86ADFC433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 23:53:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 510016128E
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 23:53:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238096AbhDLXxr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Apr 2021 19:53:47 -0400
Received: from mail-m17635.qiye.163.com ([59.111.176.35]:42250 "EHLO
        mail-m17635.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237250AbhDLXxq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Apr 2021 19:53:46 -0400
Received: from wanjb-KLV-WX9.lan (unknown [60.232.195.58])
        by mail-m17635.qiye.163.com (Hmail) with ESMTPA id A8AC94000DA;
        Tue, 13 Apr 2021 07:53:25 +0800 (CST)
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kael_w@yeah.net, Wan Jiabing <wanjiabing@vivo.com>
Subject: [PATCH] scsi: megraraid: Simplify judgement condition
Date:   Tue, 13 Apr 2021 07:53:16 +0800
Message-Id: <20210412235317.45040-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZGkJKQlZMHh0YTx1PTU0aSEpVEwETFhoSFyQUDg9ZV1kWGg8SFR0UWUFZT0tIVUpKS0
        hKTFVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NS46Iyo5HT8ITx4hER4sLSoW
        CTIKFB9VSlVKTUpDSUxKTUtNTk1IVTMWGhIXVQwaFRESGhkSFRw7DRINFFUYFBZFWVdZEgtZQVlN
        S1VJSElVSkJOVU5DWVdZCAFZQUlJTUo3Bg++
X-HM-Tid: 0a78c88115aed991kuwsa8ac94000da
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following coccicheck warning:

./drivers/scsi/megaraid/megaraid_sas_base.c:8644:30-32:
WARNING !A || A && B is equivalent to !A || B

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 63a4f48bdc75..5c17bbca95d0 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -8641,8 +8641,7 @@ int megasas_update_device_list(struct megasas_instance *instance,
 
 		if (event_type & SCAN_VD_CHANNEL) {
 			if (!instance->requestorId ||
-			    (instance->requestorId &&
-			     megasas_get_ld_vf_affiliation(instance, 0))) {
+			    megasas_get_ld_vf_affiliation(instance, 0)) {
 				dcmd_ret = megasas_ld_list_query(instance,
 						MR_LD_QUERY_TYPE_EXPOSED_TO_HOST);
 				if (dcmd_ret != DCMD_SUCCESS)
-- 
2.30.2

