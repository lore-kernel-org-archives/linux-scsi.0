From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] Fix up tag usage in lpfc
Date: Thu, 18 Oct 2007 12:12:12 +0200
Message-ID: <20071018101212.GC22562@pentland.suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="9jxsPFA5p3P2qPhR"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56425 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755367AbXJRKL6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Oct 2007 06:11:58 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@emulex.com>
Cc: linux-scsi@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi James,

appearently the lpfc driver is sligtly confused about the meaning
of the 'scmd->tag' value. It should rather inspect the correct
flags to detect the proper SCSI Tag value.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)

--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=lpfc-fixup-tags

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index cd67493..a1cf99a 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -693,17 +693,10 @@ lpfc_scsi_prep_cmnd(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
 	memcpy(&fcp_cmnd->fcpCdb[0], scsi_cmnd->cmnd, 16);
 
 	if (scsi_cmnd->device->tagged_supported) {
-		switch (scsi_cmnd->tag) {
-		case HEAD_OF_QUEUE_TAG:
-			fcp_cmnd->fcpCntl1 = HEAD_OF_Q;
-			break;
-		case ORDERED_QUEUE_TAG:
+		if (scsi_cmnd->device->ordered_tags)
 			fcp_cmnd->fcpCntl1 = ORDERED_Q;
-			break;
-		default:
+		else
 			fcp_cmnd->fcpCntl1 = SIMPLE_Q;
-			break;
-		}
 	} else
 		fcp_cmnd->fcpCntl1 = 0;
 

--9jxsPFA5p3P2qPhR--
