Return-Path: <SRS0=a792=EB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35056C2D0A3
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 09:07:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E560D22400
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 09:07:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mK3tMcsZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1772585AbgJZJHS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Oct 2020 05:07:18 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1304 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391099AbgJZJHS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Oct 2020 05:07:18 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09Q93IOk096895;
        Mon, 26 Oct 2020 05:07:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=LZu6nfQ0g9v5m/93Hb7gW5a8qdfim4JniShGr/vv/A0=;
 b=mK3tMcsZY5pqcMM3A1Tejke3XkkWv8CsF1GM6d/66zuqX1qHT8Hksx8imPbvpYQcbBDx
 u7+kOukgOI9HRV/idefY+3VayFzccCDz+0XkWCiknwkvTTsKaAGCp2D4zYHKvmH3hgby
 J/8a4XSMKqb2jESXxxBxpqSlhfAzT00rQdunJ9X2V8SnYhvPj0d9R10xyewhigHaKhtg
 mY5dyfmtlh93z4i5gEXhd7gQhBvkLqunJrvaUZBYgwynxHBqsFvQeVt15Dbk6flcpovO
 KmZpDbBqMCZdUnh3OPZxUmxZ9Za68R0lzvLZ3VwY4amwInxGBX1/f7vOHhtwZd8Gp9lF IQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34drctn1ca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Oct 2020 05:07:15 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09Q93klL099338;
        Mon, 26 Oct 2020 05:07:15 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34drctn1bj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Oct 2020 05:07:14 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09Q9308F022984;
        Mon, 26 Oct 2020 09:07:12 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 34cbw8911j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Oct 2020 09:07:12 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09Q979ke31392112
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 09:07:09 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A1D155204F;
        Mon, 26 Oct 2020 09:07:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 6890C5204E;
        Mon, 26 Oct 2020 09:07:09 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH] scsi: docs: SG_ALL no longer opts out from chained sgl
Date:   Mon, 26 Oct 2020 10:07:01 +0100
Message-Id: <20201026090701.36065-1-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-26_06:2020-10-26,2020-10-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 clxscore=1011 suspectscore=0 adultscore=0 mlxlogscore=999
 priorityscore=1501 spamscore=0 lowpriorityscore=0 impostorscore=0
 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260066
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

commit 3dccdf53c2f3 ("scsi: core: avoid preallocating big SGL for data")
has changed the sgl allocation logic. A scsi_cmnd may now contain
chained SG lists, even when sg_tablesize is set to <= SG_ALL by the LLD.

Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 Documentation/scsi/scsi_mid_low_api.rst | 1 -
 1 file changed, 1 deletion(-)

diff --git a/Documentation/scsi/scsi_mid_low_api.rst b/Documentation/scsi/scsi_mid_low_api.rst
index 5bc17d012b25..6b2bad6dc899 100644
--- a/Documentation/scsi/scsi_mid_low_api.rst
+++ b/Documentation/scsi/scsi_mid_low_api.rst
@@ -1081,7 +1081,6 @@ of interest:
 		 - scsi id of host (scsi initiator) or -1 if not known
     sg_tablesize
 		 - maximum scatter gather elements allowed by host.
-                   Set this to SG_ALL or less to avoid chained SG lists.
                    Must be at least 1.
     max_sectors
 		 - maximum number of sectors (usually 512 bytes) allowed
-- 
2.17.1

