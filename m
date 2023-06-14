Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96093EB64D9
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jun 2023 07:19:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243368AbjFNHTX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 03:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243366AbjFNHSk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 03:18:40 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75A33270B
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 00:18:11 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35E6jvG7029013;
        Wed, 14 Jun 2023 07:17:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=2CB8hum7t3sTubQzZkQU76j7vLJLjfe5nmS5Gq42ugM=;
 b=hJAfqIX3nroHtdIh0TppQ7D+tzSfLpcQunJNIqdnsQwsgaeMN7j7nN1LZ6jeB2KBarJz
 nMQ3ituwCwWf1zXhwhhb+UmRx9/gHzkKzd7PDzQ3D0yGZQs59YJV1ens5MUAZnPj4Ub7
 zFBDMHk6BFGgnRcNlvypS/dvqb+QeD5oxFUDhHKfSC9tqE6cn2kJ2To1Vz/MoH3hV+w1
 Nz/0eFi//GJdFNFh8tzA5ZYn9bs27a1WljsK8Bgmpo40XTeErAnNFm7PAmUdqaPJkzwX
 7V7L127fVd97aWlK98146T9vallYuaYV0d82sU0a8Nf78tYAXjotk21+KhWQRMKgnFoR UQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4gstxt8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:17:43 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35E5Oogi017727;
        Wed, 14 Jun 2023 07:17:42 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm4ws8x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:17:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XpAplxnUoFI7eor+VXxuymEWrClLJ1Lvi5HkTLXTYFCVRy2SoXQUWFIvbxZktNBuDT+YCgZy0A5nNu8OqcC5HJPHfP3F823G1jzdahjsf6HoofCufU8R+6VGaXRHz21JuVW/rEpliW7IUUtqp+5tINyK5qscw6oUJk/Me4lekHkT+vxmDii+soxlmg7f8aGmVTAo9QL6fwgvLhAk+RL6OVHCo259/Q2M/ldASt1QTBrsbwFioQmvcx9ddqcwi1tCpFXUsxU08+Z0y4LFJGQgB1AtVohVdvIkiFHbqmalW6EQ7zh4CB0ZLPeJS/PadARU5sIikDyvXssRWyETjxsO/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2CB8hum7t3sTubQzZkQU76j7vLJLjfe5nmS5Gq42ugM=;
 b=JU9OEXvtBim43zMsGV2bBMnNmIww7NRF89JKaKV65tApctI6xSlthwrAoz5+GM53DW2sFlJg6AkdTtjUduKjXr4U1Eoq5SvW6VQEQ6mudXnhYW+fSVuJLTDzC3CbkyZMDzsd1IJxjfJ+alyuJZ68rpFL8fyj+UZxQ4xYXTLfwsY6Y+4HPgHUUNjzsLAnDVXEjCkFwC1CbQQp2zjAIEp2w1iDYLYeD0n4vfEW0wge1c2PbmRiudVEYCezUOXyc61VgAaRNKxjNxB5cJvGT86pRBTohBwiSxBmjVcRIyC5wGGXVki0yw9A7d9m5ELlST/JwplQIgo0v1iLomzkWkpirg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2CB8hum7t3sTubQzZkQU76j7vLJLjfe5nmS5Gq42ugM=;
 b=PqGpEPBSuejLDUAGiMVa9E1v+EGDTz2cTzlHc7ZmfPezCSSc48wprXyKElL8ducJh7cAJVEGRpA4ymgH5sgawG0qkBt2CurD0LcxaLJjSz1Ea2eMq347BQ7N0wUcvjl+7m1fSnKVWsEQK9wrV90HIAVcIPHLxZLR4lFdNAgb5D4=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SN7PR10MB7030.namprd10.prod.outlook.com (2603:10b6:806:349::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Wed, 14 Jun
 2023 07:17:40 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559%5]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 07:17:40 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v8 10/33] scsi: Have scsi-ml retry sd_spinup_disk errors
Date:   Wed, 14 Jun 2023 02:16:56 -0500
Message-Id: <20230614071719.6372-11-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230614071719.6372-1-michael.christie@oracle.com>
References: <20230614071719.6372-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS0PR17CA0009.namprd17.prod.outlook.com
 (2603:10b6:8:191::9) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SN7PR10MB7030:EE_
