Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9EF9C49EA5
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Jun 2021 03:36:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B2E161408
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Jun 2021 03:36:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233023AbhFYDii (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Jun 2021 23:38:38 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:24808 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232917AbhFYDii (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Jun 2021 23:38:38 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15P3XUJ1093825
        for <linux-scsi@vger.kernel.org>; Thu, 24 Jun 2021 23:36:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=PAiQ9DOwEvzOctZzFK/vKd2mPf1P98CwzdiESolvSZ0=;
 b=YfC+Z8Qv/nPOOJ2DEb1XyWHrYZT/7aoIm+iuR4HH4zVdY+60BcPkiOFODS/DMQ81DVDs
 vVfkzuqauxJwa69b0C9UIoAFzfMpyGeJvadtIiN7G01r4Lh6Fsv+iXfXVWWHF7FersGg
 C83cuKJbSiUJqey/Duap/6eAhqFh98f1Ywq8P03If6nfD/u6jpIsfKmZ4Tg6HGUpJ2U2
 7yMO8z7aVUUskTbHxq2f39yr6SHvdRk0T2k8odVfWGsg13pp5asIG3MNSVcVB/EDkslv
 FREEUc6AvCl3pgBEIRQGQHc09kewh2umZ7MV2vMMO5u2IVd4lf2MbMkowhcy13RFLJwv fA== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39d5hujech-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 24 Jun 2021 23:36:17 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15P3Qvjn023448
        for <linux-scsi@vger.kernel.org>; Fri, 25 Jun 2021 03:36:16 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma04dal.us.ibm.com with ESMTP id 39cn61hhcy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 25 Jun 2021 03:36:16 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15P3aEJ929688146
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Jun 2021 03:36:14 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 932ABBE053;
        Fri, 25 Jun 2021 03:36:14 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 26659BE051;
        Fri, 25 Jun 2021 03:36:14 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.40.195.89])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 25 Jun 2021 03:36:13 +0000 (GMT)
From:   wenxiong@linux.vnet.ibm.com
To:     jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, brking1@linux.vnet.ibm.com,
        wenxiong@us.ibm.com, Wen Xiong <wenxiong@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ipr: system crashes when seeing type 20 error
Date:   Thu, 24 Jun 2021 21:11:25 -0500
Message-Id: <1624587085-10073-1-git-send-email-wenxiong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.0.2
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _qptY-adMB1kiu-ZcNTgrZhgDjBEV2yA
X-Proofpoint-GUID: _qptY-adMB1kiu-ZcNTgrZhgDjBEV2yA
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-25_01:2021-06-24,2021-06-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 suspectscore=0 mlxscore=0 malwarescore=0 impostorscore=0
 priorityscore=1501 adultscore=0 clxscore=1011 mlxlogscore=999 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106250018
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Wen Xiong <wenxiong@linux.vnet.ibm.com>

Test team saw "4041: Incomplete multipath connection between enclosure
and device" when IO drawers/drives have bad connections. System crashes
when handling this type 20 errors.

[    5.332452] ipr: 3/00-06-09: 4041: Incomplete multipath connection between enclosure and device
[    5.332460] ipr: 3/00-06-09: The IOA failed to detect an expected path to a device
[    5.332465] ipr: 3/00-06-09: Inactive path is failed: Resource Path=3/00-04-09
[    5.332471] ipr: 3/00-06-09: Functional IOA port: Resource Path=3/00-04, Link rate=unknown, WWN=5005076059C38E05
[    5.332478] ipr: 3/00-06-09: Incorrectly connected Device LUN: Resource Path=3/00-00-00-00-00-00-00-00-00-20-00-00-24-00-00-00-0, Link rate=unknown, WWN=0020000024000000
[    5.332487] ipr: 3/00-06-09: Path element=FF: Resource Path=3/50-05-07-60-45-56-5A-9C-00-00-00-00-00-00-00-00-0, Link rate=unknown WWN=0000000000000000
[    5.332492] ipr: 00000000: 54520EC8 00000000 00000000 4E532050
[    5.332495] ipr: 00000010: 45522054 49434B3D 00000050 278130E6
[    5.332498] ipr: 00000020: 033B5300 03282584 4C4D00E0 278039F3
[    5.332501] ipr: 00000030: 033B5180 03282404 4C4D00E0 276A0282
[    5.332504] ipr: 00000040: 033B5000 03281E04 447000E0 27697D19
[    5.332507] ipr: 00000050: 033B4E80 03281D84 447000E0 27690524
[    5.332509] ipr: 00000060: 033B4D00 03281C84 447000E0 27687FDA
[    5.332512] ipr: 00000070: 033B4B80 03281C04 447000E0 2767E787
[    5.332515] ipr: 00000080: 033B4A00 03281B04 447000E0 27674F0A

Signed-off-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>

---
 drivers/scsi/ipr.c | 4 ++--
 drivers/scsi/ipr.h | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 30c30a1db5b1..5d78f7e939a3 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -1300,7 +1300,7 @@ static char *__ipr_format_res_path(u8 *res_path, char *buffer, int len)
 
 	*p = '\0';
 	p += scnprintf(p, buffer + len - p, "%02X", res_path[0]);
-	for (i = 1; res_path[i] != 0xff && ((i * 3) < len); i++)
+	for (i = 1; res_path[i] != 0xff && i < IPR_RES_PATH_BYTES; i++)
 		p += scnprintf(p, buffer + len - p, "-%02X", res_path[i]);
 
 	return buffer;
@@ -1323,7 +1323,7 @@ static char *ipr_format_res_path(struct ipr_ioa_cfg *ioa_cfg,
 
 	*p = '\0';
 	p += scnprintf(p, buffer + len - p, "%d/", ioa_cfg->host->host_no);
-	__ipr_format_res_path(res_path, p, len - (buffer - p));
+	__ipr_format_res_path(res_path, p, len - (p - buffer));
 	return buffer;
 }
 
diff --git a/drivers/scsi/ipr.h b/drivers/scsi/ipr.h
index 783ee03ad9ea..69444d21fca1 100644
--- a/drivers/scsi/ipr.h
+++ b/drivers/scsi/ipr.h
@@ -428,6 +428,7 @@ struct ipr_config_table_entry64 {
 	__be64 lun;
 	__be64 lun_wwn[2];
 #define IPR_MAX_RES_PATH_LENGTH		48
+#define IPR_RES_PATH_BYTES		8
 	__be64 res_path;
 	struct ipr_std_inq_data std_inq_data;
 	u8 reserved2[4];
-- 
2.27.0

