Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D086C6FD1C
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Mar 2023 02:06:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbjCUCGs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Mar 2023 22:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbjCUCGp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Mar 2023 22:06:45 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93605305E8;
        Mon, 20 Mar 2023 19:06:43 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32KM4jhZ002767;
        Tue, 21 Mar 2023 02:06:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2022-7-12;
 bh=aTJJ4weWrYnJIs0IA7nCgrrq0FlpDP7lnLmNUEHvhDg=;
 b=aocPJm8lojy/LfEo1SQFAY3lxfvKAgDihPO/Hs0y4kbyK70+JA/kTCF3rSN9+iZ3npF7
 fpAZeyhT9wiAPGZ8vH1MGkmU0Iq3BqqGFVkhPTDpCVqULZ8JhM47rBkZC9VFWsXJDzeo
 zjPLrKkyd18anBQ+3udwQqW/Zj/50w1+3d3w7s0HGARROLrpnmRetfd518EWx6e4PWsA
 39VjWH2L5gpa1IKBC0FgmwJ7NSk7IthV1jyjgZpAnDfc9qqvt7cgRwM3BiQc0Rt7vb4n
 XtrMNYejmjz7+9DcXPoVz+sSHXc6uAv06/VF5WpXxEs6Qnu+cYeoStC+4CdD2rntyJzc vA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pd5uucvcj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Mar 2023 02:06:40 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32KNL7pw010476;
        Tue, 21 Mar 2023 02:06:38 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3peqjn4c53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Mar 2023 02:06:38 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32L26T9c007440;
        Tue, 21 Mar 2023 02:06:38 GMT
Received: from mnchrist-mac.us.oracle.com (dhcp-10-154-165-250.vpn.oracle.com [10.154.165.250])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3peqjn4c0v-7;
        Tue, 21 Mar 2023 02:06:38 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 6/7] vhost-scsi: Drop vhost_scsi_mutex use in port callouts
Date:   Mon, 20 Mar 2023 21:06:23 -0500
Message-Id: <20230321020624.13323-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230321020624.13323-1-michael.christie@oracle.com>
References: <20230321020624.13323-1-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-20_18,2023-03-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303210017
X-Proofpoint-GUID: el6c7okFz3kL4d464xOqzS6IgehnEWXR
X-Proofpoint-ORIG-GUID: el6c7okFz3kL4d464xOqzS6IgehnEWXR
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We are using the vhost_scsi_mutex to make sure vhost_scsi_port_link and
vhost_scsi_port_unlink see if vhost_scsi_clear_endpoint has cleared
tpg->vhost_scsi and it can't be freed while they are using.
 
However, we currently set the tpg->vhost_scsi pointer while holding
tv_tpg_mutex. So, we can just hold that while calling
vhost_scsi_hotplug/hotunplug. We then don't need to hold the
vhost_scsi_mutex while vhost_scsi_clear_endpoint is holding it and doing
a flush which could cause the LUN map/unmap to have to wait on another
device's flush.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index ba8097fcea43..d4372a4aff49 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -2040,15 +2040,10 @@ static int vhost_scsi_port_link(struct se_portal_group *se_tpg,
 	struct vhost_scsi_tpg *tpg = container_of(se_tpg,
 				struct vhost_scsi_tpg, se_tpg);
 
-	mutex_lock(&vhost_scsi_mutex);
-
 	mutex_lock(&tpg->tv_tpg_mutex);
 	tpg->tv_tpg_port_count++;
-	mutex_unlock(&tpg->tv_tpg_mutex);
-
 	vhost_scsi_hotplug(tpg, lun);
-
-	mutex_unlock(&vhost_scsi_mutex);
+	mutex_unlock(&tpg->tv_tpg_mutex);
 
 	return 0;
 }
@@ -2059,15 +2054,10 @@ static void vhost_scsi_port_unlink(struct se_portal_group *se_tpg,
 	struct vhost_scsi_tpg *tpg = container_of(se_tpg,
 				struct vhost_scsi_tpg, se_tpg);
 
-	mutex_lock(&vhost_scsi_mutex);
-
 	mutex_lock(&tpg->tv_tpg_mutex);
 	tpg->tv_tpg_port_count--;
-	mutex_unlock(&tpg->tv_tpg_mutex);
-
 	vhost_scsi_hotunplug(tpg, lun);
-
-	mutex_unlock(&vhost_scsi_mutex);
+	mutex_unlock(&tpg->tv_tpg_mutex);
 }
 
 static ssize_t vhost_scsi_tpg_attrib_fabric_prot_type_store(
-- 
2.25.1

