From: "Stewart, Sean" <Sean.Stewart@netapp.com>
Subject: [PATCH 2/2] ALUA handler attach should succeed while TPG is
 transitioning
Date: Mon, 14 Oct 2013 22:24:55 +0000
Message-ID: <8255ED565A0EAA4A960625E27D49DBF24AC14D63@SACEXCMBX04-PRD.hq.netapp.com>
References: <8255ED565A0EAA4A960625E27D49DBF24AC14D2C@SACEXCMBX04-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx12.netapp.com ([216.240.18.77]:35902 "EHLO mx12.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756459Ab3JNWY4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Oct 2013 18:24:56 -0400
In-Reply-To: <8255ED565A0EAA4A960625E27D49DBF24AC14D2C@SACEXCMBX04-PRD.hq.netapp.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "hare@suse.de" <hare@suse.de>

During testing, it was discovered that when a device tries to attach to the alua handler while in TPG
state of transitioning, the alua_rtpg function will wait for it to exit the state before allowing it
to continue. As a result, if the 60 second timeout expires, the alua handler will not attach to the
device.

To fix this, I have introduced an input argument to alua_rtpg called wait_for_transition.  The idea is
that it will wait for the transition to complete before an activation (because the current TPG state has
some bearing in that case), but during a discovery if it is transitioning, it will not wait, and will
store the state as standby for the time being.

I believe the precedent exists for this from commit c0d289b3e59577532c45ee9110ef81bd7b341272
Since if the device reports a state of transitioning, it can transition to other more valid states, and
it has been established TPGS is supported on the device, if it is attaching.

Signed-off-by: Sean Stewart <Sean.Stewart@netapp.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 78205cc..5248c88 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -522,12 +522,13 @@ static int alua_check_sense(struct scsi_device *sdev,
 /*
  * alua_rtpg - Evaluate REPORT TARGET GROUP STATES
  * @sdev: the device to be evaluated.
+ * @wait_for_transition: if nonzero, wait ALUA_FAILOVER_TIMEOUT seconds for device to exit transitioning state
  *
  * Evaluate the Target Port Group State.
  * Returns SCSI_DH_DEV_OFFLINED if the path is
  * found to be unusable.
  */
-static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h)
+static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_for_transition)
 {
 	struct scsi_sense_hdr sense_hdr;
 	int len, k, off, valid_states = 0;
@@ -599,7 +600,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h)
 	else
 		h->transition_tmo = ALUA_FAILOVER_TIMEOUT;
 
-	if (orig_transition_tmo != h->transition_tmo) {
+	if (wait_for_transition && (orig_transition_tmo != h->transition_tmo)) {
 		sdev_printk(KERN_INFO, sdev,
 			    "%s: transition timeout set to %d seconds\n",
 			    ALUA_DH_NAME, h->transition_tmo);
@@ -637,14 +638,19 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h)
 
 	switch (h->state) {
 	case TPGS_STATE_TRANSITIONING:
-		if (time_before(jiffies, expiry)) {
-			/* State transition, retry */
-			interval += 2000;
-			msleep(interval);
-			goto retry;
+		if (wait_for_transition) {
+			if (time_before(jiffies, expiry)) {
+				/* State transition, retry */
+				interval += 2000;
+				msleep(interval);
+				goto retry;
+			}
+			err = SCSI_DH_RETRY;
+		} else {
+			err = SCSI_DH_OK;
 		}
+
 		/* Transitioning time exceeded, set port to standby */
-		err = SCSI_DH_RETRY;
 		h->state = TPGS_STATE_STANDBY;
 		break;
 	case TPGS_STATE_OFFLINE:
@@ -678,7 +684,7 @@ static int alua_initialize(struct scsi_device *sdev, struct alua_dh_data *h)
 	if (err != SCSI_DH_OK)
 		goto out;
 
-	err = alua_rtpg(sdev, h);
+	err = alua_rtpg(sdev, h, 0);
 	if (err != SCSI_DH_OK)
 		goto out;
 
@@ -738,7 +744,7 @@ static int alua_activate(struct scsi_device *sdev,
 	int err = SCSI_DH_OK;
 	int stpg = 0;
 
-	err = alua_rtpg(sdev, h);
+	err = alua_rtpg(sdev, h, 1);
 	if (err != SCSI_DH_OK)
 		goto out;
 
-- 
1.8.3.1

