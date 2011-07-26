From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/2] kernel.h: Add DIV_ROUND_UP_ULL usage
Date: Tue, 26 Jul 2011 07:10:24 +0000
Message-ID: <1311664225-20172-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:43697 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab1GZHeA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jul 2011 03:34:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>, Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@purestorage.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Add new DIV_ROUND_UP_ULL macro usage for 32-bit architectures requiring
unsigned long long division of sectors * dev_max_sectors.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 include/linux/kernel.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 953352a..016dcc9 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -56,6 +56,8 @@
 
 #define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
 #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
+#define DIV_ROUND_UP_ULL(ll,d) \
+	({ unsigned long long _tmp = (ll)+(d)-1; do_div(_tmp, d); _tmp; })
 
 /* The `const' in roundup() prevents gcc-3.3 from calling __divdi3 */
 #define roundup(x, y) (					\
-- 
1.7.2.5

