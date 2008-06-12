From: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH] dpt_i2o: Add PROC_IA64 define
Date: Thu, 12 Jun 2008 00:27:12 -0400
Message-ID: <4850A5A0.1040601@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:34909 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638AbYFLE1P (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jun 2008 00:27:15 -0400
Received: from Relay1.suse.de (relay-ext.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id A5862415E5
	for <linux-scsi@vger.kernel.org>; Thu, 12 Jun 2008 06:27:14 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

 This fixes the following compile failure in 2.6.26-rc5-git5:
 drivers/scsi/dpt_i2o.c:83: error: 'PROC_IA64' undeclared here (not in a function)

 I'm not sure if these values are magic and defined somewhere, but the
 kernel wouldn't build on IA64 without it.

 I changed the value in dpt_i2o.c because the comments indicated that
 PROC_INTEL refered to the 80x86 family, which doesn't include ia64.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 drivers/scsi/dpt/dptsig.h |    1 +
 drivers/scsi/dpt_i2o.c    |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/scsi/dpt/dptsig.h
+++ b/drivers/scsi/dpt/dptsig.h
@@ -92,6 +92,7 @@ typedef unsigned int sigINT;
 #define PROC_POWERPC    0x04    /* IBM Power PC */
 #define PROC_i960       0x05    /* Intel i960 */
 #define PROC_ULTRASPARC 0x06    /* SPARC processor */
+#define PROC_IA64	 0x07	 /* IA64 processor */
 
 /* Specific Minimim Processor - sigBYTE dsProcessor;    FLAG BITS */
 /* ------------------------------------------------------------------ */
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -80,7 +80,7 @@ static dpt_sig_S DPTI_sig = {
 #ifdef __i386__
 	PROC_INTEL, PROC_386 | PROC_486 | PROC_PENTIUM | PROC_SEXIUM,
 #elif defined(__ia64__)
-	PROC_INTEL, PROC_IA64,
+	PROC_IA64, PROC_IA64,
 #elif defined(__sparc__)
 	PROC_ULTRASPARC, PROC_ULTRASPARC,
 #elif defined(__alpha__)

-- 
Jeff Mahoney
SUSE Labs
