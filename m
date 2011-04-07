From: Jesper Juhl <jj@chaosbits.net>
Subject: [PATCH] SCSI, target, loopback: Fix memory leak in
 tcm_loop_make_scsi_hba()
Date: Thu, 7 Apr 2011 21:14:27 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1104072108370.1538@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: James Bottomley <James.Bottomley@suse.de>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

There is a memory leak in tcm_loop_make_scsi_hba().

If all the strstr() calls return NULL and we end up at 
  return ERR_PTR(-EINVAL);
then we'll be leaking the memory previously allocated to tl_hba as that 
variable goes out of scope.

This patch fixes the leak.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 tcm_loop.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

  compile tested only.

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index aed4e46..c4f81ec 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -1330,7 +1330,8 @@ struct se_wwn *tcm_loop_make_scsi_hba(
 
 	printk(KERN_ERR "Unable to locate prefix for emulated Target Port:"
 			" %s\n", name);
-	return ERR_PTR(-EINVAL);
+	ret = -EINVAL;
+	goto out;
 
 check_len:
 	if (strlen(name) > TL_WWN_ADDR_LEN) {


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.
