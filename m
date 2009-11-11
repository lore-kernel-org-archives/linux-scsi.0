From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 07/17] hpsa: Factor out command submission sequence
Date: Wed, 11 Nov 2009 10:50:58 -0600
Message-ID: <20091111165058.17754.79396.stgit@beardog.cce.hp.com>
References: <20091111164803.17754.11900.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0014.houston.hp.com ([15.201.24.17]:25254 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757697AbZKKQtd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Nov 2009 11:49:33 -0500
In-Reply-To: <20091111164803.17754.11900.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, scameron@beardog.cce.hp.com, mikem@beardog.cce.hp.com

hpsa: Factor out command submission sequence.  There
are a few places where the same sequence of statements
occurs to submit and wait for the completion of a command.
Factor these out into a separate function.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---

 drivers/scsi/hpsa.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index d5a795e..81fbbff 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2086,7 +2086,6 @@ static int hpsa_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 	struct CommandList *c;
 	char *buff = NULL;
 	union u64bit temp64;
-	DECLARE_COMPLETION_ONSTACK(wait);
 
 	if (!argp)
 		return -EINVAL;
@@ -2144,9 +2143,7 @@ static int hpsa_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 		c->SG[0].Len = iocommand.buf_size;
 		c->SG[0].Ext = 0; /* we are not chaining*/
 	}
-	c->waiting = &wait;
-	enqueue_cmd_and_start_io(h, c);
-	wait_for_completion(&wait);
+	hpsa_scsi_do_simple_cmd_core(h, c);
 
 	/* unlock the buffers from DMA */
 	temp64.val32.lower = c->SG[0].Addr.lower;
@@ -2186,7 +2183,6 @@ static int hpsa_big_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 	BYTE sg_used = 0;
 	int status = 0;
 	int i;
-	DECLARE_COMPLETION_ONSTACK(wait);
 	__u32 left;
 	__u32 sz;
 	BYTE __user *data_ptr;
@@ -2280,9 +2276,7 @@ static int hpsa_big_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 			c->SG[i].Ext = 0;
 		}
 	}
-	c->waiting = &wait;
-	enqueue_cmd_and_start_io(h, c);
-	wait_for_completion(&wait);
+	hpsa_scsi_do_simple_cmd_core(h, c);
 	/* unlock the buffers from DMA */
 	for (i = 0; i < sg_used; i++) {
 		temp64.val32.lower = c->SG[i].Addr.lower;

