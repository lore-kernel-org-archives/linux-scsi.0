From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] bfa: fix test in bfad_os_fc_host_init()
Date: Thu, 15 Oct 2009 20:15:17 +0200
Message-ID: <4AD766B5.5040509@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:59165 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756584AbZJOSGX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Oct 2009 14:06:23 -0400
Received: by ewy4 with SMTP id 4so809569ewy.37
        for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2009 11:05:46 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: huangj@brocade.com, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

BFA_PORT_ROLE_FCP_IPFC is 0x04 so this always evaluates to true

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
see vi drivers/scsi/bfa/include/defs/bfa_defs_port.h +45 
was this intended?

diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 158c992..55d012a 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -948,7 +948,7 @@ bfad_os_fc_host_init(struct bfad_im_port_s *im_port)
 	if (bfad_supported_fc4s & (BFA_PORT_ROLE_FCP_IM | BFA_PORT_ROLE_FCP_TM))
 		/* For FCP type 0x08 */
 		fc_host_supported_fc4s(host)[2] = 1;
-	if (bfad_supported_fc4s | BFA_PORT_ROLE_FCP_IPFC)
+	if (bfad_supported_fc4s & BFA_PORT_ROLE_FCP_IPFC)
 		/* For LLC/SNAP type 0x05 */
 		fc_host_supported_fc4s(host)[3] = 0x20;
 	/* For fibre channel services type 0x20 */
