Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D263C0015E
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Jul 2023 21:38:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbjGNViE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Jul 2023 17:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbjGNViA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2023 17:38:00 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D832E35B5
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 14:37:54 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36EL3n4I003892;
        Fri, 14 Jul 2023 21:35:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=aBxnfB+v607HZrHGyIp/x/vDAHduZBnCu8EBg8Yj6vQ=;
 b=2v6lUn6+pNJ+ljG/TacOHlW0ZqgIgCi7LAMfX4Cqj0n9PAXuW/9hSq5+tjOuppazOQpn
 zjftNvRabV9Za4RYEUmeD8UCYZLW7LB9W1uFAuSOuZCpLWsHUsqlE07vhtAbl7ZVPL/P
 cO+j9pwp0ZdCB8haKUDkPIWmikUHPSS+ZWPuuhVWxSdAmy7hSEF+Ks9UJe8VDt3QaH7A
 501U2NYSAYX0NfPbNVB0oug49nR1S901qqfBCiklBgPNNqIItRFcRQEDM2pyyxrjnCIM
 0HIz3jg4iJbAUDEv2p56vH6y0vb4ZbLwFrpAnszrsUE77Z+9K/6YIE/iznERhyX96ELr Ag== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rtpth2e1w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:35:46 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36EK0JIo007621;
        Fri, 14 Jul 2023 21:35:45 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rtpvsrwye-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:35:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DPHtEfRMDoll5SIMpcIGqKs9WS7iRDCeRxrnv/lhONg8onuqGdwK/ZvPPo0pyet9CXI82GNx+Psfvb63Otf82coOUuxCyzOzgg7/vsorErUpjXdzlj/+s7f4EBgqyXb093cd17w3AEDa+GJbKV5i3Epjrfwvbwxw4rLtzgZBq70n4cwtYBj2E8i6G3LIT2gekFNuSYzHxS0r8Hc06oenXiwvxF7vh65a4TGyq5i2RPUUim3GlemIRdiPXtzOqO3d12GNE81AaCoRjDTE/MyNYrtKLweuSlT6aZZJfwuREdnAU/G4x9o8Kl5CCsRj2FLv1z8IVCyY5neK/6fPadCpVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aBxnfB+v607HZrHGyIp/x/vDAHduZBnCu8EBg8Yj6vQ=;
 b=TyXxanIy+Q45wXvC7jPSvwELvEaY2aFq4v//8XXDp+x8V1vINHGQeJorgGzpOfNK9tJdnzvs932AQYreVFj4UL2E550wRZ3QLTU999dK1gOSeG+Ook0T0psyMmhSbuV1KO4+U7lecBgSgU52bbDB8kDAU0bBIlD1G7WiZKXHWWCqW/C2y8ViZMgSrow6OjjUVzKBA2P/0Y4AoRFQhJ/iXCqpz4U6pizKI/1msYPrqCdc115ZYTlb8UqR33naBnZI/+NDlIiGpsFNC2r0Q2xB7XNs3CzMhFyj4mD1Jzd0V1Z7zsyYoY4eqCgljxWH7auL6mrz2DQhm1cfEivuRlVDNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aBxnfB+v607HZrHGyIp/x/vDAHduZBnCu8EBg8Yj6vQ=;
 b=AMPWLcQxQr+ZPaYu1zwBUXQ5WePA/xWp3BcHaBCqJ7KBOd8Ze5wBEytCxmIKgrln/+u34DOHvoHuYjsvVV8DZ2IqMPY2O0ZdMJBF24ucbnpWbsIvuarNygtqJuLAIMsLrqDyLi7RaXwfqaBfxwGzGMZd1OVgrlvarOTJbWOQfCM=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM6PR10MB4377.namprd10.prod.outlook.com (2603:10b6:5:21a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.28; Fri, 14 Jul
 2023 21:35:43 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6588.028; Fri, 14 Jul 2023
 21:35:43 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v10 33/33] scsi: Add kunit tests for scsi_check_passthrough
