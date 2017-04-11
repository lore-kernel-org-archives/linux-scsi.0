From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: [PATCH 4/4] scsi: scsi_dh_alua: do not print target port group state if it remains unavailable
Date: Mon, 10 Apr 2017 22:18:01 -0300
Message-ID: <1491873481-23900-5-git-send-email-mauricfo@linux.vnet.ibm.com>
References: <1491873481-23900-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46529 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753155AbdDKBSZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 Apr 2017 21:18:25 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v3B1DqOd029316
        for <linux-scsi@vger.kernel.org>; Mon, 10 Apr 2017 21:18:24 -0400
Received: from e24smtp04.br.ibm.com (e24smtp04.br.ibm.com [32.104.18.25])
        by mx0b-001b2d01.pphosted.com with ESMTP id 29rm8x2a0t-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 10 Apr 2017 21:18:24 -0400
Received: from localhost
        by e24smtp04.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
        Mon, 10 Apr 2017 22:18:22 -0300
Received: from d24av04.br.ibm.com (d24av04.br.ibm.com [9.8.31.97])
        by d24relay02.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v3B1IIf620054334
        for <linux-scsi@vger.kernel.org>; Mon, 10 Apr 2017 22:18:19 -0300
Received: from d24av04.br.ibm.com (localhost [127.0.0.1])
        by d24av04.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v3B1IH3v017691
        for <linux-scsi@vger.kernel.org>; Mon, 10 Apr 2017 22:18:17 -0300
In-Reply-To: <1491873481-23900-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare@suse.de, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, bart.vanassche@sandisk.com

Path checkers will periodically check all paths to a target port group
in unavailable state more often (as they are 'failed'), possibly for a
long or indefinite period of time, or for a large number of paths.

That might end up flooding the kernel log with the scsi_dh_alua target
port group state messages, which are triggered by the rtpg recheck
scheduled in alua_check_sense().

So, modify alua_rtpg() not to print such message when that unavailable
state remains (i.e., the target port group state did not transition to
or from the unavailable state). All other cases continue to be printed.

Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index c2c9173fd883..8025e024c011 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -554,6 +554,17 @@ static void alua_rtpg_print(struct scsi_device *sdev, struct alua_port_group *pg
 }
 
 /*
+ * alua_state_remains - Whether a RTPG state remains the same across 2 values.
+ * @state: the state value to check for.
+ * @old_state: the old state value.
+ * @new_state: the new state value.
+ */
+static bool alua_state_remains(int state, int old_state, int new_state)
+{
+	return ((old_state == state) && (new_state == state));
+}
+
+/*
  * alua_rtpg - Evaluate REPORT TARGET GROUP STATES
  * @sdev: the device to be evaluated.
  *
@@ -571,6 +582,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 	unsigned int tpg_desc_tbl_off;
 	unsigned char orig_transition_tmo;
 	unsigned long flags;
+	int orig_state;
 
 	if (!pg->expiry) {
 		unsigned long transition_tmo = ALUA_FAILOVER_TIMEOUT * HZ;
@@ -656,6 +668,8 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 		goto retry;
 	}
 
+	orig_state = pg->state;
+
 	orig_transition_tmo = pg->transition_tmo;
 	if ((buff[4] & RTPG_FMT_MASK) == RTPG_FMT_EXT_HDR && buff[5] != 0)
 		pg->transition_tmo = buff[5];
@@ -689,6 +703,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 				    !(tmp_pg->flags & ALUA_PG_RUNNING)) {
 					struct alua_dh_data *h;
 					struct scsi_device *tmp_pg_sdev = NULL;
+					int tmp_pg_orig_state = tmp_pg->state;
 
 					tmp_pg->state = desc[0] & 0x0f;
 					tmp_pg->pref = desc[0] >> 7;
@@ -704,8 +719,11 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 						 * is not running, tmp_pg->rtpg_sdev might be NULL.
 						 * Use another/one associated scsi_device to print
 						 * its RTPG information.
+						 * Don't print it if state remains 'unavailable'.
 						 */
-						if ((tmp_pg != pg) && !tmp_pg_sdev) {
+						if ((tmp_pg != pg) && !tmp_pg_sdev &&
+						    !alua_state_remains(SCSI_ACCESS_STATE_UNAVAILABLE,
+									tmp_pg_orig_state, tmp_pg->state)) {
 							tmp_pg_sdev = h->sdev;
 							alua_rtpg_print(tmp_pg_sdev, tmp_pg, NULL);
 						}
@@ -722,7 +740,11 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 	}
 
 	spin_lock_irqsave(&pg->lock, flags);
-	alua_rtpg_print(sdev, pg, &valid_states);
+
+	/* Print RTPG information (except if state remains 'unavailable'). */
+	if (likely(!alua_state_remains(SCSI_ACCESS_STATE_UNAVAILABLE,
+					orig_state, pg->state)))
+		alua_rtpg_print(sdev, pg, &valid_states);
 
 	switch (pg->state) {
 	case SCSI_ACCESS_STATE_TRANSITIONING:
-- 
1.8.3.1
