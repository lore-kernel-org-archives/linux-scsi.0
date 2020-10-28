Return-Path: <SRS0=Vgdy=EE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A53AFC5517A
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 02:11:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E51A20878
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 02:11:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gG4xvIUz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733240AbgJ2CLn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Oct 2020 22:11:43 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:29846 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726837AbgJ1Vgt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Oct 2020 17:36:49 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09SI1qTW083972;
        Wed, 28 Oct 2020 14:31:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : sender; s=pp1;
 bh=jhecTrmBW5iHnrqL0zl9efrXazNDBnk4jtaYZtXWTAU=;
 b=gG4xvIUzIcby/zIvb8dMDHECOADou3Icex7bWZBHfQRCOVjYkgPNWl/Kal1aiskH9q+/
 RcyXbl+82TYNZRS79v9RgOhu4AV59eA6tois3/8bseYUlwAdScYiiCwMDGgSoqWxD05b
 ipSl6R4CMV8HDAhbXySMfiGsA8K1iPjlYBy778iy8gBzse8+ZbHSLWFyKP+PPqXPdnM2
 5mIuHq+N5RkSVZ3mHknNELNF32mySY2wta6JQFjHV5mPvFzgS2MiJCCj67L5nx2xCj0I
 QR4peN8Qfcn+2HAXroThPs64x2LKsEf0oTQHW33dO1qgCVcW36FXM2dyfQBkV6GxLwoV KA== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34f96uc1e7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Oct 2020 14:31:01 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09SITFSb031946;
        Wed, 28 Oct 2020 18:30:57 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 34f8cr89s4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Oct 2020 18:30:57 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09SIUsHk29557092
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Oct 2020 18:30:54 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E0EB11C070;
        Wed, 28 Oct 2020 18:30:54 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 245C011C04C;
        Wed, 28 Oct 2020 18:30:54 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.72.181])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 28 Oct 2020 18:30:54 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.94)
        (envelope-from <bblock@linux.ibm.com>)
        id 1kXqDl-002ps0-4l; Wed, 28 Oct 2020 19:30:53 +0100
From:   Benjamin Block <bblock@linux.ibm.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Julian Wiedmann <jwi@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Fedor Loshakov <loshakov@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH 3/5] zfcp: clarify & assert the stat_lock locking in zfcp_qdio_send()
Date:   Wed, 28 Oct 2020 19:30:50 +0100
Message-Id: <b023b1472630f4bf9fce580577d7bb49de89ccbf.1603908167.git.bblock@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1603908167.git.bblock@linux.ibm.com>
References: <cover.1603908167.git.bblock@linux.ibm.com>
MIME-Version: 1.0
Organization: IBM Deutschland Research & Development GmbH, Vorsitz. AufsR. Gregor Pillen, Geschaeftsfuehrung Dirk Wittkopp, Sitz der Gesellschaft Boeblingen, Registergericht AmtsG Stuttgart, HRB 243294
Content-Transfer-Encoding: 8bit
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-28_08:2020-10-28,2020-10-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 priorityscore=1501 suspectscore=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 impostorscore=0 adultscore=0 mlxlogscore=999
 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010280116
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

Explain why the plain spin_lock() suffices in current code, even when
the stat_lock is also used by zfcp_qdio_int_req() in tasklet context.

We could also promote the spin_lock() to a spin_lock_irqsave(), but that
would just obfuscate the locking even further.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Reviewed-by: Steffen Maier <maier@linux.ibm.com>
Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_qdio.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/s390/scsi/zfcp_qdio.c b/drivers/s390/scsi/zfcp_qdio.c
index 9fc045ddf66d..23ab16d65f2a 100644
--- a/drivers/s390/scsi/zfcp_qdio.c
+++ b/drivers/s390/scsi/zfcp_qdio.c
@@ -10,6 +10,7 @@
 #define KMSG_COMPONENT "zfcp"
 #define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
 
+#include <linux/lockdep.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 #include "zfcp_ext.h"
@@ -283,6 +284,13 @@ int zfcp_qdio_send(struct zfcp_qdio *qdio, struct zfcp_qdio_req *q_req)
 	int retval;
 	u8 sbal_number = q_req->sbal_number;
 
+	/*
+	 * This should actually be a spin_lock_bh(stat_lock), to protect against
+	 * zfcp_qdio_int_req() in tasklet context.
+	 * But we can't do so (and are safe), as we always get called with IRQs
+	 * disabled by spin_lock_irq[save](req_q_lock).
+	 */
+	lockdep_assert_irqs_disabled();
 	spin_lock(&qdio->stat_lock);
 	zfcp_qdio_account(qdio);
 	spin_unlock(&qdio->stat_lock);
-- 
2.26.2

