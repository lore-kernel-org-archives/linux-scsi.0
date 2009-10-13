From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 3/5] zfcp: Warn about storage devices with broken PLOGI data
Date: Tue, 13 Oct 2009 10:44:09 +0200
Message-ID: <20091013084945.818781000@de.ibm.com>
References: <20091013084406.630890000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.17.161]:54891 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933802AbZJMIuY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Oct 2009 04:50:24 -0400
Content-Disposition: inline; filename=713-zfcp-broken-plogi.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

After opening a remote port zfcp checks if the WWPN returned in the
PLOGI maches the WWPN of the port that should have been opened. On a
mismatch zfcp assumes that the DID just changed, queries the FC
nameserver and tries again. If the situation persists the erp will
give up.

With this strategy, if the remote port always returns the wrong PLOGI
data, the remote port will not be opened. Introduce a warning, so that
the system administrator knows why the remote port is not being opened
and to have a pointer to investigate the problem on the storage
system.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fsf.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/s390/scsi/zfcp_fsf.c	2009-10-12 09:56:22.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2009-10-12 09:56:27.000000000 +0200
@@ -1475,9 +1475,16 @@ static void zfcp_fsf_open_port_handler(s
 		plogi = (struct fsf_plogi *) req->qtcb->bottom.support.els;
 		if (req->qtcb->bottom.support.els1_length >=
 		    FSF_PLOGI_MIN_LEN) {
-			if (plogi->serv_param.wwpn != port->wwpn)
+			if (plogi->serv_param.wwpn != port->wwpn) {
 				port->d_id = 0;
-			else {
+				dev_warn(&port->adapter->ccw_device->dev,
+					 "A port opened with WWPN 0x%016Lx "
+					 "returned data that identifies it as "
+					 "WWPN 0x%016Lx\n",
+					 (unsigned long long) port->wwpn,
+					 (unsigned long long)
+					  plogi->serv_param.wwpn);
+			} else {
 				port->wwnn = plogi->serv_param.wwnn;
 				zfcp_fc_plogi_evaluate(port, plogi);
 			}

