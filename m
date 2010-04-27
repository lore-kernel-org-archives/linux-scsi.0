From: akpm@linux-foundation.org
Subject: [patch 09/28] drivers/message: move dereference after NULL test
Date: Tue, 27 Apr 2010 14:22:54 -0700
Message-ID: <201004272122.o3RLMs6K020798@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55834 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757153Ab0D0V3E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Apr 2010 17:29:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, julia@diku.dk, James.Bottomley@suse.de, kashyap.desai@lsi.com

From: Julia Lawall <julia@diku.dk>

If the NULL test on dev->i2o_dev or i2o_dev is needed, then the dereference
should be after the NULL test.

A simplified version of the semantic match that detects this problem is as
follows (http://coccinelle.lip6.fr/):

// <smpl>
@match exists@
expression x, E;
identifier fld;
@@

* x->fld
  ... when != \(x = E\|&x\)
* x == NULL
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: James Bottomley <James.Bottomley@suse.de>
Cc: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/i2o/i2o_block.c |    3 ++-
 drivers/message/i2o/i2o_scsi.c  |    3 +--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/message/i2o/i2o_block.c~drivers-message-move-dereference-after-null-test drivers/message/i2o/i2o_block.c
--- a/drivers/message/i2o/i2o_block.c~drivers-message-move-dereference-after-null-test
+++ a/drivers/message/i2o/i2o_block.c
@@ -712,7 +712,7 @@ static int i2o_block_transfer(struct req
 {
 	struct i2o_block_device *dev = req->rq_disk->private_data;
 	struct i2o_controller *c;
-	u32 tid = dev->i2o_dev->lct_data.tid;
+	u32 tid;
 	struct i2o_message *msg;
 	u32 *mptr;
 	struct i2o_block_request *ireq = req->special;
@@ -728,6 +728,7 @@ static int i2o_block_transfer(struct req
 		goto exit;
 	}
 
+	tid = dev->i2o_dev->lct_data.tid;
 	c = dev->i2o_dev->iop;
 
 	msg = i2o_msg_get(c);
diff -puN drivers/message/i2o/i2o_scsi.c~drivers-message-move-dereference-after-null-test drivers/message/i2o/i2o_scsi.c
--- a/drivers/message/i2o/i2o_scsi.c~drivers-message-move-dereference-after-null-test
+++ a/drivers/message/i2o/i2o_scsi.c
@@ -528,7 +528,6 @@ static int i2o_scsi_queuecommand(struct 
 	 *      Do the incoming paperwork
 	 */
 	i2o_dev = SCpnt->device->hostdata;
-	c = i2o_dev->iop;
 
 	SCpnt->scsi_done = done;
 
@@ -538,7 +537,7 @@ static int i2o_scsi_queuecommand(struct 
 		done(SCpnt);
 		goto exit;
 	}
-
+	c = i2o_dev->iop;
 	tid = i2o_dev->lct_data.tid;
 
 	osm_debug("qcmd: Tid = %03x\n", tid);
_
