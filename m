Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7C8CC43334
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jun 2022 03:05:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379953AbiFQDFA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jun 2022 23:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379936AbiFQDEy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jun 2022 23:04:54 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B1EE6623A;
        Thu, 16 Jun 2022 20:04:53 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25H02WDO009842;
        Fri, 17 Jun 2022 03:04:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=xIu5h/HmVTkWDVmbEAPyG75RBdj+A8sdJYJ42jy/P7Q=;
 b=JtHTcAiaOGQz7AkjSiJ5TuIAQe/ztEW+a8qgRBqm6cYrCMEcN3bfNr61OD7fchL1BH4r
 2uMo5VuZfaZYXo0t2EW80mdpflvZnEdjOQ2ZStqms1dojMDAL/NttxN6KRQ6llhJhD0E
 r3JyuI7ERQsonjXmEpKsNSH9ozdvdd8vPj6xjfjZ5Uek7U3ZIW4bZI7Dr9daFzKLvRbu
 R5EzRzwDGkgSzKM4nguwWToIWZ2vChmKDKfllBErKO6hoEZtnwO2qIXZdu8nx+rqUqOt
 bgko+Kf9qsHD3sj7lqQOk6FqCmBgQrKSq6Lk7S0oG4QefJtcDUVND57bzRAmdBqiRUoM cg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmkktmt5e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jun 2022 03:04:52 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25H2u1Xf016838;
        Fri, 17 Jun 2022 03:04:52 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gpr7qrnv2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jun 2022 03:04:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xclupv3WQrHEjZWn7vybsUJbSh1/VJpM043S5HufyUntma7DpvJwlI3JfwZbWj0eQ+rnbqQ0osLVPiCGEuIvlAmCBT63R92CoMXnxjV92+ZFAszXfmtGzQaSXufIIO57V20Z/xNM9f6cY9WMY6gADjNUxPGkm4q4pyBukSpm71xE/He3F8QpCVpKk9+5ilRoVR7ChcMT98AjZQP7XIpyJpFUbj3k3796Lg28K0zi2xX+LoNZeWv7nXQkQD8uk4qdCkK88+jx2oU2xeildFjkjk1mr1XT/+qywYiC3aI9uS1TC7ab3ublQCvGU2fOkiWMxByYfWOmdACdTq/iP9jO8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xIu5h/HmVTkWDVmbEAPyG75RBdj+A8sdJYJ42jy/P7Q=;
 b=ZLYvBkgOjKATuSkOWPY79qVzirFLMYxC0BoeLqzJ5U9Vc4kLUrE/Ppi5ZpZe6OjAuZN5te83F/LwdQ8GP4X9wzVBdcuj4MeHg/LZnzVEnTRZmUJM3oKcBXbVnxrAt/Gw8XKbC1TBjHyvGZOp8p0IE6csQdISGtFfZYSNJEVAawVTpxwDnSgCxi19mOz3PhRZb8xKT0LH49SXxfxgAd+d35miwe0Qz5D+ubngDAF+QV5KyTfTVxM12DvANh9TGF4i/cFCwrZUqzKIA76a3bB8LOEXAxJEPxc58oZ+NNDmdHNEypwtSonOJZODTfabrvRk6Jo6AdFLDOIOaHjc18tGcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xIu5h/HmVTkWDVmbEAPyG75RBdj+A8sdJYJ42jy/P7Q=;
 b=gx3LRKqNkXCX6g+YAC9ppMkGdOw0Y3FG2fhg0UbS3q3Mztx3JUx5twT10Np4ybeqFHwIXJjxGo5UaJa4id/VB4NzrSRk5jstuCUrc8qkYXNNkrY6VJ/AU2N8VMyfuSXG2ehqjJGKywbFH/f5IjxukUKZ88cvmSREUsT2ZTs4XlY=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MWHPR10MB1280.namprd10.prod.outlook.com (2603:10b6:301:8::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5332.17; Fri, 17 Jun 2022 03:04:50 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5332.016; Fri, 17 Jun 2022
 03:04:50 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 4/4] scsi: target: Detect unmap support post configuration
