Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C6CFC433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Oct 2022 03:10:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbiJWDKO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Oct 2022 23:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbiJWDJQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Oct 2022 23:09:16 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E7373C2A
        for <linux-scsi@vger.kernel.org>; Sat, 22 Oct 2022 20:07:42 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29N2tC32015615;
        Sun, 23 Oct 2022 03:05:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=jX5kJrGR0eQrgYNm0xW+T4IYbQSa2eltMNKAoyURwW0=;
 b=dzNxBk7js+0IpTFW+VDLX84gAl+au4iNN0TSVx1b2ExsxkBeK/Nckyl6K52w1mNk2KAA
 Qz0/c2y7KfDM9rxv3ah5daU7qGZE8g1945TxODrj1R45NkZHuYYNerUytXGi6GazbhjF
 k2/nYnMipLMtk/b1Ftp+O8SCq3R0IqqFJmLYhOP9W2r2l0jc0bGkvrUpdpyoDn8ytkDW
 3Ayfjw++KoHSLIPDn/ZqVf2DR7ZGZvZJXDYaiCcGT/nsa2paAmWK186z6qm5Xe4RWcVv
 VK0S7mJOM1qIs05M32PrG/ZoWSFbKNoilAetx8IaDjShL2VoZ+ntajRhTLEX5SiaaTx+ oQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc7a2s4qr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:05:30 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29MJW0ff032103;
        Sun, 23 Oct 2022 03:05:29 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y30aud-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:05:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=if0zCE3MPi4urDCHI6kMHUHJozs0/A8lbzJ0jz5WI1azRjFkOdjK8sOFk9dwequeeGgVOKWZ8fIHagyHYZH1yRoaRMO17lO0I21Rddr+YlZ36C/k2r/P/gnGlkj32i+qSHaXYrDgCYqDJWuTPPkpOJQmsJgsBl+y9tnqnsWiR7ZLidcyJfmSBV6Vb9PetBE++an+yemZb/nmkiPIF9pTh1sqCi5bCrLHYgVUdtHSjNxwJ1XGtDrf9SmLI7isy74KYxk30PGa6/mqLYc2tZWGe2MsAAt1c2ikdrAw2CVQDt/G7257OrMsjU0ai96w/7SjaaDhLBW0fEd6DJYaGchq2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jX5kJrGR0eQrgYNm0xW+T4IYbQSa2eltMNKAoyURwW0=;
 b=Jck+K16HHwvKMfC5It2jJeNmHLS85PYw7McMUiVBdmmv6bUBwNk/S/oPHGGTroeTDGJmbVCASTSlXHKpCKQUs3DeADG3ziMIlKTLeS5Fi2X48Z4Xtgx0s7ssmoYv1tsVEzfb5klIMpH9Dywz8fPLmXF126uwYGnOrXrTVo8l1aBY9QuXL2AATITJFHaaaE9XqpJLgR6naYzkujK9B15GAugT9t87uuVjs9BN4awrd/OpFjFSqK3i7fq8RRm6KC33exbcCngSwja2HKGUnvTFAIJtxLMHhQ+0iFwz1xor2TDP3AZa0rRLGX6IT5xLURscGsfhp66iB+oj7ifPPs/9OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jX5kJrGR0eQrgYNm0xW+T4IYbQSa2eltMNKAoyURwW0=;
 b=Tj+xR0KrDevH7KH5kGHzNf4Wmhy+jEwa53llSSPVTewq0IMB8aLUQlGH3Y9yjFyrCojvrSwlKPTgPCh+5CJnhBVEzehoFBnUR65AO4wkRB2+93r8PXneATRmwFAZBm9vGma8gK8oZVUFFNRf+6LWFPv04flYptQukY1mv3B/byI=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BY5PR10MB4337.namprd10.prod.outlook.com (2603:10b6:a03:201::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Sun, 23 Oct
 2022 03:05:27 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.021; Sun, 23 Oct 2022
 03:05:27 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v5 35/35] scsi: Add kunit tests for scsi_check_passthrough
