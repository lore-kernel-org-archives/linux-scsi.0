Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAB53C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 12:45:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D70CC610FB
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 12:45:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234231AbhJMMr0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Oct 2021 08:47:26 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:24166 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234364AbhJMMrQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Oct 2021 08:47:16 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19DAVHvh016935
        for <linux-scsi@vger.kernel.org>; Wed, 13 Oct 2021 05:45:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=BBgeCDx4btbfm75Z/OsmGakKc7WKso19GYapYk67QAI=;
 b=YbDgL9Mfc2ul9pVQCaUFBqfP5BbrWRR3YlRY30rJSkVc/Wz/u0mzIPhJMMnIwoJGoo8D
 0WrbZzvHNu8g63r1wbszy0x4lRzbpcW4o04xNIw8Wlha7y5gy4kIEkcmg3NjxW16IN9v
 5bDzyeLyXtEHNCi6Gi5wm2ws/n5BfWyX4ixVslMg9hCswDu02XJ90Np/MtIX0HqPUTfj
 WtH/bpibcvdyTUg8dcxrAVfkGlWkIkJqVzdAJ06G3CP5NP3X9I4znses831dbJbnQ/Wn
 yfP0GFnH5tpDLZ9Y/qKo84MDNBOOkJXCEL8S+IaG5jJKUAFX7uSdF9ca65GN0W4YvyAW ZQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3bnwrxghgv-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 13 Oct 2021 05:45:13 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 13 Oct
 2021 05:45:11 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 13 Oct 2021 05:45:11 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 53F003F7050;
        Wed, 13 Oct 2021 05:45:11 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 19DCjBXl017222;
        Wed, 13 Oct 2021 05:45:11 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 19DCjBIN017221;
        Wed, 13 Oct 2021 05:45:11 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 07/13] qla2xxx: edif: replace list_for_each_safe with list_for_each_entry_safe
Date:   Wed, 13 Oct 2021 05:44:16 -0700
Message-ID: <20211013124422.17151-8-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20211013124422.17151-1-njavali@marvell.com>
References: <20211013124422.17151-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: INr3VCvrRGvj8gnXQdojwRDplkj6sx3C
X-Proofpoint-GUID: INr3VCvrRGvj8gnXQdojwRDplkj6sx3C
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-13_05,2021-10-13_02,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

This patch is per review comment by Hannes Reinecke from
previous submission to replace list_for_each_safe with
list_for_each_entry_safe.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_edif.c | 39 ++++++++-------------------------
 drivers/scsi/qla2xxx/qla_edif.h |  1 -
 drivers/scsi/qla2xxx/qla_os.c   |  8 +++----
 3 files changed, 13 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index b4eca966067a..ca3b947770b9 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -1674,41 +1674,25 @@ static struct enode *
 qla_enode_find(scsi_qla_host_t *vha, uint32_t ntype, uint32_t p1, uint32_t p2)
 {
 	struct enode		*node_rtn = NULL;
-	struct enode		*list_node = NULL;
+	struct enode		*list_node, *q;
 	unsigned long		flags;
-	struct list_head	*pos, *q;
 	uint32_t		sid;
-	uint32_t		rw_flag;
 	struct purexevent	*purex;
 
 	/* secure the list from moving under us */
 	spin_lock_irqsave(&vha->pur_cinfo.pur_lock, flags);
 
-	list_for_each_safe(pos, q, &vha->pur_cinfo.head) {
-		list_node = list_entry(pos, struct enode, list);
+	list_for_each_entry_safe(list_node, q, &vha->pur_cinfo.head, list) {
 
 		/* node type determines what p1 and p2 are */
 		purex = &list_node->u.purexinfo;
 		sid = p1;
-		rw_flag = p2;
 
 		if (purex->pur_info.pur_sid.b24 == sid) {
-			if (purex->pur_info.pur_pend == 1 &&
-			    rw_flag == PUR_GET) {
-				/*
-				 * if the receive is in progress
-				 * and its a read/get then can't
-				 * transfer yet
-				 */
-				ql_dbg(ql_dbg_edif, vha, 0x9106,
-				    "%s purex xfer in progress for sid=%x\n",
-				    __func__, sid);
-			} else {
-				/* found it and its complete */
-				node_rtn = list_node;
-				list_del(pos);
-				break;
-			}
+			/* found it and its complete */
+			node_rtn = list_node;
+			list_del(&list_node->list);
+			break;
 		}
 	}
 
@@ -2419,7 +2403,6 @@ void qla24xx_auth_els(scsi_qla_host_t *vha, void **pkt, struct rsp_que **rsp)
 
 	purex = &ptr->u.purexinfo;
 	purex->pur_info.pur_sid = a.did;
-	purex->pur_info.pur_pend = 0;
 	purex->pur_info.pur_bytes_rcvd = totlen;
 	purex->pur_info.pur_rx_xchg_address = le32_to_cpu(p->rx_xchg_addr);
 	purex->pur_info.pur_nphdl = le16_to_cpu(p->nport_handle);
@@ -3171,18 +3154,14 @@ static uint16_t qla_edif_sadb_get_sa_index(fc_port_t *fcport,
 /* release any sadb entries -- only done at teardown */
 void qla_edif_sadb_release(struct qla_hw_data *ha)
 {
-	struct list_head *pos;
-	struct list_head *tmp;
-	struct edif_sa_index_entry *entry;
+	struct edif_sa_index_entry *entry, *tmp;
 
-	list_for_each_safe(pos, tmp, &ha->sadb_rx_index_list) {
-		entry = list_entry(pos, struct edif_sa_index_entry, next);
+	list_for_each_entry_safe(entry, tmp, &ha->sadb_rx_index_list, next) {
 		list_del(&entry->next);
 		kfree(entry);
 	}
 
-	list_for_each_safe(pos, tmp, &ha->sadb_tx_index_list) {
-		entry = list_entry(pos, struct edif_sa_index_entry, next);
+	list_for_each_entry_safe(entry, tmp, &ha->sadb_tx_index_list, next) {
 		list_del(&entry->next);
 		kfree(entry);
 	}
diff --git a/drivers/scsi/qla2xxx/qla_edif.h b/drivers/scsi/qla2xxx/qla_edif.h
index 9e8f28d0caa1..cd54c1dfe3cb 100644
--- a/drivers/scsi/qla2xxx/qla_edif.h
+++ b/drivers/scsi/qla2xxx/qla_edif.h
@@ -102,7 +102,6 @@ struct dinfo {
 };
 
 struct pur_ninfo {
-	unsigned int	pur_pend:1;
 	port_id_t       pur_sid;
 	port_id_t	pur_did;
 	uint8_t		vp_idx;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 3fca6b8bb23f..df0e46ef3e96 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3885,13 +3885,13 @@ qla2x00_remove_one(struct pci_dev *pdev)
 static inline void
 qla24xx_free_purex_list(struct purex_list *list)
 {
-	struct list_head *item, *next;
+	struct purex_item *item, *next;
 	ulong flags;
 
 	spin_lock_irqsave(&list->lock, flags);
-	list_for_each_safe(item, next, &list->head) {
-		list_del(item);
-		kfree(list_entry(item, struct purex_item, list));
+	list_for_each_entry_safe(item, next, &list->head, list) {
+		list_del(&item->list);
+		kfree(item);
 	}
 	spin_unlock_irqrestore(&list->lock, flags);
 }
-- 
2.19.0.rc0

