From: Swen Schillig <swen@vnet.ibm.com>
Subject: [PATCH 1/4] zfcp: fix memory leak
Date: Wed, 8 Aug 2007 10:47:02 +0200
Message-ID: <200708081047.03139.swen@vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:1133 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755621AbXHHIpX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Aug 2007 04:45:23 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, heiko.carstens@de.ibm.com

From: Heiko Carstens <heiko.carstens@de.ibm.com>

fix memory leak.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
---

 drivers/s390/scsi/zfcp_scsi.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_scsi.c linux-2.6-patched/drivers/s390/scsi/zfcp_scsi.c
--- linux-2.6/drivers/s390/scsi/zfcp_scsi.c	2007-07-09 01:32:17.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_scsi.c	2007-08-08 10:14:01.000000000 +0200
@@ -764,7 +764,9 @@ zfcp_reset_fc_host_stats(struct Scsi_Hos
 		return;
 
 	ret = zfcp_fsf_exchange_port_data(NULL, adapter, data);
-	if (ret == 0) {
+	if (ret) {
+		kfree(data);
+	} else {
 		adapter->stats_reset = jiffies/HZ;
 		old_data = adapter->stats_reset_data;
 		adapter->stats_reset_data = data; /* finally freed in
