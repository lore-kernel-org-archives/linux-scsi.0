Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 537C4C00140
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Aug 2022 00:04:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244607AbiHIAE4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Aug 2022 20:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244418AbiHIAEu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2022 20:04:50 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F30118392;
        Mon,  8 Aug 2022 17:04:48 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 278Nx9td021117;
        Tue, 9 Aug 2022 00:04:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=EzKN0QkmsyrCy+l8FGtj5LaKr6RxSDLLW+QwC+eh81k=;
 b=dTwTprHBQSIW3jcXXgWpSheJtTCt2jgJcO3m062aQzFB32iOjwoPtr/cZbdeOZLyghka
 qjgO0cs7Qq29GyEh1V5Hykp6sF+wTsYmq1yzhjgo4QbvJAIKk0yI9BKfehEJvuEd1HuI
 9qfAmGxCEXJ4N65wrSwdNYt3j+TtGJBI03KlexmzSWMQvufA3GiNmcg9LYTMW0SQz2bl
 giT1p3YKhhql/BpMHU1Bi9XHjZNMsnShDAk/E7TELg6JWtFhtfSkKV3M9+o9uEQL+OFR
 u2HcupzxscJxyUZTEIlVH46iqVnr2iYz1gd/h9bHe9y/xj35+kyskbuCY1nKKl+Y0/bW 8Q== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hsgut539v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Aug 2022 00:04:28 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 278M0hMe032819;
        Tue, 9 Aug 2022 00:04:27 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hser2cbp5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Aug 2022 00:04:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=guuhfBDFYvBkmp/CFh+Hktitrl4JCrPNyWIa7V1G1ldirS9G8+zNh9NZzZp08Lt/5TjUCV/vUWOGEq+DAHFZEQf0GOVXlguPM6niaLgB+NaZ7S53fCj/MdIQhHbIw8oVqIeULN52XcsmW76KN/gZm8YfYXe+idQ5zehf3HZItSd7pHYGXGsRmaI4eVJEmOCnAg9WEeZ/JqqU8OLSqEW0Lpj7E8STvtbk6+xuSa/b/OF3vDOrOQXzraE/Df8hmmO2nUbBeYLgKvLo6SeIHG71s5Mx5YYPQB2FcBNgshQU8UTIY6PqYik/b4119WoXpyYNwj1zLaOhIJuWKXxWXX4gAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EzKN0QkmsyrCy+l8FGtj5LaKr6RxSDLLW+QwC+eh81k=;
 b=k1EQyR4AEOn0w520yUCzhL5TymAcEbkvz6DB+rxdaCQ6ciWa1PTT1MtTPm3PgUbdrOopiFcdAp1VJYL91GIkmwmxr+ivff71aCI2i1geikOrLHYJ8vMfWq5Tlk2dBcORJyPCwTfF3y0PyRcadLCm7KEszT7xUON2q3ajxsxqK5l3vpy9uEpMb7IIwnmh9bErI6wp2oVeYWWTmlqdmKHeC0qaBpQamwykcwgKG/UiMOopwOW6sTd4yazJq5E8i7L15QFKbPV2NjTlQ9eSSAsUK7XfQV03sDEykGm2oK5Ev9f0JWmUef/GQV3KV/UzZ+Sp8migR4Vu+x5tkAvW/jDhMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EzKN0QkmsyrCy+l8FGtj5LaKr6RxSDLLW+QwC+eh81k=;
 b=CDNIuHJQNTEvXUIc4Amn4WlObXNEZ6lnoP/QiUlL76VB16pSkcSipK/akbSCSONxL1AKgEMG+ZQZTMNGB1/mES3XCmjtuBmum7n83xiq5oqO2TtBvZUdFakLYRVF5/qzikbN5yBMjNO4nmzS1xWDhGEmidioH4Bz9nlZRKO8qUY=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN6PR10MB2590.namprd10.prod.outlook.com (2603:10b6:805:45::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Tue, 9 Aug 2022 00:04:26 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 00:04:26 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        hch@lst.de, linux-nvme@lists.infradead.org,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 03/20] scsi: Move sd_pr_type to header to share.
