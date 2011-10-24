From: Jesper Juhl <jj@chaosbits.net>
Subject: [PATCH] SCSI, pmcraid: Fix kmalloc() argument order in
 pmcraid_chr_ioctl()
Date: Tue, 25 Oct 2011 00:38:30 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1110250036370.19795@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
List-Id: linux-scsi@vger.kernel.org

The first argument to kmalloc() is the size, the second is
flags. pmcraid_chr_ioctl() gets this wrong and swaps the
arguments. This patch corrects the mistake.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/scsi/pmcraid.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

 compile tested only.

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index d079f9a..da19bdf 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4103,7 +4103,7 @@ static long pmcraid_chr_ioctl(
 	struct pmcraid_ioctl_header *hdr = NULL;
 	int retval = -ENOTTY;
 
-	hdr = kmalloc(GFP_KERNEL, sizeof(struct pmcraid_ioctl_header));
+	hdr = kmalloc(sizeof(struct pmcraid_ioctl_header), GFP_KERNEL);
 
 	if (!hdr) {
 		pmcraid_err("faile to allocate memory for ioctl header\n");
-- 
1.7.7


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.
