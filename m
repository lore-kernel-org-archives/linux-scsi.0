Return-Path: <SRS0=fvsq=YM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52390CA9EAB
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Oct 2019 08:59:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B8EB222C2
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Oct 2019 08:59:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hIbYwfZ/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728323AbfJSI72 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Oct 2019 04:59:28 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37586 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728270AbfJSI72 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Oct 2019 04:59:28 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9J8xNA3121416;
        Sat, 19 Oct 2019 08:59:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=0/eTYgKMfcByarnMdtpllDVRCHrlR/j9HrDm4SXKZqM=;
 b=hIbYwfZ/2W+yKjmyRpgHIWVjV5t84x9pbVUxwyBrOS1HawbZbGBm0sSrTWzEuJLprZXd
 mgzWty+fDjlFm9oSM5ZUTjn6HPJde/I2yyopI1GUHmLSCs78SPP6EelVj+MgDHnmMoyt
 CJvhDVg+AOWRTLpdTG5thxchtyCUeUJSZSKUgbmjYWU3Vk07dCtdOLWm0tMUFRVlvY1/
 dng/qHh2szfwbsFp9GSjUc6abF8KTfDtMVE/9k9llgO6AcP1xWzoZk9NRvV7qnPAIiP5
 v1Mpr0CuJNeJb8C1s0i3AOtrGIykS3DjyI/NeEso1qcV3iCBR787VtIJiKCsE/AEGItC +w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2vqtep8r1g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Oct 2019 08:59:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9J8wNPA147162;
        Sat, 19 Oct 2019 08:59:22 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2vqsu7j9r4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Oct 2019 08:59:22 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9J8xKAP017388;
        Sat, 19 Oct 2019 08:59:21 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 19 Oct 2019 08:59:20 +0000
Date:   Sat, 19 Oct 2019 11:59:13 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Naresh Kumar Inna <naresh@chelsio.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: csiostor: Don't enable IRQs too early
Message-ID: <20191019085913.GA14245@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9414 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910190079
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9414 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910190079
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

These are called with IRQs disabled from csio_mgmt_tmo_handler() so we
can't call spin_unlock_irq() or it will enable IRQs prematurely.

Fixes: a3667aaed569 ("[SCSI] csiostor: Chelsio FCoE offload driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/scsi/csiostor/csio_lnode.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_lnode.c b/drivers/scsi/csiostor/csio_lnode.c
index 66e58f0a75dc..23cbe4cda760 100644
--- a/drivers/scsi/csiostor/csio_lnode.c
+++ b/drivers/scsi/csiostor/csio_lnode.c
@@ -301,6 +301,7 @@ csio_ln_fdmi_rhba_cbfn(struct csio_hw *hw, struct csio_ioreq *fdmi_req)
 	struct fc_fdmi_port_name *port_name;
 	uint8_t buf[64];
 	uint8_t *fc4_type;
+	unsigned long flags;
 
 	if (fdmi_req->wr_status != FW_SUCCESS) {
 		csio_ln_dbg(ln, "WR error:%x in processing fdmi rhba cmd\n",
@@ -385,13 +386,13 @@ csio_ln_fdmi_rhba_cbfn(struct csio_hw *hw, struct csio_ioreq *fdmi_req)
 	len = (uint32_t)(pld - (uint8_t *)cmd);
 
 	/* Submit FDMI RPA request */
-	spin_lock_irq(&hw->lock);
+	spin_lock_irqsave(&hw->lock, flags);
 	if (csio_ln_mgmt_submit_req(fdmi_req, csio_ln_fdmi_done,
 				FCOE_CT, &fdmi_req->dma_buf, len)) {
 		CSIO_INC_STATS(ln, n_fdmi_err);
 		csio_ln_dbg(ln, "Failed to issue fdmi rpa req\n");
 	}
-	spin_unlock_irq(&hw->lock);
+	spin_unlock_irqrestore(&hw->lock, flags);
 }
 
 /*
@@ -412,6 +413,7 @@ csio_ln_fdmi_dprt_cbfn(struct csio_hw *hw, struct csio_ioreq *fdmi_req)
 	struct fc_fdmi_rpl *reg_pl;
 	struct fs_fdmi_attrs *attrib_blk;
 	uint8_t buf[64];
+	unsigned long flags;
 
 	if (fdmi_req->wr_status != FW_SUCCESS) {
 		csio_ln_dbg(ln, "WR error:%x in processing fdmi dprt cmd\n",
@@ -491,13 +493,13 @@ csio_ln_fdmi_dprt_cbfn(struct csio_hw *hw, struct csio_ioreq *fdmi_req)
 	attrib_blk->numattrs = htonl(numattrs);
 
 	/* Submit FDMI RHBA request */
-	spin_lock_irq(&hw->lock);
+	spin_lock_irqsave(&hw->lock, flags);
 	if (csio_ln_mgmt_submit_req(fdmi_req, csio_ln_fdmi_rhba_cbfn,
 				FCOE_CT, &fdmi_req->dma_buf, len)) {
 		CSIO_INC_STATS(ln, n_fdmi_err);
 		csio_ln_dbg(ln, "Failed to issue fdmi rhba req\n");
 	}
-	spin_unlock_irq(&hw->lock);
+	spin_unlock_irqrestore(&hw->lock, flags);
 }
 
 /*
@@ -512,6 +514,7 @@ csio_ln_fdmi_dhba_cbfn(struct csio_hw *hw, struct csio_ioreq *fdmi_req)
 	void *cmd;
 	struct fc_fdmi_port_name *port_name;
 	uint32_t len;
+	unsigned long flags;
 
 	if (fdmi_req->wr_status != FW_SUCCESS) {
 		csio_ln_dbg(ln, "WR error:%x in processing fdmi dhba cmd\n",
@@ -542,13 +545,13 @@ csio_ln_fdmi_dhba_cbfn(struct csio_hw *hw, struct csio_ioreq *fdmi_req)
 	len += sizeof(*port_name);
 
 	/* Submit FDMI request */
-	spin_lock_irq(&hw->lock);
+	spin_lock_irqsave(&hw->lock, flags);
 	if (csio_ln_mgmt_submit_req(fdmi_req, csio_ln_fdmi_dprt_cbfn,
 				FCOE_CT, &fdmi_req->dma_buf, len)) {
 		CSIO_INC_STATS(ln, n_fdmi_err);
 		csio_ln_dbg(ln, "Failed to issue fdmi dprt req\n");
 	}
-	spin_unlock_irq(&hw->lock);
+	spin_unlock_irqrestore(&hw->lock, flags);
 }
 
 /**
-- 
2.20.1

