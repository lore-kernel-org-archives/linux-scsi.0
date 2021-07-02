Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E14BC11F69
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Jul 2021 16:09:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40AD96140C
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Jul 2021 16:09:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbhGBQMT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Jul 2021 12:12:19 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:13804 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229455AbhGBQMT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jul 2021 12:12:19 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 162G35aq110585;
        Fri, 2 Jul 2021 12:09:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=HAiqlY+tPDpmV3CsWOuGwaS6YOetITX/IXrdESmZaxQ=;
 b=V3k7sbtyM0gOWIcRm3yP7t8+r0BXrSfrr5p3zv6kz0QwiILl0kykqkHdGDIayihJ4S0V
 4cjY7LdFCP0mJWOXr0sIa9NuDqQUSsMKWQcWH7kpTJ0hg1Cfks680e47Tx03msJW6rDh
 IbsVVUxwZR5iyz3Aq58GXWsgQ0ikjK7JYG8un/ktCkV6rIOzsZIHagkfVDtPkJc11uFO
 paY+zmUAzhmktjaR9GV5xGrNXXj96wMTg6stqBXkuCD8Oi5jRvR4mb9TZYKdap1skAao
 33KnH4XLZcKR/Xz9zC2MuvEg7H++EqFpT6Tb55kZjOLi4228TxMnqtiIReVGxxq7OGIL ew== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39j5yvg46s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Jul 2021 12:09:45 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 162FeB9P005525;
        Fri, 2 Jul 2021 16:09:43 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 39ft8es0jp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Jul 2021 16:09:43 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 162G9bhd30081410
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Jul 2021 16:09:37 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D49E152050;
        Fri,  2 Jul 2021 16:09:37 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 8C6345204F;
        Fri,  2 Jul 2021 16:09:37 +0000 (GMT)
From:   Steffen Maier <maier@linux.ibm.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Benjamin Block <bblock@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>
Subject: [PATCH] zfcp: report port fc_security as unknown early during remote cable pull
Date:   Fri,  2 Jul 2021 18:09:22 +0200
Message-Id: <20210702160922.2667874-1-maier@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: tGK4XpK653FCDN84mAgwGaw8Se5lKLG_
X-Proofpoint-ORIG-GUID: tGK4XpK653FCDN84mAgwGaw8Se5lKLG_
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-02_08:2021-07-02,2021-07-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 suspectscore=0 phishscore=0 mlxlogscore=999
 clxscore=1011 impostorscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107020086
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On remote cable pull, a zfcp_port keeps its status and only gets
ZFCP_STATUS_PORT_LINK_TEST added. Only after an ADISC timeout,
we would actually start port recovery and remove
ZFCP_STATUS_COMMON_UNBLOCKED which zfcp_sysfs_port_fc_security_show()
detected and reported as "unknown" instead of the old and possibly stale
zfcp_port->connection_info.

Add check for ZFCP_STATUS_PORT_LINK_TEST for timely "unknown" report.

Signed-off-by: Steffen Maier <maier@linux.ibm.com>
Fixes: a17c78460093 ("scsi: zfcp: report FC Endpoint Security in sysfs")
Cc: <stable@vger.kernel.org> #5.7+
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
---

Martin, James, we have a small zfcp bugfix.
Would be nice if it could still make it into v5.14-rc1 merge window,
but I'm probably too late for that. v5.14-rc2 is fine, too.
Applies to 5.14/scsi-staging or 5.14/scsi-queue or James' misc branch,
or to the corresponding fixes branch(es).

 drivers/s390/scsi/zfcp_sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/s390/scsi/zfcp_sysfs.c b/drivers/s390/scsi/zfcp_sysfs.c
index 544efd4c42f0..b8cd75a872ee 100644
--- a/drivers/s390/scsi/zfcp_sysfs.c
+++ b/drivers/s390/scsi/zfcp_sysfs.c
@@ -487,6 +487,7 @@ static ssize_t zfcp_sysfs_port_fc_security_show(struct device *dev,
 	if (0 == (status & ZFCP_STATUS_COMMON_OPEN) ||
 	    0 == (status & ZFCP_STATUS_COMMON_UNBLOCKED) ||
 	    0 == (status & ZFCP_STATUS_PORT_PHYS_OPEN) ||
+	    0 != (status & ZFCP_STATUS_PORT_LINK_TEST) ||
 	    0 != (status & ZFCP_STATUS_COMMON_ERP_FAILED) ||
 	    0 != (status & ZFCP_STATUS_COMMON_ACCESS_BOXED))
 		i = sprintf(buf, "unknown\n");
-- 
2.25.4

