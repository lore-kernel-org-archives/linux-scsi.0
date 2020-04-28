Return-Path: <SRS0=LQeo=6M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF2E9C83000
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 13:19:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99EE6206D7
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 13:19:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="b31TCLjm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726940AbgD1NTw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Apr 2020 09:19:52 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39242 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726798AbgD1NTw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Apr 2020 09:19:52 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03SDIqLJ098202;
        Tue, 28 Apr 2020 13:19:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=83YLYkc42T7Bq9c88zHIHaMNTsQFsbRZDc6KWPO5drs=;
 b=b31TCLjm3kiqk+yIfMVWUzQqGUqaymGL1mApBAtSV/SDW2MkTDzW9a/IA8xDIm+47RHM
 QwNv7Y0B+Ug6sdPrr2W2600FlclHdZJ8eNkiD4bBANEo85JnyjIuNmMOrrDwercfTrGQ
 2D4ctCCKhtKxLCzehkEqcU3J/MvrzP3rbHSNqhbemkS0eZPwEM7JOGfVR3WWE2epD9ss
 Cv7Bvhb2EY/3vAgYsAh7njYJrAz6h04s2jjPqWACQKbf426bwiRJsoHWgtNZrpqtmWrj
 jw2mTCaRJJIadiUkV3QUVG+NXBaARJkQ3HHgOfV9MtLDKXs6MoYVXYsLkfxxijZnQo9e BA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 30nucfyve0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 13:19:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03SDGe8a186457;
        Tue, 28 Apr 2020 13:19:48 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 30mxpfxre8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 13:19:48 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03SDJkuW023002;
        Tue, 28 Apr 2020 13:19:46 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 Apr 2020 06:19:45 -0700
Date:   Tue, 28 Apr 2020 16:19:39 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     QLogic-Storage-Upstream@cavium.com,
        Manish Rangankar <manish.rangankar@cavium.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: qedi: Check for buffer overflow in qedi_set_path()
Message-ID: <20200428131939.GA696531@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004280104
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004280104
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Smatch complains that the "path_data->handle" variable is user
controlled.  It comes from iscsi_set_path() so that seems possible.
It's harmless to add a limit check.

The qedi->ep_tbl[] array has qedi->max_active_conns elements (which is
always ISCSI_MAX_SESS_PER_HBA (4096) elements).  The array is allocated
in the qedi_cm_alloc_mem() function.

Fixes: ace7f46ba5fd ("scsi: qedi: Add QLogic FastLinQ offload iSCSI driver framework.")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/scsi/qedi/qedi_iscsi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index b867a143d2638..425e665ec08b2 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -1221,6 +1221,10 @@ static int qedi_set_path(struct Scsi_Host *shost, struct iscsi_path *path_data)
 	}
 
 	iscsi_cid = (u32)path_data->handle;
+	if (iscsi_cid >= qedi->max_active_conns) {
+		ret = -EINVAL;
+		goto set_path_exit;
+	}
 	qedi_ep = qedi->ep_tbl[iscsi_cid];
 	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_INFO,
 		  "iscsi_cid=0x%x, qedi_ep=%p\n", iscsi_cid, qedi_ep);
-- 
2.26.2

