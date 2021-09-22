Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22D77C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 04:45:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A5CD61268
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 04:45:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232050AbhIVErX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Sep 2021 00:47:23 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:25540 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231826AbhIVErO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Sep 2021 00:47:14 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18M22UF8013621;
        Wed, 22 Sep 2021 04:45:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=8DZIIO5Y2YQfsmM6Opyb+5/NdnyH/nAYrHGJ/M1Pi+M=;
 b=Wn97MIavzQHw6H2mQDRgZoTfIEAF8aS23Lsd4XbtJjxvyP0XYWA3WrKnv2fM9TBJurSb
 N/YCRumrb4OfjpPsNX0WDOfDPzuBBw0Mj9fq4IlszGlyI/TdbXNVDIO0OvCRKWQDYDLT
 QaLEEHry45BZ4xV33iIyJu+iMwpkxXURsHA/fsKUxeLRUnx0bleBKsrVndk6OlVW0KSl
 cfaR5gk2BvOVBo+mqsHhAwTf22Ce4S9GMi5Fd6DZ/1UXy6bDL6xSyIjSQC+5EsEQwhNk
 OBpJ+iOt/Gt7twz9YeETsSI2PmSLGF4bIFsZsybzXZPKKPySnc+r0nmzvH0VK+OT1N/y xQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b7q4s1b66-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 04:45:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18M4imvI117636;
        Wed, 22 Sep 2021 04:45:38 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by aserp3020.oracle.com with ESMTP id 3b7q5a3ry1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 04:45:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oSJJzkWWzUYdIn4CdFh6Kbcg9rAMs1tQUWzFmtylxWTBqKZgsAc9TDNtu2qGs5J34c+RwpXykBnKfOUVA7J1iAseqkF6okkXCYvJum0N6bEdQ7HCeZGdtsH71qrhqXZhKhNZ1vGHCbnJPeKKXWQm75P6YVqRHWr6cCXWuf3/u01Eyk1kX0do5p87n5MtwpnFOt2ExpnCUlR93mLVffdbj2iLCHy2dFd1QQueh56lJ47lSQ/Y/tzvK9xj5FUih7r+kg4fh01j0eOO+gjOsYBM9y++Lo8A1/z4AtJgKh3nXl/nN6j1hZwnKHCu87uoQ3jCkh5gZgQ/fp5F48miR6sf9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=8DZIIO5Y2YQfsmM6Opyb+5/NdnyH/nAYrHGJ/M1Pi+M=;
 b=oeaOCnW09YMy6OIDxRLvmrBkfNk6NzAXpT6zU8KJ5BLXe4rHiXn0zce8l6pxaab12DmdEQ//VN9Fo+5+6k08dasavqiTn/59Dg3MtpOoDdhNk0ZK4eZic1BmzxOD9zgPo2A14xCb1++x3nsJeFcCjyhzsQP36ud8LU1+jHXUDaAm5Cq9hpLZ95KvUHkwMxKayWyukq3AUSxF5h4u9FXEcEeEijjgvMDY9cMfjTRw1nyP66L/HTS26Kuwc7VW6AaF4N6lfV3h2DyRnABRRoYs7rF8PFlLBoe5VqOaMc70mRkRIdWUAijfho6u1GG7R7iklt6mS/ZXDRSI3ohLtTGHPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8DZIIO5Y2YQfsmM6Opyb+5/NdnyH/nAYrHGJ/M1Pi+M=;
 b=TEkGXgM6fLkU/E/Q+G65/TyM2smkhs7cum3m0RAptOWgULb21GjMdx9AbfEZaAu+7m2a/Z8LwLkgKsL4ALy8zQqNu8xsXW2ds9dLTegjSzaPDdKkar6t41CFMm817wElcYVL9JA7Yr3jGo3aU0lKteB6wMazZnUMorUCeWQ56vk=
