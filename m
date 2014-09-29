From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 24/38] tracing: Add trace_seq_buffer_ptr() helper function
Date: Mon, 29 Sep 2014 13:58:53 +0200
Message-ID: <1411991947-130166-25-git-send-email-hare@suse.de>
References: <1411991947-130166-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59366 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753827AbaI2L7R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Sep 2014 07:59:17 -0400
In-Reply-To: <1411991947-130166-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>, Steven Rostedt <rostedt@goodmis.org>

There's several locations in the kernel that open code the calculation
of the next location in the trace_seq buffer. This is usually done with

  p->buffer + p->len

Instead of having this open coded, supply a helper function in the
header to do it for them. This function is called trace_seq_buffer_ptr().

Acked-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/firmware/efi/cper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
index 5b53d61..4fd9961 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -294,7 +294,7 @@ void cper_mem_err_pack(const struct cper_sec_mem_err *mem,
 const char *cper_mem_err_unpack(struct trace_seq *p,
 				struct cper_mem_err_compact *cmem)
 {
-	const char *ret = p->buffer + p->len;
+	const char *ret = trace_seq_buffer_ptr(p);
 
 	if (cper_mem_err_location(cmem, rcd_decode_str))
 		trace_seq_printf(p, "%s", rcd_decode_str);
-- 
1.8.5.2

