From: vikas.chaudhary@qlogic.com
Subject: [PATCH 08/13] qla4xxx: Fix panic while rmmod
Date: Thu, 20 Sep 2012 07:35:08 -0400
Message-ID: <1348140913-11828-9-git-send-email-vikas.chaudhary@qlogic.com>
References: <1348140913-11828-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:52574 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754185Ab2ITLxF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Sep 2012 07:53:05 -0400
In-Reply-To: <1348140913-11828-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Issue:
System panic on rmmod if probe_adapter had failed during driver load.

Call Trace:
 [<ffffffffa071aa5a>] qla4xxx_abort_active_cmds+0x4a/0xa0 [qla4xxx]
 [<ffffffffa07224db>] qla4xxx_free_adapter+0x1b/0x1b0 [qla4xxx]
 [<ffffffffa073991f>] qla4xxx_remove_adapter+0x294/0x2c7 [qla4xxx]
 [<ffffffff812930b7>] pci_device_remove+0x37/0x70
 [<ffffffff8135006f>] __device_release_driver+0x6f/0xe0
 [<ffffffff813501a8>] driver_detach+0xc8/0xd0
 [<ffffffff8134ef0e>] bus_remove_driver+0x8e/0x110
 [<ffffffff81350972>] driver_unregister+0x62/0xa0
 [<ffffffff812933c4>] pci_unregister_driver+0x44/0xb0
 [<ffffffffa0739659>] qla4xxx_module_exit+0x15/0x47 [qla4xxx]
 [<ffffffff810addd4>] sys_delete_module+0x194/0x260
 [<ffffffff8150326e>] ? do_page_fault+0x3e/0xa0
 [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b

Fix:
Do not cleanup resources on remove_adapter as they are cleaned up during
probe_adapter exit.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 29bd225..97ce44b 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -5449,6 +5449,13 @@ static void __devexit qla4xxx_remove_adapter(struct pci_dev *pdev)
 {
 	struct scsi_qla_host *ha;
 
+	/*
+	 * If the PCI device is disabled then it means probe_adapter had
+	 * failed and resources already cleaned up on probe_adapter exit.
+	 */
+	if (!pci_is_enabled(pdev))
+		return;
+
 	ha = pci_get_drvdata(pdev);
 
 	if (is_qla40XX(ha))
-- 
1.7.1

