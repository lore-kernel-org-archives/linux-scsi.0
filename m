From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH] [1/8] zfcp: fix wrong handling of failed requests for GID_PN command
Date: Mon, 13 Jun 2005 13:13:45 +0200
Message-ID: <20050613111345.GA8998@lion28.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.29.150]:1976 "EHLO
	mtagate1.de.ibm.com") by vger.kernel.org with ESMTP id S261444AbVFMLNp
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Jun 2005 07:13:45 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate1.de.ibm.com (8.12.10/8.12.10) with ESMTP id j5DBDiFu159788
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2005 11:13:44 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j5DBDi2H167310
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2005 13:13:44 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id j5DBDhb5022384
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2005 13:13:43 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>

This is patch 1 of 8 in a series of zfcp bug fixes.  Patches are based
on 2.6.12-rc6 plus "remove flags_dump feature"-patch from June, 10th.

This one fixes the handling of failed requests for GID_PN nameserver
command:
Set ZFCP_STATUS_PORT_INVALID_WWPN only if indicated by response
payload for GID_PN nameserver command and not if fsf request fails.


Regards,

Andreas

 
zfcp: fix wrong handling of failed requests for GID_PN command

Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>

diff -u linux-2.6.12-rc6/drivers/s390/scsi-orig/zfcp_aux.c linux-2.6.12-rc6/drivers/s390/scsi/zfcp_aux.c
--- linux-2.6.12-rc6/drivers/s390/scsi-orig/zfcp_aux.c	2005-06-11 22:04:32.062612336 +0200
+++ linux-2.6.12-rc6/drivers/s390/scsi/zfcp_aux.c	2005-06-11 22:05:03.961762928 +0200
@@ -1753,7 +1753,10 @@
 	ct_iu_req = zfcp_sg_to_address(ct->req);
 	ct_iu_resp = zfcp_sg_to_address(ct->resp);
 
-	if ((ct->status != 0) || zfcp_check_ct_response(&ct_iu_resp->header)) {
+	if (ct->status != 0)
+		goto failed;
+
+	if (zfcp_check_ct_response(&ct_iu_resp->header)) {
 		/* FIXME: do we need some specific erp entry points */
 		atomic_set_mask(ZFCP_STATUS_PORT_INVALID_WWPN, &port->status);
 		goto failed;

