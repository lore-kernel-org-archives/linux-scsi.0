Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CEFCC433DB
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 16:04:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3219F23118
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 16:04:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728205AbhAGQE0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 11:04:26 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35204 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726780AbhAGQE0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2021 11:04:26 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 107G2CQT099371;
        Thu, 7 Jan 2021 11:03:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=bRszvytTtodPF9wRkj+mNSdoQGns39vakbpD3IFIyVo=;
 b=ggzhjZpBqc7JZYIKRqhw4aD9wOECvz5iom+LeviFEF15tTiCa2R2uMbId9c74dE8oGlU
 u8r3yx7RTecQEJymSIWE+Ta9dw8QFEjnp9JukDyg/a4oVjvjJpRMUuLLxrMNCJLhNBs7
 9ZOLnINxqK92tqoKVH8fLb/3ffRmCtdE0CDHg1lABfZt9HCK5+OjXHVAcPoVwAnDKxu1
 PtMoH9nw2ZIy4PkG4wke2esmSgTOObPK6+rkTuoShWVze83RIUmCIDkpTntSsXJsjbEr
 WkauKI3f9x9apVL4Cheeccr1A7FporZKvwTzhRxVrSAjFjJSoPHO5drN5WD5ctdzUdKM 2w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35x58w0c95-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jan 2021 11:03:39 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 107G2goH101149;
        Thu, 7 Jan 2021 11:03:13 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35x58w0btg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jan 2021 11:03:08 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 107FXe27022042;
        Thu, 7 Jan 2021 16:02:43 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 35wd379581-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jan 2021 16:02:43 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 107G2e6x41288080
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Jan 2021 16:02:40 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4901A4C052;
        Thu,  7 Jan 2021 16:02:40 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 13C034C050;
        Thu,  7 Jan 2021 16:02:40 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  7 Jan 2021 16:02:40 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>
Subject: [PATCH 3/3] scsi: iscsi: let iface class declare its sysfs attributes
Date:   Thu,  7 Jan 2021 17:02:31 +0100
Message-Id: <20210107160231.101243-3-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210107160231.101243-1-jwi@linux.ibm.com>
References: <20210107160231.101243-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-07_07:2021-01-07,2021-01-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 malwarescore=0
 phishscore=0 spamscore=0 clxscore=1011 bulkscore=0 lowpriorityscore=0
 mlxlogscore=999 adultscore=0 priorityscore=1501 mlxscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101070097
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Have device_register() create the attributes for us automatically, before
the KOBJ_ADD uevent is raised.

Cc: Lee Duncan <lduncan@suse.com>
Cc: Chris Leech <cleech@redhat.com>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index e3d57ba7ca19..d467ae3e46ee 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -286,12 +286,6 @@ static void iscsi_iface_release(struct device *dev)
 	put_device(parent);
 }
 
-
-static struct class iscsi_iface_class = {
-	.name = "iscsi_iface",
-	.dev_release = iscsi_iface_release,
-};
-
 #define ISCSI_IFACE_ATTR(_prefix, _name, _mode, _show, _store)	\
 struct device_attribute dev_attr_##_prefix##_##_name =		\
 	__ATTR(_name, _mode, _show, _store)
@@ -689,6 +683,14 @@ static struct attribute_group iscsi_iface_group = {
 	.is_visible = iscsi_iface_attr_is_visible,
 };
 
+__ATTRIBUTE_GROUPS(iscsi_iface);
+
+static struct class iscsi_iface_class = {
+	.name = "iscsi_iface",
+	.dev_groups = iscsi_iface_groups,
+	.dev_release = iscsi_iface_release,
+};
+
 /* convert iscsi_ipaddress_state values to ascii string name */
 static const struct {
 	enum iscsi_ipaddress_state	value;
@@ -773,18 +775,10 @@ iscsi_create_iface(struct Scsi_Host *shost, struct iscsi_transport *transport,
 	if (err)
 		goto free_iface;
 
-	err = sysfs_create_group(&iface->dev.kobj, &iscsi_iface_group);
-	if (err)
-		goto unreg_iface;
-
 	if (dd_size)
 		iface->dd_data = &iface[1];
 	return iface;
 
-unreg_iface:
-	device_unregister(&iface->dev);
-	return NULL;
-
 free_iface:
 	put_device(iface->dev.parent);
 	kfree(iface);
@@ -794,7 +788,6 @@ EXPORT_SYMBOL_GPL(iscsi_create_iface);
 
 void iscsi_destroy_iface(struct iscsi_iface *iface)
 {
-	sysfs_remove_group(&iface->dev.kobj, &iscsi_iface_group);
 	device_unregister(&iface->dev);
 }
 EXPORT_SYMBOL_GPL(iscsi_destroy_iface);
-- 
2.17.1

