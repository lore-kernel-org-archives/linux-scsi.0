From: Swen Schillig <swen@vnet.ibm.com>
Subject: [PATCH 2/3] zfcp: NULL vs 0 usage
Date: Wed, 18 Jul 2007 10:55:10 +0200
Message-ID: <200707181055.10235.swen@vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:60909 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611AbXGRIyV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jul 2007 04:54:21 -0400
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate7.uk.ibm.com (8.13.8/8.13.8) with ESMTP id l6I8sKd8028996
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jul 2007 08:54:20 GMT
Received: from d06av02.portsmouth.uk.ibm.com (d06av02.portsmouth.uk.ibm.com [9.149.37.228])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l6I8sKmt2359510
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jul 2007 09:54:20 +0100
Received: from d06av02.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av02.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6I8sGCj024257
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jul 2007 09:54:17 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org, heiko.carstens@de.ibm.com

Subject: [PATCH] zfcp: NULL vs 0 usage

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Get rid of two 'warning: Using plain integer as NULL pointer'.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c |    9 +++------
 drivers/s390/scsi/zfcp_fsf.c |    2 +-
 2 files changed, 4 insertions(+), 7 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_aux.c linux-2.6-patched/drivers/s390/scsi/zfcp_aux.c
--- linux-2.6/drivers/s390/scsi/zfcp_aux.c	2007-07-18 10:27:48.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_aux.c	2007-07-18 10:28:25.000000000 +0200
@@ -1526,15 +1526,12 @@ zfcp_gid_pn_buffers_alloc(struct zfcp_gi
  * zfcp_gid_pn_buffers_free - free buffers for GID_PN nameserver request
  * @gid_pn: pointer to struct zfcp_gid_pn_data which has to be freed
  */
-static void
-zfcp_gid_pn_buffers_free(struct zfcp_gid_pn_data *gid_pn)
+static void zfcp_gid_pn_buffers_free(struct zfcp_gid_pn_data *gid_pn)
 {
-        if ((gid_pn->ct.pool != 0))
+	if (gid_pn->ct.pool)
 		mempool_free(gid_pn, gid_pn->ct.pool);
 	else
-                kfree(gid_pn);
-
-	return;
+		kfree(gid_pn);
 }
 
 /**
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fsf.c linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c
--- linux-2.6/drivers/s390/scsi/zfcp_fsf.c	2007-07-09 01:32:17.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c	2007-07-18 10:28:25.000000000 +0200
@@ -1930,7 +1930,7 @@ static int zfcp_fsf_send_els_handler(str
 skip_fsfstatus:
 	send_els->status = retval;
 
-	if (send_els->handler != 0)
+	if (send_els->handler)
 		send_els->handler(send_els->handler_data);
 
 	return retval;
