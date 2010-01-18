From: George Kadianakis <desnacked@gmail.com>
Subject: Re: [PATCH 1/1] SCSI: lpfc, restore MSI-X/MSI support
Date: Mon, 18 Jan 2010 20:06:08 +0200
Message-ID: <87aawbthin.fsf@gmail.com>
References: <87r5pta66n.fsf@gmail.com> <1263754052.2802.2.camel@mulgrave.site>
	<87k4vglet8.fsf@gmail.com> <201001181549.13534.eike-kernel@sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:19853 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab0ARSIo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jan 2010 13:08:44 -0500
Received: by ey-out-2122.google.com with SMTP id 22so525384eye.5
        for <linux-scsi@vger.kernel.org>; Mon, 18 Jan 2010 10:08:43 -0800 (PST)
In-Reply-To: <201001181549.13534.eike-kernel@sf-tec.de> (Rolf Eike Beer's
	message of "Mon, 18 Jan 2010 15:48:50 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, james.smart@emulex.com

From: George Kadianakis <desnacked {bomb} gmail {point} com>

A Gentoo bug report [1] showed that as of 2.6.31 lpfc only uses INTx interrupts.
This patch restores lpfc's ability to support MSI-X/MSI interrupts that the 
"Addition of SLI4 Interface - Base Support" patch [2] broke.
It reestablishes MSI-X as the default interrupt method and in case MSI-X is not 
supported lpfc_sli{4,}_enable_intr fallbacks to MSI and then to INTx.

[1]: http://bugs.gentoo.org/show_bug.cgi?id=296319
[2]: commit da0436e915a5c17ee79e72c1bf978a4ebb1cbf4d

Signed-off-by:  George Kadianakis <desnacked@gmail.com>
---
 drivers/scsi/lpfc/lpfc_attr.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index e1a30a1..61c7f4b 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -2890,12 +2890,12 @@ LPFC_ATTR_RW(poll_tmo, 10, 1, 255,
 /*
 # lpfc_use_msi: Use MSI (Message Signaled Interrupts) in systems that
 #		support this feature
-#       0  = MSI disabled (default)
+#       0  = MSI disabled
 #       1  = MSI enabled
-#       2  = MSI-X enabled
-# Value range is [0,2]. Default value is 0.
+#       2  = MSI-X enabled (default)
+# Value range is [0,2]. Default value is 2.
 */
-LPFC_ATTR_R(use_msi, 0, 0, 2, "Use Message Signaled Interrupts (1) or "
+LPFC_ATTR_R(use_msi, 2, 0, 2, "Use Message Signaled Interrupts (1) or "
 	    "MSI-X (2), if possible");
 
 /*
