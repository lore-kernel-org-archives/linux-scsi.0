From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH] wd719x: add missing .module to wd719x_template
Date: Sun, 25 Jan 2015 22:23:45 +0100
Message-ID: <1422221025-2226-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:33611 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969AbbAYVXz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 25 Jan 2015 16:23:55 -0500
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1YFUev-0002dq-51
	for linux-scsi@vger.kernel.org; Sun, 25 Jan 2015 22:23:53 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

wd719x_template is missing the .module field, causing module refcount
not to work, allowing to rmmod the driver while in use (mounted filesystem),
causing an oops.

Set .module to THIS_MODULE to fix the problem.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/wd719x.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
index 7702664..289ad01 100644
--- a/drivers/scsi/wd719x.c
+++ b/drivers/scsi/wd719x.c
@@ -870,6 +870,7 @@ fail_free_params:
 }
 
 static struct scsi_host_template wd719x_template = {
+	.module				= THIS_MODULE,
 	.name				= "Western Digital 719x",
 	.queuecommand			= wd719x_queuecommand,
 	.eh_abort_handler		= wd719x_abort,
-- 
Ondrej Zary

