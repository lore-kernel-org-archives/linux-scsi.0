Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99798C05027
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Jan 2023 22:15:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232183AbjAWWPM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Jan 2023 17:15:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233117AbjAWWO3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jan 2023 17:14:29 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A1EC3A5B2
        for <linux-scsi@vger.kernel.org>; Mon, 23 Jan 2023 14:14:00 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30NLi4mM022499;
        Mon, 23 Jan 2023 22:11:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=zJYhQcNYm0T52T4KhPWZshh1qlutl10ILcxUYoTKdX8=;
 b=akx0VBvE0EAkefWrWbq5rbGI63FWQsIFrXbLHmEUp29MeNfesYdctO6ClwkpcAtrVs1w
 zDbMWiv/H3/fwe6D/5t9NKpJntpwlrYOcUPzYWPRWXSkWarewirEQWjm3e63ENi72Nrb
 sd68IAnLr3dyujEoRUvHhiqRTDKDoNJbQdKgxlq3e1o7K1a613CoS1v3i0cOxHAjkbUu
 qKig2I4sKyAhkhK1Mm7IPKu15b0ts/DDP2MAPcfwAeAyGcp7s73RWAGp8ZnNgaBW1ry/
 pyMZv/aAP8R/zjk776DSAMTy/jDE4M/7a84AWO0E0RgX5x/czb6KtdsOTOZr6zTnboMW iQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n87xa419t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 22:11:23 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30NLL02K023237;
        Mon, 23 Jan 2023 22:11:22 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g45er6-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 22:11:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KYRoYkoFjnyqNB4NqKSJMGF5OrD3md+uPFj4dld/eBZ5bM8nxa2FS8ver0gVM9kzJ4GNRgAh42JlYBzcGJ9AFAlp/jR+mvOo1ltmkM1SvhpFL9uRVXI11Kp8CzJRTSpqmcg/mWSKW/OyEHxvjrhXjcP7qytrq+7F1qeMjb8SWEqGiXVzRo/1BNRlVh9jBJ86EQkBNGtRB54G0nRjtu8bP9VXJk3ZQAg1XGOPUGa37hNBBG23c6uahCvM3pD4K18HqR8MOSnlK6NKqAH7nLi2mssy3Gu81lApM0lVztDtcQFpb1oCMj1ijx+oTE0N1qCWIcB2tyrGcEtfvpyBbtRqig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zJYhQcNYm0T52T4KhPWZshh1qlutl10ILcxUYoTKdX8=;
 b=FMx9d6ZTQPSo8I0FrD20BtJWO8WKvBNaZ90+OMAghCgX93jHWnbw4FwRb95t1KtTy5VL4egj7iDZ/L9PPoFye8u6QiOK1JqAnrPOnf0fbGTVSijBeChuFWCBbswJyxo+ygklYQzlA8R8Ggk722ayoUyZt4x6+e7YSJmO1amz2jsfJRe+L0WlJvLsVmTbMPM/9q49/K5GTUpNGMaQbyP4LzUk7V6NHcerXnmHYvhiBrt6dG6JEasONcpC2uG75KAcZ3xiqX2Qbcq04Y3nCuC3p+WrI8LPm96i0rT9T/Xp7BpQd45VTomuDWMqUPCc7TPsbB2rK+FBXjlhp6blTPXKEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zJYhQcNYm0T52T4KhPWZshh1qlutl10ILcxUYoTKdX8=;
 b=qnuukE8L/Jc3GOYqU5OTqvU47DIYYfB2pKBpYT7dnMyK4XPacOE5ZNQPvqeFO+/jxshMdlEggCJPk9rjt+LOYEUYe8hAq9tUme2+hLA6XLXwUnHqqcvsQf0sd/eKTw1YzB0zivML6cZVtyOxNbZkB1ExoH+BTMFVoEb3uAgNndI=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB5597.namprd10.prod.outlook.com (2603:10b6:a03:3d4::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.16; Mon, 23 Jan 2023 22:11:20 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6043.016; Mon, 23 Jan 2023
 22:11:20 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v7 20/22] scsi: sr: Have scsi-ml retry get_sectorsize errors
