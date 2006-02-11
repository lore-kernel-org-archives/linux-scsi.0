From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH 4/4] zfcp: fix: avoid race between fc_remote_port_add and scsi_add_device
Date: Sat, 11 Feb 2006 01:43:55 +0100
Message-ID: <20060211004355.GA17355@lion28.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:52248 "EHLO
	mtagate4.de.ibm.com") by vger.kernel.org with ESMTP id S932286AbWBKAok
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Feb 2006 19:44:40 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate4.de.ibm.com (8.12.10/8.12.10) with ESMTP id k1B0idVV154758
	for <linux-scsi@vger.kernel.org>; Sat, 11 Feb 2006 00:44:39 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id k1B0ieC3214574
	for <linux-scsi@vger.kernel.org>; Sat, 11 Feb 2006 01:44:40 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id k1B0ic4H019589
	for <linux-scsi@vger.kernel.org>; Sat, 11 Feb 2006 01:44:38 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>

Flush workqueue of a scsi host after a remote port for that host
is registered at the fc transport class. Otherwise immediate
registration of a scsi device on that host is racy.

Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>

---

 drivers/s390/scsi/zfcp_erp.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

8ef4d7bd844a9ed4806bbfc18313c56045486608
diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
index 8ed6fcb..e3c4bdd 100644
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -3415,6 +3415,8 @@ zfcp_erp_action_cleanup(int action, stru
 						"(adapter %s, wwpn=0x%016Lx)\n",
 						zfcp_get_busid_by_port(port),
 						port->wwpn);
+			else
+				scsi_flush_work(adapter->scsi_host);
 		}
 		zfcp_port_put(port);
 		break;
-- 
0.99.9n-g5a22
