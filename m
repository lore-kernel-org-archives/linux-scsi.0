Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AA16C48BDF
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 02:49:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63B2D61222
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 02:49:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235494AbhFSCvb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Jun 2021 22:51:31 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:7666 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235352AbhFSCva (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Jun 2021 22:51:30 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15J2h6pV016884;
        Sat, 19 Jun 2021 02:48:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=ow2OnqLbwNGYeM8yDYJP45Tdkvy3j0vchcy0ggW3zQk=;
 b=EdDRrjD79PfuseL1+P39yNevzdhWKr0ZJy7B0pW+XzZQ4PDgBcx/Facx03fPYaC+EbBS
 XsK6HICEWs6R8pXJ40ZTC65C+fLE4fmj8y9nNruOuWogI64QtpbKECDO7YfzbLieaTeZ
 QkZrqH3KD4eUJviim7pHIs3CgUZc6FHU3KFhuMD8u3jqQO9s8ztS1Zh4/j4TWTDN2CZ0
 Cgxzk/i7s1ZgIotEZNtyXNbpNtmOB8v5gTf3AgmjPwErZMjYZA/Cs2FQNI8iwOILQPxU
 t1dGBCJy42c6dW74HCTY3HTV5YzMf73Yr63mRa7xljrvumYqJR2BidSQVyCCp3qk6Hr5 8g== 
Received: from oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 399760012y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 02:48:56 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15J2mtow059941;
        Sat, 19 Jun 2021 02:48:55 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2044.outbound.protection.outlook.com [104.47.73.44])
        by userp3030.oracle.com with ESMTP id 3995psb4gj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 02:48:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f9L9rUNVPFZUYPJYiSJ57FzfqrvXAW9z1Y5zhokRl34Vvk0X6uGIU9iHKNB/1X5bPDzCMefwhxB45e8fZrgxddhQ8tj7rw81aAPM+5AShKj1aYlauwydANPTRfyyep26C36yL1NWmP71yWwvIqjB8V+kuaksGPGUm6qTRHc9aPee9FbGAKAXlH3rLYiXGw2bv5436LlC8JYPIz0XPnDY+HGIjXWye5s7ZWeZe+eBIR8KmdlQjDIGHC9QfewTfwLmPzVFtR9lizEC8fnsQ7k0fohxUjBPuZPOogR9uD25jkOFtqdbgMdHMCb7hDmeDJ/syU+4gDJO4ppGEgKjA/Bf/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ow2OnqLbwNGYeM8yDYJP45Tdkvy3j0vchcy0ggW3zQk=;
 b=RVuBfsEkknnDEM1sS0nKHi+U6D6RRGldM+BiFk7hNNa47O5dcpllWdMrRLPg5WiKJXJVpabcFlFv9PffIzvjJujlqE+6qH4tzEcs9hpwaHzC82zOIYg8UAA5KSsXhVRSyvwNxe/3uoP99q1zcz240i5LYnpB210UESNbomHWsdYlsm2MrYBEvGpqShdb9irl6dWe0z2g732kKge7zWHWkc3JBRbUYnxwWUWrum/paQnlOq5kK7DrzzsmfIuvbxg/zpaK119UgwDwxbQBTyY4T1Z8yC74R+KoHGI8sIcSh+/kps5E6EwQto4TVc1BD0W/7xRp6Q6KhrjV9lBI6JvnuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ow2OnqLbwNGYeM8yDYJP45Tdkvy3j0vchcy0ggW3zQk=;
 b=IdN4MgFjDfrasdQWITYY6f8C86pGkA+bQzCYud6mdRy633MjMgsbagCNXvM7Vk9UFRPSeraXf7vTC+bhksOreZ7BA4PSpB7vFeoCKrTgzfGRFbEECFMvQ0mWu8+7gHzAvj1vSAyYYysl97t8fYcd6jat4ubgPBjkl3vb18wlKV0=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5465.namprd10.prod.outlook.com (2603:10b6:510:e7::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18; Sat, 19 Jun
 2021 02:48:52 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4242.022; Sat, 19 Jun 2021
 02:48:52 +0000
To:     Zou Wei <zou_wei@huawei.com>
Cc:     <stanley.chu@mediatek.com>, <alim.akhtar@samsung.com>,
        <avri.altman@wdc.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <matthias.bgg@gmail.com>,
        <linux-scsi@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH -next] scsi: ufs-mediatek: Add missing of_node_put() in
 ufs_mtk_probe()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h7huwovr.fsf@ca-mkp.ca.oracle.com>
