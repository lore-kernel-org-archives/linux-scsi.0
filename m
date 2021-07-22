Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEE0EC63797
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 17:51:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8D4A61408
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 17:51:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbhGVRLP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Jul 2021 13:11:15 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:3998 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229697AbhGVRLO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Jul 2021 13:11:14 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16MHUxx7011577;
        Thu, 22 Jul 2021 17:51:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=hvLrbFXAYgtLYNsKg/3PSMtPecZz013WFIfhXyhReyI=;
 b=jeqI0UkNF5PR2/2dxmyCNUsrfmk5HbIjZpBZY21rWcUoLVQ7wTs7TgNtBifoPLq6OMLp
 IX8WoaJ6+X4QT19FGezm1NyleymJrvvybbloNJNYemNQ8JRC56i5nBhlldW7HhmqBN9v
 G520xRtCaaS1VYIvbKBEyKcB288EwzLkVxCxvYoZ6ImKusTj9ZuiHTjKb8EZ3ShVhU3h
 ERjqNtUvXji0KVBr3ADTx+y1TQGgrbGHmkGYp8//NakEQNntn8je3TR5eJ9qt3nmaOaZ
 GPmA58xVX9pROphMSf83mieKgLerHXvmzJs/nnSBL4rv+MXU3yeHeNSByj8zMgtgq9ty ng== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=hvLrbFXAYgtLYNsKg/3PSMtPecZz013WFIfhXyhReyI=;
 b=e9r419/ePOUfgTMkZ9EEKtoH0JzcHlDw6g4y1eDoWPypCTOm1qEEKZh9dPpXDiJ5nTdh
 Aex+oRnXNFtFfLqsSQXCZcGT3yrL3KRlrlH3E4TZLNqcYaQJA5rgfcyKkr/qfp3iXIhi
 6CvJRI0av8325kCE0leFpJe4dTUbtiMB6gkhokZKwHL0eKRkmaACi3qSoSGo73j8ybZL
 bQ2Mm5SR/G5W6u30+sg1rvUS0+7069iWgxE2hev/QbPUfhGVgEcSSJIZeuip0asUsci6
 7JmYNr2D5UvRTtT99te7kUrqilbFwi/pJGVdZinbxISyLx2nAvmr5RDqJfwkTt1uSvxw DA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39xvm7t20j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jul 2021 17:51:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16MHUV2O098095;
        Thu, 22 Jul 2021 17:51:33 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by userp3020.oracle.com with ESMTP id 39v9010swx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jul 2021 17:51:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VXSfUsP8VweYd9pGR7TGDsJfPJUbSDPI6FiA8nwzwD6xZo3QnVBrKG3JYKIFVQnleX7fApZSVK6SAfACiFea7SeoJYKLPWHpAShInrvFhca+Inmb59iSCgY5ZfxAOlc5QCz6HTKhdCdyLruQ+8ms07hfbyYuGooCJ2XgneYnYBbnsCSSafS+7Ouw5yfq6Zw9rxHuLQI9CK1InXJIoIqxZq6nfErCtBH+CKHAEY2VESxuviTi85gEsj9Dy6SDpgn040CSpQPiZkRSU3Loba1MjfaCwSCPhLrJ19oPDu43DhCYiRXBLpX+om5Z2tDUw3a8qdndUm0KTx/5ZuTXPFDybw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hvLrbFXAYgtLYNsKg/3PSMtPecZz013WFIfhXyhReyI=;
 b=csqtGCSj5k2n4l3FDJrlhGzubAKOZZSYDiyR5d+WKKCbFgRWGIpTyU+3FzwDSuWQ/lQ3kIlzliOvIb9K3h8Zv63CMvPXjvipMNfUuEF0uTpfnL3KzE5pXcjyDsIVCLW31zho0smRREoNd58EKGaQjEoV4AepnXdI0v2PzszNRcuRxWIdaIyQe8YTcpgdk9s0sQUS5Mmf645vP3YS0zCOPYWNU6QE4QwnZi54TAavyHK10yZSKgoo53B3CsAMsUaxQf+/9qOpG+zgDtZlfPSrEAbzDo2vBMWKD1YnA8XD5qu/lFDEjAKfl7mgnRePFq67keP5OQrRnyjF85ntqL/g9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hvLrbFXAYgtLYNsKg/3PSMtPecZz013WFIfhXyhReyI=;
 b=GCKpJLFmS94LcxL06A+YLr3WFjh0KqDW9UtEsqRSfkCcwT9XGbj1tcN3b1AsGFFvs4nNegesgU7UXUFI8yvIEBFBG97qNODQ4VRCRUqyPgqo/Wk76ZSJt7Kt9vuvx9slyvvvNo4C6RUK4Cv+872NQkkZfareMfH4qSZfKLtTnac=
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4677.namprd10.prod.outlook.com (2603:10b6:510:3d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26; Thu, 22 Jul
 2021 17:51:31 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4331.034; Thu, 22 Jul 2021
 17:51:31 +0000
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Doug Gilbert <dgilbert@interlog.com>,
        Kai =?utf-8?Q?M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 19/24] scsi: rename CONFIG_BLK_SCSI_REQUEST to
 CONFIG_SCSI_COMMON
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1zguew84u.fsf@ca-mkp.ca.oracle.com>
References: <20210712054816.4147559-1-hch@lst.de>
        <20210712054816.4147559-20-hch@lst.de>
