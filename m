From: Jesper Juhl <jj@chaosbits.net>
Subject: [PATCH 17/26] [SCSI] aic94xx: Get rid of redundant NULL check before
 release_firmware() call
Date: Mon, 9 Apr 2012 22:51:30 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1204092227391.13925@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1204092157340.13925@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1204092157340.13925@swampdragon.chaosbits.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

release_firmware() checks for NULL pointers internally, so checking
before calling the function is redundant.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/scsi/aic94xx/aic94xx_seq.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_seq.c b/drivers/scsi/aic94xx/aic94xx_seq.c
index 390168f..5fdca93 100644
--- a/drivers/scsi/aic94xx/aic94xx_seq.c
+++ b/drivers/scsi/aic94xx/aic94xx_seq.c
@@ -1228,8 +1228,7 @@ static int asd_seq_start_lseq(struct asd_ha_struct *asd_ha, int lseq)
 
 int asd_release_firmware(void)
 {
-	if (sequencer_fw)
-		release_firmware(sequencer_fw);
+	release_firmware(sequencer_fw);
 	return 0;
 }
 
-- 
1.7.10


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.