Date:   Mon, 23 Jan 2023 16:10:44 -0600
Message-Id: <20230123221046.125483-21-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230123221046.125483-1-michael.christie@oracle.com>
References: <20230123221046.125483-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR03CA0084.namprd03.prod.outlook.com
 (2603:10b6:5:333::17) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SJ0PR10MB5597:EE_
X-MS-Office365-Filtering-Correlation-Id: 11803a70-73c8-4c93-7ca3-08dafd8ec1df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rzShsp1AMlQeRky0MpLvYimF4PESB6lbV7sZ/BObCgQv+syQn6tcVgtVbtOTxF7qx6svqudv+8MPZOceQXLFFEDu519SIC5f/pLSknR9y1bzmkyy0pF5zHVNmDMraiP1vaSdtAIDrp8GDLf6oRtzPupBSmgv4GlE6afZLrkDbUG/tPyqr579KJlQoXmx7jFTwrmQY9VdjxmsFc/q5HyPU5/VEqUdILrcUzREYtbeDD78ZXzhF8x1hGZ+UlEx0lQkLjwgp8FXXBd8aCZHqOkZsSaCUxc0bwnMADJS2xmRUOw7u4J45k9Y26dScJz9Zp8kFdYq62cl6DHL0XGyeVKo/tC/UnBG41G7BIp4HaIWgR7EchrVo9khLOOzucUh/Lm+yMZmzmHefKFH3UhJY7eaKGP7YIznveUVQtSXROgvMbFyXM73tAdNE6R05JshEiI77+vH/zuTFhQOUrTOSNbVlO2ZiYqX+5aU29t27wHqXTBgmetSKAy/OrRMmY9mqgXB4U1wmFbX950bxR6fkdNr9s5qKu7zPq5O2B1j4RDCDH4Sj6LxkmP4+ovh0EKDWn1OTI+Q9qVcqHrNwVKyB59/fcWl/ph4upiKBuADbuPfhFgeGJAydY8Bq55bsSkOuUI1FMsH7mEGiyXLyjkG6xkkXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(136003)(396003)(346002)(39860400002)(451199015)(1076003)(66946007)(4326008)(66556008)(8676002)(6486002)(2616005)(66476007)(83380400001)(6512007)(6666004)(107886003)(41300700001)(26005)(8936002)(186003)(5660300002)(6506007)(2906002)(38100700002)(316002)(478600001)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rN6u3lhxCe0uZcKOl6zFPaoGUhSSUZeKplEEiLty6qClYG5bROiYnUxckovP?=
 =?us-ascii?Q?D6lLLIGj1wzXc4A83wusEj9/o829p6nYBN5aknJnnBvGtzoSNSPisloujHi4?=
 =?us-ascii?Q?A/8GY6YHZP62sbbqA4UBO6qQgfTi1iDcH8uiz3XOlFNieAdv9zHWpLej7flP?=
 =?us-ascii?Q?GGeK3HBPewySejK/vJZVimD5u58N5CiBO/QYNQP31KmR4vHsfZYPmHLXtp7N?=
 =?us-ascii?Q?1D8qCCP9lzgeK94DFFnu1Zxkp/gH2JbeHM2J+U98hscdIey23eearSM5I786?=
 =?us-ascii?Q?jg65qgUL2AwGi2lsSp26ZLB16r35i61kwuQ3BJNhqZI3SO4Kvbj87RQTJKGn?=
 =?us-ascii?Q?mY1M3GkVn8FjRML6euAvuV/h5tGVDV0YnyiWkw3rzVpYsVHpch8BYV8WI0Nx?=
 =?us-ascii?Q?pu+XSUbpohCgZuTK/vp/5LOD0yfXUcZvxZO5ZhMOGONXBj62GASe9Yj81pCc?=
 =?us-ascii?Q?PAe9cUKhex9n9V6a5IrHvb+yZaBYAKX2mho/OmyKMrHXj9lSscigV6TE2KRc?=
 =?us-ascii?Q?uQvVbDjjhpe5vudg4zZ+xBFVLMGHDakK1kqXFLZKYP6uX22RVkBkGEI7aVhp?=
 =?us-ascii?Q?KBMz+gzvL3C2X4sBMpRBxW8ph8e44ej1yyUJV9bsRoCwg91y28vXzNIvaqUl?=
 =?us-ascii?Q?EIneeT0QYPdVdqu0z6V9yfM9Fk1UHjmYV0u5kyUZLwuJY9oDXiPgns88w25J?=
 =?us-ascii?Q?tiiaCtPZVRU6JuH101Ew7wobGVzMlvHXaT4BkQpvEe5YawKF6KAg6rnepC8e?=
 =?us-ascii?Q?iYzrWx7sVW/2/kL8RHy4URG9MTSpLBqPvLId3i8Z8Q1CwC8LcBymee3bc4AK?=
 =?us-ascii?Q?rK4ZSu/It+acdVvziTIyU5ToIOxQKmS1L7Io+njUXWg1fljQj8NJ4vS7/q3c?=
 =?us-ascii?Q?VtlHLxUI3MRUSa1opURtvbMVal240ieKJdW7eQe/ZqJ8toPDPjfsTk2cc8lq?=
 =?us-ascii?Q?epwT7e4NrxMd0JeR7Y4I0wvsAef2Lv7y1ude8LUnOZerRN3EocMXYrID80ez?=
 =?us-ascii?Q?cLy9wekOR0EolGcCMpOkB6bIPeoJBdsKaL2hZpYWTGuOZc1xbsQ/pBCEdt03?=
 =?us-ascii?Q?9cgJ5kQJrnsFu8541t8Lb77WPTle8aHXcIjbR+XTy/jUcB1apgm8yDhq0SyL?=
 =?us-ascii?Q?ESUajrCpUGxqYAn4kTpdrq0F/OMWsAloTCxnP6o86vGQT4jNKt/mu3WL3Xv9?=
 =?us-ascii?Q?RNgZhoyT/nmW3yLneQNfbG0WAwGiT89NZj4SX7I5AgsFVKXxZycpqBUCj2p3?=
 =?us-ascii?Q?9EVopAnp2XMy7kQG2fHcck7chKjJAJsAUvN+dNGiGbBcZ94fJbRI8en8rhvI?=
 =?us-ascii?Q?/6Nc+POSH8DaUemi62iL1fAvgM50bJyOj66FsgT0MRIE9T/psbANhCk0+IZu?=
 =?us-ascii?Q?takpG1mvhle43BUkRZdDAJkYEioEjbMnm5SSBEt1a5hngDjm+EfRgR9WdVw0?=
 =?us-ascii?Q?a71fpXM7Whb2Ir/7SkKua8g6p7GZWg2GVsIzd65jG2olWT8lYeLSlTWY0X4C?=
 =?us-ascii?Q?NOdmGvD56dSEbubE/ytxPUrDF9sfUQjBM+tnlF3FUlOX8wPb2YBCmWdTA0A3?=
 =?us-ascii?Q?OaZ/6TPkQUX1Y1s9zYQidvXHfMUhgTrIntVVyUYeyhjocWlWVsGsvSFgRFOY?=
 =?us-ascii?Q?Xw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: NNeKyqzhxtkwX6g9O02MyA8EXLTlDdmM09W/t8OmtKulCjZTur8G8togznDi2n5QoVzT2NPAoBCOqFpC5s2hZ/C07OP+1+XWQqBcyNlTG5Yg2Mnng9FJUc9mISrDLJUDt+geuuEyCxUjddPm+TZt3OlQqSiRq8Aa/6/eV3R3j8dW2xXKGVgqc6as2LEAdBIsfaUaLqbn4shZHihnXhaIjqtnisJBMxYnfXWT6t3z5BO2TuQLbfl3bXiidCyUQDL4U9TTunaIvSYymvxbyxPcRRLIqcYJfdwpCR/cJIW2hPPILKkRWRrLVow2fm0hsF+3A4fU36MIayWqWvMwwVl3UtNdXnLOmBtCpfPX8ERas/eD7GKG/gvei/tqtdesryKzDnPdSFXRJ41+4GyW+vPdwaZydfUNdUBn+XQgb+Y5IVf97RohsOK5wa5NSWBUjaGKklul4Ourpd2SMd37ocJKblEF0s2YuKueLIt/xHOwv7YI1sJKJcq77cQ1f4gBDVUlTQzn/NQZZN9Aly9r6OBAfP1pavytzr/XX68RcAnxV3/Cvj82Gr9+eUgun36YY7creO/yhzJxLclCcqRFl1v6dKBw8pan/znVgcaCwJgkxCc2rbFfMYt+8DjZVAHEAB4WDgESK+G6JyJgdIGNrkcp2Qr9G8GrBUoEvv18sHzXJEt49+h7+n8RaNNuxwWqs5+e9+m0EOA1wXTZoomXW1ozCePTY7luYkVR+qk2fd0BlpaEceaLRTiS5Rs2KTowJ2OHtJK/YVZh9YqOBO7xZ5dvZRi4TDueJZcUKuZBKIeXPZKyHQgSfI3xAswjyUUchE6ee72jOAhhFPEuhDNGWLYMtvKQbP3VDVhEOO0/pQK34p2lCqK2TKYmYQrUtg4qPQJM
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11803a70-73c8-4c93-7ca3-08dafd8ec1df
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 22:11:20.7585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I2MB0wHXjBe23AKWdgmEfFYF5ksbQJyYaJk8HQ3lhvk+CfCF2Ap+pi/u2po9XkqxzYY9bvFlnUEcac8h7paakEAEOdx6R4792mpO9jTZyH4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5597
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301230210
X-Proofpoint-GUID: Vi9mKMH0tqLEvley-uAXTUD6JiC9AaXk
X-Proofpoint-ORIG-GUID: Vi9mKMH0tqLEvley-uAXTUD6JiC9AaXk
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has get_sectorsize have scsi-ml retry errors instead of driving them
itself.

