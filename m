From: akpm@linux-foundation.org
Subject: [patch 08/29] MPT fusion: handle mpt_resume() failure while resuming
Date: Tue, 06 Mar 2007 02:46:33 -0800
Message-ID: <200703061046.l26AkXoY020009@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34932 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964786AbXCFKqp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Mar 2007 05:46:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, dmonakhov@openvz.org, Eric.Moore@lsil.com, jeff@garzik.org

From: Dmitriy Monakhov <dmonakhov@openvz.org>

Since mpt-fusion-handle-pci-layer-error-on-resume.patch function
mpt_resume() can return error code.

Signed-off-by: Monakhov Dmitriy <dmonakhov@openvz.org>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptscsih.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/message/fusion/mptscsih.c~mpt-fusion-handle-mpt_resume-failure-while-resuming drivers/message/fusion/mptscsih.c
--- a/drivers/message/fusion/mptscsih.c~mpt-fusion-handle-mpt_resume-failure-while-resuming
+++ a/drivers/message/fusion/mptscsih.c
@@ -1191,8 +1191,11 @@ mptscsih_resume(struct pci_dev *pdev)
 	MPT_ADAPTER 		*ioc = pci_get_drvdata(pdev);
 	struct Scsi_Host 	*host = ioc->sh;
 	MPT_SCSI_HOST		*hd;
+	int ret;
 
-	mpt_resume(pdev);
+	ret = mpt_resume(pdev);
+	if (ret)
+		return  ret;
 
 	if(!host)
 		return 0;
_
