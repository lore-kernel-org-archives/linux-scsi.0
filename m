Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C989EC4167B
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Nov 2023 01:39:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbjKNBjg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Nov 2023 20:39:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231660AbjKNBjd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Nov 2023 20:39:33 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5498ED5E
        for <linux-scsi@vger.kernel.org>; Mon, 13 Nov 2023 17:39:29 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3ADNs8Q9008766;
        Tue, 14 Nov 2023 01:38:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=xKvVcmTmjFya5UcY+GG1md3A1G7SZ0ZQ6Yk1++9ltzQ=;
 b=kg6Q/6ik5X1H+krDffodRlthgJBnkI3AEaRpxLzxqqR/h4SCJSXjvnlf9s3/9dvOVRgE
 0nh8jI5fyy3qZPp2drP87jopx1i8Zrg/klzF7n+XhLm7NdhD2f669FOB2Y6N1bHf5TVZ
 gagp3txIwCH5+3TgSeiX2BgeQrzQn4QY6bIHSgKuosGzJUCHfuzExgPpRtiIT1cb5RR0
 M/ZI/ZCZ1w0QKRgD8aN7rQ4LhPIa2iskSLuVP+W7CR/swd+nhfbAzAejMx2UJ26vpD5d
 HAyZDGmD2b/q5p1W5f/nTemrQGtGSKFs9T7n25uG6B6/YEWUNjsvL6nGkHczwdYppZ2f Yg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ua2mdm7ae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Nov 2023 01:38:21 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AE1HCnJ013256;
        Tue, 14 Nov 2023 01:38:20 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2040.outbound.protection.outlook.com [104.47.51.40])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3uaxj193x7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Nov 2023 01:38:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YpXXxACEvfEzfKm3uZ8WCATn/NOwLwm1DH0XaHyhEpezqjOmnv9/JYOJdAj96CMWiO8wJAPgLq6vg9puOHOvR+wEX7ORFtsa8OZBNRSussj6j6d0yodnr0g9Sz2vJ1rqkq0+YSLLEqOGcvxmLrjXaU+5xH1VZ9jaY+7BIUeYLAj08EtccV+cTZ98aVr/Np7WjFxLjfkg2K676B1IdgYYWyTSYgGQ8kpN8t2oDkbd5TVFeusGaqCZrL0FZzi7+rBaSwYZLuE3G38SEXzfry1W82hLR+g9yARGLDoe7wb5ie69XFOUbmjEYmf4UEpGTilCsr3I7gY6AVSqQ3HojelvMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xKvVcmTmjFya5UcY+GG1md3A1G7SZ0ZQ6Yk1++9ltzQ=;
 b=MtzEu/UIHB7ekykez7tW1WQ4ywfuYsF38pPFEGUb3oxMqy9VO6svZRJwgXmdCFiZF8Y3bFB1mLvewd27hR7r1/BYjXk96YEivoceeyyi/jnSarUJ3h51goMTxjnCyMDTRyEJ4TkwABqsx2Rs5WLJyymreqmvOzyqJyy1UbnbskBUg6LXNfuzE3kXFup+Rr4AeynW4GveTvmyxKG4MElq9DTy+tFMDetJM30oTZuVZq3klZW0y+fjcUYaQKL9WCsGZcHbOjTqt9BbYBqz+EdU51722uYESlyHYSu/cKakVGoC47nmoTbA+Xim4PvfG53qJ38H03nlYb/TO+6yz0/jGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xKvVcmTmjFya5UcY+GG1md3A1G7SZ0ZQ6Yk1++9ltzQ=;
 b=Wrn9z48F+1WxwP7vIHqLQSuesPpGrYdMebS9ZmL89aoYEYeJrTirftyzT0xQXvS29VenKg10DGbjBjX44ttjtPln5LAXX4EtqB2Bq8slpVbbcysAajsz0tBv7sVWx4UOry9nzCNd35PVzMh3PCh7ihI9IiuQmtO/e8mao9CaK10=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH2PR10MB4199.namprd10.prod.outlook.com (2603:10b6:610:7f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31; Tue, 14 Nov
 2023 01:38:18 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e%4]) with mapi id 15.20.6977.029; Tue, 14 Nov 2023
 01:38:18 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, john.g.garry@oracle.com, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v12 20/20] scsi: Add kunit tests for scsi_check_passthrough
