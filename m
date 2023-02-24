Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EF65C7EE2F
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Feb 2023 17:45:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbjBXRpk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Feb 2023 12:45:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbjBXRpe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Feb 2023 12:45:34 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A6F61515F;
        Fri, 24 Feb 2023 09:45:33 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31OHiQhe003590;
        Fri, 24 Feb 2023 17:45:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=lIbc/1XlbhdTZxRS0mg3RI8xeU8EXHLVRnSF81R4BmE=;
 b=xGU+rzQh9NLe0A9qRs+Ex6NtgXh4TroA/5xkwlJixXbOiuDDEFj4N+2hg8KRjjFZ9w2G
 94gPFG3f0T3KTUn+O+32Cyhe3Y6MgthtS0nZDnvz78K0PlsAb2tZwsoONiWtqgr467RU
 xuJFBKiXAY/UjhYEtL+TszIlRsbEA+DUq2BSLVNhc2GnWc1jIdkANGCCii4n+i7bbdmt
 rf5BvE5lSjkdIcK85Ix2P2ymuN15TpRY+TWpZMEIKMXsC2vu56ugzfOTx/Yw3RSAIGkW
 NOyKRWKGy7ZlLu0jIBCFjAu0M8HV5RzVa9IYs+LkKDojq9J/G808/vbCfxQexpmvXjAm zQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntn90wq2p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Feb 2023 17:45:17 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31OH2pqv034025;
        Fri, 24 Feb 2023 17:45:16 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ntn4h5npr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Feb 2023 17:45:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OgkNToDbm0N5MqyG6DjWAEx9JGaVdvGNWu6x8KroOQfvKcs1EDSHt24NgMqc6nWG8hLw271VUGDgxkKQcc2T8S1/7r6RmuHWB7/b8Z6nsw63a5r81DxCuKyA5LeKEPY9X+dTUidavinwsVUcKzw0hxuLHwZWAsz34Omgbfkb2v+8z8woC8cCXxsiLvhDAhyvDBmTJ65AwTsHzWG1FCqkbpebbz6qdgW9QlIRLuLv+Q5wZJGONAT6onH8OfS/Sot1FHgl5w1ph5O07sIOqQzDcXc8dErfLnJLMk4EQ6dF6HfeUwDuO/7x0vjHhg6pezmFq5wfeT3PrdHrmD8N8YKVew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lIbc/1XlbhdTZxRS0mg3RI8xeU8EXHLVRnSF81R4BmE=;
 b=mOF+VzlBKi2V76/0K7reSPgqZv1C/11R+znRWgcmRwA9nwGIo061rFHoFFSqGFNCWJ5FVQep+/dYKmDV2bpSf5kLyoBLusX6GaEMWqHUN7C6bWcmhtvoiq4gWLZavUGpcYZFumw7KHr44AnvOmPeocjOOA5ssb9ZgN99HsBz2LozNSsg91WxcolH8EARqiDLZOkjTmf1exiunovGSzSl9fjxZavsCt85wuF/BnP1AeekZx71cvXqlppy5rfuu1362zc4Q2djSYEiFh1l6X74kmJJ0R6ISe8pBCE3ZqG6qQhS0t6YjrB5VgsV1xVpPWYZxR2IaCcxv5+z9mZKFV6Yxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lIbc/1XlbhdTZxRS0mg3RI8xeU8EXHLVRnSF81R4BmE=;
 b=ITfRxanQhw/uuVe6D0DfExLHPAQYHaZ/EhJwCSYqV8P0BVCdPKwb2Fn+3uF0JUtanOlaya8UCik2sBiQ78A0D7rHMKB2NRxN+72i9AFzUS/WJNmy/yDxRKC3hMM2mn9a49yVXj2BeocOcy3ErPrLPmwwkqPcZs81bVZC6e55bGw=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB7535.namprd10.prod.outlook.com (2603:10b6:610:187::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.7; Fri, 24 Feb
 2023 17:45:14 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6156.007; Fri, 24 Feb 2023
 17:45:14 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 06/18] dm: Add support for block PR read keys/reservation
Date:   Fri, 24 Feb 2023 11:44:50 -0600
Message-Id: <20230224174502.321490-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230224174502.321490-1-michael.christie@oracle.com>
References: <20230224174502.321490-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR07CA0053.namprd07.prod.outlook.com
 (2603:10b6:4:ad::18) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CH0PR10MB7535:EE_
