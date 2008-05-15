From: Philippe Roussel <p.o.roussel@free.fr>
Subject: linux-next 20080515 libsas build failure
Date: Thu, 15 May 2008 19:07:13 +0200
Message-ID: <20080515170713.GA8667@coyote.octets.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp4-g19.free.fr ([212.27.42.30]:42272 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbYEORBh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 May 2008 13:01:37 -0400
Received: from smtp4-g19.free.fr (localhost.localdomain [127.0.0.1])
	by smtp4-g19.free.fr (Postfix) with ESMTP id 0AF4B3EA58E
	for <linux-scsi@vger.kernel.org>; Thu, 15 May 2008 19:01:36 +0200 (CEST)
Received: from coyote.octets.fr (lns-bzn-47f-81-56-208-194.adsl.proxad.net [81.56.208.194])
	by smtp4-g19.free.fr (Postfix) with ESMTP id E5CBC3EA57D
	for <linux-scsi@vger.kernel.org>; Thu, 15 May 2008 19:01:35 +0200 (CEST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I ran into

drivers/built-in.o: In function sas_request_addr':drivers/scsi/libsas/sas_scsi_host.c:1091: undefined reference to request_firmware' :drivers/scsi/libsas/sas_scsi_host.c:1103: undefined reference to release_firmware'
make: *** [.tmp_vmlinux1] Error 1

I think the following is needed.

Philippe

diff --git a/drivers/scsi/libsas/Kconfig b/drivers/scsi/libsas/Kconfig
index 18f33cd..73cee53 100644
--- a/drivers/scsi/libsas/Kconfig
+++ b/drivers/scsi/libsas/Kconfig
@@ -26,6 +26,7 @@ config SCSI_SAS_LIBSAS
 	tristate "SAS Domain Transport Attributes"
 	depends on SCSI
 	select SCSI_SAS_ATTRS
+	select FW_LOADER
 	help
 	  This provides transport specific helpers for SAS drivers which
 	  use the domain device construct (like the aic94xxx).
	  
-- 
GNU's Not Unix -- IIS Isn't Secure

