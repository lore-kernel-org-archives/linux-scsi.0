From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 5/16]  qla2xxx: Correct domain/area exclusion logic.
Date: Fri, 26 Aug 2005 19:08:40 -0700 (PDT)
Message-ID: <20050827020840.27275.61783.sendpatchset@plap.qlogic.com>
References: <20050827020750.27275.19733.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:51047 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1751613AbVH0CIl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Aug 2005 22:08:41 -0400
In-Reply-To: <20050827020750.27275.19733.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Correct domain/area exclusion logic.

In an FL topology, limit port recognition to those devices
not within the same area and domain of the ISP.  The
firmware will recogonize such devices during local-loop
discovery.

Some devices may respond to a PLOGI before they have
completed their fabric login or they may not be a public
device. In this case they will report:

        domain == 00
        area == 00
        alpa == <XX>

which is valid. Exclude such devices from local loop
discovery.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

 drivers/scsi/qla2xxx/qla_init.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

051e6f0a69a8a9b3012dfe568eb11d74362df53c
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1904,7 +1904,8 @@ qla2x00_configure_local_loop(scsi_qla_ho
 			continue;
 
 		/* Bypass if not same domain and area of adapter. */
-		if (area != ha->d_id.b.area || domain != ha->d_id.b.domain)
+		if (area && domain &&
+		    (area != ha->d_id.b.area || domain != ha->d_id.b.domain))
 			continue;
 
 		/* Bypass invalid local loop ID. */
@@ -2404,6 +2405,12 @@ qla2x00_find_all_fabric_devs(scsi_qla_ho
 		if (new_fcport->d_id.b24 == ha->d_id.b24)
 			continue;
 
+		/* Bypass if same domain and area of adapter. */
+		if (((new_fcport->d_id.b24 & 0xffff00) ==
+		    (ha->d_id.b24 & 0xffff00)) && ha->current_topology ==
+			ISP_CFG_FL)
+			    continue;
+
 		/* Bypass reserved domain fields. */
 		if ((new_fcport->d_id.b.domain & 0xf0) == 0xf0)
 			continue;

-- 
Andrew Vasquez
