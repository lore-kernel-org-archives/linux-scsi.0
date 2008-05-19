From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 03/11] zfcp: Fix fsf_status_read return code handling
Date: Mon, 19 May 2008 12:17:39 +0200
Message-ID: <20080519101827.757041000@de.ibm.com>
References: <20080519101736.590943000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:29142 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831AbYESKSa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 May 2008 06:18:30 -0400
Content-Disposition: inline; filename=802-zfcp-read-return.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>, Martin Peschke <mp3@de.ibm.com>

From: Heiko Carstens <heiko.carstens@de.ibm.com>

If allocation of a status buffer failed the function incorrectly
returned 0 instead of -ENOMEM.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Peschke <mp3@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fsf.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fsf.c linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c
--- linux-2.6/drivers/s390/scsi/zfcp_fsf.c	2008-05-08 14:02:10.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c	2008-05-08 14:02:10.000000000 +0200
@@ -712,7 +712,7 @@ zfcp_fsf_status_read(struct zfcp_adapter
 	struct fsf_status_read_buffer *status_buffer;
 	unsigned long lock_flags;
 	volatile struct qdio_buffer_element *sbale;
-	int retval = 0;
+	int retval;
 
 	/* setup new FSF request */
 	retval = zfcp_fsf_req_create(adapter, FSF_QTCB_UNSOLICITED_STATUS,
@@ -731,12 +731,11 @@ zfcp_fsf_status_read(struct zfcp_adapter
         sbale[2].flags |= SBAL_FLAGS_LAST_ENTRY;
         fsf_req->sbale_curr = 2;
 
+	retval = -ENOMEM;
 	status_buffer =
 		mempool_alloc(adapter->pool.data_status_read, GFP_ATOMIC);
-	if (!status_buffer) {
-		ZFCP_LOG_NORMAL("bug: could not get some buffer\n");
+	if (!status_buffer)
 		goto failed_buf;
-	}
 	memset(status_buffer, 0, sizeof (struct fsf_status_read_buffer));
 	fsf_req->data = (unsigned long) status_buffer;
 

-- 
