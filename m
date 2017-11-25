From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH] scsi: libfc: fix ELS request handling
Date: Sat, 25 Nov 2017 19:38:10 +0100
Message-ID: <20171125183810.20035-1-mwilck@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:39157 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750808AbdKYSi7 (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Sat, 25 Nov 2017 13:38:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Martin Wilck <mwilck@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Chad Dupuis <chad.dupuis@cavium.com>

The modification of fc_lport_recv_els_req() in commit fcabb09e59a7
(merged in 4.12-rc1) caused certain requests not to be handled at all.
Fix that.

Fixes: fcabb09e59a7 "scsi: libfc: directly call ELS request handlers"
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/libfc/fc_lport.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 2fd0ec651170..787e82435241 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -904,10 +904,14 @@ static void fc_lport_recv_els_req(struct fc_lport *lport,
 		case ELS_FLOGI:
 			if (!lport->point_to_multipoint)
 				fc_lport_recv_flogi_req(lport, fp);
+			else
+				fc_rport_recv_req(lport, fp);
 			break;
 		case ELS_LOGO:
 			if (fc_frame_sid(fp) == FC_FID_FLOGI)
 				fc_lport_recv_logo_req(lport, fp);
+			else
+				fc_rport_recv_req(lport, fp);
 			break;
 		case ELS_RSCN:
 			lport->tt.disc_recv_req(lport, fp);
-- 
2.15.0