Date:   Mon,  8 Aug 2022 19:04:02 -0500
Message-Id: <20220809000419.10674-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220809000419.10674-1-michael.christie@oracle.com>
References: <20220809000419.10674-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR05CA0038.namprd05.prod.outlook.com
 (2603:10b6:610:38::15) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0556ffe8-5a5b-47aa-a561-08da799ab8d2
X-MS-TrafficTypeDiagnostic: SN6PR10MB2590:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SixcG/Srx8yJk6wsq4ukG1fGTSj2JWOHxpSITkLbt9iJbSB7qkc6YpruJxF42DaeAMke52u04FaAAewLD3zA+TWXiV2WcmYghcU551pmX1gCb73qgMyC9nndcSt51/cg6Kyycx9XjTVsWfCW4Ct3N7S6YmC+X0Onfk0hao6HEsTS6qAR2eU9cUwg3YR644mHRpAWvOtgYoT/nPDz6qNZPzNrSIvktUV8/l/4E/E5Su56ivVHgV7xlRk++h+AQopJ1sl7tWxsh0hOvUzlF/jkHPNRJt5ITNaYra9p8QZPcnX3ok2XKSxsc4X4E5bKdrBGYUdTQ6zfUprxVSqqiDztnGRWbJtJHP9IgV7nx1DoyFUnvSKQas64O9gSWznCpDeVgUSZmjxyKKYX2ETnCbJ+DDc9LRoqiIYIVv8fyP3vBQcmspyXBBDpSn7VChFL1Ej7hH59SAjnfun2ir0KM274mWSZo7Oj+ArSRiB+tV8DisPjMFREUgqTaV9+pURCyZadQ/K7zxEoPFAhsN8o6+lb6gt9Ol0Q8mDXNf9Jeo74ZQvT7a+U+nSj5uyPz7ec9D7REGrt+S8b93znXBB5/nFVpTbwOXHn8+iuYC5nRr5oBS37D75up4FTuFu9i7TPIundtAcKpdXe4PZLhVDPTF2dVdzQRL9STnOhPI6JwzYtRD+scuer0O2PEPR1VaiLgqZ1gvcuck9cq6fjCGP52ht5J0RvmYPaoS5bo+OewwKCJg40UMATfEV3OAfCUVXhmOvcTV26oQ1OlBM4kKuEZSM4U13SKK8hpXgWGsdTXkl48zg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(396003)(39860400002)(366004)(136003)(376002)(2906002)(83380400001)(6512007)(26005)(6506007)(186003)(1076003)(2616005)(36756003)(107886003)(38100700002)(86362001)(921005)(66476007)(6486002)(316002)(4326008)(6666004)(8936002)(66556008)(66946007)(8676002)(478600001)(5660300002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CGUWVvHfpxA1StwZPKVv9q03fZOKNbyvnHlyxS0X0ng0lrPk3flvvetLQ5fd?=
 =?us-ascii?Q?zvurLc4x84q1j/mKi53MUxV+hsR3JS0vNc52Iji5OjUnaSSkWWBdmUSj/H2J?=
 =?us-ascii?Q?8rMtDuX/tOzvRp+gNO28VKw1eaReUpfyqP8F1FykPQeKhzkVpfP0g/HtuIxP?=
 =?us-ascii?Q?jUTZmYEP5zD1x511lEskhSyo4uxYbASTzKjyEeiDEnGcHgNH2Q8ippnqV4iW?=
 =?us-ascii?Q?p2wuvHdpMgBIYg0uHSmc7+ZCfjmWvOXC9JVhJoeF36qgCi0PgDBfigr0EjYO?=
 =?us-ascii?Q?wo5VwfHZitcaxkssFwPoQzJXryIIG0lubSHQ6FXF5j2Yogd7dnwJ59LIIBHs?=
 =?us-ascii?Q?gepHt8GBmrqKyqlyIDj4t9yJoc8+5wcvhrV3cQkrxBKsDzHSRuzolgnShwTb?=
 =?us-ascii?Q?gPNAeSZAdJg1aorMO9rfprKUOybNjwWq9usayBaPRYtzLfMeFAjuuWPRJJAG?=
 =?us-ascii?Q?X9CgOqQrdiPx4dbiz7wrabccmBP0WABDJImtAaptxy89nADWqYDIO4+h8fK8?=
 =?us-ascii?Q?o30sLKs00BgnpSNUc01LOQhdni2uX1Z/AaMBpX7iBi+L8iJ42tJtfaqMn9q5?=
 =?us-ascii?Q?JULhh/tdIqMOtM1Jf6viJHevXtBjWh5dqXDybfeiJp7do5SObAuOrTWbM9Pc?=
 =?us-ascii?Q?eVnb8tOecfGqJYJnl5t92QGa1m5viRGC/9MOXJwMqXyZJSbXNcu8xU3rFAc4?=
 =?us-ascii?Q?VJP7YYUEZfblEgINa8F8rQTt5JDvgVGZbgULUykcG48wmOCWvEgfM2AHPF7W?=
 =?us-ascii?Q?d1Q5uQLZJ8XfSn9FIvBY+IotGCUNjdrT0f0qJGoU3x5dZE0gxIP7bHHBw3VJ?=
 =?us-ascii?Q?KQfcnbR0Y4KLc2WfX2lFvXgT+PcO2LsJhltTgmKbznb1j3aHC+ni2axcS/TJ?=
 =?us-ascii?Q?QH5B3pp9Kfzk77cLaGFZ+SeMpX4LrjTECqUqCdih6rrBNEF4rwlRwAuzWb1I?=
 =?us-ascii?Q?jHUyWzIlw6i6xmyfK9jThNrC5W85Zx4fEsFlx2Z64GeHTGEugmeIgAJi47nv?=
 =?us-ascii?Q?WTlHhdWTMfB2/Jvb2qZJLxlqcYe3/ljJVWQOI/PracouiYfZqICtf7WAk76I?=
 =?us-ascii?Q?gQUIaagUSt6EDSDMY0As7xDg/mqIAwL8jynI3dHf4AWgBYbwQiCUgwdkj+IO?=
 =?us-ascii?Q?jFD4eTQuJifEk71dSsIC/ewWFVKVylx3s62NVsFOZuoUxR7MZJ7W4qSZBRCy?=
 =?us-ascii?Q?3SCeU7QB98LRP/rUFLJJse+V9DukmYbBW8se3eo/5zzkjcWv+MDoo/gPM89P?=
 =?us-ascii?Q?yjb84ICpWoMH8+1eEEkPHLKhxmYOiRubze58q1H4p79xmYTjocsZm3UW7uKl?=
 =?us-ascii?Q?kuXZyI++vfZ0bW7Lmn8rKxuRrN7aUSP8UAblJT+sHRWYgO4cItzV9DdzfCvS?=
 =?us-ascii?Q?Tzd+h6RTIkHQdY9NhKbPomtw5mLCx3xMLP5p+D7bZ+jApHiFQeih5f+rBdrj?=
 =?us-ascii?Q?dakbPszD69GouqW6eifyWJwm7B84axX/dCPePE2OkA0zuNo8V8UJqwqQJGMW?=
 =?us-ascii?Q?wf6gFgjVncGA8g5pPekfUbudCp219uwxDDAr6/yNKJyIFbLNs7VFdyKM+uT5?=
 =?us-ascii?Q?9UuaF1hfK5hNhUTPTBprUARA/i/Vs3QTugs1bPMyAU4Oci3hjH9488XARWyl?=
 =?us-ascii?Q?rA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0556ffe8-5a5b-47aa-a561-08da799ab8d2
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 00:04:26.0177
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P9Jz7OSkaJ1Ab2NX9pZV7m13piU7A/DRyZ2EZYZjbt3/BFeaOGba+njZ8ui/dS6oWyv+FQMTrdn3BxRhZz/HbQQ+olKryHThNpn5F2Z5F80=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2590
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-08_14,2022-08-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208080105
X-Proofpoint-ORIG-GUID: XuNzfgvyCDYAH_8UH82znH44PauVgU-D
X-Proofpoint-GUID: XuNzfgvyCDYAH_8UH82znH44PauVgU-D
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

LIO is going to want to do the same block to/from SCSI pr types as sd.c
so this moves the sd_pr_type helper to a new file and adds a helper to
go from the SCSI value to the block one.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c            | 29 +++++-----------------
 include/scsi/scsi_block_pr.h | 47 ++++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+), 23 deletions(-)
 create mode 100644 include/scsi/scsi_block_pr.h

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 18ea9ea6bd68..88ce1464527c 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -67,6 +67,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_ioctl.h>
 #include <scsi/scsicam.h>
