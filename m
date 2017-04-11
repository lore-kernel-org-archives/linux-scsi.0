From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: [PATCH 2/4] scsi: scsi_dh_alua: create alua_rtpg_print() for alua_rtpg() sdev_printk
Date: Mon, 10 Apr 2017 22:17:59 -0300
Message-ID: <1491873481-23900-3-git-send-email-mauricfo@linux.vnet.ibm.com>
References: <1491873481-23900-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44309 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753046AbdDKBSS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 Apr 2017 21:18:18 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v3B1Gp1F047987
        for <linux-scsi@vger.kernel.org>; Mon, 10 Apr 2017 21:18:17 -0400
Received: from e24smtp04.br.ibm.com (e24smtp04.br.ibm.com [32.104.18.25])
        by mx0a-001b2d01.pphosted.com with ESMTP id 29rmq6hadq-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 10 Apr 2017 21:18:17 -0400
Received: from localhost
        by e24smtp04.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
        Mon, 10 Apr 2017 22:18:14 -0300
Received: from d24av04.br.ibm.com (d24av04.br.ibm.com [9.8.31.97])
        by d24relay04.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v3B1IB8J41550058
        for <linux-scsi@vger.kernel.org>; Mon, 10 Apr 2017 22:18:11 -0300
Received: from d24av04.br.ibm.com (localhost [127.0.0.1])
        by d24av04.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v3B1IAGT017605
        for <linux-scsi@vger.kernel.org>; Mon, 10 Apr 2017 22:18:11 -0300
In-Reply-To: <1491873481-23900-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare@suse.de, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, bart.vanassche@sandisk.com

Factor out the sdev_printk() statement with the RTPG information
in alua_rtpg() into a new function, alua_rtpg_print(), that will
also be used in the following patch.

The only functional difference is that the 'valid_states' value
is now referenced via a pointer, and can be NULL (optional), in
which case the 'valid_states' information is not printed.  That
is for the following patch too.

Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 43 ++++++++++++++++++++++--------
 1 file changed, 32 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 5e5a33cac951..0d3508f2e285 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -523,6 +523,37 @@ static int alua_tur(struct scsi_device *sdev)
 }
 
 /*
+ * alua_rtpg_print - Print REPORT TARGET GROUP STATES information
+ * @sdev: the device evaluated (or associated with this port group).
+ * @pg: the port group the information is associated with.
+ * @valid_states: pointer to valid_states value.
+ *                (optional; e.g., obtained via another port group)
+ *
+ * Must be called with pg->lock held.
+ */
+static void alua_rtpg_print(struct scsi_device *sdev, struct alua_port_group *pg,
+			    int *valid_states)
+{
+	if (valid_states)
+		sdev_printk(KERN_INFO, sdev,
+		    "%s: port group %02x state %c %s supports %c%c%c%c%c%c%c\n",
+		    ALUA_DH_NAME, pg->group_id, print_alua_state(pg->state),
+		    pg->pref ? "preferred" : "non-preferred",
+		    (*valid_states) & TPGS_SUPPORT_TRANSITION ? 'T' : 't',
+		    (*valid_states) & TPGS_SUPPORT_OFFLINE ? 'O' : 'o',
+		    (*valid_states) & TPGS_SUPPORT_LBA_DEPENDENT ? 'L' : 'l',
+		    (*valid_states) & TPGS_SUPPORT_UNAVAILABLE ? 'U' : 'u',
+		    (*valid_states) & TPGS_SUPPORT_STANDBY ? 'S' : 's',
+		    (*valid_states) & TPGS_SUPPORT_NONOPTIMIZED ? 'N' : 'n',
+		    (*valid_states) & TPGS_SUPPORT_OPTIMIZED  ?  'A' : 'a');
+	else
+		sdev_printk(KERN_INFO, sdev,
+		    "%s: port group %02x state %c %s\n",
+		    ALUA_DH_NAME, pg->group_id, print_alua_state(pg->state),
+		    pg->pref ? "preferred" : "non-preferred");
+}
+
+/*
  * alua_rtpg - Evaluate REPORT TARGET GROUP STATES
  * @sdev: the device to be evaluated.
  *
@@ -679,17 +710,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 	}
 
 	spin_lock_irqsave(&pg->lock, flags);
-	sdev_printk(KERN_INFO, sdev,
-		    "%s: port group %02x state %c %s supports %c%c%c%c%c%c%c\n",
-		    ALUA_DH_NAME, pg->group_id, print_alua_state(pg->state),
-		    pg->pref ? "preferred" : "non-preferred",
-		    valid_states&TPGS_SUPPORT_TRANSITION?'T':'t',
-		    valid_states&TPGS_SUPPORT_OFFLINE?'O':'o',
-		    valid_states&TPGS_SUPPORT_LBA_DEPENDENT?'L':'l',
-		    valid_states&TPGS_SUPPORT_UNAVAILABLE?'U':'u',
-		    valid_states&TPGS_SUPPORT_STANDBY?'S':'s',
-		    valid_states&TPGS_SUPPORT_NONOPTIMIZED?'N':'n',
-		    valid_states&TPGS_SUPPORT_OPTIMIZED?'A':'a');
+	alua_rtpg_print(sdev, pg, &valid_states);
 
 	switch (pg->state) {
 	case SCSI_ACCESS_STATE_TRANSITIONING:
-- 
1.8.3.1
