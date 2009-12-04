From: Michael Reed <mdr@sgi.com>
Subject: [PATCH 1/1] lpfc: lpfc no longer discovers lun 255
Date: Fri, 04 Dec 2009 10:04:10 -0600
Message-ID: <4B1932FA.7080407@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay3.sgi.com ([192.48.152.1]:41494 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757017AbZLDQEF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Dec 2009 11:04:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Smart <James.Smart@Emulex.Com>

A change in lun scanning range in scsi_scan.c ( ">" becomes ">=") results
in lpfc no longer discovering lun 255 of my test configuration.  This
patch adjusts lpfc_attr.c to discover lun 255 again.

scsi: host 3 channel 0 id 17 lun255 has a LUN larger than allowed by the host adapter


Signed-off-by: Michael Reed <mdr@sgi.com>


--- scsi-misc-2.6/drivers/scsi/lpfc/lpfc_attr.c	2009-12-01 16:18:40.000000000 -0600
+++ scsi-misc-2.6-modified/drivers/scsi/lpfc/lpfc_attr.c	2009-12-04 10:01:52.091503203 -0600
@@ -3099,10 +3099,10 @@ LPFC_VPORT_ATTR(discovery_threads, 32, 1
 
 /*
 # lpfc_max_luns: maximum allowed LUN.
-# Value range is [0,65535]. Default value is 255.
+# Value range is [0,65535]. Default value is 256, 1 greater than max lun number.
 # NOTE: The SCSI layer might probe all allowed LUN on some old targets.
 */
-LPFC_VPORT_ATTR_R(max_luns, 255, 0, 65535, "Maximum allowed LUN");
+LPFC_VPORT_ATTR_R(max_luns, 256, 0, 65535, "Maximum allowed LUN");
 
 /*
 # lpfc_poll_tmo: .Milliseconds driver will wait between polling FCP ring.
