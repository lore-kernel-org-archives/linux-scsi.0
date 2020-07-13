Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68D09C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 10:51:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EFCF20758
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 10:51:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VAtcTC2G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729543AbgGMKvo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 06:51:44 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39692 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728883AbgGMKvn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 06:51:43 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06DAkpen151425;
        Mon, 13 Jul 2020 10:51:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=8DgsNCqKYEALDnInlZ5lHD/RVlJxVBfXAfQjAhgOf+s=;
 b=VAtcTC2G5wNMFPg83SN9gHc+j8PkqqJ4SSE6spR3k/mJ3ULDVYI/pluNSetrsEB4JuO2
 +rjb61sUDu+XI91wBq9HgZ+8UrfzRuommKe21Ac+FCGfCgzusNfT9cGXPBI3DcZiXx78
 LCpNU6AUoPglaVuGQrigUq2/IMpty2irsjjVx9gICYtJh/J6c7JQ0G8IRcJJ2fSb7kf2
 K3nRedpEUsZuvoMR23FjmPrCclkGC/pjO2dyF7uKYmTj6V7KVH43K+XslmhMO6xkF1IT
 7OpVux/XVtAHR/1j/LA6ZnmysgOPLgG70EJfvppVQWw1hzYCCfgl2UxFbTPYRjiZFKXu /Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 3275ckx9he-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 13 Jul 2020 10:51:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06DAbYQf060288;
        Mon, 13 Jul 2020 10:51:35 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 327qb0agtc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Jul 2020 10:51:35 +0000
Received: from abhmp0021.oracle.com (abhmp0021.oracle.com [141.146.116.27])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06DApY38019026;
        Mon, 13 Jul 2020 10:51:34 GMT
Received: from mwanda (/41.57.98.10) by default (Oracle Beehive Gateway v4.0)
 with ESMTP ; Mon, 13 Jul 2020 03:51:06 -0700
MIME-Version: 1.0
Message-ID: <20200713105100.GA251988@mwanda>
Date:   Mon, 13 Jul 2020 10:51:00 +0000 (UTC)
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Varun Prakash <varun@chelsio.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>,
        Austin Kim <austindh.kim@gmail.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: cxgb4i: clean up a debug printk
X-Mailer: git-send-email haha only kidding
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9680 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007130080
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9680 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 clxscore=1011 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007130081
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pr_fmt() at the top of the file already includes the __func__ so we
can remove the duplicative "cxgbi_conn_init_pdu:" from the string here.
Now it all fits on one  line as well.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/scsi/cxgbi/libcxgbi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index 1fb101c616b7..ba1593be626c 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -2182,8 +2182,7 @@ int cxgbi_conn_init_pdu(struct iscsi_task *task, unsigned int offset,
 	}
 
 	log_debug(1 << CXGBI_DBG_ISCSI | 1 << CXGBI_DBG_PDU_TX,
-		  "cxgbi_conn_init_pdu: tdata->total_count %u, "
-		  "tdata->total_offset %u\n",
+		  "data->total_count %u, tdata->total_offset %u\n",
 		  tdata->total_count, tdata->total_offset);
 
 	expected_count = tdata->total_count;
-- 
2.27.0

