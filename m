From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH] scsi_dh_alua: Re-enable STPG for unavailable ports
Date: Fri, 22 Jun 2012 08:49:38 +0000
Message-ID: <4FE431A2.2050500@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay04ant.iops.be ([212.53.5.219]:46356 "EHLO
	relay04ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761697Ab2FVItn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jun 2012 04:49:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Babu Moger <babu.moger@netapp.com>, Hannes Reinecke <hare@suse.de>

A quote from SPC-4: "While in the unavailable primary target port
asymmetric access state, the device server shall support those of
the following commands that it supports while in the active/optimized
state: [ ... ] d) SET TARGET PORT GROUPS; [ ... ]". Hence re-enable
sending STPG to a target port group that is in the unavailable state.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Babu Moger <babu.moger@netapp.com>
Cc: Hannes Reinecke <hare@suse.de>

---
This patch fixes a regression introduced in kernel 3.5-rc1.

---
 drivers/scsi/device_handler/scsi_dh_alua.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 5088209..155fadc 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -691,9 +691,9 @@ static int alua_activate(struct scsi_device *sdev,
 				stpg = 0;
 			break;
 		case TPGS_STATE_STANDBY:
+		case TPGS_STATE_UNAVAILABLE:
 			stpg = 1;
 			break;
-		case TPGS_STATE_UNAVAILABLE:
 		case TPGS_STATE_OFFLINE:
 			err = SCSI_DH_IO;
 			break;
