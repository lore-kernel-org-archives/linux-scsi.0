Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6010C001DE
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Jul 2023 21:38:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbjGNViC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Jul 2023 17:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbjGNVh4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2023 17:37:56 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 838633586
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 14:37:53 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36EL3moN003889;
        Fri, 14 Jul 2023 21:34:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=i74eLM0gYYLfBKQ58eUwPhldoNfeqtnqzPMiKTZMjK4=;
 b=YusmBiQN720RyUltYX0dPsqHPLNWtKRt1nW5ts+4YVG54o/+uFg3fRVYxlFC1StsiWAM
 oAQnkVo0NYgmTcUxrIkyOwDqOp/tHe8AW3f+ScCxnzEzR54rUuPBGBlZrCJxy5Hq6NK8
 WAbA9cxHUg8TJNtI+uuSdm9AeUazMHSXofS4XrbmAstAIbc1/efZzF11QwNLd/m6rX0t
 xXDS2wzsP6o2COmUA6Cs6mvBonB2VwyVKZq7SgaV5RrYDhEn9annGSsIBZKUcaTxnMd3
 E8z2wsHXoINmJHAVje/uS0njDpg3e0QG4ecpUOZlOuRdc0zmsXGCSn1hdytZdxu4kvYM 6A== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rtpth2dw3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:34:46 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36EK45HL013796;
        Fri, 14 Jul 2023 21:34:45 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rtpvs91q4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:34:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i32akuYOVRzdZSXiLyYQMCfGL6WMa5MTNfWhKbnFioYFW4kiPtoSA1yrcB6NitobLid0dzvKhInJO6ZAE8xXB3vxgpZlP9OZZjd0MQpqT5utiRo0xvYdvPW32lKkfRpCQvj4wG8QEbW5jfv8HxeDm3rlMn3HKCXKjgxh3to7QM7I8lzsWs/jrpF5LyWf1x7JN6fBRzC7XCqPbEWN9FhPAuwdBwSQOw8QxLGgeCAXCNjjTVxLnA9bAg25MKAuT1T5mO7zhLHvmfBWYQlFdGp2u9MoUxJLVlSGXoXPprHDNRBHj12S72BonwhO58heVJ1hcY6q3HfWAji35st6d9VNZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i74eLM0gYYLfBKQ58eUwPhldoNfeqtnqzPMiKTZMjK4=;
 b=giFxbXJ8oOGouW6wH45O8kEJ4YIBWZJIXY5y5SKW8B/EIGLcKjk7vB3V1hD/RPKcSX9IUAreULw0q81Hui2ALg2UO8v9vcoHwpD8u6BEn2KnryXJiENLqca/Dt7nzV26dlei1qbT7LlDTHIaRDzu7NWWnp5hBPqikFfSHcsIz2IKZSgOJaFef+lJoOYdioddwKGB/YwySYXL9sOTAu8jzNvLCBkCckOzhq3wAdgiD94u3D60T9ljwHvOyV0PrF6u4aqRmuuqBbeKge2rSi3eEzmoXl4NEfSwZxIglU3Mkva+1trAmlBdR9yIRcWQsdfBraQOvfwAi5HSdS+KSI0t0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i74eLM0gYYLfBKQ58eUwPhldoNfeqtnqzPMiKTZMjK4=;
 b=Eo8OFcXzADynrOZOl9OnoCmh7rZpl15Ia0orq8s6cO9JYAt1IWswSBjJlsPTsnQaX9oyOpiV9vAY6g+aDd3TTFqxcAKdiWkC00t5i34ZhcMK+aUS/9oqwvp/eHFSPWEH2/IDnXrAQKX/hd/9NISQ0h+f/jnMSn+NEfStyYWxy8U=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM6PR10MB4377.namprd10.prod.outlook.com (2603:10b6:5:21a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.28; Fri, 14 Jul
 2023 21:34:41 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6588.028; Fri, 14 Jul 2023
 21:34:41 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v10 11/33] scsi: hp_sw: Only access sshdr if res > 0
Date:   Fri, 14 Jul 2023 16:33:57 -0500
Message-Id: <20230714213419.95492-12-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230714213419.95492-1-michael.christie@oracle.com>
References: <20230714213419.95492-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR06CA0097.namprd06.prod.outlook.com
 (2603:10b6:5:336::30) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM6PR10MB4377:EE_