Date:   Fri, 14 Jul 2023 16:34:19 -0500
Message-Id: <20230714213419.95492-34-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230714213419.95492-1-michael.christie@oracle.com>
References: <20230714213419.95492-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR06CA0028.namprd06.prod.outlook.com
 (2603:10b6:5:120::41) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM6PR10MB4377:EE_
X-MS-Office365-Filtering-Correlation-Id: a0d8ed0a-0346-4564-cfd3-08db84b23763
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H3KcD2L4z9Vue5r3ECz/Koczp8A0ph7R2Jmq0zIuVgsdyDXNgG02iULsyhvTkcGTZtDIHKry3O+90yg6LyXI4E6bYqp2kRqU7g7AZ8GUqEZ7tWgoDNNSwXZUZAWSNI5eXKoFqS1nRjHGcU/z/gBJwN2Dqc5ZvSw1y4uioAluu37N+Cf3Lit4TuFj/MHnGtqagWFYJfr2QLhjEooV6nUnQgSD+6Fvubw1D/zrUTB+8mPmGSmQYHpopqV7nknwGdHn9uktW2dkWnp986yXpnoM4L0UYvT81xuUEemaGy8wer9ROH8n+O6EAGFUb8LeXI/aIaZHxxzZnemXoHVrl/mV44eaua1EVSRhcy67s2LPjEN416M35AOgCmhMJOfc33YjpMbdshcfWwwKKVyBcv0UFuyW3tWDkzxr+Cc0jwQGzTMurlRb/0k6JoPBTVotSB46mdeBW9qALaYCrGx/rAnjLqD8i+X5QJXhOL4BJpSlHBMpyMTlE+v1nnbosrd/Yiqr/pa5dLD8EHcZtk8RcI7Ngf2B/R4tl8YEUmWoPiguJF+iOKZPreAFtDfCC/KjL3T9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(366004)(39860400002)(396003)(376002)(451199021)(8676002)(5660300002)(8936002)(316002)(41300700001)(4326008)(2906002)(478600001)(6666004)(6512007)(6486002)(107886003)(26005)(6506007)(1076003)(186003)(66946007)(66556008)(66476007)(83380400001)(2616005)(38100700002)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Lem0TNOB8tdKSMldsa8mWl7UG6gW4N0bgIDUgszAzARdmUWYp7yrem2q1umT?=
 =?us-ascii?Q?VAJ5Bo72rTFGRavHRL3cj2bgdUeB1iGlGhM0thOjoWpjt/ZMyMNXhoTy+oz7?=
 =?us-ascii?Q?pHmksx3AZRp+wmtzqcGigHYRV1n/VZSm0F7EI/9xf5RCHaDJjDdR6P6kxWqT?=
 =?us-ascii?Q?Cg5JqLEYxSs6u+V4CbDyfdVnVp4zTj2dOd4GtUmLDccz5hoT+1JeOUcDDVr+?=
 =?us-ascii?Q?fkKZig/mdGxqry4fzG5sgreZBaYvnyBYq6PnKRM2cil0m6h5GZxCH1a1hN0I?=
 =?us-ascii?Q?zhVsmvdKpYAskUX7Pkcd0ATPYTlDFutoQAGsfvd3SkazVlbpdPtilObcPVBn?=
 =?us-ascii?Q?cur1LVJ9b3bmE6DIwuEthGfv/zo+KsfCnhN5E4ZZCSGBJKu9ojgJMHY+eeOG?=
 =?us-ascii?Q?0z73VKT0ThpMEDNWHnG1KnY90fT6rtH5ft3hWp5GjizzBm2GMVkATiOEXM0V?=
 =?us-ascii?Q?3G02wwxdCnsBftVEMgYTfzVaF5ez8+W89a7fPgAb/D8sb39i4Zlm8tjiP8g3?=
 =?us-ascii?Q?/XowD0UnfACN1lyQf9ooZozv0arC28mt8KYn5iPVultZ+/b2uowptDhRsnBq?=
 =?us-ascii?Q?MlqJjkuKRGwaYld38hGvrKFnC2OKTy3fmtK1uNDYs0EklcMScoWwhjX990v5?=
 =?us-ascii?Q?mVEF6AgPGeahKUlStRnLXxXAMeNvk1/ZvLpq+dvTSeaP044xXfkWmTP2aHhN?=
 =?us-ascii?Q?Ds18eG4AzvPi9du7TElwQjq6HzpZbgfKiZJZZ7TeY2bLeJOoMQbfzdYWI3PT?=
 =?us-ascii?Q?Pufpz10uGX30Ew1dUCOxOwh3A63koOn6GWHvqmb6fVCHRzKUd51RRWh7ZcrK?=
 =?us-ascii?Q?/XYVsZaa8Uw50B/ljEhIM3AAm4Yz73hht6aI2fhxfH0LrOcgqt4EBJ0SEQxC?=
 =?us-ascii?Q?ZdWx6gnsG5dkXhQnZR/O+wVVPcDAkxZswOnGUy0PVh91uTHem5UXKAtaDTQZ?=
 =?us-ascii?Q?wxvcgtH9Sh4emqnhTaZbvz8RaPiHiXPSRowuHY7aiW7fiLlKvn9MTCM/vW5l?=
 =?us-ascii?Q?+OkGoKpWTjwr7suuPAjAF5OqGA57wJAF/SJYfD3Y8aEsrhc39laWRah9VUxH?=
 =?us-ascii?Q?lbpdXUqMD0Por1kslobi2rCOe1ArleuxCaht+by6OqK9N+Y1S7jMuGwcjnb+?=
 =?us-ascii?Q?fiFpfXY7oc03ss2gR26Fu1XlmhuMHwNY3h7dVQz3VKi6QiBtJppvQ6y0qNSR?=
 =?us-ascii?Q?GPmQCjn1fDYFI4C6V+7Mx94q3PFLql4sD9Zvc6ISrbZX1f7GQjb+/pNjTXe0?=
 =?us-ascii?Q?yPMbxd3Rw7jieXxQ7mqCPS/XdnkQOf/ab9zuVYWREDFFqxKQ9j7LTjP44AZq?=
 =?us-ascii?Q?EWrQVxLDY9dAcgIwk4KkPYCcivZcijI1p3QNXkH78dXD52syaIoVPBC49ihZ?=
 =?us-ascii?Q?omjtASvSIuh67JOoxpyzTEhhJw+SrfQ4il6PD2rMSRVL7a8G3nT6H7ce4fBg?=
 =?us-ascii?Q?tPOtdtMd4cTg6lUCDQ3xPEEna4rlMd10LJNQI97m3OFwpTbD1two+EoMMirW?=
 =?us-ascii?Q?2jyHeKUVpvFVlO3qYfsx64192GKBMqehsvS0HT/UQOw/e5CwdZjb5LgDXlQg?=
 =?us-ascii?Q?RMuBTjKvsfqqxrJkK9k6QHasF0n8gqVfM20aERF9k7WevqE+y6je3MYTdies?=
 =?us-ascii?Q?1g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: tMZqU2w3CHdpWUAJEfeI7qRAua/NsPf3xWopTaLfVo36KKacVGfnWOA2Kt+Y2b8prJxYhMp1EMZf9FkJaka+KBEAxy7MJEH7zwzMZ82kaoH1aZ5kyyZEDvoa4EFws35NzSdDkXD/UYbdOWY+OiSGHujUSPMj4/Y8HKnUnukCtCN1VugiIkZpDyK2Qo4RUtVGiP0z7t1JCjXRjcqMVVhZIkOE5WAKvKUps+Pay18KRQdexkTHkR8dDYIT4Bbn032b4rrjYNFEt9BbmepRmHLb0QXid3BSVXLuy4Y1SaYsWP97/ArbOCwKxIuf57sF2yIzU8jqCBgwQV2IzmtJxPt7ekQ0Ul4g2YsQelE4hFvZBWjEgZ6UoUz0CcYNbt1dwMy0cuLyUIAGFS/Af666DRz1pVBlAMBAsDY2p8FCgdq/zBEJreQA5iuQZWSDmTihfON7M9MTgNEvqxGXwSxHpsfyUecfrGwwSI4+09m530GU83VwbpL2EmGTplq7QbjrJ4PzRsIWW50IBygP95IEmXQXpUk+dK5I9VwyFvKxrdkLMjFiDGnJ6q5gH8zdIvHA3G1cDjspdZjVrueqbec/Zn6T4rS1ZRCgDzNxI5k1CbMbfuNNxpeXXIMQCzFCZVNFOVdAIjwEYtgyjeH4S/4df/m17AVaoVMT5gfEswrqc1hiokAq2YGpjQUm63v2gIKt52FcoqorAL3NVar8r/kVwAPrtq3fVNG3/cY6ABCE0nBmmshwyVHVj86CvnzFxSlTG6n1AUiS50oEckdd2MRrmBNZoq2GRr0mE0/suYM8Q6tw+GuhwAqWM8Cet1EeXzGA8xkGXkmFkpIPL+Mevfq68YY0Kj1w+jXqyBwV9ORjbMzwTUp1teuyN2e4hp+yFCsuWXLN
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0d8ed0a-0346-4564-cfd3-08db84b23763
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2023 21:35:17.2654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j7cvE8gXdhaYG7ZoiKmKQSfzEYnL47kanEkuUVoYwv5q+NRhmgWRmCDwxuxMypcNHfoIRA0d70a9WpQsw039evH1Nf/kjUCqTuIpUlEZ1zc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4377
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-14_10,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 phishscore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307140198
X-Proofpoint-GUID: qvTmuQaJc_L_WQ4oYCQ7_MTxr5kbvrCR
X-Proofpoint-ORIG-GUID: qvTmuQaJc_L_WQ4oYCQ7_MTxr5kbvrCR
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add some kunit tests for scsi_check_passthrough so we can easily make sure
we are hitting the cases it's difficult to replicate in hardware or even
scsi_debug.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/Kconfig           |   9 ++
 drivers/scsi/scsi_error.c      |   4 +
 drivers/scsi/scsi_error_test.c | 170 +++++++++++++++++++++++++++++++++
 3 files changed, 183 insertions(+)
 create mode 100644 drivers/scsi/scsi_error_test.c

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 4962ce989113..be9b6eb2fba2 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -67,6 +67,15 @@ config SCSI_PROC_FS
 
 	  If unsure say Y.
 
