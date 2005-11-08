From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 8/10] st must check phys and hw segments limits now
Date: Tue, 08 Nov 2005 04:06:51 -0600
Message-ID: <1131444412.23111.69.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:10911 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932503AbVKHKHl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2005 05:07:41 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de, linux-scsi@vger.kernel.org

We have two segments limitations. Previously
st made its own scatterlists that got sent to LLDs
so it could ignore max_phys_segments.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 2d8592d..5e61e48 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3889,7 +3889,8 @@ static int st_probe(struct device *dev)
 		return -ENODEV;
 	}
 
-	i = SDp->host->sg_tablesize;
+	i = min(SDp->request_queue->max_hw_segments,
+		SDp->request_queue->max_phys_segments);
 	if (st_max_sg_segs < i)
 		i = st_max_sg_segs;
 	buffer = new_tape_buffer(1, (SDp->host)->unchecked_isa_dma, i);


