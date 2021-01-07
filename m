Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CE47C433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 16:07:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E89F623403
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 16:06:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbhAGQGo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 11:06:44 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15326 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726319AbhAGQGo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2021 11:06:44 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 107G5PHu003354;
        Thu, 7 Jan 2021 11:05:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=rwr3p9Gi9zaZG9OZ5de6+AhAlq5C8aS9GEEax1yHiI8=;
 b=IRkISkCSTUqafEf/A8eAXRt/JAxulWGBniE2txla4mzfV8ZruI0nZaz3RDhZPZzxDX2g
 u9ng9RYGUrQgVaK7OPE/5PhxXtAl1lmw3/6Qgg6i7ib2OQppOWDNEM002Wt1pqVtKs5f
 D11hfj9Niw7Rze6XczQSF3sJfXUwhZhrtMbG+OpaexLlhHfdfMr/PU4ZiShcrEVEGVpx
 CRshAGuxswyG7h48Tp/TpdF/m99XOweQ95CzYgIdCxF7qemXCNMvw1seJKrSQmhwgHUK
 sMnFrlCllFktlMmSbLoCJcSi8pTDClvdhWdksXeaBjMY/wqoU5yU4W7z97+YgVFYKvTi +g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35x4r89k45-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jan 2021 11:05:57 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 107G5ZNs004043;
        Thu, 7 Jan 2021 11:05:35 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35x4r89jc6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jan 2021 11:05:32 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 107FVpx1023202;
        Thu, 7 Jan 2021 16:02:43 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 35tgf8jktt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jan 2021 16:02:43 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 107G2eLi38273530
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Jan 2021 16:02:40 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 08B7C4C044;
        Thu,  7 Jan 2021 16:02:40 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C72E04C046;
        Thu,  7 Jan 2021 16:02:39 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  7 Jan 2021 16:02:39 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>
Subject: [PATCH 2/3] scsi: iscsi: let transport class declare its sysfs attributes
Date:   Thu,  7 Jan 2021 17:02:30 +0100
Message-Id: <20210107160231.101243-2-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210107160231.101243-1-jwi@linux.ibm.com>
References: <20210107160231.101243-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-07_07:2021-01-07,2021-01-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 phishscore=0 malwarescore=0 spamscore=0 priorityscore=1501 bulkscore=0
 adultscore=0 lowpriorityscore=0 clxscore=1015 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101070097
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Have device_register() create the attributes for us automatically, before
the KOBJ_ADD uevent is raised.

Cc: Lee Duncan <lduncan@suse.com>
Cc: Chris Leech <cleech@redhat.com>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 29 ++++++++++-------------------
 1 file changed, 10 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index c18d01e178b2..e3d57ba7ca19 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -118,15 +118,6 @@ static void iscsi_transport_release(struct device *dev)
 	kfree(priv);
 }
 
-/*
- * iscsi_transport_class represents the iscsi_transports that are
- * registered.
- */
-static struct class iscsi_transport_class = {
-	.name = "iscsi_transport",
-	.dev_release = iscsi_transport_release,
-};
-
 static ssize_t
 show_transport_handle(struct device *dev, struct device_attribute *attr,
 		      char *buf)
@@ -154,8 +145,16 @@ static struct attribute *iscsi_transport_attrs[] = {
 	NULL,
 };
 
-static struct attribute_group iscsi_transport_group = {
-	.attrs = iscsi_transport_attrs,
+ATTRIBUTE_GROUPS(iscsi_transport);
+
+/*
+ * iscsi_transport_class represents the iscsi_transports that are
+ * registered.
+ */
+static struct class iscsi_transport_class = {
+	.name = "iscsi_transport",
+	.dev_groups = iscsi_transport_groups,
+	.dev_release = iscsi_transport_release,
 };
 
 /*
@@ -4622,10 +4621,6 @@ iscsi_register_transport(struct iscsi_transport *tt)
 	if (err)
 		goto free_priv;
 
-	err = sysfs_create_group(&priv->dev.kobj, &iscsi_transport_group);
-	if (err)
-		goto unregister_dev;
-
 	/* host parameters */
 	priv->t.host_attrs.ac.class = &iscsi_host_class.class;
 	priv->t.host_attrs.ac.match = iscsi_host_match;
@@ -4652,9 +4647,6 @@ iscsi_register_transport(struct iscsi_transport *tt)
 	printk(KERN_NOTICE "iscsi: registered transport (%s)\n", tt->name);
 	return &priv->t;
 
-unregister_dev:
-	device_unregister(&priv->dev);
-	return NULL;
 free_priv:
 	kfree(priv);
 	return NULL;
@@ -4681,7 +4673,6 @@ int iscsi_unregister_transport(struct iscsi_transport *tt)
 	transport_container_unregister(&priv->session_cont);
 	transport_container_unregister(&priv->t.host_attrs);
 
-	sysfs_remove_group(&priv->dev.kobj, &iscsi_transport_group);
 	device_unregister(&priv->dev);
 	mutex_unlock(&rx_queue_mutex);
 
-- 
2.17.1