+config SCSI_KUNIT_TEST
+	tristate "KUnit tests for SCSI Mid Layer" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  Run SCSI Mid Layer's KUnit tests.
+
+	  If unsure say N.
+
 comment "SCSI support type (disk, tape, CD-ROM)"
 	depends on SCSI
 
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index d2fb28212880..f12ab199a03f 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2663,3 +2663,7 @@ bool scsi_get_sense_info_fld(const u8 *sense_buffer, int sb_len,
 	}
 }
 EXPORT_SYMBOL(scsi_get_sense_info_fld);
+
+#ifdef CONFIG_SCSI_KUNIT_TEST
+#include "scsi_error_test.c"
+#endif
diff --git a/drivers/scsi/scsi_error_test.c b/drivers/scsi/scsi_error_test.c
new file mode 100644
index 000000000000..c01201ad8702
--- /dev/null
+++ b/drivers/scsi/scsi_error_test.c
@@ -0,0 +1,170 @@
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
+		{}
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
+		{}
+	};
+	struct scsi_failure any_status_failures[] = {
+		{
+			.result = SCMD_FAILURE_STAT_ANY,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+		},
+		{}
+	};
+	struct scsi_failure any_sense_failures[] = {
+		{
+			.result = SCMD_FAILURE_SENSE_ANY,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+		},
+		{}
+	};
+	struct scsi_failure any_failures[] = {
+		{
+			.result = SCMD_FAILURE_RESULT_ANY,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+		},
+		{}
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
+	scsi_reset_failures(multiple_sense_failures);
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
+	{}
+};
+
+static struct kunit_suite scsi_test_error_suite = {
+	.name = "scsi_error",
+	.test_cases = scsi_test_error_cases,
+};
+
+kunit_test_suite(scsi_test_error_suite);
-- 
2.34.1

