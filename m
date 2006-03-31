From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] Retry INQUIRY on power-on
Date: Fri, 31 Mar 2006 15:12:01 +0200
Message-ID: <442D2AA1.3070909@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060302020807040401020703"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:58759 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S932105AbWCaNMD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Mar 2006 08:12:03 -0500
Received: from Relay1.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 67BB51C65B
	for <linux-scsi@vger.kernel.org>; Fri, 31 Mar 2006 15:12:02 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------060302020807040401020703
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Hi all,

the current inquiry code in scsi_scan.c:scsi_probe_lun() will retry the
inquiry only for ASC/ASCQ 0x28/0x0 and 0x29/0x0. When I'm hot-plugging a
disk no reset has necessarily happened, so the first rescan will fail.
The disk is found properly on the second rescan.

So we really should loosen that statement to do retry for all ASC 0x29
values as a power-on might well have occured without a reset.

Please apply.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstraße 5				+49 911 74053 688
90409 Nürnberg				http://www.suse.de

--------------060302020807040401020703
Content-Type: text/plain;
 name="scsi-scan-retry-on-poweron"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi-scan-retry-on-poweron"

From: Hannes Reinecke <hare@suse.de>
Subject: Retry INQUIRY on power-on

The current code retries INQUIRY only for ASC/ASCQ 0x29/0x0
(POWER ON, RESET, OR BUS DEVICE RESET OCCURRED). This means drives
which have been hot-removed (ie without a reset) won't be detected
upon rescan. So we should loose this condition to enable a retry
for the ASC 0x29 in general.

Signed-off-by: Hannes Reinecke

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index f149459..f6ead5c 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -514,8 +514,7 @@ static int scsi_probe_lun(struct scsi_de
 			    scsi_sense_valid(&sshdr)) {
 				if ((sshdr.sense_key == UNIT_ATTENTION) &&
 				    ((sshdr.asc == 0x28) ||
-				     (sshdr.asc == 0x29)) &&
-				    (sshdr.ascq == 0))
+				     (sshdr.asc == 0x29)))
 					continue;
 			}
 		}

--------------060302020807040401020703--
