From: Jesper Juhl <jj@chaosbits.net>
Subject: [PATCH] SCSI: pmcraid: Fix swapped kmalloc() arguments
Date: Sun, 10 Jul 2011 23:55:57 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1107102353410.2818@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

pmcraid_chr_ioctl() contains a kmalloc() call where the arguments are
switched, fix that.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/scsi/pmcraid.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index ee161c6..cb2b4e1 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4099,8 +4099,7 @@ static long pmcraid_chr_ioctl(
 	struct pmcraid_ioctl_header *hdr = NULL;
 	int retval = -ENOTTY;
 
-	hdr = kmalloc(GFP_KERNEL, sizeof(struct pmcraid_ioctl_header));
-
+	hdr = kmalloc(sizeof(struct pmcraid_ioctl_header), GFP_KERNEL);
 	if (!hdr) {
 		pmcraid_err("faile to allocate memory for ioctl header\n");
 		return -ENOMEM;
-- 
1.7.6



PS. I'm not subscribed to linux-scsi, so please CC: me on replies.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.
