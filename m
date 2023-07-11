Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5B81EB64DC
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Jul 2023 21:47:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231669AbjGKVrj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Jul 2023 17:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231582AbjGKVrU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2023 17:47:20 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF78173C
        for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2023 14:47:17 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BICu0T015121;
        Tue, 11 Jul 2023 21:47:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=Ds52T6Jbh8rYeYhx4qBoVeLXGAn9pSepUMo3yJrjZR4=;
 b=neM4R/20vVlmPHT5WFYFpGASMkP3G5CBbUJYTQPkj4450eSVQ4sxK6HDFFkqWH+w9Pvu
 j6S4U4NsH+7fPdxb9fPCLXXzg3WVj9TAWkxePsD19OBpcudj0pdICh5YEgf4Oh1JwOVX
 AF9cs26sl5/uxQBh7X6gU9dJ2drO32kyvfnKszlRIaykfgqyvQ11SxPlF8WUSC5TizDR
 M0wYscQDL+IBRPbrRVjkTD3vRENgvrffA9wtD/49pVNfXuv9/+rr9bl2RWCWIrD3wnxy
 yfQ9O4SmxccdbbWUyQNobYqLonqFtNpY8823dUnwGtoJGhQTAlnbwrjo0e4UJvrJqmo3 bg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rrea2v0kj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:47:10 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36BJxGbG007247;
        Tue, 11 Jul 2023 21:47:10 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rpx85h1d7-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:47:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mQROv/6ztkiu3FKjMbKV7UPTGO6YPuTS4I9pKLpaMfXutmMdlrganI1/TfiNDoBc1T94NjRdcfp5zRVKI82/nJbtfPYwM32E/Z1hjYCo0QwGTxki6dC60LicRlbSBTmH9cuRNu7z5dvl9VEUAfF2RGklqEk/q3rHE8K+B5nfdlsT8t3owhHhVzrfq6NIDzaUlgaCU0ZSFC2z1LWrpLwpIwOrR3sTzFp+sjCMqgD4IKRi4fZ96ajOh4t8DC6QU+7h4tArw4dTH3qyZBHOE1SiTIEbnLfaQkXDvkn7i0Wx/EvV307mswR4FPsewghanCaVwDZga98ZXpA0NTuA0qk6Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ds52T6Jbh8rYeYhx4qBoVeLXGAn9pSepUMo3yJrjZR4=;
 b=InRYr6JNBCkFkZmdf8bYl+QFPeIHuejrFAoJTli7uLMIvGhTvYuFXtelbxM5F6jgf+ur+43ttGtdI1K2wH4GX1N201845/u+Gj9SFrnWRaqWAiAOT+7duQUeIb2ziLMhCZwsdPVp1G3wGrC4/MfD/x1gy/Ab4qE9jtnzhdjcONUZ38RvzG4/1SxoL0Yxh5k0v5eTG6CQcprE6UbcnzWbNjK5xzPnRuoRotlRJRprkZ5hEsM4n+hnL0gruxBUHoA4wM+gsHdVQiWx+VDjLun4WQ7ZwRiK4I8cjZRPl8ncT6jbVrrgvhywFxfBN2cuxiNsKeCHw9RT/66/7UQEVjNhDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ds52T6Jbh8rYeYhx4qBoVeLXGAn9pSepUMo3yJrjZR4=;
 b=MYzD7AhWewyqc8IIwAchgaWUwcHBQFYgoRQMfSByWejiLyJJNnG3qt0s29avcnS4gVA99jr6d9cDJQgbRMfiVk6MuSMQJ/g0wH1cqiz+57iKBS30iU5bkcT2V7vxwShAo7/3dCGczPGqIwtjPWvgCXau5EZukJi5ofn8tKA2P2I=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SA3PR10MB6950.namprd10.prod.outlook.com (2603:10b6:806:31d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.30; Tue, 11 Jul
 2023 21:47:04 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6565.028; Tue, 11 Jul 2023
 21:47:03 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v9 19/33] scsi: ch: Remove unit_attention
