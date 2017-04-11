From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: [PATCH 3/4] scsi: scsi_dh_alua: print changes to RTPG state of other PGs too
Date: Mon, 10 Apr 2017 22:18:00 -0300
Message-ID: <1491873481-23900-4-git-send-email-mauricfo@linux.vnet.ibm.com>
References: <1491873481-23900-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41827 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753155AbdDKBSg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 Apr 2017 21:18:36 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v3B1DkPg037646
        for <linux-scsi@vger.kernel.org>; Mon, 10 Apr 2017 21:18:20 -0400
Received: from e24smtp04.br.ibm.com (e24smtp04.br.ibm.com [32.104.18.25])
        by mx0b-001b2d01.pphosted.com with ESMTP id 29rj2uxskp-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 10 Apr 2017 21:18:20 -0400
Received: from localhost
        by e24smtp04.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
        Mon, 10 Apr 2017 22:18:18 -0300
Received: from d24av04.br.ibm.com (d24av04.br.ibm.com [9.8.31.97])
        by d24relay02.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v3B1IEYj35651782
        for <linux-scsi@vger.kernel.org>; Mon, 10 Apr 2017 22:18:14 -0300
Received: from d24av04.br.ibm.com (localhost [127.0.0.1])
        by d24av04.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v3B1IDTH017626
        for <linux-scsi@vger.kernel.org>; Mon, 10 Apr 2017 22:18:13 -0300
In-Reply-To: <1491873481-23900-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare@suse.de, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, bart.vanassche@sandisk.com

Currently, alua_rtpg() can change the 'state' and 'preferred'
values for the current port group _and_ of other port groups
present in the response buffer/descriptors.

However, it reports such changes _only_ for the current port
group (i.e., only for 'pg' but not for 'tmp_pg').

This might cause uncertainty and confusion when going through
the kernel logs for analyzing/debugging scsi_dh_alua behavior,
which is not helpful during support and development scenarios.

So, print such changes for other port groups than the current
one.

This requires finding a scsi_device to call sdev_printk() with
for that other port group. Using 'tmp_pg->rtpg_sdev' is not an
option because in that 'if' conditional the 'tmp_pg' is not in
the ALUA_PG_RUNNING state, so that pointer may be NULL. So the
for-loop over the tmp->pg device_handler structures is used to
find a valid scsi_device that is associated to this port group.

Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 0d3508f2e285..c2c9173fd883 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -688,6 +688,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 				if ((tmp_pg == pg) ||
 				    !(tmp_pg->flags & ALUA_PG_RUNNING)) {
 					struct alua_dh_data *h;
+					struct scsi_device *tmp_pg_sdev = NULL;
 
 					tmp_pg->state = desc[0] & 0x0f;
 					tmp_pg->pref = desc[0] >> 7;
@@ -697,6 +698,17 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 						/* h->sdev should always be valid */
 						BUG_ON(!h->sdev);
 						h->sdev->access_state = desc[0];
+
+						/*
+						 * If tmp_pg is not the running pg, and its worker
+						 * is not running, tmp_pg->rtpg_sdev might be NULL.
+						 * Use another/one associated scsi_device to print
+						 * its RTPG information.
+						 */
+						if ((tmp_pg != pg) && !tmp_pg_sdev) {
+							tmp_pg_sdev = h->sdev;
+							alua_rtpg_print(tmp_pg_sdev, tmp_pg, NULL);
+						}
 					}
 					rcu_read_unlock();
 				}
-- 
1.8.3.1
