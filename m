From: Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH] qla4xxx: drop redundant init_completion
Date: Wed, 22 Mar 2017 11:44:22 +0100
Message-ID: <1490179462-16559-1-git-send-email-der.herr@hofr.at>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.osadl.org ([62.245.132.105]:50209 "EHLO www.osadl.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759175AbdCVKoW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Mar 2017 06:44:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>, QLogic-Storage-Upstream@qlogic.com, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Nicholas Mc Guire <der.herr@hofr.at>

The redundant init_completion() here seems to be a cut&past error as
struct scsi_qla_host only has 4 completion elements to initialize, thus
the duplicate init_completion(disable_acb_comp) is simply removed.

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---

Found by experimental coccinelle script: 
./drivers/scsi/qla4xxx/ql4_os.c:8667:1-16: WARNING: possible duplicate 
init_completion


checking struct scsi_qla_host in
drivers/scsi/qla4xxx/ql4_def.h:457 "Linux Host Adapter structure"
it contain only the following 4 completion objects:

struct completion disable_acb_comp;
struct completion idc_comp;
struct completion link_up_comp;
struct completion mbx_intr_comp;

so it seems the double initialization of disable_acb_comp was just a
cut&past but and no omission of some other completion object - thus
the second initialization is simply removed.

Patch was only compile tested with: x86_64_defconfig + SCSI_LOWLEVEL=y,
 CONFIG_SCSI_QLA_ISCSI=m
(...quite a few sparse and coccinelle errors/warnings during build-tests)

Patch is against 4.11-rc3 (localversion-next is next-20170322)

 drivers/scsi/qla4xxx/ql4_os.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index ac52150..64c6fa5 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -8663,9 +8663,8 @@ static int qla4xxx_probe_adapter(struct pci_dev *pdev,
 	init_completion(&ha->mbx_intr_comp);
 	init_completion(&ha->disable_acb_comp);
 	init_completion(&ha->idc_comp);
 	init_completion(&ha->link_up_comp);
-	init_completion(&ha->disable_acb_comp);
 
 	spin_lock_init(&ha->hardware_lock);
 	spin_lock_init(&ha->work_lock);
 
-- 
2.1.4
