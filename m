From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 0/4] Use of new scsi_allocate_command
Date: Thu, 01 May 2008 18:13:13 +0300
Message-ID: <4819DE09.4080800@panasas.com>
References: <4819C9DB.60104@panasas.com> <1209651854.3067.8.camel@localhost.localdomain> <4819DA39.70505@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:27989 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757571AbYEAPNd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 May 2008 11:13:33 -0400
In-Reply-To: <4819DA39.70505@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>, USB list <linux-usb@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, linux-scsi <linux-scsi@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>

On Thu, May 01 2008 at 17:56 +0300, Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
> ---
> From: Boaz Harrosh <bharrosh@panasas.com>
> Subject: [PATCH 4/4] gdth: Use scsi_allocate_command for private command allocation
> 
> In gdth_execute() use scsi_allocate_command for allocation of
> a command. To be insulated from future scsi_cmnd construction
> considerations.
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> ---
<snip>

Rrrr wrong patch sorry for the noise. Here is a compiling one

---
From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH] gdth: Use scsi_get_command for private command allocation

In gdth_execute() use scsi_get_command for allocation of
a command. To be insulated from future scsi_cmnd construction
considerations.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/gdth.c |   13 +++----------
 1 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 35ad3bf..3cfbab6 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -447,17 +447,10 @@ int gdth_execute(gdth_ha_str *ha, gdth_cmd_str *gdtcmd, char *cmnd,
     DECLARE_COMPLETION_ONSTACK(wait);
     int rval;
 
-    scp = kzalloc(sizeof(*scp), GFP_KERNEL);
+    scp = scsi_get_command(ha->sdev, GFP_KERNEL);
     if (!scp)
         return -ENOMEM;
 
-    scp->sense_buffer = kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_KERNEL);
-    if (!scp->sense_buffer) {
-	kfree(scp);
-	return -ENOMEM;
-    }
-
-    scp->device = ha->sdev;
     memset(&cmndinfo, 0, sizeof(cmndinfo));
 
     /* use request field to save the ptr. to completion struct. */
@@ -477,8 +470,8 @@ int gdth_execute(gdth_ha_str *ha, gdth_cmd_str *gdtcmd, char *cmnd,
     rval = cmndinfo.status;
     if (info)
         *info = cmndinfo.info;
-    kfree(scp->sense_buffer);
-    kfree(scp);
+
+    scsi_put_command(scp);
     return rval;
 }
 
-- 
1.5.3.3

