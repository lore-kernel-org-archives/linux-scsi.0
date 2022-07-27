Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6F8CC00144
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jul 2022 02:40:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240067AbiG0Ck7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jul 2022 22:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbiG0Ck5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jul 2022 22:40:57 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 169C71D0F9;
        Tue, 26 Jul 2022 19:40:55 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26QKn2sY029968;
        Wed, 27 Jul 2022 02:40:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=YqAfkMBq4Rwzs3+yAnuRQQ8dIoqjqm9nZiUAU8g2BZ8=;
 b=QZkB4ffuySkvzhWrym+dgaNqZS8lfKe2mXYSfZqUYLrQf9HbucF98kq18NgUKzDxihdJ
 7N/Ld3IdF8fTRMtK6Ebp0irjCfvcoiW1xh+C0zbNKbIkGd3XJF0rnhoeqymgStJdzk/I
 B8hipIwwE/gjtFu1VMuVxAijzat8TJwN2eiHg28aYteIpOMdVOZJeASItvhh37zFlsJb
 j26hKK93aS7oo+IvmvR8a7A39r6qkuCgHTcYnh4VZWL6WqhP0tIeU2NZi6AkYTrmM4ai
 ao3Pcl0D+pVFjpNkdygBl2myv7r15tF2f1iVCFY5SuBzqZ4MFueFmMyh6mnU0HvxcCsB mQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hg9hsra39-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jul 2022 02:40:54 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26R2D6rR034559;
        Wed, 27 Jul 2022 02:40:53 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hh633mxgd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jul 2022 02:40:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=goqAlltf9b1FPj95emRayLF34y7LMQPPtZMo3YVF4oOSJme+h9xMcROTAycGEj80PhMfJ0q6JMQZGx2Ie/TB5GDXNMssJTXXrf4l2EDNdCUgkMN/i+Bbk3ibKJhaYNn7YVCVIcGtEelAf2d9ho4J0NBkSDZ7W1iWTQ2cHCFA4DLOBOMIIKY5U6mg6rBQO1MeP+9BQSe9UN0iiI5mSmYowZNhoZxB5G3FZCA1y8HLVbLX+Fx9ChqTIhVKaDOQUy65AEPFWby6ZxfVHhlGD7tyCMRUX7VifW18UmmbIYhak1gfxV0tyIlBp3Yi/Mx2QdasfzhOqF/k21gjqUm8HoiZAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YqAfkMBq4Rwzs3+yAnuRQQ8dIoqjqm9nZiUAU8g2BZ8=;
 b=oc4bxbxTg7RWvLUwO/x3XFtAMSxySvk9SfU14pma8dYXjKher/iPIz8I2qbBb345hpiH72+jLvOUCwq1IcRsYTAERAHyzmh3xwinPg5yl1imCGkGqgXIwGng1bKQReiYeXgUAcXtPIC9klnuasXwFQcON1M/kMjd9D4PmTwqZQqun2bX81MFdHSA3pIGJRJ2ZdFa9OSuJ8vDomVmFxjZkcQciIu3kmV27ZO5C3FisB01gq0wjCpLz7Sqd+Sl/bqvzI5JUyrOiSqEorNgD4aCsm6psQSEz1//UwBSGuR/bpU66inLwFED04V/01lY2lJdoL4xSa1v1+i1X+sBEmjZKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YqAfkMBq4Rwzs3+yAnuRQQ8dIoqjqm9nZiUAU8g2BZ8=;
 b=t151mSvZNPzjg9/Ng2RqB+K8mFxTquFEFBlkmqHGnXTYHZggACH29y7qxMJxBLKbjIku47dc+QepqJmrRJl7UOJ2/WbVz6Ld56G/vYcu0OnVH5wJREY5rQ0oNLqrl/hJC1EdNqkBEEr2ipp7jT/Sz5GJ0NnzMewmhzQxzYsv2Tg=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BL0PR10MB2961.namprd10.prod.outlook.com (2603:10b6:208:33::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Wed, 27 Jul
 2022 02:40:51 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45%5]) with mapi id 15.20.5458.025; Wed, 27 Jul 2022
 02:40:51 +0000
