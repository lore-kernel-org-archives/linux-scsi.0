From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH] scsi_dh_alua: Enable STPG for unavailable ports
Date: Fri, 24 Aug 2012 09:08:41 +0000
Message-ID: <50374499.5010808@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50617 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758050Ab2HXJIq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Aug 2012 05:08:46 -0400
Received: by pbbrr13 with SMTP id rr13so3096493pbb.19
        for <linux-scsi@vger.kernel.org>; Fri, 24 Aug 2012 02:08:46 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Mike Snitzer <snitzer@redhat.com>, Babu Moger <babu.moger@netapp.com>

A quote from SPC-4: "While in the unavailable primary target port
asymmetric access state, the device server shall support those of
the following commands that it supports while in the active/optimized
state: [ ... ] d) SET TARGET PORT GROUPS; [ ... ]". Hence enable
sending STPG to a target port group that is in the unavailable state.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Babu Moger <babu.moger@netapp.com>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/device_handler/scsi_dh_alua.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 08d80a6..a05d469 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -641,8 +641,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h)
 		h->state = TPGS_STATE_STANDBY;
 		break;
 	case TPGS_STATE_OFFLINE:
-	case TPGS_STATE_UNAVAILABLE:
-		/* Path unusable for unavailable/offline */
+		/* Path unusable */
 		err = SCSI_DH_DEV_OFFLINED;
 		break;
 	default:
-- 
1.7.7

