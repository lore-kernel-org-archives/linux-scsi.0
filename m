From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] scsi: dc395x.c:  Fix for possible null pointer dereference
Date: Sun, 18 May 2014 18:09:09 +0200
Message-ID: <1400429349-11040-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>, Ali Akcaagac <aliakc@web.de>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, Jamie Lenehan <lenehan@twibble.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, dc395x@twibble.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

There is otherwise a risk of a possible null pointer dereference.

Was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/dc395x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 83d9bf6..0d86bc7 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -2637,7 +2637,7 @@ static struct ScsiReqBlk *msgin_qtag(struct AdapterCtlBlk *acb,
 	struct ScsiReqBlk *srb = NULL;
 	struct ScsiReqBlk *i;
 	dprintkdbg(DBG_0, "msgin_qtag: (0x%p) tag=%i srb=%p\n",
-		   srb->cmd, tag, srb);
+		   srb ? srb->cmd : 0, tag, srb);
 
 	if (!(dcb->tag_mask & (1 << tag)))
 		dprintkl(KERN_DEBUG,
-- 
1.7.10.4