There is one behavior change where we no longer retry when
scsi_execute_cmd returns < 0, but we should be ok. We don't need to retry
for failures like the queue being removed, and for the case where there
are no tags/reqs the block layer waits/retries for us. For possible memory
allocation failures from blk_rq_map_kern we use GFP_NOIO, so retrying
will probably not help.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sr.c | 35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 9e51dcd30bfd..81802a080189 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -721,27 +721,26 @@ static int sr_probe(struct device *dev)
 
 static void get_sectorsize(struct scsi_cd *cd)
 {
-	unsigned char cmd[10];
-	unsigned char buffer[8];
-	int the_result, retries = 3;
+	static const u8 cmd[10] = { READ_CAPACITY };
+	unsigned char buffer[8] = { };
+	int the_result;
 	int sector_size;
 	struct request_queue *queue;
+	struct scsi_failure failures[] = {
+		{
+			.result = SCMD_FAILURE_RESULT_ANY,
+			.allowed = 3,
+		},
+		{},
+	};
+	const struct scsi_exec_args exec_args = {
+		.failures = failures,
+	};
 
-	do {
-		cmd[0] = READ_CAPACITY;
-		memset((void *) &cmd[1], 0, 9);
-		memset(buffer, 0, sizeof(buffer));
-
-		/* Do the command and wait.. */
-		the_result = scsi_execute_cmd(cd->device, cmd, REQ_OP_DRV_IN,
-					      buffer, sizeof(buffer),
-					      SR_TIMEOUT, MAX_RETRIES, NULL);
-
-		retries--;
-
-	} while (the_result && retries);
-
-
+	/* Do the command and wait.. */
+	the_result = scsi_execute_cmd(cd->device, cmd, REQ_OP_DRV_IN, buffer,
+				      sizeof(buffer), SR_TIMEOUT, MAX_RETRIES,
+				      &exec_args);
 	if (the_result) {
 		cd->capacity = 0x1fffff;
 		sector_size = 2048;	/* A guess, just in case */
-- 
2.25.1

