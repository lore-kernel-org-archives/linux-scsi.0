From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 5/7] iscsi-target: Fix iscsit_map_iovec cur_len + data_offset breakage
Date: Fri,  3 Jun 2011 18:18:16 -0700
Message-ID: <1307150298-23921-6-git-send-email-nab@linux-iscsi.org>
References: <1307150298-23921-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm21-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.176]:40995
	"HELO nm21-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753896Ab1FDBTH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jun 2011 21:19:07 -0400
In-Reply-To: <1307150298-23921-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>, Christoph Hellwig <hch@lst.de>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes two length + offset releated bugs in the new iscsit_map_iovec().
The first is where cur_len was being calculated incorrectly for the case type
SCF_SCSI_CONTROL_NONSG_IO_CDB with an sg->offset non zero offset.

The second adds the missing pg_off to kmap() when setting iov_base
from sg_page() with the current scatterlist pointer.

It also converts iscsit_map_iovec() to use sg_next() instead of
incremented the scatterlist pointer following lib/scatterlist.h

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 6ebc247..d84d52b 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -696,7 +696,7 @@ static int iscsit_map_iovec(
 	u32 data_offset,
 	u32 data_length)
 {
-	u32 i;
+	u32 i = 0;
 	struct scatterlist *sg;
 	unsigned int page_off;
 
@@ -705,20 +705,20 @@ static int iscsit_map_iovec(
 	 * At this point, we also know each contains a page.
 	 */
 	sg = &cmd->t_mem_sg[data_offset / PAGE_SIZE];
-	page_off = (data_offset % PAGE_SIZE) + sg->offset;
+	page_off = (data_offset % PAGE_SIZE);
 
 	cmd->first_data_sg = sg;
 	cmd->first_data_sg_off = page_off;
 
-	i = 0;
 	while (data_length) {
-		u32 cur_len = min_t(u32, data_length, (sg[i].length - page_off));
+		u32 cur_len = min_t(u32, data_length, sg->length - page_off);
 
-		iov[i].iov_base = kmap(sg_page(&sg[i]));
+		iov[i].iov_base = kmap(sg_page(sg)) + sg->offset + page_off;
 		iov[i].iov_len = cur_len;
 
 		data_length -= cur_len;
 		page_off = 0;
+		sg = sg_next(sg);
 		i++;
 	}
 
-- 
1.7.2.5

