Return-Path: <SRS0=SSlb=ED=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02560C4363A
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Oct 2020 21:33:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A55EA24857
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Oct 2020 21:33:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="EO+s6I9G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbgJ1VdN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Oct 2020 17:33:13 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:8398 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725880AbgJ1VdJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Oct 2020 17:33:09 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09SI2FCV142882;
        Wed, 28 Oct 2020 14:30:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : sender; s=pp1;
 bh=nUrjxTynwetPdicobT6uk9qEocRsUFwi1Wf2q6mGDHM=;
 b=EO+s6I9G9fAVX9GaR423oSPEawfm416RrAb5Cy9k99j1YGFwFexSeFTfTB69qZ7KYeL4
 h/6L9iuzlChhUhvSXe2z/8NnLNvoy+srZtnDfdnd4vfLngiFqZeLoL9xQhOp6VpKw2bG
 tiCBfzz4DMalwdKx2/BD4CsDvq70qd/w7vMVPlqrjGvLXwYF0pXQEzId/2fHCDMl+a8N
 TQhAQw6fs/T/krWBJmAmmfJRO+uHU2oKfwQyxV80B7wHTvGcgLX1wz4aaf9c3wV56aU9
 Znj5xY+F0qMKAGcMDK+W2Nq9Rk90efhp62DG1Kjuk4kQQb+F9ZI0A3jGHanKVFB7G0lo Kg== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34fa6p985j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Oct 2020 14:30:59 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09SISor3025451;
        Wed, 28 Oct 2020 18:30:56 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 34cbw8af4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Oct 2020 18:30:56 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09SIUsuP9240910
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Oct 2020 18:30:54 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E01DC42049;
        Wed, 28 Oct 2020 18:30:53 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D6D9F42047;
        Wed, 28 Oct 2020 18:30:53 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.72.181])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 28 Oct 2020 18:30:53 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.94)
        (envelope-from <bblock@linux.ibm.com>)
        id 1kXqDk-002prx-S0; Wed, 28 Oct 2020 19:30:52 +0100
From:   Benjamin Block <bblock@linux.ibm.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Vasily Gorbik <gor@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Fedor Loshakov <loshakov@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH 2/5] zfcp: remove orphaned function declarations
Date:   Wed, 28 Oct 2020 19:30:49 +0100
Message-Id: <6854ae03c5c65805f746774eeb0f2869fcd6c397.1603908167.git.bblock@linux.ibm.com>
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
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 malwarescore=0 suspectscore=2 lowpriorityscore=0 mlxlogscore=999
 clxscore=1015 phishscore=0 adultscore=0 spamscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010280116
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

drivers/s390/scsi/zfcp_ext.h: zfcp_sg_free_table - only declaration left
after commit 58f3ead54752 ("scsi: zfcp: move SG table helper from aux
to fc and make them static")

drivers/s390/scsi/zfcp_ext.h: zfcp_sg_setup_table - only declaration
left after commit 58f3ead54752 ("scsi: zfcp: move SG table helper from
aux to fc and make them static")

Reviewed-by: Steffen Maier <maier@linux.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_ext.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
index 3ef5d74331c3..8b50f580584c 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -20,8 +20,6 @@ extern struct zfcp_port *zfcp_get_port_by_wwpn(struct zfcp_adapter *, u64);
 extern struct zfcp_adapter *zfcp_adapter_enqueue(struct ccw_device *);
 extern struct zfcp_port *zfcp_port_enqueue(struct zfcp_adapter *, u64, u32,
 					   u32);
-extern void zfcp_sg_free_table(struct scatterlist *, int);
-extern int zfcp_sg_setup_table(struct scatterlist *, int);
 extern void zfcp_adapter_release(struct kref *);
 extern void zfcp_adapter_unregister(struct zfcp_adapter *);
 
-- 
2.26.2