Date:   Tue, 11 Jul 2023 16:46:06 -0500
Message-Id: <20230711214620.87232-20-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230711214620.87232-1-michael.christie@oracle.com>
References: <20230711214620.87232-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR07CA0093.namprd07.prod.outlook.com
 (2603:10b6:5:337::26) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SA3PR10MB6950:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f14f69c-64de-405f-8419-08db82585d4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M09tSuET4ftukoQRAq4cAwZ+DDCSvlQxjC3N4ADx6A3N60RJzkr3cq3Fi0h0hOerv9hTncSGIFL+YnHEQGscuhM+IoJURDJZtvLyB8Vp7wp+QEgfdUng7srvCQgc3UlVta+g/j6Uzj6aQf7vqLTDF5D8p/afhyrZYLXhA01riMpxh6AR8x6ez2Om8EM10JWy7Nh/5qNF2RVVeT6pSK6JaD0UUwsbc85VSmK5LX3yPZEiRIwjQD0hNmIJ9lReNXbxcUefs+b/e2wBweJxbhLhnhIghvXSp4d7zHM0KmfCAGtFJ7sG+m0Znf7MVwYGnT6QUbSZ57PQ5Q33iuYzF5Zid53LMpREb1bhtqF/lC7TZh0ImRJNS3VIcAVKjAGTsjhiDa1O6Qjt8BneYDp/7Nvy8BzUylQfGX3HWJhgl8Z0Gg6pzXOypfuHElRTzNeHS3G7BBQdrAllaY6x6/AY3RwUQX97NswXSBrnSZHN6Du7gxu4wl3dDbMC3hq/e/jlB+4ZWW2jVyUlXvaLVTsg8GSUMPMM/z4xQK2j3zEah4Q6p7QLBqD0/MsR/BNBXJzyIdl6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(396003)(346002)(366004)(376002)(451199021)(186003)(6506007)(2616005)(6512007)(478600001)(26005)(1076003)(107886003)(83380400001)(4744005)(41300700001)(4326008)(5660300002)(66556008)(2906002)(316002)(8676002)(8936002)(66946007)(66476007)(6486002)(36756003)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qU/r8bx06+T6CPKJimc05zHg5/OYW3LtQIVIY+qnGHfmqVR3Xpsaawkz7Cg5?=
 =?us-ascii?Q?cmv3QFqaxNY9Gnbd/1RK8sstEF2yafQWCCYo6JJTeL15yYRfkXvjym8/zHKD?=
 =?us-ascii?Q?SJjOXbpMGoM1Hi0KGybz3kQpSefGC7cxGtO+sl+yDGw16RNKR8+Uas00D22f?=
 =?us-ascii?Q?ivp8atXS+UtAF/exnn9+AzZvoPpn0v2yZyey4o3I4CZ8jcg1JuNdgGrs2gNG?=
 =?us-ascii?Q?kIMIDIst+Dr6Otrl+rdb9MXs4CJ/Rexh0Uo3LAgmYPpaFjn0Ibd0jZ+exKgH?=
 =?us-ascii?Q?9SXKUoEOLCwV4B/aw1xbtgTL7o/ldc/JuvxvdQQXduyRjGn2HqwN1JAJEwwi?=
 =?us-ascii?Q?qhu8B9FH8uc3+P1XgDpmtbDsV+kyzd07ggRI6QzCj+MyL5EqvYMqzR+sChvD?=
 =?us-ascii?Q?bTJc6WkNi02mw1kbm3Y2ozxkBG07F/J4K8T0JxpeviMB/K5b4RTm8xA3YhnL?=
 =?us-ascii?Q?pj/aemqCbAX+JfBKSE5v+R6X75YpzhtVu2cze73LSAsmf0ONo/eW7J0rLMvc?=
 =?us-ascii?Q?Azqqdvwf5HtFiU+Yx2kDzYLm0iRuxyGF+J4JR6/0ny5hrvD2D7u8pfP64OQg?=
 =?us-ascii?Q?hIQvuLlHYOxNBsNwP9BT1iurzZhMT3fb2VOPBbELyDliJonLGprZQar16ZDA?=
 =?us-ascii?Q?jiemW0sU/6PzO6Edgny/gqrYdwspUXCoYG3zrKdBGsHixxt04oB69dqCLxA1?=
 =?us-ascii?Q?pi9fbRBu0N4MG06JbZeRL65e+i9PftNWKPg1x8M4w7TA5uQLuJilYxwileo+?=
 =?us-ascii?Q?5HlHiNJcDQq31aQIdn/8rHIzAo9RcbOyCfz2k8uQPGPI2UlBfo6roYZy8qYs?=
 =?us-ascii?Q?kjN9ZvWwmN2v24AWTTwBlU+Dlj4xVkorPYTT7lEKPDI6EZsewhX5dqWNzTfT?=
 =?us-ascii?Q?TKkJQqxIA7ljU4FV4xUOSlUFK5+HbT48jxCyyhvo9qBbQHMiZXOplXOfHcvd?=
 =?us-ascii?Q?gzQeq1BzwNgQTwFtIprqonx54miQ2btplclclcG2w224LcSnfCUwYoPfA7a/?=
 =?us-ascii?Q?Bp3mIqzUlqXoecC8RfW+kj9Q37SElwF7frj6FLd45DKOgHnmShTQtl/coeIG?=
 =?us-ascii?Q?ULvxW/yL2O7TjggfhlyRpcnRY6XryEkDv9j5WX57PnDDAgqbokXhIooG5aPg?=
 =?us-ascii?Q?Il79hH0D+5MrGrKbCkM4W1mClmp4iFwM01M6uTysaQ4XeMXULWcHco15zdtG?=
 =?us-ascii?Q?g8XuEW0hjXEDNj9OgCdzJmFBA10EwuNv/TjXWVMuw+KW6o2ljuWSlmYL9CSz?=
 =?us-ascii?Q?/hRYgfqesKV1UdhKscWRMVYQWBAwwMAtdPYft06Fzee0KO1HwwKJ8thKa3Ol?=
 =?us-ascii?Q?P/GLiSTFO9YGFNKVJUtmjpmkF0O5c+xpYAghFnc+avYxQ2CRMarQCVRf9CMA?=
 =?us-ascii?Q?YkSm0TxQATKPgi1Wp6L2yrO7CIlc2eo00l8fjfNBTgjIsbpoUMXM9Jf1dETw?=
 =?us-ascii?Q?toZEN8IMIhLrLJqqW4Na+Z9QAVxVJluSzfLlkWDV9LU8UFi2Gc0gBEF7KCO5?=
 =?us-ascii?Q?j6VM3dQzEg9IVnsdJsaCw73SBJ7i12cw/5BaipkyKZHq2ckOlp0eX/1ngPH7?=
 =?us-ascii?Q?tiUAtl74STEJAhCJZc1cSl69uUKVvpQWMhF7e90JZdYWybOWk/ypcW5nzkwp?=
 =?us-ascii?Q?mQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: rbn4+yZlzRpwuuxlxxApxK0YTYtt1hH7FOiL4VEXLfL2n9jikworuYPGD07bHtHd8R4GDupA9cvCDYddbb95Nbt9kWeX2vut6D5LHTHrxEYLEeObQxpqFwaLWwEbj0Bpq8nsAxDe1Twl2p3HdKLYyUn0d5XeKlLloMYDj0gf+e72YfwcerOd7I+C7lJ6GIEwYcPpXfggnq7fzQB9MhxVs632l9vdC2yyj223UpqH5vycTdYFif75+bO1oDJHL7NM9AzsXDMWG/9OAufAzuMJ+g+vYnzJsufUhzr33LIyzzJfx4T9DRaagvHgldN4Jt3tbvhf/YNY8MyaSM2oKUwEY0MG5Plhw5aN43OrtIrUMh7H2tpwgWMBtYXpgl0FxtfPwIjO7LQpfDDQDwyQExOoXRuvOyE/PLQDsMFqVJNBdm9MRBMbOdVIcMbm5AQhoIZ3Yl9DR5Wt2qzMEqoTjiaa0LZaD/FL8NGpUjuqDzIA/9Kyx/yYxPw3IB2Q5ZOnXEvI6MiQcFsQIm2OAy6D3481tq/ROxkiHSOGGK6Q4atcNMP7ZXnhCJz4ZvwYsUkoVzoTCNihkS/DfFTwjvYgX6jz7fNZJ2PkfgfKgLq7oLKV2CQQbcPjnLXyTlDwaOdmAWPa4xCe4acLQL+3bKT5jXY9Z6hDZyO6Q6wZDeOK0p7wfGCRZPcvC/MJmNqw09XwmTs3xfrokZpJMD235quYAc9sjMfvYn3L55e/oXGf1ZCoSpcCYu3biPZYvE4Bcyef81A4tzyhbOjKDDnUGxrn8VMFPg3GSkCxPrbTDZEozy+GRdP47o4sE72B0H6K/vGbDStxPizY3e0jw9RS93ZhaEKpt8+T9vMrb0F4cBOd78cEhfp+TD6SrUSIrtKrb/AGn33u
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f14f69c-64de-405f-8419-08db82585d4c
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2023 21:47:03.8865
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dpQuxIu+7VVTKdyYRl3MMkKgOmX1xdLN9akJij0iOyzNcXnidnx+xPaoTV5n9vXIAt4/CBKUXQdZna1/78UuWgmcjdKEr//+4aRThEtbs2s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB6950
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_12,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 spamscore=0 phishscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307110198
X-Proofpoint-GUID: lGw8Yb-UGU_S1ocCe4VMPW3msbsH06f_
X-Proofpoint-ORIG-GUID: lGw8Yb-UGU_S1ocCe4VMPW3msbsH06f_
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

unit_attention is not used so remove it.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/ch.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index ac648bb8f7e7..ff4a81a1b056 100644
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

