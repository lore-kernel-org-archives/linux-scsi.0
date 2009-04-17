From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 2/14 - 2nd post] mpt2sas: the sanity check in base_interrupt needs to be on dword boundary
Date: Fri, 17 Apr 2009 10:25:51 -0600
Message-ID: <20090417162549.GC7009@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chip3og62.obsmtp.com ([64.18.14.201]:58666 "EHLO
	chip3og62.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbZDQQYq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2009 12:24:46 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com

The poison sanity check on the reply_post_free register needs to be by 32bit,
not 64bit. The poison check is there because its possible that the driver read
the 1st 32bit before the 2nd 32bit has been written to by firmware.  In other
words, this handles race between driver reading the 64 bit register, and it
being dma'd across pci memory from controller firmware as two 32bit pci writes.

Signed-off-by: Eric Moore <eric.moore@lsi.com>

diff -uarpN a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c	2009-03-16 08:52:29.000000000 -0600
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c	2009-04-09 16:36:40.000000000 -0600
@@ -636,6 +636,14 @@ _base_unmask_interrupts(struct MPT2SAS_A
 static irqreturn_t
 _base_interrupt(int irq, void *bus_id)
 {
+	union reply_descriptor {
+		u64 word;
+		struct {
+			u32 low;
+			u32 high;
+		} u;
+	};
+	union reply_descriptor rd;
 	u32 post_index, post_index_next, completed_cmds;
 	u8 request_desript_type;
 	u16 smid;
@@ -656,7 +664,8 @@ _base_interrupt(int irq, void *bus_id)
 
 	completed_cmds = 0;
 	do {
-		if (ioc->reply_post_free[post_index].Words == ~0ULL)
+		rd.word = ioc->reply_post_free[post_index].Words;
+		if (rd.u.low == UINT_MAX || rd.u.high == UINT_MAX)
 			goto out;
 		reply = 0;
 		cb_idx = 0xFF;
@@ -721,7 +730,7 @@ _base_interrupt(int irq, void *bus_id)
 	for (i = 0 ; i < completed_cmds; i++) {
 		post_index = post_index_next;
 		/* poison the reply post descriptor */
-		ioc->reply_post_free[post_index_next].Words = ~0ULL;
+		ioc->reply_post_free[post_index_next].Words = ULLONG_MAX;
 		post_index_next = (post_index ==
 		    (ioc->reply_post_queue_depth - 1))
 		    ? 0 : post_index + 1;
@@ -3068,7 +3077,7 @@ _base_make_ioc_operational(struct MPT2SA
 
 	/* initialize Reply Post Free Queue */
 	for (i = 0; i < ioc->reply_post_queue_depth; i++)
-		ioc->reply_post_free[i].Words = ~0ULL;
+		ioc->reply_post_free[i].Words = ULLONG_MAX;
 
 	r = _base_send_ioc_init(ioc, VF_ID, sleep_flag);
 	if (r)
