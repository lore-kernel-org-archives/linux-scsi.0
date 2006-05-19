From: Amit Arora <aarora@in.ibm.com>
Subject: [PATCH] scsi: Return -EINVAL when "id == max_id" in
	scsi_scan_host_selected()
Date: Fri, 19 May 2006 16:14:50 -0700
Message-ID: <1148080489.23417.18.camel@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:3755 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751423AbWESXPc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 May 2006 19:15:32 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k4JNFV9O008662
	for <linux-scsi@vger.kernel.org>; Fri, 19 May 2006 19:15:31 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k4JNFVOK231770
	for <linux-scsi@vger.kernel.org>; Fri, 19 May 2006 19:15:31 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k4JNFUYm020738
	for <linux-scsi@vger.kernel.org>; Fri, 19 May 2006 19:15:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: patmans@us.ibm.com

The scsi_scan_host_selected() should return -EINVAL when the id is equal
to the max_id. Currently it uses ">" when comparing with max_id, and
hence leaves the border case when "id==max_id".
The channel and lun have values valid from 0 up to,
and including, max_channel or max_lun. But, the valid values for id
range from 0 to max_id-1. This patch fixes the problem.

Regards,
Amit Arora

Signed-off-by: Amit Arora <aarora@in.ibm.com>
---
diff -Nuarp linux-2.6.17-rc4.orig/drivers/scsi/scsi_scan.c
linux-2.6.17-rc4/drivers/scsi/scsi_scan.c
--- linux-2.6.17-rc4.orig/drivers/scsi/scsi_scan.c      2006-05-18
20:25:32.000000000 -0600
+++ linux-2.6.17-rc4/drivers/scsi/scsi_scan.c   2006-05-18
20:28:09.000000000 -0600
@@ -1473,7 +1473,7 @@ int scsi_scan_host_selected(struct Scsi_
                __FUNCTION__, channel, id, lun));
  
        if (((channel != SCAN_WILD_CARD) && (channel >
shost->max_channel)) ||
-           ((id != SCAN_WILD_CARD) && (id > shost->max_id)) ||
+           ((id != SCAN_WILD_CARD) && (id >= shost->max_id)) ||
            ((lun != SCAN_WILD_CARD) && (lun > shost->max_lun)))
                return -EINVAL;





