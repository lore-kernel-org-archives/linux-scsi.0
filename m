Return-Path: <SRS0=0D1w=7E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB047C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 22 May 2020 16:52:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7359E206D5
	for <linux-scsi@archiver.kernel.org>; Fri, 22 May 2020 16:52:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="0BZ66Vr9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730487AbgEVQwU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 May 2020 12:52:20 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45150 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730445AbgEVQwT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2020 12:52:19 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MGmCoF127891;
        Fri, 22 May 2020 16:52:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=NbkzrpzfdMkZVyNkKF8d10u9zQwPbuOBwaLGLqxsGlc=;
 b=0BZ66Vr9tCjCVqTO1oRYWQpOQaMnH7o5lUXe+8GiR4ioflvWsi3BvTbqYBV2qzpPk9ZV
 lxk5L/Xtm7GNzHLsWchywj1u1VWxz0Ss6hY3dBJrBkpLkPdncFzb8I/ExOfIafQku8of
 ejlTXeWtegRWXCbUqekoWQOwblMXiCXrSzjhsnRJJrPiv2ub4VR9rHLHMAcXAkKNu4WC
 NAjmgPQVLEQZe8uiJop6N2MuaUIJ4TNaLh4Ph+xo2E2w7Xuz4cNsKJylAAfsZ7M2qqc5
 6QMSrtUNUnI0Suk3T7kMAv8swQyUjW4WPV4cw8h/42uNOJBQvH8RQgl9febvY6/pc/dD nw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3127krpthm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 16:52:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MGmk3G109572;
        Fri, 22 May 2020 16:52:14 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 313gj7sacb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 May 2020 16:52:14 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04MGqDIs013279;
        Fri, 22 May 2020 16:52:13 GMT
Received: from supannee-devvm-ol7.osdevelopmeniad.oraclevcn.com (/100.100.231.179)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 May 2020 09:52:13 -0700
From:   Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
To:     martin.petersen@oracle.com, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
        stefanha@redhat.com, shirley.ma@oracle.com
Subject: [PATCH 1/1] vhost: scsi: notify TCM about the maximum sg entries supported per command.
Date:   Fri, 22 May 2020 16:51:57 +0000
Message-Id: <1590166317-953-1-git-send-email-sudhakar.panneerselvam@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxscore=0 adultscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005220136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005220136
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

vhost-scsi pre-allocates the maximum sg entries per command and if a
command requires more than VHOST_SCSI_PREALLOC_SGLS entries, then that
command is failed by it. This patch lets vhost communicate the max sg limit
when it registers vhost_scsi_ops with TCM. With this change, TCM would
report the max sg entries through "Block Limits" VPD page which will be
typically queried by the SCSI initiator during device discovery. By knowing
this limit, the initiator could ensure the maximum transfer length is less
than or equal to what is reported by vhost-scsi.

Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
---
 drivers/vhost/scsi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index c39952243fd3..8b104f76f324 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -2280,6 +2280,7 @@ static void vhost_scsi_drop_tport(struct se_wwn *wwn)
 static const struct target_core_fabric_ops vhost_scsi_ops = {
 	.module				= THIS_MODULE,
 	.fabric_name			= "vhost",
+	.max_data_sg_nents		= VHOST_SCSI_PREALLOC_SGLS,
 	.tpg_get_wwn			= vhost_scsi_get_fabric_wwn,
 	.tpg_get_tag			= vhost_scsi_get_tpgt,
 	.tpg_check_demo_mode		= vhost_scsi_check_true,
-- 
1.8.3.1