Date:   Mon, 13 Nov 2023 19:37:50 -0600
Message-Id: <20231114013750.76609-21-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231114013750.76609-1-michael.christie@oracle.com>
References: <20231114013750.76609-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR07CA0054.namprd07.prod.outlook.com
 (2603:10b6:4:ad::19) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH2PR10MB4199:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a5174e6-d973-48a2-574a-08dbe4b26121
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nd/8QlW0MsSG9H+qGi4pOKD0JOfb/vWYt5vEy5C3PpLjlMrThwRjh72GuVsJBn5caZL5vrWwRUbtfiaeZZkrrt4921zBjL+ywKfVRZIjW8FA9ieAy3wR7xYPg8Ae/4zDquHX4+jNR5+ViaQf75lMdgqkPDXFQpK1ZgUB7tzAhLMsy/0V2z9xBQDgHkC/jWnL36+pNVegHEkp4TgDI0wTgBU6bgQkYsUQfgNyPhqcrwoYOb4CNfUL/vS65HHMNxeRzcxz8iBdEJ5hybtQFA0vKHmrkWQ5dpqWY2hWs4Y30r5gsESuwD+Ublb/Xz5PVkMDUeJ/g8wgErB0Uzp4k49480AD5VN/XrsTvxFTRiLqSI9cswn+Pg7UpsqPwscKX4gqU2/TZVQOD93ocQ/OW3JfQy7J4jq25HK0oLU4aTKxkEatqmHH+40hG+2ZGUle9bqcIuJpuiiK6fA4FgAoU4sNsbfWGsQ2XT8x/hOu1L9gBmu4cv5ByinFvETEHYN+Fl25MzxzCejF8SrDjnMwJIjjc8dzREUuMrhjh7LKWK6klj6XWKdOCq9xM9D1FLVa4zBe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(136003)(366004)(396003)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(83380400001)(107886003)(1076003)(2616005)(26005)(30864003)(2906002)(38100700002)(36756003)(86362001)(41300700001)(6666004)(8676002)(8936002)(4326008)(6486002)(478600001)(6506007)(66476007)(66946007)(66556008)(316002)(5660300002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KvdDm7Hj7yvux4p5q48YTBni4jrN2WSaNJEmFZtyXF5vS+9euAd5Cxb9zR3A?=
 =?us-ascii?Q?O413IWizgKtzLQllQZKlMSfWPWiLrjRTg1LH/EWm9QtpObR6mn4DnALGWkpW?=
 =?us-ascii?Q?zQR2l88l+My+7uY8PAs3JLBlqhe59fZeGNzwl455XZeO4lpzma5QAS86ITlY?=
 =?us-ascii?Q?Bfin/Aujy/pqQN/ii2LxmNQOyvyLgjts0IHInp3TxrK8Ytv2gm0N6QnwW0/z?=
 =?us-ascii?Q?25bjw1YLlnTGThXST7sL67vz1waBWAkVSawLJp4MLa05WqavVcl6hBLwFnri?=
 =?us-ascii?Q?EL7Bzk/03+XFy0+VwWJEy2GdKLMaNz5OkqyK4JikeapiocOvLwl+vyqQhgD5?=
 =?us-ascii?Q?BArjoHyhm5TjQXTnCguAg1LAsRUfT61k5I7mz18N1U6yNKwfG5GN/Ky1LJYs?=
 =?us-ascii?Q?+8Fz7dDPd08wywzUkNs8j7dGRDeb9ln90LAyHEXhHvzYrgisG37CVSPTrC1n?=
 =?us-ascii?Q?srFyEEAhZjC75BfKnTFMpYoI7I1Tk4t91oF9xezSXMgQjNyIPBnYFkfUvhBx?=
 =?us-ascii?Q?ua9FcAtIJ80DkxFtReLRWlEC3ytLm+4cW2mT5LIjrVCl/T+1XgfB3kskykCG?=
 =?us-ascii?Q?1kPz+rFX0rAxFIFdr2L07r6Jx4g1NpEQ5IaYAMKDtHsppwTnj/zH683rkDA+?=
 =?us-ascii?Q?CnFwPPfFYUbbnFdI/AZmvEALu6p4uzn9FMXb2LBLKl3judQpkDRlKH740BC+?=
 =?us-ascii?Q?aC3RqocfCqrKdlMPYiPEMvI6AjvAiBNQRi/ymIBH3Jbzl+Ec7EqhgHfn9hqo?=
 =?us-ascii?Q?KumdPWzjHqjEYwc0p9MBfwYXGC989yoobkFXQqfmd/jEBPdqyTncZwg4LaRp?=
 =?us-ascii?Q?C/zkN+VMRQnWrSn6qz/UtcBeqhzIT3e90p0CgsfWb4uJ3WXL/U8b/qDH77Cl?=
 =?us-ascii?Q?gVbmwXyZJKm/Jfwm/v0o1Ae47fPkQEb6MaWbNRbmVOn24dk2B4FNTRVJRw96?=
 =?us-ascii?Q?RCU4xAFAI5zqu1d0V105qDsjmjiIKvQDK/Vg8nhECWlBIz91GLn2N6C5/U4q?=
 =?us-ascii?Q?w+AdHPNZRDqc63G1BAswAI/uFVX1l/9IUkCtikQq9nppEKiGtA55IjQocwI7?=
 =?us-ascii?Q?LOqiO/6lHL8/4jhEOX/GYw1+Em27CjriAYyrEBYIBIgsUWujvjoSnDSLrawB?=
 =?us-ascii?Q?wci3mcKRHX3fnq4VEJAwxB84XeS0E/qm4fTLu4MJrK3M+xcfpDxAZ/jkKpmj?=
 =?us-ascii?Q?QEIAqg3AvPiWSGC2xeuSG7dzAF3rNVUHnHQODS6R98tDlBZJqRzpaG23NThm?=
 =?us-ascii?Q?MKj3mfR7ZiZZn3yZ+DgufAyQomKEf9sWZ7y7GiNGSja+tEiBFbUz/oOljm56?=
 =?us-ascii?Q?WMM4Vfb/V5vCvzrHJAaSM2Q7ax2Um5P5UOJOJUftvYeb+Whn97pe+EJrm0X/?=
 =?us-ascii?Q?FtVArD3ANtiYu+E+zZ08HL3gC2Bpc/U3FP+4GQ++CDlHoVkMcszSlH2SqLEr?=
 =?us-ascii?Q?MNWsYUL89iOjKMzso4dPX0+2iOUqwahImyler9gA2UyIur5RMpJQOcnB+RpB?=
 =?us-ascii?Q?KtzWX7l6krEwUWst3eVmkoMNR92MsqglDw7MM3+eNn0IidR9mF6TI8gbap2r?=
 =?us-ascii?Q?AjdQeP85koaF2A6f5bmFajRqVmBDWi7/4dB33vo3lwg1ZOANq4VhnbwpwT+D?=
 =?us-ascii?Q?bA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: d0gEwUm16M3cEKw8LMFD5htUpz0lVeSBOlDFLp3CHVP8IKQ5Dfs8m4vONlHUHl34pl5UTTaVZeqLxJikDhSQl35wKJ9fgDltoCAoWeRZLwSN2Hfp13jOIvIupDZwxpRYhyWBInd9SjhiakrXB/wx+j/1LunGiCYGU8kPKt6hEi1A64GCmdtXC7oOCdog9Nh9ZxH5cN5uF56MsEP3AAbBKOYIUTfnsGM1rECRUaxn1LYER5DXd710O5dwMLLy6lv7E2PG0Vww7YadEvQdtEnavcKlOhpJZxGFU7xFQ63zqnawyGjPI72tHAgosJbXKMS5NNtC8frlYJ0hZhWseOkpuNLSZHcV/63A4DY8jgMlNVwNToo+sEL5oR0qwLu9hr1AQZdOMESadvRivgy9xgrrC5YaxBwRig0OA8DJXJVx6VLDG7S+Sq3qNbyA9R0qIosWn8xBDJPnC1wThO7wnvYbE/eejUjnC6SeQ57KyaZ0qMq77kM3OZ5DVgeygRxymTA7iY4FLgGhKql63Rw/MOpcISBVI/4S7XPrfdwFOrqvTR+cePqtpl9EAHZoshCSy/5vsoy2NaBsDvLSCsOAZ5Cronyp3+ZHRVXUZigELU6yAWEniGP5AhBfDtc/FFKVjjylAuKkPudTzh7F9NGN5STzzAjUiQZPlt5HV3bRQJLFeoOw3jNhm+typ6eKmTLrV+t3xCV2qpH+Vn0BAGvgBnb5uo/NAd3DfBDMWfBU4HzHch7imHrpXJE49cA2+GgoYkHGKbfJqbaQR+zPmZfuYykbdYw4hE3KewULHNj4xtB8TRCm5TlysVJUq7ArC0NBSN1V2BadYKAAPAtOyWSS6xzqjD2xmitOiuiGZDBemTX0ijz9LYLlvGng/9GC9z5Efc6O
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a5174e6-d973-48a2-574a-08dbe4b26121
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2023 01:38:18.9009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s9OayhbqKIq58v19Jni2ORi4VFpY991wgh2sAw0L08O+hmKBgtcW8p8ucVRb43g+3o/PW7DmXQF4vEXI1BuAbEN1TsgBuEWG05baklhG77Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4199
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-14_01,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 phishscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311140010
X-Proofpoint-GUID: lb6jM6qjGfrLHbYCgRtTc36dVsA_tRSS
X-Proofpoint-ORIG-GUID: lb6jM6qjGfrLHbYCgRtTc36dVsA_tRSS
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add some kunit tests for scsi_check_passthrough so we can easily make sure
we are hitting the cases it's difficult to replicate in hardware or even
scsi_debug.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/Kconfig         |   9 +
 drivers/scsi/scsi_lib.c      |   4 +
 drivers/scsi/scsi_lib_test.c | 330 +++++++++++++++++++++++++++++++++++
 3 files changed, 343 insertions(+)
 create mode 100644 drivers/scsi/scsi_lib_test.c

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index addac7fbe37b..e4ecf6491c41 100644
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
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 69c79725a1cb..b3b3ed8d435b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -3434,3 +3434,7 @@ void scsi_build_sense(struct scsi_cmnd *scmd, int desc, u8 key, u8 asc, u8 ascq)
 	scmd->result = SAM_STAT_CHECK_CONDITION;
 }
 EXPORT_SYMBOL_GPL(scsi_build_sense);
