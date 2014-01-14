From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] bfa: set correct command return code
Date: Tue, 14 Jan 2014 10:26:25 +0100
Message-ID: <1389691585-84227-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48556 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbaANJ01 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Jan 2014 04:26:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Vijaya Mohan Guvva <vmohan@brocade.com>, Hannes Reinecke <hare@suse.de>

For various error conditions the bfa driver just returns
'DID_ERROR', which carries no information at all about the
actual source of error.
This patch updates the error handling to return a correct
error code, depending on the type of error occurred.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/bfa/bfad_im.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 9967f9c..f067332 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -73,9 +73,14 @@ bfa_cb_ioim_done(void *drv, struct bfad_ioim_s *dio,
 
 		break;
 
-	case BFI_IOIM_STS_ABORTED:
 	case BFI_IOIM_STS_TIMEDOUT:
+		host_status = DID_TIME_OUT;
+		cmnd->result = ScsiResult(host_status, 0);
+		break;
 	case BFI_IOIM_STS_PATHTOV:
+		host_status = DID_TRANSPORT_DISRUPTED;
+		cmnd->result = ScsiResult(host_status, 0);
+		break;
 	default:
 		host_status = DID_ERROR;
 		cmnd->result = ScsiResult(host_status, 0);
-- 
1.7.12.4

