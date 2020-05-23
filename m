Return-Path: <SRS0=JddF=7F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E6F8C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 23 May 2020 10:11:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41DF820727
	for <linux-scsi@archiver.kernel.org>; Sat, 23 May 2020 10:11:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oCl8f3IC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387759AbgEWKLp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 23 May 2020 06:11:45 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47792 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbgEWKLp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 23 May 2020 06:11:45 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04NA8E8r056160;
        Sat, 23 May 2020 10:11:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=n4h8Ze/WKiLXL3/dPkzL/wAshMKn0b30Ha6W6Rr7XF8=;
 b=oCl8f3ICddFsd+XbIb+UWjYuM20nfc+mTATGV6AaPSujHe2g4Vvf1HVK0coJPmEE0Jb5
 SkVT+li1vlyRmeQecBv6McHElWBjb3Pp1OVqVGAKydxY4iWrliHOk+CccX+ZP3r4JBYH
 /9YuUnMJXzynwu11vuM0N1P62FC3WqQzVFYFFnPsHYk4MGu4dLn+YtWS19XmlHF/9f9E
 ACtwTrOO72E4+w7hazE/BxdX5iTWyhWnO/r5WGl6xtbJbzw87z7m9g8PgPxR2w6fR/4n
 VVHLRiOmHNPFC9CfKcuJ6xUAsZoNTgxvPl7P8W8Rn2CnZV7DFYMLxlPt+GE5VDXxBva2 Bw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 316u8qgpgr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 23 May 2020 10:11:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04NA9Ie4122828;
        Sat, 23 May 2020 10:11:38 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 316un0g2wq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 May 2020 10:11:37 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04NABbO9022106;
        Sat, 23 May 2020 10:11:37 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 23 May 2020 03:11:36 -0700
Date:   Sat, 23 May 2020 13:11:29 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bodo Stroesser <bstroesser@ts.fujitsu.com>
Cc:     Mike Christie <mchristi@redhat.com>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: target: tcmu: Fix a use after free in
 tcmu_check_expired_queue_cmd()
Message-ID: <20200523101129.GB98132@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 phishscore=0 spamscore=0 suspectscore=2 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005230084
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 spamscore=0 cotscore=-2147483648 suspectscore=2
 phishscore=0 clxscore=1011 mlxlogscore=999 bulkscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005230084
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pr_debug() dereferences "cmd" after we already freed it by calling
tcmu_free_cmd(cmd).  The debug printk needs to be done earlier.

Fixes: 61fb24822166 ("scsi: target: tcmu: Userspace must not complete queued commands")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/target/target_core_user.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 904d8a8373f2..28fb9441de7a 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1292,13 +1292,13 @@ static void tcmu_check_expired_queue_cmd(struct tcmu_cmd *cmd)
 	if (!time_after(jiffies, cmd->deadline))
 		return;
 
+	pr_debug("Timing out queued cmd %p on dev %s.\n",
+		  cmd, cmd->tcmu_dev->name);
+
 	list_del_init(&cmd->queue_entry);
 	se_cmd = cmd->se_cmd;
 	tcmu_free_cmd(cmd);
 
-	pr_debug("Timing out queued cmd %p on dev %s.\n",
-		  cmd, cmd->tcmu_dev->name);
-
 	target_complete_cmd(se_cmd, SAM_STAT_TASK_SET_FULL);
 }
 
-- 
2.26.2

