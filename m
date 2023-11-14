Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 963DCC4167B
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Nov 2023 01:38:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231765AbjKNBie (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Nov 2023 20:38:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231872AbjKNBib (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Nov 2023 20:38:31 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA6FDD43
        for <linux-scsi@vger.kernel.org>; Mon, 13 Nov 2023 17:38:19 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3ADNt3W4010777;
        Tue, 14 Nov 2023 01:38:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=lkE6YB03vn58d7F5yu/BNH6O2p7Ojudh70E71un5AWA=;
 b=0p5Rr6b9P4pGIA62ey0mjz7kCFc2tFPV08TY/Y3u8ieKVsh5oqcOZfUqacSyVQCNKrBv
 tVkVXGCcFjV3DmvKc0m21gSkLmSJJhpK2RYcdAl/7rPn9n3Opm3XfLaegd+luHF02CSl
 nanMSQx1tNsxTkS2i8tJplk8xevbWmcTMO0cqo4P9pBaBQcGeTNazYqPg2x1hADWAVKu
 jHSp8cYhLRQCn/rTR5+jvInrnTAPTqj7Z4LwWM7Ldf72vqz6K6qMpiJxoaZdwVqDS+1v
 gM5wRIIQjAZyI4HnJeymlmyAdoSPGAA/LaFIy+IA8QXA8pjoAwE6IFxbgaJX3P+4Y7JW pA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ua2qjm56d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Nov 2023 01:38:09 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AE13Y5M022706;
        Tue, 14 Nov 2023 01:38:08 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2041.outbound.protection.outlook.com [104.47.56.41])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3uaxpxgwq8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Nov 2023 01:38:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CbImbR0m3O0yOwklE3Io4cqoLuYn7eCuTj55c9BY9nGUpU2vxEZV3u1ODOfNnA6jSMSc5BE6+/WKA3EQn+XUpgKdWk4n3x/Z75g4WXMWOFAYZiafAP0GGQBo+EE16KgHVdhk+k74ro70zNO3SlMnSXPWDHJjOQ3+TXD7ugBqcd22l/JJiDj5Wg/kkxJzDb6O2tZLyBn9dKFfRs01GrAARD0VWfIC2wvuUxj07XHYiKpm718W1mI/ttiCCCAfyZoEfQyHsdi8vOiu8NdMZr5faPUgz4D6gMXOlKwOBTdEnQ4sGayBGG732eVSPUE5Oc8NOUWv1TNIOYsmqlmKO3jEcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lkE6YB03vn58d7F5yu/BNH6O2p7Ojudh70E71un5AWA=;
 b=T4zOWMiTcS5FT28FgtIbJEF9ovPILmU0d+0HxkBPmkn7ANzcaAclHKOvtGkxfRZkWRVwP4QTe4YXVrIa9a7woLTW2aQHTXmwW5oh4UtHNKuQBZ5zYNUQVxNPHjQcGpT9uvunrp9cyPTvqmujCqGCpZyQjOWdr0gudgPeedKucQGC9iJB1ENncbDkkbecP0lVhF2+YfG6uhklcBd9De2ZNhhWvMeWaksE6DtNFrfDRgxnofsNgxzBDzU/yhhQMGv6+sWEgk9in1pgXpZkBk7PYe2PHULjiRDoGpsN518LjjvVUoxw8G88cxP3mRVJkU+UXEyvbsXUcOvucjODZGNb4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lkE6YB03vn58d7F5yu/BNH6O2p7Ojudh70E71un5AWA=;
 b=mbR0aN5fhJKhrFDfNlP3wnZWbYchvjfMEbkesD+TpUwJwTyFtIxghuw3JcewEW3S/uAhLRpxJgrYKeQpSkSVXokcNScFObWA+NumxujnFJWVw0g/L6aaU3HLYu2m3MsYpHlFIyLeLBT4b0xZRMNZa1QRHVALpkoJkPXlx/UNDBs=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH2PR10MB4199.namprd10.prod.outlook.com (2603:10b6:610:7f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31; Tue, 14 Nov
 2023 01:38:06 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e%4]) with mapi id 15.20.6977.029; Tue, 14 Nov 2023
 01:38:06 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, john.g.garry@oracle.com, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v12 11/20] scsi: ch: Remove unit_attention
Date:   Mon, 13 Nov 2023 19:37:41 -0600
Message-Id: <20231114013750.76609-12-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231114013750.76609-1-michael.christie@oracle.com>
References: <20231114013750.76609-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR06CA0102.namprd06.prod.outlook.com
 (2603:10b6:5:336::35) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH2PR10MB4199:EE_
