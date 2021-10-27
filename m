Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23857C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 15:44:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F074260F5A
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 15:44:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236649AbhJ0Pqp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Oct 2021 11:46:45 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:7324 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234704AbhJ0Pqp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Oct 2021 11:46:45 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19RF1p43028933;
        Wed, 27 Oct 2021 15:44:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=NP/b8FPCfFnn8sHIFNN50VueCoZAwfR1q6u7PJHInew=;
 b=bfyk57NOgI5J7cm6j2OgkQ3ecWLogqPtFKqzfWF+FAqec0E5yMwBjJm8HKX3XkzacaIH
 y07ducq2Te1ETz1I+ITbS6EYIGulRZ7WBQCmsVMExjlnUpc+8+J+w1rOBaDI8iJoYMoa
 w1CNGPucHquPheWvQbj49z3xowfoDQSO2rDlk8CkhtAZSkjGlVizqP3/xR+XLtaJDjAo
 S4umJjyvn+jrRV02j2RRpo/aiIJ9Vywt5uV9k0Pqh+ZJ7gtdn6AlnETQef1MIn5EM3Bh
 P2yRD+6B0RObll1ivPxFYPHfrkgVs4kkHOjjeFwwSxIbnioaB44BafWJ14HrbLRffyVb Fg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bx4fjm21t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Oct 2021 15:44:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19RFa4UY074972;
        Wed, 27 Oct 2021 15:44:08 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
        by userp3020.oracle.com with ESMTP id 3bx4gr99eg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Oct 2021 15:44:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b1+wRNQoUCyUMrqF1cZLcU449RZ3PwrbugG0kKa6s1OSbSXxwkLHS6l/G7URpZyvqcF4CyO9ZjNkAFFjuQQUrRfMFnZT27Yv3D+oxNXJAJ0ixvt2c62l9qkXoteXitCUm6L7jUbcwBtfbV+2qxQMuyVZZxKK9GtoHASMPx9OeuPFz/YLDglw2F/6d2cqxEDNXJ7XsykRp0XW72gGHa5XKhEXqUY+xcwK0apqTsutfw8ILJbHrztfrdeqFVVjdrRTFyn6RXrhQjZRaNXfVY+vp0g/CrlGJpWIQjjZGnCKc7woeUVc6ZU0VO7FjAkzhNfcOkPg/DpzsNUdaMlnTT1J3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NP/b8FPCfFnn8sHIFNN50VueCoZAwfR1q6u7PJHInew=;
 b=nFp4TN54gfUyBqMVWpFe0USGMtCqs3M/Sdq9e3faIUVA7SkcAt7dVIhWH+5S4hXeUirA0o9Hyacp+Zp1C3j8F/7nt+T2zsi6qsiwCwH2LPIre3EIUW7FO4N/6MTX3hVccDC1k7uj6AHu0jyxFHP0iBNlXZC0GSZ1dWCTIecSZ5y44kOdwM93EKUiATAvLoGEYQpAhtdyzSW75x2ZVCGpDB8APdLBtA0llsF0v/IpgO7LRxf4VjuRlCQT1MfC6eO43MTIUySm+8NnGwOGjTaPf6JzMJLIWvsR/xXQ14GMnA0Dty4LDthpPV9nm7IjF0X6+8ws7f/cUAUtRpXFvw24sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NP/b8FPCfFnn8sHIFNN50VueCoZAwfR1q6u7PJHInew=;
 b=nXVmKoWAEqdboxxb+p1mC1Gd/6a3NcSXoNOvcVQBptIA7EXSWJn25Zlbvn/qcXMKGU7cBbsDpbCOFYiWB22aUooDZu9QZIjelK7gU4nS5iDe7I/Sm5AHc2xmKTkFl3aVpg8R7eUKZpDGaHJNuNi0y+BaG3IJjI4GPfC0x8fvJXE=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4792.namprd10.prod.outlook.com (2603:10b6:510:3d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Wed, 27 Oct
 2021 15:44:06 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%8]) with mapi id 15.20.4649.014; Wed, 27 Oct 2021
 15:44:06 +0000
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: mark HPB support as BROKEN
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wnlyzday.fsf@ca-mkp.ca.oracle.com>
References: <4438ab72-7da0-33de-ecc9-91c3c179eca7@acm.org>
        <c3d85be5-2708-ea50-09ac-2285928bbe0e@kernel.dk>
        <36729509daa80fd48453e8a3a1b5c23750948e6c.camel@HansenPartnership.com>
        <yq1ee873av4.fsf@ca-mkp.ca.oracle.com>
        <679b4d3b-778e-47cd-d53f-f7bf77315f7c@acm.org>
        <20211027052724.GA8946@lst.de>
        <b8aec3cb-75f1-3e1f-1dfc-5d77322b736f@acm.org>
        <20211027141231.GA2338303@dhcp-10-100-145-180.wdc.com>
        <YXlqSRLHuIFiMLY7@T590>
        <3f43feaa-5c3a-9e4c-ebc1-c982b0723e7e@kernel.dk>
        <YXltPgRTxe+Xn66i@T590>
