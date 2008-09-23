From: Levy_Jerome@emc.com
Subject: [PATCH 1/1] scsi_dh: add ALUA notification for EMC Clariion devices
Date: Tue, 23 Sep 2008 10:46:18 -0400
Message-ID: <6416EE16C1AF1E4C86882867E4DD0FF6026D1BF1@CORPUSMX40B.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mexforward.lss.emc.com ([128.222.32.20]:28508 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbYIWOrB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Sep 2008 10:47:01 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Adding sense code data decode and notification for optimal/non-optimal
path changeover on Clariion devices. Unfortunately in the read sense
code we can't do another inquiry, so we can't tell the user whether we
are on the optimal or non-optimal path, only that a change has occurred.


Signed-off-by: Jerry Levy <levy_jerome@emc.com>
---------------------

--- ./drivers/scsi/device_handler/scsi_dh_emc.original.c
2008-09-17 14:50:18.000000000 -0400
+++ ./drivers/scsi/device_handler/scsi_dh_emc.c 2008-09-17
14:54:38.000000000 -0400
@@ -435,6 +435,16 @@
                        return SUCCESS;
                break;
        case UNIT_ATTENTION:
+                if (sense_hdr->asc == 0x2A && sense_hdr->ascq == 0x06)
+                        /*
+                         * ALUA status has changed. Report to host,
+                         * no further action required... jml
+                         */
+                        sdev_printk(KERN_NOTICE, sdev,
+                                    "%s: Asymmetric access state has
changed.\n",
+                                    CLARIION_NAME);
+                        return SUCCESS;
+                break;
                if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x00)
                        /*
                         * Unit Attention Code. This is the first IO