+
+#ifdef CONFIG_SCSI_KUNIT_TEST
+#include "scsi_lib_test.c"
+#endif
diff --git a/drivers/scsi/scsi_lib_test.c b/drivers/scsi/scsi_lib_test.c
new file mode 100644
index 000000000000..b4f7576edf2c
--- /dev/null
+++ b/drivers/scsi/scsi_lib_test.c
@@ -0,0 +1,330 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KUnit tests for scsi_lib.c.
+ *
+ * Copyright (C) 2023, Oracle Corporation
+ */
+#include <kunit/test.h>
+
+#include <scsi/scsi_proto.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+
+#define SCSI_LIB_TEST_MAX_ALLOWED 3
+#define SCSI_LIB_TEST_TOTAL_MAX_ALLOWED 5
+
+static void scsi_lib_test_multiple_sense(struct kunit *test)
+{
+	struct scsi_failure multiple_sense_failure_defs[] = {
+		{
+			.sense = DATA_PROTECT,
+			.asc = 0x1,
+			.ascq = 0x1,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x11,
+			.ascq = 0x0,
+			.allowed = SCSI_LIB_TEST_MAX_ALLOWED,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = NOT_READY,
+			.asc = 0x11,
+			.ascq = 0x22,
+			.allowed = SCSI_LIB_TEST_MAX_ALLOWED,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = ABORTED_COMMAND,
+			.asc = 0x11,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SCSI_LIB_TEST_MAX_ALLOWED,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = HARDWARE_ERROR,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.allowed = SCSI_LIB_TEST_MAX_ALLOWED,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = ILLEGAL_REQUEST,
+			.asc = 0x91,
+			.ascq = 0x36,
+			.allowed = SCSI_LIB_TEST_MAX_ALLOWED,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{}
+	};
+	struct scsi_failures failures = {
+		.failure_definitions = multiple_sense_failure_defs,
+	};
+	u8 sense[SCSI_SENSE_BUFFERSIZE] = {};
+	struct scsi_cmnd sc = {
+		.sense_buffer = sense,
+	};
+	int i;
+
+	/* Match end of array */
+	scsi_build_sense(&sc, 0, ILLEGAL_REQUEST, 0x91, 0x36);
+	KUNIT_EXPECT_EQ(test, -EAGAIN, scsi_check_passthrough(&sc, &failures));
+	/* Basic match in array */
+	scsi_build_sense(&sc, 0, UNIT_ATTENTION, 0x11, 0x0);
+	KUNIT_EXPECT_EQ(test, -EAGAIN, scsi_check_passthrough(&sc, &failures));
+	/* No matching sense entry */
+	scsi_build_sense(&sc, 0, MISCOMPARE, 0x11, 0x11);
+	KUNIT_EXPECT_EQ(test, 0, scsi_check_passthrough(&sc, &failures));
+	/* Match using SCMD_FAILURE_ASCQ_ANY */
+	scsi_build_sense(&sc, 0, ABORTED_COMMAND, 0x11, 0x22);
+	KUNIT_EXPECT_EQ(test, -EAGAIN, scsi_check_passthrough(&sc, &failures));
+	/* Fail to match */
+	scsi_build_sense(&sc, 0, ABORTED_COMMAND, 0x22, 0x22);
+	KUNIT_EXPECT_EQ(test, 0, scsi_check_passthrough(&sc, &failures));
+	/* Match using SCMD_FAILURE_ASC_ANY */
+	scsi_build_sense(&sc, 0, HARDWARE_ERROR, 0x11, 0x22);
+	KUNIT_EXPECT_EQ(test, -EAGAIN, scsi_check_passthrough(&sc, &failures));
+	/* No matching status entry */
+	sc.result = SAM_STAT_RESERVATION_CONFLICT;
+	KUNIT_EXPECT_EQ(test, 0, scsi_check_passthrough(&sc, &failures));
+
+	/* Test hitting allowed limit */
+	scsi_build_sense(&sc, 0, NOT_READY, 0x11, 0x22);
+	for (i = 0; i < SCSI_LIB_TEST_MAX_ALLOWED; i++)
+		KUNIT_EXPECT_EQ(test, -EAGAIN, scsi_check_passthrough(&sc,
+				&failures));
+	KUNIT_EXPECT_EQ(test, 0, scsi_check_passthrough(&sc, &failures));
+
+	/* reset retries so we can retest */
+	failures.failure_definitions = multiple_sense_failure_defs;
+	scsi_reset_failures(&failures);
+
+	/* Test no retries allowed */
+	scsi_build_sense(&sc, 0, DATA_PROTECT, 0x1, 0x1);
+	KUNIT_EXPECT_EQ(test, 0, scsi_check_passthrough(&sc, &failures));
+}
+
+static void scsi_lib_test_any_sense(struct kunit *test)
+{
+	struct scsi_failure any_sense_failure_defs[] = {
+		{
+			.result = SCMD_FAILURE_SENSE_ANY,
+			.allowed = SCSI_LIB_TEST_MAX_ALLOWED,
+		},
+		{}
+	};
+	struct scsi_failures failures = {
+		.failure_definitions = any_sense_failure_defs,
+	};
+	u8 sense[SCSI_SENSE_BUFFERSIZE] = {};
+	struct scsi_cmnd sc = {
+		.sense_buffer = sense,
+	};
+
+	/* Match using SCMD_FAILURE_SENSE_ANY */
+	failures.failure_definitions = any_sense_failure_defs;
+	scsi_build_sense(&sc, 0, MEDIUM_ERROR, 0x11, 0x22);
+	KUNIT_EXPECT_EQ(test, -EAGAIN, scsi_check_passthrough(&sc, &failures));
+}
+
+static void scsi_lib_test_host(struct kunit *test)
+{
+	struct scsi_failure retryable_host_failure_defs[] = {
+		{
+			.result = DID_TRANSPORT_DISRUPTED << 16,
+			.allowed = SCSI_LIB_TEST_MAX_ALLOWED,
+		},
+		{
+			.result = DID_TIME_OUT << 16,
+			.allowed = SCSI_LIB_TEST_MAX_ALLOWED,
+		},
+		{}
+	};
+	struct scsi_failures failures = {
+		.failure_definitions = retryable_host_failure_defs,
+	};
+	u8 sense[SCSI_SENSE_BUFFERSIZE] = {};
+	struct scsi_cmnd sc = {
+		.sense_buffer = sense,
+	};
+
+	/* No matching host byte entry */
+	failures.failure_definitions = retryable_host_failure_defs;
+	sc.result = DID_NO_CONNECT << 16;
+	KUNIT_EXPECT_EQ(test, 0, scsi_check_passthrough(&sc, &failures));
+	/* Matching host byte entry */
+	sc.result = DID_TIME_OUT << 16;
+	KUNIT_EXPECT_EQ(test, -EAGAIN, scsi_check_passthrough(&sc, &failures));
+}
+
+static void scsi_lib_test_any_failure(struct kunit *test)
+{
+	struct scsi_failure any_failure_defs[] = {
+		{
+			.result = SCMD_FAILURE_RESULT_ANY,
+			.allowed = SCSI_LIB_TEST_MAX_ALLOWED,
+		},
+		{}
+	};
+	struct scsi_failures failures = {
+		.failure_definitions = any_failure_defs,
+	};
+	u8 sense[SCSI_SENSE_BUFFERSIZE] = {};
+	struct scsi_cmnd sc = {
+		.sense_buffer = sense,
+	};
+
+	/* Match SCMD_FAILURE_RESULT_ANY */
+	failures.failure_definitions = any_failure_defs;
+	sc.result = DID_TRANSPORT_FAILFAST << 16;
+	KUNIT_EXPECT_EQ(test, -EAGAIN, scsi_check_passthrough(&sc, &failures));
+}
+
+static void scsi_lib_test_any_status(struct kunit *test)
+{
+	struct scsi_failure any_status_failure_defs[] = {
+		{
+			.result = SCMD_FAILURE_STAT_ANY,
+			.allowed = SCSI_LIB_TEST_MAX_ALLOWED,
+		},
+		{}
+	};
+	struct scsi_failures failures = {
+		.failure_definitions = any_status_failure_defs,
+	};
+	u8 sense[SCSI_SENSE_BUFFERSIZE] = {};
+	struct scsi_cmnd sc = {
+		.sense_buffer = sense,
+	};
+
+	/* Test any status handling */
+	failures.failure_definitions = any_status_failure_defs;
+	sc.result = SAM_STAT_RESERVATION_CONFLICT;
+	KUNIT_EXPECT_EQ(test, -EAGAIN, scsi_check_passthrough(&sc, &failures));
+}
+
+static void scsi_lib_test_total_allowed(struct kunit *test)
+{
+	struct scsi_failure total_allowed_defs[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.result = SAM_STAT_CHECK_CONDITION,
+                },
+		/* Fail all CCs except the UA above */
+		{
+			.sense = SCMD_FAILURE_SENSE_ANY,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		/* Retry any other errors not listed above */
+		{
+			.result = SCMD_FAILURE_RESULT_ANY,
+		},
+		{}
+        };
+	struct scsi_failures failures = {
+		.failure_definitions = total_allowed_defs,
+	};
+	u8 sense[SCSI_SENSE_BUFFERSIZE] = {};
+	struct scsi_cmnd sc = {
+		.sense_buffer = sense,
+	};
+	int i;
+
+	/* Test total_allowed */
+	failures.failure_definitions = total_allowed_defs;
+	scsi_reset_failures(&failures);
+	failures.total_allowed = SCSI_LIB_TEST_TOTAL_MAX_ALLOWED;
+
+	scsi_build_sense(&sc, 0, UNIT_ATTENTION, 0x28, 0x0);
+	for (i = 0; i < SCSI_LIB_TEST_TOTAL_MAX_ALLOWED; i++)
+		/* Retry since we under the total_allowed limit */
+		KUNIT_EXPECT_EQ(test, -EAGAIN, scsi_check_passthrough(&sc,
+				&failures));
+	sc.result = DID_TIME_OUT << 16;
+	/* We have now hit the total_allowed limit so no more retries */
+	KUNIT_EXPECT_EQ(test, 0, scsi_check_passthrough(&sc, &failures));
+}
+
+static void scsi_lib_test_mixed_total(struct kunit *test)
+{
+	struct scsi_failure mixed_total_defs[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x28,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.allowed = 1,
+			.result = DID_TIME_OUT << 16,
+		},
+		{}
+	};
+	u8 sense[SCSI_SENSE_BUFFERSIZE] = {};
+	struct scsi_failures failures = {
+		.failure_definitions = mixed_total_defs,
+	};
+	struct scsi_cmnd sc = {
+		.sense_buffer = sense,
+	};
+	int i;
+
+	/*
+	 * Test total_allowed when there is a mix of per failure allowed
+	 * and total_allowed limits.
+	 */
+	failures.failure_definitions = mixed_total_defs;
+	scsi_reset_failures(&failures);
+	failures.total_allowed = SCSI_LIB_TEST_TOTAL_MAX_ALLOWED;
+
+	scsi_build_sense(&sc, 0, UNIT_ATTENTION, 0x28, 0x0);
+	for (i = 0; i < SCSI_LIB_TEST_TOTAL_MAX_ALLOWED; i++)
+		/* Retry since we under the total_allowed limit */
+		KUNIT_EXPECT_EQ(test, -EAGAIN, scsi_check_passthrough(&sc,
+				&failures));
+	/* Do not retry since we are now over total_allowed limit */
+	KUNIT_EXPECT_EQ(test, 0, scsi_check_passthrough(&sc, &failures));
+
+	scsi_reset_failures(&failures);
+	scsi_build_sense(&sc, 0, UNIT_ATTENTION, 0x28, 0x0);
+	for (i = 0; i < SCSI_LIB_TEST_TOTAL_MAX_ALLOWED; i++)
+		/* Retry since we under the total_allowed limit */
+		KUNIT_EXPECT_EQ(test, -EAGAIN, scsi_check_passthrough(&sc,
+				&failures));
+	sc.result = DID_TIME_OUT << 16;
+	/* Retry because this failure has a per failure limit */
+	KUNIT_EXPECT_EQ(test, -EAGAIN, scsi_check_passthrough(&sc, &failures));
+	scsi_build_sense(&sc, 0, UNIT_ATTENTION, 0x29, 0x0);
+	/* total_allowed is now hit so no more retries */
+	KUNIT_EXPECT_EQ(test, 0, scsi_check_passthrough(&sc, &failures));
+}
+
+static void scsi_lib_test_check_passthough(struct kunit *test)
+{
+	scsi_lib_test_multiple_sense(test);
+	scsi_lib_test_any_sense(test);
+	scsi_lib_test_host(test);
+	scsi_lib_test_any_failure(test);
+	scsi_lib_test_any_status(test);
+	scsi_lib_test_total_allowed(test);
+	scsi_lib_test_mixed_total(test);
+}
+
+static struct kunit_case scsi_lib_test_cases[] = {
+	KUNIT_CASE(scsi_lib_test_check_passthough),
+	{}
+};
+
+static struct kunit_suite scsi_lib_test_suite = {
+	.name = "scsi_lib",
+	.test_cases = scsi_lib_test_cases,
+};
+
+kunit_test_suite(scsi_lib_test_suite);
-- 
2.34.1

