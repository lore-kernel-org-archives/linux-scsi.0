From: michaelc@cs.wisc.edu
Subject: [PATCH 1/1] libiscsi_tcp: use kmap in xmit path
Date: Thu, 17 Mar 2011 16:22:17 -0500
Message-ID: <1300396937-11869-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755473Ab1CQVV4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Mar 2011 17:21:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

The xmit path can sleep with a page kmapped in the network
xmit code while it waits for space to open up, so we have to use
kmap instead of kmap atomic in that path.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi_tcp.c |   15 +++++++++++++--
 include/scsi/libiscsi_tcp.h |    1 +
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index 8eeb39f..e98ae33 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -132,14 +132,25 @@ static void iscsi_tcp_segment_map(struct iscsi_segment *segment, int recv)
 	if (page_count(sg_page(sg)) >= 1 && !recv)
 		return;
 
-	segment->sg_mapped = kmap_atomic(sg_page(sg), KM_SOFTIRQ0);
+	if (recv) {
+		segment->atomic_mapped = true;
+		segment->sg_mapped = kmap_atomic(sg_page(sg), KM_SOFTIRQ0);
+	} else {
+		segment->atomic_mapped = false;
+		/* the xmit path can sleep with the page mapped so use kmap */
+		segment->sg_mapped = kmap(sg_page(sg));
+	}
+
 	segment->data = segment->sg_mapped + sg->offset + segment->sg_offset;
 }
 
 void iscsi_tcp_segment_unmap(struct iscsi_segment *segment)
 {
 	if (segment->sg_mapped) {
-		kunmap_atomic(segment->sg_mapped, KM_SOFTIRQ0);
+		if (segment->atomic_mapped)
+			kunmap_atomic(segment->sg_mapped, KM_SOFTIRQ0);
+		else
+			kunmap(sg_page(segment->sg));
 		segment->sg_mapped = NULL;
 		segment->data = NULL;
 	}
diff --git a/include/scsi/libiscsi_tcp.h b/include/scsi/libiscsi_tcp.h
index 741ae7e..e6b9fd2 100644
--- a/include/scsi/libiscsi_tcp.h
+++ b/include/scsi/libiscsi_tcp.h
@@ -47,6 +47,7 @@ struct iscsi_segment {
 	struct scatterlist	*sg;
 	void			*sg_mapped;
 	unsigned int		sg_offset;
+	bool			atomic_mapped;
 
 	iscsi_segment_done_fn_t	*done;
 };
-- 
1.7.2.3