Date:   Sat, 22 Oct 2022 22:04:03 -0500
Message-Id: <20221023030403.33845-36-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221023030403.33845-1-michael.christie@oracle.com>
References: <20221023030403.33845-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR15CA0020.namprd15.prod.outlook.com
 (2603:10b6:610:51::30) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BY5PR10MB4337:EE_
X-MS-Office365-Filtering-Correlation-Id: b4bd9e0b-0044-48cd-1f24-08dab4a36094
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: syJMMC0Wpa2rakmxwJpd8xJEdQpWiSrm3JyfiilERQnyrzfKMZj+l4m2bv52SyMLJbOylE0mun4sDESPgb1K05hcQijlQzkFXZ/oL/SLr0OcCxXtlAwT28RZ7X+LOpxOJARuvR9Xc8DbsLtj48WWpcZ9sLTYuUIsd5aB6R25Lth1Bwf9HF9wHcdkgpEBHKSMaLicvJdeZSgbOxBois/+Ywg+r4Dw98QdRi/kLMMYxyJKDW6CEwzJm6fdlcfXhN0QOfgKMsVsei0lF6iWMP4EJDU2g8TA+3mhelhyV3SrByNMCi/opuf6DOE7sXmvn3VqQmaX9w741yl5SVj6gHDC+VhCm+NuqFwQwyX7fCCWjQp4MsOivRJgE1SSHoDi5h1m4jfVOsuwNvcwu+9hlGkZbxomlZZqDEar6Bj+rOZdq99F4U7xbLUea6zUovqeUVgj6aEc8AUvpUaMe33c7/1HoW1wDhNwRC4XNkDg5hvCyANPu5XpCAz0EkJGx3XuJoNRG3QknilrdfdOJLYYTZrmduCec4yydQZmulOVZl0fKL8NgTB5/iSIaKu3BCyg8fQFa7axNyWD/UBpBVrs7Qi7bOwKNuALh4NFtbh8iuV9vqok4vR/Mj9SKyZ4hbfseewIqXzDlq9MRzluT1V/nDzBkxHLCvacVgXeMAGxCTGJ8LnmVaEg0M02BVfqIx4W3FlSrC5JtuqU6MD9FPG+nZClXA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(366004)(136003)(39850400004)(396003)(451199015)(66946007)(8676002)(316002)(478600001)(6506007)(6486002)(6666004)(4326008)(66476007)(66556008)(107886003)(8936002)(6512007)(186003)(2906002)(86362001)(1076003)(5660300002)(2616005)(26005)(41300700001)(36756003)(83380400001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ko/MKfimlSAP1PxRwLhTjg5jf5Zd0/f48GQIhh9IwmNjiKaIg5ZqwLEoNhhf?=
 =?us-ascii?Q?geq1/Y+pF2wqrQ/aoix4Ip9itr3vOAJVPeZ3QTUjRTr8ka9Ur6dv4SZrjcQ+?=
 =?us-ascii?Q?+RN7gHBP6o+L5QGOSNx8mzLi7L3oq7uq5K8liaNmpkJrC6q6W/R8LRgd6meV?=
 =?us-ascii?Q?/QN1OpK7XAoq/dcox5e3jeO78Qhl1gkk+WwlZR33r0RIoyKJ8L2M7g3J8QDA?=
 =?us-ascii?Q?HoC70vtLp41/pE08yF6r5cmXzv1gHY+Wkhcq32kj1lBIba3Pe1OLgN/XwxKq?=
 =?us-ascii?Q?yI+zeLdktD2zLJRaCTThtsOOV5ZU/6KKFGs9l+0ME79tIvFxJQxR/RSnSWmB?=
 =?us-ascii?Q?HGlLxLxtxWWx7j+9cCwNfDUWGFxbwe4vBZN08iU6A+iXt9D+pvQ8QBzLMUx1?=
 =?us-ascii?Q?15n3jHU5ovmgYsnKTBkfEFp5yJKUA6D5RCydB9LlluLAd84VIB8qX31oXTF9?=
 =?us-ascii?Q?VSjwSCs3kHhFbsJfIee+3F+HeECounOHqW6lBa9yO9cYKL+yVvG3E4OmUlfy?=
 =?us-ascii?Q?vZVDA298z36SV/TVFG/qgb8/H3Iy9RUcX4jQ2y6bqCST1do44gJTMj9TgJRn?=
 =?us-ascii?Q?cSH1t/x8vS2NUctMwRF8jdH6OrVWKduLh7RBzabFXUiCkriGNu6WNnQSqxxw?=
 =?us-ascii?Q?NjAXTYNSAFDz5/Z0aucjsNmluR0by14LHAk/PWuM3YEfXebMGC1RpRlioRMU?=
 =?us-ascii?Q?Nx0vZpkMPI0ppXtYNdE8YIzfl8Z/NP/I3bLiZH6Z7ZuypS6Uyi/G6HYeIIiw?=
 =?us-ascii?Q?RqSR/L0fo6hLkS+sPKZNR1JrC8y4HWT7dxLhya3GKRjJsH4V4K1vR0tK/R4y?=
 =?us-ascii?Q?uVgBLDYXMTxJiKGRiZWl8/kh4t0bsCbncictYLZ2klHFyuhf8l1unErV4UrE?=
 =?us-ascii?Q?l41KCco41TfWx66yQd+snV6FTtoV++9E9d/jAgijavJtpJFnfXt2rqYex4Vk?=
 =?us-ascii?Q?6hl9PLxX+A60GBFHR4IuE/K/D170u3MqfJyiA78oEE7/P4UepBFRSeCB50Fn?=
 =?us-ascii?Q?bb/Ya4xYi+SSWHMUaz0zqf11advYbZsdpppNs4ZW+A3+WLD72LyO08CtZI8h?=
 =?us-ascii?Q?smSKvCMwmYuMO82enI0d7QOe97ZmWMm99DiBBeSo0pNra4pjXGU2dJRTLD7f?=
 =?us-ascii?Q?IB8CSILlg2CUGPBTLL0JLQ1IXrbS5vakQgDz6b0ia6kpmKo8rDGDweMUog6M?=
 =?us-ascii?Q?1h6ZNrUV17wn1UYkC10UnFvxrBBKoM9monpDLq2/XKOPpU4xg16+JhcGPEEJ?=
 =?us-ascii?Q?AlVbV5Ts69cC5/pMglWc1qtsPIEYneX0K3UniuYMRU1P4jKG0eXfQmuVwA/q?=
 =?us-ascii?Q?HGHMu9ExsSzyxNtsikL9gmA8QnIAm+GFPxhD2eRjzK/0ZGVyVitX7pvuF1jr?=
 =?us-ascii?Q?VODN6zxmZaCyUS2ctDD95LTRkize0fhgMgLGC9nZsCXMzlRcOCdn6zqVWllR?=
 =?us-ascii?Q?GBhFfQ93LS2FFsVm+PeoAJjBWTuda0Eu389b4Y/JBOk6ya26/LXbA/DrAwNd?=
 =?us-ascii?Q?mCL+iSDH3g2n8OB3TU9BXv9btiUZpci9fgVYu6NqzoPxPIZK9WJHtHbBSl9M?=
 =?us-ascii?Q?o+35eTEh29TLBkE7ebqF/exdqp7sQ9N/H+VgHqSGn+NoR3QwNQBUJZtlOmB7?=
 =?us-ascii?Q?Kg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4bd9e0b-0044-48cd-1f24-08dab4a36094
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2022 03:05:02.0585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qOAVuw+xh1J3BtNhwa012satT21rnL2eBUPJRm8bJt/3I2YDlESvr+Pn+0DuK50x/RDfTzxQCtdRsghZxTYajbBX0lewdtO8hp/qvviLzmQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4337
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210230018
X-Proofpoint-GUID: CrL2aOsV4ZsXUvLzL-mtoa2858j1TaWh
X-Proofpoint-ORIG-GUID: CrL2aOsV4ZsXUvLzL-mtoa2858j1TaWh
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add some kunit tests for scsi_check_passthrough so we can easily make sure
we are hitting the cases it's difficult to replicate in hardware or even
scsi_debug.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/Kconfig           |   7 ++
 drivers/scsi/scsi_error.c      |   4 +
 drivers/scsi/scsi_error_test.c | 171 +++++++++++++++++++++++++++++++++
 3 files changed, 182 insertions(+)
 create mode 100644 drivers/scsi/scsi_error_test.c

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 03e71e3d5e5b..40ddbb691f08 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -67,6 +67,13 @@ config SCSI_PROC_FS
 
 	  If unsure say Y.
 
+config SCSI_KUNIT_TEST
+	bool "KUnit tests for SCSI Mid Layer" if !KUNIT_ALL_TESTS
+	depends on SCSI && KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  Run SCSI Mid Layer's KUnit tests.
+
 comment "SCSI support type (disk, tape, CD-ROM)"
 	depends on SCSI
 
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 19548a1d69c0..87ab763b7b19 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2616,3 +2616,7 @@ bool scsi_get_sense_info_fld(const u8 *sense_buffer, int sb_len,
 	}
 }
 EXPORT_SYMBOL(scsi_get_sense_info_fld);
