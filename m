From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
Subject: [PATCH 10/10] arcmsr: add missing braces to multistatement if block
Date: Thu, 30 Oct 2008 13:47:20 +0200 (EET)
Message-ID: <Pine.LNX.4.64.0810301345050.7072@wrl-59.cs.helsinki.fi>
References: <Pine.LNX.4.64.0810301307160.7072@wrl-59.cs.helsinki.fi>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; boundary="-696208474-1836378461-1225367149=:7072"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from courier.cs.helsinki.fi ([128.214.9.1]:40962 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421AbYJ3LuF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Oct 2008 07:50:05 -0400
In-Reply-To: <Pine.LNX.4.64.0810301307160.7072@wrl-59.cs.helsinki.fi>
Content-ID: <Pine.LNX.4.64.0810301345550.7072@wrl-59.cs.helsinki.fi>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---696208474-1836378461-1225367149=:7072
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.64.0810301345551.7072@wrl-59.cs.helsinki.fi>


Funny, there are plenty of the braces in case block where
one does not need them while in here they seem to be
forgotten.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
---
 drivers/scsi/arcmsr/arcmsr_hba.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index f91f79c..b57834b 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -673,10 +673,11 @@ static void arcmsr_report_ccb_state(struct AdapterControlBlock *acb, \
 	id = ccb->pcmd->device->id;
 	lun = ccb->pcmd->device->lun;
 	if (!(flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR)) {
-		if (acb->devstate[id][lun] == ARECA_RAID_GONE)
+		if (acb->devstate[id][lun] == ARECA_RAID_GONE) {
 			acb->devstate[id][lun] = ARECA_RAID_GOOD;
 			ccb->pcmd->result = DID_OK << 16;
 			arcmsr_ccb_complete(ccb, 1);
+		}
 	} else {
 		switch (ccb->arcmsr_cdb.DeviceStatus) {
 		case ARCMSR_DEV_SELECT_TIMEOUT: {
-- 
1.5.2.2
---696208474-1836378461-1225367149=:7072--
