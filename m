From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: [PATCH v2 4/4] scsi: scsi_dh_alua: add sdev_dbg() to track alua_rtpg_work()
Date: Mon, 10 Jul 2017 19:47:37 -0300
Message-ID: <1499726857-7875-5-git-send-email-mauricfo@linux.vnet.ibm.com>
References: <1499726857-7875-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58658 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755035AbdGJWsG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 Jul 2017 18:48:06 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6AMasdt145016
        for <linux-scsi@vger.kernel.org>; Mon, 10 Jul 2017 18:48:00 -0400
Received: from e24smtp05.br.ibm.com (e24smtp05.br.ibm.com [32.104.18.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2bmbr5xq1s-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 10 Jul 2017 18:48:00 -0400
Received: from localhost
        by e24smtp05.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
        Mon, 10 Jul 2017 19:47:58 -0300
In-Reply-To: <1499726857-7875-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: hare@suse.de, bart.vanassche@sandisk.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Insert sdev_dbg() calls in the function path which may queue
alua_rtpg_work() past initialization, for debugging purposes:
- alua_activate()
- alua_check_sense()
- alua_rtpg_queue()

Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index e0bf0827a980..5bf0d55f6eb1 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -422,6 +422,10 @@ static char print_alua_state(unsigned char state)
 static int alua_check_sense(struct scsi_device *sdev,
 			    struct scsi_sense_hdr *sense_hdr)
 {
+	sdev_dbg(sdev, "%s: %s(): Sense Key: 0x%x, ASC: 0x%x, ASCQ: 0x%x\n",
+		 ALUA_DH_NAME, __func__, sense_hdr->sense_key,
+		 sense_hdr->asc, sense_hdr->ascq);
+
 	switch (sense_hdr->sense_key) {
 	case NOT_READY:
 		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0a) {
@@ -987,10 +991,13 @@ static bool alua_rtpg_queue(struct alua_port_group *pg,
 	spin_unlock_irqrestore(&pg->lock, flags);
 
 	if (start_queue) {
+
 		if (queue_delayed_work(alua_wq, &pg->rtpg_work,
-				msecs_to_jiffies(ALUA_RTPG_DELAY_MSECS)))
+				msecs_to_jiffies(ALUA_RTPG_DELAY_MSECS))) {
+			sdev_dbg(sdev, "%s: %s(): port group %02x\n",
+				 ALUA_DH_NAME, __func__, pg->group_id);
 			sdev = NULL;
-		else
+		} else
 			kref_put(&pg->kref, release_port_group);
 	}
 	if (sdev)
@@ -1100,6 +1107,9 @@ static int alua_activate(struct scsi_device *sdev,
 	rcu_read_unlock();
 	mutex_unlock(&h->init_mutex);
 
+	sdev_dbg(sdev, "%s: %s(): port group %02x, fn: %pf()\n",
+		 ALUA_DH_NAME, __func__, pg->group_id, fn);
+
 	if (alua_rtpg_queue(pg, sdev, qdata, true))
 		fn = NULL;
 	else
-- 
1.8.3.1
