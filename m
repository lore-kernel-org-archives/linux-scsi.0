From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 4/4] gdth: Use scsi_allocate_command for private command allocation
Date: Thu, 01 May 2008 17:06:14 +0300
Message-ID: <4819CE56.9010906__41876.4975540855$1209650843$gmane$org@panasas.com>
References: <4819C9DB.60104@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:7587 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751006AbYEAOGX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 May 2008 10:06:23 -0400
In-Reply-To: <4819C9DB.60104@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, USB list <linux-usb@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>
Cc: Andi Kleen <andi@firstfloor.org>


In gdth_execute() use scsi_allocate_command for allocation of
a command. To be insulated from future scsi_cmnd construction
considerations.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/gdth.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 35ad3bf..7778373 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -447,16 +447,10 @@ int gdth_execute(gdth_ha_str *ha, gdth_cmd_str *gdtcmd, char *cmnd,
     DECLARE_COMPLETION_ONSTACK(wait);
     int rval;
 
-    scp = kzalloc(sizeof(*scp), GFP_KERNEL);
+    scp = scsi_allocate_command(GFP_KERNEL);
     if (!scp)
         return -ENOMEM;
 
-    scp->sense_buffer = kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_KERNEL);
-    if (!scp->sense_buffer) {
-	kfree(scp);
-	return -ENOMEM;
-    }
-
     scp->device = ha->sdev;
     memset(&cmndinfo, 0, sizeof(cmndinfo));
 
@@ -477,8 +471,8 @@ int gdth_execute(gdth_ha_str *ha, gdth_cmd_str *gdtcmd, char *cmnd,
     rval = cmndinfo.status;
     if (info)
         *info = cmndinfo.info;
-    kfree(scp->sense_buffer);
-    kfree(scp);
+
+    scsi_free_command(scp);
     return rval;
 }
 
-- 
1.5.3.3