Date:   Thu, 22 Jul 2021 13:51:28 -0400
In-Reply-To: <20210712054816.4147559-20-hch@lst.de> (Christoph Hellwig's
        message of "Mon, 12 Jul 2021 07:48:11 +0200")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0021.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::34) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR07CA0021.namprd07.prod.outlook.com (2603:10b6:a02:bc::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend Transport; Thu, 22 Jul 2021 17:51:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6b88cba2-ab42-4484-b4ce-08d94d39567d
X-MS-TrafficTypeDiagnostic: PH0PR10MB4677:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46773B28AD64F7C593A2EC7B8EE49@PH0PR10MB4677.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L/s2iGFYmjDvBhhMzFwb2PADOPNUyhT5MU0hw/ckxHr+rzF8KW8pqlUnoQYWh+Re8yZWFNDbk28qbsBtw0FaIP/bIq2ivA+WxVurnbQ3GD1uza446aO+krBbrwpXnYBq4tAfx9lUIO+jUomYTo/MdbPAaslnpjxfNX9xEl07sp/S/c/FqLy86v5Rut2PQU8ZXy+cB2XYCAxFfBzJHSaozc8gHkcvVeIaazHZOGiHTdoorgtSMYqr8sTeOPFRNwSbfejx0Z1lnBy50PbqzSbWSXopnLHwAK1az+EQzjYjzxJ1+bqkdAa5OdRBFQGSdQtW2IltNw+i2zjXh19a5MThyWrMDJJaSXmgsK01251Plc+WxejltsdYo6QRQDBMg7i8V2EuuKMhTXlAjCEhlIAX4aqFenF3bOeEFHcIcNjY19SzC38Ywo78QrtMr0RnY1NIZ8wzNDu+G7Q1sXwJJmYDwwuqWpHPgEFpcwobv1XjHNY2zMdGCMnI4ojL11v5g4le5a/gVfXWKpjIkQyeQBkFDGsMQlBaXHDloGiYKNK4ibds++XJJ0ZBTdra3SO6+78xvyAH0lTPDuoaeXJ8d8NECXiVyoR31hqkmMakBwpbUenMn5UbgbAq8sD2Sf08WKPGbcsBGaDTAlun7K6unI31Hmkm5/xqfaApl7udzieOo9UWs0GJ/keoQOh4cX7735GU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(39860400002)(136003)(396003)(36916002)(7696005)(55016002)(52116002)(8936002)(478600001)(66946007)(38350700002)(8676002)(316002)(66476007)(26005)(38100700002)(956004)(186003)(6916009)(66556008)(4744005)(5660300002)(54906003)(2906002)(83380400001)(4326008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NU39KLDGbGcdEeSCNwHvJHbh12Yei/zK4Hs01i03PD2iKMGjD01cZR9l/Pog?=
 =?us-ascii?Q?4gKLPTGH6v4l7DtE+9SD9Th6yHG4zdylV4wDa35vTYTmabszj9tQ9gQ/1vzE?=
 =?us-ascii?Q?V8aK8HMG4cRiapdBXVDj3+3/lX7M9HhJpfu/YclBYUd1MOvp4tJbSRpjEBuQ?=
 =?us-ascii?Q?ct30snET2ftHqUgfh1AdvtW4g3SfmlOtHdZyMj1c3h3EWQgwVx1jUUqxVqxH?=
 =?us-ascii?Q?hJJJ54jVVrJBwgKnS8zk6euh8i5lAq/3qq+usGgxqBnaiH5Ah9j8d59BjVka?=
 =?us-ascii?Q?u2ML1ROS2gTCTn9bg5xPXfMNvUKjqDxJ+sSdFfXt6JRbvsInjrFS2kNupBgb?=
 =?us-ascii?Q?vTB+qzq7NnBRKr2IxMSj8UYONvdnynY4jJRNjwilASyFiroVIK8mHEwDDeqH?=
 =?us-ascii?Q?V1tMyZmdMBl9vdLLP4LBpirPKfNyw21SARGp8C7svVU6bcU2xpDD8reAvgpO?=
 =?us-ascii?Q?5kxLD3uhBwar/4k4JMoRxUn4m9MfRQtf4zaD2nMarVxHoBklXfG+2YbtERjL?=
 =?us-ascii?Q?139uQAaaJ7n2pWmJCQtnU28tA/dfooa52l65BYeJDUVbE/bm/Oah/BMBiusd?=
 =?us-ascii?Q?EzhU2JnokRxNHeFXhk9ZyqTPUn+0zTdew/Yq1njfZNvDyjcrEFOERRczv1Bu?=
 =?us-ascii?Q?6K/iPqxXFeB3fOAfoz46PSIgiuTYoIlawfvVG8Nc2wV5blIYGaIQYxx6xcC2?=
 =?us-ascii?Q?aZHExzjO6nPTczv/HTsP+41uHQfiTlaGT4WrgBY2AG9WARWl6ExP7ZduCtZi?=
 =?us-ascii?Q?Dlh7sO7FL2BvtsN43sRbUhANsK5ed6FSGGHXSHurJ9807N8m4y8S4gtNF1Xb?=
 =?us-ascii?Q?TV4vk6ocJMTWO5NpplSB0SfFlURU1nYH6D8ZI9HO00P7wSsxUV61ylD7i1XC?=
 =?us-ascii?Q?fkDxbRPjPi4elE59+m2gj98yQaujR4kjkFSt8AmSSNxZnOzotlcoRvZ/d6D/?=
 =?us-ascii?Q?AxT+TouuNL41uFrs8JFmpna5VVQGQXRyU6m715y7AdwvGw86F9L+Ct9OZb98?=
 =?us-ascii?Q?aG6OwHslPI3jcWo+VBtAwZvm0gzLzyGDhoal7Ff9UI6pDyf8sNYf3qUL46SX?=
 =?us-ascii?Q?n6Lkuq/3BhWt0QfqNKTF4KZzTu3eYvLYRNF5Zjs0lgQ8ai0Tch8ZhcZLafSr?=
 =?us-ascii?Q?cZ4XbvnE+kbuu3eDvDuSlrvslYJoH8OoBNBZGGQGu4JLGZfOamzEFtg5VoED?=
 =?us-ascii?Q?gcxM85k+fQwnVvxzAwZv7v0JQKo8fJNLlEVK0rInt3IOAP48me9LJraQvq6/?=
 =?us-ascii?Q?aFjqNzb2Sux3PhDADhY50NYEut5L/4iPTRUnbnZKAjs8/AcX256jed3h7+4L?=
 =?us-ascii?Q?R2dGhmC0zuYV85p5RiizOLiM?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b88cba2-ab42-4484-b4ce-08d94d39567d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 17:51:31.1051
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LflZShP3X+gZSgSbSz7qkwdLbyBbS40Lh4zQvgAuLEauBAMTnPvL+IOsaAoK3AP5ZxpCAPAUxw04On7GeRN+hzLznJn2fEMLyVWASvlAPUo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4677
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10053 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 malwarescore=0
 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107220116
X-Proofpoint-ORIG-GUID: wr4oPuT8hTBi2FbKEV57haG-WnOi5cqe
X-Proofpoint-GUID: wr4oPuT8hTBi2FbKEV57haG-WnOi5cqe
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christoph,

> CONFIG_BLK_SCSI_REQUEST is rather misnamed now as it just enabled
> building a small amount of code shared by the scsi initiator, target
> and consumers of the scsi_request passthrough API.  Rename it and also
> allow building it as a module.

Build now fails. Needs:

diff --git a/drivers/scsi/scsi_common.c b/drivers/scsi/scsi_common.c
index 8aac4e5e8c4c..4fb16e70dddf 100644
--- a/drivers/scsi/scsi_common.c
+++ b/drivers/scsi/scsi_common.c
@@ -7,9 +7,12 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/errno.h>
+#include <linux/module.h>
 #include <asm/unaligned.h>
 #include <scsi/scsi_common.h>

+MODULE_LICENSE("GPL v2");
+

-- 
Martin K. Petersen	Oracle Linux Engineering