X-MS-Office365-Filtering-Correlation-Id: 41822e7d-d2aa-4063-ff7c-08dbe4b259e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PKaGrM4gieQvrkwxcsg5nNklmztfxy7fU2f3+lu77kUdELxQxu7/siwq/OfomzroPTVKpNDg1BWsl8r8O/pcPFz+qiMCJQ6yxzu0FIV9TO+E6SnHEk7fEhHEzrjh6lrV1XJPXRw9H3++Z63DzM4PS9K7fE/l+p/QVeM8hprCp7I2lu21Y+/84noC/uvCUg+8WKgv7uuD7cSKGuvbPNaF3a2YZ2oSbt+TPU9a03FSv6QawxPq9nyL1vAPcWB8OXsKXWWKgfQ+u/SpzzCEh0Ab+s4dJymrpz5jAwBs3i1X1sIxRkz15Nbr/WVxxV8ln0KywfoEdvFBU1p8Zd5R0mlKBGJTvjzAFCZkalvDckxcHn+koyVevLxcDrqsUABbqYrd6+tjRKx+jJgqPB7dh15LCvbyAUhuNzUnyXX8o9m3b+xmBlyYkHyYOeEQLLgQX3mJncMcFmv5lo1SyDSWzb+74jwAauImsiQY+lxlYNGdt6KImbgoiJrBrn5EwFWDFNMKuL/abvcQJdeOmRPmw+Uy4KYh1O8IV8sYAGkOJctxEhDwk33K2jxhZJSCT6MXOwPpRADPnOKmgtg2xu/YCSd/4gsJL3Ouk7L03/DF9n676dQOegDazus/Us7zq6SDpF/4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(136003)(366004)(396003)(230273577357003)(230922051799003)(230173577357003)(451199024)(64100799003)(1800799009)(186009)(83380400001)(107886003)(1076003)(2616005)(26005)(2906002)(4744005)(38100700002)(36756003)(86362001)(41300700001)(6666004)(8676002)(8936002)(4326008)(6486002)(478600001)(6506007)(66476007)(66946007)(66556008)(316002)(5660300002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2GG//dZcs4RLjIkTPbzR/DW9kwj5kbKr7DbgDFtsmdV4IUG7LML6cBFLOIg+?=
 =?us-ascii?Q?T+kMfQ7UC05y/9NppZWEvfQBqBswytUNfm6Zg3SwmKoVLJrHJKpqDjCgDUOu?=
 =?us-ascii?Q?HQcZNQMJwdrilquC5NNE4dIp0fDGVkAly0wnuXiVqF8cik+BRSJQVuEOlYgt?=
 =?us-ascii?Q?4ZzmAqe1mMs/fjtQzWEKg54apzBzJcNl72id7flfrPZEa6fykh0XAOQCEnVM?=
 =?us-ascii?Q?cs4UZXtC2Me9iWkUflaTynE6lxNuCIVC+18OJ2P0C3U6jRs8BHTGS1/qSO88?=
 =?us-ascii?Q?l5PGNo0bIwQpEGY1OMXgPb1Zq+bq4+mlpVKrB6Zfc44rFrKhsUu/a+XcvHhP?=
 =?us-ascii?Q?CoWWSDyg0A/8dOc6PEUK1/ts0pfYcRPeX70LEG1jd25CR5PyfOPJVwpRStVu?=
 =?us-ascii?Q?CuiYoJ+/IgolN6zEfja8MGA17ef8KJhuSWwPbrAkHtGxLjavpfWrmFIaRl+k?=
 =?us-ascii?Q?ulepttM2R8FiQfX3wn3uOG+Rxi8PxDtVplAeQAUSGlgrIB61dbWjCXfgZA9x?=
 =?us-ascii?Q?TTBVsNm8Rvz4gsc43SBCGr1AsyxvxfkYtq4Y6u1Ia5FG5xX9WvhBAy1P5YNg?=
 =?us-ascii?Q?KhVCznvtSfR4ttR16kabHwDVmGW0L+ZKZMjM9/IeT2HLhPizfYOI1TC3p3Cu?=
 =?us-ascii?Q?iNpY2PF7tvGBy7cIWHiHFW3IBHp0A0YpP9nW6jUo4p3tkxhYM3t6pp52IN1F?=
 =?us-ascii?Q?z4h/52ejDMts+BEWhfXBhdhwXs6pfwX+YM63DbXVf+NReiPEJZRR8+YAAtbb?=
 =?us-ascii?Q?iju6YiWFHNH815KsSfxq2TQQg+fSP8glFAc9PwjSuUTUNzx6lkTf8geWgmUu?=
 =?us-ascii?Q?/kLGHzWxPSp6aBgsbuVHOdEsfEZElXIW03BiLzShSXNeAz0VZNMz5K/J2ptX?=
 =?us-ascii?Q?PM6tpxmqsJ8nzxQmT5/SS3/w+LLOC4nF7mBTTOc89BZ9pAMcnP26xN16vrgH?=
 =?us-ascii?Q?nOTK5UE+ihGrW28qUt2Vs118T0kB0qNrsQfEI8nLjuzlGCbEW2Hp27wQauan?=
 =?us-ascii?Q?iwo6X+qzs4WMWsODIG2KX8gAppJLx0rS3nZnbtb0pOCVJ4PFHkenWbi9sbYq?=
 =?us-ascii?Q?4i/mvRWmqjrmLUzNu0f/B5VZW4fFj5HvnkLhtL0rYAqP0i9m4eMpPPx1hBEN?=
 =?us-ascii?Q?rJobgz9esXaty2XfDyN5BFepZyR6clZor7iMGpz6ltL2UD+xQbgUw3uH0Cdj?=
 =?us-ascii?Q?65GLch4GUMhxNGM6oiL34hXAIQxPnc9zy6oj//yRoovBeZd8CvmrQiYfiGQ5?=
 =?us-ascii?Q?mUAaWRbIfcfFMzyuQ2YNx36z7eFoXC37TrrQGtDWYUQ0Y4f0BFc08MFMDvjO?=
 =?us-ascii?Q?IKcCek4/mA27q9UejRWWRPO5myQ98EA6dCEN08vIqocxIM4Dzrhcvru/J0uW?=
 =?us-ascii?Q?k0QuuIt2xPK1YwmbAOHOa97TP77CLjX87T9n1494c0td0JgSeGWThd/A7Sp3?=
 =?us-ascii?Q?f3bD4LWL5JpfQOnd/LzsbPMK5zVhKOmMw+X4ZbiJmr5GMxvlfhxDgtQ6aKu8?=
 =?us-ascii?Q?xM8rUrbj5J7wY5pFuqIO869wrJ6O/kGMwzabr1UdMUt/r5nf85yRvJWEc67e?=
 =?us-ascii?Q?9iaylqmo4i9HRSP2fA6Tx6d9nzW/56D506+W9/AcGDi45Nuja3DPIdXO3QGi?=
 =?us-ascii?Q?PQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Zp0s9WS0rZ5BnIBrIhj6KiDaUSPBbbHnOOj5pVe7AFUO5uzCsaXapduDXkzXGbvpTCKZ6V0ZmWR+sMR7W6r/L/hZEGcsO4jEwZWfPx/PfyXqernTQCG9M8qGdf2GvyLo1pxWyrRJtby8gwA98kckOMLfBZdZY1J1iGgIqTEaJw7xxI2kPipQoiiy5s6v90fE5BJRASBnsdMQFZJ6Fc3AMabTsyXM552DXQm+qaTIsQNokM5HR2iTki/9TIv5DY2gC+XLzMIJuE4QyLiS59F/MX/a7LkDZS9wn/EDB5ZMR7atDJ82iOdOmes4b63/gFI4SxR7E1cmOKPsvR5o1AXiEE+qPDHmNRZx/KvJTFXgZdAJClzUznA/tKOBQpZFV5k9K8J4xR1RvAiqIzAsUj2x/eZtTaa2+YWOtY04G2F3wgjvBOXkuoN5FAPq+aSDC9JAO96VDLlUesixRpIBb3NDi5UrCa3dj+Y9LQlK8ROjQSJZL9LRhWJMAlQeibfx1csjXJwFWJkAbqhX3dCtLlL/9irM8mYUCYMbGX2sew0UFffMRq1ABDJmKOQ7dzzma9Jg1mku1ReN03DlCLa+6z/InICadwcEqqUtUXPeP8LfKNpkKNrErvqOMirYTzEGcBvLtZuf6lolttrhNECyMr8NUCxfzXWojNPaPTfgnJ/hYM4pReYdbP2s+65L29/VwaCMzCY67y2al5RUHV2GEWDWFWvXfLPmMJwSct6NrSshO17Hk5dwXbIrsrQvHoN0HdSqjPUvSVG9qwdG5SIz8G1irOkPuACnta1cmp3W/nKLEsUg+5t0mlhqTF+Jj2/R69Iqq+wWZOb8LrGZyeMHxB989RojHj1XmU9/xiodDtuGsXiQaArrSk4sqThLWRDWgIBl
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41822e7d-d2aa-4063-ff7c-08dbe4b259e6
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2023 01:38:06.7352
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YdpdPw0cyCEwgShRzqagSUmr/kFBjA1tW8p/naKI9fwwnjCXk0BYFbciiOqL8dZM2DU9EXT6HsZSkXJnp11+Z8Q0jX9fTeEkM745hbKwR3c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4199
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-14_01,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311060000
 definitions=main-2311140010
X-Proofpoint-GUID: SrGdY63lhRQW1EWdy2XcXk43hRDtSdDz
X-Proofpoint-ORIG-GUID: SrGdY63lhRQW1EWdy2XcXk43hRDtSdDz
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

unit_attention is not used so remove it.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/ch.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index cb0a399be1cc..1a998e45978e 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -113,7 +113,6 @@ typedef struct {
 	struct scsi_device  **dt;        /* ptrs to data transfer elements */
 	u_int               firsts[CH_TYPES];
 	u_int               counts[CH_TYPES];
-	u_int               unit_attention;
 	u_int		    voltags;
 	struct mutex	    lock;
 } scsi_changer;
@@ -208,7 +207,6 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
 
 		switch(sshdr.sense_key) {
 		case UNIT_ATTENTION:
-			ch->unit_attention = 1;
 			if (retries++ < 3)
 				goto retry;
 			break;
-- 
2.34.1

