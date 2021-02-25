Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 041C0C4332D
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Feb 2021 21:43:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBD3D64F30
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Feb 2021 21:43:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234680AbhBYVno (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Feb 2021 16:43:44 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:10630 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234458AbhBYVnb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 25 Feb 2021 16:43:31 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11PLX5iG075702;
        Thu, 25 Feb 2021 16:42:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=sYHcfn9UZuLqFHPWaElPDEe18DCVcGq3h/d7UNHgvgY=;
 b=LTWUEnw/xBjTzGMVyi3Je1wWO2Pv7ddcnyl3KAS7TKvkGxgW3CCr1KTkd5ye+mgbx++E
 dSMnAD3JIGoR3mIRSZzK1If0jSGn6Z/PDiO2BNci05OYR7tOtEDDWiJVznQM63VBh0ZU
 gYlOTtClgAK8+icExCqu3GnvtXUAfY4yjUA1mGqYKPj4Hhm4PgNIhypizDUGrGEmq1Ba
 cxjKS2B8531yOGmWACTUgv+gMdvSzcqBP+dtaCzhRbplrKKtL46NhI+m33bDgCmgblCU
 3MDADxayVhviFg/Ohr3E8pK/g3VPjBYOwmkiqdkAkgosRPu3DXX8D6otjGY82TKpFoBk JQ== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36xh994xm9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Feb 2021 16:42:45 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11PLRvwE018570;
        Thu, 25 Feb 2021 21:42:44 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma03dal.us.ibm.com with ESMTP id 36v5y9mryj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Feb 2021 21:42:44 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11PLggfM14811476
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Feb 2021 21:42:42 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 956687805F;
        Thu, 25 Feb 2021 21:42:42 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 16E937805C;
        Thu, 25 Feb 2021 21:42:42 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 25 Feb 2021 21:42:41 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v3 5/5] ibmvfc: reinitialize sub-CRQs and perform channel enquiry after LPM
Date:   Thu, 25 Feb 2021 15:42:37 -0600
Message-Id: <20210225214237.22400-6-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210225214237.22400-1-tyreld@linux.ibm.com>
References: <20210225214237.22400-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-25_14:2021-02-24,2021-02-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 impostorscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 clxscore=1015 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102250163
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A live partition migration (LPM) results in a CRQ disconnect similar to
a hard reset. In this LPM case the hypervisor moslty perserves the CRQ
transport such that it simply needs to be reenabled. However, the
capabilities may have changed such as fewer channels, or no channels at
all. Further, its possible that there may be sub-CRQ support, but no
channel support. The CRQ reenable path currently doesn't take any of
this into consideration.

For simpilicty release and reinitialize sub-CRQs during reenable, and
set do_enquiry and using_channels with the appropriate values to trigger
channel renegotiation.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 1bb08e5f3674..6bbc2697ad5a 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -903,6 +903,9 @@ static int ibmvfc_reenable_crq_queue(struct ibmvfc_host *vhost)
 {
 	int rc = 0;
 	struct vio_dev *vdev = to_vio_dev(vhost->dev);
+	unsigned long flags;
+
+	ibmvfc_release_sub_crqs(vhost);
 
 	/* Re-enable the CRQ */
 	do {
@@ -914,6 +917,15 @@ static int ibmvfc_reenable_crq_queue(struct ibmvfc_host *vhost)
 	if (rc)
 		dev_err(vhost->dev, "Error enabling adapter (rc=%d)\n", rc);
 
+	ibmvfc_init_sub_crqs(vhost);
+
+	spin_lock_irqsave(vhost->host->host_lock, flags);
+	spin_lock(vhost->crq.q_lock);
+	vhost->do_enquiry = 1;
+	vhost->using_channels = 0;
+	spin_unlock(vhost->crq.q_lock);
+	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+
 	return rc;
 }
 
-- 
2.27.0