+#include <scsi/scsi_block_pr.h>
 
 #include "sd.h"
 #include "scsi_priv.h"
@@ -1682,26 +1683,6 @@ static int sd_get_unique_id(struct gendisk *disk, u8 id[16],
 	return ret;
 }
 
-static char sd_pr_type(enum pr_type type)
-{
-	switch (type) {
-	case PR_WRITE_EXCLUSIVE:
-		return 0x01;
-	case PR_EXCLUSIVE_ACCESS:
-		return 0x03;
-	case PR_WRITE_EXCLUSIVE_REG_ONLY:
-		return 0x05;
-	case PR_EXCLUSIVE_ACCESS_REG_ONLY:
-		return 0x06;
-	case PR_WRITE_EXCLUSIVE_ALL_REGS:
-		return 0x07;
-	case PR_EXCLUSIVE_ACCESS_ALL_REGS:
-		return 0x08;
-	default:
-		return 0;
-	}
-};
-
 static int sd_pr_out_command(struct block_device *bdev, u8 sa,
 		u64 key, u64 sa_key, u8 type, u8 flags)
 {
@@ -1748,19 +1729,21 @@ static int sd_pr_reserve(struct block_device *bdev, u64 key, enum pr_type type,
 {
 	if (flags)
 		return -EOPNOTSUPP;
-	return sd_pr_out_command(bdev, 0x01, key, 0, sd_pr_type(type), 0);
+	return sd_pr_out_command(bdev, 0x01, key, 0,
+				 block_pr_type_to_scsi(type), 0);
 }
 
 static int sd_pr_release(struct block_device *bdev, u64 key, enum pr_type type)
 {
-	return sd_pr_out_command(bdev, 0x02, key, 0, sd_pr_type(type), 0);
+	return sd_pr_out_command(bdev, 0x02, key, 0,
+				 block_pr_type_to_scsi(type), 0);
 }
 
 static int sd_pr_preempt(struct block_device *bdev, u64 old_key, u64 new_key,
 		enum pr_type type, bool abort)
 {
 	return sd_pr_out_command(bdev, abort ? 0x05 : 0x04, old_key, new_key,
-			     sd_pr_type(type), 0);
+				 block_pr_type_to_scsi(type), 0);
 }
 
 static int sd_pr_clear(struct block_device *bdev, u64 key)
diff --git a/include/scsi/scsi_block_pr.h b/include/scsi/scsi_block_pr.h
new file mode 100644
index 000000000000..36d6e742fd98
--- /dev/null
+++ b/include/scsi/scsi_block_pr.h
@@ -0,0 +1,47 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _SCSI_BLOCK_PR_H
+#define _SCSI_BLOCK_PR_H
+
+#include <uapi/linux/pr.h>
+
+static inline u8 block_pr_type_to_scsi(enum pr_type type)
+{
+	switch (type) {
+	case PR_WRITE_EXCLUSIVE:
+		return 0x01;
+	case PR_EXCLUSIVE_ACCESS:
+		return 0x03;
+	case PR_WRITE_EXCLUSIVE_REG_ONLY:
+		return 0x05;
+	case PR_EXCLUSIVE_ACCESS_REG_ONLY:
+		return 0x06;
+	case PR_WRITE_EXCLUSIVE_ALL_REGS:
+		return 0x07;
+	case PR_EXCLUSIVE_ACCESS_ALL_REGS:
+		return 0x08;
+	default:
+		return 0;
+	}
+};
+
+static inline enum pr_type scsi_pr_type_to_block(u8 type)
+{
+	switch (type) {
+	case 0x01:
+		return PR_WRITE_EXCLUSIVE;
+	case 0x03:
+		return PR_EXCLUSIVE_ACCESS;
+	case 0x05:
+		return PR_WRITE_EXCLUSIVE_REG_ONLY;
+	case 0x06:
+		return PR_EXCLUSIVE_ACCESS_REG_ONLY;
+	case 0x07:
+		return PR_WRITE_EXCLUSIVE_ALL_REGS;
+	case 0x08:
+		return PR_EXCLUSIVE_ACCESS_ALL_REGS;
+	default:
+		return 0;
+	}
+}
+
+#endif
-- 
2.18.2

