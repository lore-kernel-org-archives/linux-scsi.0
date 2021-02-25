Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D341EC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Feb 2021 21:51:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8894964F2C
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Feb 2021 21:51:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233440AbhBYVvt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Feb 2021 16:51:49 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47542 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231326AbhBYVvs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 25 Feb 2021 16:51:48 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11PLY8bR090122;
        Thu, 25 Feb 2021 16:51:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=nILnawZBkXgE9K7dLnpbGy1lY+tttA4o0oEurj3Me0Q=;
 b=jO2U+dql85EMh2TcWESwTRZNE8AaNZCqLEFe7DwBxfoJakISrREWumakQHGpXkM65jIV
 nclTgnaU7icdqa8py5jMqH394VlehWFuZPhgAs3wPWmweBHNGY80JOSUjaiTSkNpdHzb
 zm3WDk0wy216E49rhi5JhoURnO1k8aLu5iEHsHjyZxK68s5V3uYYGlbWbhaoRm73+Pit
 AzrgVUU1OWfUX4EcuzlbkM1tvWsCjxyq36LgaURvXhgGt4gFPXXjq0KQv8M5UhXetfEh
 ZIV9kH9BYzICV+5hnoTkFl+QnEIKBL7LdTqNnNAlXt7CAk9hB8RGf98OkPePQkl9wuCJ WA== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36xh8jw3tn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Feb 2021 16:51:01 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11PLmYGe018707;
        Thu, 25 Feb 2021 21:51:00 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma01wdc.us.ibm.com with ESMTP id 36tt29hvw6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Feb 2021 21:51:00 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11PLoxCU24641830
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Feb 2021 21:50:59 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 169E36E050;
        Thu, 25 Feb 2021 21:50:59 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC40D6E04C;
        Thu, 25 Feb 2021 21:50:58 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 25 Feb 2021 21:50:58 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v4 1/5] ibmvfc: simplify handling of sub-CRQ initialization
Date:   Thu, 25 Feb 2021 15:50:53 -0600
Message-Id: <20210225215057.23020-2-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210225215057.23020-1-tyreld@linux.ibm.com>
References: <20210225215057.23020-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-25_14:2021-02-24,2021-02-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 clxscore=1015 phishscore=0 malwarescore=0 priorityscore=1501 adultscore=0
 impostorscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102250163
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If ibmvfc_init_sub_crqs() fails ibmvfc_probe() simply parrots
registration failure reported elsewhere, and futher
vhost->scsi_scrq.scrq == NULL is indication enough to the driver that it
has no sub-CRQs available. The mq_enabled check can also be moved into
ibmvfc_init_sub_crqs() such that each caller doesn't have to gate the
call with a mq_enabled check. Finally, in the case of sub-CRQ setup
failure setting do_enquiry can be turned off to putting the driver into
single queue fallback mode.

The aforementioned changes also simplify the next patch in the series
that fixes a hard reset issue, by tying a sub-CRQ setup failure and
do_enquiry logic into ibmvfc_init_sub_crqs().

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Reviewed-by: Brian King <brking@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 7097028d4cb6..384960036f8b 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -5705,17 +5705,21 @@ static void ibmvfc_deregister_scsi_channel(struct ibmvfc_host *vhost, int index)
 	LEAVE;
 }
 
-static int ibmvfc_init_sub_crqs(struct ibmvfc_host *vhost)
+static void ibmvfc_init_sub_crqs(struct ibmvfc_host *vhost)
 {
 	int i, j;
 
 	ENTER;
+	if (!vhost->mq_enabled)
+		return;
 
 	vhost->scsi_scrqs.scrqs = kcalloc(nr_scsi_hw_queues,
 					  sizeof(*vhost->scsi_scrqs.scrqs),
 					  GFP_KERNEL);
-	if (!vhost->scsi_scrqs.scrqs)
-		return -1;
+	if (!vhost->scsi_scrqs.scrqs) {
+		vhost->do_enquiry = 0;
+		return;
+	}
 
 	for (i = 0; i < nr_scsi_hw_queues; i++) {
 		if (ibmvfc_register_scsi_channel(vhost, i)) {
@@ -5724,13 +5728,12 @@ static int ibmvfc_init_sub_crqs(struct ibmvfc_host *vhost)
 			kfree(vhost->scsi_scrqs.scrqs);
 			vhost->scsi_scrqs.scrqs = NULL;
 			vhost->scsi_scrqs.active_queues = 0;
-			LEAVE;
-			return -1;
+			vhost->do_enquiry = 0;
+			break;
 		}
 	}
 
 	LEAVE;
-	return 0;
 }
 
 static void ibmvfc_release_sub_crqs(struct ibmvfc_host *vhost)
@@ -5997,11 +6000,7 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 		goto remove_shost;
 	}
 
-	if (vhost->mq_enabled) {
-		rc = ibmvfc_init_sub_crqs(vhost);
-		if (rc)
-			dev_warn(dev, "Failed to allocate Sub-CRQs. rc=%d\n", rc);
-	}
+	ibmvfc_init_sub_crqs(vhost);
 
 	if (shost_to_fc_host(shost)->rqst_q)
 		blk_queue_max_segments(shost_to_fc_host(shost)->rqst_q, 1);
-- 
2.27.0

