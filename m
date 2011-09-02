From: Vasily Averin <vvs@parallels.com>
Subject: [SCSI] aacraid reset should disable MSI interrupt
Date: Fri, 02 Sep 2011 19:31:46 +0400
Message-ID: <4E60F6E2.7090505@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:7687 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645Ab1IBPcH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Sep 2011 11:32:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, aacraid@adaptec.com, Mark Salyzyn <mark_salyzyn@us.xyratex.com>
Cc: James Bottomley <jbottomley@parallels.com>

scsi reset on hardware with enabled MSI interrupts generates WARNING message

[11027.798722] aacraid: Host adapter abort request (0,0,0,0)
[11027.798814] aacraid: Host adapter reset request. SCSI hang ?
[11087.762237] aacraid: SCSI bus appears hung
[11135.082543] ------------[ cut here ]------------
[11135.082646] WARNING: at drivers/pci/msi.c:658 pci_enable_msi_block+0x251/0x290()

Signed-off-by:	Vasily Averin <vvs@sw.ru>
---
 drivers/scsi/aacraid/commsup.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index e7d0d47..e5f2d7d 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1283,6 +1283,8 @@ static int _aac_reset_adapter(struct aac_dev *aac, int forced)
 	kfree(aac->queues);
 	aac->queues = NULL;
 	free_irq(aac->pdev->irq, aac);
+	if (aac->msi)
+		pci_disable_msi(aac->pdev);
 	kfree(aac->fsa_dev);
 	aac->fsa_dev = NULL;
 	quirks = aac_get_driver_ident(index)->quirks;
-- 
1.7.4.1


