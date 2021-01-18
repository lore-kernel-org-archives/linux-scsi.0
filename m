Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16D66C433E6
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 20:38:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFE6022B39
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 20:38:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388361AbhARUhy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jan 2021 15:37:54 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:43182 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388360AbhARUhm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jan 2021 15:37:42 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10IKYgqP182469;
        Mon, 18 Jan 2021 20:36:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=WEJimV81r45yjghIbTvK2WquM5hvx0QLO5eGWeQLv/U=;
 b=VRwghXrMuS8pqqo63LsC/eAlHWhPij46LV5ctAHSzn+1dW0+JSrwjJpUYy38/g4PbOsD
 BLEgDMIGFUskh/FIWlSClbROAkUK6gD51DaKd+2eE+JfMAwYG402Ye5erL20P3qMItTi
 GHvCvyhI1ckbLQI6rtgrjlZKVY2D6SNHSZUsskyWJf17eLvtRmpWWdCs0AZvN5moeU9M
 eq7m4tlGt9XhvGrOumyR2cni8ruyuAqTGZg4h2QWjkSIOuju5tmw1qxr/ZaNrkZaVvUd
 qmB+MrIaczmdOwSppO0xQ+0Q6tI9RZyrGrM7Ds0czK9bHYptFPUGHE8j9iqx80TZKZwW 7g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 363xyhnxdn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Jan 2021 20:36:46 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10IKQKWF061926;
        Mon, 18 Jan 2021 20:34:45 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 364a1wsuwc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Jan 2021 20:34:45 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 10IKYhZS021845;
        Mon, 18 Jan 2021 20:34:43 GMT
Received: from localhost.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 Jan 2021 12:34:43 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     lutianxiong@huawei.com, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com, haowenchao@huawei.com
Subject: [PATCH 4/7] libiscsi: fix iscsi host workq destruction
Date:   Mon, 18 Jan 2021 14:34:27 -0600
Message-Id: <20210118203430.4921-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210118203430.4921-1-michael.christie@oracle.com>
References: <20210118203430.4921-1-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9868 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 adultscore=0
 mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101180123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9868 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 bulkscore=0 priorityscore=1501 spamscore=0
 mlxscore=0 impostorscore=0 lowpriorityscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101180124
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We allocate the iscsi host workq in iscsi_host_alloc so iscsi_host_free
should do the destruction. Drivers can then do their error/goto handling
and call iscsi_host_free to clean up what has been allocated in
iscsi_host_alloc.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index ec159bcb7460..b271d3accd2a 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2738,8 +2738,6 @@ void iscsi_host_remove(struct Scsi_Host *shost)
 		flush_signals(current);
 
 	scsi_remove_host(shost);
-	if (ihost->workq)
-		destroy_workqueue(ihost->workq);
 }
 EXPORT_SYMBOL_GPL(iscsi_host_remove);
 
@@ -2747,6 +2745,9 @@ void iscsi_host_free(struct Scsi_Host *shost)
 {
 	struct iscsi_host *ihost = shost_priv(shost);
 
+	if (ihost->workq)
+		destroy_workqueue(ihost->workq);
+
 	kfree(ihost->netdev);
 	kfree(ihost->hwaddress);
 	kfree(ihost->initiatorname);
-- 
2.25.1