X-MS-Office365-Filtering-Correlation-Id: 84e3842f-ed05-455e-8afe-08db84b221d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eXQHfimF/Xhn2WKhOv9m8xtC/fE059udBqIts+bguL8KkR6epsvNAGBE5yNIcwjuz5CH9VNUWHVJGHGCv/NbNg7Ew4JAw2sG9johLGqLccHlnQddrnK2lf9P18jdMZIL5+c3taXGRKNb2ZdAMe686Acum8E5p8lpNEA4+fn3efIhMDHcYGbrS5lxfgXFiRQBfZjAlviKgZco/9zDbuTJJh42qx9J0m+L42GGbt+XZ6YR6qSJ57nIQVEMjtxQC8/VoH4d8zVQgsmf7VguK+R6YAPjCl77R7UaJu/rQ4VoE1qoY9ZNSl74pBXwC1/uc1BDn2mxBV3yyw9hEL0PkY7ZVIc4r2/AP1ABumCPOQAL4qnKd6Vlq1d9+uRZaO4xqWrOW369wWetCP31GGytZIHd0KqAsSlC4pLdKY3IazsJWuP6wOqkYWEmAaM8CNeSK6W8is3t2YRx03IwAFrnQXareLXj5lOQLByw+kvxfIUEUiJHxKYkY7M7WdHZI27MhuUYK2mQzYpFS9zIDaid6zpQEeifnCfRfQRHjIxltjA0CeOU+6+S5f+K7XhSEH0me/zy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(366004)(39860400002)(396003)(376002)(451199021)(8676002)(5660300002)(8936002)(316002)(41300700001)(4326008)(2906002)(478600001)(6666004)(6512007)(6486002)(107886003)(26005)(6506007)(1076003)(186003)(66946007)(66556008)(66476007)(83380400001)(2616005)(38100700002)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mCtNcoMyM+E4uU8m0CCUcigfe6mrHE8CXtAmnWQH/JEjoO779DOkQ+b0fz/f?=
 =?us-ascii?Q?GoHqKHGGizUnVvbwe+dyMsMMJB/PE/rEQVva8tRkwZ28ULHEmoSO88opAry7?=
 =?us-ascii?Q?mqw7ptRMKCWIEQZTmJ87ohkVzomKdtcg0esnWm3vEMsPHFdYhzdiABpmce8H?=
 =?us-ascii?Q?UkOJPjFzqzh6By/6TFQkTNiq8Gz1Gy+w/NRjuvt4AgBAiT2g2FvjE3hM1XqS?=
 =?us-ascii?Q?rbwc/pUFC3v6ggCx3gRRzeuxNCf9PtENtlyD2xGciPKkrAKHa5jLPzHRVsz7?=
 =?us-ascii?Q?LIBtPZF6JeP9sdtG6nfjDs4iCYWIZGCt5n4kZ86ugJlL51pocPOV/zYRvMBr?=
 =?us-ascii?Q?L9+o07RpShIKvizpu1sIAcvN3E6s2gIJ8A3uj6h7LUh2T6jiYK7Ca0YxLju7?=
 =?us-ascii?Q?ab/1lHq+R9uoxlkAcNRVKC9HelqNAUHE90dK0wKxb/JO3KpQPevi9RyjxoTW?=
 =?us-ascii?Q?VbFlbY2c9ziqyWHymM1yroqLByec/4iZANf7W6ifTVwbChenoVXGeoi1PJc0?=
 =?us-ascii?Q?um81rQtPRCHG5g8ITozvgG5sjRyUdl3L6h7thq/aWElBzVLqqPVa4z0g3dkv?=
 =?us-ascii?Q?adjiUhg4PXDAsnTCJ+n3JCHBko2FNarY4oPw+fAy7eEunYY9+uAP1P0Qk4bS?=
 =?us-ascii?Q?Ge7jIsm0IyxzSqHV+oFyY6GCwURGz/mr6eLeb7rqnkzNv+RSbBT+8MqqzG9s?=
 =?us-ascii?Q?Q4FDR39QoOWcTliP8+7KP+Z4Ire3L/dTfYNUhcK2vrVXeAaJ19F0nhjnqeE9?=
 =?us-ascii?Q?zOkw/Qet2XrshwjhrNOhEq+KJXI36slTluIoPnZb8fcHVmeXa4OkI6U+t4Gg?=
 =?us-ascii?Q?P+V5i8P0QSwqfvM9O8QD5c53SR6SvsJK1D82YLnKrsjPr5ePV40l5UW2sxw+?=
 =?us-ascii?Q?X6OL1g/cz8IaxZmOXHTeX6bwAzbhscXKdtYc7L+IycBZnx/zO0PzHyh7OGo1?=
 =?us-ascii?Q?CiAokildq/ITf2i5n0OEVe0nie7U8MJ+2F5xUrHF2I1aJmw8TgfnV76tsgPV?=
 =?us-ascii?Q?PyBDlMDlLSkZRu32xsBVV8f2sUM+ggEaM3w1UxcoMvd6V7QuM7mGVKz4wxQX?=
 =?us-ascii?Q?9V+CRvecoDlOAajjfmbPbc6FB5zvE3UAkHthcqyYIef7YvVDHqgkGztfxoHI?=
 =?us-ascii?Q?CNu4WTxoRQt+gcMGaLd1JD5ijydw3ruKw81FBHxEgfxU9tAefbgboa2i3IHm?=
 =?us-ascii?Q?KQ5OpiGGBhQ433ZSr8hX3tNx3+qn4PZcQ6W0idT18SC0DOG+cK70EVBTugSq?=
 =?us-ascii?Q?HYBVFJli4q3bZ9IaTj5K5HLyHAlQg5cU4ndy1r8M/JvFu0WZB0azPepZfo2T?=
 =?us-ascii?Q?qwBFp3XkE2aySwUGnXY0Lt5Nlxq3WZrptui1dWR5GSh6ZA+urLiyiNReyM2S?=
 =?us-ascii?Q?eulrI59f19nidHg/OLEjFuqw/TH6yis/e4GFcNpbciv4+r6UbhMTeQbAmeFs?=
 =?us-ascii?Q?ajY2xLEZBstQljLGuQ1fyAEblrVxDr7tJnO92s/TgE8dTyHi/P7ogVW0SXqr?=
 =?us-ascii?Q?PivqSyNku0X/kzI77+T5/ULbFZ40nUFTwIxp4x0b0APPS2c7p7sLE1UquIVz?=
 =?us-ascii?Q?mbYA6+gI+wRgFNbhUpf2i8JmAtaO0z3ZPBLsCy5jNXFSgjXQqvEaTdhEnxEd?=
 =?us-ascii?Q?aw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: R+mJ1mXTIcAou3ua1wo7ThhjvW+H7eoqlIhYGrGQpYyQYqpvon6qF32EZzfszkMbC5uQA7GHZh7tGdN2KaOT9C4M6YQ2piYOVI5Ec3vO8UuqSYINNGfWoSLc0FR60zKduPqm5S/HuKdpcJ3sNWhmCA35OaqaNEvo471aoJQQvBLCvI6/BNFEacBIzfxkhQyrweyWORFyP58SUAeFlvbg86+bI6i1WHwH7jXZa2g+Ozx2mNygOAh+qg5tGPM+9ABlvIeNpJ3kZwgXarpSVLZ5qU2QtHBoJ6WznOQAQwjV2Wp4TqdkBlu+mnBVDpB/7CN++yIEJ9RQnsN4do7MHDoNdEVytkffmTIAlIM3aMVei6hmJep8SokOJFY+Ey+VdgT0fXbhXSE2DpSly/9JG4+diVQnNZM7nQ9tbGR87PG4UbrXeG8dpaOgaJ3O2oO1mlHY/PlO9G5Vdn66t1ML8dntX/enH1I/vxqyk+LLgMJ0RnMBXLUuHsj3Xn0CjKleYKNj6j7X558T5RZ4iATDZkH1/FvR9mkEPmbrT9mXqA+7eVLAeW8ZjNeLZHcUTalcUT6l5fzrEJ5VAOvNu43DiS0Fpu0We1wC1t6L5nhalD9d1t//JZ0pjWkMmau6eUS0bhYwoVRpxJjhPcRP2mmWLkVM5FUuzZ9GokEWoPYwi0LDwrW/eNAVEPrBXqEevHawbl2ylAF6R1+MbF5Dc37ZK2IDWtBfKtaQIRheKV4LtJ5DcgQUK5ojgE2PZ+do5JxyYFO4VcQJjLUKgQIDS5lk6kjRAPp3FbkIYyJiJONe49KgM/l0CqQJJD56oagT20uthJpbBPilys+J036YZ2+QABwIdRR5UFR9o1Fgc0i0Mhjmy9X7JcdUqK20Ih0DHY+viF5I
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84e3842f-ed05-455e-8afe-08db84b221d8
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2023 21:34:41.1400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dpgg57G8lQZQajP6XK+kRDgdYhMsa0WQH/H0jfvdvKHn4CGpR68wITrltEY5kOJlIJYsAaLquCseOPgk/Pt+YbAisqxG04PK8LYaMs//xP8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4377
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-14_10,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307140198
X-Proofpoint-GUID: ea2HnslWzEd8gH7iTL1j-iNvpe66jY9c
X-Proofpoint-ORIG-GUID: ea2HnslWzEd8gH7iTL1j-iNvpe66jY9c
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If scsi_execute_cmd returns < 0, it doesn't initialize the sshdr, so we
shouldn't access the sshdr. If it returns 0, then the cmd executed
successfully, so there is no need to check the sshdr. This has us access
the sshdr when get a return value > 0.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/device_handler/scsi_dh_hp_sw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 5f2f943d926c..785ab2c5391f 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -93,7 +93,7 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 	res = scsi_execute_cmd(sdev, cmd, opf, NULL, 0, HP_SW_TIMEOUT,
 			       HP_SW_RETRIES, &exec_args);
 	if (res) {
-		if (scsi_sense_valid(&sshdr))
+		if (res > 0 && scsi_sense_valid(&sshdr))
 			ret = tur_done(sdev, h, &sshdr);
 		else {
 			sdev_printk(KERN_WARNING, sdev,
@@ -134,7 +134,7 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 	res = scsi_execute_cmd(sdev, cmd, opf, NULL, 0, HP_SW_TIMEOUT,
 			       HP_SW_RETRIES, &exec_args);
 	if (res) {
-		if (!scsi_sense_valid(&sshdr)) {
+		if (res < 0 || !scsi_sense_valid(&sshdr)) {
 			sdev_printk(KERN_WARNING, sdev,
 				    "%s: sending start_stop_unit failed, "
 				    "no sense available\n", HP_SW_NAME);
-- 
2.34.1

