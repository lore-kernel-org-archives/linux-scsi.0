From: Oliver Neukum <oliver@neukum.org>
Subject: [PATCH 1/3] sd: SCSI error codes must not be returned to generic code
Date: Wed,  1 Aug 2012 16:44:08 +0200
Message-ID: <1343832250-24228-2-git-send-email-oliver@neukum.org>
References: <1343832250-24228-1-git-send-email-oliver@neukum.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out002.kontent.com ([81.88.40.216]:50420 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755155Ab2HAPAC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Aug 2012 11:00:02 -0400
In-Reply-To: <1343832250-24228-1-git-send-email-oliver@neukum.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org, hare@suse.de
Cc: Oliver Neukum <oliver@neukum.org>, Oliver Neukum <oneukum@suse.de>

sd_start_stop_device leaks SCSI specific error codes
to the generic driver code

Signed-off-by: Oliver Neukum <oneukum@suse.de>
---
 drivers/scsi/sd.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 4df73e5..cef06f5 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2830,7 +2830,11 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 			sd_print_sense_hdr(sdkp, &sshdr);
 	}
 
-	return res;
+	/* SCSI error codes must not go to the generic layer */
+	if (res)
+		return -EIO;
+
+	return 0;
 }
 
 /*
-- 
1.7.7

