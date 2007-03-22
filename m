From: Richard Lary <rlary@austin.ibm.com>
Subject: [PATCH] qla2xxx: fix for byteswap in fc_host fabric_name
Date: Thu, 22 Mar 2007 10:53:19 -0500
Message-ID: <200703221553.l2MFrJEM012956@anacortes.austin.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:45690 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933546AbXCVPzw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Mar 2007 11:55:52 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l2MFtoq5005458
	for <linux-scsi@vger.kernel.org>; Thu, 22 Mar 2007 11:55:50 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l2MFtowa239342
	for <linux-scsi@vger.kernel.org>; Thu, 22 Mar 2007 11:55:50 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l2MFtnKb003622
	for <linux-scsi@vger.kernel.org>; Thu, 22 Mar 2007 11:55:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-driver@qlogic.com, linux-scsi@vger.kernel.org

From: Richard Lary <rlary@us.ibm.com>

This patch fixes byte swap issue in qla2xxx driver
to fix corrupted fabric_name passed to
/sys/class/fc_host/host*/fabric_name.

Signed-off-by: Richard Lary <rlary@us.ibm.com>
---

Example: Switch fabric name: 20:02:00:0d:ec:41:51:01
# cat /sys/class/fc_host/host*/fabric_name
0x2200d0041ec0151

# cat /sys/class/fc_host/host*/fabric_name
0x2002000dec415101

Applies to: 2.6.21-rc4-git5

Index: b/drivers/scsi/qla2xxx/qla_mbx.c
===================================================================
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1280,14 +1280,14 @@ qla2x00_get_port_name(scsi_qla_host_t *h
 	} else {
 		if (name != NULL) {
 			/* This function returns name in big endian. */
-			name[0] = LSB(mcp->mb[2]);
-			name[1] = MSB(mcp->mb[2]);
-			name[2] = LSB(mcp->mb[3]);
-			name[3] = MSB(mcp->mb[3]);
-			name[4] = LSB(mcp->mb[6]);
-			name[5] = MSB(mcp->mb[6]);
-			name[6] = LSB(mcp->mb[7]);
-			name[7] = MSB(mcp->mb[7]);
+			name[0] = MSB(mcp->mb[2]);
+			name[1] = LSB(mcp->mb[2]);
+			name[2] = MSB(mcp->mb[3]);
+			name[3] = LSB(mcp->mb[3]);
+			name[4] = MSB(mcp->mb[6]);
+			name[5] = LSB(mcp->mb[6]);
+			name[6] = MSB(mcp->mb[7]);
+			name[7] = LSB(mcp->mb[7]);
 		}
 
 		DEBUG11(printk("qla2x00_get_port_name(%ld): done.\n",