+
+#if defined(CONFIG_SCSI_KUNIT_TEST)
+#include "scsi_error_test.c"
+#endif
diff --git a/drivers/scsi/scsi_error_test.c b/drivers/scsi/scsi_error_test.c
new file mode 100644
index 000000000000..23a2e7edc5eb
--- /dev/null
+++ b/drivers/scsi/scsi_error_test.c
@@ -0,0 +1,171 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KUnit tests for scsi_error.c.
+ *
+ * Copyright (C) 2022, Oracle Corporation
+ */
+#include <kunit/test.h>
+
+#include <scsi/scsi_proto.h>
+#include <scsi/scsi_cmnd.h>
+
+#define SCSI_TEST_ERROR_MAX_ALLOWED 3
+
+static void scsi_test_error_check_passthough(struct kunit *test)
+{
+	struct scsi_failure multiple_sense_failures[] = {
+		{
+			.sense = DATA_PROTECT,
+			.asc = 0x1,
+			.ascq = 0x1,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x11,
+			.ascq = 0x0,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = NOT_READY,
+			.asc = 0x11,
+			.ascq = 0x22,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = ABORTED_COMMAND,
+			.asc = 0x11,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = HARDWARE_ERROR,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = ILLEGAL_REQUEST,
+			.asc = 0x91,
+			.ascq = 0x36,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
+	struct scsi_failure retryable_host_failures[] = {
+		{
+			.result = DID_TRANSPORT_DISRUPTED << 16,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+		},
+		{
+			.result = DID_TIME_OUT << 16,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+		},
+		{},
+	};
+	struct scsi_failure any_status_failures[] = {
+		{
+			.result = SCMD_FAILURE_STAT_ANY,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+		},
+		{},
+	};
+	struct scsi_failure any_sense_failures[] = {
+		{
+			.result = SCMD_FAILURE_SENSE_ANY,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+		},
+		{},
+	};
+	struct scsi_failure any_failures[] = {
+		{
+			.result = SCMD_FAILURE_RESULT_ANY,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+		},
+		{},
+	};
+	u8 sense[SCSI_SENSE_BUFFERSIZE] = {};
+	struct scsi_cmnd sc = {
+		.sense_buffer = sense,
+		.failures = multiple_sense_failures,
+	};
+	int i;
+
+	/* Match end of array */
+	scsi_build_sense(&sc, 0, ILLEGAL_REQUEST, 0x91, 0x36);
+	KUNIT_EXPECT_EQ(test, NEEDS_RETRY, scsi_check_passthrough(&sc));
+	/* Basic match in array */
+	scsi_build_sense(&sc, 0, UNIT_ATTENTION, 0x11, 0x0);
+	KUNIT_EXPECT_EQ(test, NEEDS_RETRY, scsi_check_passthrough(&sc));
+	/* No matching sense entry */
+	scsi_build_sense(&sc, 0, MISCOMPARE, 0x11, 0x11);
+	KUNIT_EXPECT_EQ(test, SCSI_RETURN_NOT_HANDLED,
+			scsi_check_passthrough(&sc));
+	/* Match using SCMD_FAILURE_ASCQ_ANY */
+	scsi_build_sense(&sc, 0, ABORTED_COMMAND, 0x22, 0x22);
+	KUNIT_EXPECT_EQ(test, SCSI_RETURN_NOT_HANDLED,
+			scsi_check_passthrough(&sc));
+	/* Match using SCMD_FAILURE_ASC_ANY */
+	scsi_build_sense(&sc, 0, HARDWARE_ERROR, 0x11, 0x22);
+	KUNIT_EXPECT_EQ(test, NEEDS_RETRY, scsi_check_passthrough(&sc));
+	/* No matching status entry */
+	sc.result = SAM_STAT_RESERVATION_CONFLICT;
+	KUNIT_EXPECT_EQ(test, SCSI_RETURN_NOT_HANDLED,
+			scsi_check_passthrough(&sc));
+
+	/* Test hitting allowed limit */
+	scsi_build_sense(&sc, 0, NOT_READY, 0x11, 0x22);
+	for (i = 0; i < SCSI_TEST_ERROR_MAX_ALLOWED; i++)
+		KUNIT_EXPECT_EQ(test, NEEDS_RETRY, scsi_check_passthrough(&sc));
+	KUNIT_EXPECT_EQ(test, SUCCESS, scsi_check_passthrough(&sc));
+
+	/* Match using SCMD_FAILURE_SENSE_ANY */
+	sc.failures = any_sense_failures;
+	scsi_build_sense(&sc, 0, MEDIUM_ERROR, 0x11, 0x22);
+	KUNIT_EXPECT_EQ(test, NEEDS_RETRY, scsi_check_passthrough(&sc));
+
+	/* reset retries so we can retest */
+	for (i = 0; i < ARRAY_SIZE(multiple_sense_failures); i++)
+		multiple_sense_failures[i].retries = 0;
+
+	/* Test no retries allowed */
+	sc.failures = multiple_sense_failures;
+	scsi_build_sense(&sc, 0, DATA_PROTECT, 0x1, 0x1);
+	KUNIT_EXPECT_EQ(test, SUCCESS, scsi_check_passthrough(&sc));
+
+	/* No matching host byte entry */
+	sc.failures = retryable_host_failures;
+	sc.result = DID_NO_CONNECT << 16;
+	KUNIT_EXPECT_EQ(test, SCSI_RETURN_NOT_HANDLED,
+			scsi_check_passthrough(&sc));
+	/* Matching host byte entry */
+	sc.result = DID_TIME_OUT << 16;
+	KUNIT_EXPECT_EQ(test, NEEDS_RETRY, scsi_check_passthrough(&sc));
+
+	/* Match SCMD_FAILURE_RESULT_ANY */
+	sc.failures = any_failures;
+	sc.result = DID_TRANSPORT_FAILFAST << 16;
+	KUNIT_EXPECT_EQ(test, NEEDS_RETRY, scsi_check_passthrough(&sc));
+
+	/* Test any status handling */
+	sc.failures = any_status_failures;
+	sc.result = SAM_STAT_RESERVATION_CONFLICT;
+	KUNIT_EXPECT_EQ(test, NEEDS_RETRY, scsi_check_passthrough(&sc));
+}
+
+static struct kunit_case scsi_test_error_cases[] = {
+	KUNIT_CASE(scsi_test_error_check_passthough),
+	{},
+};
+
+static struct kunit_suite scsi_test_error_suite = {
+	.name = "scsi_error",
+	.test_cases = scsi_test_error_cases,
+};
+
+kunit_test_suite(scsi_test_error_suite);
-- 
2.25.1

