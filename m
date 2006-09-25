From: akpm@osdl.org
Subject: [patch 22/28] Signdness issue in drivers/scsi/osst.c
Date: Mon, 25 Sep 2006 16:59:08 -0700
Message-ID: <200609252359.k8PNx8TT003522@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:42171 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751763AbWIYX7P (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Sep 2006 19:59:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, snakebyte@gmx.de, osst@riede.org

From: Eric Sesterhenn <snakebyte@gmx.de>

another signdness warning from gcc 4.1

drivers/scsi/osst.c:5154: warning: comparison of unsigned expression < 0 is always false

The problem is that blk is defined as unsigned, but all usages of it are
normal int cases.  osst_get_frame_position() and osst_get_sector() return ints
and can return negative values.  If blk stays an unsigned int, the error check
is useless.

Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>
Cc: Willem Riede <osst@riede.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/osst.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/scsi/osst.c~signedness-issue-in-drivers-scsi-osstc drivers/scsi/osst.c
--- a/drivers/scsi/osst.c~signedness-issue-in-drivers-scsi-osstc
+++ a/drivers/scsi/osst.c
@@ -4843,8 +4843,7 @@ static int os_scsi_tape_close(struct ino
 static int osst_ioctl(struct inode * inode,struct file * file,
 	 unsigned int cmd_in, unsigned long arg)
 {
-	int		      i, cmd_nr, cmd_type, retval = 0;
-	unsigned int	      blk;
+	int		      i, cmd_nr, cmd_type, blk, retval = 0;
 	struct st_modedef   * STm;
 	struct st_partstat  * STps;
 	struct osst_request * SRpnt = NULL;
_