X-MS-Office365-Filtering-Correlation-Id: 806ebdc1-81be-4a2a-98c5-08db6ca77051
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5mcjnciKhIWQc6UQB0rBO9Smb+NLikrH7ITweHSYnd/UFvCABuergRDKQA6Oj5d9yivcbzJ/D04XymXbzS1q/A2peAVbzi0Zx8h1pKGpZVLqZkY/6AIQ2pw/EiXxjsTVIuIK6jr+INjlH5oCYSeaE3x9+wv+I8iLO/cs4lcx1/liDibddBPbz1wn62CmZXJBsMs8dy9nRsxh55+RXlss5Ave5iWvYzM9hRBLpnl7/Y2IKk/E87SbyTDpsjdq1ocjyvJlv2lJx/ssF7goTHorfdpVOzkCWyJgjoDWz8fRjaMgrGqNTI6Lxm6WDpHy9hhaWQ/mBYOmAfZYb1qMlr3Cekjb9VuDUTwwD+tQVn6PoST53Z8fw44EiYxR4Sq9SkBB4ygH5b7Myk/9Dzp90bdfLzfE6ify72Qdk30PT+9U+tST5/t11eQ32nXxnEvhcF8kIk2EP/8sx4fJK54OhBOqc1J6T0jCvLvrpTaZ9grI/kcEjDYX7ul/pzBTCJMvPTpNQH7FHn7stmWE5OZSae+7oGXEUXJ7z7W9lgpfshJwvHmma59Y+JA0Zq9JGzDQwu6w
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(366004)(376002)(396003)(346002)(451199021)(66946007)(66476007)(66556008)(478600001)(5660300002)(8936002)(6666004)(4326008)(8676002)(36756003)(41300700001)(6486002)(316002)(38100700002)(107886003)(26005)(186003)(6512007)(1076003)(6506007)(2616005)(2906002)(83380400001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0VIszC+WUa8uWgc8uzjxpnZU+6cwPz38u6TANi/JZPL0aJDZD76/fvQeWQ+Z?=
 =?us-ascii?Q?EAfiQxZJ5ywNYuXl18FpdGGhvaNXo61y3j4dc8yvEwy2atkhbeo7SXSjSmOq?=
 =?us-ascii?Q?ObEruzzy8ckvKC+bX+Rbj94uEgp7vXjaVtln4BfxQV1glpCaDGnxFuKfCpOU?=
 =?us-ascii?Q?iZLVc2z1b3ZDzXDw/wFUANZf2CT84s1IndEi1hSXGXw/VwEwTUKZwla+wd3T?=
 =?us-ascii?Q?Wxn2uYiFdsZxEJrV1RoXj6ewn3FmrcjCbVoCuWoG7o0swk05aqlDbWiCeyTY?=
 =?us-ascii?Q?VtWTlK2x8SLsZSBCP9xciujDTdrFH2kRyGgQaU69WG25BVJclGEc+mS4W2ml?=
 =?us-ascii?Q?PAVHWwoOMB5ksUeynLo5fPZ7aBX7FWD5EVGozWTMU9TzANVRK6oSvmfIViMI?=
 =?us-ascii?Q?9AcV4lQTtS9qIklp0QlKksRy8LlM/0jsQVoxptnubaSQgwhRrkrRU6xdx6rO?=
 =?us-ascii?Q?JWv8WBtU2tqmEkiYncov7SoY3Pj/grNMfzHro9SAapk6B0iIEHh40axAMOw7?=
 =?us-ascii?Q?8tvkE4h3cUl9WOZevP6D5lPbUW6Kq9xxTGBKN+0Ng6TRfuvKNV3j7HgHB1TI?=
 =?us-ascii?Q?ZjQZIAGOkxoIUrMvxaSf0mPZ9frX78QacXANUdwfpfNn4BsGJVgdxRjvFVyS?=
 =?us-ascii?Q?mTbEkwO+LxmYxz20tbFjzJY0a5MU+GMBkmtGHNp2KRmwaXOMXaOOUzOfHxiE?=
 =?us-ascii?Q?v/WOlXfPWSU8J7OsBGGpV0fRqCby/O6BEvVoPBqm1OOHWxex3rRJ4xPV5sW5?=
 =?us-ascii?Q?9SLIGjfUUzacYvh2M6kLUdj5npeaz1E2v8UC/Sc46SK9ptjm99c529kbwRJb?=
 =?us-ascii?Q?0IWIkUIdbukl/TWinNgyEYBqOE2h11YXeseJhDRUmwiWH8nlDIhUV36XPGbv?=
 =?us-ascii?Q?rQgf0iTWXmjWzXddzw7tSD6r8TW8AFCerU8n6pf9ljmHw5tRSxTfkrQ/OdO8?=
 =?us-ascii?Q?N4uGgXsAsQPQowEGKKV/wj9sSijAkPrV6Qb1/+m2LoxD5afd9JwIxa1Vw75e?=
 =?us-ascii?Q?qizqaLBniGEd/JU8oh/7qUvirZU9dwdtIuARYIalsGURRAQGrPpT1fSOg1Fd?=
 =?us-ascii?Q?f+DX5HG1FooAmStU3+ZA/uYuAKW0C0eTJt5MJdwNScLIHbGoMg+mNslsfZLD?=
 =?us-ascii?Q?yz3TSG3KZZ/jT24BmIKAypHpSE97qvcnpPQ/Rt+uOJ+pVnbTT1/0Q/NTmDXy?=
 =?us-ascii?Q?TWSwvlI9Ns+FJ+K3n77U4J7b5V60vsA+yuI7YEyZRJCTFCF5xCivges+Cjhz?=
 =?us-ascii?Q?dcKKI8nqI9YVHYTMFFqQhMA8xlmyqwfXNUNtIRXUpnQhjnWJeQ4NmiABZemj?=
 =?us-ascii?Q?dIOUrXpyQzVzqkP2nZ+cB/+BxrT9NUMpql7Uifcm7BCDSd7QIrnVqRq3hl+h?=
 =?us-ascii?Q?AMCYY9SK6mkDYiyICBYlLx3C5EzK2BvVfEAMGz5arIBvpfS0U1CuicExan74?=
 =?us-ascii?Q?tmBljoiV1hyomjkhJ0gLTqdCY07zIkRvmN7wNQTiHsnYHbeucTrhVKSS6oiT?=
 =?us-ascii?Q?S0ZHsFzx9yEG5S3TCERC8rS2GLWs9sYI/tcdI93wCp4QTYJl57MR2J8JQ+H7?=
 =?us-ascii?Q?YNh+w7fAkwBEHQoTxnWBvmHM6w2CwKBLdA7t+X1DY5azpiVbHzDpwO1Q5ley?=
 =?us-ascii?Q?/Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 074WPhc2Y7HBTEIUFQloWbkzgQ0Uzsp5gwe7q5Td89jFFKlX6h/t67767EHxu/COaNakZ7z6ZhzYsxsJs4k7ekV3+jLMgxSqHdHjjXVT7wEDjm2Gy2pkt5C21gjeSUrE339W0EyK3mANdS3jzuUjykuWsO+Vm8EbiqCBn5irk0iNzW0BhY5VXzn5YN9fAvrCVgCZChjSyQrdYTvKgYv5mh8SG/POGdmXPmTdY2Uwfasr+OWO0Ix8KssvuuLT0AiX4nxcFiHf3scpSuO7uS0BWRkB7Gmna65v+Rq5OLftWowanOU9Qwmv0PHua/DzghePlUhKXOlCwrv3GCxS7q3CjBPW9dWVz2UABCJu3Q7+b/PYMEKuJsk+gkxfy6AgZbR34OeBPHLxk39udwUM13q8btXO5UOb6mwKMSIQHjiCExmxjHjs9eBroxQSRmmljRANqiW3EZ2K6T1LfdYj4+cSUkKhXyOIWcfZuVLcpWiw+TBUcB+pXq/IRVBLU0FkjXAX6cUyjinoI4SyRBnDA5ISWa8M+fyVEWIehrEvWPcmMwQail0h9a7+ZakLR7ZKjxXG6IjiDejl+pxzAKW6JA7MBR9dT6QInsv5dJSb3SrbvjBvRC9yCWZnGdQFaW1fm/Yejw25YiCBV1h3uvTSUVb/Xc91uBzEZ5qevjyhy0ydMH5jfDyl66uLGNyqLmYNVm1ApN9BZJGn6QKo8wiSZouWGgJK60wXXA5o82PDzl0DlwBqbYatH3L4MFqYye22VmVsq3QWM/DklL0KxoAvFXVWhrtzg3ScKPWFTfnQjTijX9iEOtCE3lQJ/Uu+6vT2oYYA/OUqLYXX0wt/+sD+QZO8KKQIinUJSzevbsdc2stIG0bveU+2etH49qxvmsEMdxGV
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 806ebdc1-81be-4a2a-98c5-08db6ca77051
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 07:17:40.3855
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tvUwvxA1UGUaB3VwnSGSglG31Vj8WBB0kO4q0l43njDbyh7wPKfZrczPOvFQaWYnbQoj+QHpp1La9wAqwl5+8TONmrZPcOoqV1SvvrCJTj4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7030
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_04,2023-06-12_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306140062
X-Proofpoint-GUID: 5k3R6Vsp5HCVEaqy_Wg2qYfxFJEwMtnN
X-Proofpoint-ORIG-GUID: 5k3R6Vsp5HCVEaqy_Wg2qYfxFJEwMtnN
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This simplifies sd_spinup_disk so scsi-ml retries errors for it. Note that
we retried specifically on a UA and also if scsi_status_is_good returned
failed which would happen for all check conditions. In this patch we use
SCMD_FAILURE_STAT_ANY which will trigger for the same conditions as
when scsi_status_is_good returns false. This will cover all CCs including
UAs so there is no explicit failures arrary entry for UAs.

We do not handle the outside loop's retries because we want to sleep
between tries and we don't support that yet.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c | 73 ++++++++++++++++++++++++++---------------------
 1 file changed, 41 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index e34cc9daddce..e67a3d163b24 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2191,55 +2191,64 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 static void
 sd_spinup_disk(struct scsi_disk *sdkp)
 {
-	unsigned char cmd[10];
+	static const u8 cmd[10] = { TEST_UNIT_READY };
 	unsigned long spintime_expire = 0;
-	int retries, spintime;
+	int spintime, sense_valid = 0;
 	unsigned int the_result;
 	struct scsi_sense_hdr sshdr;
+	struct scsi_failure failures[] = {
+		/* Fail immediately for Medium Not Present */
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x3A,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = NOT_READY,
+			.asc = 0x3A,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.result = SCMD_FAILURE_STAT_ANY,
+			.allowed = 3,
+		},
+		{},
+	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.failures = failures,
 	};
-	int sense_valid = 0;
 
 	spintime = 0;
 
 	/* Spin up drives, as required.  Only do this at boot time */
 	/* Spinup needs to be done for module loads too. */
 	do {
-		retries = 0;
-
-		do {
-			bool media_was_present = sdkp->media_present;
+		bool media_was_present = sdkp->media_present;
 
-			cmd[0] = TEST_UNIT_READY;
-			memset((void *) &cmd[1], 0, 9);
+		scsi_reset_failures(failures);
 
-			the_result = scsi_execute_cmd(sdkp->device, cmd,
-						      REQ_OP_DRV_IN, NULL, 0,
-						      SD_TIMEOUT,
-						      sdkp->max_retries,
-						      &exec_args);
+		the_result = scsi_execute_cmd(sdkp->device, cmd, REQ_OP_DRV_IN,
+					      NULL, 0, SD_TIMEOUT,
+					      sdkp->max_retries, &exec_args);
 
-			if (the_result > 0) {
-				/*
-				 * If the drive has indicated to us that it
-				 * doesn't have any media in it, don't bother
-				 * with any more polling.
-				 */
-				if (media_not_present(sdkp, &sshdr)) {
-					if (media_was_present)
-						sd_printk(KERN_NOTICE, sdkp,
-							  "Media removed, stopped polling\n");
-					return;
-				}
 
-				sense_valid = scsi_sense_valid(&sshdr);
+		if (the_result > 0) {
+			/*
+			 * If the drive has indicated to us that it doesn't
+			 * have any media in it, don't bother with any more
+			 * polling.
+			 */
+			if (media_not_present(sdkp, &sshdr)) {
+				if (media_was_present)
+					sd_printk(KERN_NOTICE, sdkp,
+						  "Media removed, stopped polling\n");
+				return;
 			}
-			retries++;
-		} while (retries < 3 &&
-			 (!scsi_status_is_good(the_result) ||
-			  (scsi_status_is_check_condition(the_result) &&
-			  sense_valid && sshdr.sense_key == UNIT_ATTENTION)));
+			sense_valid = scsi_sense_valid(&sshdr);
+		}
 
 		if (!scsi_status_is_check_condition(the_result)) {
 			/* no sense, TUR either succeeded or failed
-- 
2.25.1