Authentication-Results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4456.namprd10.prod.outlook.com (2603:10b6:510:43::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Wed, 22 Sep
 2021 04:45:30 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 04:45:30 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     bvanassche@acm.org, ALIM AKHTAR <alim.akhtar@samsung.com>,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        Keoseong Park <keosung.park@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>, huobean@gmail.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: ufshpb: Use proper power management API
Date:   Wed, 22 Sep 2021 00:45:15 -0400
Message-Id: <163228527480.25516.4457982420650944437.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210902003534epcms2p1937a0f0eeb48a441cb69f5ef13ff8430@epcms2p1>
References: <CGME20210902003534epcms2p1937a0f0eeb48a441cb69f5ef13ff8430@epcms2p1> <20210902003534epcms2p1937a0f0eeb48a441cb69f5ef13ff8430@epcms2p1>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR11CA0154.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::9) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA0PR11CA0154.namprd11.prod.outlook.com (2603:10b6:806:1bb::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Wed, 22 Sep 2021 04:45:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f3b92b2d-7527-4ce4-0407-08d97d83ce45
X-MS-TrafficTypeDiagnostic: PH0PR10MB4456:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB44564644BAB6C0B12943D9C88EA29@PH0PR10MB4456.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:272;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lbuauq2KXOUW4alWUUPtpyw5PaRf3Eu/2lJ1hsrGJFsXDv4sZKMbiwbVSIC7GI5+JjcWTWYWHn5aq6wzmzSBrp7SyRRRZA36dQR4s2YfHgX+hBSb+CAREeCysr1xFhmhf2+9mXgkaZLIOnvallrfXQ/6DttpHR9GoBYLNemHRykggft4xFEAVSyskpuoX+WB0H2tu5ul89m/KlgyxbnXvFp5Zkward4FxQHGXySU3zVb7zHGdZodJ1Qj0OmMc1rZbbKbjT2FUJnq83GR7CLzTiVh+ah6KVFyPIh40Cval4DlzqU2zP84JqYWzFcXq/g+0/LE17ABv7ABT9pPO7twHRCDSDOmVBqVPZaW5XZx7sYUeUjVLkToPYGMKEbNBZ9W+ahjKJS/zbhH49ylVirdNXOOD5aPRNQpwitmqvaWChI8KuTndVYrNQEfoDgdwXjuY4DSD7P2npxRCUK4BiFzHSut+ZUc+uFEm6Pz8jUTNotshj9SRZAhMy5Kgei6s9WZhW7zbyGXuPaA9TAvB3LHUI8MxWqLsJk9VicZ4EQVuGWAJw6Uft9a+tflb0RP5fwia+NwHLliMwSy4RMPgPOm2b4PWH12JDIQ4DNNJ/RWvGZfFjuz2YU4B52yLkdcepvBaNiIx8FIBAvOIJhBRl540By89I7iTs4rn8qqKqFTSmF/1HWqtGptipQPyMltGbAKXRmupTphfneeQN9Vco8wIKsRZaf5eSqPITldwdhOmyw3n5o978+5F7vN6F1l+fn7MydCkmMN0XBrWngA2RcAwA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(966005)(36756003)(86362001)(2616005)(4326008)(508600001)(2906002)(8676002)(6666004)(66476007)(38100700002)(26005)(52116002)(103116003)(66556008)(5660300002)(66946007)(7696005)(6486002)(4744005)(186003)(38350700002)(8936002)(110136005)(316002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QnF1akZwSmJqZHlKTEI3RGJaNWdiUUVCeW04ZzRndmQwTU9ac1d1dmF1TlBy?=
 =?utf-8?B?WEVGNzBVdStnTzhiT0FDWXFhT2J2OHJoYVRGL1VDTUZFdFNqL2YvRU1DU2F3?=
 =?utf-8?B?cDBtaklYNm0weGwvUXhsVUJTREV6cjQyQkJaVTgzMTc3THlKa2EwVTRYWjNV?=
 =?utf-8?B?by9zQktTQy85OHVMSmh3R1NsaTJ0WVlrR0pGNDhKRDkvZ0lJVU5QaGJWRXF4?=
 =?utf-8?B?ajRieVlEM1k5L3huaGhxRXVhNFl5Y3FzV05nSGc0UzdrZk82bmJPWU8wc3Fs?=
 =?utf-8?B?YTlCaXVvRkVzKzV5T3pIaWVLaTV6RWYzSkpwbnRoQTIyWkZIT2ZiMUVPeFI0?=
 =?utf-8?B?KzJwTzdSSmdYdjdZUzB0bUFiQzI2UDI1WklnMVVmSHoxMzJQbTNOV1MzbFdK?=
 =?utf-8?B?VWQrcnNpeVdHZHJZSlR0YkgyajVWM1JFNFgxQ1VCb2tib2hTZEtQMk1rNWZz?=
 =?utf-8?B?YmVpL1YycnIwai9QZDcyYjdvcVJKR090UUxsWlpiQjd0SUV6ZFBMV01XYVk5?=
 =?utf-8?B?Y2JjLzZlSGh2YjRnZm5TVGFrbkNoUnVIZWFoMm1EeWJrcHlnNzZGWGgxRFh4?=
 =?utf-8?B?ejNMeTlkUWQyNzREMHNBb0R0RklPNzV2V2c3RWpKVVdtSjZST1VZc2xEZUl5?=
 =?utf-8?B?YWdlYnpycnkySWpJdjJIYkNMcVZNVzNpT2U5YzdRWDBkd1puNHZZMjYrYzhH?=
 =?utf-8?B?VFZIQlZlOUFiNXdwTTlRRXFCSG9wcm91SXQ5c1Y1OHNkYm1FZjlkNldtYXN5?=
 =?utf-8?B?emd3eUdsdHlFL2JWRm5XK0RMRy9HRTRDUDlRVzV4U1VaTkZhOVhGeFFkNms5?=
 =?utf-8?B?SGpkRkh1M0ZOUitNQ0wrOUlLblMrSVBDVjVFQ0E0SVZtZmNITDZRTzdVUXlO?=
 =?utf-8?B?bHU1elVQWGVCVzNoZldra29jNXpUMUYzQkdGaGJCb2c5cmkxMFJlc0trZkhL?=
 =?utf-8?B?NDRDM3c3UWM4d2VoOStLQ2p3bVRONHpFODVPZUI2My9Ib1NvbEVQaXVBQnZZ?=
 =?utf-8?B?NVpCdlIvT2UxTnFDUHZpWnRMWlU5ZCs4NGV5WjFvT2FJWTdCRDd3MFdVQy9r?=
 =?utf-8?B?N0pVc092ZmpzOXNlR2xOc0Z0OTZKYzVyaUhMYjFOc2dQWjBnYWFEaENwblNN?=
 =?utf-8?B?ZmY3SlIwaXlPckx1RitXNmlBSzU0d002Rmt1eG5Wc0E3Z2JIM1RKOXkrQXF5?=
 =?utf-8?B?OWFaR0RTUnJUam4zcUc3RDVXMDE4cUxDRzQ4a0NLc0V6VlRzeTZtQ2krMjZL?=
 =?utf-8?B?dmNkTkI0RW91alNqSVFSUTZiRHU3MUFPalBJT2wxK25Day9BZUpQZTNvcWdL?=
 =?utf-8?B?RUJETUlzUHNwaEFiQlNpQldmUk82ZDVzVVRNdjZRZ1B5TXJMNUN2U1g2eEJC?=
 =?utf-8?B?WlVyOEQxajhmUWNBaEhYZzMxaHBGQzlRb1Jpdkx3TVl6NnEyNHpDWWlHUXcz?=
 =?utf-8?B?SVhCQmRRTEZrYlZiaVJHSEtTWmZMelBIWS94WU1aNFB3d2RuZVdpTTZpdEwz?=
 =?utf-8?B?RExOMkZRelJoN0xEZ1NNNHZnRjE4dGhha3FxTEt0QS9yaTJRRytydDUrNlpK?=
 =?utf-8?B?Zk83d2ZiQWFKYjJ5U2ZVUDdtRzVvU0xXZUR1NXltTzEvN2d6NVdBUzBkVWQ3?=
 =?utf-8?B?RHVsQk1hcHczNFdaeXczem4xRDI3Q05TeE5qTWtnMS9rcTFKNTZUTENhbXFX?=
 =?utf-8?B?djgrOXh3dkpPNHB6aFpFZU8rVzJwZG9zbWIxS256bWJFQTI2cmFpK1pVMkQ4?=
 =?utf-8?Q?5j1aZ1mh++8hP7MIeQ1Hy8mHNa+egIOmj7UKC9y?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3b92b2d-7527-4ce4-0407-08d97d83ce45
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 04:45:30.6046
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z5WGZJiBL+EYgbC4tyfPlH1gTrF6nOVRsvkwkK0+CWbIsMvEXSZJYFl2Z/R5PLIp4y35sqa4gGyoO9+kpLG7sNBkZeCWNrrJX9u1zOabGXU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4456
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10114 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 phishscore=0 mlxlogscore=744 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109200000 definitions=main-2109220030
X-Proofpoint-GUID: 0WOG-eLOA5OO17a3DNa3Fq7qA__SbpXk
X-Proofpoint-ORIG-GUID: 0WOG-eLOA5OO17a3DNa3Fq7qA__SbpXk
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 02 Sep 2021 09:35:34 +0900, Daejun Park wrote:

> In ufshpb, pm_runtime_{get,put}_sync() are used to avoid unwanted runtime
> suspend during query requests. In commit b294ff3e3449 ("scsi: ufs: core:
> Enable power management for wlun") has been modified to use
> ufshcd_rpm_{get,put}_sync() APIs.
> 
> This patch has been modified to use these APIs in HPB module.
> 
> [...]

Applied to 5.16/scsi-queue, thanks!

[1/1] scsi: ufs: ufshpb: Use proper power management API
      https://git.kernel.org/mkp/scsi/c/351b3a849ac7

-- 
Martin K. Petersen	Oracle Linux Engineering
