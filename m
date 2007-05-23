From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] Un-remove aacraid devices
Date: Wed, 23 May 2007 14:50:53 +0200
Message-ID: <465438AD.8000406@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040301030908070305000405"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37140 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754497AbXEWMuz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 May 2007 08:50:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------040301030908070305000405
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Hi Mark,

for some weird reason the aacraid driver insists on presenting all disks
as 'removable' devices. This is gross hackery and causes userspace tools
to not identify these devices as fixed disks, which most evidently they are.

Please apply.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)

--------------040301030908070305000405
Content-Type: text/plain;
 name="aacraid-unremove-disks"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="aacraid-unremove-disks"

Make aacraid devices fixed

For some reason the aacraid driver insists on making all devices removable.
This causes userspace tools to not identifying aacraid disks as fixed disks.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 1e82c69..24275d8 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -1843,9 +1843,6 @@ int aac_scsi_cmd(struct scsi_cmnd * scsi
 			} while ((offset += len) < scsicmd->cmnd[13]);
 		}
 
-		/* Do not cache partition table for arrays */
-		scsicmd->device->removable = 1;
-
 		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
 		scsicmd->scsi_done(scsicmd);
 

--------------040301030908070305000405--
