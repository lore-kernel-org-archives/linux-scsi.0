From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH RESEND 2/2] Drivers: scsi: storvsc: Don't pass ATA_16 command to the host
Date: Sun, 18 Mar 2012 17:12:43 -0700
Message-ID: <1332115963-26855-2-git-send-email-kys@microsoft.com>
References: <1332115915-26805-1-git-send-email-kys@microsoft.com>
 <1332115963-26855-1-git-send-email-kys@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1332115963-26855-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, virtualization@lists.osdl.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

The current Windows hosts don't handle the ATA_16 command and furthermore
return a generic error code after filtering the command on the host side.
For now filter the command on the guest side until the host is modified to
properly handle unsupported commands.

I would like to thank Jeff Garzik <jgpobox@gmail.com> and
Douglas Gilbert <dgilbert@interlog.com> for suggesting the correct approach
here.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 018c363..66e9bdd 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1233,9 +1233,21 @@ static bool storvsc_scsi_cmd_ok(struct scsi_cmnd *scmnd)
 	/*
 	 * smartd sends this command and the host does not handle
 	 * this. So, don't send it.
+	 * The current Windows hosts implement a subset of scsi commands
+	 * and for the commands that are not implemented, the host filters
+	 * them and returns a generic failure SRB status. I have been in
+	 * discussions with the Windows team to return the appropriate SRB
+	 * status code for unsupported scsi commands and while they have
+	 * agreed to implement this, it is not clear when this change will be
+	 * available. Consequently, filtering the command before submitting it
+	 * to the host is a resonable interim solution.
 	 */
 	case SET_WINDOW:
-		scmnd->result = ILLEGAL_REQUEST << 16;
+	case ATA_16:
+		scmnd->result = ((DRIVER_SENSE << 24) |
+				SAM_STAT_CHECK_CONDITION);
+		scsi_build_sense_buffer(0, scmnd->sense_buffer,
+					ILLEGAL_REQUEST, 0x20, 0);
 		allowed = false;
 		break;
 	default:
-- 
1.7.4.1
