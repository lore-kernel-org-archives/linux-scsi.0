Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5CF0C83036
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 02:09:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C5E422203
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 02:09:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729415AbgLCCJB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Dec 2020 21:09:01 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:11392 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728142AbgLCCJA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2020 21:09:00 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B322lbo095985;
        Wed, 2 Dec 2020 21:08:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=0vrJkpxV7J6wUU6nHBy8wxjwXBtmUbHss6o/M2/SEuI=;
 b=GRCHzgZED+MHc7NVpt8I+4MfvrqoLpnealIRqV5G8YuuwbxFlfL0JoocBUK/y8K2jbt+
 Qt/8Bw2ms0jHnINmTVVHgra4LPP27u19o4ddOK8fSOhAFhSllxG1RG6w7/Yp2IjjbS0k
 4e8PCyDjFnQtSz5LL/KUQozRRoZdpfdH6r/SMXstiKf9kbxm2LqYGUjOZuN3PBFJfH5O
 remkjn/KixdVebJZVriU9PD6kH6Q3iD+KoErubcvTecj7KHkgaE311fWp4D234CTl6GA
 jH0dVWC1vO0iFnvvJIeRqJVJHKOcFLoPJD2+p33rdFJ0upfOPSFzRbzZsbpeijNlOUDl Ow== 
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 356jfcxxdc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Dec 2020 21:08:15 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B327YJZ004616;
        Thu, 3 Dec 2020 02:08:14 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma04wdc.us.ibm.com with ESMTP id 354ysup6px-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Dec 2020 02:08:14 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B328CJm25559308
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Dec 2020 02:08:12 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C88AF78066;
        Thu,  3 Dec 2020 02:08:12 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 31E4178060;
        Thu,  3 Dec 2020 02:08:12 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  3 Dec 2020 02:08:12 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH v3 05/18] ibmvfc: add Sub-CRQ IRQ enable/disable routine
Date:   Wed,  2 Dec 2020 20:07:53 -0600
Message-Id: <20201203020806.14747-6-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201203020806.14747-1-tyreld@linux.ibm.com>
References: <20201203020806.14747-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-02_14:2020-11-30,2020-12-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 priorityscore=1501 bulkscore=0 impostorscore=0 suspectscore=1
 mlxlogscore=766 spamscore=0 malwarescore=0 mlxscore=0 clxscore=1015
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030009
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Each Sub-CRQ has its own interrupt. A hypercall is required to toggle
the IRQ state. Provide the necessary mechanism via a helper function.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index f879be666c84..e082935f56cf 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -3361,6 +3361,26 @@ static void ibmvfc_tasklet(void *data)
 	spin_unlock_irqrestore(vhost->host->host_lock, flags);
 }
 
+static int ibmvfc_toggle_scrq_irq(struct ibmvfc_sub_queue *scrq, int enable)
+{
+	struct device *dev = scrq->vhost->dev;
+	struct vio_dev *vdev = to_vio_dev(dev);
+	unsigned long rc;
+	int irq_action = H_ENABLE_VIO_INTERRUPT;
+
+	if (!enable)
+		irq_action = H_DISABLE_VIO_INTERRUPT;
+
+	rc = plpar_hcall_norets(H_VIOCTL, vdev->unit_address, irq_action,
+				scrq->hw_irq, 0, 0);
+
+	if (rc)
+		dev_err(dev, "Couldn't %s sub-crq[%lu] irq. rc=%ld\n",
+			enable ? "enable" : "disable", scrq->hwq_id, rc);
+
+	return rc;
+}
+
 /**
  * ibmvfc_init_tgt - Set the next init job step for the target
  * @tgt:		ibmvfc target struct
-- 
2.27.0

