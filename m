From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: [PATCH 2/2] SCSI tape fixes: remove f_pos handling
Date: Sat, 12 Mar 2005 19:08:06 +0200 (EET)
Message-ID: <Pine.LNX.4.61.0503121906090.6875@kai.makisara.local>
References: <Pine.LNX.4.61.0503121903010.6875@kai.makisara.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Received: from fep32-0.kolumbus.fi ([193.229.0.63]:37272 "EHLO
	fep32-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S261945AbVCLRGp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Mar 2005 12:06:45 -0500
Received: from kai.makisara.local ([193.229.226.111])
          by fep32-app.kolumbus.fi with ESMTP
          id <20050312170644.VUAJ13446.fep32-app.kolumbus.fi@kai.makisara.local>
          for <linux-scsi@vger.kernel.org>; Sat, 12 Mar 2005 19:06:44 +0200
In-Reply-To: <Pine.LNX.4.61.0503121903010.6875@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch applies over the previous patch in this thread. The patch removes
updating filp->f_pos. It has been dead code since 2.6.8 and nobody has missed
it.

Signed-off-by: Kai Makisara <kai.makisara@kolumbus.fi>

--- linux-2.6.11-bk7-k2/drivers/scsi/st.c	2005-03-12 13:52:30.000000000 +0200
+++ linux-2.6.11-bk7-k3/drivers/scsi/st.c	2005-03-12 18:11:11.000000000 +0200
@@ -1156,9 +1156,7 @@ static int st_flush(struct file *filp)
 	if (STps->rw == ST_WRITING && !STp->pos_unknown) {
 		struct st_cmdstatus *cmdstatp = &STp->buffer->cmdstat;
 
-                DEBC(printk(ST_DEB_MSG "%s: File length %lld bytes.\n",
-                            name, (long long)filp->f_pos);
-                     printk(ST_DEB_MSG "%s: Async write waits %d, finished %d.\n",
+                DEBC(printk(ST_DEB_MSG "%s: Async write waits %d, finished %d.\n",
                             name, STp->nbr_waits, STp->nbr_finished);
 		)
 
@@ -1520,7 +1518,6 @@ st_write(struct file *filp, const char _
 			}
 		}
 		count -= do_count;
-		filp->f_pos += do_count;
 		b_point += do_count;
 
 		async_write = STp->block_size == 0 && !STbp->do_dio &&
@@ -1580,7 +1577,6 @@ st_write(struct file *filp, const char _
 					undone = 0;
 				if (STp->block_size != 0)
 					undone *= STp->block_size;
-				filp->f_pos -= undone;
 				if (undone <= do_count) {
 					/* Only data from this write is not written */
 					count += undone;
@@ -1629,7 +1625,6 @@ st_write(struct file *filp, const char _
 					}
 				}
 			} else {
-				filp->f_pos -= do_count;
 				count += do_count;
 				STps->drv_block = (-1);		/* Too cautious? */
 				retval = (-EIO);
@@ -1958,7 +1953,6 @@ st_read(struct file *filp, char __user *
 					goto out;
 				}
 			}
-			filp->f_pos += transfer;
 			buf += transfer;
 			total += transfer;
 		}
