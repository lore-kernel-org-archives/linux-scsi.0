From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: [PATCH] scsi disk: Reduce buffer size for vpd request
Date: Mon, 23 Sep 2013 14:47:32 +0200
Message-ID: <52403864.9020507@fastmail.fm>
References: <87r4ehfzhf.fsf@spindle.srvr.nix> <51F667C2.4020801@fastmail.fm> <87mwp5frdl.fsf@spindle.srvr.nix> <51F67959.2060803@fastmail.fm> <87fvuxdqes.fsf@spindle.srvr.nix> <yq1txjdhree.fsf@sermon.lab.mkp.net> <51F80167.1080004@fastmail.fm> <yq1zjt3h11y.fsf@sermon.lab.mkp.net> <51F94E8D.5040908@fastmail.fm> <51F95A2E.60805@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:58564 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab3IWNDS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Sep 2013 09:03:18 -0400
In-Reply-To: <51F95A2E.60805@fastmail.fm>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Nix <nix@esperi.org.uk>, nick.cheng@areca.com.tw, stable@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>

From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>

Somehow older areca firmware versions have issues with 
scsi_get_vpd_page() and a large buffer, the firmware
seems to crash and the scsi error-handler will start endless 
recovery retries.
Limiting the buf-size to 64-bytes fixes this issue with older
firmware versions (<1.49 for my controller).

Fixes a regression with areca controllers and older firmware versions
introduced by commit: 66c28f97120e8a621afd5aa7a31c4b85c547d33d

Reported-by: Nix <nix@esperi.org.uk>
Tested-by: Nix <nix@esperi.org.uk>
Signed-off-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
CC: stable@vger.kernel.org
Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

---
 drivers/scsi/sd.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index b58e8f8..09a599f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2644,13 +2644,16 @@ static void sd_read_write_same(struct scsi_disk *sdkp, unsigned char *buffer)
 	struct scsi_device *sdev = sdkp->device;
 
 	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, INQUIRY) < 0) {
+		/* too large values might cause issues with arcmsr */
+		int vpd_buf_len = 64;
+
 		sdev->no_report_opcodes = 1;
 
 		/* Disable WRITE SAME if REPORT SUPPORTED OPERATION
 		 * CODES is unsupported and the device has an ATA
 		 * Information VPD page (SAT).
 		 */
-		if (!scsi_get_vpd_page(sdev, 0x89, buffer, SD_BUF_SIZE))
+		if (!scsi_get_vpd_page(sdev, 0x89, buffer, vpd_buf_len))
 			sdev->no_write_same = 1;
 	}
 
