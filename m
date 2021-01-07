Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7803EC433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 16:04:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47FA723428
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 16:04:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728468AbhAGQE2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 11:04:28 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:65310 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726780AbhAGQE2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2021 11:04:28 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 107G2Cqd099376;
        Thu, 7 Jan 2021 11:03:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=yFFxWZ2zRBx6cdljP0LZkpQw/jzFJ1iylyRzDuu7h+I=;
 b=gPsL+5cR7iUzSytpM6c7tgrq6XjoDFwxmooVd5kyBrhD5df+QTHjHNiYRCsvhGDZKbuG
 dHJtkrcmcdddrvmxCRC9xkHx2f2nqkikCP2tXTajNs0hiE3sFs/UF2xPLUx9K9jZ9b44
 5cAE4lxRhlWOcoqJ1r8OspKqhdRiSbThZAzAoU17iaTUZgTMBaevRpcQ+yxTO35PmYlv
 Vw81UDX1wrfZxN5+L/rNq8zSVgkxJS3C3j53kW4GQ6kXSGnrxTx6afR5HsOst4a4JL/W
 jnuC712Ux6x9BTuvMn1ihMbCSjv1r8iGdAT47JJqOZA1FdROqalqWLe1Zsu7Y2dH5xTB fQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35x58w0c9w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jan 2021 11:03:39 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 107G2goK101149;
        Thu, 7 Jan 2021 11:03:14 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35x58w0bt8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jan 2021 11:03:14 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 107FXlPf018840;
        Thu, 7 Jan 2021 16:02:42 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 35tg3hd1kh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jan 2021 16:02:42 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 107G2aGK31195508
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Jan 2021 16:02:36 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BC3584C044;
        Thu,  7 Jan 2021 16:02:39 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 860834C040;
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
Subject: [PATCH 1/3] scsi: iscsi: let endpoint class declare its sysfs attributes
Date:   Thu,  7 Jan 2021 17:02:29 +0100
Message-Id: <20210107160231.101243-1-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-07_07:2021-01-07,2021-01-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 malwarescore=0
 phishscore=0 spamscore=0 clxscore=1015 bulkscore=0 lowpriorityscore=0
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
 drivers/scsi/scsi_transport_iscsi.c | 22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 2e68c0a87698..c18d01e178b2 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -174,11 +174,6 @@ static void iscsi_endpoint_release(struct device *dev)
 	kfree(ep);
 }
 
-static struct class iscsi_endpoint_class = {
-	.name = "iscsi_endpoint",
-	.dev_release = iscsi_endpoint_release,
-};
-
 static ssize_t
 show_ep_handle(struct device *dev, struct device_attribute *attr, char *buf)
 {
@@ -192,8 +187,12 @@ static struct attribute *iscsi_endpoint_attrs[] = {
 	NULL,
 };
 
-static struct attribute_group iscsi_endpoint_group = {
-	.attrs = iscsi_endpoint_attrs,
+ATTRIBUTE_GROUPS(iscsi_endpoint);
+
+static struct class iscsi_endpoint_class = {
+	.name = "iscsi_endpoint",
+	.dev_groups = iscsi_endpoint_groups,
+	.dev_release = iscsi_endpoint_release,
 };
 
 #define ISCSI_MAX_EPID -1
@@ -239,18 +238,10 @@ iscsi_create_endpoint(int dd_size)
         if (err)
                 goto free_ep;
 
-	err = sysfs_create_group(&ep->dev.kobj, &iscsi_endpoint_group);
-	if (err)
-		goto unregister_dev;
-
 	if (dd_size)
 		ep->dd_data = &ep[1];
 	return ep;
 
-unregister_dev:
-	device_unregister(&ep->dev);
-	return NULL;
-
 free_ep:
 	kfree(ep);
 	return NULL;
@@ -259,7 +250,6 @@ EXPORT_SYMBOL_GPL(iscsi_create_endpoint);
 
 void iscsi_destroy_endpoint(struct iscsi_endpoint *ep)
 {
-	sysfs_remove_group(&ep->dev.kobj, &iscsi_endpoint_group);
 	device_unregister(&ep->dev);
 }
 EXPORT_SYMBOL_GPL(iscsi_destroy_endpoint);
-- 
2.17.1