Date:   Thu, 16 Jun 2022 22:04:39 -0500
Message-Id: <20220617030440.116427-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220617030440.116427-1-michael.christie@oracle.com>
References: <20220617030440.116427-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR20CA0034.namprd20.prod.outlook.com
 (2603:10b6:3:13d::20) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 11596f7e-6448-4aa1-2334-08da500e2483
X-MS-TrafficTypeDiagnostic: MWHPR10MB1280:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB1280B6C0E0113C7371D52389F1AF9@MWHPR10MB1280.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g6+7mU9udZR0mbVT9/b6rgkUd6T3AAgU5Q/HdbGqbZPPxLPb++zW0UtLtSr1/7ip+WbQZNXss/6faVhxhWWfrcGNbkH8O3h+Z27Ym+36+qFvlvk+KqvsftYJ9krrDqMKde2aOsnXSDqZEiX/zgycsBXniyWGhKMWltp9qoxSqfpTNMCOh2uFMvjv6zDG3S6JNybD3nLkZ030cHruBbuJWme89NXQcaBkcNIvQV50pDrigJX+9JqmrK4DGjvFcSXZN0UdeVMjAT1QSvFv7/SBNZ4sWgxdn+PiwcBckvGr250LTKp6N8FSYSUuI5PNj4UCSBdm4jI9xJ9fg3u54FO9fXu9y3w9/I42N9MfLrIRqRwsOJmBmSXWe9+YpvfgraTbJFwcNo5ouLLf8a81LjyuNOnZTPM4zFUwMU1kKLuCBrwQnSM54cc3G1Vw6SHr/+WS7dwzvZ7P+f9j+rTfSZQB9UmD+xxlBErFWQ6M9wvhp7jMVnrmK7WfxAhyT1qGHJDqOEBZGx+WPh+lRrjfsbaBTcAW5UEZl7eyaKEDJyUIjS4mGDuF97wDD7kdo9/YHuq4GO41uRrAlSYb1hlm1KJek5o4BZ8r/t01/eU9/TZfP4Du+gOwUeYZ6w20t5kgu/KLBQC8C6+m1CL37U9hNd16OpfZkZuU8rX0abhbhkN9ppX7qOGfdmP3WDU5881jdFQLJVJE+S8NWEIvAxPxoxpTbA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(8936002)(6666004)(6506007)(6486002)(6512007)(508600001)(186003)(26005)(66946007)(52116002)(38100700002)(2906002)(38350700002)(1076003)(86362001)(66556008)(36756003)(107886003)(8676002)(2616005)(4326008)(316002)(83380400001)(66476007)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?50Uv3WMgmdAdErZb5avdhaC7VQ79U/3TAB2pto6pKIeNZpeiIoulyEveBTPL?=
 =?us-ascii?Q?+sCqjv2lCDOzO4HzWsAw4WDEK29Uf3IWjaFyh+cjiXQkuEMt497mxoAcIYZr?=
 =?us-ascii?Q?sQUuVMRo0H2OeSPepwHmSuT9NmkxYAemlKdD2C+rXc/PBku3HwL1xp54fFsE?=
 =?us-ascii?Q?92oF1U9lLQkD95T0PPHuppFztU1f/q4Ogig9bKxZzHAnJ+8HBMt0whLlqxfw?=
 =?us-ascii?Q?lw3Ckj/l/uGPSgRb1znQpLGF/6/ojjV+YctHYcaY1YQMr2F10jIPVqJEm2Ph?=
 =?us-ascii?Q?KzvPha9K+uv55XEocrtcPToiD7jYn8yNJHqNvg5fQHRFdw3dnYcNZTb7krsI?=
 =?us-ascii?Q?DuVJL/I53vMY4DHWUgZ0PbgJUYpNQuBpfvbfFHG6JTfFN7w12NtZeDQENH8d?=
 =?us-ascii?Q?IjIUa/Mmu6/gNAG/nzf7mnqXB1tw+Mxln3zG+NV2X18rXy+xKTQk7JpInQUe?=
 =?us-ascii?Q?EgX7Mh6MB/GcqzlU8mRrYYajiFgBVL6TUqGhXBoGC5j/Mffu12140bEXMU4q?=
 =?us-ascii?Q?VpjOV2N7SpmmHYDr2Tl1hh4mLmyeKXLii+ABBqDtqmOhGoIVYQSciehdDVlZ?=
 =?us-ascii?Q?uBUExZJsH+ZCgj646ZaiwpPZuTPlof6LuzAa/5hpuc44t0eUw4YL/O+IiDO4?=
 =?us-ascii?Q?e6wNuZBRofPNpU/8KP6ZIDmPUDiNiFwXXtP16SJ5PNwDzw9oP93KHQNJGhNf?=
 =?us-ascii?Q?hmY4sDxGhlf7KB0Wjk/fQqWSGDt6T+/ccgxUX9XungSV9cxK1LvOEBmlObvd?=
 =?us-ascii?Q?Z23Tt2Rbtd5ipmOv9xcAK+xbMih0G7X11nAbidIJplZgdxO9yhtZmakehWso?=
 =?us-ascii?Q?lSimvMgGTKvh1koeAAzt0bgXE5RDo685HMKbFQ+xssMNPKCmNFhkoM66zf3/?=
 =?us-ascii?Q?FlhPZzrgckXC9pODXSvBWL7n1GM+hXfZL/DDVbl/3k4imJgmmsBGLmWZXVbj?=
 =?us-ascii?Q?2pZA8XTkmg3qyMfM90WmuPWlR8efiIp34BAv3kG7qz2g6bZxUfS6yZm12z7o?=
 =?us-ascii?Q?Vkbx232bDJKkpTmxtBqkyfJ0wHpUfnVvkzO3SZ8rFhgi76mO/Y60XLhGqPjS?=
 =?us-ascii?Q?x0SmrvLEqHZlFalUkyYO4iGagoaQmojTGtQDaJ10+0rVYoTVajabgdtApaRC?=
 =?us-ascii?Q?U2Bf2fH86e8W8EwJpuQ86sTEzzBKWRoYQ06vGEzP+ZTQfLrGan2iPHkorDpB?=
 =?us-ascii?Q?NSMwaaftaoARKRR4NTX+ixeKY6c1sIllNYbjNrwWu3PHypWyv5PYX3V3wJkM?=
 =?us-ascii?Q?Kcqz2Wfhf7lsTDmPnVjCfjfBD+uJcAuTE3igSPUVgeOCODiONoY+4G5O9q2q?=
 =?us-ascii?Q?+JrWcmR+zQgd5ZScO0Nrur438Mtzz+CNlG9tuBpzvxad47V6Gmp0ywKURfxH?=
 =?us-ascii?Q?oUc3w4xMSFOrOxdymhezsItbBbcoYAVcmplE7rABRSALgrolDr9SA1c3mgZd?=
 =?us-ascii?Q?OXUQCkIHsyYRo/n47vQpXb2AYL9fHp2DmNq54Om0cR6QviFaTxqnQFV5Zi4H?=
 =?us-ascii?Q?qV0SSIz19nS3zJ67cgIR7CUdGGUoP3qolOkPYNBelPZVD1UORbelNXIiSghw?=
 =?us-ascii?Q?ko8trw5rw2K+Q5SLvEDmWktTdPkXgyeHip9Pa0/3RfNWDnbaYBxFHTIe+YGx?=
 =?us-ascii?Q?Et51jbNXRcQCVEKUnlQyAZpR7E40wKpdooysnxxY6mt9tnn4kx2DBtLzqaZY?=
 =?us-ascii?Q?XgloNsxL1JrmEXSfNa+MdyT97RLTDMCDbQYnc8ZMwmk95bKFAYqbJgL/PAfp?=
 =?us-ascii?Q?pkcgJKHVdjv2Z31epfrNM3etzUp57Vo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11596f7e-6448-4aa1-2334-08da500e2483
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 03:04:50.0403
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H6PnYW3esgbAg4YDbkk7ec16PSXF7KFLoC2c7bz7rI4OBK8yDLX64RyxF4YFFEF5tfCaPPkanAj8MUYXuKRlKQ1IzlpsinpYs3XMYL4C7xk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1280
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-17_02:2022-06-16,2022-06-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 adultscore=0 suspectscore=0 mlxlogscore=999 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206170012
X-Proofpoint-GUID: 7-lSe4UmzGAWKiEu_Trd6iK3W4oJ3XXY
X-Proofpoint-ORIG-GUID: 7-lSe4UmzGAWKiEu_Trd6iK3W4oJ3XXY
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On our backend we can do something similar to LIO where we can enable and
disable unmap support on the fly. In the scsi/block layer we can detect
this by just doing a rescan. However, LIO cannot detect this change
because we only check during the initial configuration. This patch
allows unmap detection to also happen when the user tries to turn it on.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_configfs.c | 27 +++++++++++++++++++--------
 drivers/target/target_core_file.c     | 15 ++++++++++++++-
 drivers/target/target_core_iblock.c   | 11 ++++++++++-
 include/target/target_core_backend.h  |  1 +
 4 files changed, 44 insertions(+), 10 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index bbcbbfa72b07..416514c5c7ac 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -732,6 +732,7 @@ static ssize_t emulate_tpu_store(struct config_item *item,
 		const char *page, size_t count)
 {
 	struct se_dev_attrib *da = to_attrib(item);
+	struct se_device *dev = da->da_dev;
 	bool flag;
 	int ret;
 
@@ -744,8 +745,11 @@ static ssize_t emulate_tpu_store(struct config_item *item,
 	 * Discard supported is detected iblock_create_virtdevice().
 	 */
 	if (flag && !da->max_unmap_block_desc_count) {
-		pr_err("Generic Block Discard not supported\n");
-		return -ENOSYS;
+		if (!dev->transport->configure_unmap ||
+		    !dev->transport->configure_unmap(dev)) {
+			pr_err("Generic Block Discard not supported\n");
+			return -ENOSYS;
+		}
 	}
 
 	da->emulate_tpu = flag;
@@ -758,6 +762,7 @@ static ssize_t emulate_tpws_store(struct config_item *item,
 		const char *page, size_t count)
 {
 	struct se_dev_attrib *da = to_attrib(item);
+	struct se_device *dev = da->da_dev;
 	bool flag;
 	int ret;
 
@@ -770,8 +775,11 @@ static ssize_t emulate_tpws_store(struct config_item *item,
 	 * Discard supported is detected iblock_create_virtdevice().
 	 */
 	if (flag && !da->max_unmap_block_desc_count) {
-		pr_err("Generic Block Discard not supported\n");
-		return -ENOSYS;
+		if (!dev->transport->configure_unmap ||
+		    !dev->transport->configure_unmap(dev)) {
+			pr_err("Generic Block Discard not supported\n");
+			return -ENOSYS;
+		}
 	}
 
 	da->emulate_tpws = flag;
@@ -964,6 +972,7 @@ static ssize_t unmap_zeroes_data_store(struct config_item *item,
 		const char *page, size_t count)
 {
 	struct se_dev_attrib *da = to_attrib(item);
+	struct se_device *dev = da->da_dev;
 	bool flag;
 	int ret;
 
@@ -982,10 +991,12 @@ static ssize_t unmap_zeroes_data_store(struct config_item *item,
 	 * Discard supported is detected iblock_configure_device().
 	 */
 	if (flag && !da->max_unmap_block_desc_count) {
-		pr_err("dev[%p]: Thin Provisioning LBPRZ will not be set"
-		       " because max_unmap_block_desc_count is zero\n",
-		       da->da_dev);
-		return -ENOSYS;
+		if (!dev->transport->configure_unmap ||
+		    !dev->transport->configure_unmap(dev)) {
+			pr_err("dev[%p]: Thin Provisioning LBPRZ will not be set because max_unmap_block_desc_count is zero\n",
+			       da->da_dev);
+			return -ENOSYS;
+		}
 	}
 	da->unmap_zeroes_data = flag;
 	pr_debug("dev[%p]: SE Device Thin Provisioning LBPRZ bit: %d\n",
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 2011836ab7f4..a7c6df01d554 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -86,6 +86,18 @@ static struct se_device *fd_alloc_device(struct se_hba *hba, const char *name)
 	return &fd_dev->dev;
 }
 
+static bool fd_configure_unmap(struct se_device *dev)
+{
+	struct file *file = FD_DEV(dev)->fd_file;
+	struct inode *inode = file->f_mapping->host;
+
+	if (!S_ISBLK(inode->i_mode))
+		return true;
+
+	return target_configure_unmap_from_queue(&dev->dev_attrib,
+						 I_BDEV(inode));
+}
+
 static int fd_configure_device(struct se_device *dev)
 {
 	struct fd_dev *fd_dev = FD_DEV(dev);
@@ -150,7 +162,7 @@ static int fd_configure_device(struct se_device *dev)
 			dev_size, div_u64(dev_size, fd_dev->fd_block_size),
 			fd_dev->fd_block_size);
 
-		if (target_configure_unmap_from_queue(&dev->dev_attrib, bdev))
+		if (fd_configure_unmap(dev))
 			pr_debug("IFILE: BLOCK Discard support available,"
 				 " disabled by default\n");
 		/*
@@ -944,6 +956,7 @@ static const struct target_backend_ops fileio_ops = {
 	.configure_device	= fd_configure_device,
 	.destroy_device		= fd_destroy_device,
 	.free_device		= fd_free_device,
+	.configure_unmap	= fd_configure_unmap,
 	.parse_cdb		= fd_parse_cdb,
 	.set_configfs_dev_params = fd_set_configfs_dev_params,
 	.show_configfs_dev_params = fd_show_configfs_dev_params,
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 767ed2e9474b..c435b6dd3ae2 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -76,6 +76,14 @@ static struct se_device *iblock_alloc_device(struct se_hba *hba, const char *nam
 	return NULL;
 }
 
+static bool iblock_configure_unmap(struct se_device *dev)
+{
+	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
+
+	return target_configure_unmap_from_queue(&dev->dev_attrib,
+						 ib_dev->ibd_bd);
+}
+
 static int iblock_configure_device(struct se_device *dev)
 {
 	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
@@ -119,7 +127,7 @@ static int iblock_configure_device(struct se_device *dev)
 	dev->dev_attrib.hw_max_sectors = queue_max_hw_sectors(q);
 	dev->dev_attrib.hw_queue_depth = q->nr_requests;
 
-	if (target_configure_unmap_from_queue(&dev->dev_attrib, bd))
+	if (iblock_configure_unmap(dev))
 		pr_debug("IBLOCK: BLOCK Discard support available,"
 			 " disabled by default\n");
 
@@ -923,6 +931,7 @@ static const struct target_backend_ops iblock_ops = {
 	.configure_device	= iblock_configure_device,
 	.destroy_device		= iblock_destroy_device,
 	.free_device		= iblock_free_device,
+	.configure_unmap	= iblock_configure_unmap,
 	.plug_device		= iblock_plug_device,
 	.unplug_device		= iblock_unplug_device,
 	.parse_cdb		= iblock_parse_cdb,
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 773963a1e0b5..a3c193df25b3 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -37,6 +37,7 @@ struct target_backend_ops {
 	struct se_dev_plug *(*plug_device)(struct se_device *se_dev);
 	void (*unplug_device)(struct se_dev_plug *se_plug);
 
+	bool (*configure_unmap)(struct se_device *se_dev);
 	ssize_t (*set_configfs_dev_params)(struct se_device *,
 					   const char *, ssize_t);
 	ssize_t (*show_configfs_dev_params)(struct se_device *, char *);
-- 
2.25.1

