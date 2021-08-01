Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81A88C4338F
	for <linux-scsi@archiver.kernel.org>; Sun,  1 Aug 2021 17:22:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E51761075
	for <linux-scsi@archiver.kernel.org>; Sun,  1 Aug 2021 17:22:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbhHARWl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 1 Aug 2021 13:22:41 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:35906 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229592AbhHARWk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Aug 2021 13:22:40 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 171HFppD002129;
        Sun, 1 Aug 2021 17:22:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=/ycxUdoWXFnpZ80anapPOENzUJ0eQJ7ptt7zwHByAzo=;
 b=GwVOTwhrIZgENeOsoEM7Nv+EmJ7ly2lqvQZs08RGNZWV5r7jhIQ1IEp9PIQfueJ/CK+X
 Ptb7YPVmCBuF3ZrGFBj6DXodnb2ei05IJ4F81lkI8FaMF0FyMogYb3nSRUttVfIRFGG5
 5lFtMPEqRLxH8pnF4YJlMFeZTQHBcPlxmJJ15Xtz5Ijm2Q5uAQ/1vOkzxYAi/NBlTuVB
 566nXYIV18v/BkWR2rUTdRsSdIDcx7RJENXqWnPeLRMS01604qf5VN9xKwvaCEaIUKcQ
 46AAij/dlgcm9v4NT7KG8Mb8sOepuPBXcX4Seu+9Z+LqjHHfsQFjsY7T1PwWvAKOVeff Cw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=/ycxUdoWXFnpZ80anapPOENzUJ0eQJ7ptt7zwHByAzo=;
 b=fRBLz7QYUUN1MGt2S6D6/fNDu0KR3t68i+2Zu+1n30MozuK6UviIgw2ZoxshOAnEizaF
 wHFA9p9z9RWkhzfM5/jG4m7Xn7M6L6KPhzC4FC5nZ7U425lxbkimTESrA6EkD0LbHPqq
 TgZ1bmWXoJ+TFQX3iZA4bN65nQ45We/Ai240wmQmXOAyTEUA5LrbbthEoTW3g2BaqDjz
 E40xi9vT4yADSlEgpc99U/GAVvnSH23yi/HBTZPca9ZXaoli2ust4a9SRbxaKHTjYGxK
 iSuQN3UR0mCVvJB6vShuIF0XBaG5WkvnuS6BcKGzOAo32+1I+wPdiaGCUXRIYZWNFtyj yQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a4x4s1p2v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 01 Aug 2021 17:22:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 171HF96i059804;
        Sun, 1 Aug 2021 17:22:23 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by userp3020.oracle.com with ESMTP id 3a5g9rrb8v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 01 Aug 2021 17:22:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W2FaBZxBBzImjeJ93teQfFLjG6ym/EcWz17QT96ZO5+s6wFZFyZarRhjnQwLPjUt39Rcrl6Gq5PY6BRqSVq9NfnbSV37/wMctla9gHmT/u70mW/NDPc/Gl2PrLXIZbqyiJenVvR3iONoF5+S+BuafKF8OIFzxOccEUutMRe4d9ZG1RybfNddoK14CMvbCqeE659xiUkXmO04CA8MmjVP45qOFbwdYGZ73umjEHomeVcSqmFKS1CBtBbWif0L/nkirbMC1JPBG+NDBv4GMqcRpPMk6xvBk+1/NNVySYEHYruHJT8T/LrU0gi0ZE9/S/BbXBPhAntZ51V3duytLt4Jug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ycxUdoWXFnpZ80anapPOENzUJ0eQJ7ptt7zwHByAzo=;
 b=Vmt89CLeVvy6g/c1VsXfZUZgTNC7uSQK6s38+qBSw25TSp67033dgYdH+SApluuIFEcLFyQXvhLt/AvoatwKNsSQNdTD8brBv8vLL4jk1LSAwb3iFHRqS9cUJetvEE68E7RP/2ZLrRYF8EUfePkIEn39wZAM1nkSWiTkMh48zn5RcTlbRIlNa9xNgJIIyrl+xbMwaJKmmUcj0jec5lFrHPsEBwOawXTOxPn9N4nsL0EU0wQYlvcQBDbO51Rl2jxsjatliUBOvC2asBKsMBdGPfxYSs5afwyJVDNumSDrAFMDTU1IMr2NK9Lovh0gY49OPeuqDOJnbwRH30Fr8uxiPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ycxUdoWXFnpZ80anapPOENzUJ0eQJ7ptt7zwHByAzo=;
 b=JoxsfD63ljfRb4QsGSpd3wGmC5J6Cpl+f8Udm+1hZcWzGxu5jFLRTYDhq3S7x4JA+KzEBNd87t7aXwzY/hMXBNWMg3w4hvXM8dECnPWUNcUlF/B9O/X8e2b75bEsS5d+zdagfwF2SKN4jmpYCFGbkxjPZ2oWHqjU2Wj2CbIqJAw=
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5449.namprd10.prod.outlook.com (2603:10b6:510:e7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17; Sun, 1 Aug
 2021 17:22:20 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4373.026; Sun, 1 Aug 2021
 17:22:20 +0000
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: two bsg fixes
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1sfztkrlq.fsf@ca-mkp.ca.oracle.com>
References: <20210731074027.1185545-1-hch@lst.de>
Date:   Sun, 01 Aug 2021 13:22:16 -0400
In-Reply-To: <20210731074027.1185545-1-hch@lst.de> (Christoph Hellwig's
        message of "Sat, 31 Jul 2021 09:40:25 +0200")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0018.namprd08.prod.outlook.com
 (2603:10b6:a03:100::31) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR08CA0018.namprd08.prod.outlook.com (2603:10b6:a03:100::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Sun, 1 Aug 2021 17:22:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 496984e0-cea8-41e4-dcb5-08d95510eafc
X-MS-TrafficTypeDiagnostic: PH0PR10MB5449:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB54496FE09625480FB1AB74F08EEE9@PH0PR10MB5449.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 01kAVdCBizOEM/ZzWzZ2XjqLVpcR6xQu0b27QBg1AWXrDPcDI7HVKUWDdivwpxQyWBANMs7mKjku/sieapHDMbSDqEX3HOermco8JgWSjBRd7SNOU2AYuCiJB6t91hX2WIWGqcDfNAG9wgaPcfyUEHfY3soMhEuzDnKjw2U2GBUVMjPjQiTIxALw8GzsYLyAIM1ACd8r8+mSt9jHc1G/YzpBChIZM3d1P/c+vd2BOHGHY0ZVGQVCV+1R9PveAq5kR6h8AxVD4LdG+r+xDgw3jmmmHXw5SHNyl/He8XbgN3o5kpyRsfxVxEMqVkc5KB4bQyFcAstx4CNsXVQwPDYNPLlZWFC44fg8xahyMD2jCbkBEZSDuO4Enz6vZdsFH0aWpMl6hcXW74sTUe18t7UvxaA1XQ+mlcvbt9WsFQwbrMmu9uoWjnsVhaonHGNgKofnqdFfpJkkou91hvj7xiiREQP/ZlMq7xtBP03tR6rJqyao66dgcxHDv4r+rsrL7E0J1JtCrcLo3mqDkCEyLLty6JjhKO+0sBa5805+SH7Pr0XzqXS/tPqx/eK1u/+WnncuUGJgo1/4r5yDvGQcEGNaAnRqSHIGijaCqZo0wQKt5TAe21I6rIysyH9n+DYIJ4Wt2TfVSLE28l54JOUOx2XYBxflOwlygmiSGiENBnnc5t12FK7tbo+083SWdiYVmvVTJvgmt9TUWO8LTAnm+wtjlA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(366004)(346002)(376002)(396003)(38100700002)(38350700002)(3480700007)(6916009)(54906003)(956004)(316002)(26005)(4326008)(8676002)(7116003)(8936002)(2906002)(52116002)(36916002)(7696005)(186003)(558084003)(478600001)(66946007)(66476007)(66556008)(86362001)(6666004)(5660300002)(55016002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HMT8vabsiUjhAfXk2tfNWIhPchTDDz7aUhmzZ9RoMXmXW0ep9kQ05CDDltSw?=
 =?us-ascii?Q?y3WTGNJS7MI9KSwwivFmXOieh1nNSTTqvo5f5UknU/DrBNRIx+ljvk8nCzl8?=
 =?us-ascii?Q?NWMa6U2JuIn6T8tqC3HymjoG4iiDoLkftdY5lpOw6ZZafSRLgxixtscvR2PH?=
 =?us-ascii?Q?F4CPENhp5Y+KzCWW2A3RljXC/f6zo1KAIZd1CvR2Q16H97b84OzLpMkYF+0N?=
 =?us-ascii?Q?A4ymqHHNJiHRZH5l2QmzZmPwakL7oU7urZSYwDmBRFEwizdEn6i9/Ck0dxXn?=
 =?us-ascii?Q?VBohoig3wDGoK4IXXOopSc4k5QnU7en2HFOnCM7iEif/XVfHQuqfenVaRQd7?=
 =?us-ascii?Q?srXXP2zHb2TPziXh4oE/Zo/dlMWk0S9pwaxz7i6PrVGgGY05UUhPLpS3mbjq?=
 =?us-ascii?Q?ejJTpBHF7boaajwt1lOEFRaD/ws9v6D2jjbPeSw3uSVNaswFUKFnkmLMHc58?=
 =?us-ascii?Q?k5SEPumyfZ/8cmSAvQdlyOV9EGEChCsTWvIrHorQMl8VXuxWG5X1jMBSWsaT?=
 =?us-ascii?Q?YbAFTM8XLgvLluCpuFkQXhMUvPGQ8T9Z7ukN6RCv5zFiTjS5iP5CHP33fY8h?=
 =?us-ascii?Q?gurGPoTBUScbIkkYO8nMNTNaeVJUfgKWeAUFKSRhUb6VTc79eP7P54ghKtgX?=
 =?us-ascii?Q?kZdg6TXjuCGqJoPPAqYeyQFikK73w7BLkEmzztOv/dxN7F2lBrbhUpWM3z+4?=
 =?us-ascii?Q?bVuZqOmHcQa+jd/szYjf0+5uIb46udhIBpVsTdcfekfzPR2QodBGIeF9JWOI?=
 =?us-ascii?Q?32wOduGbQoycI7BBYi5gqDj2BfJSHR/W/V7uUYfk/6ktS94eNFR8FBLasChR?=
 =?us-ascii?Q?kJwjCtXqqTcrNERtYeY0h09HK8BKSXglFhu3RytYvVeauJrKI9G6QNXCl2WI?=
 =?us-ascii?Q?HQtJG+XsCC19Vs/3jRIQ41Rc12AE3Nej3K1r14ZslHxQVuqn4zO3Xzjmit7O?=
 =?us-ascii?Q?1/j8PY55h1uYInchkw5wUNhbF+e8Ry+9K+n4KbHGXHiqETR3tqkSukPWXFLL?=
 =?us-ascii?Q?gFWGoylG37t8fjPtlCPQkBtLn9iiUy0b3AZ2T0OXAyPFKsJOBPmeLQHGsGvZ?=
 =?us-ascii?Q?vgDiDQwuMKm6hM4xbj1BjvtEgPvk8eYvSabLCKsjITyHgqviH+MAU4CS6V5z?=
 =?us-ascii?Q?acCx/HiHDXi2Iwfn/j4NfH6T5Q2yV5xSSqoJBpwKv8sSg7nGE2YVmay0cklk?=
 =?us-ascii?Q?voCXbgfgFCiWz5y2UOn1sMc0mGSdr/rP6gLqEYSf+f3lNIly0UegOg/mxEZb?=
 =?us-ascii?Q?xa7bkCBSlzQTLP+txLZi2UY2jfSGOseiUEliGwGFy4Pedod2z/96XJh3/cv2?=
 =?us-ascii?Q?+nCcxLimc3IGVTz2pkNII7wL?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 496984e0-cea8-41e4-dcb5-08d95510eafc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2021 17:22:20.1018
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HZ7Y2LD/kEklSfNFHpH0XSZHTBYIGIAmE8Vq78tJc3yW3XBga7M8/gQZ8v3vnYl4sAEY4iTN7l5KqiWqVFvsLk4M6cgLY8q3Nk1myh2oh6o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5449
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10062 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=728 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108010125
X-Proofpoint-GUID: ZzEf-Ks5h_MoMjog4tNTSUsid8L7jz0-
X-Proofpoint-ORIG-GUID: ZzEf-Ks5h_MoMjog4tNTSUsid8L7jz0-
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christoph,

> this series contains two small fixes for commands without data
> transfer for the recent bsg changes.

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
