From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 2/4] libosd: Free resources in reverse order of allocation
Date: Tue, 19 Oct 2010 14:21:34 +0200
Message-ID: <1287490894-23954-1-git-send-email-bharrosh@panasas.com>
References: <4CBD8CAB.2030207@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og113.obsmtp.com ([64.18.0.26]:43621 "HELO
	exprod5og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758464Ab0JSMVh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Oct 2010 08:21:37 -0400
In-Reply-To: <4CBD8CAB.2030207@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, John Chandy <john.chandy@uconn.edu>, open-osd <osd-dev@open-osd.org>, linux-scsi <linux-scsi@vger.kernel.org>

At osd_end_request first free the request that might
point to pages, then free these pages. In reverse order
of allocation. For now it's just anal neatness. When we'll
use mempools It'll also pay in performance.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/osd/osd_initiator.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index 771ab12..acbdcb6 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -452,10 +452,6 @@ void osd_end_request(struct osd_request *or)
 {
 	struct request *rq = or->request;
 
-	_osd_free_seg(or, &or->set_attr);
-	_osd_free_seg(or, &or->enc_get_attr);
-	_osd_free_seg(or, &or->get_attr);
-
 	if (rq) {
 		if (rq->next_rq) {
 			_put_request(rq->next_rq);
@@ -464,6 +460,11 @@ void osd_end_request(struct osd_request *or)
 
 		_put_request(rq);
 	}
+
+	_osd_free_seg(or, &or->get_attr);
+	_osd_free_seg(or, &or->enc_get_attr);
+	_osd_free_seg(or, &or->set_attr);
+
 	_osd_request_free(or);
 }
 EXPORT_SYMBOL(osd_end_request);
-- 
1.7.2.3

