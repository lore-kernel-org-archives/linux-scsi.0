Return-Path: <SRS0=g0vc=CJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D418C433E2
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Aug 2020 08:12:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50D832098B
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Aug 2020 08:12:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728145AbgHaIMN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Aug 2020 04:12:13 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:10353 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726573AbgHaIML (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 31 Aug 2020 04:12:11 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 1AD57713026F222955E;
        Mon, 31 Aug 2020 16:12:07 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Mon, 31 Aug 2020
 16:11:56 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <satishkh@cisco.com>, <sebaddel@cisco.com>, <kartilak@cisco.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <yanaijie@huawei.com>, <linux-scsi@vger.kernel.org>
CC:     Hulk Robot <hulkci@huawei.com>
Subject: [PATCH 4/4] scsi: fnic: remove set but not used 'eth_hdrs_stripped'
Date:   Mon, 31 Aug 2020 16:11:26 +0800
Message-ID: <20200831081126.3251288-5-yanaijie@huawei.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200831081126.3251288-1-yanaijie@huawei.com>
References: <20200831081126.3251288-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This addresses the following gcc warning with "make W=1":

drivers/scsi/fnic/fnic_fcs.c: In function ‘fnic_rq_cmpl_frame_recv’:
drivers/scsi/fnic/fnic_fcs.c:840:15: warning: variable
‘eth_hdrs_stripped’ set but not used [-Wunused-but-set-variable]
  840 |  unsigned int eth_hdrs_stripped;
      |               ^~~~~~~~~~~~~~~~~

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/fnic/fnic_fcs.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
index 643622f8e1d9..e3384afb7cbd 100644
--- a/drivers/scsi/fnic/fnic_fcs.c
+++ b/drivers/scsi/fnic/fnic_fcs.c
@@ -831,7 +831,6 @@ static void fnic_rq_cmpl_frame_recv(struct vnic_rq *rq, struct cq_desc
 	struct sk_buff *skb;
 	struct fc_frame *fp;
 	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
-	unsigned int eth_hdrs_stripped;
 	u8 type, color, eop, sop, ingress_port, vlan_stripped;
 	u8 fcoe = 0, fcoe_sof, fcoe_eof;
 	u8 fcoe_fc_crc_ok = 1, fcoe_enc_error = 0;
@@ -861,7 +860,6 @@ static void fnic_rq_cmpl_frame_recv(struct vnic_rq *rq, struct cq_desc
 				   &ingress_port, &packet_error,
 				   &fcoe_enc_error, &fcs_ok, &vlan_stripped,
 				   &vlan);
-		eth_hdrs_stripped = 1;
 		skb_trim(skb, fcp_bytes_written);
 		fr_sof(fp) = sof;
 		fr_eof(fp) = eof;
@@ -878,7 +876,6 @@ static void fnic_rq_cmpl_frame_recv(struct vnic_rq *rq, struct cq_desc
 				    &tcp_udp_csum_ok, &udp, &tcp,
 				    &ipv4_csum_ok, &ipv6, &ipv4,
 				    &ipv4_fragment, &fcs_ok);
-		eth_hdrs_stripped = 0;
 		skb_trim(skb, bytes_written);
 		if (!fcs_ok) {
 			atomic64_inc(&fnic_stats->misc_stats.frame_errors);
-- 
2.25.4

