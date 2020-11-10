Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFD1DC55ABD
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Nov 2020 05:33:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BECC20795
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Nov 2020 05:33:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iUe9uy4L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731493AbgKJFdm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Nov 2020 00:33:42 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:51896 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbgKJFdj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Nov 2020 00:33:39 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AA5KHjG151983;
        Tue, 10 Nov 2020 05:33:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=A9bovLFaElhDaavp8mepiemNjazWnq9Kn/aEjeexg/g=;
 b=iUe9uy4LOSe/QBK0+XosahZao63PxTlXyNCHTUCI2G2oEGhm2/7fHeYAoptAKBiy/Sx+
 G2JDfztJPBuZb631mtsXEYttdvTw+2uMXjs343SGISZqsgGLNNM+ZBKVjxwbGiBGmhOz
 kc8QVgPKx8ujkqUd5p8zzjVQxcgNNQFQ/Y+So2acR0tDXVVN4JOFaIseHjwchEWYbn8K
 cumJGqf8zIDi093UvrZc7q4tsDaA21Udf57q6SgIrcm4iHH1iUsb94pVa5Nn46pG/YRJ
 jUdzPcXhC6THFO5/Z53Yqym04AhnnQG//1gcZEc3Miqe8R2qav4iQx+gzDEQ5zM5RhV+ Og== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 34nh3asuah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 10 Nov 2020 05:33:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AA5G5CO002694;
        Tue, 10 Nov 2020 05:33:35 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 34p5gwb6nf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Nov 2020 05:33:34 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AA5XYnd022476;
        Tue, 10 Nov 2020 05:33:34 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 09 Nov 2020 21:33:33 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
        stefanha@redhat.com, virtualization@lists.linux-foundation.org
Subject: [PATCH 4/5] vhost scsi: add lun parser helper
Date:   Mon,  9 Nov 2020 23:33:22 -0600
Message-Id: <1604986403-4931-5-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1604986403-4931-1-git-send-email-michael.christie@oracle.com>
References: <1604986403-4931-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9800 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 phishscore=0 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011100037
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9800 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011100037
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move code to parse lun from req's lun_buf to helper, so tmf code
can use it in the next patch.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/scsi.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 5d8850f..ed7dc6b 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -898,6 +898,11 @@ static void vhost_scsi_submission_work(struct work_struct *work)
 	return ret;
 }
 
+static u16 vhost_buf_to_lun(u8 *lun_buf)
+{
+	return ((lun_buf[2] << 8) | lun_buf[3]) & 0x3FFF;
+}
+
 static void
 vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 {
@@ -1036,12 +1041,12 @@ static void vhost_scsi_submission_work(struct work_struct *work)
 			tag = vhost64_to_cpu(vq, v_req_pi.tag);
 			task_attr = v_req_pi.task_attr;
 			cdb = &v_req_pi.cdb[0];
-			lun = ((v_req_pi.lun[2] << 8) | v_req_pi.lun[3]) & 0x3FFF;
+			lun = vhost_buf_to_lun(v_req_pi.lun);
 		} else {
 			tag = vhost64_to_cpu(vq, v_req.tag);
 			task_attr = v_req.task_attr;
 			cdb = &v_req.cdb[0];
-			lun = ((v_req.lun[2] << 8) | v_req.lun[3]) & 0x3FFF;
+			lun = vhost_buf_to_lun(v_req.lun);
 		}
 		/*
 		 * Check that the received CDB size does not exceeded our
-- 
1.8.3.1

