Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B115EC77B61
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Apr 2023 02:38:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbjDJCiZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 9 Apr 2023 22:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjDJCiY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Apr 2023 22:38:24 -0400
Received: from hust.edu.cn (unknown [202.114.0.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8B042721;
        Sun,  9 Apr 2023 19:38:22 -0700 (PDT)
Received: from localhost.localdomain ([172.16.0.254])
        (user=jun_c@hust.edu.cn mech=LOGIN bits=0)
        by mx1.hust.edu.cn  with ESMTP id 33A2bQaM021706-33A2bQaN021706
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Mon, 10 Apr 2023 10:37:37 +0800
From:   Jun Chen <jun_c@hust.edu.cn>
To:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Jun Chen <jun_c@hust.edu.cn>, Dongliang Mu <dzm91@hust.edu.cn>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: lpfc: silence an incorrect device output
Date:   Mon, 10 Apr 2023 10:37:23 +0800
Message-Id: <20230410023724.3209455-1-jun_c@hust.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-FEAS-AUTH-USER: jun_c@hust.edu.cn
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In lpfc_sli4_pci_mem_unset, case LPFC_SLI_INTF_IF_TYPE_1 does not have a
break statement, resulting in an incorrect device output.

Fix this by adding a break statement before the default option.

Signed-off-by: Jun Chen <jun_c@hust.edu.cn>
Reviewed-by: Dongliang Mu <dzm91@hust.edu.cn>
---
 drivers/scsi/lpfc/lpfc_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index d062220d3232..da3a45441639 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -12105,6 +12105,7 @@ lpfc_sli4_pci_mem_unset(struct lpfc_hba *phba)
 			iounmap(phba->sli4_hba.dpp_regs_memmap_p);
 		break;
 	case LPFC_SLI_INTF_IF_TYPE_1:
+		break;
 	default:
 		dev_printk(KERN_ERR, &phba->pcidev->dev,
 			   "FATAL - unsupported SLI4 interface type - %d\n",
-- 
2.25.1