X-MS-Office365-Filtering-Correlation-Id: 59138c39-2cb2-40d0-3eae-08db168ee265
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1pyDQGUd5vVU4DWtvlAMMX9U9oaKkxcxSJXZNCTKHlEk8JtoAR0EeR5/i0SqPop/64rAxjf3kmKwO5sisZeDWuT7zw4ZrJ9FczaKqePguEt7Ybw+kHLlsC0Sf0oAGw7GGBYW9hBvLk/uzgVRHV0lNZjlae3G22lZhWKSlgn5/6ab3wAHEKmdnm0pLgroAqsmM/EOkm887+3porp69rf8twWcX1WEbiOfrw6gNE6xp0vUin3kNEQc4T6RaTy08SOr/BF22jPwWSwuY+ZCpj3SyoU+vvy1f+gXUAv2KQLaTGyALuPFviTdBMDNNAcULiXBhy35KtgLEgnqf0s8o72FzNSlEYMwgpFpos6egIQ2IQu4qa4AAeUw+ohcqjCEg4O9FhZrnRCPE/6MLdkJlRzDl+gHfy3ERmvRUxzbCiw8+abtujUQkF4XYh9RoB9PfpJd0TROimizt/YzVuMk7jMBngY8V1beY/gcpxDxv+YgSz6aIlcGINlOYjK5aQx+Cu936QHPdE7LyMpkWT0u9aoZpBtB+9L0+pfracdip7cy0GBoFTAFvnz/hFtpGfszDdDnW64GSI6bVPn0HYzN/fByplfhrh06Aghi4CFH6wpZdPkTKB/iDzOyHircZI8sHxY6+ZycUdps1JcmsBtXT7VA8ZY0n8poyIrOnh2fS3b5qF4TGzpZ1KRnDTct7CgwRMcV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(366004)(376002)(39860400002)(136003)(396003)(451199018)(4326008)(66476007)(66556008)(66946007)(8676002)(83380400001)(41300700001)(316002)(36756003)(186003)(8936002)(26005)(5660300002)(2616005)(38100700002)(7416002)(6512007)(921005)(86362001)(478600001)(2906002)(6486002)(6506007)(107886003)(1076003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NL9rm/7SQ73RuDC+6RY13kSzRMss2XPbxwa2qTmP2TwEN/JKI1z00d9wDF/w?=
 =?us-ascii?Q?u0eKJopgQGoBALxU8qNlC8mrXPW37ZFpp2vBuG5PB6+lusoYpExc49SrIlhO?=
 =?us-ascii?Q?jQ8VcxpQX95z9g2HWuKGcL1DyXUlnB+5JnYH/J2hNRfwmY7fydzZxGwCfrIL?=
 =?us-ascii?Q?L5ojtCzOuevZHJHytb80wxMJfkHKJYmVYGZybwgTVpkMyXDW60bIvT7hxU87?=
 =?us-ascii?Q?zEawz8VnP5+vGsV/prQIBOjlNNAFLlW8giGo0kh3oGQQVd3y00xX0A5a7IGK?=
 =?us-ascii?Q?ojjNTnMn+uj38HNfOZQdFQv6nDU/SEboR5jcPRbEGZW62mlRDpKP7i0tSHi9?=
 =?us-ascii?Q?KFSLOrXZNqiEBXLiSS7ebz8bZZH/Mss2Ejd4HJrJRSI4EK+ekJ4D4zC2O+Z2?=
 =?us-ascii?Q?JyDMmg5B5YQ5KjJXYC9Ee3qm/ZhQL1D5BbIwvOzXoxtIJZAvNuAQjGOcpKCX?=
 =?us-ascii?Q?uq/AZfCWqgoaMQDmBQCScmHqjDvIDec3V3gpQSTtSQuH5X6N2Q2AuCohovgh?=
 =?us-ascii?Q?F2VqJGjHfcsAsm0Hn2CGHWbYbH1sadbPaUPqdJJYbecziaRZ8QIJicUDscp0?=
 =?us-ascii?Q?wIM8qZBmj71HL4SbTIHZ962+GHsLG3QLvEFGO6tC3EFUMek7wRKdxGfB0nQs?=
 =?us-ascii?Q?4TGeKnduGhGSvd3mI9+fSWbLLS4KnKCVfhOAPFsMmsS4ZpeDI8+NRVqgUtdi?=
 =?us-ascii?Q?wbpW8T11hkwaIzF7md75DoekPpMSF9ciPV3xG3gWA88wIbrLbLNVF9imUGcs?=
 =?us-ascii?Q?TDLhhwNHqLrN6K1U050/dTn2LAwGjM9+tXKL2EDdh9wXZtOwmmKJQE957BIW?=
 =?us-ascii?Q?nbsWQgu/1VIBAk7uhUpvOSyziRaRdRnhZAfWaVKgo+zyZKO7SQ142jvQW2HH?=
 =?us-ascii?Q?KphY0JsOaPs6BZCH6MBGW9BlvF5NJ9MbMnknGe6aGO3rs1bL537FeqTV+V1Y?=
 =?us-ascii?Q?BqNwDY2MIgJnXS0PX+QJZzHyjF5XEiLviciU5CYQYluFUuvaYmw4632er3FC?=
 =?us-ascii?Q?cE5nUq4E+eWWBvcHBhr17JKff3/0tvzcnQuE4wDvCBbFp1omSFWbwgDDH1Zp?=
 =?us-ascii?Q?XOwcxblOYo521qUC2JYvgFZsQMWXyhpLBx664ALHEubJa4ypuTfSU4iOxIEY?=
 =?us-ascii?Q?3rozKel6oxLFGMgjWkRDNhkEoSm/ofHjM2ByK9qLsiQpEB9NoIoMWBTfB+qQ?=
 =?us-ascii?Q?ah+Kz7aLMUgwwWU8QJyRLVqvztQUd1ACzh1PoRjaIYfzbciO9XCoOhEaB1mw?=
 =?us-ascii?Q?Giieu0nlQXhlvA02q0IMDhXot9+TTsX1UBhVKUhJRzdNEuQsv8ylkG3nxL83?=
 =?us-ascii?Q?S0I+D1mpULVd+eOFmxQc7Wefw1fOEg6GxIltkteTvzhQ03wHseyNVIYSgyPK?=
 =?us-ascii?Q?VKLbzqx0ggc5Es037VSDdbnZhgA9PbPjjaZWgcuCsOxTfnvccRFVmTaZLOB3?=
 =?us-ascii?Q?DPdlzUVENmJ2+Be0HM6cmCcf5SrMcTon8MnyKYTENcgeBKC4pIr88FlhvWLa?=
 =?us-ascii?Q?t19ZtoQy58hjeLnyJlZ5LxPqdOTkddwEf3OXdVNjXqyOxymlyszDK9dn6cEz?=
 =?us-ascii?Q?CaXoCBys2OwPexjCFJhNQhONHwnrnXJL6klAfReaMc7LG7PfIHN/JeIcbsZY?=
 =?us-ascii?Q?wA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?gtFI4exu8jcgcD38gs9C/0LCO+U+NNAzj6e/r9mZNFohHr/KOqkHlun6Kxf8?=
 =?us-ascii?Q?ZOTp90n3jlh+KYSeczMQNF9QKRLg6zk7X++8jIJSPoK211rnaQdNNbV2BO6C?=
 =?us-ascii?Q?jDs16qMez4CLOh+IW1KGBwrqM2H0i2sfODKN4sraw9NEoq7XO5W2mwgzoyDm?=
 =?us-ascii?Q?p4MYikz76H6O3dtVQ0uPU5ZLPYi00OMXYiotZUD8BhiAwP7tsUBUP8KvnpAR?=
 =?us-ascii?Q?zXxxZZd1/YU1+hbcXQbcHecTe2pb65wfthMVEy2wqpeeVrsjRhmjDimRAkOt?=
 =?us-ascii?Q?HDS+umj+/y5/kRMIQUm5zZuh5bNlyjILQWqt3ja9DN+pPoMceiMdNfCAZsBL?=
 =?us-ascii?Q?4rprnT/xOIr4W9r0x6Wxj0p2/LA9npCRkM79hJvpjt8Ue20MaOJ5T5GpLpws?=
 =?us-ascii?Q?1KzBv7OxMH75aud6zt6/uoUJt/oxsjLlnjbZfym50IZ/ApmO1pMT+JUaznBg?=
 =?us-ascii?Q?/fE/cq2JCbm7gy4RdxWXhFHsBmCU3s1P2NSIEYPxYF2ZFd2OfvCG+Agvlvrg?=
 =?us-ascii?Q?hz9QpEK+n+k7SpOfc6HNh9MfslRBXb6UB+/DKzGTjK7lRPeTxBZiQgcDnQKZ?=
 =?us-ascii?Q?VD+O2abJmupj8ebKOqKPVzhher+dUQrOnMDScXs9VHzPX9sseb1poqyaGirS?=
 =?us-ascii?Q?Nj91AYWhpLtogT36aKtiyi3S+2dJ97SAen7vBHuF1axG0Iv41p9OV07wZFoh?=
 =?us-ascii?Q?SNyrvZao0LcImZCuNKp2hl4TtsudqI6ZqFTInaFyP4KwK8hlHBWUE0aujg8A?=
 =?us-ascii?Q?87mnbSauLWPz1tQJd2BKTTkuxeIIhMRcD4jURRlRBIiC6ScTCvaQV5QiwORV?=
 =?us-ascii?Q?GGhupMYR6Sd6+lIx3UU4+pJg6ksFRuZfPPe9q6XCbhxiYLa1NF//Ok/+oVE2?=
 =?us-ascii?Q?FyX+gwi1A0jpZ7v18XZdVrgesMIEl811EoF8jv9WlSH934vGPXU3/aNCyA5u?=
 =?us-ascii?Q?ZbW7S3kVW0BdsLYepIIexA5LsX449w6w9Pp0y4B38W9j8w1k3kfnoOm9nUKy?=
 =?us-ascii?Q?N9o6fdv+HEhBKh0pDVZnfb7INA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59138c39-2cb2-40d0-3eae-08db168ee265
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 17:45:14.3916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HvGP/UAqOKOzO0q6eNhhLsEaLp+3csU02rgiG8zFXGTgMlVL0r21agvCMa8lnhsWZy/AlkYjzuK1gGoH9KwOJKNS5Qtfo6ZPjHfN6dwh0ro=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7535
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-24_12,2023-02-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302240139
X-Proofpoint-ORIG-GUID: JvnnRt9eNraiwUJGuqKyW1z2G7sTTUg4
X-Proofpoint-GUID: JvnnRt9eNraiwUJGuqKyW1z2G7sTTUg4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This adds support in dm for the block PR read keys and read reservation
callouts.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/md/dm.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index eace45a18d45..4abf640f1e7e 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -3346,12 +3346,55 @@ static int dm_pr_clear(struct block_device *bdev, u64 key)
 	return r;
 }
 