Date:   Wed, 27 Oct 2021 11:44:04 -0400
In-Reply-To: <YXltPgRTxe+Xn66i@T590> (Ming Lei's message of "Wed, 27 Oct 2021
        23:16:14 +0800")
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0046.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::21) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.21) by BY3PR05CA0046.namprd05.prod.outlook.com (2603:10b6:a03:39b::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Wed, 27 Oct 2021 15:44:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4720e514-a910-455c-0658-08d999609c31
X-MS-TrafficTypeDiagnostic: PH0PR10MB4792:
X-Microsoft-Antispam-PRVS: <PH0PR10MB4792FFF250D5521A8ACCD2808E859@PH0PR10MB4792.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C1QLQCjUGGyVYAp/vLrTdV02BOls7t65+tNAcB9UeMOU9qDC6L+f5/ByTc2f0zfI8v457+jX3CoMMdfMRh2wr9y3+oTunSClTrEdRZAetLAWMlyhKmL29pZ1xM2qETjTmA7PAoRKjJUcfo3p+N1EnB/gv3/abEbGTZv9ueEUQch+xPe1M7FM9PiWyMfM57VJETRp/ZDyc0IoOWP7Dm4xgB5x7jfoo+AdllR7HAYcP2Gm7qOc1Ihx4LtQn7nAtpjSGggdOYMWp+WdNI5je4gOA9xjkFBuDanlC+9vGrlHSKtbValeajZN35+CxpADzL4Kmf/cd5MrUyZ7mbzw8QorbpERjFtjtPF4Y9P9c3AycKs0K9snHDkrhKMOXf4HpGYsUkdxGyBHQ52kV5r/fpq0AVwrytgp90nyq/cITic/LgVHdlkj7KNJ0xZ7562qGOFMxPX/URWY7FsA+m5g4YMgHF51tPgggb5OD5BcpCCshUrsizSyHIrFTYBq3TJx1S9w2vTtws9qlpUHuYVgDUy/jbqx3sYmJqiwwhlY4AGjEORIXsvyczFTeRB8xJQKTNhD5qBHc+SFj2RSAx5bx9cVlhaLG04Eb0iPMJhKGPoctvX+W6bb0pZPUU6hGxm5TC8FiN6czY23wioF4bcGAglpsutUd773hIc+VpupIUQtG7AS0AlFrCKYPmSX7Nk3xg1AFCFbDMyu2DXjItev+fD/Wg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(7696005)(316002)(52116002)(186003)(26005)(54906003)(36916002)(86362001)(2906002)(5660300002)(6916009)(4744005)(55016002)(8936002)(7416002)(4326008)(83380400001)(66946007)(8676002)(956004)(66476007)(38100700002)(38350700002)(66556008)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?i5M7uEHMjYlUMKifi7og1Jnzbjs8FbEIYAzYScXGltEWVuZPWv2gsvr8Fijq?=
 =?us-ascii?Q?5IhA+Xiy4yDpqh91KKHg1Q/W64w+9xz7piMmHCDL67hOIgDVQ2ol/FNr+yDw?=
 =?us-ascii?Q?PRcTy2L9OTKiQ6L+P1w0+XL5KevR+XiluUjSaUTQ+5KcQnH/2hwZf983eM24?=
 =?us-ascii?Q?whT+9eqQ2tBX6EeKn5joHTi/ngarnIcW+34IOGJPYaTFHo0bxVDkfyWHt8j5?=
 =?us-ascii?Q?rkkz1zbH1tTtlrCXOIKOmzFhaDY73BcrglgUt5/0zHP8KWXiVqlZZqvfNPSX?=
 =?us-ascii?Q?QSizud9qgLdda/W8a1qli8W9AMQm0ICDXWD1A5xjuJ5SGt9mliNHwavsbqqg?=
 =?us-ascii?Q?4nN4tpcSRRxA45Je2U2uxEsHFTL5Q/RcTgls2/4tKp46ziygQ+TWjZ08aZhu?=
 =?us-ascii?Q?fHG61ph6nBezDLN5xOEtRFD1QV1Kl29Zs01RVv602WpWJCy9PncRyizcDPkc?=
 =?us-ascii?Q?3Eug+YU++PsIp2MdAJB94L/ciNCP9hNv+hP+U1QlFEbhpGySN0vg9KeY8DDq?=
 =?us-ascii?Q?Zj0v3+4ZHHZTDAS7Kv+fdgt2VCmhthuV5gF6Tlo9pvC1UGNSvO6+NyRxbVDz?=
 =?us-ascii?Q?TtYt3nvlJcBIyNXLK/LwjrZUzi1aOEt+BCPaI5b0ciOMLYIoESzd6tDS2EH9?=
 =?us-ascii?Q?Y0+6FDA0LNjey5QmZT3FH8jY7kfTLFTXaITED8CxXMyikdwElZTTTp/CpZhV?=
 =?us-ascii?Q?r2g2ZYkqD1iSSRTIvXnJfCzF86iDLLnsT5EGXRDzjTk5qfyFV5y7AD/zrL7O?=
 =?us-ascii?Q?JfWbEZ3b2hZPM6IOZqabUSyxYkN1/4O9ZGIyX4HelOfxUXGnR7bt01ZAdMW7?=
 =?us-ascii?Q?OHV9U6TieQgO7yvpHYyF12eoq0eRKbTgeMzV4bV25HPxWimPUC2JaXoLt8wq?=
 =?us-ascii?Q?mBuA8yDhIHrOfGg8wmxZ80JwokrfTgWVi8kuVHiGCDZwnhQe9VdPcmEYu3rk?=
 =?us-ascii?Q?zF35DHUQ2Ce6D9xl31yy9EJ6XhMrzuIR9h9lvvqoBGRPZpYk9OPD6TTWPWVQ?=
 =?us-ascii?Q?5IUZupApNZv3sHjiLVWPJf/d/ZyjcD1Q3afHTJd9fvBJS32sYHbIBWVJbAqQ?=
 =?us-ascii?Q?rLUaU+TiipuK7bvbVHL9DZlEY8QL8pbGXlnXhsU0EjQbmtrEn2cUxlqn9dAX?=
 =?us-ascii?Q?7CO/K0FnixLTDEBy6SzjK3ZZc9K2EwdyhLgAdi7Y7oWN8DFwkcxf3MtXaWro?=
 =?us-ascii?Q?QZ/IXNAu/LmI6kXCk5zIiHTRF7Xz70Xes9Dj/YrpcsdvNI9b8QU6oYFa2jdW?=
 =?us-ascii?Q?xCspYvYVxVzxy2Erf9wTn65usynHm5XM9pyfyCfxAc8MzjtslVKQCeQ5N4Ar?=
 =?us-ascii?Q?ChrSkAOreMZY90UrmH+Jrqn9uKxF/pOPIlIcFN/gskmYwfEW2LNWiWoG/rX3?=
 =?us-ascii?Q?1f7wa5n33azqmEbGGML8cIJ58wJcPsVAdbvyiUjZmlQ4gHKMGCNv0CCXZAFV?=
 =?us-ascii?Q?BH8FNylMu/tXYmplbUxBcm0Y4IUnKs2KUkb4ZpF1bUb2lqfaDtXW9Vvmt14q?=
 =?us-ascii?Q?XiBRj0vS5JvEfKRg2xmmMhxePVgPYyQCWopyZaaInJuwfc7i65HrEwUpyD9j?=
 =?us-ascii?Q?JolwRSKo9RSObpOwuFgKTUbynMd4p1fzx3eCNKYmD/x4VRpVBy/UmzualehK?=
 =?us-ascii?Q?ZvWIks/PrrqGbicjYO/hzPL+SuGvQTBcIXpcR6MgEhZlEUySQl6rSiv/dcA2?=
 =?us-ascii?Q?XGpWmS7y0uGGBEkzNNt6ZOHP2vc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4720e514-a910-455c-0658-08d999609c31
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 15:44:06.7179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AD2rHTIPFGb8/JZuV857apsf+ZUOKmzj0g7EFeY73/CM6LhxDPNkw//dVYKv0MWvwzH9KpDWgGsmzQwCRiMEN57uy+/dmcdzN/IvagaD67U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4792
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10150 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110270093
X-Proofpoint-GUID: H8cc723TxntrDAQ3fJJkng7lvOwchK-k
X-Proofpoint-ORIG-GUID: H8cc723TxntrDAQ3fJJkng7lvOwchK-k
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ming,

> request with scsi_cmnd may be allocated by the ufshpb driver, even it
> should be fine to call ufshcd_queuecommand() directly for this driver
> private IO, if the tag can be reused. One example is scsi_ioctl_reset().

scsi_ioctl_reset() allocates a new request, though, so that doesn't
solve the forward progress guarantee. Whereas eh puts the saved request
on the stack.

-- 
Martin K. Petersen	Oracle Linux Engineering
