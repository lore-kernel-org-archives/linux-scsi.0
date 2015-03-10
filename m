From: Olaf Hering <olaf@aepfle.de>
Subject: [PATCH] storvsc: use KBUILD_MODNAME to fill .proc_name
Date: Tue, 10 Mar 2015 16:27:20 +0100
Message-ID: <1426001240-31686-1-git-send-email-olaf@aepfle.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.160]:35889 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbbCJP1b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Mar 2015 11:27:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <JBottomley@parallels.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>
Cc: linux-scsi@vger.kernel.org, devel@linuxdriverproject.org, linux-kernel@vger.kernel.org, Olaf Hering <olaf@aepfle.de>

Since the previous patch ead3700d893654d440edcb66fb3767a0c0db54cf ("storvsc:
use cmd_size to allocate per-command data") fills .proc_name now anyway give it
a usable content for v4.0. Old mkinitrd in SLES makes use of this variable to
find the required storage driver.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
---

This should go into v4.0 because ead3700d893654d440edcb66fb3767a0c0db54cf is in v4.0-rc1.


 drivers/scsi/storvsc_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index efc6e44..458e3d4 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1642,7 +1642,7 @@ static struct scsi_host_template scsi_driver = {
 	.bios_param =		storvsc_get_chs,
 	.queuecommand =		storvsc_queuecommand,
 	.eh_host_reset_handler =	storvsc_host_reset_handler,
-	.proc_name =		"storvsc_host",
+	.proc_name =		KBUILD_MODNAME,
 	.eh_timed_out =		storvsc_eh_timed_out,
 	.slave_configure =	storvsc_device_configure,
 	.cmd_per_lun =		255,