+static int dm_pr_read_keys(struct block_device *bdev, struct pr_keys *keys)
+{
+	struct mapped_device *md = bdev->bd_disk->private_data;
+	const struct pr_ops *ops;
+	int r, srcu_idx;
+
+	r = dm_prepare_ioctl(md, &srcu_idx, &bdev);
+	if (r < 0)
+		goto out;
+
+	ops = bdev->bd_disk->fops->pr_ops;
+	if (ops && ops->pr_read_keys)
+		r = ops->pr_read_keys(bdev, keys);
+	else
+		r = -EOPNOTSUPP;
+out:
+	dm_unprepare_ioctl(md, srcu_idx);
+	return r;
+}
+
+static int dm_pr_read_reservation(struct block_device *bdev,
+				  struct pr_held_reservation *rsv)
+{
+	struct mapped_device *md = bdev->bd_disk->private_data;
+	const struct pr_ops *ops;
+	int r, srcu_idx;
+
+	r = dm_prepare_ioctl(md, &srcu_idx, &bdev);
+	if (r < 0)
+		goto out;
+
+	ops = bdev->bd_disk->fops->pr_ops;
+	if (ops && ops->pr_read_reservation)
+		r = ops->pr_read_reservation(bdev, rsv);
+	else
+		r = -EOPNOTSUPP;
+out:
+	dm_unprepare_ioctl(md, srcu_idx);
+	return r;
+}
+
 static const struct pr_ops dm_pr_ops = {
 	.pr_register	= dm_pr_register,
 	.pr_reserve	= dm_pr_reserve,
 	.pr_release	= dm_pr_release,
 	.pr_preempt	= dm_pr_preempt,
 	.pr_clear	= dm_pr_clear,
+	.pr_read_keys	= dm_pr_read_keys,
+	.pr_read_reservation = dm_pr_read_reservation,
 };
 
 static const struct block_device_operations dm_blk_dops = {
-- 
2.25.1

