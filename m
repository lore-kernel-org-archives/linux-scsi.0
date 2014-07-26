From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] scsi: bfa: bfad_bsg.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sat, 26 Jul 2014 16:51:04 +0200
Message-ID: <1406386264-4225-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:64782 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbaGZOti (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 26 Jul 2014 10:49:38 -0400
Received: by mail-wi0-f177.google.com with SMTP id ho1so2300359wib.4
        for <linux-scsi@vger.kernel.org>; Sat, 26 Jul 2014 07:49:37 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/bfa/bfad_bsg.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index 8994fb8..f229936 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -128,7 +128,7 @@ bfad_iocmd_ioc_get_attr(struct bfad_s *bfad, void *cmd)
 
 	/* fill in driver attr info */
 	strcpy(iocmd->ioc_attr.driver_attr.driver, BFAD_DRIVER_NAME);
-	strncpy(iocmd->ioc_attr.driver_attr.driver_ver,
+	strlcpy(iocmd->ioc_attr.driver_attr.driver_ver,
 		BFAD_DRIVER_VERSION, BFA_VERSION_LEN);
 	strcpy(iocmd->ioc_attr.driver_attr.fw_ver,
 		iocmd->ioc_attr.adapter_attr.fw_ver);
@@ -316,7 +316,7 @@ bfad_iocmd_port_get_attr(struct bfad_s *bfad, void *cmd)
 	iocmd->attr.port_type = port_attr.port_type;
 	iocmd->attr.loopback = port_attr.loopback;
 	iocmd->attr.authfail = port_attr.authfail;
-	strncpy(iocmd->attr.port_symname.symname,
+	strlcpy(iocmd->attr.port_symname.symname,
 		port_attr.port_cfg.sym_name.symname,
 		sizeof(port_attr.port_cfg.sym_name.symname));
 
-- 
1.7.10.4

