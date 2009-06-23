From: Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 1/1] Reduce AACRAID hardware queue size
Date: Tue, 23 Jun 2009 12:25:06 +0100
Message-ID: <1245756306-29023-2-git-send-email-apw@canonical.com>
References: <1245756306-29023-1-git-send-email-apw@canonical.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adelie.canonical.com ([91.189.90.139]:32806 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbZFWLZP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jun 2009 07:25:15 -0400
In-Reply-To: <1245756306-29023-1-git-send-email-apw@canonical.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@adaptec.com>
Cc: Andy Whitcroft <apw@canonical.com>, Mathias Urlichs <matthias@urlichs.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

From: Mathias Urlichs <matthias@urlichs.de>

BugLink: http://bugzilla.kernel.org/show_bug.cgi?id=11120
BugLink: http://bugs.launchpad.net/bugs/249964

Reduce the hardware queue size for the AACRAID controller.  This controloler
suffers adapter aborts and scsi resets under high load otherwise:

    aacraid: Host adapter abort request (0,0,2,0)
    aacraid: Host adapter abort request (0,0,3,0)
    aacraid: Host adapter reset request. SCSI hang ?
    aacraid: Host adapter abort request (0,0,0,0)

Signed-Off-By: Mathias Urlichs <matthias@urlichs.de>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 drivers/scsi/aacraid/aacraid.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index cdbdec9..0d5d036 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -24,7 +24,7 @@
 #define AAC_MAX_LUN		(8)
 
 #define AAC_MAX_HOSTPHYSMEMPAGES (0xfffff)
-#define AAC_MAX_32BIT_SGBCOUNT	((unsigned short)256)
+#define AAC_MAX_32BIT_SGBCOUNT	((unsigned short)127)
 
 /*
  * These macros convert from physical channels to virtual channels
-- 
1.6.3.rc3.199.g24398