References: <1623929522-4389-1-git-send-email-zou_wei@huawei.com>
Date:   Fri, 18 Jun 2021 22:48:50 -0400
In-Reply-To: <1623929522-4389-1-git-send-email-zou_wei@huawei.com> (Zou Wei's
        message of "Thu, 17 Jun 2021 19:32:02 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SJ0PR03CA0322.namprd03.prod.outlook.com
 (2603:10b6:a03:39d::27) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR03CA0322.namprd03.prod.outlook.com (2603:10b6:a03:39d::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16 via Frontend Transport; Sat, 19 Jun 2021 02:48:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3ed93272-5b3c-439d-83a2-08d932ccc600
X-MS-TrafficTypeDiagnostic: PH0PR10MB5465:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5465DDF766D5D9C43C9BAD628E0C9@PH0PR10MB5465.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2/24rPWYndcDSM98KpB/hhztTs9WyCX7B1a+FDieMF2vqIf5wdJeRNZzgjHo2qA1zmQoelwXuf29wQWeW8xXBh8MC4rCrZJ/1hWIj4EYl2yqcF10dinr+x/1KiDTmyf1YpM2TTA+UvDx77vFcm41lNLTp7wmWiy/zFu7Kymb7w6IGUWgY94jrhAdiQpDW4P6AdjDInNfYPlUMbSQ3HJD8kyJd7aEPXAR4NAlXOgoxJlEEfAI7B4GS2f86/owpe50FB+Qs8+wWw71KfzT8iZ1S3hNdDsF1gd6ec7Cw+sRutSK27/vQIkvJaKdBjKrlA7rDnlcmCVUVWknjOfc5gdvnOxvRQowwE/upUGvzKjJPN03lnoJHsQOGp5AQTSUaRApkTjqHKmRF8mpbgNcDpJy1A8oH76V8VQKqnju0i5hZKIq7/8muEfBIS+uSfI7tYjNFNEVZ7xlf5uIj2Wvq0P3vtHN8kr+Qvx7EJPUIYjCeF8gnmomL7pTRtxyFlbfSyhHe2Yhx+gb2ws3yv3MWS7qIOoKQEagThhhUsHcCgLz4MSTutlnh2VSI/g7AOtGqcpVxJRyR71S0czvEWSnLXmtb8khDPvcgvZ3ZfLRmryTzQOTjfUkvHbiX//HYH951sVSFP0Q9zEn4SU14x+GLlH4lQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(346002)(39860400002)(376002)(5660300002)(316002)(66476007)(186003)(16526019)(52116002)(66556008)(36916002)(6916009)(55016002)(26005)(86362001)(66946007)(4326008)(7696005)(558084003)(7416002)(8676002)(478600001)(54906003)(2906002)(38350700002)(38100700002)(956004)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?n7zf90jpAeyCSRMWClkGkM6g2heiMcFnpaOV4qfxD+9WBsrq4YvwpCAHdJzC?=
 =?us-ascii?Q?QWrdWOicOxqL+hDFR7HfwjH+8OYsn/hfwYjoRAjov0MU5yiW4Si/TeZy2znE?=
 =?us-ascii?Q?HjhvvLiPMSsgxTBi0iTvxGOh636OXNI1HiMgkjRL68v2NUsdVcFZkaxOvS+y?=
 =?us-ascii?Q?S+x6WPDixIVswfPk6Y3IEb/qPSZ+HAh31p4skVIWEAfafmIbgPlcXX3rY5w5?=
 =?us-ascii?Q?nL+C0Z2sn/yDjAEvxbhb/RVgzC79Y4/eF8+3dwsOIWh7s1Hx4Szv9FY4v+eA?=
 =?us-ascii?Q?Jc/N9iWtipkXM1JzU4T/2y59KpZCZFRQy3TFqYBDbGBA/DXrK+IlJy78esxu?=
 =?us-ascii?Q?KjPhu7miiErrVdFQJcKX8gYQWAZbmfljzoZRDGD21A0Co671ge5oowcZF/c4?=
 =?us-ascii?Q?G5AWiv9BZmwGwqynz3wnrRTIkALGWTbUq1dFWXHT8N/oQ+MqiGGH7RrMHtAd?=
 =?us-ascii?Q?n51NaX+RxbvWzTjzMd07njX25c7Men45rb/OxqarlSoaUXBon8CCh5W47Yo/?=
 =?us-ascii?Q?zO4YYD59PDp/ZEU+zdefm+vxk9T4//3ssiAUyWYrNJ7pgxKRr0DHq3uAEJlA?=
 =?us-ascii?Q?0gX9+CADk1+09sZ/+HKfDeoPme8VH7YfB5zyumZ9RNkvnVr21bkB+NuMYTw1?=
 =?us-ascii?Q?AAQkNktSypzgQVEENViij6iNfb8JRyAGtHUw8oeVKoLXqdZbLmPkr6rhhvyZ?=
 =?us-ascii?Q?47EJ2o0uU3rWBfz0YQDKulg4Q5rsH776UuOmOdoaLmXJ9ibBZEPs2IfYCHQX?=
 =?us-ascii?Q?kojp/sZFv4p6N33agTPWflSuA1NqtGpvLg/C9qI+jifyv+neAuZQbyNJx8y0?=
 =?us-ascii?Q?ioh/RjJWBUpSOmrS3T5DVgTDVTdfPGRjJ8QX+oqOskophdWmNQAH81WG8clq?=
 =?us-ascii?Q?K6jwUQtSZOtkekkSrdYq2B7UXS+TRXJmTSo6bf4s9IZdk3kbKE9hkAi50mOF?=
 =?us-ascii?Q?IcRFNTQ4l1Fi/+Rr/yt/rthdVQ4y/qCx5pHT5qWGeSCnJogPI1R2Rpx0zv2D?=
 =?us-ascii?Q?nnDuv1QEGiqBQ0x6/IVlWmJvWzEgfCFp9QyHAwxT6YvEqGPI9eAcgCfDtCBO?=
 =?us-ascii?Q?CipgLaXqrGh8FKB5u0UDa8/S8UYwh2J3YotF40qOU2AtWJVLqWbucB3al27t?=
 =?us-ascii?Q?WqiFBE1G1iTqnz0uQ+n4N489SoHW5EWEoudFKs7Wp1p4uzKf3EfSt7ExUQWq?=
 =?us-ascii?Q?aGxmk5LE/aWc4aLMSwQFDBlbcU9eHpwl3qQ0xRRBV5XO25aejLebpHMbA/PZ?=
 =?us-ascii?Q?shokvgOnrvr5vQw2mSHBRwuWN8ukMa7tN7L8ZTayujplWQRhDJ3cZ/P1aTU4?=
 =?us-ascii?Q?oYtxVfCPUolvR32Qq9fCFhUB?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ed93272-5b3c-439d-83a2-08d932ccc600
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2021 02:48:52.7052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tm4zTbhdIaGLSSxYfFYGJKnCgQidMSNPfYQJTG8H9nzGCD2fKNLCSkw4w790GnHcTewRXg68YSHJuz5GJzEIhk0ejkriJ8O+ioaBb1ltbVo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5465
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10019 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106190012
X-Proofpoint-ORIG-GUID: ysG_mcHv5xN1Z6v6T6Ge0HWtyzLEjzA5
X-Proofpoint-GUID: ysG_mcHv5xN1Z6v6T6Ge0HWtyzLEjzA5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Zou,

> The function is missing a of_node_put on node, fix this by adding the
> call before returning.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
