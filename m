From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: [RFC PATCH 06/10] scsi/sd: Delete extra scsi_show_extd_sense() in
 sd_print_sense_hdr()
Date: Fri, 08 Aug 2014 11:50:19 +0000
Message-ID: <20140808115019.6768.99063.stgit@yuno-kbuild.novalocal>
References: <20140808115004.6768.97014.stgit@yuno-kbuild.novalocal>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail9.hitachi.co.jp ([133.145.228.44]:45784 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756563AbaHHLuY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Aug 2014 07:50:24 -0400
In-Reply-To: <20140808115004.6768.97014.stgit@yuno-kbuild.novalocal>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, Doug Gilbert <dgilbert@interlog.com>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, Christoph Hellwig <hch@lst.de>

sd_print_sense_hdr() calls scsi_show_extd_sense(),
but scsi_print_sense_hdr() also calls scsi_show_extd_sense().
We can get same result, so we delete it.

Note:
Calling scsi_show_extd_sense() is introduced in fdd8b297.

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 drivers/scsi/sd.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8d7204a..22dd214 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3286,8 +3286,6 @@ static void sd_print_sense_hdr(struct scsi_disk *sdkp,
 			       struct scsi_sense_hdr *sshdr)
 {
 	scsi_print_sense_hdr(sdkp->device, sdkp->disk->disk_name, sshdr);
-	scsi_show_extd_sense(sdkp->device, sdkp->disk->disk_name,
-			     sshdr->asc, sshdr->ascq);
 }
 
 static void sd_print_result(struct scsi_disk *sdkp, int result)