To:     Mike Christie <michael.christie@oracle.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: Re: [PATCH] scsi: target: Remove XDWRITEREAD emulated support
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1k07zcm6z.fsf@ca-mkp.ca.oracle.com>
References: <20220726235339.14551-1-michael.christie@oracle.com>
Date:   Tue, 26 Jul 2022 22:40:47 -0400
In-Reply-To: <20220726235339.14551-1-michael.christie@oracle.com> (Mike
        Christie's message of "Tue, 26 Jul 2022 18:53:39 -0500")
Content-Type: text/plain
X-ClientProxiedBy: SN6PR08CA0008.namprd08.prod.outlook.com
 (2603:10b6:805:66::21) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b2ce90cb-7207-4501-53db-08da6f796b55
X-MS-TrafficTypeDiagnostic: BL0PR10MB2961:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tOmvOmsZZ5lrV5wzS90kkVlfoyzS6/laVaSKtBL3Lq7qJ6hSFtr8cRq682KFMGb3FXgIHL+06tiDhEgo6WboTu2TghdsFfESCFUkaOPX6BaqR1R3Og6r6M8TDg9S/xhM4QQe31fubdwNFA+aOpP87Jr3aZvKd+2T5LaP7oflvboj80u6C/n93KiFLwn6lH3VHPgxHManFETsrTG5Ac8RW+3Ze5V9yCWSjrZ49MupfEadHBmKulrgD9i4zYA/X9AxC7P3Thqy9UwtH5Xl4m3PnTdaIC2Xl/Fka/WBrZShTgw7uK4SPt2fm4XtLjcbj4Zbpcq5G3hyRXzjO1+VIH3Q8H6UIHJ6zyg3zXAQTh6mqpoUIX0pYIC4Z4TTEtYJZGkHCFdHj5g045YnNHt4G2f/qKlANMcV3K/VlSldRXR+AvBPFiBDHhG7i+burGukoA9gpKC7hRwOXAUkPEa6BuRlJm/IoQl21VJM1lZPUqslff6RuGQFdjG0LoG3s4nDeJP5eJ+ZMcDu93HpsY7SmtSD9NMi3zwNnP8Nslxl20l1KxDnkBVzA+l3xWKADMoJMT3vpDSREgdlOx7H0x14V6VUrm9rG60Q04MQVy0YFi+KR8/TQm8HOt/7nlnFSY3FKy8xvq1dQeV35ohOOXH0ZINfKMR9gtPoDFRygdS3wWJy9S1lYRERi2K1Xt0SEI+8ZNHZzR0tvagXgDfeErPlkexZ19/7iXUp2e3Fwh3oloY7UZRLkT8h0F5qwsOBlGQyH6eVkA7e7jB1e7ObN63vXWRbLy5IL3iCAEYXt2BjcNt/jM04a5bkjyYbSVED+mL2Ywoy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(366004)(136003)(396003)(376002)(346002)(316002)(38100700002)(6636002)(38350700002)(186003)(8676002)(6666004)(4326008)(2906002)(66946007)(66476007)(6506007)(36916002)(52116002)(450100002)(8936002)(558084003)(6862004)(66556008)(6512007)(6486002)(86362001)(26005)(478600001)(41300700001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?L9MsDpn3816Ag4byTaN7LYWpZgSYb3c6roUxNvK2uJuu6QCxHZde50ww+QQu?=
 =?us-ascii?Q?vfYKcC/ObPyHUyaB3l/YvwcKYsaLs6mgG7EwvcbvclI4FadshLOG5PmGZL22?=
 =?us-ascii?Q?qnzyhBKMLRn7FP7QkRIHDCzT1vAowPWHnOio7tMpue30UdLfLvL7GZVbsvVT?=
 =?us-ascii?Q?iw/6voZrj5YHWtH5MosuzEyXYqzSOVFwkD0vLFHpo1L22ef43WkHLVDdmZBo?=
 =?us-ascii?Q?pwudOFn921fKTO1KT9A9uLlYTqnfSoGabYK3I7m6VuwaKR7xzhdNqVR5kuoq?=
 =?us-ascii?Q?ai0Sqcb1BmpdBSnzC5uOQNmKrYBtzdmD/+EgeTdpFvZ6t+IjmILiYQTwklue?=
 =?us-ascii?Q?inbrojnNRIZHEmA9siyKHyzj9Or5bg8PbZkXVXiMY+rBm+cYa8Xl3zfzmsk4?=
 =?us-ascii?Q?ur5rjNwcssbHCTKwBqGbnUQzXz+cLaADKUWUZf7w0E81/dPk12NitUTH+/gF?=
 =?us-ascii?Q?15VGbsKBu35MoO24bt1YjunFep2p8FGDgX1/uOnVFLEEp0muIcGTxcFaB4BV?=
 =?us-ascii?Q?rC87zcQ85aQZqMSXuQq0uoJF7nIvV+7HzREMitFKjOte3XFiuk5Cb7rWmr84?=
 =?us-ascii?Q?4kTAV1e8xQDqIwOyx3ZqRfURR1/QRfFIlnznh0Z6Km7m93cUalDJSdabmn57?=
 =?us-ascii?Q?1grDBG+rhI/oLZXCTo9FfYaNS9sniESHdWd2Z211eg0gcMC1uZovrRtqvfBo?=
 =?us-ascii?Q?+aKO/zo3p8B2o8dNF1OBTjf1A+Ab5NqBn8HbqDJbdor7XL/d4bz5/dmtrn5a?=
 =?us-ascii?Q?ksFbOV9KFjLST8rek+3Dox1w0SN6ouDV5ZZ0g6FZ/meGj37ZErDQdlYV2s//?=
 =?us-ascii?Q?3cNbSezoXBHbI9SDtNL6JIMZ9kbhiPYfK3vnFeRdEy7iAKRs1FJqHg2dE5fB?=
 =?us-ascii?Q?HIuLRqQXpwQPKbLRSWd6eWmShbSrolHuwygsDN8RyZQjI2vs8p+OgjXPiYRv?=
 =?us-ascii?Q?C60pPdCDJItfATiNRACIQNx1Gbt3gYUqMXJUSOxyI/q3Uk8wpydsHb+RJxZ5?=
 =?us-ascii?Q?JpprSI7xm3FjILTck3WqTpLn2VkGxNq5YQQbt34bAFOa5QNsg7NDDvGAIn+g?=
 =?us-ascii?Q?5ve0fO6bNwG0wb7uNhH18amQ8neVQ3KOA+3zckeYxW/tv9JI8oqQUSYjPgHB?=
 =?us-ascii?Q?lbr6GdqLIIbGuMBnuw7mmuDHQNPY8blPCNEy8QsdKwjaYA8t8ijWR/CTUuuQ?=
 =?us-ascii?Q?oI+zwWGGZ+zvozx17JYCNq6zMHqU+3mQQcGnJoeucyFtPSQI6n7w2MgIEB8S?=
 =?us-ascii?Q?x0cnxi4wj58yNOECeqE0XR2WfNgpyuGLC88JjurHMk1tXbvwwkjMTPJIxHZY?=
 =?us-ascii?Q?9NrxdIIDAXLTy4CxYdn1HPbIp0JEXvmEUD3Dnb+OGZCrhDKkdvlT2xAafrNF?=
 =?us-ascii?Q?o1L3iMswfbo1zSquoNnXoYMvEy5RTDdkJSuH2KKXaifYMD2BoxAX14aaPChr?=
 =?us-ascii?Q?mo88wMwEjgSdlH3XPHuK21q+9Km42BLz6fvMNOY7adVJQ2ufXz/5WdO89Jkz?=
 =?us-ascii?Q?OQkbf94b7fpoYHcrThaJTjTmfbZX0AP3PLSyTBmWnFSFPgtStijuLRRMhF3n?=
 =?us-ascii?Q?Jss4ar7gznpGQxejWkVSeqHSsNLB6i+QSyS+It7HYxaKetFJBBYOqIGFuq9l?=
 =?us-ascii?Q?SQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2ce90cb-7207-4501-53db-08da6f796b55
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 02:40:51.0701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CNM2ys635/E8gXAo8mf9rR3FG3CHrTDae55srZ6gD+2eNq98iH7pOu7Yo99UBqIZCyPtd2DbMu1garuwgIA0sw06IWCymEtiHvuR+AlmAWQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2961
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-26_07,2022-07-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=821 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207270006
X-Proofpoint-ORIG-GUID: KCP0530zC2Hr9QxDY6DU0DIBR874xesW
X-Proofpoint-GUID: KCP0530zC2Hr9QxDY6DU0DIBR874xesW
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Mike,

> Since this has been fully broken for almost nine years this patch just
> removes emulated support.

Applied to 5.20/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
