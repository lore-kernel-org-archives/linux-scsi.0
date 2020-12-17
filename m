Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2FADC2BB9A
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 06:43:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91A59238A0
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 06:43:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbgLQGnV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Dec 2020 01:43:21 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:47662 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726512AbgLQGnR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Dec 2020 01:43:17 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BH6Ttwv164261;
        Thu, 17 Dec 2020 06:42:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=rkx9mmw3ZFDugBiaDjfrKsHPT24kSDN8MswAMrDg9XM=;
 b=w61ZsbSGpDyOL6ZQKpff2v+XrztNzq60Qji9bQmHm+YVAMkLERtQk+HE8EhenL87b1pb
 BKS7uBIGJUeWpttsDJY3psp5tm7aONxMxGKWhrcg44wk8UuFhfUJ/bq6Hb6xVEHPggfD
 k0alxnt+hp1aEywAq3rXGy/EDcXD9lCKAFOCjKpCqKG+CBMwyG5MIlQ0BzN1klv4g9Mp
 Osd0XlRFXX1NJs14g7c5D7NjfWccJFTMb0CJSrVnwBiNu290crKhG2GG4xNBNO1JoTeC
 64rMGjv26V8oGusvmHWA25W8R0znDkbB9o7CTkexEuRbkzHtu1eeijPxG1JF/OX7is9s CQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 35cntmbudn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Dec 2020 06:42:26 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BH6VHlg143597;
        Thu, 17 Dec 2020 06:42:25 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 35d7eqfab8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Dec 2020 06:42:25 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BH6gOdY006521;
        Thu, 17 Dec 2020 06:42:24 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 16 Dec 2020 22:42:23 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Subject: [PATCH 04/22] qla4xxx: use iscsi_is_session_online
Date:   Thu, 17 Dec 2020 00:41:54 -0600
Message-Id: <1608187332-4434-5-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1608187332-4434-1-git-send-email-michael.christie@oracle.com>
References: <1608187332-4434-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9837 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012170047
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9837 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 priorityscore=1501 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012170047
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

__qla4xxx_is_chap_active just wants to know if a session is online and
does not care about why it's not, so this has it use
iscsi_is_session_online.

This is not a bug now, but the next patch changes the behavior of
iscsi_session_chkready so this patch just prepares the driver for that
change.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
---
 drivers/scsi/qla4xxx/ql4_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 2c23b69..6996942 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -844,7 +844,7 @@ static int __qla4xxx_is_chap_active(struct device *dev, void *data)
 	sess = cls_session->dd_data;
 	ddb_entry = sess->dd_data;
 
-	if (iscsi_session_chkready(cls_session))
+	if (iscsi_is_session_online(cls_session))
 		goto exit_is_chap_active;
 
 	if (ddb_entry->chap_tbl_idx == *chap_tbl_idx)
-- 
1.8.3.1

