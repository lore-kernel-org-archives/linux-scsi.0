From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
Subject: [RFC PATCH] arcmsr: add missing braces to multistatement if block
Date: Tue, 19 Aug 2008 11:05:13 +0300 (EEST)
Message-ID: <Pine.LNX.4.64.0808191103330.4551@wrl-59.cs.helsinki.fi>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-696208474-1928556142-1219133113=:4551"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from courier.cs.helsinki.fi ([128.214.9.1]:58742 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172AbYHSIFO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Aug 2008 04:05:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---696208474-1928556142-1219133113=:4551
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

It seems that this is the right way to go, though I definately
have no clue about the driver's internals...

...Funny, there are plenty of the braces in case blocks where
one does not need them while in here they're forgotten.

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

---696208474-1928556142-1219133113=:4551--
