From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] fix the poll method of bsg file operations in Block layer
 SCSI generic driver
Date: Wed, 10 Nov 2010 21:58:52 +0800
Message-ID: <AANLkTi=butKgG8VktAu0V12aBKTetOJwiGkcTLG_RZWB@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, "Zou, Yi" <yi.zou@intel.com>, Joe Eykholt <jeykholt@cisco.com>
List-Id: linux-scsi@vger.kernel.org

Though it looks like a typo, the check for POLLOUT is computed incorrectly.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/block/bsg.c	2010-09-13 07:07:38.000000000 +0800
+++ b/block/bsg.c	2010-11-10 21:40:30.000000000 +0800
@@ -874,6 +874,8 @@ static unsigned int bsg_poll(struct file
 	if (!list_empty(&bd->done_list))
 		mask |= POLLIN | POLLRDNORM;
 	if (bd->queued_cmds >= bd->max_queue)
+		;
+	else
 		mask |= POLLOUT;
 	spin_unlock_irq(&bd->lock);
