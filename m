Return-Path: <SRS0=/OAa=YS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24959CA9EBD
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 16:13:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2CBA2070B
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 16:13:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504588AbfJYQNI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Oct 2019 12:13:08 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57182 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2502576AbfJYQNB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Oct 2019 12:13:01 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9PG8ugQ054098
        for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2019 12:13:00 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vv42u0t39-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2019 12:13:00 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bblock@linux.ibm.com>;
        Fri, 25 Oct 2019 17:12:58 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 25 Oct 2019 17:12:56 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9PGCsCl40894684
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 16:12:54 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C94E4C04E;
        Fri, 25 Oct 2019 16:12:54 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 47E9F4C044;
        Fri, 25 Oct 2019 16:12:54 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.152.212.148])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 25 Oct 2019 16:12:54 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.92.3)
        (envelope-from <bblock@linux.ibm.com>)
        id 1iO2Cs-00074f-0E; Fri, 25 Oct 2019 18:12:54 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Jens Remus <jremus@linux.ibm.com>,
        Fedor Loshakov <loshakov@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v2 07/11] zfcp: introduce SysFS interface to read the local B2B-Credit
Date:   Fri, 25 Oct 2019 18:12:49 +0200
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1571934247.git.bblock@linux.ibm.com>
References: <cover.1571934247.git.bblock@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19102516-0028-0000-0000-000003AF90D4
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102516-0029-0000-0000-00002471C7A9
Message-Id: <8a53aef87b53c50cfb1a3425b799bacb6f82b832.1572018132.git.bblock@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-25_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910250148
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In addition to the diagnostic data from the local SFP transceiver this
patch adds an interface to read the advertised buffer-to-buffer credit
from the local FC_Port.

With this patch the userspace-interface will only read data stored in
the corresponding "diagnostic buffer" (that was stored during completion
of a previous Exchange Config Data command). Implicit updating will
follow later in this series.

Reviewed-by: Steffen Maier <maier@linux.ibm.com>
Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_sysfs.c | 40 ++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/s390/scsi/zfcp_sysfs.c b/drivers/s390/scsi/zfcp_sysfs.c
index a2fa3db5695d..376d76b9f337 100644
--- a/drivers/s390/scsi/zfcp_sysfs.c
+++ b/drivers/s390/scsi/zfcp_sysfs.c
@@ -666,6 +666,45 @@ struct device_attribute *zfcp_sysfs_shost_attrs[] = {
 	NULL
 };
 
+static ssize_t zfcp_sysfs_adapter_diag_b2b_credit_show(
+	struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct zfcp_adapter *adapter = zfcp_ccw_adapter_by_cdev(to_ccwdev(dev));
+	struct zfcp_diag_header *diag_hdr;
+	struct fc_els_flogi *nsp;
+	ssize_t rc = -ENOLINK;
+	unsigned long flags;
+	unsigned int status;
+
+	if (!adapter)
+		return -ENODEV;
+
+	status = atomic_read(&adapter->status);
+	if (0 == (status & ZFCP_STATUS_COMMON_OPEN) ||
+	    0 == (status & ZFCP_STATUS_COMMON_UNBLOCKED) ||
+	    0 != (status & ZFCP_STATUS_COMMON_ERP_FAILED))
+		goto out;
+
+	diag_hdr = &adapter->diagnostics->config_data.header;
+
+	spin_lock_irqsave(&diag_hdr->access_lock, flags);
+	/* nport_serv_param doesn't contain the ELS_Command code */
+	nsp = (struct fc_els_flogi *)((unsigned long)
+					      adapter->diagnostics->config_data
+						      .data.nport_serv_param -
+				      sizeof(u32));
+
+	rc = scnprintf(buf, 5 + 2, "%hu\n",
+		       be16_to_cpu(nsp->fl_csp.sp_bb_cred));
+	spin_unlock_irqrestore(&diag_hdr->access_lock, flags);
+
+out:
+	zfcp_ccw_adapter_put(adapter);
+	return rc;
+}
+static ZFCP_DEV_ATTR(adapter_diag, b2b_credit, 0400,
+		     zfcp_sysfs_adapter_diag_b2b_credit_show, NULL);
+
 #define ZFCP_DEFINE_DIAG_SFP_ATTR(_name, _qtcb_member, _prtsize, _prtfmt)      \
 	static ssize_t zfcp_sysfs_adapter_diag_sfp_##_name##_show(	       \
 		struct device *dev, struct device_attribute *attr, char *buf)  \
@@ -733,6 +772,7 @@ static struct attribute *zfcp_sysfs_diag_attrs[] = {
 	&dev_attr_adapter_diag_sfp_sfp_invalid.attr,
 	&dev_attr_adapter_diag_sfp_connector_type.attr,
 	&dev_attr_adapter_diag_sfp_fec_active.attr,
+	&dev_attr_adapter_diag_b2b_credit.attr,
 	NULL,
 };
 
-- 
2.21.0

